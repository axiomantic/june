"""Emit a Nim subclass for every abstract JUCE class in a bound module.

A JUCE class with a pure virtual cannot be instantiated at all, so one that has
no C++ subclass is unreachable from Nim however completely its methods are
bound. defineCppClassInternal generates that subclass, with a std::function per
override, so this walks the module for abstract classes and writes the macro
invocation for each.

The output is included from the module's _lifting file. Run it the same way as
inspect_juce.py; see the README.
"""
import os
import subprocess
import sys

import clang.cindex
from clang.cindex import AccessSpecifier, CursorKind, TypeKind

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from inspect_juce import use_system_libclang

modules = ("juce_core", "juce_events", "juce_data_structures",
           "juce_graphics", "juce_gui_basics")

def inside_platform_guard(cursor):
    """Whether the class sits inside a JUCE platform #if.

    The generator runs on one platform, so a class JUCE declares only on macOS
    or Windows would be emitted and then fail to compile everywhere else - the
    subclass names a base that does not exist there. The preprocessor has
    already resolved the condition by the time libclang reports the cursor, so
    the guard is found by reading the declaring header.
    """
    location = cursor.location
    if location.file is None:
        return False
    try:
        with open(location.file.name) as handle:
            lines = handle.readlines()
    except OSError:
        return False

    platform_macros = ("JUCE_MAC", "JUCE_WINDOWS", "JUCE_LINUX", "JUCE_IOS",
                       "JUCE_ANDROID", "JUCE_BSD", "JUCE_WASM")
    depth, guarded = 0, 0
    for number, text in enumerate(lines[:location.line], start=1):
        stripped = text.strip()
        if stripped.startswith("#if"):
            depth += 1
            if any(macro in stripped for macro in platform_macros):
                guarded = depth
        elif stripped.startswith("#endif"):
            if guarded == depth:
                guarded = 0
            depth = max(0, depth - 1)
    return guarded > 0


def hand_written_subclasses():
    """Parents and type names the _lifting files already define a subclass for.

    Read rather than listed: a hand-written subclass carries extra
    constructors, named setters or a cppParent the generated form knows nothing
    about, and a list maintained by hand goes stale the first time one is added.
    The generated type name is checked too, because CustomLookAndFeel is
    written against LookAndFeel_V4 while the abstract base is LookAndFeel, and
    the two would collide under one name.
    """
    import glob
    import re

    parents, names = set(), set()
    for path in glob.glob(os.path.join("sources", "june", "*_lifting.nim")):
        with open(path) as handle:
            for match in re.finditer(r"defineCppClassInternal (\w+) of (\w+)",
                                     handle.read()):
                names.add(match.group(1))
                parents.add(match.group(2))
    return parents, names

# std:: classes the bindings wrap under a different name.
std_class_names = {
    "std::exception": "CppException", "exception": "CppException",
    "std::string": "CppString", "string": "CppString",
    "std::type_index": "CppTypeIndex", "std::byte": "CppByte",
}

def canonical_std_name(name):
    """`exception` -> `std::exception`. libclang drops the namespace where the
    declaration is reached through a using-directive."""
    return name if name.startswith("std::") else f"std::{name}"


primitive_map = {
    "void": "", "bool": "bool", "int": "cint", "unsigned int": "cuint",
    "float": "cfloat", "double": "cdouble", "char": "cchar",
    "short": "cshort", "long": "clong", "long long": "clonglong",
    "unsigned char": "cuchar", "unsigned short": "cushort",
    "unsigned long": "culong", "unsigned long long": "culonglong",
    "size_t": "csize_t", "int64": "int64", "uint32": "uint32",
    "int32": "cint", "uint8": "uint8", "uint16": "uint16", "int8": "int8",
    "juce::int64": "int64", "juce::uint32": "uint32", "juce::int32": "cint",
    "juce::uint8": "uint8", "juce::uint16": "uint16", "juce::int8": "int8",
    "std::size_t": "csize_t",
    # The <cstdint> spellings, which libclang uses wherever the header does.
    "int8_t": "int8", "uint8_t": "uint8", "int16_t": "int16",
    "uint16_t": "uint16", "int32_t": "cint", "uint32_t": "uint32",
    "int64_t": "int64", "uint64_t": "uint64",
}

# name -> what it stands for, for typedefs reached where no declaration cursor
# is to hand, such as a template argument known only by its spelling.
typedef_names = {}


def strip_namespace(name):
    """`juce::Foo::Bar` -> `Foo::Bar`. The bindings drop the juce namespace."""
    for prefix in ("juce::", "const juce::"):
        if name.startswith(prefix):
            name = name[len(prefix):]
    return name


def type_declaration(clang_type):
    """The declaration a type ultimately names.

    A pointer or reference declares nothing itself, so its pointee has to be
    followed or a nested class arrives with only its unqualified spelling and
    cannot be matched against the flattened Nim name.
    """
    seen = clang_type
    for _ in range(4):
        declaration = seen.get_declaration()
        if declaration is not None and declaration.spelling:
            return declaration
        pointee = seen.get_pointee()
        if pointee is None or pointee.spelling == seen.spelling:
            break
        seen = pointee
    return clang_type.get_declaration()


# Nim keywords that turn up as C++ parameter names. A parameter called `type`
# is a syntax error rather than a bad name, so it is quoted.
nim_keywords = {
    "addr", "and", "as", "asm", "bind", "block", "break", "case", "cast",
    "concept", "const", "continue", "converter", "defer", "discard", "distinct",
    "div", "do", "elif", "else", "end", "enum", "except", "export", "finally",
    "for", "from", "func", "if", "import", "in", "include", "interface", "is",
    "isnot", "iterator", "let", "macro", "method", "mixin", "mod", "nil", "not",
    "notin", "object", "of", "or", "out", "proc", "ptr", "raise", "ref",
    "return", "shl", "shr", "static", "template", "try", "tuple", "type",
    "using", "var", "when", "while", "xor", "yield",
}


def parameter_name(spelling, index):
    """The Nim spelling of a C++ parameter name."""
    name = spelling or f"arg{index}"
    return f"`{name}`" if name in nim_keywords else name


def qualified_name(cursor):
    """`ThreadPoolJob::JobStatus` for a nested declaration.

    A type's own spelling is unqualified where the declaration is nested, and
    the bindings name a nested class by its parents joined together, so the
    parent chain has to be walked to find it.
    """
    parts = []
    while cursor is not None and cursor.kind != CursorKind.TRANSLATION_UNIT:
        if cursor.kind == CursorKind.NAMESPACE:
            break
        if cursor.spelling:
            parts.append(cursor.spelling)
        cursor = cursor.semantic_parent
    return "::".join(reversed(parts))


def nim_name(cpp_name, declared, declaration=None, aliases=None):
    """The Nim spelling of a bound class, flattening a nested name.

    A generic name with no arguments is refused. libclang spells a nested
    instantiation with the inner arguments dropped - Optional<Span<T>> arrives
    as "Optional<Span>" - and Optional[Span] is not a concrete Nim type.
    """
    declared, generic = declared
    candidates = [strip_namespace(cpp_name).strip()]
    if declaration is not None and declaration.spelling:
        candidates.append(strip_namespace(qualified_name(declaration)))
    for candidate in candidates:
        if candidate in declared:
            return None if candidate in generic else candidate
        flattened = candidate.replace("::", "")
        if flattened in declared:
            if flattened in generic:
                return None
            # The bindings join a nested name together - SourceDetails inside
            # DragAndDropTarget becomes DragAndDropTargetSourceDetails - but C++
            # still spells it with the ::. Record the pairing so the class body
            # can carry a cppTypeName line for it.
            if aliases is not None and "::" in candidate:
                aliases[flattened] = candidate
            return flattened
    return None


def map_type(type_spelling, declared, is_return, declaration=None, aliases=None):
    """The macro's spelling for a C++ parameter or return type.

    Returns None when the type has no Nim form, which withholds the class.
    """
    text = type_spelling.strip()
    bare = text.replace("const ", "").strip()

    if bare.endswith("*") and text.startswith("const "):
        # The override keeps the const to match the virtual; the callback gets a
        # mutable pointer, which the forwarder casts to.
        pointee = bare[:-1].strip()
        if pointee in ("void",):
            return "constrawptr[pointer]"
        if pointee in primitive_map and primitive_map[pointee]:
            return f"constrawptr[{primitive_map[pointee]}]"
        if pointee in std_class_names:
            nim_spelling = std_class_names[pointee]
            if aliases is not None:
                aliases[nim_spelling] = canonical_std_name(pointee)
            return f"constrawptr[{nim_spelling}]"
        name = nim_name(pointee, declared, declaration, aliases)
        return f"constrawptr[{name}]" if name else None

    if bare in ("void *", "void*"):
        return "pointer"

    if bare in std_class_names:
        nim_spelling = std_class_names[bare]
        if aliases is not None:
            aliases[nim_spelling] = canonical_std_name(bare)
        return nim_spelling

    if bare in primitive_map:
        return primitive_map[bare]

    if bare.endswith("*"):
        pointee = bare[:-1].strip()
        if pointee in primitive_map and primitive_map[pointee]:
            return f"ptr {primitive_map[pointee]}"
        name = nim_name(pointee, declared, declaration, aliases)
        return f"ptr {name}" if name else None

    if bare.endswith("&"):
        if is_return:
            # The forwarder would return the std::function's result, which is a
            # value, where the virtual promises a reference - a reference to a
            # temporary that dies with the call.
            return None
        pointee = bare[:-1].strip()
        if pointee in primitive_map:
            name = primitive_map[pointee] or None
        elif pointee.endswith(">") and "<" in pointee:
            name = map_template(pointee, declared, aliases)
        else:
            name = nim_name(pointee, declared, declaration, aliases)
        if not name:
            return None
        # A reference reaches the callback as a pointer either way: Nim hands an
        # object to a C function by pointer, so a by-value std::function
        # parameter would not match the raw proc behind the closure.
        return f"constptr[{name}]" if text.startswith("const ") else f"varref[{name}]"

    if bare.endswith(">") and "<" in bare:
        return map_template(bare, declared, aliases)

    # The declaration this type came from, before the table keyed on the bare
    # alias. typedef_names is global and JUCE names dozens of things Ptr, so
    # the table answers with whichever class was collected last: ImagePixelData
    # ::clone returns ImagePixelData::Ptr and came back as a
    # ReferenceCountedObjectPtr<DynamicObject>, which C++ rejects as an
    # override of a virtual returning ReferenceCountedObjectPtr<ImagePixelData>.
    if declaration is not None and declaration.kind in (
            CursorKind.TYPEDEF_DECL, CursorKind.TYPE_ALIAS_DECL):
        underlying = declaration.underlying_typedef_type
        if underlying is not None and underlying.spelling != type_spelling:
            resolved = map_type(underlying.spelling, declared, is_return,
                                type_declaration(underlying), aliases)
            if resolved is not None:
                return resolved

    simple = strip_namespace(bare).strip()
    if simple in typedef_names and typedef_names[simple] != bare:
        resolved = map_type(typedef_names[simple], declared, is_return,
                            aliases=aliases)
        if resolved is not None:
            return resolved

    name = nim_name(bare, declared, declaration, aliases)
    if name:
        # A return type keeps a top-level const, because an override's return
        # type has to match the virtual's exactly and JUCE declares several as
        # `const String`.
        if is_return and text.startswith("const "):
            return f"constval[{name}]"
        return name

    return None


def split_template_arguments(text):
    """`int, 2` from `Foo<int, 2>`, respecting nested angle brackets."""
    arguments, depth, current = [], 0, ""
    for character in text:
        if character == "<":
            depth += 1
        elif character == ">":
            depth -= 1
        if character == "," and depth == 0:
            arguments.append(current.strip())
            current = ""
        else:
            current += character
    if current.strip():
        arguments.append(current.strip())
    return arguments


def map_std_function(bare, declared, aliases):
    """Withheld.

    The Nim binding for std::function<void(bool)> is CppFunctionObjectN1[bool],
    and the macro renders a bracket type by substituting the head, which would
    give CppFunctionObjectN1<bool>. The two are different shapes rather than
    different names, so there is nothing for cppTypeName to pair.
    """
    return None


def map_template(bare, declared, aliases=None):
    """`Point<int>` -> `Point[cint]`, and std::unique_ptr to UniquePtr."""
    head, _, rest = bare.partition("<")
    head = strip_namespace(head).strip()
    inner = rest[:-1]

    if head in ("std::function", "function"):
        return map_std_function(bare, declared, aliases)

    template_map = {"std::unique_ptr": "UniquePtr", "unique_ptr": "UniquePtr",
                    "std::shared_ptr": "SharedPtr", "shared_ptr": "SharedPtr",
                    "std::vector": "CppVector", "vector": "CppVector",
                    "std::optional": "CppOptional", "optional": "CppOptional",
                    "std::map": "CppMap", "map": "CppMap"}
    all_names, _ = declared
    nim_head = template_map.get(head, head if head in all_names else None)
    if nim_head is None:
        return None

    mapped = []
    for argument in split_template_arguments(inner):
        piece = map_type(argument, declared, is_return=False, aliases=aliases)
        if piece is None or piece == "":
            return None
        mapped.append(piece)
    return f"{nim_head}[{', '.join(mapped)}]"


def declared_type_names():
    """Every JUCE type the bindings declare, generic ones included.

    The class templates - Point, Rectangle, Range, Array - are hand-written in
    june_juce_types rather than generated, so that file has to be read too or a
    Point<int> parameter looks unbindable.
    """
    import re

    names, generic = set(), set()
    paths = [os.path.join("sources", "june", f"{module}.nim") for module in modules]
    paths.append(os.path.join("sources", "june", "june_juce_types.nim"))
    paths.append(os.path.join("sources", "june", "june_stl.nim"))
    pattern = re.compile(r"^\s+([A-Za-z_][A-Za-z0-9_]*)\*(\[[^\]]*\])? \{\.")
    for path in paths:
        with open(path) as handle:
            for line in handle:
                match = pattern.match(line)
                if match:
                    names.add(match.group(1))
                    if match.group(2):
                        generic.add(match.group(1))
    return names, generic


def parse(module, base_path):
    args = ["-x", "c++", "-std=c++17", "-DJUCE_API=", "-DNDEBUG=1",
            "-DJUCE_GLOBAL_MODULE_SETTINGS_INCLUDED=1",
            "-DJUCE_STANDALONE_APPLICATION=1",
            f"-I{os.path.join(base_path, 'JUCE/modules')}"]
    for name in modules:
        args.append(f"-DJUCE_MODULE_AVAILABLE_{name}=1")
    if sys.platform == "darwin":
        sdk = subprocess.run(["xcrun", "--show-sdk-path"], capture_output=True,
                             text=True).stdout.strip()
        if sdk:
            args += ["-isysroot", sdk]
    unit = clang.cindex.Index.create().parse(
        f"JUCE/modules/{module}/{module}.h", args=args)
    errors = [d for d in unit.diagnostics
              if d.severity >= clang.cindex.Diagnostic.Error]
    if errors:
        for diagnostic in errors[:5]:
            print(f"error: {diagnostic.spelling}", file=sys.stderr)
        sys.exit(1)
    return unit


def collect_typedefs(unit):
    """Every typedef in the module, by name.

    A template argument arrives as a bare spelling with no declaration cursor
    behind it - Array<CommandID> - so the only way to learn that CommandID is
    an int is to have recorded it while walking.
    """

    def walk(cursor):
        for child in cursor.get_children():
            if child.kind in (CursorKind.TYPEDEF_DECL, CursorKind.TYPE_ALIAS_DECL):
                underlying = child.underlying_typedef_type
                if underlying is not None and underlying.spelling != child.spelling:
                    typedef_names.setdefault(child.spelling, underlying.spelling)
            walk(child)

    walk(unit.cursor)


def abstract_classes(unit):
    found = {}

    def walk(cursor):
        for child in cursor.get_children():
            if (child.kind in (CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL)
                    and child.is_definition()):
                try:
                    is_abstract = child.is_abstract_record()
                except AttributeError:
                    is_abstract = False
                # Keyed on the flattened name the bindings use, not on the
                # class's own spelling. main() filters against the declared Nim
                # names, so a nested class keyed as `Listener` never matched one
                # and was dropped with no withheld entry - and every class named
                # Listener collapsed onto a single key besides. 58 abstract
                # classes were skipped that way, most of them the Listener and
                # LookAndFeelMethods interfaces an application implements.
                flattened = strip_namespace(qualified_name(child)).replace("::", "")
                if is_abstract and flattened not in found:
                    found[flattened] = child
            walk(child)

    walk(unit.cursor)
    return found


def pure_virtuals(cursor):
    """The pure virtuals a subclass has to implement to be constructible.

    Inherited ones count. A class can be abstract without declaring a pure
    virtual of its own - juce::DrawableShape is abstract because it leaves one
    of Drawable's unimplemented - and a subclass that overrides only what the
    class itself declares is still abstract, so `new` fails on it.

    A private one cannot be overridden from a generated subclass, so a class
    with one is withheld rather than emitted broken.
    """
    result, private, seen, implemented = [], False, set(), set()

    def signature(member):
        # The name alone is not the identity of a virtual. ComponentListener
        # declares a non-pure componentMovedOrResized(Component&, bool, bool)
        # and ComponentMovementWatcher a pure componentMovedOrResized(bool,
        # bool); they are different virtuals, and keying on the name let the
        # first mark the second implemented. The subclass then overrode one of
        # three pure virtuals and was still abstract, which C++ only reports
        # where something tries to build it.
        return (member.spelling,
                tuple(argument.type.spelling
                      for argument in member.get_arguments()),
                member.is_const_method())

    def walk(class_cursor, depth=0):
        nonlocal private
        if depth > 8:
            return
        for member in class_cursor.get_children():
            if member.kind == CursorKind.CXX_BASE_SPECIFIER:
                base = member.type.get_declaration()
                if base is not None and base.is_definition():
                    walk(base, depth + 1)
                continue
            if member.kind != CursorKind.CXX_METHOD:
                continue
            if not member.is_virtual_method():
                continue
            key = signature(member)
            if member.is_pure_virtual_method():
                if member.access_specifier == AccessSpecifier.PRIVATE:
                    private = True
                elif key not in seen and key not in implemented:
                    seen.add(key)
                    result.append(member)
            else:
                # A base's pure virtual that this class already implements.
                implemented.add(key)

    walk(cursor)
    return [m for m in result if signature(m) not in implemented], private


def map_constructor_type(clang_type, declared):
    """The Nim spelling of a constructor parameter.

    Not the same as an override's parameter. constptr and varref are markers the
    defineCppClassInternal macro understands; a plain proc signature needs the
    ordinary binding spelling, which is how the generated modules already write
    a const reference - `makeFile(absolutePath: String)` for `const File&`.
    """
    text = clang_type.spelling.strip()
    bare = text.replace("const ", "").strip()
    if bare in ("void *", "void*"):
        return "pointer"
    if bare in primitive_map:
        return primitive_map[bare] or None
    if bare.endswith("&"):
        inner = bare[:-1].strip()
        if inner in primitive_map:
            return primitive_map[inner] or None
        if inner.endswith(">") and "<" in inner:
            return map_template(inner, declared)
        return nim_name(inner, declared, type_declaration(clang_type))
    if bare.endswith("*"):
        pointee = bare[:-1].strip()
        if pointee in primitive_map and primitive_map[pointee]:
            return f"ptr {primitive_map[pointee]}"
        name = nim_name(pointee, declared, type_declaration(clang_type))
        return f"ptr {name}" if name else None
    if bare.endswith(">") and "<" in bare:
        return map_template(bare, declared)
    return nim_name(bare, declared, type_declaration(clang_type))


def handler_type(mapped):
    """The Nim type a handler proc declares for a mapped parameter.

    The markers are only meaningful inside the macro; a setter is an ordinary
    proc, so each one has to be written as the type the callback actually
    receives. constrawptr[pointer] is already `pointer` and takes no second ptr.
    """
    for marker in ("constptr[", "varref["):
        if mapped.startswith(marker):
            return "ptr " + mapped[len(marker):-1]
    if mapped.startswith("constval["):
        return mapped[len("constval["):-1]
    if mapped.startswith("basescalar["):
        # The callback returns the base scalar, never the distinct enum.
        return "cint"
    if mapped.startswith("constrawptr["):
        inner = mapped[len("constrawptr["):-1]
        return inner if inner == "pointer" else f"ptr {inner}"
    return mapped


def base_constructors(cursor, declared):
    """Signatures for the generated class's constructors.

    A copy or move constructor is skipped: the generated class forwards to it,
    but a Nim caller reaches copying through the ordinary value semantics.
    Returns None when a constructor cannot be spelled, which withholds the
    class rather than emitting one that fails only once it is called.
    """
    signatures, found_any = [], False
    for member in cursor.get_children():
        if member.kind != CursorKind.CONSTRUCTOR:
            continue
        if member.access_specifier == AccessSpecifier.PRIVATE:
            continue
        if member.is_copy_constructor() or member.is_move_constructor():
            continue
        found_any = True
        arguments = []
        for index, argument in enumerate(member.get_arguments()):
            mapped = map_constructor_type(argument.type, declared)
            if mapped is None or mapped == "":
                return None
            arguments.append(
                f"{parameter_name(argument.spelling, index)}: {mapped}")
        signatures.append((", ".join(arguments), len(arguments)))

    if not found_any:
        # No declared constructor at all means the implicit default one.
        return [("", 0)]
    # Deduplicate on the rendered signature; defaulted arguments make libclang
    # report shapes that collapse to the same Nim proc.
    seen, unique = set(), []
    for signature, count in signatures:
        if signature in seen:
            continue
        seen.add(signature)
        unique.append((signature, count))
    return unique


# Classes whose generated form does not compile, with the reason each was
# measured. Nothing in the headers predicts one: the failure shows only when
# the generated std::function is assigned, so an entry here is a record of a
# compile that was actually attempted.
#
# Empty. The one entry it held was TreeView::LookAndFeelMethods, whose
# drawTreeviewPlusMinusBox takes a Colour by value; `inheritable` made Nim hand
# every object over as a pointer, so the closure's C signature said Colour*
# where the std::function said Colour. Colour is marked bycopy now.
unsupported_subclasses = {
}


def render_class(cursor, module, declared):
    """The macro invocation for one class, or a reason it was withheld.

    The macro derives the C++ parent as juce::<the Nim name>. That is right for
    a top-level class and wrong for a nested one, whose Nim name is the parts
    joined together - it would name a juce::FlattenedName that does not exist.
    A nested class therefore carries a cppParent directive giving the real
    qualified spelling, the same way the hand-written CustomSliderListener
    does.

    This used to say no abstract class in these modules was nested. 58 of them
    are: the Listener and LookAndFeelMethods interfaces an application
    implements, ComponentBuilder::TypeHandler, TextEditor::InputFilter and the
    rest. They were invisible because abstract_classes keyed them on their own
    spelling, which never matched a declared Nim name.
    """
    qualified = strip_namespace(qualified_name(cursor))
    name = qualified.replace("::", "")
    if name in unsupported_subclasses:
        return None, unsupported_subclasses[name]
    methods, has_private = pure_virtuals(cursor)
    if has_private:
        return None, "a pure virtual is private, so no subclass can implement it"
    if not methods:
        return None, "abstract with no overridable pure virtual"

    aliases = {}
    lines = [f"defineCppClassInternal Custom{name} of {name}:",
             f'    include "{module}/{module}.h"']
    if "::" in qualified:
        lines.append(f'    cppParent "juce::{qualified}"')

    setters = []
    seen = set()
    for method in methods:
        if method.spelling in seen:
            return None, f"{method.spelling} is overloaded, which one handler cannot express"
        seen.add(method.spelling)

        # Nim's importcpp substitutes a type by a single digit, so a
        # std::function can name at most ten of them: '0 to '9. A void
        # override therefore carries ten arguments and one with a result nine,
        # and JUCE has six virtuals past that - drawFileBrowserRow takes
        # twelve. There is no spelling for those.
        # Nim builds a temporary for a closure's result, so a handler cannot
        # return a type C++ cannot value-initialise. juce::Justification is
        # one: it declares constructors and no default, and
        # getSidePanelTitleJustification returns it.
        returned = method.result_type.get_canonical().get_declaration()
        if returned is not None and returned.kind in (
                CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL) and returned.is_definition():
            constructors = [c for c in returned.get_children()
                            if c.kind == CursorKind.CONSTRUCTOR]
            has_default = any(len(list(c.get_arguments())) == 0
                              and c.access_specifier == AccessSpecifier.PUBLIC
                              for c in constructors)
            if constructors and not has_default:
                return None, (f"{method.spelling} returns {returned.spelling}, "
                              f"which has no default constructor, and Nim builds "
                              f"a temporary for a closure's result")

        argument_count = len(list(method.get_arguments()))
        limit = 10 if method.result_type.spelling == "void" else 9
        if argument_count > limit:
            return None, (f"{method.spelling} takes {argument_count} arguments, "
                          f"and a std::function Nim can spell carries at most "
                          f"{limit} here")

        arguments, handler_args, handler_types = [], [], []
        for index, argument in enumerate(method.get_arguments()):
            mapped = map_type(argument.type.spelling, declared, is_return=False,
                              declaration=type_declaration(argument.type),
                              aliases=aliases)
            if mapped is None:
                return None, f"{argument.type.spelling} in {method.spelling} has no Nim spelling"
            argument_name = parameter_name(argument.spelling, index)
            arguments.append(f"{argument_name}: {mapped}")
            handler_types.append(handler_type(mapped))
            handler_args.append(f"{argument_name}: {handler_types[-1]}")

        returns = map_type(method.result_type.spelling, declared, is_return=True,
                           declaration=type_declaration(method.result_type),
                           aliases=aliases)
        if returns is None:
            return None, f"{method.result_type.spelling} returned by {method.spelling} has no Nim spelling"

        # Every bound JUCE enum is a `distinct cint`, and Nim renders one
        # closure struct for `proc(): cint` and `proc(): SomeEnum`, typing its
        # function-pointer field from whichever it emits first. A program that
        # sets one handler of each kind then assigns a pointer of the wrong
        # type. basescalar keeps the distinct out of the closure: the callback
        # returns the base scalar and the forwarder casts.
        if returns and method.result_type.get_canonical().kind == TypeKind.ENUM:
            returns = f"basescalar[{returns}]"

        signature = ", ".join(arguments)
        suffix = f": {returns}" if returns else ""
        pragma = " {.cppconst.}" if method.is_const_method() else ""
        lines.append(f"    proc {method.spelling}({signature}){suffix}{pragma} = discard")

        handler = ", ".join(handler_args)
        field = "on" + method.spelling[0].upper() + method.spelling[1:]
        handler_returns = handler_type(returns) if returns else ""
        setters.append(
            f"proc set{method.spelling[0].upper()}{method.spelling[1:]}Handler*("
            f"this: var Custom{name}, handler: proc({handler})"
            f"{(': ' + handler_returns) if handler_returns else ''} "
            "{.closure.}) =\n"
            f"    this.{field} = bindClosure(handler)")

    for nim_spelling, cpp_spelling in sorted(aliases.items()):
        lines.insert(2, f'    cppTypeName {nim_spelling}, "{cpp_spelling}"')

    lines.append("")

    # One constructor per constructor of the base. The generated class forwards
    # its arguments, so a no-argument form only compiles where the base has a
    # default constructor - juce::Thread takes a name and has none, and emitting
    # `new june::CustomThread` for it produces a class that builds only while
    # nothing constructs one.
    constructors = base_constructors(cursor, declared)
    if constructors is None:
        return None, "a constructor of the base has no Nim spelling"
    for signature, forwarded in constructors:
        arguments = f"({signature})" if signature else "()"
        call = "(@)" if signature else ""
        lines.append(f'proc newCustom{name}*{arguments}: ptr Custom{name} '
                     f'{{.importcpp: "(new june::Custom{name}{call})".}}')
    lines.append("")
    lines.extend(setter + "\n" for setter in setters)
    return "\n".join(lines), None


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Emit Nim subclasses for abstract JUCE classes")
    parser.add_argument("--module", required=True, choices=modules)
    options = parser.parse_args()

    use_system_libclang()
    base_path = os.getcwd()
    declared = declared_type_names()
    all_names = declared[0]
    hand_parents, hand_names = hand_written_subclasses()
    unit = parse(options.module, base_path)
    collect_typedefs(unit)

    emitted, withheld = [], []
    for name, cursor in sorted(abstract_classes(unit).items()):
        if (name in hand_parents or f"Custom{name}" in hand_names
                or name not in all_names):
            continue
        # Declared in another module, which emits it in its own file.
        location = cursor.location.file.name if cursor.location.file else ""
        if f"/{options.module}/" not in location:
            continue
        if inside_platform_guard(cursor):
            withheld.append((name, "declared only on some platforms"))
            continue
        rendered, reason = render_class(cursor, options.module, declared)
        if rendered is None:
            withheld.append((name, reason))
        else:
            emitted.append(rendered)

    # The project's copyright notice. A generated file is still a file in
    # this repository, and carries it like every other.
    print('#\xa0June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray')
    print('#')
    print('#\xa0Licensed and distributed under the')
    print('#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).')
    print('#')
    print('# This file may not be copied, modified, or distributed except according to those terms.')
    print()
    print("# Generated by tools/generate_subclasses.py. Do not edit.")
    print("#")
    print("# A JUCE class with a pure virtual cannot be constructed, so one with no")
    print("# C++ subclass is unreachable from Nim however completely its methods are")
    print("# bound. Each of these is that subclass: a std::function per override, set")
    print("# through the matching handler setter.")
    print()
    for rendered in emitted:
        print(rendered)
    if withheld:
        print("# Withheld, with the reason:")
        for name, reason in withheld:
            print(f"#   {name}: {reason}")


if __name__ == "__main__":
    main()

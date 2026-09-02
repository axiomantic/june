import sys
import os
import subprocess
from collections import Counter

import clang.cindex
import argparse
import glob
import re
from clang.cindex import TypeKind

from clang_base_enumerations import CursorKind, AccessSpecifier

#==================================================================================================

nim_enum_def = """  {enum_name}* {{.header: {juce_module_name}, importcpp: "{spelling}".}} = distinct cint"""

nim_dollar_def = """proc `$`*(this: {class_name}): string = $this.toString()"""

nim_no_equality_def = """proc `==`*(this: {class_name}, other: {class_name}): bool {{.error: "{spelling} defines no operator==; compare a property instead".}}"""

nim_enum_constant_def = """let {constant_name}* {{.header: {juce_module_name}, importcpp: "{spelling}".}}: {enum_name}"""

nim_type_def = """type
{classes}
"""

nim_prolog_def = """import june_common

const {juce_module_name} = "{juce_module_prefix}{juce_module_path}"
"""

nim_suffix_def = """

include {juce_module_name}_lifting
"""

# inheritable lifts Nim's refusal to write `object of X`; pure stops it adding
# an RTTI field to the layout. Without pure, Nim value-initialises these as
# {(&NTIv2_...)}, and C++ rejects it: JUCE's classes have no such member.
nim_class_def = """  {class_name}{export} {{.header: {juce_module_name}, importcpp: "{spelling}", inheritable, pure.}} = object{base}"""

nim_template_def = """{comment}proc {function_name}*[{generics}]({function_args}){function_return} {{.header: {juce_module_name}, importcpp: "juce::{juce_spelling}(@)".}}{reason}"""

nim_function_def = """{comment}proc {function_name}*({function_args}){function_return} {{.header: {juce_module_name}, importcpp: "juce::{juce_spelling}({juce_args})".}}{reason}"""

# Free functions the _lifting files already bind, which would otherwise be
# emitted a second time under the same name.
free_functions_bound_by_lifting = {"initialiseJuce_GUI", "shutdownJuce_GUI"}

# A conversion operator. Bound as an explicit to<Type> rather than a Nim
# converter: an implicit one competes with every other overload and makes calls
# ambiguous, which is the failure this binding has hit repeatedly with strings.
# static_cast names the target, so it picks the operator without relying on how
# the class spells it.
nim_conversion_def = """{comment}proc to{target}*(this: {class_name}): {nim_type} {{.header: {juce_module_name}, importcpp: "static_cast<{cpp_type}>(#)".}}{reason}"""


def conversion_target_name(nim_type):
    """The to<Type> suffix for a conversion operator's result."""
    bare = nim_type.replace("ptr ", "").replace("var ", "").strip()
    # cint reads better as toInt than as toCint, and the c-prefixed names are
    # the only ones where the Nim spelling is not the natural word.
    if bare.startswith("c") and bare[1:] in ("int", "uint", "float", "double", "char", "short", "long"):
        bare = bare[1:]
    return bare[:1].upper() + bare[1:]


# A static member variable. Not a call, so the pattern names it without
# parentheses; it takes the class as a typedesc like a static method, which is
# what makes AffineTransform.identity read the way it does in C++.
# The pattern is parenthesised. Nim's importcpp for a proc wants something
# call-shaped, and a bare qualified name makes the compiler fail with an
# internal error rather than a message - which is why the hand-written
# DocumentWindow constants had never actually been callable.
nim_static_var_def = """{comment}proc {var_name}*(this: typedesc[{class_name}]): {var_type} {{.header: {juce_module_name}, importcpp: "({qualified_name}::{juce_spelling})".}}{reason}"""

# A public field. C++ reaches one by name; Nim reaches it through a getter and a
# setter, which is also what lets the binding stay an importcpp object with no
# fields of its own.
nim_field_getter_def = """{comment}proc {field_name}*(this: {class_name}): {field_type} {{.header: {juce_module_name}, importcpp: "#.{juce_spelling}".}}{reason}"""
# The setter's backticks already quote the name, so it takes the raw spelling:
# a field called `end` is `end=`, not ``end`=`.
nim_field_setter_def = """{comment}proc `{raw_name}=`*(this: var {class_name}, value: {field_type}) {{.header: {juce_module_name}, importcpp: "#.{juce_spelling} = #".}}{reason}"""

# A static method has no receiver, so it takes the class as a typedesc and is
# called as Time.currentTimeMillis(). That is the spelling juce_events_lifting
# already used for MessageManager.getInstance.
nim_static_method_def = """{comment}proc {method_name}*(this: typedesc[{class_name}]{method_args}){method_return} {{.header: {juce_module_name}, importcpp: "{qualified_name}::{juce_spelling}({juce_args})".}}{reason}"""

nim_method_def = """{comment}proc {method_name}*({method_args}){method_return} {{.header: {juce_module_name}, importcpp: "#.{juce_spelling}({juce_args})".}}{reason}"""

# Deliberately not {.constructor.}. That pragma makes Nim emit a C++ declaration,
# `ValueTree vt(Identifier("x"))`, which C++ reads as a function declaration -
# the most vexing parse - and every later use fails with "not a structure or
# union". Without it the pattern is used and the call is an expression.
nim_constructor_def = """{comment}proc make{class_name}*({method_args}): {class_name} {{.header: {juce_module_name}, importcpp: "{spelling}(@)".}}{reason}"""

#==================================================================================================

def remap_type(t, *args):
    remap_table = {
        # C++ int is 32 bits and Nim's int is 64. Mapping it to Nim's int made
        # distinct C++ overloads collapse onto the same emitted signature:
        # var(int) and var(int64) both became juce::var(NI), which g++ rejects
        # as ambiguous. C++ float is likewise 32 bits, not Nim's 64.
        "int": "cint",
        "float": "cfloat",
        "short": "int16",
        "long": "int64",
        "double": "float64",
        "wchar_t": "uint16",
        "juce::int8": "int8",
        "juce::int16": "int16",
        "juce::int32": "int32",
        "juce::int64": "int64",
        "juce::uint8": "uint8",
        "juce::uint16": "uint16",
        "juce::uint32": "uint32",
        "juce::uint64": "uint64",
        # wchar_t is 32-bit on the platforms this binding supports, and JUCE
        # defines juce_wchar as wchar_t there.
        "juce::juce_wchar": "uint32",
        "juce_wchar": "uint32",
        "CommandID": "int",
        "juce::CommandID": "int",
        "juce::String::CharPointerType": "ptr char",
        "juce::CharPointer_ASCII::CharType": "char",
        "juce::CharPointer_UTF8::CharType": "char",
        "juce::CharPointer_UTF16::CharType": "int16",
        "juce::CharPointer_UTF32::CharType": "uint16",
        "String::CharPointerType": "CharPointer_UTF8",
        "CharPointer_ASCII::CharType": "char",
        "CharPointer_UTF8::CharType": "char",
        "CharPointer_UTF16::CharType": "int16",
        "CharPointer_UTF32::CharType": "uint16",
        "size_t": "csize_t",
        "unsigned int": "uint32",
        "unsigned char": "uint8",
        "unsigned short": "uint16",
        "unsigned long": "uint64",
        "long long": "int64",
        "unsigned long long": "uint64",
        "juce::var": "juce_var",
        "std::string": "CppString",
        "std::exception": "CppException",
        "std::type_index": "CppTypeIndex",
        "std::byte": "CppByte",
        "var": "juce_var",
        "var::NativeFunctionArgs": "juce_varNativeFunctionArgs",
        "NamedValueSet::NamedValue": "NamedValueSetNamedValue"
    }

    # A nested type is spelled bare, and the same bare name can belong to
    # several classes: Slider, PopupMenu and others each have an "Options". The
    # declaration knows its own owner, so ask it rather than guess from the name.
    # A pointer or reference has no declaration of its own; the thing it points
    # at does. Without this, `Expression::Scope *` never resolves and keeps the
    # C++ qualification that makes it invalid Nim.
    target = t
    prefix = ""
    if t.kind == TypeKind.POINTER:
        target = t.get_pointee()
        prefix = "ptr "
    elif t.kind in (TypeKind.LVALUEREFERENCE, TypeKind.RVALUEREFERENCE):
        target = t.get_pointee()
        prefix = "" if target.is_const_qualified() else "var "

    declaration = target.get_declaration()

    # A member typedef names a type rather than being one: X::Ptr is a
    # ReferenceCountedObjectPtr<X>. Resolve through it before anything else.
    if declaration is not None and declaration.kind in (
            CursorKind.TYPEDEF_DECL, CursorKind.TYPE_ALIAS_DECL):
        underlying = remap_type(declaration.underlying_typedef_type, *args)
        # A function typedef, such as MessageCallbackFunction, has no Nim
        # spelling here and resolves to nonsense like "pointer(pointer)".
        if (underlying and "<" not in underlying and "::" not in underlying
                and "(" not in underlying and not is_c_array(underlying)):
            return f"{prefix}{underlying}"

    if declaration is not None and declaration.kind in (
            CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL, CursorKind.ENUM_DECL):
        owner = declaration.semantic_parent
        if (owner is not None and owner.kind in (CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL)
                and declaration.spelling and owner.spelling):
            qualified_nested = f"juce::{owner.spelling}::{declaration.spelling}"
            for table in args:
                if qualified_nested in table:
                    return f"{prefix}{table[qualified_nested]}"

    parts = list(filter(lambda part: part, t.spelling.split(" ")))

    is_pointer = "*" in parts
    is_const = "const" in parts

    result = t.spelling
    # Remap common types
    result = result.replace("const void *", "kPointer")
    result = result.replace("void *", "pointer")
    result = result.replace("const char *", "kChar")
    result = result.replace("char *", "ptr char")
    # Extract the type itself
    result = result.replace("const", "")
    result = result.replace("*", "")
    result = result.replace("&", "")
    # Replace internal june types
    result = result.replace("kPointer", "constPointer")
    result = result.replace("kChar", "constChar")
    result = result.strip()

    if "<" in result:
        mapped = remap_template(result, *args)
        # std::function over a const reference is a different C++ type from one
        # over a value, and where the argument holds a reference member - as
        # var::NativeFunctionArgs does - the by-value form does not compile at
        # all. The const and the & are stripped from the spelling above before
        # remap_template ever sees them, so the distinction is read here, off
        # the original.
        if (mapped is not None and mapped.startswith("CppFunctionObjectR1[")
                and re.search(r"std::function<[^<>]*\(\s*const\s[^()*]*&\s*\)>", t.spelling)):
            mapped = "CppFunctionObjectR1Ref[" + mapped[len("CppFunctionObjectR1["):]
        # Leave the C++ spelling in place when it cannot be mapped. It is not
        # valid Nim, which is exactly the signal the emit site checks in order
        # to comment the proc out.
        if mapped is not None:
            return f"ptr {mapped}" if is_pointer else mapped
        return result

    result = remap_table.get(result, result)
    for a in args:
        result = a.get(result, result)

    if not is_const and not t.get_pointee().is_const_qualified():
        # An rvalue reference parameter has no distinct Nim spelling. It used to
        # be bound as `lent`, which is a return-type modifier: as a parameter it
        # produced an overload differing from the const-reference one by a word
        # Nim 1.6 cannot tell apart, so calling either was ambiguous. Binding it
        # as the plain type makes the two declarations identical, and the
        # duplicate is dropped by the check that already removes repeats.
        if "&" in parts:
            result = f"var {result}"

    implicit_pointer_types = ["pointer", "ptr char", "constChar", "constPointer"]

    return f"ptr {result}" if is_pointer and result not in implicit_pointer_types else result

# C++ spellings that must not become Nim's int or float inside a template
# argument. Nim substitutes the parameter's C++ name into the template, and
# Nim's int is 64-bit, so Rectangle[int] would ask for juce::Rectangle<long long>
# rather than the juce::Rectangle<int> that JUCE instantiates.
cpp_value_types = {
    # std::byte is a distinct C++ type rather than an alias for a character, so
    # it needs a binding of its own; remap_template_arg reaches this table but
    # not remap_type's, which is where the other std:: names live.
    "std::byte": "CppByte",
    "int": "cint",
    "unsigned int": "cuint",
    "short": "cshort",
    "unsigned short": "cushort",
    "long": "clong",
    "long long": "clonglong",
    "float": "cfloat",
    "double": "cdouble",
    "char": "cchar",
    "unsigned char": "cuchar",
    "bool": "bool",
    "size_t": "csize_t",
    "void": "void",
    "CommandID": "cint",
    "int8_t": "int8",
    "int16_t": "int16",
    "int32_t": "int32",
    "int64_t": "int64",
    "uint8_t": "uint8",
    "uint16_t": "uint16",
    "uint32_t": "uint32",
    "uint64_t": "uint64",
}

# Template heads this binding can express. A JUCE template maps to the Nim
# generic of the same name in the corresponding _lifting file; the standard
# library ones map to june_stl.
template_heads = {
    "std::unique_ptr": "UniquePtr",
    "std::optional": "CppOptional",
    # A method declared with `auto` reports its deduced return type unqualified,
    # so std::optional arrives as a bare `optional`. juce::Optional is spelled
    # with a capital O, so the lowercase name is unambiguous.
    "optional": "CppOptional",
    "std::vector": "CppVector",
    "std::map": "CppMap",
    "std::unordered_map": "CppUnorderedMap",
    "std::array": "CppArray",
    "Rectangle": "Rectangle",
    "Point": "Point",
    "Line": "Line",
    "BorderSize": "BorderSize",
    "Range": "Range",
    "Array": "Array",
    "OwnedArray": "OwnedArray",
    "ReferenceCountedObjectPtr": "ReferenceCountedObjectPtr",
    "Span": "Span",
    "HeapBlock": "HeapBlock",
    "WeakReference": "WeakReference",
    "OptionalScopedPointer": "OptionalScopedPointer",
    "RectangleList": "RectangleList",
    "Parallelogram": "Parallelogram",
    "SparseSet": "SparseSet",
    "NormalisableRange": "NormalisableRange",
    "Optional": "Optional",
}

def split_template_args(text):
    """Split on commas that are not inside nested angle brackets or parens."""
    args, depth, current = [], 0, ""
    for char in text:
        if char in "<(":
            depth += 1
        elif char in ">)":
            depth -= 1
        if char == "," and depth == 0:
            args.append(current.strip())
            current = ""
        else:
            current += char
    if current.strip():
        args.append(current.strip())
    return args

def remap_template(spelling, *args):
    """Convert a C++ template spelling to Nim, or return None if it cannot be.

    Returning None matters: the caller comments the proc out. Emitting a
    half-translated type would be a Nim syntax error rather than a binding that
    is merely unavailable.
    """
    # The same `auto` deduction keeps the alias it was written through, giving
    # `optional<decay_t<float>>`. std::decay_t is the identity for the value
    # types JUCE uses it with, so unwrapping it resolves the type the way the
    # explicitly typed overload of the same method already resolves.
    spelling = re.sub(r"(?:std::)?decay_t\s*<\s*([^<>]*?)\s*>", r"\1", spelling)

    match = re.match(r"^([A-Za-z_][A-Za-z0-9_:]*)\s*<(.*)>$", spelling.strip())
    if not match:
        return None

    head, inner = match.group(1), match.group(2)

    # std::function is already bound: the CppFunctionObject types in
    # june_function_utils are std::function, indexed by arity and by whether
    # they return a value.
    if head == "std::function":
        signature = re.match(r"^(.*?)\s*\((.*)\)$", inner.strip())
        if not signature:
            return None
        returns, params = signature.group(1).strip(), signature.group(2).strip()
        params = [] if params in ("", "void") else split_template_args(params)
        if len(params) > 9:
            return None
        mapped = [remap_template_arg(p, *args) for p in params]
        if any(m is None for m in mapped):
            return None
        if returns == "void":
            name = f"CppFunctionObjectN{len(params)}"
            return name if not mapped else f"{name}[{', '.join(mapped)}]"
        mapped_return = remap_template_arg(returns, *args)
        if mapped_return is None:
            return None
        return f"CppFunctionObjectR{len(params)}[{', '.join([mapped_return] + mapped)}]"

    nim_head = template_heads.get(head, template_heads.get(head.split("::")[-1]))
    if nim_head is None:
        return None

    mapped = [remap_template_arg(a, *args) for a in split_template_args(inner)]
    if not mapped or any(m is None for m in mapped):
        return None

    return f"{nim_head}[{', '.join(mapped)}]"

def remap_template_arg(spelling, *args):
    spelling = spelling.replace("const", "").replace("&", "").strip()

    is_pointer = spelling.endswith("*")
    if is_pointer:
        spelling = spelling[:-1].strip()

    if "<" in spelling:
        result = remap_template(spelling, *args)
    elif spelling in cpp_value_types:
        result = cpp_value_types[spelling]
    else:
        result = spelling
        for table in args:
            result = table.get(result, result)
        # juce::var is bound as juce_var, because `var` is a Nim keyword. The
        # rename was applied to class names and to parameter types but not
        # inside a template argument, so a std::function taking one produced a
        # type spelled `var` that no Nim file can contain.
        result = remap_class_name(result)
        if "::" in result:
            # A nested name is bound under the concatenation of its enclosing
            # class and its own name - juce::ProgressBar::Style is
            # ProgressBarStyle - and that rename reached parameter types but not
            # template arguments. Guessing here is safe: a name that is not
            # declared is caught by the check at the emit site, which comments
            # the proc out exactly as an unresolved one already is.
            # Only a JUCE nested name concatenates. A std:: name that reached
            # here is one this binding does not know, and joining it would
            # invent a plausible-looking type - std::byte became "stdbyte" -
            # which the emit site then reports as merely undeclared.
            if result.startswith("std::"):
                return None
            qualifiers = [remap_class_name(part) for part in result.split("::")
                          if part and part != "juce"]
            result = "".join(qualifiers)
            for table in args:
                result = table.get(result, result)

    if result is None:
        return None

    return f"ptr {result}" if is_pointer else result

#==================================================================================================

def remap_class_name(class_name):
    remap_table = {
        "var": "juce_var",
        "juce::var": "juce_var",
    }

    return remap_table.get(class_name, class_name)

# Classes the hand-written _lifting layer subclasses in order to override
# virtual methods. The generated type becomes the base under an Impl name and
# is not exported, so the lifting file can export the real name for the
# june:: subclass that defineCppClass generates.
subclassed_by_lifting = {
    "JUCEApplication": "JUCEApplicationImpl",
    "DocumentWindow": "DocumentWindowImpl",
}

# Methods the hand-written _lifting layer wraps under the same Nim name. The
# generated binding keeps the raw call under an Impl name so both can coexist;
# without this the two overloads differ only by return type, which Nim rejects
# as an ambiguous call.
wrapped_by_lifting = {
    ("String", "toRawUTF8"): "toRawUTF8Impl",
}

# Types whose equality JUCE declares as a free function rather than a member.
# The generator only sees members, so it would emit its no-equality guard and
# collide with the operator the _lifting file binds.
equality_bound_by_lifting = {"String", "juce_var"}

# Types a Nim string reaches through a converter. A class with more than one
# single-argument constructor among these is ambiguous at every literal call:
# makeIdentifier("x") matches both the constChar and the String overload. Nim 2
# picks one, Nim 1.6 refuses.
string_like_types = ("String", "constChar", "StringRef")

def preferred_string_constructor(constructor_types, class_name):
    """Of the string-like single-argument constructors, the one to keep.

    String wins: a Nim string converts to it, and a String value passes
    straight through, so keeping it costs no caller anything.
    """
    # The class's own type is its copy constructor, which is dropped anyway.
    available = {types[0] for types in constructor_types
                 if len(types) == 1 and types[0] in string_like_types
                 and types[0] != class_name}
    if len(available) < 2:
        return None

    # StringRef keeps both. Its String overload is safe and the converter needs
    # it, its constChar overload is the one that must not go through a temporary,
    # and the ambiguity only affects makeStringRef("literal") - which nobody
    # writes, because a string reaches a StringRef parameter by converter.
    if class_name == "StringRef":
        return None

    # Otherwise String wins: a Nim string converts to it and a String value
    # passes straight through, so no caller loses.
    for candidate in string_like_types:
        if candidate in available:
            return candidate
    return None

def preferred_string_operand(overload_types, class_name):
    """Of the string-like single-argument overloads of a method, the one to keep.

    Nim reaches String, StringRef and constChar from a string literal by three
    separate converters, so every one of them matches
    `text.equalsIgnoreCase("literal")` equally well and Nim 1.6 refuses the
    call.

    The class's own type wins where it is one of them: dropping it would leave
    no way to pass a value of the class itself, and there is no converter back.
    StringRef comparing against a StringRef is the case that matters. Otherwise
    String wins - a String value passes straight through and a literal
    converts, so no caller loses.

    Unlike the constructor rule, the class's own type is not excluded here: a
    method taking the class is an ordinary overload rather than a copy
    constructor.
    """
    available = {types[0] for types in overload_types
                 if len(types) == 1 and types[0] in string_like_types}
    if len(available) < 2:
        return None

    if class_name in available:
        return class_name

    for candidate in string_like_types:
        if candidate in available:
            return candidate
    return None

def remap_wrapped_method_name(class_name, method_name):
    return wrapped_by_lifting.get((class_name, method_name), method_name)

#==================================================================================================

def remap_exported_class_name(class_name):
    return subclassed_by_lifting.get(class_name, remap_class_name(class_name))

def class_is_exported(class_name):
    return class_name not in subclassed_by_lifting

#==================================================================================================

# Names that are valid in the generated module without being declared in it:
# Nim builtins, and the types the hand-written june_* files provide.
known_builtin_types = {
    "int", "int8", "int16", "int32", "int64",
    "uint", "uint8", "uint16", "uint32", "uint64",
    "float", "float32", "float64", "bool", "char", "string", "cstring",
    "pointer", "void", "csize_t", "cchar", "cuchar", "cshort", "cushort",
    "cint", "cuint", "clong", "culong", "clonglong", "culonglong",
    "cfloat", "cdouble", "constChar", "constPointer",
    "UniquePtr", "CppOptional", "CppVector", "CppFunctionObjectR1Ref",
    "CppString", "CppMap", "CppUnorderedMap", "CppArray", "CppException", "CppTypeIndex", "CppByte",
    "Rectangle", "Point", "Line", "BorderSize", "Range",
    "Array", "OwnedArray", "ReferenceCountedObjectPtr",
    "Span", "RectangleList", "Parallelogram", "SparseSet", "Optional", "HeapBlock",
    "WeakReference", "OptionalScopedPointer",
    "NormalisableRange",
}
known_builtin_types.update(f"CppFunctionObjectN{n}" for n in range(10))
known_builtin_types.update(f"CppFunctionObjectR{n}" for n in range(10))

# Not types: Nim type-construction keywords that appear in a rendered signature.
type_syntax_words = {"var", "ptr", "lent", "typedesc", "proc", "of"}

def is_c_array(rendered):
    """A C array spells as uint8[6] or char[]; Nim generic brackets never hold
    a number and are never empty, so the two cannot be confused."""
    return re.search(r"\[\s*\d*\s*\]", rendered) is not None

def unbound_type_reason(rendered):
    """Why a rendered signature could not be bound.

    Two of these are not missing capability. A C array parameter always comes
    with an overload taking a String or a value, and an initializer_list always
    comes with the incremental API - add, set, appendChild - that the tests use.
    """
    if is_c_array(rendered):
        return ("a C array parameter; every one of these has an overload "
                "taking a String or a value instead")
    if "initializer_list" in rendered:
        return ("a std::initializer_list parameter, which Nim cannot spell; "
                "build the value with the incremental API instead")
    if "long double" in rendered:
        return ("a long double parameter, which Nim has no type for; the other "
                "overloads take a float or an int")
    if "detail::" in rendered:
        return ("takes a type from juce::detail, which is JUCE's own "
                "implementation; the class is obtained from the API that "
                "creates it")
    return "a type that cannot be spelled in Nim"

def nested_class_descendants(cursor, nim_prefix, cpp_prefix):
    """Every public class nested under a cursor, at any depth.

    A nested class can itself hold one - Expression::Scope::Visitor is three
    deep - and stopping at the first level left those with no Nim spelling and
    no methods. Each is yielded with the concatenated Nim name its type carries
    and the full C++ path to name it by.
    """
    for child in cursor.get_children():
        if (child.kind not in (CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL)
                or child.access_specifier != AccessSpecifier.PUBLIC
                or not child.spelling):
            continue
        nim_name = f"{nim_prefix}{child.spelling}"
        cpp_name = f"{cpp_prefix}::{child.spelling}"
        yield child, nim_name, cpp_name
        yield from nested_class_descendants(child, nim_name, cpp_name)


def is_anonymous_enum(cursor):
    """libclang names an anonymous enum "(unnamed enum at path:line:col)"."""
    return not cursor.spelling or not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", cursor.spelling)

def type_is_declared(rendered, declared):
    """True when every identifier in a rendered signature names a known type.

    The generator has no way to declare a nested typedef such as
    CharPointer_UTF8::CharType, which libclang spells bare as CharType. Emitting
    a proc that mentions one produces an undeclared-identifier error that fails
    the whole module, so check every name rather than blocklisting the ones seen
    so far.
    """
    for identifier in re.findall(r"[A-Za-z_][A-Za-z0-9_]*", rendered):
        if identifier in type_syntax_words or identifier in known_builtin_types:
            continue
        if identifier in declared:
            continue
        return False
    return True

#==================================================================================================

# Every Nim keyword, not the handful that happened to come up. A C++ parameter
# or method named after one is a syntax error, and each was found by the
# compiler rejecting a regenerated file.
nim_keywords = frozenset("""
    addr and as asm bind block break case cast concept const continue converter
    defer discard distinct div do elif else end enum except export finally for
    from func if import in include interface is isnot iterator let macro method
    mixin mod nil not notin object of or out proc ptr raise ref return shl shr
    static template try tuple type using var when while xor yield
""".split())


def remap_identifier(identifier):
    return f"`{identifier}`" if identifier in nim_keywords else identifier

def remap_method_name(method_name):
    return remap_identifier(method_name)

# Compound assignment. C++ returns a reference to the target; Nim's form is a
# statement, and a proc returning a value cannot be used as one, so the return
# is dropped at the emission site. Binding these as `BigInteger+=` instead made
# a legal identifier that cannot be written as an operator, which is the same
# uselessness the mangled `Colour==` had.
nim_compound_assignments = {
    "operator+=": "`+=`",
    "operator-=": "`-=`",
    "operator*=": "`*=`",
    "operator/=": "`/=`",
    "operator|=": "`|=`",
    "operator&=": "`&=`",
    "operator^=": "`^=`",
    "operator%=": "`%=`",
    "operator<<=": "`<<=`",
    "operator>>=": "`>>=`",
}


# Nim can spell these, so bind them as the operators they are. They used to be
# mangled into `Colour==`, which is a legal identifier and useless: the whole
# point of binding an operator is to write a == b. At module scope because JUCE
# declares some of them as free functions rather than members.
nim_operators = {
    "operator==": "`==`",
    "operator<": "`<`",
    "operator<=": "`<=`",
    "operator+": "`+`",
    "operator-": "`-`",
    "operator*": "`*`",
    "operator/": "`/`",
    "operator[]": "`[]`",
    # Nim has no bitwise or shift operator of its own for these spellings -
    # it uses `and`, `or`, `shl` and `shr` - so binding them introduces no
    # ambiguity with an existing overload. `&` is the exception: it already
    # concatenates strings, and an overload on a JUCE type is distinct.
    "operator|": "`|`",
    "operator&": "`&`",
    "operator^": "`^`",
    "operator%": "`%`",
    "operator<<": "`shl`",
    "operator>>": "`shr`",
}


def remap_operator_name(class_name, method_name):
    if method_name in nim_operators:
        return nim_operators[method_name]

    if method_name in nim_compound_assignments:
        return nim_compound_assignments[method_name]

    remap_table = {
        # != > and >= are not bound: Nim derives != from ==, and reverses > and
        # >= from < and <=, so binding them creates ambiguous overloads.
        "operator=": f"`{class_name}=`",
        "operator++": "`inc`",
        "operator--": "`dec`",
    }

    return remap_table.get(method_name)

def operator_comment_reason(method_name):
    """Why an operator was left as a comment rather than bound."""
    if method_name in ("operator!=",):
        return "Nim derives != from =="
    if method_name in ("operator>", "operator>="):
        return "Nim derives > and >= from < and <="
    return "an operator with no Nim spelling"

def remap_argument_name(arg_name, count):
    if not arg_name:
        return f"arg{count + 1}"

    # Nim rejects a leading or trailing underscore and a doubled one, all of
    # which are ordinary in C++ parameter names.
    arg_name = re.sub(r"_+", "_", arg_name).strip("_")
    if not arg_name or arg_name[0].isdigit():
        return f"arg{count + 1}"

    return remap_identifier(arg_name)

#==================================================================================================

def skip_class_method(class_name, method_name):
    # One entry per class, holding a set. A dict of class to a single method
    # name loses every entry but the last for a class named more than once, and
    # `in` against the surviving string is a substring test rather than a
    # membership test, so a method whose name is a prefix of another is skipped
    # by accident.
    skip_table = {
        "ConsoleApplication": {"findAndRunCommand"},
        "AbstractFifo": {"read", "write"},
        "String": {"quoted"},
        "StringArray": {"appendNumbersToDuplicates"},
        "DynamicObject": {"clone"},
        "MemoryMappedFile": {"getRange"},
        "RelativeTime": {"getDescription"},
        "Expression": {"getType"},
        "Random": {"nextInt"},
        # A plain C++ function pointer. juce_core_lifting binds it by hand.
        "SystemStats": {"setApplicationCrashHandler"},
        "Thread": {"getThreadID"},
        "ThreadPoolJob": {"runJob", "addListener", "removeListener", "addJob"},
        # A plain C++ function pointer, which the generator cannot spell.
        # juce_events_lifting binds it by hand.
        "MessageManager": {"callFunctionOnMessageThread"},
        # Slider::Listener is an alias for the class template
        # SliderListener<Slider>. juce_gui_basics_lifting binds the type
        # through the alias and these two along with it.
        "Slider": {"addListener", "removeListener"},
        "URL": {"downloadToFile", "createInputStream"},
        "XmlElement": {"getChildIterator", "getChildWithTagNameIterator"},
    }

    return method_name.strip() in skip_table.get(class_name.strip(), frozenset())

#==================================================================================================

def use_system_libclang():
    """Prefer the toolchain's own libclang.

    A pip-installed libclang cannot find its builtin headers (stdarg.h and the
    rest), and pointing -I at another toolchain's resource directory puts the C
    headers ahead of libc++ and breaks the parse a different way. The toolchain
    library locates its own resources relative to itself, so use it when present
    and otherwise leave whatever the bindings already resolved.
    """
    candidates = []
    if sys.platform == "darwin":
        clang_bin = subprocess.run(["xcrun", "--find", "clang"], capture_output=True,
                                   text=True).stdout.strip()
        if clang_bin:
            toolchain = os.path.dirname(os.path.dirname(clang_bin))
            candidates.append(os.path.join(toolchain, "lib", "libclang.dylib"))
        candidates.append("/Library/Developer/CommandLineTools/usr/lib/libclang.dylib")
    else:
        candidates += sorted(glob.glob("/usr/lib/llvm-*/lib/libclang.so*"), reverse=True)
        candidates += sorted(glob.glob("/usr/lib/*/libclang-*.so*"), reverse=True)

    for candidate in candidates:
        if os.path.exists(candidate):
            clang.cindex.Config.set_library_file(candidate)
            return

#==================================================================================================

def run_main(juce_module_name, juce_class_name_to_export):
    class_map = {}
    class_inheritance_map = {}
    class_inner = {}
    class_juce_map = {}

    done_classes = set()
    emitted_types = set()
    emitted_declarations = set()
    # Keyed on the signature rather than the rendered line. Two JUCE overloads
    # can differ only in the parameter NAME - String(int64 largeIntegerValue)
    # and String(int64 decimalInteger) - and Nim rejects a call that matches
    # both as ambiguous. Comparing the rendered text keeps them both.
    emitted_signatures = set()
    declared_type_names = set()
    dollar_definitions = []
    enum_remap = {}
    global_nested_remap = {}

    base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    juce_module_prefix = "../../"
    juce_module_path = f"JUCE/modules/{juce_module_name}/{juce_module_name}.h"

    # A JUCE module header names its dependencies as <other_module/other_module.h>,
    # so without the modules directory on the include path every cross-module type
    # fails to resolve and libclang reports it as an implicit int. That is silent:
    # the generator still emits a binding, just one that takes int where it should
    # take Graphics or String. The module-available defines are needed for the same
    # reason, since a module header compiles its dependencies out without them.
    juce_args = [
        "-x", "c++",
        "-std=c++17",
        "-DJUCE_API=",
        "-DNDEBUG=1",
        "-DJUCE_GLOBAL_MODULE_SETTINGS_INCLUDED=1",
        "-DJUCE_STANDALONE_APPLICATION=1",
        f"-I{os.path.join(base_path, 'JUCE/modules')}",
    ]
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        juce_args.append(f"-DJUCE_MODULE_AVAILABLE_{module}=1")

    # A .h file is parsed as C unless the language is stated, which fails outright
    # under current libclang. On macOS the SDK also has to be named explicitly.
    if sys.platform == "darwin":
        sdk_path = subprocess.run(["xcrun", "--show-sdk-path"], capture_output=True,
                                  text=True).stdout.strip()
        if sdk_path:
            juce_args += ["-isysroot", sdk_path]

    use_system_libclang()

    index = clang.cindex.Index.create()
    translation_unit = index.parse(os.path.join(base_path, juce_module_path), args=juce_args)

    # Fail loudly. An unresolved type does not stop the parse, it degrades to int,
    # so a run that reports nothing and emits a full file is indistinguishable from
    # a correct one unless the diagnostics are checked here.
    errors = [d for d in translation_unit.diagnostics
              if d.severity >= clang.cindex.Diagnostic.Error]
    if errors:
        for d in errors[:10]:
            print(f"error: {d.spelling}", file=sys.stderr)
        print(f"error: {len(errors)} parse error(s) in {juce_module_path}; "
              f"types would degrade to int", file=sys.stderr)
        sys.exit(1)

    top_level = translation_unit.cursor.get_children()

    juce_namespace = []
    for entry in top_level:
        if entry.kind == CursorKind.NAMESPACE and entry.spelling == "juce":
            juce_namespace.append(entry)

    # TODO - Extract base types (ints, floats, aliases)

    # Extract free functions
    all_functions = []
    for entry in juce_namespace:
        all_functions += [node for node in filter(
            lambda x: x.kind == CursorKind.FUNCTION_DECL, entry.get_children())]

    # And the function templates. A C++ template parameter becomes a Nim
    # generic one and the C++ compiler deduces it from the call, which is what
    # makes jlimit and jmax reachable. nimterop leaves C++ templates to
    # hand-written overrides and hcparse calls its own handling a graceful
    # fallback, so the ones that do not map cleanly stay comments here too.
    all_function_templates = []
    for entry in juce_namespace:
        all_function_templates += [node for node in filter(
            lambda x: x.kind == CursorKind.FUNCTION_TEMPLATE, entry.get_children())]

    # A class whose operator== is a free function rather than a member still
    # has equality, and emitting the no-equality guard for it would collide
    # with the operator the free-function pass binds. juce::String is the case
    # that matters; its == and < are both free.
    classes_with_free_equality = set()
    for function in all_functions:
        if function.spelling != "operator==":
            continue
        arguments = list(function.get_arguments())
        if not arguments:
            continue
        first = arguments[0].type.spelling.replace("const", "").replace("&", "").strip()
        classes_with_free_equality.add(remap_class_name(first.split("::")[-1]))

    # Extract all juce classes
    all_classes = []
    for entry in juce_namespace:
        all_classes += [node for node in filter(
            lambda x: x.kind == CursorKind.CLASS_DECL or x.kind == CursorKind.STRUCT_DECL, entry.get_children())]

    # A module header pulls in the modules it depends on, so the translation
    # unit holds their classes too. Bind only what this module declares, and
    # let the rest stay available as types: june.nim includes every module, so
    # a juce_core class is in scope inside juce_gui_basics without being
    # declared there a second time.
    module_path_prefix = os.path.join(base_path, "JUCE", "modules", juce_module_name)

    def declared_in_this_module(cursor):
        location = cursor.location.file
        return location is not None and os.path.abspath(location.name).startswith(module_path_prefix)

    # A class appears once per forward declaration and once for its definition,
    # and the two can sit in different modules: juce_events forward-declares
    # ThreadPoolJob, which juce_core defines. Ownership follows the definition,
    # so each class is bound exactly once. Picking a declaration instead would
    # emit the type twice and give one copy no methods at all.
    definitions_by_name = {}
    declarations_by_name = {}
    for c in all_classes:
        if c.is_definition():
            definitions_by_name.setdefault(c.spelling, c)
        else:
            declarations_by_name.setdefault(c.spelling, c)

    module_classes = [c for c in definitions_by_name.values() if declared_in_this_module(c)]

    # Enums, top level and nested. None were bound at all, which is why
    # NotificationType, SliderStyle and Justification-adjacent parameters had no
    # spelling and their procs were commented out.
    module_enums = []
    seen_enum_names = set()
    for entry in juce_namespace:
        for node in entry.get_children():
            if node.kind == CursorKind.ENUM_DECL and not is_anonymous_enum(node) and declared_in_this_module(node):
                if node.spelling not in seen_enum_names:
                    seen_enum_names.add(node.spelling)
                    module_enums.append((node.spelling, node, None))
    # Two levels: an enum can sit inside a nested class, and
    # Image::BitmapData::ReadWriteMode is one. Walking only the top level left
    # it with no Nim spelling, which commented out the proc taking it.
    for c in module_classes:
        scopes = [(c.spelling, c)]
        for ic in c.get_children():
            if (ic.kind in (CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL)
                    and ic.access_specifier == AccessSpecifier.PUBLIC and ic.spelling):
                scopes.append((f"{c.spelling}::{ic.spelling}", ic))

        for owner_spelling, owner_cursor in scopes:
            for node in owner_cursor.get_children():
                if (node.kind == CursorKind.ENUM_DECL and node.access_specifier == AccessSpecifier.PUBLIC
                        and not is_anonymous_enum(node)):
                    nested_name = "".join(remap_class_name(part) for part in owner_spelling.split("::")) + node.spelling
                    if nested_name not in seen_enum_names:
                        seen_enum_names.add(nested_name)
                        module_enums.append((nested_name, node, owner_spelling))

    # An opaque class, declared but never defined in this translation unit, is
    # still worth binding as a type by whichever module declares it.
    module_classes += [c for name, c in declarations_by_name.items()
                       if name not in definitions_by_name and declared_in_this_module(c)]

    # Store internal mapping tables, build inheritance map
    for c in all_classes:
        bases = [node.referenced for node in filter(
            lambda x: x.kind == CursorKind.CXX_BASE_SPECIFIER, c.get_children())]

        inner_classes = [node for node in filter(
            lambda x: x.access_specifier == AccessSpecifier.PUBLIC and
                (x.kind == CursorKind.CLASS_DECL or x.kind == CursorKind.STRUCT_DECL), c.get_children())]

        # Record from the definition. A forward declaration has no bases and no
        # nested types, so letting one overwrite the definition's entry silently
        # drops both: Slider::Listener stops existing and Component stops
        # inheriting.
        if c.spelling in class_map and not c.is_definition():
            continue

        class_map[c.spelling] = c
        class_inheritance_map[c.spelling] = bases
        class_inner[c.spelling] = inner_classes

        qualified_name = f"juce::{c.spelling}"
        # For a class the lifting layer subclasses, point at the generated base.
        # The exported subclass is declared in a file included later, so the
        # generated module cannot name it, and inheritance means a caller can
        # still pass the subclass.
        class_juce_map[qualified_name] = remap_exported_class_name(c.spelling)

        # Inside its own module the class is spelled bare, so the qualified key
        # never matches and a renamed class keeps its original name in the
        # signature - a name nothing in that file declares.
        if c.spelling in subclassed_by_lifting:
            class_juce_map[c.spelling] = subclassed_by_lifting[c.spelling]

    print(nim_prolog_def.format(**{
        "juce_module_name": juce_module_name,
        "juce_module_prefix": juce_module_prefix,
        "juce_module_path": juce_module_path }))

    # Every class goes in a single type section. Nim resolves references within
    # one section regardless of order, which is what makes it possible to emit
    # inheritance at all: a class routinely names a base declared further down
    # the header, and there is no ordering of separate type sections that
    # satisfies every such pair.
    all_class_decls = []
    for c in module_classes:
        if juce_class_name_to_export is not None and c.spelling != juce_class_name_to_export:
            continue
        if c.spelling.startswith("this_will_fail_to_link") or c.spelling in emitted_types:
            continue
        emitted_types.add(c.spelling)

        class_name = remap_exported_class_name(c.spelling)
        base = None
        for b in class_inheritance_map[c.spelling]:
            if b is not None and b.spelling in class_map and b.spelling != c.spelling:
                base = remap_exported_class_name(b.spelling)
                break

        all_class_decls.append(nim_class_def.format(**{
            "class_name": class_name,
            "spelling": f"juce::{c.spelling}",
            "juce_module_name": juce_module_name,
            "export": "*" if class_is_exported(c.spelling) else "",
            "base": f" of {base}" if base else "" }))

        for _, inner_name, inner_path in nested_class_descendants(
                c, remap_class_name(c.spelling), f"juce::{c.spelling}"):
            if inner_name in emitted_types:
                continue
            emitted_types.add(inner_name)
            all_class_decls.append(nim_class_def.format(**{
                "class_name": inner_name,
                "spelling": inner_path,
                "juce_module_name": juce_module_name,
                "export": "*",
                "base": "" }))

    for enum_name, enum_cursor, owner in module_enums:
        qualified = f"juce::{owner}::{enum_cursor.spelling}" if owner else f"juce::{enum_cursor.spelling}"
        all_class_decls.append(nim_enum_def.format(**{
            "enum_name": enum_name,
            "spelling": qualified,
            "juce_module_name": juce_module_name }))
        declared_type_names.add(enum_name)
        enum_remap[qualified] = enum_name
        if owner:
            # libclang prints a nested name as it was written, and how much of
            # the path it writes depends on the scope it was written in:
            # LookAndFeel_V4::ColourScheme::UIColour arrives as
            # ColourScheme::UIColour inside LookAndFeel_V4. Register every
            # suffix of the owner path so each spelling resolves.
            owner_parts = owner.split("::")
            for index in range(len(owner_parts)):
                suffix = "::".join(owner_parts[index:])
                enum_remap[f"{suffix}::{enum_cursor.spelling}"] = enum_name
        else:
            enum_remap[enum_cursor.spelling] = enum_name

    if all_class_decls:
        print(nim_type_def.format(**{ "classes": "\n".join(all_class_decls) }))

    # Enumerators are prefixed with their type. C++ scopes them by enum or by
    # class; Nim would put every one of them in the same namespace, where names
    # as generic as "plain" or "none" collide immediately.
    #
    # Each is bound to its C++ name rather than to its numeric value. Nim 1.6
    # erases a distinct type back to its base when passing it, emitting
    # `juce::Image(((int) 2), ...)`, and C++ does not implicitly convert an int
    # to an enum, so every call taking one failed to find a constructor. Naming
    # the enumerator emits the enumerator, which is correct on every version.
    for enum_name, enum_cursor, owner in module_enums:
        if owner:
            scope = f"juce::{owner}::{enum_cursor.spelling}::" if enum_cursor.is_scoped_enum() else f"juce::{owner}::"
        else:
            scope = f"juce::{enum_cursor.spelling}::" if enum_cursor.is_scoped_enum() else "juce::"

        constants = [nim_enum_constant_def.format(**{
                        "constant_name": f"{enum_name}_{e.spelling}",
                        "enum_name": enum_name,
                        "spelling": f"{scope}{e.spelling}",
                        "juce_module_name": juce_module_name })
                     for e in enum_cursor.get_children()
                     if e.kind == CursorKind.ENUM_CONSTANT_DECL]
        if constants:
            print("\n".join(constants) + "\n")

    # An anonymous enum has no name to bind, but its enumerators are ordinary
    # constants and some of them matter, such as the byte limits on a
    # CharPointer. Emit those as plain integers under the owning class's name.
    for c in module_classes:
        for node in c.get_children():
            if (node.kind != CursorKind.ENUM_DECL or node.access_specifier != AccessSpecifier.PUBLIC
                    or not is_anonymous_enum(node)):
                continue
            constants = [f"  {remap_class_name(c.spelling)}_{e.spelling}*: cint = {e.enum_value}"
                         for e in node.get_children()
                         if e.kind == CursorKind.ENUM_CONSTANT_DECL]
            if constants:
                print("const\n" + "\n".join(constants) + "\n")

    for c in all_classes:
        declared_type_names.add(remap_exported_class_name(c.spelling))
        for _, inner_name, _ in nested_class_descendants(
                c, remap_class_name(c.spelling), f"juce::{c.spelling}"):
            declared_type_names.add(inner_name)

    # Enums from every module in the translation unit, not only this one. They
    # are declared by whichever module owns them and june.nim includes them all,
    # so a NotificationType is in scope inside juce_gui_basics - without this,
    # every proc taking one was commented out as an unknown type.
    for entry in juce_namespace:
        for node in entry.get_children():
            if node.kind == CursorKind.ENUM_DECL and not is_anonymous_enum(node):
                declared_type_names.add(node.spelling)
    for c in class_map.values():
        for node in c.get_children():
            if (node.kind == CursorKind.ENUM_DECL and not is_anonymous_enum(node)
                    and node.access_specifier == AccessSpecifier.PUBLIC):
                declared_type_names.add(f"{remap_class_name(c.spelling)}{node.spelling}")

    # Every nested type, keyed by its qualified name. remap_type reaches these
    # through the declaration's semantic parent, so an Options owned by another
    # class resolves to that class's, and nothing is matched by spelling alone -
    # several classes have an Options, and a bare-name table would have to guess.
    for c in class_map.values():
        for _, inner_name, inner_path in nested_class_descendants(
                c, remap_class_name(c.spelling), f"juce::{c.spelling}"):
            global_nested_remap[inner_path] = inner_name
        for node in c.get_children():
            if (node.kind == CursorKind.ENUM_DECL and not is_anonymous_enum(node)
                    and node.access_specifier == AccessSpecifier.PUBLIC):
                global_nested_remap[f"juce::{c.spelling}::{node.spelling}"] = f"{remap_class_name(c.spelling)}{node.spelling}"

    # libclang prints a nested name as it was written, so one used inside its
    # own enclosing class arrives unqualified and the table above, keyed on the
    # qualified name, does not match it. A bare name is only safe to resolve
    # where nothing else in the module shares it: several classes have an
    # Options, and guessing between them would bind the wrong type.
    bare_nested_counts = Counter(key.split("::")[-1] for key in global_nested_remap)
    unambiguous_nested_remap = {
        key.split("::")[-1]: value for key, value in global_nested_remap.items()
        if bare_nested_counts[key.split("::")[-1]] == 1}

    # A nested class is emitted as a type but had no methods and no
    # constructors, so one could be held and passed and never built or called
    # on: LookAndFeel_V4::ColourScheme, Image::BitmapData and PopupMenu::Options
    # among them. Emitting for the inner classes too treats each as a class in
    # its own right, under the concatenated name its type already carries.
    emission_targets = []
    # A top-level class owns its name. juce::MessageManagerLock and
    # juce::MessageManager::Lock are different classes that concatenate to the
    # same Nim name, and emitting for both puts one class's methods on the
    # other's type.
    top_level_names = {remap_exported_class_name(x.spelling) for x in all_classes}
    for c in module_classes:
        emission_targets.append((c, remap_exported_class_name(c.spelling), f"juce::{c.spelling}"))
        for ic, inner_name, inner_path in nested_class_descendants(
                c, remap_class_name(c.spelling), f"juce::{c.spelling}"):
            if inner_name in top_level_names:
                continue
            emission_targets.append((ic, inner_name, inner_path))

    for c, class_name, qualified_name in emission_targets:
        if juce_class_name_to_export is not None and c.spelling != juce_class_name_to_export:
            continue

        if c.spelling.startswith("this_will_fail_to_link"):
            continue

        remap_inner_classes = {}
        for ic in class_inner.get(c.spelling, []):
            mapped_inner = f"{class_name}{ic.spelling}"
            remap_inner_classes[f"{qualified_name}::{ic.spelling}"] = mapped_inner

            # Inside its own class a nested type is spelled bare, so
            # Slider::Listener arrives as "Listener". Map that too, unless a
            # top-level class already owns the name, which must win.
            if f"juce::{ic.spelling}" not in class_juce_map:
                remap_inner_classes[ic.spelling] = mapped_inner

        # Nested enums are spelled bare inside their class too: Image's
        # constructor takes a "PixelFormat", not an "Image::PixelFormat".
        for node in c.get_children():
            if (node.kind != CursorKind.ENUM_DECL or is_anonymous_enum(node)
                    or node.access_specifier != AccessSpecifier.PUBLIC):
                continue
            # class_name and qualified_name rather than c.spelling: those
            # coincide for a top-level class and do not for an inner one, whose
            # Nim name carries its enclosing class and whose C++ name carries
            # the whole path.
            mapped_enum = f"{class_name}{node.spelling}"
            remap_inner_classes[f"{qualified_name}::{node.spelling}"] = mapped_enum
            if f"juce::{node.spelling}" not in class_juce_map:
                remap_inner_classes[node.spelling] = mapped_enum

        # Member typedefs. X::Ptr is a ReferenceCountedObjectPtr<X> and
        # CharPointer_UTF8::CharType is a char; neither is a class, so nothing
        # declared them and every proc using one was commented out.
        for node in c.get_children():
            if (node.kind not in (CursorKind.TYPEDEF_DECL, CursorKind.TYPE_ALIAS_DECL)
                    or node.access_specifier != AccessSpecifier.PUBLIC):
                continue
            resolved = remap_type(node.underlying_typedef_type,
                                  remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)
            if resolved and "<" not in resolved and "::" not in resolved and not is_c_array(resolved):
                remap_inner_classes.setdefault(node.spelling, resolved)
                remap_inner_classes.setdefault(f"juce::{c.spelling}::{node.spelling}", resolved)

        # Keyed on the qualified name: several classes have an inner Options,
        # and the bare name would let the first one seen suppress the rest.
        if qualified_name in done_classes:
            continue
        done_classes.add(qualified_name)

        #print(c.spelling)
        #print(list(map(lambda x: x.spelling, class_inheritance_map[c.spelling])))

        # Constructors. Nothing generated these before, so a type could be
        # named but never built: an Identifier had no way into existence, which
        # is most of why ValueTree was unusable.
        public_constructors = [x for x in c.get_children()
                               if x.kind == CursorKind.CONSTRUCTOR
                               and x.access_specifier == AccessSpecifier.PUBLIC]

        def constructor_arg_types(ctor):
            return [remap_type(a.type, remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)
                    for a in ctor.get_arguments()]

        keep_string_constructor = preferred_string_constructor(
            [constructor_arg_types(x) for x in public_constructors], class_name)

        for ctor in public_constructors:
            ctor_args, ctor_types, ctor_comment = [], [], ""
            for count, arg in enumerate(ctor.get_arguments()):
                argument_type = remap_type(arg.type, remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)
                ctor_args.append(f"{remap_argument_name(arg.spelling, count)}: {argument_type}")
                ctor_types.append(argument_type)

            if (keep_string_constructor is not None and len(ctor_types) == 1
                    and ctor_types[0] in string_like_types
                    and ctor_types[0] != class_name
                    and ctor_types[0] != keep_string_constructor):
                ctor_comment = "# "
                ctor_reason = f"redundant with the {keep_string_constructor} overload, which a string also reaches"
            else:
                ctor_reason = ""

            # A copy or move constructor would just shadow the plain one.
            if len(ctor_types) == 1 and ctor_types[0].replace("var ", "").replace("lent ", "") == class_name:
                continue

            rendered = ", ".join(ctor_types)
            ctor_invalid = ("<" in rendered or "::" in rendered or "(" in rendered
                            or is_c_array(rendered)
                            or not type_is_declared(rendered, declared_type_names))
            ctor_comment = ctor_comment or ("# " if ctor_invalid else "")

            declaration = nim_constructor_def.format(**{
                "comment": ctor_comment,
                "class_name": class_name,
                "method_args": ", ".join(ctor_args),
                "juce_module_name": juce_module_name,
                "spelling": qualified_name,
                "reason": (f"  # {ctor_reason}" if ctor_reason
                           else f"  # {unbound_type_reason(rendered)}" if ctor_comment
                           else "") })

            signature = (f"make{class_name}", tuple(ctor_types))
            if declaration in emitted_declarations or signature in emitted_signatures:
                continue
            emitted_declarations.add(declaration)
            emitted_signatures.add(signature)
            print(declaration)

        # Conversion operators. juce::var has no other way out: without these
        # a var could be turned into a String and nothing else, so reading the
        # int or the double back was not possible.
        for conversion in c.get_children():
            if (conversion.kind != CursorKind.CONVERSION_FUNCTION
                    or conversion.access_specifier != AccessSpecifier.PUBLIC):
                continue

            nim_type = remap_type(conversion.result_type, remap_inner_classes, enum_remap,
                                  class_juce_map, global_nested_remap, unambiguous_nested_remap)
            conversion_comment, conversion_reason = "", ""
            if ("<" in nim_type or "::" in nim_type or "(" in nim_type
                    or is_c_array(nim_type)
                    or not type_is_declared(nim_type, declared_type_names)):
                conversion_comment = "# "
                conversion_reason = unbound_type_reason(nim_type)

            target = conversion_target_name(nim_type)

            # A method of the same name wins. juce::var has both a toString
            # method and an operator String, and they are not the same thing:
            # emitting the conversion first made `$` use static_cast and print
            # the wrong text.
            if any(other.kind == CursorKind.CXX_METHOD
                   and other.access_specifier == AccessSpecifier.PUBLIC
                   and other.spelling == f"to{target}"
                   for other in c.get_children()):
                continue

            # Keyed the way a method is, because that is what it competes
            # with: juce::var has both a toString method and an operator String.
            conversion_signature = (f"this: {class_name}", f"to{target}", (), f": {nim_type}")
            if conversion_signature in emitted_signatures:
                continue
            emitted_signatures.add(conversion_signature)

            print(nim_conversion_def.format(**{
                "comment": conversion_comment, "target": target, "class_name": class_name,
                "nim_type": nim_type.replace("var ", ""),
                "cpp_type": conversion.result_type.get_canonical().spelling,
                "juce_module_name": juce_module_name,
                "reason": f"  # {conversion_reason}" if conversion_comment else "" }))

        # Static member variables. AffineTransform::identity, AlertWindow's
        # icon types and FlexItem::autoValue are constants an application
        # reaches for, and a static member is a VAR_DECL rather than a
        # FIELD_DECL, so the field pass does not see one.
        for static_var in c.get_children():
            if (static_var.kind != CursorKind.VAR_DECL
                    or static_var.access_specifier != AccessSpecifier.PUBLIC
                    or not static_var.spelling):
                continue

            var_type = remap_type(static_var.type, remap_inner_classes, enum_remap,
                                  class_juce_map, global_nested_remap, unambiguous_nested_remap)
            var_comment, var_reason = "", ""
            if ("<" in var_type or "::" in var_type or "(" in var_type
                    or is_c_array(var_type)
                    or not type_is_declared(var_type, declared_type_names)):
                var_comment = "# "
                var_reason = unbound_type_reason(var_type)

            var_name = remap_identifier(static_var.spelling)
            var_signature = (f"this: typedesc[{class_name}]", var_name, (), f": {var_type}")
            if var_signature in emitted_signatures:
                continue
            emitted_signatures.add(var_signature)

            print(nim_static_var_def.format(**{
                "comment": var_comment, "var_name": var_name, "class_name": class_name,
                "var_type": var_type.replace("var ", ""), "juce_module_name": juce_module_name,
                "qualified_name": qualified_name, "juce_spelling": static_var.spelling,
                "reason": f"  # {var_reason}" if var_comment else "" }))

        # Public fields. A JUCE options or parameters struct is often nothing
        # but fields - Slider::RotaryParameters is two floats and a bool - so
        # binding the class without them binds nothing usable.
        for field in c.get_children():
            if (field.kind != CursorKind.FIELD_DECL
                    or field.access_specifier != AccessSpecifier.PUBLIC
                    or not field.spelling):
                continue

            field_type = remap_type(field.type, remap_inner_classes, enum_remap,
                                    class_juce_map, global_nested_remap, unambiguous_nested_remap)
            field_comment, field_reason = "", ""
            if ("<" in field_type or "::" in field_type or "(" in field_type
                    or is_c_array(field_type)
                    or not type_is_declared(field_type, declared_type_names)):
                field_comment = "# "
                field_reason = unbound_type_reason(field_type)

            field_name = remap_identifier(field.spelling)
            # Also keyed the way a method is: a class with a field and a
            # method of the same name would otherwise emit both.
            field_signature = (f"this: {class_name}", field_name, (), f": {field_type}")
            if field_signature in emitted_signatures:
                continue
            emitted_signatures.add(field_signature)

            print(nim_field_getter_def.format(**{
                "comment": field_comment, "field_name": field_name,
                "class_name": class_name, "field_type": field_type.replace("var ", ""),
                "juce_module_name": juce_module_name, "juce_spelling": field.spelling,
                "reason": f"  # {field_reason}" if field_comment else "" }))

            # No setter for a field C++ will not let anyone assign: a const one,
            # or a reference, which binds once and cannot be repointed.
            if not (field.type.is_const_qualified() or "&" in field.type.spelling):
                print(nim_field_setter_def.format(**{
                    "comment": field_comment, "raw_name": field.spelling,
                    "class_name": class_name, "field_type": field_type.replace("var ", ""),
                    "juce_module_name": juce_module_name, "juce_spelling": field.spelling,
                    "reason": f"  # {field_reason}" if field_comment else "" }))

        class_bound_equality = False
        class_has_to_string = False

        # The same ambiguity the constructors have, one level down, and for
        # every method rather than only the operators. A method taking both a
        # String and a StringRef gives Nim 1.6 two equally good matches for
        # `text.equalsIgnoreCase("literal")` and it refuses the call. Nim 2
        # resolves it, so the ambiguity is invisible unless 1.6 is compiled
        # against.
        public_methods = [x for x in c.get_children()
                          if x.kind == CursorKind.CXX_METHOD
                          and x.access_specifier == AccessSpecifier.PUBLIC]
        keep_string_operand = {}
        for method_spelling in {x.spelling for x in public_methods}:
            overload_types = [
                [remap_type(a.type, remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)
                 for a in x.get_arguments()]
                for x in public_methods if x.spelling == method_spelling]
            preferred = preferred_string_operand(overload_types, class_name)
            if preferred is not None:
                keep_string_operand[method_spelling] = preferred

        for m in filter(lambda x: x.kind == CursorKind.CXX_METHOD, c.get_children()):
            if m.access_specifier != AccessSpecifier.PUBLIC:
                continue

            if m.spelling in ["JUCE_DEPRECATED", "JUCE_DEPRECATED_STATIC"]:
                continue

            is_static_method = m.is_static_method()
            is_const_method = m.is_const_method()

            comment = ""

            # A static method's receiver is the class itself rather than a
            # value, so it carries no `this` argument into the C++ call.
            args = ([] if is_static_method
                    else [f"this: {'' if is_const_method else 'var '}{class_name}"])
            argument_types = []
            for count, arg in enumerate(m.get_arguments()):
                default_value = ""

                contains_default = any(filter(lambda t: t == "=", [t.spelling for t in arg.get_tokens()]))
                if contains_default:
                    arg_children = [t.spelling for t in arg.get_tokens()]
                    default_value = "".join(arg_children[arg_children.index("=") + 1:])
                    default_value = default_value.replace("nullptr", "nil")
                    default_value = f" = {default_value}"

                spelling = remap_argument_name(arg.spelling, count)
                argument_type = remap_type(arg.type, remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)

                # `nil` is a value only for a nilable type. A std::function
                # binds to an object, and the CppFunctionObject types are in the
                # builtin set, so the check below would let `= nil` through on
                # one - which is what a static method taking an optional
                # callback turned up.
                if default_value.strip() == "= nil" and not (
                        argument_type.startswith("ptr ")
                        or argument_type in ("pointer", "cstring")):
                    default_value = ""

                # A default is only kept where the literal is already a value of
                # the parameter's type here. The converters that would make, say,
                # "*" into a juce::String live in the _lifting file, which is
                # included after this one, so such a default does not compile.
                if default_value and argument_type not in known_builtin_types:
                    if not (argument_type.startswith("ptr ") and default_value.strip() == "= nil"):
                        default_value = ""

                # And only when the default is a literal. C++ freely defaults a
                # parameter to an enumerator or a constant that this binding
                # never declares, which reads as an undeclared identifier.
                if default_value:
                    literal = default_value.split("=", 1)[1].strip()
                    if not re.fullmatch(r"(nil|true|false|-?[0-9][0-9a-fA-FxX.eE+_-]*[fFlLuU]?|'.'|\".*\")", literal):
                        default_value = ""
                    # A C++ character literal defaults an integer parameter
                    # freely; Nim will not convert one.
                    elif literal.startswith("'") and argument_type not in ("char", "cchar"):
                        default_value = ""

                args.append(f"{spelling}: {argument_type}{default_value}")
                argument_types.append(argument_type)

            reason = ""
            return_type = ""
            if m.result_type.spelling != "void":
                return_type = f": {remap_type(m.result_type, remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)}"

            if m.result_type.spelling in ["CFStringRef", "OSType"]:
                comment, reason = "# ", "a platform type with no Nim spelling"

            if (m.spelling in ["begin", "end", "cbegin", "cend"]
                    or m.spelling.endswith("Iterator")):
                comment, reason = "# ", "a C++ iterator; loop with the Nim iterator instead"
            elif skip_class_method(class_name, m.spelling):
                comment, reason = "# ", "excluded deliberately: see skip_class_method"

            # A C++ template or a nested name that survived remapping is not
            # valid Nim and would break the whole module, so emit the proc as a
            # comment. It stays visible as work still to do.
            # Check the types only. Argument names are not types, and a default
            # value is not either: reading "ignoreCase: bool = false" as a type
            # made "false" look like an undeclared name and commented out every
            # proc that had one.
            preferred_operand = keep_string_operand.get(m.spelling)
            if (preferred_operand is not None and len(argument_types) == 1
                    and argument_types[0] in string_like_types
                    and argument_types[0] != preferred_operand):
                # Emitted as a comment rather than dropped, so that a binding
                # withheld to keep a call unambiguous is as visible as one
                # withheld because its type has no Nim spelling.
                comment = "# "
                reason = f"redundant with the {preferred_operand} overload, which a string also reaches"

            method_spelling = m.spelling
            method_name = remap_method_name(remap_wrapped_method_name(class_name, m.spelling))
            if method_name.startswith("operator"):
                mapped_operator = remap_operator_name(class_name, method_name)
                if not mapped_operator:
                    comment, reason = "# ", operator_comment_reason(method_name)
                    method_name = m.spelling
                else:
                    method_name = mapped_operator

            # Dropped before the check below, so a compound assignment is not
            # commented out over a return type it no longer has.
            if method_name in nim_compound_assignments.values():
                return_type = ""

            rendered = ", ".join(argument_types) + return_type
            if ("<" in rendered or "::" in rendered or "(" in rendered
                    or is_c_array(rendered)
                    or not type_is_declared(rendered, declared_type_names)):
                comment = "# "
                # Only when nothing more specific has been established: a
                # begin() whose return type is also unspellable is still best
                # described as an iterator the Nim ones replace.
                reason = reason or unbound_type_reason(rendered)

            if is_static_method:
                declaration = nim_static_method_def.format(**{
                    "comment": comment,
                    "method_name": method_name,
                    "class_name": class_name,
                    "method_args": (", " + ", ".join(args)) if args else "",
                    "method_return": return_type,
                    "juce_module_name": juce_module_name,
                    "qualified_name": qualified_name,
                    "juce_spelling": method_spelling,
                    "juce_args": "@" if args else "",
                    "reason": f"  # {reason}" if comment and reason else "",
                })
            else:
                declaration = nim_method_def.format(**{
                    "comment": comment,
                    "method_name": method_name,
                    "method_args": ", ".join(args),
                    "method_return": return_type,
                    "juce_module_name": juce_module_name,
                    "juce_spelling": method_spelling,
                    "juce_args": "@" if len(args) > 1 else "",
                    "reason": f"  # {reason}" if comment and reason else "",
                })

            # libclang can hand back the same method more than once for a single
            # class, and Nim rejects the repeat as a redefinition.
            # The receiver is part of the key, const-ness included:
            # argument_types holds neither. Without the class name,
            # AsyncUpdater.triggerAsyncUpdate and
            # LockingAsyncUpdater.triggerAsyncUpdate collide; without the
            # const-ness, the const and non-const overloads of a getter do, and
            # dropping the const one makes it uncallable on a `let`.
            receiver = f"typedesc[{class_name}]" if is_static_method else args[0]
            signature = (receiver, method_name, tuple(argument_types), return_type)
            if declaration in emitted_declarations or signature in emitted_signatures:
                continue
            emitted_declarations.add(declaration)
            emitted_signatures.add(signature)

            if method_name == "`==`" and not comment:
                class_bound_equality = True

            # A zero-argument toString returning a String is what $ should use.
            # Without it Nim's default $ prints "()" for every one of these: an
            # importcpp object declares no fields, so there is nothing to show.
            if (method_name == "toString" and not comment and len(args) == 1
                    and return_type == ": String"):
                class_has_to_string = True

            print(declaration)

        # Where C++ defines no equality, make comparing two of these a compile
        # error. Nim would otherwise fall back to structural equality, and an
        # importcpp object declares no fields, so it compares nothing and
        # reports every two values equal - silently, and in the direction that
        # makes a test pass. != is derived from ==, so it is covered too.
        if class_has_to_string:
            # Emitted after the _lifting include below, not here: the body calls
            # $ on a String, and that is defined in the lifting file. Declared
            # before it, the call resolves to Nim's default $ for an object,
            # which prints "()" because these declare no fields.
            dollar_definitions.append(nim_dollar_def.format(**{"class_name": class_name}))

        if (not class_bound_equality and class_name not in equality_bound_by_lifting
                and class_name not in classes_with_free_equality):
            print(nim_no_equality_def.format(**{
                "class_name": class_name,
                "spelling": qualified_name }))

        print()

    # The same string-overload rule the methods have, across the free
    # functions. JUCE declares operator< for String, StringRef and constChar in
    # every combination, and a Nim string literal reaches each of them, so a
    # comparison of two Strings matched several equally well.
    module_functions = [f for f in all_functions if declared_in_this_module(f) and f.spelling]
    free_preferred = {}
    for function in module_functions:
        key = (function.spelling, len(list(function.get_arguments())))
        types = [remap_type(a.type, {}, enum_remap, class_juce_map,
                            global_nested_remap, unambiguous_nested_remap)
                 for a in function.get_arguments()]
        free_preferred.setdefault(key, []).append(types)
    free_keep = {}
    for key, overloads in free_preferred.items():
        if len(overloads) < 2:
            continue
        for position in range(key[1]):
            candidates = {types[position] for types in overloads
                          if types[position] in string_like_types}
            if len(candidates) < 2:
                continue
            for preferred in string_like_types:
                if preferred in candidates:
                    free_keep[(key, position)] = preferred
                    break

    # Free functions in the juce namespace. These were collected and then
    # discarded, so countNumberOfBits, findHighestSetBit and the rest had no
    # binding at all.
    for function in all_functions:
        if not declared_in_this_module(function) or not function.spelling:
            continue

        function_name = remap_identifier(function.spelling)
        comment, reason = "", ""

        # JUCE declares String's ==, < and + as free functions rather than
        # members, so the operator table applies here too. There is no class to
        # mangle an unspellable one into, so it stays a comment.
        if function.spelling.startswith("operator"):
            mapped = (nim_operators.get(function.spelling)
                      or nim_compound_assignments.get(function.spelling))
            if mapped:
                function_name = mapped
            else:
                comment, reason = "# ", operator_comment_reason(function.spelling)
        if function.spelling in ("begin", "end", "cbegin", "cend"):
            comment, reason = "# ", "a C++ iterator; loop with the Nim iterator instead"
        if function.spelling in free_functions_bound_by_lifting:
            comment, reason = "# ", "bound by hand in the _lifting file"

        function_args, function_types = [], []
        for count, arg in enumerate(function.get_arguments()):
            # No per-class table here: the loop that built one has ended, so
            # it holds whichever class happened to be last.
            argument_type = remap_type(arg.type, {}, enum_remap, class_juce_map,
                                       global_nested_remap, unambiguous_nested_remap)
            function_args.append(f"{remap_argument_name(arg.spelling, count)}: {argument_type}")
            function_types.append(argument_type)

        function_return = ""
        if function.result_type.spelling != "void":
            function_return = f": {remap_type(function.result_type, {}, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)}"

        rendered = ", ".join(function_types) + function_return
        if ("<" in rendered or "::" in rendered or "(" in rendered
                or is_c_array(rendered)
                or not type_is_declared(rendered, declared_type_names)):
            comment = "# "
            reason = reason or unbound_type_reason(rendered)

        overload_key = (function.spelling, len(function_types))
        withheld = next(
            (position for position in range(len(function_types))
             if free_keep.get((overload_key, position), function_types[position])
                != function_types[position]
             and function_types[position] in string_like_types), None)
        if withheld is not None:
            comment = "# "
            reason = (f"redundant with the {free_keep[(overload_key, withheld)]} overload, "
                      "which a string also reaches")

        signature = ("<free>", function_name, tuple(function_types), function_return)
        if signature in emitted_signatures:
            continue
        emitted_signatures.add(signature)

        print(nim_function_def.format(**{
            "comment": comment,
            "function_name": function_name,
            "function_args": ", ".join(function_args),
            "function_return": function_return,
            "juce_module_name": juce_module_name,
            "juce_spelling": function.spelling,
            "juce_args": "@" if function_args else "",
            "reason": f"  # {reason}" if comment and reason else "" }))

    print()

    # Function templates. Each C++ type parameter becomes a Nim generic one and
    # the C++ compiler deduces it from the call site, so jlimit(0, 10, x) works
    # for any type JUCE accepts.
    for template_function in all_function_templates:
        if not declared_in_this_module(template_function) or not template_function.spelling:
            continue

        # A deduction guide is not callable; libclang names one
        # "<deduction guide for X>".
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", template_function.spelling):
            continue

        parameters = list(template_function.get_children())
        type_parameters = [p.spelling for p in parameters
                           if p.kind == CursorKind.TEMPLATE_TYPE_PARAMETER and p.spelling]
        # A non-type parameter has no Nim generic to become, and a pack has no
        # fixed arity, so neither maps.
        if any(p.kind == CursorKind.TEMPLATE_NON_TYPE_PARAMETER for p in parameters):
            continue
        if not type_parameters:
            continue

        template_scope = declared_type_names | set(type_parameters)
        # The template's own parameter names win over every rename, and they
        # have to short-circuit rather than sit in a table: JUCE has an
        # Expression::Type, so an earlier table rewrote a parameter called Type
        # to ExpressionType, after which an identity entry keyed on Type could
        # no longer match it.
        def remap_template_type(cursor_type):
            bare = cursor_type.spelling.replace("const", "").replace("&", "").strip()
            if bare in type_parameters:
                return remap_identifier(bare)
            if bare.endswith("*") and bare[:-1].strip() in type_parameters:
                return f"ptr {remap_identifier(bare[:-1].strip())}"
            return remap_type(cursor_type, {}, enum_remap, class_juce_map,
                              global_nested_remap, unambiguous_nested_remap)

        # get_arguments() is empty for a FUNCTION_TEMPLATE; its parameters are
        # PARM_DECL children alongside the template parameters themselves.
        template_args, template_types = [], []
        for count, arg in enumerate(p for p in parameters if p.kind == CursorKind.PARM_DECL):
            argument_type = remap_template_type(arg.type)
            template_args.append(f"{remap_argument_name(arg.spelling, count)}: {argument_type}")
            template_types.append(argument_type)

        if not template_args:
            continue

        template_return = ""
        if template_function.result_type.spelling != "void":
            template_return = f": {remap_template_type(template_function.result_type)}"

        rendered = ", ".join(template_types) + template_return
        comment, reason = "", ""
        if ("<" in rendered or "::" in rendered or "(" in rendered
                or "..." in rendered
                or is_c_array(rendered)
                or not type_is_declared(rendered, template_scope)):
            comment = "# "
            reason = unbound_type_reason(rendered)

        # Every type parameter has to appear in the arguments, or Nim has no
        # way to infer it and C++ no way to deduce it.
        if not comment and any(parameter not in rendered for parameter in type_parameters):
            comment = "# "
            reason = "a template parameter that appears only in the return type, which nothing can deduce"

        signature = ("<template>", template_function.spelling, tuple(template_types), template_return)
        if signature in emitted_signatures:
            continue
        emitted_signatures.add(signature)

        print(nim_template_def.format(**{
            "comment": comment,
            "function_name": remap_identifier(template_function.spelling),
            "generics": ", ".join(remap_identifier(p) for p in type_parameters),
            "function_args": ", ".join(template_args),
            "function_return": template_return,
            "juce_module_name": juce_module_name,
            "juce_spelling": template_function.spelling,
            "reason": f"  # {reason}" if comment and reason else "" }))

    print()

    print(nim_suffix_def.format(**{"juce_module_name": juce_module_name}))

    if dollar_definitions:
        print("\n".join(dollar_definitions))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Juce to Nim binding converter")
    parser.add_argument("--module", default="juce_core", help="Name of the juce module to export")
    parser.add_argument("--class-name", help="Name of the juce class to export, if none all classes will be exported")
    args = parser.parse_args()

    run_main(args.module, args.class_name)

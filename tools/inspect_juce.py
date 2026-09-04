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

# `$` on an importcpp object with no toString falls through to Nim's default,
# which prints "()" because these declare no fields - a silent, useless answer
# in exactly the place a person is trying to see what a value is. 610 of the
# 630 bound types were in that state. Marked {.error.}, it says so instead.
nim_no_dollar_def = """proc `$`*(this: {class_name}): string {{.error: "{spelling} has no toString; print a property instead".}}"""

nim_no_equality_def = """proc `==`*(this: {class_name}, other: {class_name}): bool {{.error: "{spelling} defines no operator==; compare a property instead".}}"""

nim_enum_constant_def = """let {constant_name}* {{.header: {juce_module_name}, importcpp: "{spelling}".}}: {enum_name}"""

nim_type_def = """type
{classes}
"""

# The project's own copyright and licence, which every file under sources/
# carries. A GENERATED file is still a file in this repository, so it carries
# the notice naming the project's authors like any other.
nim_licence_header = '#\xa0June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray\n#\n#\xa0Licensed and distributed under the\n#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).\n#\n# This file may not be copied, modified, or distributed except according to those terms.\n'

nim_prolog_def = """{licence}
import june_common

const {juce_module_name} = "{juce_module_header}"
"""

nim_suffix_def = """

include {juce_module_name}_lifting
"""

# inheritable lifts Nim's refusal to write `object of X`; pure stops it adding
# an RTTI field to the layout. Without pure, Nim value-initialises these as
# {(&NTIv2_...)}, and C++ rejects it: JUCE's classes have no such member.
nim_class_def = """  {class_name}{export} {{.header: {juce_module_name}, importcpp: "{spelling}", inheritable, pure{by_copy}.}} = object{base}"""

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
    """The to<Type> suffix for a conversion operator's result.

    Named after what the result POINTS AT, not after the Nim spelling of the
    pointer. `ConstPtr[int16]` would otherwise give `toConstPtr[int16]`, which
    is not an identifier at all, and `constChar` would give `toConstChar` where
    the readable name is `toChar`. Naming by the pointee also means correcting
    a pointer's constness does not rename the proc.
    """
    bare = nim_type.strip()
    if bare == "constChar":
        bare = "char"
    elif bare == "constPointer":
        bare = "pointer"
    elif bare.startswith("ConstPtr[") and bare.endswith("]"):
        bare = bare[len("ConstPtr["):-1]
    bare = bare.replace("ptr ", "").replace("var ", "").strip()
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
nim_field_var_getter_def = """{comment}proc {field_name}*(this: var {class_name}): var {field_type} {{.header: {juce_module_name}, importcpp: "#.{juce_spelling}".}}{reason}"""

nim_field_setter_def = """{comment}proc `{raw_name}=`*(this: var {class_name}, value: {field_type}) {{.header: {juce_module_name}, importcpp: "#.{juce_spelling} = {value_expression}".}}{reason}"""

# Wrappers that cannot be copy-assigned, so a setter for a field of one has to
# move. Nine field setters assigned one by copy and every call was rejected:
# PopupMenu::Item::subMenu and image, FillType::gradient,
# DialogWindowLaunchOptions::content and the accessibility interfaces.
#
# A named set rather than asking libclang whether the copy assignment is
# deleted: for these it is deleted implicitly, because of a member, and that is
# not reported as a deleted method.
move_only_wrappers = ("UniquePtr[", "OptionalScopedPointer[")

# A static method has no receiver, so it takes the class as a typedesc and is
# called as Time.currentTimeMillis(). That is the spelling juce_events_lifting
# already used for MessageManager.getInstance.
nim_static_method_def = """{comment}proc {method_name}*(this: typedesc[{class_name}]{method_args}){method_return} {{.header: {juce_module_name}, importcpp: "{address_open}{qualified_name}::{juce_spelling}({juce_args}){address_close}".}}{reason}"""

# The same call with each argument cast to the type its overload declares, for
# a static method whose overloads differ only in a scalar. The leading `#` is
# the typedesc, which is compile-time only and expands to nothing: giving it a
# placeholder of its own inside the parentheses lets the ones after it line up
# with the real arguments, which is what a bare `#` per parameter could not do.
nim_static_method_cast_def = """{comment}proc {method_name}*(this: typedesc[{class_name}]{method_args}){method_return} {{.header: {juce_module_name}, importcpp: "{address_open}(#{qualified_name}::{juce_spelling}({juce_args})){address_close}".}}{reason}"""

nim_method_def = """{comment}proc {method_name}*({method_args}){method_return} {{.header: {juce_module_name}, importcpp: "{address_open}#.{juce_spelling}({juce_args}){address_close}".}}{reason}"""

# Deliberately not {.constructor.}. That pragma makes Nim emit a C++ declaration,
# `ValueTree vt(Identifier("x"))`, which C++ reads as a function declaration -
# the most vexing parse - and every later use fails with "not a structure or
# union". Without it the pattern is used and the call is an expression.
nim_constructor_def = """{comment}proc make{class_name}*({method_args}): {class_name} {{.header: {juce_module_name}, importcpp: "{spelling}({juce_args})".}}{reason}"""

#==================================================================================================

def remap_type(t, *args):
    remap_table = {
        # C++ int is 32 bits and Nim's int is 64. Mapping it to Nim's int made
        # distinct C++ overloads collapse onto the same emitted signature:
        # var(int) and var(int64) both became juce::var(NI), which g++ rejects
        # as ambiguous. C++ float is likewise 32 bits, not Nim's 64.
        # Keyed on the CANONICAL spelling, because that is what libclang
        # reports by the time this is consulted. An entry naming an alias -
        # juce_wchar, CommandID, CharPointer_UTF32::CharType - never fires,
        # and one of those hid a real bug: juce_wchar was mapped to uint32
        # here, correctly and uselessly, while the canonical wchar_t was
        # mapped to uint16 and truncated every character above U+FFFF. A
        # sentinel pass over this table found twenty-seven entries that no
        # binding ever reached; they are gone, so an unmapped type now fails
        # loudly as an unbindable one rather than resolving to a wrong width.
        "int": "cint",
        "float": "cfloat",
        "short": "int16",
        "long": "int64",
        "double": "float64",
        # 32 bits on macOS and Linux, which are the platforms this binding
        # supports. libclang resolves juce_wchar to wchar_t before the mapping
        # below is consulted, so getting this wrong truncated every character
        # above U+FFFF - String's operator[] returned 0xF600 for U+1F600
        # rather than failing. JUCE only spells CharPointer_UTF16::CharType as
        # wchar_t where wchar_t is 16-bit, which is Windows, and there it uses
        # int16 instead.
        "wchar_t": "WChar",
        # wchar_t is 32-bit on the platforms this binding supports, and JUCE
        # defines juce_wchar as wchar_t there.
        "unsigned int": "uint32",
        "unsigned char": "uint8",
        "unsigned short": "uint16",
        "unsigned long": "uint64",
        "long long": "int64",
        "unsigned long long": "uint64",
        "std::string": "CppString",
        "std::exception": "CppException",
        "std::type_index": "CppTypeIndex",
        "var": "juce_var"
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
        # Only an lvalue reference becomes var. An rvalue reference has no
        # distinct Nim spelling and is bound as the plain type, for the reason
        # the & handling further down states; giving it a var here would
        # contradict that path for class templates alone.
        prefix = ("var " if t.kind == TypeKind.LVALUEREFERENCE
                  and not target.is_const_qualified() else "")

    declaration = target.get_declaration()

    # A POINTER TO CONST keeps its constness here, where the typedef branch
    # below would otherwise drop it. `const CharType *` - how the CharPointer
    # classes spell `const char *` - reached that branch, resolved the typedef
    # to `char`, and came back as a mutable `ptr char`. The literal
    # substitutions further down never saw it, because they match the raw
    # spelling and the typedef hides the word `char`.
    #
    # Five conversion operators were bound that way, and writing through one is
    # what a caller does next: `toChar()` handed back a pointer C++ will not
    # let anyone write through, spelled as one Nim will.
    if (t.kind == TypeKind.POINTER and target.is_const_qualified()
            and declaration is not None and declaration.kind in (
                CursorKind.TYPEDEF_DECL, CursorKind.TYPE_ALIAS_DECL)):
        pointee = remap_type(declaration.underlying_typedef_type, *args)
        if pointee == "char":
            return "constChar"
        if (pointee and "<" not in pointee and "::" not in pointee
                and "(" not in pointee and not is_c_array(pointee)):
            return f"ConstPtr[{pointee}]"

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

    is_const = "const" in parts

    result = t.spelling
    # Remap common types
    result = result.replace("const void *", "kPointer")
    result = result.replace("void *", "pointer")
    result = result.replace("const char *", "kChar")
    result = result.replace("char *", "ptr char")
    # Counted here, after the replacements above and before the stars are
    # stripped, so an implicit pointer type does not get a second ptr - `char *`
    # is already "ptr char" by this point and contributes no star - while a
    # double pointer gets both. The test this replaces looked for a bare "*"
    # token in the split spelling, which missed every spelling that glues the
    # star to another word: `Component *const` and `Component **` each lost
    # their pointer entirely and bound as the class BY VALUE. MouseEvent's
    # eventComponent and originalComponent fields and StretchableLayoutManager's
    # layOutComponents were the three in JUCE's public API.
    pointer_depth = result.count("*")
    # Extract the type itself
    result = result.replace("const", "")
    result = result.replace("*", "")
    result = result.replace("&", "")
    # Replace internal june types
    result = result.replace("kPointer", "constPointer")
    result = result.replace("kChar", "constChar")
    result = result.strip()

    if "<" in result:
        # From the pointee's spelling, not from `result`: the replacements above
        # strip every star in the string, including the ones inside the angle
        # brackets, so Array<TextButton *> reached remap_template as
        # Array<TextButton> and bound an array of buttons where JUCE wants an
        # array of pointers to them. Only the outer const needs removing here;
        # the outer star and reference are already gone with the pointee.
        template_spelling = target.spelling
        if template_spelling.startswith("const "):
            template_spelling = template_spelling[len("const "):]

        # The canonical spelling as well as the written one. libclang reports a
        # nested type as the header spells it - std::optional<Style> inside
        # ProgressBar - and the table that renames an instantiation is keyed on
        # the qualified form, which is the only one that identifies it.
        canonical_spelling = target.get_canonical().spelling
        if canonical_spelling.startswith("const "):
            canonical_spelling = canonical_spelling[len("const "):]
        renamed = template_instantiation_renames.get(canonical_spelling)
        if renamed is not None:
            return f"{prefix}{renamed[0]}"

        mapped = remap_template(template_spelling, *args)
        # std::function over a const reference is a different C++ type from one
        # over a value, and where the argument holds a reference member - as
        # var::NativeFunctionArgs does - the by-value form does not compile at
        # all. The const and the & are stripped from the spelling above before
        # remap_template ever sees them, so the distinction is read here, off
        # the original.
        const_reference_argument = re.search(
            r"std::function<[^<>]*\(\s*const\s[^()*]*&\s*\)>", t.spelling)
        if (mapped is not None and const_reference_argument
                and mapped.startswith("CppFunctionObjectR1[")):
            mapped = "CppFunctionObjectR1Ref[" + mapped[len("CppFunctionObjectR1["):]
        # The void-returning form of the same thing. FileChooser::launchAsync
        # asks for a std::function over a FileChooser, which cannot be copied,
        # so the by-value type it was bound as is one C++ cannot even form.
        elif (mapped is not None and const_reference_argument
                and mapped.startswith("CppFunctionObjectN1[")):
            mapped = "CppFunctionObjectN1Ref[" + mapped[len("CppFunctionObjectN1["):]
        # Leave the C++ spelling in place when it cannot be mapped. It is not
        # valid Nim, which is exactly the signal the emit site checks in order
        # to comment the proc out.
        if mapped is not None:
            # prefix, not is_pointer alone. It carries the var for a non-const
            # reference as well as the ptr, and returning only the ptr dropped
            # the var from every reference to a class template: checkBounds
            # took its out parameter as an immutable Rectangle[cint] while JUCE
            # wrote through it.
            return f"{prefix}{mapped}"
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

    return "ptr " * pointer_depth + result

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

# Template instantiations that must not be spelled as a Nim generic, with the
# Nim type each becomes and the module that declares it.
#
# Nim collapses a `distinct cint` onto its base when it instantiates a generic,
# so CppOptional[cint] and CppOptional[ProgressBarStyle] render one C++ type -
# whichever is emitted first - and a program using both gets std::optional<int>
# where std::optional<juce::ProgressBar::Style> is wanted. That is the same
# erasure that made one Nim closure struct serve `proc(): cint` and
# `proc(): SomeEnum`, which bindEnumClosure works around for the function
# objects; a container has no such hook, so it gets a type of its own.
#
# Found by compiling both instantiations in one program. Alone, either
# compiles.
template_instantiation_renames = {
    "std::optional<juce::ProgressBar::Style>": (
        "ProgressBarStyleOptional", "juce_gui_basics"),
}

#==================================================================================================

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

    renamed = template_instantiation_renames.get(spelling.strip())
    if renamed is not None:
        return renamed[0]

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
    # Read before the const is stripped: a pointer TO a const is a different
    # C++ type from a pointer to a mutable one, and Array<const UndoableAction *>
    # bound as Array[ptr UndoableAction] names a type C++ will not convert to.
    # ConstPtr is what spells the difference in Nim.
    without_reference = spelling.replace("&", "").strip()
    points_to_const = (without_reference.endswith("*")
                       and "const" in without_reference[:without_reference.rindex("*")])

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

    if not is_pointer:
        return result
    return f"ConstPtr[{result}]" if points_to_const else f"ptr {result}"

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

# Types whose `$` the hand-written layer provides.
dollar_bound_by_lifting = {"String", "Rectangle", "Point", "CppString", "Toolbar"}

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
    "cfloat", "cdouble", "constChar", "constPointer", "WChar", "ConstPtr",
    "UniquePtr", "CppOptional", "CppVector", "CppFunctionObjectR1Ref",
    "CppFunctionObjectN1Ref",
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

# A class with no declared constructor still has no usable default one when a
# member of its own has none: C++ deletes it, and libclang reports neither the
# deletion nor the reason. The suite constructs every aggregate the generator
# emits a default constructor for, so a class that belongs here and is missing
# fails the build rather than sitting uncompiled.
no_implicit_default = {
    "ColourLayer": "holds an EdgeTable, which has no default constructor",
    "GlyphLayer": ("holds a std::variant whose first alternative is "
                   "ColourLayer, so its own default is deleted too"),
    # Seven of these are FORWARD DECLARATIONS whose definition lives in a
    # platform source file, so the header libclang reads declares the name and
    # nothing else. The reason recorded beside each is the one clang gave when
    # the constructor was actually called, not a guess.
    "AccessibilityNativeHandle": "an incomplete type; defined per platform",
    "AndroidDocumentInfoArgs": "an incomplete type; defined on Android only",
    "AndroidDocumentNativeInfo": "an incomplete type; defined on Android only",
    "FileChooserNative": "an incomplete type; defined per platform",
    "FontNative": "an incomplete type; defined per platform",
    "ImagePixelDataNativeExtensions": "an incomplete type; defined per platform",
    "TypefaceNative": "an incomplete type; defined per platform",
    "URLDownloadTask": "its operator= is deleted, so Nim cannot assign one",
}

def unbound_type_reason(rendered, member=False):
    """Why a rendered signature could not be bound.

    Two of these are not missing capability. A C array parameter always comes
    with an overload taking a String or a value, and an initializer_list always
    comes with the incremental API - add, set, appendChild - that the tests use.

    `member` says the type is a field or a static variable rather than a
    parameter. It matters for a C array: a parameter has an overload to reach
    the same call through, and a field has nothing - IPAddress::address and
    RelativePointPath's control points are only reachable as the array they
    are, so saying an overload exists would be false.
    """
    if is_c_array(rendered):
        if member:
            return ("a fixed-size C array member, which Nim cannot spell and "
                    "which no other accessor exposes")
        return ("a C array parameter; every one of these has an overload "
                "taking a String or a value instead")
    if "initializer_list" in rendered:
        return ("a std::initializer_list parameter, which Nim cannot spell; "
                "build the value with the incremental API instead")
    if "..." in rendered:
        return "a parameter pack, which has no fixed arity to give a Nim proc"
    if "enable_if" in rendered or "is_enum_v" in rendered or "is_integral_v" in rendered:
        return "a SFINAE-constrained signature, which Nim has no way to express"
    if "long double" in rendered:
        return ("a long double parameter, which Nim has no type for; the other "
                "overloads take a float or an int")
    if "detail::" in rendered:
        return ("takes a type from juce::detail, which is JUCE's own "
                "implementation; the class is obtained from the API that "
                "creates it")
    # The shapes that turn up often enough to name. The bare fallback below
    # says nothing a reader can act on, and 21 procs were sitting behind it.
    if re.search(r"\bauto\b", rendered):
        return ("a deduced return type, which cannot be spelled without "
                "instantiating the template")
    if "std::variant" in rendered:
        return "a std::variant, which Nim cannot spell"
    if "SingletonHolder" in rendered:
        return "JUCE's SingletonHolder, which is reached through the singleton it holds"
    if "ListenerList" in rendered:
        return ("a ListenerList over a nested type, which has no name outside "
                "the class; addListener and removeListener reach it")
    if "__CFString" in rendered or "CFString" in rendered:
        return "a Core Foundation type, which is not bound"
    if "nullopt_t" in rendered:
        return "std::nullopt_t, which is a tag rather than a value Nim can pass"
    if "ScopedPointer" in rendered:
        return "juce::ScopedPointer, which JUCE removed and does not define"
    if re.search(r"\(\s*pointer[^)]*\)", rendered):
        return "a C++ function pointer parameter, which the generator cannot spell"
    if "::" in rendered:
        return ("a nested or template name that survived remapping, so it is "
                "not valid Nim")
    return "a type that cannot be spelled in Nim"

# A nested class whose flattened name collides with a top-level one. Both
# juce::MessageManagerLock and juce::MessageManager::Lock flatten to
# MessageManagerLock, and the type declaration ended up naming the nested one
# while every method bound onto it came from the top-level class - so the
# constructor could not be called and the methods were attributed to a class
# that does not have them.
nested_class_renames = {
    "juce::MessageManager::Lock": "MessageManagerInnerLock",
}


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
        cpp_name = f"{cpp_prefix}::{child.spelling}"
        nim_name = nested_class_renames.get(
            cpp_name, f"{nim_prefix}{child.spelling}")
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
    # Nim spells both of these `not`: logical negation for a bool result and
    # bitwise complement otherwise. Neither collides with the built-in, which
    # is only defined for bool.
    "operator!": "`not`",
    "operator~": "`not`",
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

# C++ builtins an argument can convert to silently, so an overload set built
# only from these cannot be resolved by passing the value through.
convertible_scalars = {
    "char", "signed char", "unsigned char", "short", "unsigned short",
    "int", "unsigned int", "long", "unsigned long", "long long",
    "unsigned long long", "float", "double", "long double", "bool",
    "wchar_t", "char16_t", "char32_t", "size_t",
}


def scalar_overloaded_names(methods):
    """Method names whose overloads differ only in a scalar parameter.

    CharacterFunctions::isDigit is declared for char and for juce_wchar. An
    argument coming from Nim converts to both, so C++ reports the call as
    ambiguous and neither binding can be used. Naming these lets the emitter
    cast each argument to the type its overload declares, which picks one.
    """
    import collections

    shapes = collections.defaultdict(list)
    for method in methods:
        # Canonical, so a typedef is compared as what it stands for:
        # juce_wchar is wchar_t, and the overload it clashes with says char.
        types = [a.type.get_canonical().spelling for a in method.get_arguments()]
        shapes[(method.spelling, len(types))].append(types)

    ambiguous = set()
    for (name, _), overloads in shapes.items():
        if len(overloads) < 2:
            continue
        for position in range(len(overloads[0])):
            seen = {types[position] for types in overloads}
            # Two are enough. juce::var is declared for int, int64, bool and
            # double alongside const char* and const String&, and the scalars
            # are ambiguous among themselves whatever else is in the set.
            scalars = [t for t in seen
                       if t.replace("const ", "").strip() in convertible_scalars]
            if len(scalars) > 1:
                ambiguous.add(name)
    return ambiguous


# Declared in JUCE's headers and defined nowhere in JUCE 8.0.15. The binding
# compiles and the call fails to link, which no amount of parsing the headers
# can predict - each of these was found by linking one. One entry per class,
# holding a set, for the reason skip_class_method's own comment gives.
undefined_in_juce = {
    # NativeInfo is `struct NativeInfo;` in the header and defined only in
    # JUCE's Android sources, so it cannot be returned by value anywhere else.
    # libclang offers no reliable test for this: get_size() is negative for
    # every class template instantiation it has not laid out, which withheld
    # forty perfectly good bindings when it was tried, and asking the return
    # type's declaration whether it is a definition flags fourteen methods that
    # work - getAllComponents and getChildren among them - while missing the
    # two below entirely.
    "AndroidDocument": {"getNativeInfo"},
    # `class Native;` and `class ImagePixelDataNativeExtensions;` in their
    # headers, defined in the per-platform sources. Both were found by
    # compiling a call: "calling 'getNativeDetails' with incomplete return
    # type".
    "Font": {"getNativeDetails"},
    "ImagePixelData": {"getNativeExtensions"},
    "RelativeCoordinate": {"references"},
    # JUCE keeps the removed shape of these as a [[deprecated]] declaration
    # with no definition, so a call compiles and the link fails. An entry can
    # name one overload rather than the method, because the replacement sits
    # beside it: Slider::setValue(double, NotificationType) is the one to use
    # and works.
    #
    # Measured by linking, not derived. 46 methods carry [[deprecated]] and 22
    # of those have a non-deprecated sibling, but only these eleven are
    # undefined - the rest are deprecated and still implemented, and
    # withholding them on either rule would take working bindings with them.
    "Slider": {
        ("setValue", ("double", "bool")),
        ("setValue", ("double", "bool", "bool")),
        ("setMinValue", ("double", "bool")),
        ("setMinValue", ("double", "bool", "bool")),
        ("setMinValue", ("double", "bool", "bool", "bool")),
        ("setMaxValue", ("double", "bool")),
        ("setMaxValue", ("double", "bool", "bool")),
        ("setMaxValue", ("double", "bool", "bool", "bool")),
        ("setMinAndMaxValues", ("double", "double", "bool")),
        ("setMinAndMaxValues", ("double", "double", "bool", "bool")),
    },
    "ListBox": {("setSelectedRows", ("const SparseSet<int> &", "bool"))},
    "RelativePointPathQuadraticTo": {"createTree"},
    "RelativePointPathCubicTo": {"createTree"},
}


def skip_class_method(class_name, method_name):
    # One entry per class, holding a set. A dict of class to a single method
    # name loses every entry but the last for a class named more than once, and
    # `in` against the surviving string is a substring test rather than a
    # membership test, so a method whose name is a prefix of another is skipped
    # by accident.
    skip_table = {
        # Returns AbstractFifo::ScopedRead / ScopedWrite, neither of which is
        # bound as a type, so the binding would name something that does not
        # exist on the Nim side.
        "AbstractFifo": {"read", "write"},
        # A plain C++ function pointer. juce_core_lifting binds it by hand.
        "SystemStats": {"setApplicationCrashHandler"},
        # A plain C++ function pointer, which the generator cannot spell.
        # juce_events_lifting binds it by hand.
        "MessageManager": {"callFunctionOnMessageThread"},
        # Slider::Listener is an alias for the class template
        # SliderListener<Slider>. juce_gui_basics_lifting binds the type
        # through the alias and these two along with it.
        "Slider": {"addListener", "removeListener"},
        # Return an Iterator over a private traits type, which has no name
        # outside the class. juce_core_lifting has the equivalent iterators.
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

def is_template_specialization(cursor):
    """Whether this class is an explicit specialization of a class template.

    libclang reports one as an ordinary STRUCT_DECL carrying the template's
    bare name, so the generator bound juce::VariantConverter<String> as a class
    called VariantConverter and emitted its statics. C++ then refuses the call:
    "use of class template 'juce::VariantConverter' requires template
    arguments". get_num_template_arguments answers -1 for a class that is not
    one and the count for a class that is, which separates them exactly.
    """
    try:
        return cursor.get_num_template_arguments() >= 0
    except Exception:
        return False

#==================================================================================================

def public_bases(cursor):
    """The public base classes of a class, as cursors.

    Read off the cursor rather than looked up by name. JUCE gives many nested
    classes the name LookAndFeelMethods and LookAndFeel inherits most of them,
    so a table keyed on the bare spelling collapses them into one and loses
    every drawing hook but the first.
    """
    if cursor is None:
        return []
    return [node.referenced for node in cursor.get_children()
            if node.kind == CursorKind.CXX_BASE_SPECIFIER
            and node.access_specifier == AccessSpecifier.PUBLIC
            and node.referenced is not None]

#==================================================================================================

def reachable_public_methods(cursor, seen=None):
    """Public methods of a class and of everything it publicly inherits.

    Returns name -> list of (owner USR, cursor). A name reaching the class down
    two different base branches has more than one owner and is ambiguous in C++
    when called unqualified. A name the class redeclares shadows the base's, so
    an override keeps a single owner and stays callable - which is why the test
    is on owners rather than on how many declarations were seen.

    Each branch recurses with its own visited set, so a name arriving twice
    through a diamond is reported as the two arrivals it is rather than pruned
    to one and wrongly emitted.
    """
    seen = set() if seen is None else seen
    found = {}
    if cursor is None:
        return found
    usr = cursor.get_usr()
    if usr in seen:
        return found
    seen = seen | {usr}

    for x in cursor.get_children():
        if (x.kind == CursorKind.CXX_METHOD
                and x.access_specifier == AccessSpecifier.PUBLIC
                and x.spelling):
            found.setdefault(x.spelling, []).append((usr, x))

    declared_here = set(found)
    for b in public_bases(cursor):
        for name, entries in reachable_public_methods(b, seen).items():
            if name in declared_here:
                continue
            found.setdefault(name, []).extend(entries)
    return found

#==================================================================================================

def non_copyable_type_names(translation_unit):
    """Names of types with no accessible copy constructor.

    Read from the definitions, and from the CLASS_TEMPLATE among them: asking
    an instantiation for its constructors gives nothing, because libclang has
    not laid one out. OwnedArray<Run> answers "no constructors" and reads as
    copyable, while the template it came from deletes the copy.
    """
    found = set()

    def visit(cursor):
        for child in cursor.get_children():
            if (child.kind in (CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL,
                               CursorKind.CLASS_TEMPLATE)
                    and child.is_definition() and child.spelling):
                copies = [x for x in child.get_children()
                          if x.kind == CursorKind.CONSTRUCTOR
                          and x.is_copy_constructor()]
                if copies and not any(
                        x.access_specifier == AccessSpecifier.PUBLIC
                        and not x.is_deleted_method() for x in copies):
                    found.add(child.spelling)
            visit(child)

    visit(translation_unit.cursor)
    return found

#==================================================================================================

def type_is_copyable(field_type, non_copyable):
    """Whether a value of this type can be copied.

    A field whose type cannot be copied has no by-value getter and no setter:
    both compile until something calls them, and then neither does. OwnedArray
    deletes its copy constructor, so TextLayoutLine's runs and
    RelativePointPath's elements could only ever be reached through the var
    getter that hands back the field itself.
    """
    declaration = field_type.get_declaration()
    if declaration is None or not declaration.spelling:
        return True
    return declaration.spelling not in non_copyable

#==================================================================================================

def using_declaration_members(cursor):
    """Members a class hands back out of a base with a using-declaration.

    A class that inherits privately is not a subtype, so nothing of the base
    comes with it - except what it re-exports this way, which IS callable.
    TimedCallback re-exports five Timer methods and ResizableWindow re-exports
    Component::addToDesktop.

    The declaration carries the member's name and a TYPE_REF naming the class
    it comes from, and is resolved by name against that class. Its
    OVERLOADED_DECL_REF child would say the same thing, but reading one needs a
    libclang method the pip package does not expose.
    """
    found = []
    for using in cursor.get_children():
        if (using.kind != CursorKind.USING_DECLARATION
                or using.access_specifier != AccessSpecifier.PUBLIC):
            continue
        for reference in using.get_children():
            if reference.kind != CursorKind.TYPE_REF:
                continue
            origin = reference.type.get_declaration()
            if origin is None:
                continue
            found += [x for x in origin.get_children()
                      if x.kind == CursorKind.CXX_METHOD
                      and x.spelling == using.spelling
                      and x.access_specifier == AccessSpecifier.PUBLIC]
    return found

#==================================================================================================

def method_signature(cursor):
    """A method's identity: name, arguments, constness and return type.

    The return type is part of it because C++ allows a covariant override, and
    dropping one as a duplicate would hand the caller the base's type instead:
    TableListBox::getModel returns a TableListBoxModel where ListBox::getModel
    returns a ListBoxModel, and the derived one is the whole point of calling
    it on a TableListBox.
    """
    # Canonical spellings, because the same type is written differently
    # depending on where it is declared: PopupMenu::LookAndFeelMethods spells
    # its parameter "const Options &" and LookAndFeel_V2 spells the same one
    # "const PopupMenu::Options &". Comparing the written form left that pair
    # looking like two different methods and both were emitted.
    return (cursor.spelling,
            tuple(a.type.get_canonical().spelling for a in cursor.get_arguments()),
            cursor.is_const_method(),
            cursor.result_type.get_canonical().spelling)

#==================================================================================================

def restated_members(cursor, class_map):
    """Methods this class needs restated because Nim cannot inherit them.

    Nim carries one parent and C++ carries as many as it likes, so everything
    reachable through a public base that is not the Nim parent is unreachable
    unless it is written onto the class itself. The C++ call is identical - the
    base is public either way - so restating changes only whether Nim can see
    it.
    """
    chosen = primary_base(cursor, class_map)
    already_reachable = (set(reachable_public_methods(chosen))
                         if chosen is not None else set())
    declared_here = {x.spelling for x in cursor.get_children()
                     if x.kind == CursorKind.CXX_METHOD}
    declared_here |= {x.spelling for x in using_declaration_members(cursor)}

    found = []
    for b in public_bases(cursor):
        if chosen is not None and b.get_usr() == chosen.get_usr():
            continue
        for name, entries in sorted(reachable_public_methods(b).items()):
            if name in already_reachable or name in declared_here:
                continue
            # Declared by two different classes among the bases, so an
            # unqualified call is ambiguous in C++ as well. Leaving it out is
            # what the C++ compiler would say about it.
            if len({owner for owner, _ in entries}) > 1:
                continue
            found += [member for _, member in entries]
    return found

#==================================================================================================

def declared_by_an_ancestor(cursor, member, class_map):
    """Whether a Nim ancestor already declares this exact method.

    An override has the same parameter types as the virtual it overrides, so
    emitting both gives Nim two procs differing only in the receiver. Called on
    the derived class itself the nearer one wins, but called on anything below
    it neither is nearer and 2.2.2 calls it ambiguous: `paint` on a
    TableListBox matched both ListBox's and Component's and could not be
    called at all. 51 pairs were in that state.

    Dropping the derived copy loses nothing. The base proc accepts the derived
    receiver, and the C++ it emits is a call on the object, which dispatches
    virtually to whichever override the object actually has.

    Both what an ancestor declares itself and what it restates from a secondary
    base count, since both are emitted as procs on the ancestor.
    """
    if member.is_static_method():
        # A static's receiver is typedesc[X], which does not inherit.
        return False

    wanted = method_signature(member)
    ancestor = primary_base(cursor, class_map)
    seen = set()
    while ancestor is not None and ancestor.get_usr() not in seen:
        seen.add(ancestor.get_usr())
        declared = [x for x in ancestor.get_children()
                    if x.kind == CursorKind.CXX_METHOD
                    and x.access_specifier == AccessSpecifier.PUBLIC]
        declared += using_declaration_members(ancestor)
        declared += restated_members(ancestor, class_map)
        if any(method_signature(x) == wanted for x in declared):
            return True
        ancestor = primary_base(ancestor, class_map)
    return False

#==================================================================================================

def primary_base(cursor, class_map):
    """The public base that becomes the Nim parent: the one reaching the most.

    Nim has one parent and C++ has as many as it likes, so this choice decides
    which half of the API is inherited and which half has to be restated on the
    class itself. Taking the first base declared bound TextEditor as a
    TextInputTarget and put the whole of Component out of reach - no setBounds,
    no repaint.
    """
    candidates = [b for b in public_bases(cursor)
                  if b.spelling in class_map and b.spelling != cursor.spelling]
    if not candidates:
        return None
    return max(candidates, key=lambda b: len(reachable_public_methods(b)))

#==================================================================================================

def passed_by_value_to_a_virtual(index, juce_args, base_path):
    """Classes JUCE passes BY VALUE into a virtual, which must not be pointers.

    `inheritable` makes Nim hand an object over as a pointer, which is right
    for the classes a generated subclass overrides but wrong for a small value
    a virtual takes by value: the closure's C signature then says Colour* where
    the std::function says Colour, and the assignment does not compile.
    TreeView::LookAndFeelMethods was withheld for exactly that. `bycopy` says
    to pass the value, which is what C++ does with it anyway.

    Computed rather than listed, so a JUCE upgrade that adds one is covered.
    The generic types this also finds - Point and Rectangle - are declared by
    hand in june_juce_types and are unaffected by what is returned here.

    Read from juce_gui_basics whichever module is being generated, because it
    includes the other four and the two ends of this relation are rarely in the
    same one: Colour is declared in juce_graphics and passed by value to a
    virtual in juce_gui_basics, so a per-module parse finds neither end.
    """
    found = set()
    translation_unit = index.parse(
        os.path.join(base_path, "JUCE/modules/juce_gui_basics/juce_gui_basics.h"),
        args=juce_args)

    def visit(cursor):
        for child in cursor.get_children():
            if (child.kind in (CursorKind.CLASS_DECL, CursorKind.STRUCT_DECL)
                    and child.is_definition()):
                for member in child.get_children():
                    if (member.kind != CursorKind.CXX_METHOD
                            or not member.is_pure_virtual_method()):
                        continue
                    for argument in member.get_arguments():
                        declaration = argument.type.get_declaration()
                        if (declaration is not None and declaration.spelling
                                and declaration.kind in (CursorKind.CLASS_DECL,
                                                         CursorKind.STRUCT_DECL)):
                            found.add(declaration.spelling)
            visit(child)

    visit(translation_unit.cursor)
    return found

#==================================================================================================

# Nested namespaces inside juce:: that JUCE keeps private. Everything else
# nested there is either template machinery with nothing to bind or real API:
# juce::Colours holds 286 named colours and juce::StandardApplicationCommandIDs
# holds the ids ApplicationCommandManager expects.
private_namespaces = {"detail", "internal"}


def nested_namespaces(juce_namespace):
    """The juce:: sub-namespaces whose public constants and functions bind."""
    found = []
    seen = set()
    for entry in juce_namespace:
        for node in entry.get_children():
            if (node.kind == CursorKind.NAMESPACE and node.spelling
                    and node.spelling not in private_namespaces
                    and node.spelling not in seen):
                seen.add(node.spelling)
                found.append(node)
            elif node.kind == CursorKind.NAMESPACE and node.spelling in seen:
                found.append(node)
    return found

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

    # The include as the GENERATED FILE will spell it. Angle brackets, so it
    # resolves against the C++ include path rather than against the location
    # of whichever nimcache file happens to include it. nim.cfg puts
    # JUCE/modules on that path; a consumer whose JUCE lives elsewhere
    # changes that one line instead of regenerating five binding modules.
    juce_module_header = f"<{juce_module_name}/{juce_module_name}.h>"
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

    # And the ones a nested namespace holds. juce::Colours::findColourForName is
    # the only one today. Its Nim name and its C++ spelling both carry the
    # namespace, so the emit loop below reads the prefix off the cursor rather
    # than assuming juce:: throughout.
    for namespace in nested_namespaces(juce_namespace):
        all_functions += [node for node in namespace.get_children()
                          if node.kind == CursorKind.FUNCTION_DECL]

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
        # From the declaration rather than the written type. Stripping const and
        # & off the spelling leaves the template arguments attached, so a free
        # == on a class template was recorded under "RangedValuesIterator<T>"
        # and matched nothing. No bound class is affected today; the spelling
        # is simply not where a type's name lives.
        first = arguments[0].type
        if first.kind in (TypeKind.LVALUEREFERENCE, TypeKind.RVALUEREFERENCE):
            first = first.get_pointee()
        declaration = first.get_declaration()
        if declaration is not None and declaration.spelling:
            classes_with_free_equality.add(
                remap_class_name(declaration.spelling))

    # Extract all juce classes
    all_classes = []
    for entry in juce_namespace:
        all_classes += [node for node in filter(
            lambda x: x.kind == CursorKind.CLASS_DECL or x.kind == CursorKind.STRUCT_DECL, entry.get_children())]

    by_value_classes = passed_by_value_to_a_virtual(index, juce_args, base_path)
    non_copyable = non_copyable_type_names(translation_unit)


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
        # PUBLIC bases only. A private base is not a subtype anywhere outside
        # the class, so modelling one as the Nim parent offers every method it
        # declares and the C++ compiler refuses each call: triggerAsyncUpdate
        # on an ApplicationCommandManager is "a private member of AsyncUpdater".
        # Nothing called them, so nothing said so. Fourteen classes inherited
        # this way, thirteen of them having no public base at all - those now
        # have no Nim parent, which is what they always were.
        bases = [node.referenced for node in filter(
            lambda x: (x.kind == CursorKind.CXX_BASE_SPECIFIER
                       and x.access_specifier == AccessSpecifier.PUBLIC),
            c.get_children())]

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
        "licence": nim_licence_header,
        "juce_module_name": juce_module_name,
        "juce_module_header": juce_module_header }))

    # Every class goes in a single type section. Nim resolves references within
    # one section regardless of order, which is what makes it possible to emit
    # inheritance at all: a class routinely names a base declared further down
    # the header, and there is no ordering of separate type sections that
    # satisfies every such pair.
    all_class_decls = []
    emitted_enum_names = []
    # A C++ SCOPED enum (`enum class`) does not convert to int on its own, so a
    # borrowed `$` emits dollar_(int32) over a value clang will not narrow and
    # fails at the call site - the same only-when-called shape as every other
    # defect on this branch. These get an explicit static_cast instead.
    scoped_enum_names = set()
    for c in module_classes:
        if juce_class_name_to_export is not None and c.spelling != juce_class_name_to_export:
            continue
        if is_template_specialization(c):
            continue
        if c.spelling.startswith("this_will_fail_to_link") or c.spelling in emitted_types:
            continue
        emitted_types.add(c.spelling)

        class_name = remap_exported_class_name(c.spelling)

        # Nim has one parent and C++ has as many as it likes, so where a class
        # has several public bases the choice decides what stays reachable.
        # Taking the first one declared bound TextEditor as a TextInputTarget
        # and put the whole of Component out of reach - no setBounds, no
        # repaint, a text box that cannot be placed. Take the base that reaches
        # the most instead, which loses the least in every case: TextEditor
        # gives up TextInputTarget's 13 methods rather than Component's 203,
        # and the other two classes this moves - KeyPressMappingSet and
        # RelativeCoordinatePositionerBase - improve the same way.
        chosen = primary_base(c, class_map)
        base = remap_exported_class_name(chosen.spelling) if chosen else None

        all_class_decls.append(nim_class_def.format(**{
            "class_name": class_name,
            "spelling": f"juce::{c.spelling}",
            "juce_module_name": juce_module_name,
            "export": "*" if class_is_exported(c.spelling) else "",
            "by_copy": ", bycopy" if c.spelling in by_value_classes else "",
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
                "by_copy": "",
                "base": "" }))

    # The instantiations that get a type of their own rather than a Nim
    # generic. Declared here so the module that uses them declares them.
    for cpp_spelling, (nim_name, owning_module) in sorted(
            template_instantiation_renames.items()):
        if owning_module != juce_module_name:
            continue
        all_class_decls.append(
            f'  {nim_name}* {{.header: "<optional>", '
            f'importcpp: "{cpp_spelling}", bycopy.}} = object')
        declared_type_names.add(nim_name)

    for enum_name, enum_cursor, owner in module_enums:
        qualified = f"juce::{owner}::{enum_cursor.spelling}" if owner else f"juce::{enum_cursor.spelling}"
        emitted_enum_names.append(enum_name)
        if enum_cursor.is_scoped_enum():
            scoped_enum_names.add(enum_name)
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

    if emitted_enum_names:
        # An enum is a distinct cint, so it has none of cint's operators unless
        # they are given to it. Without this, comparing two enum values needs a
        # cast on both sides, which is what every caller would end up writing.
        # `borrow` takes the base type's == rather than binding a C++ one,
        # because the values are already the C++ enumerators.
        print("# Comparison for the enums above, taken from their base type,")
        print("# and $ so a value can appear in a message. $ prints the number")
        print("# rather than the name: the binding holds the C++ enumerator and")
        print("# there is no table of names on this side to look one up in.")
        print("#")
        print("# A scoped enum - `enum class` in C++ - does not convert to int")
        print("# on its own, so a borrowed $ emits dollar_(int32) over a value")
        print("# clang refuses to narrow, and the error appears at the call")
        print("# site rather than here. Those get toCint, which does the")
        print("# static_cast C++ requires, and a $ written over it.")
        for enum_name in emitted_enum_names:
            print(f"proc `==`*(a: {enum_name}, b: {enum_name}): bool {{.borrow.}}")
            if enum_name in scoped_enum_names:
                # The parameter is called `this` so the compile harness treats
                # toCint as a method and calls it. Named anything else it is a
                # free function to the harness, which skips those - and an
                # importcpp nothing calls is an importcpp nothing compiles.
                print(f"proc toCint*(this: {enum_name}): cint "
                      f"{{.header: {juce_module_name}, "
                      f'importcpp: "static_cast<int>(#)".}}')
                print(f"proc `$`*(value: {enum_name}): string = $value.toCint()")
            else:
                print(f"proc `$`*(value: {enum_name}): string {{.borrow.}}")
        print()

        # JUCE spells a flag set as a nested enum called Flags, which this
        # flattens to a name ending in Flags. Those are the ones meant to be
        # combined, and a distinct cint has no bitwise operators either, so
        # every caller would otherwise cast both sides to cint and back.
        flag_enums = [name for name in emitted_enum_names if name.endswith("Flags")]
        if flag_enums:
            print("# Bitwise operators for the flag sets among them.")
            for enum_name in flag_enums:
                for operator in ("or", "and"):
                    print(f"proc `{operator}`*(a: {enum_name}, b: {enum_name}): "
                          f"{enum_name} {{.borrow.}}")
            print()

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

        if is_template_specialization(c):
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
        # A deleted constructor is declared and cannot be called. JUCE deletes
        # them on its static-only helpers - JSONUtils, OrderedContainerHelpers
        # - and the generator emitted a makeX for each, which no call could
        # compile.
        def constructor_is_deleted(constructor):
            try:
                return constructor.is_deleted_method()
            except AttributeError:
                return False

        public_constructors = [x for x in c.get_children()
                               if x.kind == CursorKind.CONSTRUCTOR
                               and x.access_specifier == AccessSpecifier.PUBLIC
                               and not constructor_is_deleted(x)]

        # juce::var declares one constructor per numeric type, and Nim's int64
        # is not long long on every platform, so g++ could not pick between
        # var(int), var(int64) and var(double) while clang could. The cast that
        # fixes an overloaded method fixes an overloaded constructor too.
        scalar_overloaded_ctors = scalar_overloaded_names(public_constructors)

        # An abstract class cannot be allocated, so a constructor for one is a
        # binding that looks usable and is a compile error at every call. The
        # generated Custom<Name> subclass in the _subclasses file is what a
        # caller wants instead.
        try:
            class_is_abstract = c.is_abstract_record()
        except AttributeError:
            class_is_abstract = False

        # A class that declares no constructor at all still has C++'s implicit
        # default one, and the generator emitted nothing for it: 16 types were
        # declared with readable and writable fields and no way to build one -
        # ZipFile::ZipEntry, MouseWheelDetails, DirectoryContentsList::FileInfo,
        # ThreadPool::Options and the rest. A class with a private or protected
        # constructor is a different case and stays out, because it names one.
        all_constructors = [x for x in c.get_children()
                            if x.kind == CursorKind.CONSTRUCTOR]
        has_public_field = any(x.kind == CursorKind.FIELD_DECL
                               and x.access_specifier == AccessSpecifier.PUBLIC
                               for x in c.get_children())
        # A class with no declared constructors and no pure virtuals is
        # default-constructible in C++ whether or not its fields are public;
        # requiring a public field only found the AGGREGATES. It left the
        # option structs out, and an option struct nothing can build makes
        # every proc that takes one unreachable - drawFittedText,
        # JSON's toString, startRealtimeThread and DatagramSocket's
        # constructor were all in that position.
        #
        # Some of these C++ still deletes, usually because a member is not
        # default-constructible. That only shows at the `new`, so each is
        # listed in no_implicit_default once the build finds it, and the
        # coverage gate requires a test to construct every one that stays.
        if (not all_constructors and not class_is_abstract
                and class_name not in no_implicit_default
                and c.spelling not in no_implicit_default):
            declaration = nim_constructor_def.format(**{
                "comment": "", "class_name": class_name, "method_args": "",
                "juce_module_name": juce_module_name,
                "spelling": qualified_name, "juce_args": "@",
                # Marked, so check_handwritten_covered.py can require a test to
                # build each one. Two of these turned out to have a default
                # constructor C++ deletes, which only a call reveals.
                "reason": "  # implicit default constructor"})
            signature = (f"make{class_name}", ())
            if (declaration not in emitted_declarations
                    and signature not in emitted_signatures):
                emitted_declarations.add(declaration)
                emitted_signatures.add(signature)
                print(declaration)

        for ctor in public_constructors:
            ctor_args, ctor_types, ctor_comment = [], [], ""
            ctor_cpp_types = []
            for count, arg in enumerate(ctor.get_arguments()):
                argument_type = remap_type(arg.type, remap_inner_classes, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)
                ctor_args.append(f"{remap_argument_name(arg.spelling, count)}: {argument_type}")
                ctor_types.append(argument_type)
                ctor_cpp_types.append(arg.type.get_canonical().spelling)

            # A constructor has no receiver, so `@` is the whole argument list
            # and only a single-argument one can be cast as a unit.
            # One bare `#` per parameter, so each argument carries the type its
            # overload declares. A constructor has no typedesc to swallow the
            # first placeholder, which is what limited the static form, so
            # arity makes no difference here.
            if ctor_cpp_types and ctor.spelling in scalar_overloaded_ctors:
                ctor_juce_args = ", ".join(f"({cpp_type}) #"
                                           for cpp_type in ctor_cpp_types)
            else:
                ctor_juce_args = "@"

            ctor_reason = ""
            if class_is_abstract:
                ctor_comment = "# "
                ctor_reason = (f"{class_name} is abstract; build a "
                               f"Custom{class_name} instead")

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
                "juce_args": ctor_juce_args,
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
                var_reason = unbound_type_reason(var_type, member=True)

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
                field_reason = unbound_type_reason(field_type, member=True)

            # A field that is a POINTER TO CONST keeps its constness in the
            # GETTERS, for the reason the return-type rule below states: C++
            # does not convert `const T*` to `T*`, so a getter that drops the
            # const does not compile where anything reads it.
            # var::NativeFunctionArgs holds its arguments as `const var*`, and
            # both of its getters named `var*`.
            #
            # The setter keeps `ptr T`, because THAT conversion is the one C++
            # does make: assigning a `T*` into a `const T*` field is legal, and
            # a caller almost always has the mutable pointer in hand.
            setter_field_type = field_type
            if (field.type.kind == TypeKind.POINTER
                    and field.type.get_pointee().is_const_qualified()
                    and field_type.startswith("ptr ")):
                field_type = f"ConstPtr[{field_type[len('ptr '):]}]"

            field_name = remap_identifier(field.spelling)
            # Also keyed the way a method is: a class with a field and a
            # method of the same name would otherwise emit both.
            field_signature = (f"this: {class_name}", field_name, (), f": {field_type}")
            if field_signature in emitted_signatures:
                continue
            emitted_signatures.add(field_signature)

            # A field that IS a non-const reference aliases something the
            # owner does not own, so handing back a copy of the referent is
            # wrong twice over: writes through it are lost, and the copy does
            # not compile at all when the referent is non-copyable. Bind the
            # reference itself instead. DirectoryContentsDisplayComponent's
            # directoryContentsList is the one such field JUCE exports, and
            # DirectoryContentsList is non-copyable.
            binds_reference = (field.type.kind == TypeKind.LVALUEREFERENCE
                               and not field.type.get_pointee().is_const_qualified())

            # A field whose type has no accessible copy constructor cannot be
            # handed back by value or assigned. Both stay as comments with the
            # reason rather than being dropped, so what is missing is visible
            # where the var getter that does work sits beside them.
            field_copyable = type_is_copyable(field.type, non_copyable)
            value_comment, value_reason = field_comment, field_reason
            if not field_copyable:
                value_comment = "# "
                value_reason = value_reason or (
                    f"{field_type.replace('var ', '')} has no accessible copy "
                    f"constructor, so it can only be reached through the var "
                    f"getter below")

            if not binds_reference:
                print(nim_field_getter_def.format(**{
                    "comment": value_comment, "field_name": field_name,
                    "class_name": class_name, "field_type": field_type.replace("var ", ""),
                    "juce_module_name": juce_module_name, "juce_spelling": field.spelling,
                    "reason": f"  # {value_reason}" if value_comment else "" }))

            # A second getter returning var, so a container field can be
            # mutated in place: box.items.add(x) works on the field itself,
            # where the by-value getter above hands back a copy. Same C++
            # expression; Nim picks by whether the receiver is mutable. For a
            # reference field it is the only getter.
            # is_reference, not an ampersand anywhere in the spelling: a field
            # whose type is std::function<void (const ArgumentList &)> carries
            # one inside the template argument, and reading it that way left
            # ConsoleApplicationCommand::command with no setter - readable, and
            # impossible to install.
            is_reference = field.type.kind in (TypeKind.LVALUEREFERENCE,
                                               TypeKind.RVALUEREFERENCE)
            if binds_reference or not (field.type.is_const_qualified()
                                       or is_reference):
                print(nim_field_var_getter_def.format(**{
                    "comment": field_comment, "field_name": field_name,
                    "class_name": class_name, "field_type": field_type.replace("var ", ""),
                    "juce_module_name": juce_module_name, "juce_spelling": field.spelling,
                    "reason": f"  # {field_reason}" if field_comment else "" }))

            # No setter for a field C++ will not let anyone assign: a const one,
            # a reference, which binds once and cannot be repointed, or one
            # whose type has no copy constructor to assign through.
            if not (field.type.is_const_qualified() or is_reference):
                print(nim_field_setter_def.format(**{
                    "value_expression": ("std::move(#)"
                                         if field_type.startswith(move_only_wrappers)
                                         else "#"),
                    "comment": value_comment, "raw_name": field.spelling,
                    "class_name": class_name,
                    "field_type": setter_field_type.replace("var ", ""),
                    "juce_module_name": juce_module_name, "juce_spelling": field.spelling,
                    "reason": f"  # {value_reason}" if value_comment else "" }))

        class_bound_equality = False
        class_has_to_string = False

        # A class that inherits privately can still hand individual members
        # back out with a using-declaration, and those ARE callable even though
        # the base is not a subtype: TimedCallback inherits Timer privately and
        # re-exports five of its methods that way. The base is not modelled as
        # the Nim parent - it is not one - so pick the re-exported members up
        # here and emit them as methods of this class.
        class_members = list(c.get_children())
        class_members += using_declaration_members(c)

        inherited_members = set()
        for member in restated_members(c, class_map):
            inherited_members.add(member.get_usr())
            class_members.append(member)

        scalar_overloaded = scalar_overloaded_names(
            [x for x in class_members
             if x.kind == CursorKind.CXX_METHOD
             and x.access_specifier == AccessSpecifier.PUBLIC])

        for m in filter(lambda x: x.kind == CursorKind.CXX_METHOD, class_members):
            if m.access_specifier != AccessSpecifier.PUBLIC:
                continue

            if m.spelling in ["JUCE_DEPRECATED", "JUCE_DEPRECATED_STATIC"]:
                continue

            # An override of something a Nim ancestor already declares. Emitting
            # it here would give Nim two procs with identical parameter types
            # differing only in the receiver, which 2.2.2 rejects as ambiguous
            # for any receiver below the derived class. The base proc accepts
            # this receiver and C++ dispatches it virtually, so nothing is lost.
            if (m.get_usr() not in inherited_members
                    and declared_by_an_ancestor(c, m, class_map)):
                continue

            is_static_method = m.is_static_method()
            is_const_method = m.is_const_method()

            comment = ""

            # A method JUCE deletes. It is declared so that calling it is an
            # error rather than silently reaching an overload that means
            # something else: Component::contains(int, int) is deleted because
            # the two-coordinate form was removed and the Point one is what to
            # use. A binding for it compiles and fails at the call.
            deleted_reason = "JUCE deletes it" if m.is_deleted_method() else ""
            if deleted_reason:
                comment = "# "

            # A static method's receiver is the class itself rather than a
            # value, so it carries no `this` argument into the C++ call.
            args = ([] if is_static_method
                    else [f"this: {'' if is_const_method else 'var '}{class_name}"])
            argument_types = []
            cpp_argument_types = []
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
                # Canonical, because the cast has to name a type that resolves
                # where the generated call sits - juce_wchar does not.
                cpp_argument_types.append(arg.type.get_canonical().spelling)

            reason = deleted_reason
            return_type = ""
            returns_address = False
            if m.result_type.spelling != "void":
                rendered_return = remap_type(
                    m.result_type, remap_inner_classes, enum_remap,
                    class_juce_map, global_nested_remap,
                    unambiguous_nested_remap)
                # A pointer to const is not a ptr. C++ does not convert
                # `const T*` to `T*`, so every one of these was a proc that
                # could not be called - and nothing noticed, because an
                # importcpp string only reaches the C++ compiler at a call
                # site. ConstPtr, in june_common, is the spelling that both
                # compiles and keeps the const.
                #
                # Only the return position. A `const T*` parameter takes a
                # plain `ptr T` already, because that conversion is the one
                # C++ does make.
                # A return type that C++ only forward declares cannot be
                # returned by value: AndroidDocument::NativeInfo is declared
                # and defined nowhere in the header, and the binding for
                # getNativeInfo is a compile error at every call site.
                if (m.result_type.kind == TypeKind.POINTER
                        and m.result_type.get_pointee().is_const_qualified()
                        and rendered_return.startswith("ptr ")):
                    rendered_return = (
                        f"ConstPtr[{rendered_return[len('ptr '):]}]")

                # A CONST REFERENCE to something that cannot be copied is a
                # pointer. A non-const `T&` already renders as `var T`, which
                # is a real reference: a caller reaches through it without
                # copying anything. A const one renders as a plain `T`, which
                # means "a copy of the referent" - a fine thing to want only
                # when T can be copied. For an abstract class, or one whose
                # copy constructor is deleted (every class carrying
                # JUCE_DECLARE_NON_COPYABLE), that copy is a compile error at
                # every call site, and `discard` hides it: a discarded call
                # constructs nothing, so the compile harness passed while the
                # binding could not be used for anything at all.
                #
                # The var getter for a field already had this treatment
                # (type_is_copyable); the return type of a method did not.
                if (m.result_type.kind == TypeKind.LVALUEREFERENCE
                        and not rendered_return.startswith("var ")):
                    referent = m.result_type.get_pointee()
                    referent_declaration = referent.get_declaration()
                    if (referent_declaration is not None
                            and referent_declaration.spelling
                            and (not type_is_copyable(referent, non_copyable)
                                 or (referent_declaration.is_definition()
                                     and referent_declaration.kind in (
                                         CursorKind.CLASS_DECL,
                                         CursorKind.STRUCT_DECL)
                                     and referent_declaration
                                         .is_abstract_record()))):
                        rendered_return = f"ConstPtr[{rendered_return}]"
                        # C++ hands back a reference; the Nim type is now a
                        # pointer, so the emitted expression has to take its
                        # address. Nim does not do that on its own, and
                        # without it the call is a conversion error at every
                        # call site rather than a copy error.
                        returns_address = True
                return_type = f": {rendered_return}"

            if m.result_type.spelling in ["CFStringRef", "OSType"]:
                comment, reason = "# ", "a platform type with no Nim spelling"

            if (m.spelling in ["begin", "end", "cbegin", "cend"]
                    or m.spelling.endswith("Iterator")):
                comment, reason = "# ", "a C++ iterator; loop with the Nim iterator instead"
            elif (m.spelling in undefined_in_juce.get(class_name, ())
                    or (m.spelling, tuple(a.type.spelling
                                          for a in m.get_arguments()))
                        in undefined_in_juce.get(class_name, ())):
                comment = "# "
                reason = ("declared in JUCE's header and defined nowhere in "
                          "JUCE 8.0.15, so calling it fails to link")
            elif skip_class_method(class_name, m.spelling):
                comment, reason = "# ", "excluded deliberately: see skip_class_method"

            # A C++ template or a nested name that survived remapping is not
            # valid Nim and would break the whole module, so emit the proc as a
            # comment. It stays visible as work still to do.
            # Check the types only. Argument names are not types, and a default
            # value is not either: reading "ignoreCase: bool = false" as a type
            # made "false" look like an undeclared name and commented out every
            # proc that had one.
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

            # An overload set that differs only in a scalar parameter needs each
            # argument cast to the type this overload declares, or C++ cannot
            # tell which one the call means.
            has_arguments = len(args) > (0 if is_static_method else 1)
            # Either reason to write one placeholder per parameter rather than
            # `@`. A static method needs the parenthesised form when it does,
            # because its typedesc consumes the first placeholder and expands
            # to nothing.
            # An rvalue reference will not bind to an lvalue, and Nim hands
            # over an lvalue, so a parameter declared `T&&` needs the move as
            # much as a move-only wrapper does. Three of the four JUCE methods
            # with one also declare a const-reference overload, which the two
            # collapse onto, so only ConsoleApplication::invokeCatchingFailures
            # was uncallable.
            def moves(nim_type, cpp_type):
                return (nim_type.startswith(move_only_wrappers)
                        or cpp_type.rstrip().endswith("&&"))

            moves_an_argument = has_arguments and any(
                moves(nim_type, cpp_type) for nim_type, cpp_type
                in zip(argument_types, cpp_argument_types))
            per_argument = (has_arguments
                            and (m.spelling in scalar_overloaded
                                 or moves_an_argument))

            if has_arguments and m.spelling in scalar_overloaded:
                # `#` takes the next argument in order, and a digit after it is
                # literal text rather than an index, so one bare `#` per
                # parameter is the spelling that works. In the instance form the
                # leading `#.` has already consumed the receiver.
                #
                # `#` takes the next argument in order and a digit after one is
                # literal text, so one bare `#` per parameter is the spelling
                # that works. A static method's first parameter is the typedesc,
                # which is compile-time only and expands to nothing: it gets a
                # placeholder of its own at the front, inside the parentheses
                # the cast form adds, so the rest line up.
                emitted_args = ", ".join(
                    f"({cpp_type}) #" for cpp_type in cpp_argument_types)
            elif moves_an_argument:
                # A move-only wrapper cannot be passed by copy, and `@` copies:
                # every method taking a std::unique_ptr was rejected at its
                # call site, the same way nine field setters were before them.
                # One placeholder per parameter, with the move where it is
                # needed. A static method's typedesc expands to nothing and
                # takes a placeholder of its own, which the cast form supplies
                # by wrapping the call in parentheses - the move form has no
                # such wrapper, so a static method with a move-only parameter
                # would need one; none exists in JUCE.
                emitted_args = ", ".join(
                    "std::move(#)" if moves(nim_type, cpp_type) else "#"
                    for nim_type, cpp_type
                    in zip(argument_types, cpp_argument_types))
            else:
                emitted_args = "@" if has_arguments else ""

            if is_static_method:
                static_template = (nim_static_method_cast_def if per_argument
                                   else nim_static_method_def)
                declaration = static_template.format(**{
                    "comment": comment,
                    "method_name": method_name,
                    "class_name": class_name,
                    "method_args": (", " + ", ".join(args)) if args else "",
                    "method_return": return_type,
                    "juce_module_name": juce_module_name,
                    "qualified_name": qualified_name,
                    "juce_spelling": method_spelling,
                    "juce_args": emitted_args,
                    "address_open": "(&(" if returns_address else "",
                    "address_close": "))" if returns_address else "",
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
                    "juce_args": emitted_args,
                    "address_open": "(&(" if returns_address else "",
                    "address_close": "))" if returns_address else "",
                    "reason": f"  # {reason}" if comment and reason else "",
                })

            # Marked so the coverage check can require a test for each. These
            # reach the class through a public base that is not the Nim parent,
            # which means nothing inherits them: they exist only because they
            # are restated here, and a restatement nobody calls is never seen
            # by the C++ compiler.
            if not comment and m.get_usr() in inherited_members:
                declaration += "  # inherited from a secondary base"

            # libclang can hand back the same method more than once for a single
            # class, and Nim rejects the repeat as a redefinition.
            # The receiver is part of the key, const-ness included:
            # argument_types holds neither. Without the class name,
            # AsyncUpdater.triggerAsyncUpdate and
            # LockingAsyncUpdater.triggerAsyncUpdate collide; without the
            # const-ness, the const and non-const overloads of a getter do, and
            # dropping the const one makes it uncallable on a `let`.
            receiver = f"typedesc[{class_name}]" if is_static_method else args[0]
            # The return type is normalised, because JUCE declares a pair of
            # ref-qualified overloads for the same method - Item& setTicked(..)&
            # and Item&& setTicked(..)&& - that differ by nothing else. Nim
            # cannot pick between two procs that differ only in return type, so
            # the pair has to collapse to one rather than both being emitted.
            signature = (receiver, method_name, tuple(argument_types),
                         return_type.replace(": var ", ": ", 1))
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
        elif class_name not in dollar_bound_by_lifting:
            dollar_definitions.append(nim_no_dollar_def.format(**{
                "class_name": class_name, "spelling": qualified_name}))

        if (not class_bound_equality and class_name not in equality_bound_by_lifting
                and class_name not in classes_with_free_equality):
            print(nim_no_equality_def.format(**{
                "class_name": class_name,
                "spelling": qualified_name }))

        print()

    # Constants a nested namespace holds. juce::Colours is 286 named Colour
    # values and juce::StandardApplicationCommandIDs is the nine ids
    # ApplicationCommandManager expects; neither was reachable, because the
    # walk above only ever looked inside juce:: itself. Named
    # <Namespace>_<name>, which is the shape the enum constants already use.
    for namespace in nested_namespaces(juce_namespace):
        constants = []
        for node in namespace.get_children():
            if not declared_in_this_module(node):
                continue

            if node.kind == CursorKind.VAR_DECL and node.spelling:
                variable_type = remap_type(node.type, {}, enum_remap, class_juce_map,
                                           global_nested_remap, unambiguous_nested_remap)
                if not type_is_declared(variable_type, declared_type_names):
                    continue
                constants.append(nim_enum_constant_def.format(**{
                    "constant_name": f"{namespace.spelling}_{remap_identifier(node.spelling)}",
                    "enum_name": variable_type,
                    "spelling": f"juce::{namespace.spelling}::{node.spelling}",
                    "juce_module_name": juce_module_name }))

            elif node.kind == CursorKind.ENUM_DECL:
                # An enum in a namespace is bound as plain integers: unnamed it
                # has no type to name, and named it would collide with the
                # class-owned enums the table above already keys by bare name.
                scope = (f"juce::{namespace.spelling}::{node.spelling}::"
                         if node.is_scoped_enum()
                         else f"juce::{namespace.spelling}::")
                constants += [nim_enum_constant_def.format(**{
                    "constant_name": f"{namespace.spelling}_{remap_identifier(e.spelling)}",
                    "enum_name": "cint",
                    "spelling": f"{scope}{e.spelling}",
                    "juce_module_name": juce_module_name })
                    for e in node.get_children()
                    if e.kind == CursorKind.ENUM_CONSTANT_DECL]

        if constants:
            print("\n".join(constants) + "\n")

    # A free function set that differs only in a scalar needs the same casts a
    # method set does. countNumberOfBits takes uint32 and uint64, and on Linux
    # Nim's uint64 is `unsigned long` while JUCE's is `unsigned long long` -
    # the same width and a different type - so the call was ambiguous there.
    scalar_overloaded_functions = scalar_overloaded_names(all_functions)

    # Free functions in the juce namespace. These were collected and then
    # discarded, so countNumberOfBits, findHighestSetBit and the rest had no
    # binding at all.
    for function in all_functions:
        if not declared_in_this_module(function) or not function.spelling:
            continue

        # juce:: itself contributes no prefix; a nested namespace contributes
        # its own name, so Colours::red is Colours_red - the same shape the
        # enum constants already use.
        owner = function.semantic_parent
        namespace_prefix = ""
        if (owner is not None and owner.kind == CursorKind.NAMESPACE
                and owner.spelling and owner.spelling != "juce"):
            namespace_prefix = f"{owner.spelling}_"

        function_name = namespace_prefix + remap_identifier(function.spelling)
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

        function_args, function_types, function_cpp_types = [], [], []
        for count, arg in enumerate(function.get_arguments()):
            # No per-class table here: the loop that built one has ended, so
            # it holds whichever class happened to be last.
            argument_type = remap_type(arg.type, {}, enum_remap, class_juce_map,
                                       global_nested_remap, unambiguous_nested_remap)
            function_args.append(f"{remap_argument_name(arg.spelling, count)}: {argument_type}")
            function_types.append(argument_type)
            function_cpp_types.append(arg.type.get_canonical().spelling)

        function_return = ""
        if function.result_type.spelling != "void":
            function_return = f": {remap_type(function.result_type, {}, enum_remap, class_juce_map, global_nested_remap, unambiguous_nested_remap)}"

        rendered = ", ".join(function_types) + function_return
        if ("<" in rendered or "::" in rendered or "(" in rendered
                or is_c_array(rendered)
                or not type_is_declared(rendered, declared_type_names)):
            comment = "# "
            reason = reason or unbound_type_reason(rendered)

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
            "juce_spelling": namespace_prefix.replace("_", "::") + function.spelling,
            "juce_args": (", ".join(f"({cpp_type}) #"
                                    for cpp_type in function_cpp_types)
                          if function_args
                          and function.spelling in scalar_overloaded_functions
                          else ("@" if function_args else "")),
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

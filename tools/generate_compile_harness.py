"""Write tests/test_juce_compiles.nim: a call to every remaining binding.

An importcpp proc reaches the C++ compiler only where something calls it, so a
binding nothing calls is never compiled at all. The tests assert behaviour, and
there is far more surface than behaviour worth asserting - 2645 methods had
nothing calling them. This hands each of them to the C++ compiler and the
linker, and nothing more.

Every call is on a pointer the compiler cannot see through, behind a guard that
is false at run time, so the C++ is generated and never executed. What it
proves is that the signature compiles and the symbol exists; what it does not
prove is anything about behaviour.

It found eight defect classes on its first run: methods passing a move-only
wrapper by copy, two static methods whose typedesc swallowed a cast
placeholder, an rvalue-reference parameter needing the same move, deleted
methods emitted as if callable, two class-template specializations bound as
plain classes, two methods returning a type only forward-declared, a generic
instantiated over a distinct enum collapsing onto its base type, and eleven
[[deprecated]] overloads JUCE declares and never defines.
"""

import re, glob, collections, sys

MODULES = ["juce_core", "juce_events", "juce_data_structures", "juce_graphics", "juce_gui_basics"]
src = {m: open(f"sources/june/{m}.nim").read() for m in MODULES}

# Two types the generator emits without an export marker, so nothing outside
# the module can name them. Their methods reach a program through the exported
# subclass instead.
UNEXPORTED = {"DocumentWindowImpl", "JUCEApplicationImpl"}

# Bindings JUCE only declares on macOS. The generated modules are produced on
# macOS - the workflow says why - so they carry these, and the tests never
# noticed because nothing called them. The harness calls everything, so the
# calls to these go behind `when defined(macosx)`.
#
# Measured by compiling the harness on Linux, one round per error the compiler
# would report, since it stops after a few.
MACOS_ONLY_CLASSES = {
    "MountedVolumeListChangeDetector",
}
MACOS_ONLY_METHODS = {
    ("String", "convertToPrecomposedUnicode"),
    ("SystemStats", "isAppSandboxEnabled"),
    ("File", "isBundle"),
    ("File", "addToDock"),
    ("File", "getContainerForSecurityApplicationGroupIdentifier"),
    ("Process", "setDockIconVisible"),
    ("Desktop", "isOSXDarkModeActive"),
    ("MenuBarModel", "setMacMainMenu"),
    ("MenuBarModel", "getMacMainMenu"),
    ("MenuBarModel", "getMacExtraAppleItemsMenu"),
}

# An enum is a distinct cint on the Nim side, and a plain integer is not a C++
# enum: the C++ compiler refuses `int` where a scoped enum is declared. The
# value has to be one of the bound enumerators, whose importcpp IS the C++
# name, so the first constant of each enum is what the harness passes.
ENUM_CONSTANT = {}
for _text in src.values():
    for _enum in re.findall(r'^  (\w+)\* \{[^}]*\} = distinct cint', _text, re.M):
        _first = re.search(rf'^let ({re.escape(_enum)}_\w+)\*', _text, re.M)
        if _first:
            ENUM_CONSTANT[_enum] = _first.group(1)

SCALARS = {
    "cint": "0.cint", "cfloat": "0.0'f32", "float64": "0.0", "cdouble": "0.0",
    "bool": "false", "uint8": "0'u8", "uint16": "0'u16", "uint32": "0'u32",
    "uint64": "0'u64", "int64": "0'i64", "int16": "0'i16", "int8": "0'i8",
    "int32": "0'i32", "csize_t": "0.csize_t", "WChar": "WChar(0)",
    "cchar": "cchar(0)", "cuchar": "cuchar(0)", "cshort": "cshort(0)",
    "cushort": "cushort(0)", "clong": "clong(0)", "culong": "culong(0)",
    "clonglong": "clonglong(0)", "culonglong": "culonglong(0)",
    "pointer": "cast[pointer](address)", "constPointer": "cast[constPointer](address)",
    "constChar": "cast[constChar](cstring(\"\"))",
    "cstring": "cstring(\"\")", "int": "0", "float": "0.0", "char": "chr(0)",
    "string": "\"\"",
}

# JUCE names that something already in scope shadows. Qualified one by one
# rather than wholesale: `june.X` inside a generic argument loses the type's
# importcpp name, so CppOptional[june.ProgressBarStyle] renders as
# std::optional<int> and C++ refuses it.
SHADOWED = {"File", "Thread", "Time"}


def qualify(nim_type):
    return re.sub(r"\b([A-Z]\w*)",
                  lambda m: f"june.{m.group(1)}" if m.group(1) in SHADOWED else m.group(1),
                  nim_type)


def value_for(nim_type):
    """A value of this type, or None if none can be spelled here."""
    t = nim_type.strip()
    if t.startswith("var "):
        inner = t[4:].strip()
        v = value_for(inner)
        return None if v is None else f"nowhere[{qualify(inner)}]()[]"
    if t in SCALARS:
        return SCALARS[t]
    if t in ENUM_CONSTANT:
        return ENUM_CONSTANT[t]
    if t.startswith("ptr "):
        return f"cast[{qualify(t)}](address)"
    if t.startswith("ConstPtr["):
        return f"nowhere[{qualify(t)}]()[]"
    if re.fullmatch(r"[A-Za-z_]\w*(\[[^\]]*\])?", t):
        return f"nowhere[{qualify(t)}]()[]"
    return None

calls = []
mac_only = []
skipped = collections.Counter()
for module, text in src.items():
    for line in text.splitlines():
        if not line.startswith("proc "):
            continue
        m = re.match(r'^proc (`?[\w=+*/<>\[\]-]+`?)\*\((.*?)\)(: [^{]+)? \{[^}]*importcpp: "', line)
        if not m:
            continue
        name, body, returns = m.group(1), m.group(2), (m.group(3) or "")
        if name.endswith("=`") or name.endswith("="):
            skipped["a setter, covered by the field check"] += 1
            continue
        if not name.startswith("`") and not re.fullmatch(r"\w+", name):
            skipped["an operator"] += 1
            continue
        if name.startswith("`"):
            skipped["an operator"] += 1
            continue
        if any(name in line for name in UNEXPORTED):
            skipped["a type the generator does not export"] += 1
            continue

        parts = [p for p in body.split(", ") if ":" in p]
        if not parts:
            skipped["no receiver"] += 1
            continue
        first_name, first_type = parts[0].split(":", 1)
        first_type = first_type.strip()
        if first_name.strip() != "this":
            skipped["a free function"] += 1
            continue

        static_match = re.fullmatch(r"typedesc\[(\w+)\]", first_type)
        if static_match:
            receiver = f"{qualify(static_match.group(1))}."
        else:
            cls = first_type[4:].strip() if first_type.startswith("var ") else first_type
            if not re.fullmatch(r"\w+", cls):
                skipped["a generic receiver"] += 1
                continue
            receiver = f"nowhere[{qualify(cls)}]()[]."

        arguments, ok = [], True
        for part in parts[1:]:
            _, argument_type = part.split(":", 1)
            argument_type = argument_type.split(" = ")[0].strip()
            value = value_for(argument_type)
            if value is None:
                skipped[f"an argument of type {argument_type}"] += 1
                ok = False
                break
            arguments.append(value)
        if not ok:
            continue

        prefix = "discard " if returns.strip() and returns.strip() != ": void" else ""
        call = f"{prefix}{receiver}{name}({', '.join(arguments)})"
        owner = static_match.group(1) if static_match else (
            first_type[4:].strip() if first_type.startswith("var ") else first_type)
        if owner in MACOS_ONLY_CLASSES or (owner, name) in MACOS_ONLY_METHODS:
            mac_only.append(f"            {call}")
        else:
            calls.append(f"        {call}")

print(f"# calls generated: {len(calls)}", file=sys.stderr)
print(f"# skipped: {sum(skipped.values())}", file=sys.stderr)
for reason, n in skipped.most_common(8):
    print(f"#   {n:5}  {reason}", file=sys.stderr)
HEADER = """# Generated by tools/generate_compile_harness.py. Do not edit.
#
# A call to every binding the tests do not otherwise reach. An importcpp proc
# reaches the C++ compiler only where something calls it, so a binding nothing
# calls is never compiled at all: this file exists to hand each of them to the
# compiler and the linker, and nothing more.
#
# Every call is on a pointer the compiler cannot see through, behind a guard
# that is false at run time, so the C++ is generated and never executed.
# `nowhere[T]()` hides a zero behind a runtime variable, which is what lets the
# call type-check without a constructor for T.
#
# It proves signatures compile and symbols exist. It proves nothing about what
# any of them does - that is what the other test files are for.

import june

var address = 0

proc nowhere[T](): ptr T = cast[ptr T](address)

"""

CHUNK = 400
procedures, names = [], []
for start in range(0, len(calls), CHUNK):
    name = f"compileChunk{start // CHUNK}"
    names.append(name)
    procedures.append(f"proc {name}() =\n    if address != 0:\n"
                      + "\n".join(calls[start:start + CHUNK]) + "\n")

if mac_only:
    procedures.append("proc compileMacOnly() =\n    if address != 0:\n"
                      "        when defined(macosx):\n"
                      + "\n".join(mac_only) + "\n")
    names.append("compileMacOnly")

print(f"# macOS-only calls: {len(mac_only)}", file=sys.stderr)

open("tests/test_juce_compiles.nim", "w").write(
    HEADER + "\n".join(procedures) + "\n"
    + "\n".join(f"{name}()" for name in names) + "\n")

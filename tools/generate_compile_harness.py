"""Write tests/test_juce_compiles.nim: a call to every binding this can spell.

An importcpp proc reaches the C++ compiler only where something calls it, so a
binding nothing calls is never compiled at all. The tests assert behaviour, and
there is far more surface than behaviour worth asserting, so most of the
generated surface had nothing calling it. This hands it to the C++ compiler and
the linker, and nothing more.

The only input is sources/june/*.nim. This does not read the tests and cannot
tell what they already reach: it emits a call for every importcpp proc with a
`this` receiver whose arguments it can spell, including the ones a test already
calls. The skip report on stderr names what it could not spell, and the counts
have to add up - see the check below the loop.

Every call is on a pointer the compiler cannot see through, behind a guard that
is false at run time, so the C++ is generated and never executed. What it
proves is that the signature compiles and the symbol exists; what it does not
prove is anything about behaviour.

A result whose type is a plain class name is BOUND to a name; everything else is
discarded. The two forms ask different questions and the split is deliberate -
see the comment above the emission for the reasoning, which is what found two
methods returning a forward-declared type.

Not every result can be bound. A `var T` return is a reference, and binding one
copies from an lvalue, which demands a copy constructor that several of these
deliberately do not have - TextLayout::Line::runs is bound as a `var` return for
exactly that reason, so binding it would fail on a correct binding. A `ptr T` is
a pointer, and the move-only handles cannot be bound to a `let` in Nim at all.
Those stay discarded, and assigning a result - the only form that would check
copy-assignment - is ruled out by the same argument. Copy-assignment of returned
types therefore stays unchecked here, by choice rather than by oversight.

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

# Results Nim itself refuses to bind to a `let`: a move-only wrapper is not
# copyable in Nim, so `let x = f()` is a Nim error that says nothing about the
# C++. These stay discarded.
MOVE_ONLY_RESULTS = {"UniquePtr", "ReferenceCountedObjectPtr", "OwnedArray",
                     "OptionalScopedPointer",
                     # A JUCE aggregate is move-only when it holds a unique_ptr,
                     # which is not visible from the Nim spelling. Found by the
                     # C++ compiler rejecting the copy, one name at a time.
                     "AccessibilityHandlerInterfaces"}

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
# The ARGUMENT question is not the RESULT question. MOVE_ONLY_RESULTS names
# types NIM refuses to bind to a `let`; this names types C++ cannot COPY from an
# lvalue, which is what nowhere[T]()[] hands to a by-value parameter.
# ReferenceCountedObjectPtr belongs to the first and not the second - it is a
# copyable refcounted pointer - and conflating the two silently dropped
# withTypeface, setCustomComponent and setDefaultSansSerifTypeface out of the
# harness while they stayed declared in the bindings.
UNCOPYABLE_ARGUMENTS = {"UniquePtr", "OwnedArray", "OptionalScopedPointer",
                        "AccessibilityHandlerInterfaces"}

macos_used = set()
MACOS_ONLY_CLASSES = {
    "MountedVolumeListChangeDetector",
}
# A free function has no receiver, so it cannot be reached through the class set
# above. juce_assert_noreturn is declared behind
# `#if JUCE_CLANG && __has_feature (attribute_analyzer_noreturn)`, which is a
# COMPILER test rather than a platform one: it exists under clang on macOS,
# where these modules are generated, and not under gcc on Linux. Found by the
# Linux job saying "'juce_assert_noreturn' is not a member of 'juce'".
MACOS_ONLY_FUNCTIONS = {
    "juce_assert_noreturn",
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

def split_parameters(body):
    """The parameters, split at top-level commas.

    A plain split on ", " cuts inside a generic argument list too, so
    CppMap[Identifier, juce_var] arrived as two fragments and the skip report
    named a type that does not exist. The report is what a maintainer reads to
    decide whether a gap is worth closing, so the fragment misdirects twice
    over: no such type, and no such gap.
    """
    parts, depth, current = [], 0, ""
    for character in body:
        if character in "([{":
            depth += 1
        elif character in ")]}":
            depth -= 1
        if character == "," and depth == 0:
            parts.append(current)
            current = ""
        else:
            current += character
    parts.append(current)
    return [part.strip() for part in parts if ":" in part]


calls = []
values = 0
mac_only = []
skipped = collections.Counter()
declarations = 0
for module, text in src.items():
    for line in text.splitlines():
        if not line.startswith("proc ") or 'importcpp: "' not in line:
            continue
        declarations += 1
        m = re.match(r'^proc (`?[\w=+*/<>\[\]-]+`?)\*\((.*?)\)(: [^{]+)? \{[^}]*importcpp: "', line)
        if not m:
            # Every one of these is an operator whose name the pattern's
            # character class does not carry, or a generic free function, so
            # the branches below would skip it anyway. Counted rather than
            # dropped so the accounting at the bottom stays exact.
            skipped["a declaration this pattern cannot parse"] += 1
            continue
        name, body, returns = m.group(1), m.group(2), (m.group(3) or "")
        # `name=` is two different things. A field setter writes the field -
        # importcpp `#.x = ` - and the field check already requires a test to
        # assign it. An assignment operator is spelled the same way but its
        # importcpp is `#.operator=(...)`, which the field check never looks at
        # and no other check covers, so skipping it here left it compiled by
        # nothing. `==`, `<=`, `+=` and the rest also end in `=` and are neither.
        setter_like = re.fullmatch(r"`?\w+=`?", name)
        if setter_like:
            bare = name.strip("`")[:-1]
            if re.search(r'importcpp: "#\.' + re.escape(bare) + r' = ', line):
                skipped["a field setter, covered by the field check"] += 1
                continue
        if not setter_like:
            if not name.startswith("`") and not re.fullmatch(r"\w+", name):
                skipped["an operator"] += 1
                continue
        if any(name in line for name in UNEXPORTED):
            skipped["a type the generator does not export"] += 1
            continue

        parts = split_parameters(body)
        if not parts:
            # A no-argument constructor is already required to be called by a
            # test, so calling it here would only duplicate that. Anything else
            # taking no arguments is a free function with nothing covering it -
            # juce_assert_noreturn and juce_isRunningUnderDebugger were the two,
            # and neither had ever been handed to a C++ compiler.
            if name.startswith("make"):
                skipped["a no-argument constructor, covered by its own check"] += 1
                continue
            call = f"{name}()"
            # The same binds decision the receiver path makes below. A
            # discarded call CONSTRUCTS nothing, so a by-value return of a
            # class C++ will not copy compiles here while failing at every
            # real call site - the whole reason this harness binds results.
            bare = returns.strip()[1:].strip() if returns.strip() else ""
            if (bare and bare != "void" and re.fullmatch(r"\w+", bare)
                    and bare not in MOVE_ONLY_RESULTS):
                values += 1
                rendered = f"let harnessValue{values} = {call}"
            elif bare and bare != "void":
                rendered = f"discard {call}"
            else:
                rendered = call
            if name in MACOS_ONLY_FUNCTIONS:
                macos_used.add(name)
                mac_only.append(f"            {rendered}")
            else:
                calls.append(f"        {rendered}")
            continue
        first_name, first_type = parts[0].split(":", 1)
        first_type = first_type.strip()
        # A free function has no receiver to hang the call on, but it is a
        # binding like any other and an importcpp string still reaches the C++
        # compiler only where something calls it. Called by name, with every
        # parameter an argument.
        free_function = first_name.strip() != "this"

        static_match = None if free_function else re.fullmatch(
            r"typedesc\[(\w+)\]", first_type)
        if free_function:
            receiver = ""
        elif static_match:
            receiver = f"{qualify(static_match.group(1))}."
        else:
            cls = first_type[4:].strip() if first_type.startswith("var ") else first_type
            if not re.fullmatch(r"\w+", cls):
                skipped["a generic receiver"] += 1
                continue
            if cls in ENUM_CONSTANT:
                # An enum receiver uses a real enumerator, not nowhere[]. Nim
                # erases `distinct` when it instantiates a generic, so
                # nowhere[SomeEnum] and nowhere[cint] render ONE C++ function
                # and every nowhere[cint] elsewhere in the harness then passes
                # the enum's type. The enumerator has no such problem, and it
                # is what a caller would actually write.
                receiver = f"{ENUM_CONSTANT[cls]}."
            else:
                receiver = f"nowhere[{qualify(cls)}]()[]."

        arguments, ok = [], True
        for part in (parts if free_function else parts[1:]):
            _, argument_type = part.split(":", 1)
            argument_type = argument_type.split(" = ")[0].strip()
            # A move-only type cannot be passed by value from an lvalue, and
            # nowhere[T]()[] is one: C++ reports a deleted copy constructor. The
            # same set already keeps these from being bound as a result.
            bare = argument_type.split("[")[0].removeprefix("var ").strip()
            if bare in UNCOPYABLE_ARGUMENTS and "std::move" not in line:
                # Only where the C++ side does not move it for us. Where the
                # importcpp already spells std::move - which inspect_juce emits
                # for a move-only parameter - an lvalue is exactly what it wants.
                skipped["an argument that cannot be copied"] += 1
                ok = False
                break
            value = value_for(argument_type)
            if value is None:
                skipped[f"an argument of type {argument_type}"] += 1
                ok = False
                break
            arguments.append(value)
        if not ok:
            continue

        # A result that is a plain class name is BOUND to a variable rather
        # than discarded, because that is the only thing that makes the C++
        # compiler construct it. `discard f()` constructs nothing, so a
        # by-value binding of a reference to a class C++ will not copy - an
        # abstract one, or one carrying JUCE_DECLARE_NON_COPYABLE - compiled
        # here and failed at every real call site. Two were found that way.
        #
        # Only a plain class name. `var T` is a reference and copies nothing;
        # `ptr T` is a pointer; and the move-only handles below cannot be
        # bound to a `let` in Nim at all, which is a Nim error rather than the
        # C++ question this is asking.
        rendered = returns.strip()[1:].strip() if returns.strip() else ""
        binds = (rendered and rendered != "void"
                 and re.fullmatch(r"\w+", rendered)
                 and rendered not in MOVE_ONLY_RESULTS)
        if binds:
            values += 1
            prefix = f"let harnessValue{values} = "
        else:
            prefix = "discard " if rendered and rendered != "void" else ""
        call = f"{prefix}{receiver}{name}({', '.join(arguments)})"
        owner = static_match.group(1) if static_match else (
            first_type[4:].strip() if first_type.startswith("var ") else first_type)
        if (owner in MACOS_ONLY_CLASSES or (owner, name) in MACOS_ONLY_METHODS
                or name in MACOS_ONLY_FUNCTIONS):
            # Recorded in the form the entry is WRITTEN in, so the staleness
            # report below names what to delete rather than what it matched.
            if owner in MACOS_ONLY_CLASSES:
                macos_used.add(owner)
            if (owner, name) in MACOS_ONLY_METHODS:
                macos_used.add((owner, name))
            if name in MACOS_ONLY_FUNCTIONS:
                macos_used.add(name)
            mac_only.append(f"            {call}")
        else:
            calls.append(f"        {call}")

# An entry naming something JUCE no longer declares withholds nothing and says
# nothing: the call it was meant to guard is simply not generated, so the list
# keeps a name that has stopped meaning anything and the next reader trusts it.
# Every entry is reached by the emit loop today, so anything unreached is stale.
stale_macos = (sorted(c for c in MACOS_ONLY_CLASSES if c not in macos_used)
               + sorted(f"{c}.{m}" for c, m in MACOS_ONLY_METHODS
                        if (c, m) not in macos_used)
               + sorted(n for n in MACOS_ONLY_FUNCTIONS if n not in macos_used))
if stale_macos:
    print("These are listed as macOS-only but the generator never reached a "
          "call for them, so the entry guards nothing:", file=sys.stderr)
    for entry in stale_macos:
        print(f"  {entry}", file=sys.stderr)
    sys.exit(1)

emitted = len(calls) + len(mac_only)
print(f"# calls generated: {emitted} ({len(mac_only)} of them macOS-only)",
      file=sys.stderr)
print(f"# skipped: {sum(skipped.values())}", file=sys.stderr)
for reason, n in skipped.most_common(8):
    print(f"#   {n:5}  {reason}", file=sys.stderr)
remainder = skipped.most_common()[8:]
if remainder:
    print(f"#   {sum(n for _, n in remainder):5}  ... and "
          f"{len(remainder)} more reason{'s' if len(remainder) > 1 else ''}",
          file=sys.stderr)

# Every bound declaration is either called or skipped for a named reason. The
# counts above go to stderr, where nothing reads them, so a change that stopped
# emitting a whole category would leave a smaller harness that regenerates
# cleanly and passes CI's diff of the committed file. This refuses to write in
# that case. It does not police a category moved to a NAMED skip reason - that
# one shows up in the report - only a call that vanishes with no reason at all.
if emitted + sum(skipped.values()) != declarations:
    sys.exit(f"{declarations} bound declarations, but "
             f"{emitted + sum(skipped.values())} accounted for: a call was "
             f"dropped with no skip reason")
HEADER = """# Generated by tools/generate_compile_harness.py. Do not edit.
#
# A call to every binding the generator can spell. An importcpp proc reaches
# the C++ compiler only where something calls it, so a binding nothing calls is
# never compiled at all: this file exists to hand each of them to the compiler
# and the linker, and nothing more. The generator reads the generated modules
# and not the tests, so a binding a test already calls is called again here.
#
# Every call is on a pointer the compiler cannot see through, behind a guard
# that is false at run time, so the C++ is generated and never executed.
# `nowhere[T]()` hides a zero behind a runtime variable, which is what lets the
# call type-check without a constructor for T. A result whose type is a plain
# class name is bound to a name, because that is what makes the C++ compiler
# construct it; everything else is discarded. A `var` return is not bound, since
# binding one demands a copy constructor that several of them deliberately do
# not have.
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

open("tests/test_juce_compiles.nim", "w").write(
    HEADER + "\n".join(procedures) + "\n"
    + "\n".join(f"{name}()" for name in names) + "\n")

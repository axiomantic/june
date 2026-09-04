"""Fail if a hand-written binding is never called.

The generated modules are checked by the generator itself: it reproduces them
byte for byte, and CI compares. The hand-written layer - june_juce_types,
june_stl, june_common, june_function_utils and the _lifting files - has no such
check, and an importcpp string only reaches the C++ compiler at the call site.
A binding nothing calls is therefore never compiled at all.

That is not hypothetical. Seven defects were found in that layer by calling
things for the first time: a BorderSize constructor JUCE does not declare, four
container types with no constructor at all, three Range setters that mutated a
let binding, and a SparseSet with no way to add to it. Every one of them
compiled cleanly for as long as nothing used it.

What is checked is a NAME, not a declaration. Six procs are called isNil and
eight iterators are called items, and one call of either satisfies all of them.
That is the limit of a check built on a text search: it catches a binding
nothing mentions, which is the case every defect above was found in, and it
does not catch one overload of a name something else already calls.

Run from the repository root. Exits non-zero and names what is uncovered.
"""
import glob
import os
import re
import sys

hand_written = [
    "june_juce_types.nim", "june_stl.nim", "june_common.nim",
    "june_function_utils.nim", "juce_core_lifting.nim", "juce_events_lifting.nim",
    "juce_graphics_lifting.nim", "juce_gui_basics_lifting.nim",
    "juce_data_structures_lifting.nim",
]

# Each needs a reason, and the reason has to be why a test cannot call it
# rather than that nobody has yet.
uncallable = {
    "newApplication":
        "builds a JUCEApplication, whose constructor asserts unless it is the "
        "process's one instance",
    "constructApplication":
        "builds a JUCEApplication, same as newApplication",
    "release":
        "OptionalScopedPointer::release hands back ownership, and a test that "
        "called it would have to invent a leak or a double free to finish",
}

export = re.compile(r'(?:proc|iterator|template|converter) `?(\w+)`?\*')

# The generator withholds a C++ begin()/end() pair with a reason that promises
# a Nim iterator in its place. Nothing checked that the promise held, and for
# one class it did not.
iterator_promise = re.compile(
    r'# proc (?:begin|cbegin)\*\(this: (?:var )?(\w+)\).*loop with the Nim iterator')

nim_iterator = re.compile(r'iterator \w+\*(?:\[[^\]]*\])?\(this: (?:var )?(\w+)')

# A class whose begin() is withheld and that gets no Nim iterator anyway. The
# reason has to be why a Nim iterator cannot exist.
no_iterator_possible = {
    "AndroidDocumentIterator":
        "Android only. JUCE declares it on every platform but implements it "
        "behind JUCE_ANDROID, so there is nothing for an iterator to call.",
}


implicit_default = re.compile(
    r'proc (make\w+)\*\(\): \w+ \{[^}]*\}\s*# implicit default constructor')


subclass_constructor = re.compile(r'proc (newCustom\w+)\*\(')

# A generated subclass a test cannot build. The reason has to be why a test
# cannot, not that nobody has yet.
unbuildable_subclasses = {
    "newCustomJUCEApplicationBase":
        "trips JUCE's assertion that the process has a single application "
        "instance, the same as newApplication",
    "newCustomThreadWithProgressWindow":
        "is a top-level window, and building one on a headless Linux "
        "container segfaults, the same as AlertWindow",
}


def check_subclasses():
    """Every generated subclass is built by a test.

    The C++ class lives in a header the Nim type carries, and Nim includes it
    only where the type is used - so a constructor nothing calls is never
    compiled, and neither is the class. Two real defects were sitting behind
    that: an ImagePixelData::clone override typed against the wrong class's
    Ptr, and a ComponentMovementWatcher subclass that overrode one of three
    pure virtuals and was still abstract.

    Discarding the returned pointer does not count, because the type never
    enters the translation unit. The names here are matched textually, so a
    test has to name the constructor - which it does by using what it returns.
    """
    emitted = set()
    for path in (glob.glob("sources/june/*_subclasses.nim")
                 + glob.glob("sources/june/*_lifting.nim")):
        emitted.update(subclass_constructor.findall(open(path).read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    uncalled = sorted(name for name in emitted
                      if name not in unbuildable_subclasses
                      and not re.search(r"\b" + name + r"\b", used))
    stale = sorted(name for name in unbuildable_subclasses
                   if name not in emitted)

    if uncalled:
        print("These generated subclasses are never built by a test, so "
              "nothing compiles the C++ class:", file=sys.stderr)
        for name in uncalled:
            print(f"  {name}", file=sys.stderr)
    if stale:
        print("These are listed as unbuildable but no longer exist:",
              file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)

    if not (uncalled or stale):
        print(f"all {len(emitted) - len(unbuildable_subclasses)} generated "
              f"subclasses are built by a test "
              f"({len(unbuildable_subclasses)} listed as unbuildable)")
    return not (uncalled or stale)


handler_setter = re.compile(r'proc (set\w+Handler)\*\(')

# A handler setter no test can call. The reason has to be why a test cannot.
uncallable_handlers = {
    name: ("is on CustomJUCEApplicationBase, and building one trips JUCE's "
           "assertion that the process has a single application instance")
    for name in (
        "setGetApplicationNameHandler", "setGetApplicationVersionHandler",
        "setMoreThanOneInstanceAllowedHandler", "setInitialiseHandler",
        "setShutdownHandler", "setAnotherInstanceStartedHandler",
        "setSystemRequestedQuitHandler", "setSuspendedHandler",
        "setResumedHandler", "setUnhandledExceptionHandler")
}


no_argument_constructor = re.compile(r'^proc (make\w+)\*\(\):', re.M)

# A constructor for a class that exists on one platform only. The committed
# generated files are the macOS output, so these are declared everywhere and
# defined only there, and a test that called one would not build on Linux.
platform_specific_constructors = {
    "makeScopedAutoReleasePool":
        "juce::ScopedAutoReleasePool is an Objective-C autorelease pool and "
        "exists on macOS only",
}


def check_no_argument_constructors():
    """Every generated constructor that takes no arguments is called.

    Only constructors, and only the no-argument ones. Sweeping the const
    getters on every default-constructible class was tried too and abandoned
    for the same reason: makeThreadPool starts threads, makeStreamingSocket
    and makeChildProcess do real work, and the process was killed rather than
    finishing. It did find one thing before it was dropped - AndroidDocument
    ::getNativeInfo returns a type JUCE only forward declares - and that is
    named in the generator now.

    A sweep that invents arguments was tried and abandoned: a JUCE constructor does real work, and the invented values sent
    it doing it - a directory handed to ZipFile, an empty name to
    InterProcessLock - until the process was killed. Compiling the importcpp is
    not worth running JUCE against nonsense, so the 191 constructors that take
    arguments stay uncovered unless a test has a real reason to build one.

    Sweeping the no-argument ones is what found five constructors emitted for a
    deleted C++ one - JSONUtils,
    OrderedContainerHelpers, WindowUtils, ContentSharer and String(bool),
    which JUCE deletes so that a bool does not silently become a String.
    """
    emitted = set()
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        emitted.update(no_argument_constructor.findall(
            open(f"sources/june/{module}.nim").read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    uncalled = sorted(name for name in emitted
                      if name not in platform_specific_constructors
                      and not re.search(r"\b" + name + r"\b", used))
    if uncalled:
        print("These no-argument constructors are never called, so nothing "
              "compiles them:", file=sys.stderr)
        for name in uncalled:
            print(f"  {name}", file=sys.stderr)
        return False

    print(f"all {len(emitted) - len(platform_specific_constructors)} "
          f"no-argument constructors are called "
          f"({len(platform_specific_constructors)} is platform specific)")
    return True


bound_constant = re.compile(r'^let (\w+)\* \{[^}]*importcpp:', re.M)


constructible_class = re.compile(r'^proc make(\w+)\*\(', re.M)

# A class a test cannot reach. The reason has to be why, not that nobody has.
unreachable_classes = {
    "NetworkServiceDiscoveryAvailableServiceList":
        "opens a UDP socket to listen for service announcements",
    "NetworkServiceDiscoveryAdvertiser":
        "opens a UDP socket to broadcast announcements",
    "AndroidDocumentInputSource": "exists on Android only",
    "ScopedAutoReleasePool":
        "is an Objective-C autorelease pool and exists on macOS only, while "
        "the committed generated files are the macOS output",
}


def check_classes():
    """Every class with a constructor is named by a test.

    Weaker than the other checks here - a name in a test file is not proof the
    class was driven - but it is what stops a new class from arriving with no
    test at all, which is how every defect this branch fixed stayed hidden.
    """
    emitted = set()
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        emitted.update(constructible_class.findall(
            open(f"sources/june/{module}.nim").read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    # Substring, not a word boundary: a class is often reached through
    # make<Name>, and <Name> has no boundary before it there.
    untested = sorted(name for name in emitted
                      if name not in unreachable_classes and name not in used)
    stale = sorted(name for name in unreachable_classes if name not in emitted)

    if untested:
        print("These classes have a constructor and are named by no test:",
              file=sys.stderr)
        for name in untested:
            print(f"  {name}", file=sys.stderr)
    if stale:
        print("These are listed as unreachable but have no constructor:",
              file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)

    if not (untested or stale):
        print(f"all {len(emitted) - len(unreachable_classes)} constructible "
              f"classes are named by a test "
              f"({len(unreachable_classes)} listed as unreachable)")
    return not (untested or stale)


inherited_method = re.compile(
    r'^proc (\w+)\*\(this: (?:var )?(?:typedesc\[)?(\w+)[,)\]][^\n]*'
    r'# inherited from a secondary base$', re.M)


# Restated methods a test cannot call, with the reason it cannot. Same shape as
# the exclusion tables the other checks carry: the entry has to say what stops
# a test, not that writing one is inconvenient.
uncallable_inherited = {
    "setCurrentDragImage":
        "JUCE writes through dragImageComponents[0] without checking it exists "
        "(juce_DragAndDropContainer.cpp:570), so it segfaults unless a drag is "
        "already running, and starting a real one needs a dragging mouse",
    "startDragging":
        "needs a MouseInputSource that is actually dragging; with none it "
        "trips two jasserts and starts nothing",
    "performExternalDragDropOfFiles":
        "hands the payload to the operating system's drag service, so calling "
        "it would start a real drag on the machine running the tests",
    "performExternalDragDropOfText":
        "hands the payload to the operating system's drag service, so calling "
        "it would start a real drag on the machine running the tests",
    "findFirstTargetParentComponent":
        "reached only through a JUCEApplication, whose constructor asserts "
        "unless it is the process's one application instance",
    "getTargetForCommand":
        "reached only through a JUCEApplication, whose constructor asserts "
        "unless it is the process's one application instance",
    "invoke":
        "reached only through a JUCEApplication, whose constructor asserts "
        "unless it is the process's one application instance",
    "isCommandActive":
        "reached only through a JUCEApplication, whose constructor asserts "
        "unless it is the process's one application instance",
}


# Nim integer types an integer literal converts to at equal cost, which is what
# makes an overload set of them ambiguous for a plain literal.
nim_integer_types = {
    "cint", "int8", "int16", "int32", "int64",
    "uint8", "uint16", "uint32", "uint64", "csize_t",
    "cshort", "cushort", "clong", "culong", "clonglong", "culonglong",
}

# Overload sets where an int-taking forwarder would have no lossless target,
# with the reason. A caller passes the width for these.
no_lossless_int_target = {
    "swap": "each overload returns its own width, so an int form would have to "
            "pick one return type and no choice is the obvious one",
    "countNumberOfBits": "takes only uint32 and uint64, and a Nim int is signed",
    "makeGridPx": "takes only cint and uint64, so neither is lossless for a Nim int",
    "makeGridFr": "takes only cint and uint64, so neither is lossless for a Nim int",
    "read": "takes only cint and uint64, and the two overloads return different types",
}


# A field accessor a test cannot reach, with the reason it cannot. The reason
# has to be why a test cannot, not that nobody has written one.
unreachable_fields = {
    "clip":
        "belongs to ColourLayer, which holds an EdgeTable and so has no "
        "default constructor, and JUCE hands one out from nothing that is "
        "bound",
    "directoryContentsList":
        "belongs to DirectoryContentsDisplayComponent, which is a secondary "
        "base of FileListComponent and FileTreeComponent; Nim carries one "
        "parent and both take the other, so no bound class reaches the field",
}

field_getter = re.compile(
    r'^proc (\w+)\*\(this: (?:var )?(\w+)\)[^{]*\{[^}]*importcpp: "#\.\1"', re.M)
field_setter = re.compile(
    r'^proc `(\w+)=`\*\(this: var (\w+)[^{]*\{[^}]*importcpp: "#\.\1 = ', re.M)


def check_field_accessors():
    """Every public field is written and read by a test.

    A field getter and setter are importcpp procs like any other: they reach
    the C++ compiler only where something calls them, so a setter nothing
    assigns is never compiled. Nine of them assigned a move-only wrapper by
    copy and were rejected at every call site, and two more named a type with
    no copy constructor at all - each found by writing the assignment.

    Identified by the shape of the importcpp rather than the signature: a
    getter is a bare member read and a setter a member assignment, which is
    what tells them apart from an ordinary method.

    Keyed on the field's NAME, because the receiver's type is not written at
    the call site and this reads the test source rather than compiling it. Two
    classes with a field of the same name therefore cover each other:
    FlexBox.alignContent and Grid.alignContent are one entry here, and only one
    of them has to be assigned. Verified against a name that belongs to a
    single class - removing the assignment to
    ComponentPaintDiagnostics.wroteToCache makes this fail and name it.
    """
    getters, setters = set(), set()
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        text = open(f"sources/june/{module}.nim").read()
        getters.update(name for name, _ in field_getter.findall(text))
        setters.update(name for name, _ in field_setter.findall(text))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    unread = sorted(name for name in getters
                    if name not in unreachable_fields
                    and not re.search(r"\." + name + r"\b", used))
    unwritten = sorted(name for name in setters
                       if name not in unreachable_fields
                       and not re.search(r"\." + name + r"\s*=[^=]", used))

    stale = sorted(name for name in unreachable_fields
                   if name not in getters and name not in setters)
    if stale:
        print("These entries in unreachable_fields name no field accessor:",
              file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)
        return False

    if unread or unwritten:
        if unread:
            print("These field getters are never read, so nothing compiles "
                  "them:", file=sys.stderr)
            for name in unread[:20]:
                print(f"  {name}", file=sys.stderr)
            if len(unread) > 20:
                print(f"  ... and {len(unread) - 20} more", file=sys.stderr)
        if unwritten:
            print("These field setters are never assigned, so nothing "
                  "compiles them:", file=sys.stderr)
            for name in unwritten[:20]:
                print(f"  {name}", file=sys.stderr)
            if len(unwritten) > 20:
                print(f"  ... and {len(unwritten) - 20} more", file=sys.stderr)
        return False

    print(f"all {len(getters)} field getters are read and all {len(setters)} "
          f"field setters are assigned by a test "
          f"({len(unreachable_fields)} listed as unreachable)")
    return True


def check_integer_literal_overloads():
    """Every overload set that can take a Nim int has a proc that does.

    JUCE gives String six integer constructors, and a plain Nim integer literal
    converts to all of them at equal cost, so `makeString(5)` is ambiguous. A
    proc taking Nim's own `int` is an exact match and wins outright.

    One is written by hand for each set that has an int64 overload and one
    return type across its integer overloads, since a Nim int IS an int64 here
    and the conversion is lossless. This recomputes the set from the generated
    files, so a JUCE upgrade that adds or removes an overload fails here rather
    than silently leaving a call ambiguous.
    """
    groups = {}
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        for line in open(f"sources/june/{module}.nim"):
            if not line.startswith("proc "):
                continue
            match = re.match(r'^proc (`?[\w=]+`?)\*\((.*?)\)(: [^{]+)? \{', line)
            if not match:
                continue
            name, body, returns = (match.group(1), match.group(2),
                                   (match.group(3) or "").strip(": ").strip())
            parts = [p for p in body.split(", ") if ":" in p]
            types = tuple(p.split(":", 1)[1].strip().split(" =")[0].strip()
                          for p in parts)
            names = tuple(p.split(":", 1)[0].strip() for p in parts)
            if not types:
                continue
            receiver = types[0] if names and names[0] == "this" else ""
            groups.setdefault((name, receiver, len(types)), []).append(
                (types, returns))

    wanted, unavailable = set(), set()
    for (name, receiver, arity), rows in groups.items():
        signatures = {row[0] for row in rows}
        if len(signatures) < 2:
            continue
        for position in range(arity):
            column = {s[position] for s in signatures}
            others_fixed = all(len({s[other] for s in signatures}) == 1
                               for other in range(arity) if other != position)
            if len(column & nim_integer_types) < 2 or not others_fixed:
                continue
            returns = {row[1] for row in rows
                       if row[0][position] in nim_integer_types}
            if "int64" in column and len(returns) == 1:
                wanted.add((name, position))
            else:
                unavailable.add(name)
            break

    written = ""
    for path in glob.glob("sources/june/*_lifting.nim"):
        written += open(path).read()

    missing = sorted(name for name, _ in wanted
                     if not re.search(r"^proc " + re.escape(name) +
                                      r"\*\([^)]*: int[,)]", written, re.M))
    if missing:
        print("These overload sets have an int64 form and one return type, so "
              "a proc taking Nim's int would resolve a literal, and none is "
              "written:", file=sys.stderr)
        for name in missing:
            print(f"  {name}", file=sys.stderr)
        return False

    stale = sorted(name for name in no_lossless_int_target
                   if name not in unavailable)
    if stale:
        print("These entries in no_lossless_int_target name a set that now has "
              "a lossless target, or no longer exists:", file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)
        return False

    print(f"all {len(wanted)} overload sets that can take a Nim int have a proc "
          f"that does ({len(unavailable)} have no lossless target)")
    return True


def check_one_declaration_per_signature():
    """No method is declared on both a class and a Nim ancestor.

    An override has the same parameter types as the virtual it overrides, so
    emitting both leaves Nim two procs differing only in the receiver. On the
    derived class itself the nearer one wins; on anything below it neither is
    nearer, and Nim 2.2.2 refuses the call as ambiguous. `paint` on a
    TableListBox was in that state, along with 50 others.

    Nothing catches this at generation time, and nothing catches it at compile
    time either unless a test happens to make the call on a deep enough
    receiver. It is a property of the emitted text, so it is checked here.
    """
    parents, procedures = {}, {}
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        text = open(f"sources/june/{module}.nim").read()
        parents.update(re.findall(r'^  (\w+)\*[^=\n]*= object of (\w+)', text, re.M))
        for line in text.splitlines():
            match = re.match(r'^proc (`?[\w=]+`?)\*\(this: (?:var )?(\w+)([,)])(.*)', line)
            if not match:
                continue
            name, receiver, separator, rest = match.groups()
            if separator == ")":
                arguments = ()
            else:
                body = rest.rsplit("):", 1)[0] if "):" in rest else rest.rsplit(")", 1)[0]
                arguments = tuple(part.split(":", 1)[1].strip().split(" =")[0].strip()
                                  for part in body.split(", ") if ":" in part)
            procedures.setdefault((name, receiver), set()).add(arguments)

    def ancestors(name):
        found, seen = [], set()
        while name in parents and name not in seen:
            seen.add(name)
            name = parents[name]
            found.append(name)
        return found

    children = {}
    for child, parent in parents.items():
        children.setdefault(parent, []).append(child)

    def has_descendant(name):
        return bool(children.get(name))

    # Only where a class below the derived one exists. On the derived class
    # itself Nim prefers the nearer proc, so two declarations there are
    # harmless; the ambiguity needs a receiver for which neither is nearer.
    # That distinction is what lets a covariant override stay: TableListBox
    # declares its own getModel because it returns a TableListBoxModel rather
    # than a ListBoxModel, and nothing inherits from TableListBox. A covariant
    # override on a class that DOES have descendants would land here, and it
    # would be a real conflict rather than a false alarm - the type and the
    # callability cannot both be had.
    clashes = []
    for (name, receiver), signatures in sorted(procedures.items()):
        if not has_descendant(receiver):
            continue
        for ancestor in ancestors(receiver):
            shared = signatures & procedures.get((name, ancestor), set())
            if shared:
                clashes.append(f"{name} on {receiver} and on {ancestor}")
                break

    if clashes:
        print("These are declared with the same argument types on a class and "
              "on one of its Nim ancestors, so a call on anything below the "
              "class is ambiguous:", file=sys.stderr)
        for clash in clashes[:20]:
            print(f"  {clash}", file=sys.stderr)
        if len(clashes) > 20:
            print(f"  ... and {len(clashes) - 20} more", file=sys.stderr)
        return False

    print(f"no method is declared on both a class with descendants and a Nim "
          f"ancestor ({len(procedures)} class-and-name pairs checked)")
    return True


def check_inherited_methods():
    """Every method restated from a secondary base is called by a test.

    Nim carries one parent, so a method reaching a class through any other
    public base is not inherited - it exists only because the generator
    restates it on the class. A restatement nobody calls is never handed to the
    C++ compiler, which is how the whole class of defect on this branch stayed
    invisible. Each of these is a fresh binding and gets the same treatment as
    a hand-written one.
    """
    emitted = set()
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        for method, owner in inherited_method.findall(
                open(f"sources/june/{module}.nim").read()):
            emitted.add((owner, method))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    # The receiver's type is not written at the call site, so this asks only
    # that the method name appears. Two classes inheriting the same method from
    # the same base therefore cover each other, which is why the tests below
    # name the class in the assertion message instead.
    uncalled = sorted({method for _, method in emitted
                       if method not in uncallable_inherited
                       and not re.search(r"\." + method + r"\b", used)})

    # An entry that no longer names an emitted method is stale, and a stale
    # excuse reads exactly like a live one.
    stale = sorted(name for name in uncallable_inherited
                   if name not in {method for _, method in emitted})
    if stale:
        print("These entries in uncallable_inherited name no restated method:",
              file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)
        return False

    if uncalled:
        print("These methods are restated from a secondary base and never "
              "called, so the C++ compiler never sees them:", file=sys.stderr)
        for name in uncalled[:25]:
            owners = sorted(o for o, m in emitted if m == name)
            print(f"  {name} on {', '.join(owners)}", file=sys.stderr)
        if len(uncalled) > 25:
            print(f"  ... and {len(uncalled) - 25} more", file=sys.stderr)
        return False

    print(f"all {len(emitted)} methods restated from a secondary base "
          f"are called by a test "
          f"({len(uncallable_inherited)} listed as uncallable)")
    return True


def check_macos_only_calls():
    """A behavioural test calling a macOS-only method does so under a guard.

    The bindings are generated ON macOS, so a method JUCE declares nowhere
    else still gets a proc here. Nim compiles the call; g++ on Linux does not,
    and the failure arrives a full CI cycle later. The compile harness already
    knows which methods these are - MACOS_ONLY_METHODS in its generator - and
    puts its own calls behind `when defined(macosx)`. This is the same rule
    for the behavioural tests, which had no check at all: File.isBundle was
    called unguarded and only Linux CI said so.

    A call counts as guarded when some enclosing line, at a smaller
    indentation, is `when defined(macosx)`. That is what the suite's own
    guards look like, and a false ALARM here is cheap to fix while a false
    all-clear is what this exists to prevent.

    What this does NOT catch: a macOS-only method that is not on that list.
    The list was built by compiling the harness on Linux, one round per error
    the compiler reported, so it holds the methods the harness had to call.
    A method covered behaviourally from the start never entered the harness
    and so never entered the list. Linux CI is still the backstop for those -
    it is what found isBundle - and a name added to MACOS_ONLY_METHODS when
    that happens brings the method under this check too.
    """
    harness = open("tools/generate_compile_harness.py").read()
    block = re.search(r"MACOS_ONLY_METHODS = \{(.*?)\n\}", harness, re.S)
    if block is None:
        print("MACOS_ONLY_METHODS is not where this expected it",
              file=sys.stderr)
        return False
    methods = set(re.findall(r'\(\s*"[A-Za-z_]\w*"\s*,\s*"([A-Za-z_]\w*)"\s*\)',
                             block.group(1)))

    unguarded = []
    for path in sorted(glob.glob("tests/test_juce_*.nim")):
        if path.endswith("test_juce_compiles.nim"):
            continue
        lines = open(path).read().splitlines()
        for number, line in enumerate(lines):
            call = re.search(r"\.(" + "|".join(sorted(methods)) + r")\s*\(",
                             line)
            if not call:
                continue
            indent = len(line) - len(line.lstrip())
            guarded = False
            for earlier in reversed(lines[:number]):
                if not earlier.strip():
                    continue
                earlier_indent = len(earlier) - len(earlier.lstrip())
                if earlier_indent < indent:
                    if re.match(r"when defined\(macosx\):", earlier.strip()):
                        guarded = True
                        break
                    indent = earlier_indent
            if not guarded:
                unguarded.append(f"{path}:{number + 1}  {call.group(1)}")

    if unguarded:
        print("These behavioural tests call a macOS-only method without a "
              "`when defined(macosx)` guard, so they will not compile on "
              "Linux:", file=sys.stderr)
        for entry in unguarded:
            print(f"  {entry}", file=sys.stderr)
        return False

    print(f"every behavioural call to one of the {len(methods)} macOS-only "
          f"methods is guarded")
    return True


def check_constants():
    """Every bound constant is read by a test.

    A `let` with an importcpp is not checked against C++ unless something
    reads it. A constant naming juce::NoSuchClass::nope compiles clean while
    nothing touches it, which was measured rather than assumed: when this was
    first checked, most of the bound constants had never had their spelling
    put to the compiler. The count this prints is the live one.
    """
    emitted = set()
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        emitted.update(bound_constant.findall(
            open(f"sources/june/{module}.nim").read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    unread = sorted(name for name in emitted
                    if not re.search(r"\b" + name + r"\b", used))
    if unread:
        print("These constants are never read, so their C++ spelling is not "
              "checked:", file=sys.stderr)
        for name in unread[:20]:
            print(f"  {name}", file=sys.stderr)
        if len(unread) > 20:
            print(f"  ... and {len(unread) - 20} more", file=sys.stderr)
        return False

    print(f"all {len(emitted)} bound constants are read by a test")
    return True


static_variable = re.compile(
    r'^proc (\w+)\*\(this: typedesc\[\w+\]\): [^{]+\{[^}]*importcpp: "\(', re.M)


def check_static_variables():
    """Every bound static variable is read by a test.

    Bound as a proc over the typedesc, so it is compiled only where it is
    called - exactly like the constants, and 99 of the 111 had never had their
    C++ spelling checked.
    """
    emitted = set()
    for module in ("juce_core", "juce_events", "juce_data_structures",
                   "juce_graphics", "juce_gui_basics"):
        emitted.update(static_variable.findall(
            open(f"sources/june/{module}.nim").read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    unread = sorted(name for name in emitted
                    if not re.search(r"\b" + name + r"\b", used))
    if unread:
        print("These static variables are never read, so their C++ spelling "
              "is not checked:", file=sys.stderr)
        for name in unread[:20]:
            print(f"  {name}", file=sys.stderr)
        return False

    print(f"all {len(emitted)} static variables are read by a test")
    return True


def check_handlers():
    """Every generated handler setter is called by a test.

    A setter nothing calls is neither type-checked in its body nor generated,
    and the C++ field it assigns to is never written. Calling them is what
    caught CustomImagePixelData::clone being typed against the wrong class's
    Ptr, and what showed that UniquePtr, ReferenceCountedObjectPtr, CppVector
    and CppString had no constructor, so no override returning one could be
    written at all.
    """
    emitted = set()
    for path in (glob.glob("sources/june/*_subclasses.nim")
                 + glob.glob("sources/june/*_lifting.nim")):
        emitted.update(handler_setter.findall(open(path).read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    uncalled = sorted(name for name in emitted
                      if name not in uncallable_handlers
                      and not re.search(r"\b" + name + r"\b", used))
    stale = sorted(name for name in uncallable_handlers if name not in emitted)

    if uncalled:
        print("These handler setters are never called, so nothing type-checks "
              "or generates them:", file=sys.stderr)
        for name in uncalled:
            print(f"  {name}", file=sys.stderr)
    if stale:
        print("These are listed as uncallable handlers but no longer exist:",
              file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)

    if not (uncalled or stale):
        print(f"all {len(emitted) - len(uncallable_handlers)} handler setters "
              f"are called ({len(uncallable_handlers)} listed as uncallable)")
    return not (uncalled or stale)


def check_implicit_defaults():
    """Every aggregate given an implicit default constructor is built by a test.

    libclang reports no constructor for a struct that declares none, and it
    does not report that C++ deleted the implicit one because a member has no
    default either. ColourLayer and GlyphLayer are both that case. Only a call
    tells them apart, so each of these has to be called.
    """
    emitted = set()
    for path in glob.glob("sources/june/juce_*.nim"):
        emitted.update(implicit_default.findall(open(path).read()))

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            used += open(path).read()

    uncalled = sorted(name for name in emitted
                      if not re.search(r"\b" + name + r"\b", used))
    if uncalled:
        print("These aggregates get an implicit default constructor that no "
              "test builds, so nothing compiles it:", file=sys.stderr)
        for name in uncalled:
            print(f"  {name}", file=sys.stderr)
        return False

    print(f"all {len(emitted)} implicit default constructors are built by a test")
    return True


def check_iterator_promises():
    """Every class whose begin() was withheld naming a Nim iterator has one."""
    promised = set()
    for path in glob.glob("sources/june/juce_*.nim"):
        promised.update(iterator_promise.findall(open(path).read()))

    provided = set()
    for path in glob.glob("sources/june/*.nim"):
        provided.update(nim_iterator.findall(open(path).read()))

    broken = sorted(promised - provided - set(no_iterator_possible))
    stale = sorted(name for name in no_iterator_possible if name not in promised)

    if broken:
        print("These classes have begin() withheld with a reason that names a "
              "Nim iterator, and no such iterator exists:", file=sys.stderr)
        for name in broken:
            print(f"  {name}", file=sys.stderr)
    if stale:
        print("These are listed as having no possible iterator but no longer "
              "have a withheld begin():", file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)

    if not (broken or stale):
        print(f"all {len(promised - set(no_iterator_possible))} withheld "
              f"begin() reasons name an iterator that exists "
              f"({len(no_iterator_possible)} cannot have one)")
    return not (broken or stale)


def main():
    declared = {}
    for name in hand_written:
        path = os.path.join("sources", "june", name)
        if not os.path.exists(path):
            continue
        with open(path) as handle:
            for line in handle:
                match = export.match(line)
                if match:
                    declared.setdefault(match.group(1), name)

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            with open(path) as handle:
                used += handle.read()

    uncovered = sorted(
        name for name in declared
        if name not in uncallable
        and not re.search(r"\b" + re.escape(name) + r"\b", used))

    stale = sorted(name for name in uncallable if name not in declared)

    if stale:
        print("These are listed as uncallable but no longer exist:", file=sys.stderr)
        for name in stale:
            print(f"  {name}", file=sys.stderr)

    if uncovered:
        print(f"{len(uncovered)} hand-written binding(s) are never called, so "
              f"nothing compiles their importcpp:", file=sys.stderr)
        for name in uncovered:
            print(f"  {name}  ({declared[name]})", file=sys.stderr)
        print("Call it from a test, or add it to `uncallable` with the reason "
              "a test cannot.", file=sys.stderr)

    iterators_ok = check_iterator_promises()
    defaults_ok = check_implicit_defaults()
    subclasses_ok = check_subclasses()
    handlers_ok = check_handlers()
    constructors_ok = check_no_argument_constructors()
    constants_ok = check_constants()
    statics_ok = check_static_variables()
    classes_ok = check_classes()
    inherited_ok = check_inherited_methods()
    signatures_ok = check_one_declaration_per_signature()
    literals_ok = check_integer_literal_overloads()
    fields_ok = check_field_accessors()
    macos_ok = check_macos_only_calls()

    if (uncovered or stale or not iterators_ok or not defaults_ok
            or not subclasses_ok or not handlers_ok or not constructors_ok
            or not constants_ok or not statics_ok or not classes_ok
            or not inherited_ok or not signatures_ok
            or not literals_ok or not fields_ok or not macos_ok):
        sys.exit(1)

    print(f"all {len(declared)} hand-written binding names are called "
          f"({len(uncallable)} listed as uncallable)")


if __name__ == "__main__":
    main()

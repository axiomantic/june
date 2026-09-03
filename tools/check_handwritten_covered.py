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
import pathlib
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

    Only the no-argument ones. A sweep that invents arguments was tried and
    abandoned: a JUCE constructor does real work, and the invented values sent
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


def check_licence_headers():
    """Every file under sources/ carries the project's copyright notice, once.

    A generated file is still a file in this repository. When the generator's
    prolog omits the notice, regenerating silently removes the line naming the
    project's authors - and the result would be offered upstream with the
    upstream author's own copyright stripped out of it.

    A GENERATED file is compared byte for byte against a hand-written one,
    because the notice contains a NON-BREAKING SPACE after the first two
    hashes. A normal space there reads identically and would leave the
    generated modules subtly different from everything around them.

    A HAND-WRITTEN file only has to carry the notice. Two of them - june_stl
    and june_juce_types - spell it with an ordinary space, and that is how the
    project's authors wrote them; normalising their bytes is not this check's
    business. What is checked everywhere is that the notice appears exactly
    ONCE, because a generator that prepends it to a file that already carries
    one produces a doubled header, and a check reading only the first six lines
    cannot see that.
    """
    reference = pathlib.Path("sources/june/juce_core_lifting.nim")
    expected = "\n".join(reference.read_text(encoding="utf-8").split("\n")[:6])
    marker = "June - Copyright (c)"
    modules = ("juce_core", "juce_events", "juce_data_structures",
               "juce_graphics", "juce_gui_basics")
    generated = {f"{m}.nim" for m in modules}
    generated |= {f"{m}_subclasses.nim" for m in modules}

    wrong, absent, doubled = [], [], []
    for path in sorted(pathlib.Path("sources").rglob("*.nim")):
        text = path.read_text(encoding="utf-8")
        head = "\n".join(text.split("\n")[:6])
        is_generated = path.name in generated
        if marker not in head:
            absent.append(path)
        elif is_generated and head != expected:
            wrong.append(path)
        elif text.count(marker) != 1:
            doubled.append((path, text.count(marker)))

    for path in absent:
        print(f"{path} does not open with the project's copyright notice",
              file=sys.stderr)
    for path in wrong:
        print(f"{path} is generated, so its notice must match "
              f"{reference} byte for byte (note the non-breaking space)",
              file=sys.stderr)
    for path, count in doubled:
        print(f"{path} carries the copyright notice {count} times",
              file=sys.stderr)
    return not (absent or wrong or doubled)


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

    licences_ok = check_licence_headers()
    iterators_ok = check_iterator_promises()
    defaults_ok = check_implicit_defaults()
    subclasses_ok = check_subclasses()
    handlers_ok = check_handlers()
    constructors_ok = check_no_argument_constructors()

    if (uncovered or stale
            or not licences_ok
            or not iterators_ok
            or not defaults_ok
            or not subclasses_ok
            or not handlers_ok
            or not constructors_ok):
        sys.exit(1)

    print(f"all {len(declared)} hand-written binding names are called "
          f"({len(uncallable)} listed as uncallable)")


if __name__ == "__main__":
    main()

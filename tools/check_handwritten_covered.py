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

    if uncovered or stale or not iterators_ok or not defaults_ok:
        sys.exit(1)

    print(f"all {len(declared)} hand-written binding names are called "
          f"({len(uncallable)} listed as uncallable)")


if __name__ == "__main__":
    main()

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

    if uncovered or stale or not licences_ok:
        sys.exit(1)

    print(f"all {len(declared)} hand-written bindings are called "
          f"({len(uncallable)} listed as uncallable)")


if __name__ == "__main__":
    main()

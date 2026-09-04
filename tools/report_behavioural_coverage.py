"""Report which bound methods no behavioural test calls.

The compile harness calls every bound method once, so it answers "does this
binding reach the C++ compiler". This answers the other question: "does
anything assert what the method DOES".

ONE UNIT is one bound method declaration whose first parameter is `this` - that
is, one method on one class. A free function, an operator and a static are not
counted, because the harness classifies those separately and they have no
receiver to group them under.

A method counts as CALLED when its name appears after a dot and before an open
parenthesis OR another dot, anywhere in a behavioural test file. The second case
matters: `button[].onClick.invoke()` exercises the onClick getter, and matching
only on a following parenthesis missed every getter chained into a further call.

It is still generous in one direction and strict in another:

  - generous, because it matches by name rather than by receiver, so a method
    called on one class marks the same name on another;
  - strict, because a getter whose result is bound to a variable and used on the
    next line - `var f = x.hook` - is not matched at all.

So a name reported uncalled may still be exercised, and a name reported called
may have been called on a different class. The figure is a rough measure meant
for tracking a direction between runs, not a coverage guarantee - the gate that
actually fails a build is tools/check_handwritten_covered.py.

test_juce_compiles.nim is excluded, because counting it would mark everything
covered and answer the harness's question instead of this one.

OVERLOADS COLLAPSE. `setBounds(x, y, w, h)` and `setBounds(rect)` are one unit,
because a behavioural test calling either one exercises the name. That is why
the total here (4528) is smaller than the number of receiver-taking proc LINES
in the same files (7169) - the two counts differ by exactly the overloads, and
a figure close to 7169 would mean this script had started counting lines.
"""

import collections
import pathlib
import re
import sys

TESTS = pathlib.Path("tests")
SOURCES = pathlib.Path("sources/june")
HARNESS = "test_juce_compiles.nim"

# Classes whose remaining methods a headless behavioural test cannot reach.
# Each name is here because a test was written against it and the reason was
# measured, not guessed; README's "What Is Tested" section records which.
UNREACHABLE = {
    "ComponentPeer": "needs a native window",
    "MouseInputSource": "needs a real input device",
    "MouseEvent": "needs a real input device",
    "AccessibilityHandler": "needs a native window handle",
    "AccessibilityNativeHandle": "defined per platform",
    "JUCEApplicationBase": "the process's single application instance",
    "JUCEApplication": "the process's single application instance",
    "JUCEApplicationImpl": "the process's single application instance",
}

# The same, one method at a time, for a class whose OTHER methods a test can
# reach. Keyed "Class.method".
UNREACHABLE_METHODS = {
    "File.addToDock": "writes the user's Dock preferences and restarts the Dock",
}


def called_names():
    names = set()
    for path in sorted(TESTS.glob("test_juce_*.nim")):
        if path.name == HARNESS:
            continue
        text = path.read_text()
        # The backticks are optional: a method whose name is a Nim keyword is
        # called as `x.\`type\`()`, and without them the call reads as
        # uncalled while the test really does make it.
        names |= {m.group(1)
                  for m in re.finditer(
                      r"\.`?([A-Za-z_][A-Za-z0-9_]*)`?\s*[(.]", text)}
    return names


def methods_by_class():
    per = collections.defaultdict(set)
    for path in sorted(SOURCES.glob("juce_*.nim")):
        if path.name.endswith(("_lifting.nim", "_subclasses.nim")):
            continue
        for line in path.read_text().splitlines():
            match = re.match(
                r"proc (`?[A-Za-z_][A-Za-z0-9_]*`?)\*\("
                r"this: (?:var )?([A-Za-z_][A-Za-z0-9_]*)[,)]", line)
            if match:
                per[match.group(2)].add(match.group(1).strip("`"))
    return per


def main():
    called = called_names()
    per = methods_by_class()

    total = sum(len(names) for names in per.values())
    missing = {cls: names - called for cls, names in per.items()}
    uncalled = {cls: len(names) for cls, names in missing.items() if names}

    unreachable = sum(count for cls, count in uncalled.items()
                      if cls in UNREACHABLE)
    unreachable += sum(
        1 for cls, names in missing.items() if cls not in UNREACHABLE
        for name in names if f"{cls}.{name}" in UNREACHABLE_METHODS)
    every_uncalled = sum(uncalled.values())
    remaining = every_uncalled - unreachable

    # A class listed method by method drops out of the gap table once every
    # one of its remaining methods is listed.
    for cls, names in missing.items():
        if cls in UNREACHABLE:
            continue
        left = sum(1 for name in names
                   if f"{cls}.{name}" not in UNREACHABLE_METHODS)
        if left:
            uncalled[cls] = left
        else:
            uncalled.pop(cls, None)

    # A fixed-column table, so a later run can be diffed against this one.
    print(f"{'methods':>8}  what")
    print(f"{total:>8}  bound methods with a receiver")
    print(f"{total - every_uncalled:>8}  called by a behavioural test")
    print(f"{unreachable:>8}  uncalled, and unreachable without a window, "
          f"an input device or the app instance")
    print(f"{remaining:>8}  uncalled, and reachable")
    print()

    reachable = sorted(((count, cls) for cls, count in uncalled.items()
                        if cls not in UNREACHABLE), reverse=True)
    print(f"{'methods':>8}  largest reachable gaps")
    for count, cls in reachable[:15]:
        print(f"{count:>8}  {cls}")
    print()

    spread = collections.Counter()
    for count, _ in reachable:
        spread["10 or more" if count >= 10
               else "5 to 9" if count >= 5 else "1 to 4"] += 1
    print(f"{'classes':>8}  spread of the reachable gaps")
    for band in ("10 or more", "5 to 9", "1 to 4"):
        print(f"{spread[band]:>8}  classes with {band} uncalled")

    return 0


if __name__ == "__main__":
    sys.exit(main())

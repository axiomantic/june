"""Report which bound methods no behavioural test calls.

The compile harness calls the bound methods no behavioural test reaches and a
call can be built for, so it answers "does this binding reach the C++
compiler". This answers the other question: "does
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
because a behavioural test calling either one exercises the name.

The sanity check on that used to be a sentence, and the sentence was false. It
said the total was smaller than the number of receiver-taking proc LINES in the
same files "by exactly the overloads". It is not. The extraction pattern
matches only some of those lines, and only THOSE are then collapsed by class;
the rest it never matched at all. So the gap between the two figures is mostly
exclusion rather than collapse, and an invariant stated that loosely would not
notice this script dropping an entire declaration shape.

check_line_classification() replaces it, and is mechanical. It sorts every
receiver-taking proc line into counted, operator or static - operators and
statics being what this file says above that it does not count - and fails when
a line falls into none of the three. A declaration shape excluded in silence is
what is worth catching. The figures are printed rather than written down here,
because a figure in a docstring is wrong at the next commit and nothing says so.

WHAT MAKES THIS SCRIPT EXIT NON-ZERO. Not a coverage figure: this is a report,
and no number it prints is a verdict. It exits non-zero only when the script
itself is inconsistent with the tree - a receiver-taking declaration of a shape
it counts under no heading. That is an error in this file, and a report that
cannot be trusted to describe the tree is worse than no report.
"""

import collections
import pathlib
import re
import sys

TESTS = pathlib.Path("tests")
SOURCES = pathlib.Path("sources/june")
HARNESS = "test_juce_compiles.nim"

# Every proc line that takes a receiver, and the three shapes it can have.
# COUNTED is the extraction this whole report is built on; the other two are
# the shapes the docstring says are deliberately not counted. A receiver-taking
# line matching none of them is a shape nobody decided about, which is what
# check_line_classification() below exists to report.
RECEIVER_LINE = re.compile(r"proc .*\(this: ")
COUNTED = re.compile(r"proc (`?[A-Za-z_][A-Za-z0-9_]*`?)\*\("
                     r"this: (?:var )?([A-Za-z_][A-Za-z0-9_]*)[,)]")
OPERATOR = re.compile(r"proc `[^`]+`\*\(")
STATIC = re.compile(r"proc [^(]*\*\(this: typedesc\[")

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
    # Abstract, and no subclass is generated for it: getRowSpan returns an
    # Optional<Span> the generator cannot spell, which
    # juce_gui_basics_subclasses.nim records among the withheld ones. So the
    # only instance a test could reach comes from an AccessibilityHandler,
    # which needs a native window handle.
    "AccessibilityTableInterface": "abstract, and no subclass is generated",
}

# The same, one method at a time, for a class whose OTHER methods a test can
# reach. Keyed "Class.method".
UNREACHABLE_METHODS = {
    "File.addToDock": "writes the user's Dock preferences and restarts the Dock",
    "Toolbar.showCustomisationDialog":
        "builds a modal DialogWindow on a queue nothing here turns",
    "Toolbar.setCurrentDragImage":
        "dereferences dragImageComponents[0], which is null with no live drag",
    "ToolbarItemPalette.setCurrentDragImage":
        "dereferences dragImageComponents[0], which is null with no live drag",
    "DragAndDropContainer.setCurrentDragImage":
        "dereferences dragImageComponents[0], which is null with no live drag",
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


def binding_modules():
    """The generated module files every count in this report is taken from."""
    return [path for path in sorted(SOURCES.glob("juce_*.nim"))
            if not path.name.endswith(("_lifting.nim", "_subclasses.nim"))]


def methods_by_module():
    """{module: {class: {method}}}, from the generated bindings only."""
    per_module = {}
    for path in binding_modules():
        per = collections.defaultdict(set)
        for line in path.read_text().splitlines():
            match = COUNTED.match(line)
            if match:
                per[match.group(2)].add(match.group(1).strip("`"))
        per_module[path.stem] = per
    return per_module


def methods_by_class():
    per = collections.defaultdict(set)
    for module in methods_by_module().values():
        for cls, names in module.items():
            per[cls] |= names
    return per


def check_line_classification():
    """Every receiver-taking proc line is counted, an operator, or a static.

    The total this report prints is built by one pattern, and a pattern that
    stops matching a declaration shape does not fail - it drops those
    declarations and the total simply gets smaller. Nothing in the output
    distinguishes "the bindings shrank" from "this script stopped seeing part
    of them", which is the failure the rest of this file is written against.

    So the three shapes are made to account for the whole population. Counted,
    operator and static are exhaustive over the receiver-taking proc lines
    today; a line matching none of them is a fourth shape, and it is reported
    here rather than silently left out of the total.
    """
    counts = collections.Counter()
    unclassified = []
    for path in binding_modules():
        for number, line in enumerate(path.read_text().splitlines(), 1):
            if not RECEIVER_LINE.match(line):
                continue
            if COUNTED.match(line):
                counts["counted"] += 1
            elif OPERATOR.match(line):
                counts["operator"] += 1
            elif STATIC.match(line):
                counts["static"] += 1
            else:
                unclassified.append(f"{path}:{number}  {line.strip()[:90]}")

    total = sum(counts.values()) + len(unclassified)
    print(f"{'lines':>8}  receiver-taking proc lines in the bindings")
    print(f"{total:>8}  in the five generated modules")
    print(f"{counts['counted']:>8}  matched by the pattern this report counts")
    print(f"{counts['operator']:>8}  operators, not counted (applied as syntax)")
    print(f"{counts['static']:>8}  statics on typedesc, not counted (no "
          f"receiver)")

    if unclassified:
        print(f"\nreceiver-taking declarations matching none of the three "
              f"shapes above ({len(unclassified)}), and so missing from every "
              f"figure this report prints without being excluded on purpose:",
              file=sys.stderr)
        for entry in unclassified[:20]:
            print(f"  {entry}", file=sys.stderr)
        if len(unclassified) > 20:
            print(f"  ... and {len(unclassified) - 20} more", file=sys.stderr)
        return False
    return True


def is_reachable(cls, method):
    return (cls not in UNREACHABLE
            and f"{cls}.{method}" not in UNREACHABLE_METHODS)


def print_remaining():
    """Every reachable-and-uncalled method, by module and then by class.

    This is what docs/coverage-roadmap.rst describes the shape of. The doc
    carries the shape because that is what a reader needs; this carries the
    list, because a list in a document is wrong the moment a test is written.
    """
    called = called_names()
    for module, per in methods_by_module().items():
        rows = []
        for cls, names in per.items():
            left = sorted(n for n in names - called if is_reachable(cls, n))
            if left:
                rows.append((len(left), cls, left))
        if not rows:
            continue
        rows.sort(key=lambda row: (-row[0], row[1]))
        methods = sum(row[0] for row in rows)
        print(f"\n{module}  ({methods} methods, {len(rows)} classes)")
        for count, cls, left in rows:
            print(f"  {count}  {cls}: {' '.join(left)}")
    return 0


def main():
    # The integrity check runs in both modes and alone decides the exit
    # status. No figure below is a verdict: a coverage number moving is news,
    # not a failure, and only this script disagreeing with the tree is.
    sound = check_line_classification()
    print()

    if "--remaining" in sys.argv[1:]:
        print_remaining()
        return 0 if sound else 1

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

    return 0 if sound else 1


if __name__ == "__main__":
    sys.exit(main())

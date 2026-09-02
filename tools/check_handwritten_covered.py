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
    # june_cpp_utils exports the defineCppClass macros. It was left out, so
    # they were checked by nothing; both are called, so listing it costs
    # nothing and closes the hole by file as the keyword above closes it by
    # declaration.
    "june_cpp_utils.nim",
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

# `macro` belongs here with the rest. A macro is only checked where it is
# expanded, exactly as an importcpp proc is only checked where it is called, so
# a macro nothing expands is unverified in the same way and for the same
# reason. Omitting the keyword left this gate reporting every hand-written
# binding covered while it could not see that kind of export at all.
#
# The backtick group matches an OPERATOR name. `\w+` cannot: it stops at the
# first punctuation, so `==`, `[]`, `$`, `=destroy` and the rest matched
# nothing at all. Fifty-two of the three hundred and eighteen exported
# declarations here were invisible, and this gate printed "all N hand-written
# binding names are called" without ever having looked at one of them.
export = re.compile(
    r'(?:proc|iterator|template|converter|macro) (`[^`]+`|\w+)\*')

# Every exported operator, and how it is verified.
#
# An operator is applied as SYNTAX - `a == b`, `$x`, `s[i]` - and never as
# `a.==(b)`, so the by-name search below cannot find its call sites. Widening
# the pattern alone would report all nine as uncalled; one blanket exemption
# would report all nine as covered. Both are false, so each name says how it is
# actually checked, and each way of checking is mechanical.
#
# "applied": a fragment of the tests that applies the operator, which has to
# still be there. Chosen so it can only mean this declaration - `makeString
# ("aa") < makeString("bb")` rather than a StringRef on the left, which picks
# the generated `<`(StringRef, String) instead.
#
# "no binding": every declaration of that name carries no importcpp, so there
# is no C++ string for a call site to compile and this gate's premise does not
# apply to it. Checked against the declarations rather than promised: adding
# one with an importcpp fails the gate and asks for a fragment instead.
#
# The by-name limit of the rest of this file applies here too. One fragment
# covers a NAME, so `<` is witnessed by String and the CppTypeIndex `<` beside
# it rides on that. That is the same trade the file makes everywhere else.
APPLIED, NO_BINDING = "applied", "no binding"

operator_uses = {
    "$": (APPLIED, '$greeting'),
    "()": (APPLIED, '`()`(native, noArguments)'),
    "<": (APPLIED, 'makeString("aa") < makeString("bb")'),
    "<=": (APPLIED, 'makeString("aa") <= makeString("aa")'),
    "==": (APPLIED, 'makeRange(0.cint, 10.cint) == makeRange(0.cint, 10.cint)'),
    "[]": (APPLIED, 'table[0.cint].getRed()'),
    "[]=": (APPLIED, 'headers[makeString("accept")] = makeString("text/plain")'),
    # `=destroy` is `= discard` and `=copy` is `{.error.}`. Neither names a C++
    # expression, and `=copy` is a deletion marker whose whole purpose is that
    # reaching it is a compile error - a test that called one could not build.
    "=destroy": (NO_BINDING, None),
    "=copy": (NO_BINDING, None),
}

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


def check_operators(declared, lines_by_name, used):
    """Every exported operator, against the way operator_uses says it is checked.

    Returns the messages that make this fail. Three ways to fail, and each is
    read off the tree rather than trusted: an entry naming an operator that no
    longer exists, an operator with no entry, and an entry whose fragment is no
    longer in the tests.
    """
    problems = []
    operators = {name for name in declared if not name.isidentifier()}

    for name in sorted(operator_uses):
        if name not in operators:
            problems.append(
                f"`{name}` is listed in operator_uses but is no longer an "
                f"exported operator")

    for name in sorted(operators):
        if name not in operator_uses:
            problems.append(
                f"`{name}` is exported but operator_uses does not say how it "
                f"is checked. An operator is applied as syntax, so the "
                f"by-name search cannot find its call sites: add the fragment "
                f"of the tests that applies it.")
            continue

        kind, fragment = operator_uses[name]
        if kind == APPLIED:
            if fragment not in used:
                problems.append(
                    f"`{name}` is recorded as applied by  {fragment}  and "
                    f"that is no longer in the tests or examples")
        else:
            bound = [line.strip() for line in lines_by_name[name]
                     if "importcpp" in line]
            if bound:
                problems.append(
                    f"`{name}` is recorded as having no C++ binding behind "
                    f"it, but one of its declarations now has an importcpp:\n"
                    f"    {bound[0]}")
    return problems


def main():
    declared = {}
    declarations = []
    lines_by_name = {}
    for name in hand_written:
        path = os.path.join("sources", "june", name)
        if not os.path.exists(path):
            continue
        with open(path) as handle:
            for line in handle:
                match = export.match(line)
                if match:
                    routine = match.group(1).strip("`")
                    declared.setdefault(routine, name)
                    # Kept alongside, because setdefault throws the second
                    # and later files away: `items` is declared in five of
                    # these and `release` in two. The check is by NAME on
                    # purpose, but the figure printed at the end must not
                    # read as a count of declarations when it is a count of
                    # names.
                    declarations.append((routine, name))
                    lines_by_name.setdefault(routine, []).append(line)

    used = ""
    for pattern in ("tests/test_juce_*.nim", "examples/*.nim"):
        for path in glob.glob(pattern):
            with open(path) as handle:
                used += handle.read()

    # Operators are held to operator_uses instead: `\b==\b` matches nothing,
    # and a name-shaped search for one would answer a question nobody asked.
    by_name = {name for name in declared if name.isidentifier()}

    uncovered = sorted(
        name for name in by_name
        if name not in uncallable
        and not re.search(r"\b" + re.escape(name) + r"\b", used))

    stale = sorted(name for name in uncallable if name not in declared)

    operator_problems = check_operators(declared, lines_by_name, used)

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

    for problem in operator_problems:
        print(problem, file=sys.stderr)

    licences_ok = check_licence_headers()
    iterators_ok = check_iterator_promises()

    if (uncovered or stale or operator_problems
            or not licences_ok or not iterators_ok):
        sys.exit(1)

    shared = len(declarations) - len(declared)
    operators = len(declared) - len(by_name)
    print(f"all {len(declared)} hand-written binding names are exercised: "
          f"{len(by_name)} found by name in the tests "
          f"({len(uncallable)} of them listed as uncallable), "
          f"{operators} operators held to operator_uses"
          + (f", {shared} declarations share a name with another"
             if shared else ""))


if __name__ == "__main__":
    main()

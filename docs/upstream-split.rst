==========================================
Splitting This Work For Upstream Submission
==========================================

``update-juce`` is one branch of about 55,000 changed lines. Nobody reviews
that. This describes how it divides, what each division would cost a reviewer,
and the order that puts the most valuable and most obviously-correct work
first.

Nothing here has been submitted anywhere. It is analysis.


The constraint that decides the shape
=====================================

CI regenerates both generators and fails on any diff, so **a generator change
and its regenerated output cannot be separated**. Every chunk that touches
``tools/inspect_juce.py`` drags a slice of ``sources/june/juce_*.nim`` with it,
and because they all touch the same five module files, the chunks form a
LINEAR STACK. They are not independent PRs that can be reviewed in parallel.

That is a property of the verification, not an accident of how the work was
done. Dropping it would let a generator change land without its output, which
is the state that hid the original defect.


What the 55,000 lines actually are
==================================

Measured with ``git diff --numstat origin/main...origin/update-juce``:

=========================  =====  ======  ==========
area                       files   added  nature
=========================  =====  ======  ==========
behavioural tests              5  29,998  additive
generated bindings            10   9,462  mechanical
generated compile harness      1   5,666  mechanical
generators and gates           6   5,082  authored
generated subclasses           5   1,925  mechanical
hand-written bindings          5   1,062  authored
docs, CI, build               14   1,613  small
=========================  =====  ======  ==========

About 47,000 lines are machine-produced or purely additive. The authored,
genuinely-reviewable surface is roughly **7,700 lines**, and half of that is
one file: ``tools/inspect_juce.py``, at +2,596 over 94 commits.


What each chunk would cost a reviewer
=====================================

The figures below are the CUMULATIVE diff of the five generated module files
against ``main`` -- ``juce_core``, ``juce_events``, ``juce_data_structures``,
``juce_graphics``, ``juce_gui_basics``, and not ``_lifting`` or ``_subclasses``
-- at the point each milestone lands. That is what a reviewer of that chunk
sees.

It is NOT the per-commit churn. Cumulative churn across the 94 generator
commits is +12,801/-7,803, but that double-counts every line a later commit
rewrote. Sizing chunks from per-commit churn overstates them.

==========  ==================  =================  =====
stop after  milestone           generated diff     share
==========  ==================  =================  =====
commit 11   resolved types      +2,741 / -2,764      31%
commit 12   enums, ctors        +4,159 / -2,693      46%
commit 13   operators, widths   +5,101 / -3,641      57%
commit 19   enumerators         +4,955 / -3,617      55%
commit 414  final               +8,978 / -4,042     100%
==========  ==================  =================  =====

Three things follow.

**The root-cause fix is a small PR.** Stopping after it gives +2,741/-2,764,
and nearly half is deletions, because it replaces wrong ``int`` declarations
with right ones. A reviewer sees a mostly one-for-one substitution with an
obvious story rather than thousands of lines of new surface.

**The churn is front-loaded.** The first 13 commits carry 57% of the final
generated diff. The remaining 395 commits add about 4,000 lines between them,
and most regenerate under 50 lines each: of the 94 generator commits, 52 move
fewer than 50 generated lines and 5 regenerate nothing at all.

**One chunk shrinks the output.** Between commits 13 and 19 the cumulative
diff falls from +5,101 to +4,955, because binding enumerators by name replaced
a more verbose form. That chunk reduces the generated surface rather than
growing it.

To re-derive any row::

  git diff --numstat origin/main <commit> -- \
    sources/june/juce_core.nim sources/june/juce_events.nim \
    sources/june/juce_data_structures.nim sources/june/juce_graphics.nim \
    sources/june/juce_gui_basics.nim


The order to submit in
======================

Ordered by dependency first, then by descending certainty of acceptance.

1. **Make it build again.** JUCE 6.0.8 to 8.0.15, Linux support, CMake and
   nim.cfg, the submodule over HTTPS, the ``defineCppClass`` header emission
   bug, the test-suite imports, and CI. About 1,000 lines. Independently
   valuable whatever happens to the rest: the project does not build without
   it, and the test suite did not compile on any JUCE version. It also
   installs the CI that every later chunk leans on.

2. **Root-cause type resolution.** Headers were parsed with no include path,
   so every cross-module type silently became ``int`` and the generator
   emitted a complete binding for a type it had not understood. Parse
   diagnostics stop the run now. One conceptual change, a symptom worth
   stating plainly - ``Component.paint`` took a ``var int`` - and about 2,700
   lines of mechanically explainable output that CI regenerates.

3. **The three other heavy themes, one PR each.** Enums, constructors and
   containers; operators, integer widths and nested owners; enumerators by
   name. Each is a single idea.

4. **The long tail, grouped by theme.** Const-correctness, inheritance,
   closures, nested namespaces, and the rest. Small generated diffs, easy to
   accept or decline one at a time.

5. **The verification layer, last.** Compile harness, the three gates, and the
   behavioural tests. Large but purely additive, and it is the evidence for
   every claim the earlier chunks make.

There is a tension in that order worth deciding deliberately. Chunks 3 to 5
hold the evidence, and they land last. Pulling the compile harness and
``check_handwritten_covered.py`` forward into chunk 2 would make "the
regeneration is correct" checkable at the point it is first claimed rather
than several PRs later.


The question no measurement answers
===================================

Whether upstream wants the generated bindings committed at all, and whether it
wants a verification layer of this size. Every figure above assumes yes. If the
answer is no, the split is not the thing to change - the shape of the
contribution is.

Ask before splitting. A short issue describing the shape and asking what would
be accepted costs one message and can save the whole exercise.

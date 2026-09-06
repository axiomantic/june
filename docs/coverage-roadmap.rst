========================================
Behavioural Coverage: What Is Left To Do
========================================

This document describes the SHAPE of the remaining behavioural-coverage work
and how to decide what to pick up next. It does not carry the list of methods.
The list lives in the tool, because a list written into a document is wrong the
moment the next test is written::

  python3 tools/report_behavioural_coverage.py --remaining

That prints every reachable-and-uncalled method, grouped by module and then by
class, largest class first. The figures below were measured with it; re-run it
rather than trusting them.


Where things stand
==================

Run the tool with no arguments for the current table. At the time this document
was written it read:

=======  =========================================================
methods  what
=======  =========================================================
   4528  bound methods with a receiver
   4107  called by a behavioural test
     82  uncalled, and unreachable without a window, an input device
         or the app instance
    339  uncalled, and reachable
=======  =========================================================

One unit is one bound method on one class, and overloads collapse into one. The
match is by NAME rather than by receiver, which makes the uncalled figure a
lower bound: it never claims coverage that is not there, and it may credit a
method because a same-named one elsewhere was called. README's "What Is Tested"
section states the rest of the counting rules.


The shape of the remainder
==========================

The 339 are spread across 210 classes:

=======  =================
classes   uncalled methods
=======  =================
      6                  4
     32                  3
     47                  2
    125                  1
=======  =================

No class has five or more. That is the fact that governs how to spend effort
here: the large blocks are gone, and what is left costs roughly the same
per-class overhead as a large one did while returning a quarter as much. A
class still has to be read in the JUCE source, its real behaviour established
rather than assumed, and any ownership rule found the hard way before a test
can assert anything true about it.

By module:

====================  =========  =========
module                 methods    classes
====================  =========  =========
juce_gui_basics             197        117
juce_core                    79         52
juce_graphics                39         23
juce_events                  16         13
juce_data_structures          8          5
====================  =========  =========


How to pick the next one
========================

Work down from the largest class, and prefer these in order:

1. **A class whose remaining methods are pure queries.** They need no window,
   no thread and no ownership reasoning, so the test is short and the
   assertions are about arithmetic or about a relation between two answers.

2. **A listener or interface with a generated ``Custom`` subclass.** The
   overrides are installed from Nim and the methods are then called through the
   BASE class, which is what shows the override really reached C++. Several
   classes in the remainder are this shape.

3. **A class whose methods have empty bodies in JUCE.** No subclass is
   generated for these - there is nothing to override - so what is worth
   pinning is the DEFAULT each one gives, which is what a caller who overrides
   only one of them relies on. ``ValueTree::Listener`` and ``ListBoxModel``
   were both done this way.

Leave for last anything that shows a modal window, needs a live drag, or writes
outside the temporary directory. Some of those turn out to have exactly one
path that does nothing - a disabled ``ComboBox``, a ``TableHeaderComponent``
with no columns to offer - and that path is worth taking. The rest belong in
the unreachable lists below.


Rules this branch learned the hard way
======================================

**Assert what JUCE does, not what the name suggests.** Roughly forty
expectations on this branch were wrong while the binding was right.
``EdgeTable``'s clipping does not narrow its bounds to the intersection;
``GridTrackInfo::isPixels`` is only the negation of ``isFractional``, so an
auto track answers yes to it; ``ComponentBuilder::registerStandardComponentTypes``
registers nothing at all; ``Colours::green`` has a green channel of 128. Every
one of those is now recorded next to the assertion that found it, with the JUCE
file and line. Do the same: read the implementation before writing the
expectation, and when the answer is surprising, write down where it came from.

**Destroy a JUCE object before JUCE is shut down.** A ``var`` declared at proc
scope is destroyed by Nim at the END of the proc - after the
``shutdownJuce_GUI()`` that is usually the last statement. If that object's
destructor touches the MessageManager, it does so when there is none.
``testTextEditorConfiguration`` did exactly that: ``~TextEditor`` tears down its
Viewport, whose destructor calls ``removeMouseListener``, and JUCE asserted on
every run for as long as the test existed. Put the object in a ``block:`` so it
goes first. A ``let x = newCustom...()`` is a heap pointer that is explicitly
``cdelete``d and is not affected; it is the by-value ``var`` that is.

The same shape - an object outliving the thing it depends on - produced three
of the four bugs this audit found. The third was
``discard makeScopedJuceInitialiser_GUI()`` sitting in the middle of a list of
constructors: it keeps its own counter, so building and destroying one calls
``shutdownJuce_GUI``, and everything constructed after it ran with no
MessageManager.

**Find the ownership rule before the leak gate does.** ``registerTypeHandler``
puts the handler in the builder's own ``OwnedArray``.
``ComponentBuilder::updateChildComponents`` deletes the children the new tree
does not reclaim. ``PropertyPanel::addSection`` adopts its rows.
``TabBarButton::setExtraComponent`` holds a ``unique_ptr``. Each of those was a
crash or a leak first. The suite's leak gate catches them, but reading the JUCE
source first is cheaper than reading a stack trace.


What is deliberately not covered
================================

Two lists in ``tools/report_behavioural_coverage.py`` hold the methods a
headless behavioural test cannot reach. Every entry is there because a test was
written against it and the reason was MEASURED, not guessed.

``UNREACHABLE`` names whole classes: ``ComponentPeer`` and
``AccessibilityHandler`` need a native window handle, ``MouseInputSource`` and
``MouseEvent`` need a real input device, the ``JUCEApplication`` family needs
the process's single application instance, and ``AccessibilityTableInterface``
is abstract with no generated subclass, so nothing in Nim can produce one.

``UNREACHABLE_METHODS`` names single methods on classes whose other methods are
perfectly reachable: ``File.addToDock`` writes the user's Dock preferences and
restarts the Dock, ``Toolbar.showCustomisationDialog`` builds a modal
``DialogWindow``, and ``setCurrentDragImage`` dereferences
``dragImageComponents[0]``, which is null with no live drag.

Adding to either list is a real decision, not a way to make a number smaller.
Write the reason as something a reader could check, and cite the JUCE file and
line where it holds.


The other layer
===============

Behavioural coverage is the second of two. The first is
``tests/test_juce_compiles.nim``, which calls the bindings the behavioural
tests do not reach, so that each one is handed to the C++ compiler and the
linker at least once - an ``importcpp`` proc reaches the compiler only at a
call site.

Not every one of them. The generator emits a call where it can build one and
skips the rest with a reason apiece - a setter the field check covers, a free
function or a method with no receiver, an operator, a type it does not export -
printing both counts when it runs. Those skipped are the bindings still reaching
no compiler through this layer, so the report is the thing to read rather than
this sentence.

The harness BINDS each result whose type is a plain class name rather than
discarding it, because a discarded call constructs nothing: a by-value binding
of a reference to a class C++ will not copy compiled there for a long time
while failing at every real call site. If a change to the harness makes it
discard results again, that whole class of defect goes quiet.

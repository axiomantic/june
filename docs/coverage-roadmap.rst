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
   4416  called by a behavioural test
     95  uncalled, and unreachable without a window, an input device
         or the app instance
     17  uncalled, and reachable
=======  =========================================================

One unit is one bound method on one class, and overloads collapse into one. The
match is by NAME rather than by receiver, which makes the uncalled figure a
lower bound: it may credit a method because a same-named one elsewhere was
called, so the real gap is at least this big. The room for that is not small.
``report_behavioural_coverage.py`` prints the room in a table beside the one
above: the 4528 methods carry 3238 distinct names, 672 of those names are bound
on more than one class, and 1290 methods sit beyond one per shared name. That
is the ceiling on how many could be credited without their own receiver ever
being called, not a claim about how many are - but it is the reason to read the
figure as a floor rather than a measurement. The tool prints it rather than this
document stating it because an earlier hand-derived version of these four
numbers was measured over the receiver-taking proc LINES, a larger population
than the 4528 the gap itself lives in, so it bounded a quantity it was not
measured in. ``ToolbarButton::buttonStateChanged`` was exactly this: it
dropped off the uncalled list when ``DrawableButton``'s method of the same name
was covered, and a test for it had to be written afterwards. It errs the other way too, though
far less often: a call spelled in a form the match cannot see reads as uncalled
when a test does make it. README's "What Is Tested" section states the rest of
the counting rules.


The shape of the remainder
==========================

The 17 are spread across 14 classes:

=======  =================
classes   uncalled methods
=======  =================
      3                  2
     11                  1
=======  =================

No class has three or more, and none of what is left is waiting to be written.
Every method in the table is one a test MUST NOT call, for a reason recorded
below rather than for want of someone to write it: it would set the machine
clock, open a browser, beep, enter a loop that never returns, run every
UnitTest in the process, strand a singleton, double-free a callback, add a site
to the assertion ledger, or want a desktop window. The two the generator cannot
reach are there too.

So the number to watch is no longer this one. It moves again when the bindings
grow - a new module, or a generator change that emits methods nobody has
written a test for yet - and the guidance below is for that, not for the table
above it.

By module:

====================  =========  =========
module                 methods    classes
====================  =========  =========
juce_gui_basics               8          6
juce_core                     6          5
juce_events                   4          4
juce_graphics                 0          0
juce_data_structures          0          0
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

A handful are reachable and must still be left alone, which is why they are not
in those lists: nothing stops a test calling them, and calling one damages the
run. ``LookAndFeel::playAlertSound`` is ``NSBeep()`` on macOS and writes a BEL
into stdout on Linux, which is the same stdout the assertion and leak gates
read. ``Desktop::setKioskModeComponent`` carries a ``jassert`` that the outgoing
kiosk component has a peer, so a component that was never on the desktop passes
on the way in and fires it on the way out. ``ModalComponentManager::attachCallback``
wraps its callback in a ``unique_ptr`` and only releases it if the component is
already on the modal stack, so attaching to anything else deletes the callback
and a later ``cdelete`` is a double free. ``ChoicePropertyComponent::setIndex``
is ``jassertfalse`` on the base and no subclass is generated for it. Each of
those would add a site to the assertion ledger, or a leak, or a crash, in
exchange for a number.

Being blocked by an input device is worth checking rather than assuming, since
the name rarely settles it. ``ListBox::selectRowsBasedOnModifierKeys`` sounds
like it needs a live keyboard and takes a ``ModifierKeys`` value that
``makeModifierKeys`` builds, so its three branches are all assertable. Only the
methods that actually take a ``MouseEvent`` are out of reach, because
``MouseInputSource`` has no public constructor.


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


**A call is not a test, and reaching for one hides an unreachable method.**
Three tests called a setter whose value JUCE keeps private and then asserted
something unrelated beside it. The method counted as called while the assertion
could not fail if the method broke. Two of the three turned out to be genuinely
unreachable once the implementation was read: ``MouseInactivityDetector``'s
delay and tolerance are read only inside ``wakeUp (const MouseEvent&)``, and a
``MouseEvent`` needs a ``MouseInputSource``, whose only non-copy constructor is
private to ``ComponentPeer``, ``Desktop`` and two detail classes. When a value
cannot be read back, ask whether the method can be reached at all before
writing a test around it. If it cannot, it belongs in the list below with that
reason; if it can, the effect is observable somewhere and that is what to
assert. ``ProgressBar``'s two setters look identical to those three and are
not: they feed the paint path, so rendering the bar and comparing the pixels
holds them.

**A second overload of a name already used is never compiled.** An
``importcpp`` proc reaches the C++ compiler only where it is CALLED, and
``check_handwritten_covered.py`` matches by NAME, so adding an overload to a
name a test already calls satisfies the gate while the new overload is never
built. ``newLocalisedStrings`` was added with a ``String`` and a ``File``
spelling and only the first had a call site; the second had never been
compiled. Give every overload its own call site, and do not read a green gate
as evidence that one exists.

**``doAssert cond, msg`` evaluates ``msg`` only when ``cond`` fails.** A call
placed inside the message string is therefore not made on the passing path. A
counter asserted against a number that includes such a call is wrong in the
direction that still passes. Bind each result to a ``let`` first, then assert.

**Laying out text loads a typeface into a cache only ``shutdownJuce_GUI``
releases.** A test that builds fonts or lays out a string leaks without the
initialise and shutdown pair around it, and the run still exits zero, because
the leak detector prints and carries on exactly as ``jassert`` does. Fourteen
leaked objects hid behind a passing suite this way.

**A binding can be wrong in a direction every existing test agrees with.**
``toRawUTF8`` sized its buffer with ``juce::String::length()``, which counts
characters, and then copied that many BYTES, so ``$`` truncated every string
holding a multi-byte character. Each of the suite's several thousand ``$``
assertions was ASCII, where the two counts agree, so all of them passed. A test
whose inputs never separate two quantities cannot tell you they are different.

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

An entry also cannot outlive the thing it was written about. Membership is the
only test either list gets, so an entry naming a renamed or removed class goes
on matching nothing while its reason is checked against nothing. Two entries
were already in that state, one of them a class the generator now spells
``JUCEApplicationImpl``. The report compares both lists against the classes and
methods it parses out of the bindings and exits non-zero on an entry that names
neither. That exit status is about the script rather than about coverage: no
figure it prints fails a run.


The other layer
===============

Behavioural coverage is the second of two. The first is
``tests/test_juce_compiles.nim``, which calls the bindings the behavioural
tests do not reach, so that each one is handed to the C++ compiler and the
linker at least once - an ``importcpp`` proc reaches the compiler only at a
call site.

Not every one of them. The generator emits a call where it can build one and
skips the rest with a reason apiece - a setter the field check covers, a
no-argument constructor its own check covers, a declaration the pattern cannot
parse, a type it does not export, an argument it cannot spell or cannot copy -
printing both counts when it runs. Free functions, constructors and operators
are no longer among them: an importcpp string reaches the C++ compiler only
where something calls it, whichever shape it has. Those skipped are the bindings still reaching
no compiler through this layer, so the report is the thing to read rather than
this sentence.

The harness BINDS each result whose type is a plain class name rather than
discarding it, because a discarded call constructs nothing: a by-value binding
of a reference to a class C++ will not copy compiled there for a long time
while failing at every real call site. If a change to the harness makes it
discard results again, that whole class of defect goes quiet.

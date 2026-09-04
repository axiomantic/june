"""Fail on a JUCE assertion the suite does not deliberately provoke.

JUCE's `jassert` PRINTS and carries on: `jassertfalse` is
`JUCE_LOG_CURRENT_ASSERTION; if (juce_isRunningUnderDebugger()) BREAK`, so
outside a debugger it writes one line to stderr and the process continues at
exit code 0. The test step already greps that same output for "Leaked objects
detected" for the same reason - JUCE's leak detector prints rather than fails.
An assertion is the other half of that, and nothing was reading it.

What that cost: a MenuBarComponent outlived the model it was built over, so its
destructor called `model->removeListener` on freed memory. JUCE says exactly
that at juce_MenuBarModel.cpp:78 - "make sure you've not deleted this menu
model while it's still being used by something (e.g. by a MenuBarComponent)" -
and printed it on every run for as long as the test existed. CI stayed green
until a Linux run on Nim 2.2.2 happened to segfault on it.

Usage:

    python3 tools/check_juce_assertions.py <log> [<log> ...]

Each entry below is a place the suite provokes an assertion ON PURPOSE, with
what JUCE asserts there and which test does it. Adding one is a claim that the
assertion is the documented answer to something the test deliberately asks -
not a way to quieten a warning. A line here that no run produces is stale and
fails the check too, so an entry cannot outlive the test that needed it.
"""

import collections
import re
import sys

# file:line -> why the suite reaches it.
EXPECTED = {
    # --- deliberately asking for something JUCE refuses -------------------
    "juce_GIFLoader.cpp:460":
        "writing is not implemented for GIFs, and the ImageFileFormat test "
        "asserts that GIF's writeImageToStream reports failure",
    "juce_ComponentBuilder.cpp:145":
        "createComponent needs a registered type, and the ComponentBuilder "
        "test asserts that a builder with none builds nothing",
    "juce_ComponentBuilder.cpp:150":
        "the same call again for the unknown ValueTree type it was given",
    "juce_DocumentWindow.cpp:182":
        "the base closeButtonPressed is a jassertfalse telling a subclass to "
        "override it; the DocumentWindow test calls it to show it only logs",
    "juce_ResizableWindow.cpp:469":
        "setMinimised needs a desktop peer, and the window-state tests assert "
        "that a window off the desktop is not minimised by it",
    "juce_DragAndDropContainer.cpp:438":
        "startDragging outside a mouse callback finds no dragging source; the "
        "Toolbar test asserts that no drag starts",
    "juce_DragAndDropContainer.cpp:624":
        "the same, reached through the other overload",
    "juce_ThreadPool.cpp:112":
        "a pool asked for zero threads; the ThreadPool test pins that JUCE "
        "gives it one anyway",
    "juce_XmlElement.cpp:927":
        "getText on an element that is not a text element, which the "
        "XmlElement test asserts returns nothing",
    "juce_TreeView.cpp:2203":
        "getOpennessState needs every item to have a name; the TreeView test "
        "pins that an unnamed one cannot be saved",
    "juce_TableListBox.cpp:684":
        "refreshComponentForCell expects nothing to recycle, and the model "
        "test calls it the way the table would the first time",
    "juce_RelativeCoordinatePositioner.cpp:285":
        "markerListBeingDeleted expects the list to be among the watched "
        "ones; the positioner test drops one that is not",
    "juce_ConnectedChildProcess.cpp:162":
        "sendMessageToWorker with no connection; the ChildProcess test "
        "asserts both spellings report failure",
    "juce_ConnectedChildProcess.cpp:287":
        "sendMessageToCoordinator with no connection, the worker's half",

    # --- a component doing what a headless test can only do off-screen ----
    "juce_Component.cpp:3027":
        "grabKeyboardFocus wants the component showing or on the desktop, "
        "which nothing headless is; the focus tests assert it does not take",
    "juce_Component.cpp:793":
        "the default inputAttemptWhenModal is a jassertfalse, reached by the "
        "modal tests",
    "juce_EdgeTable.cpp:385":
        "remapTableForNumEdges shrinking rather than growing, which "
        "optimiseTable does on a table whose rows are already tight",
    "juce_GraphicsContext.cpp:141":
        "a drawing coordinate outside the range JUCE will render, which the "
        "clipping tests reach deliberately",
    "juce_FontOptions.h:126":
        "a FontOptions carrying both a typeface and a name; the Font tests "
        "build one to show the name is ignored",
    "juce_TextEditor.cpp:551":
        "line feeds inserted into a single-line editor, which the TextEditor "
        "tests do to pin what it keeps",
    "juce_MultiChoicePropertyComponent.cpp:260":
        "the controlled Value must hold an array; the property tests build "
        "one over a plain value to show what it does then",

    # --- process and platform ---------------------------------------------
    "juce_SharedCode_posix.h:1062":
        "thread affinity is not supported in this build, and the Thread test "
        "calls setAffinityMask to pin that it is inert rather than fatal",
    "juce_ActionBroadcaster.cpp:67":
        "an ActionBroadcaster built before initialiseJuce_GUI; the subclass "
        "tests build one outside the GUI block on purpose",
    "juce_ActionBroadcaster.cpp:73":
        "the same object destroyed after shutdownJuce_GUI",
    "juce_Timer.cpp:376":
        "startTimer with no running MessageManager, which every headless "
        "timer test does",
    "juce_Timer.cpp:99":
        "JUCE's shared TimerThread is a static torn down at PROCESS EXIT, "
        "after the MessageManager has gone. It fires in the two suites that "
        "start a Timer at all and in none of the others, and no test can "
        "change the order two statics are destroyed in",
    "juce_Component.cpp:2407":
        "a Component method called from a thread that is not the message "
        "thread; the MessageManagerLock tests do this to show the lock is "
        "what makes it safe",
}

PATTERN = re.compile(r"JUCE Assertion failure in ([A-Za-z_]+\.(?:cpp|h):\d+)")


def main(paths):
    if not paths:
        print(__doc__.strip().splitlines()[0], file=sys.stderr)
        print("usage: check_juce_assertions.py <log> [<log> ...]",
              file=sys.stderr)
        return 2

    seen = collections.Counter()
    where = collections.defaultdict(set)
    for path in paths:
        try:
            text = open(path, errors="replace").read()
        except OSError as error:
            print(f"could not read {path}: {error}", file=sys.stderr)
            return 2
        for site in PATTERN.findall(text):
            seen[site] += 1
            where[site].add(path)

    unexpected = sorted(site for site in seen if site not in EXPECTED)
    if unexpected:
        print("JUCE asserted somewhere the suite does not expect. Each of "
              "these is JUCE telling you something is wrong, and it does not "
              "fail the run on its own:", file=sys.stderr)
        for site in unexpected:
            files = ", ".join(sorted(where[site]))
            print(f"  {site}  ({seen[site]}x, in {files})", file=sys.stderr)
        print("\nRead the JUCE source at each. Fix what it names, or add the "
              "site here with the reason the suite provokes it on purpose.",
              file=sys.stderr)
        return 1

    stale = sorted(site for site in EXPECTED if site not in seen)
    if stale:
        print("These sites are listed as deliberately provoked and no run "
              "reaches them any more, so the reason they carry is no longer "
              "checked against anything:", file=sys.stderr)
        for site in stale:
            print(f"  {site}", file=sys.stderr)
        print("\nRemove them.", file=sys.stderr)
        return 1

    print(f"every one of the {sum(seen.values())} JUCE assertions across "
          f"{len(seen)} sites is one the suite provokes on purpose")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))


import june

# Enums had no binding at all before, so any parameter typed by one had no
# spelling and its proc was commented out.
#
# Each constant binds to its C++ enumerator by name rather than to a number, so
# asserting the values checks that the name resolves to the right enumerator.
proc testEnums() =
  doAssert NotificationType_dontSendNotification.cint == 0
  doAssert NotificationType_sendNotification.cint == 1
  doAssert NotificationType_sendNotificationSync.cint == 2
  doAssert NotificationType_sendNotificationAsync.cint == 3

  # Distinct types, so two enums cannot be confused for one another even though
  # both are integers underneath.
  doAssert not compiles(NotificationType_sendNotification == ImagePixelFormat_ARGB)

# MessageManager is deliberately not exercised here: getInstance creates a
# singleton that nothing deletes, and JUCE's leak detector fires at exit.

testEnums()

# Timer's timerCallback is pure virtual, so a Timer could not be instantiated
# without a subclass either.
proc testCustomTimer() =
  initialiseJuce_GUI()

  block:
    let timer = newCustomTimer()
    doAssert CustomTimer is Timer

    var ticks = 0
    timer[].onTimerCallback = bindClosure(proc() = ticks += 1)

    doAssert not timer[].isTimerRunning()
    timer[].startTimer(10.cint)
    doAssert timer[].isTimerRunning()
    doAssert timer[].getTimerInterval() == 10
    timer[].stopTimer()
    doAssert not timer[].isTimerRunning()
    cdelete timer

  shutdownJuce_GUI()

testCustomTimer()

proc testCallAsync() =
  # Posting work to the message thread. The callback is not run here: that needs
  # the dispatch loop, which a test has no business starting. What is checked is
  # that JUCE accepted the std::function the Nim closure was bound into.
  initialiseJuce_GUI()
  block:
    let callback: CppFunctionObjectN0 = bindClosure(proc() = discard)
    doAssert MessageManager.callAsync(callback)
  shutdownJuce_GUI()

testCallAsync()

# AsyncUpdater, ActionListener and ChangeListener each have a pure virtual, so
# none could be instantiated without a subclass, and no subclass was possible.
proc testAsyncUpdater() =
  initialiseJuce_GUI()

  block:
    let updater = newCustomAsyncUpdater()
    doAssert CustomAsyncUpdater is AsyncUpdater

    var updates = 0
    updater[].onHandleAsyncUpdate = bindClosure(proc() = updates += 1)

    doAssert not updater[].isUpdatePending()
    updater[].triggerAsyncUpdate()
    doAssert updater[].isUpdatePending()

    # Runs it now rather than waiting for the message loop, so the test can see
    # that JUCE called into Nim.
    updater[].handleUpdateNowIfNeeded()
    doAssert updates == 1
    doAssert not updater[].isUpdatePending()
    cdelete updater

  block:
    let listener = newCustomActionListener()
    doAssert CustomActionListener is ActionListener
    cdelete listener

    let changeListener = newCustomChangeListener()
    doAssert CustomChangeListener is ChangeListener
    cdelete changeListener

  shutdownJuce_GUI()

testAsyncUpdater()


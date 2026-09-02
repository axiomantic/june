
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

    # Nothing dispatches here, so the callback cannot have run: a Timer is
    # driven by the MessageManager's loop, which a test has no business
    # starting. `ticks` is asserted rather than left unread, because a counter
    # that is written and never checked reads as verification that is not
    # happening. What the assignment above does verify is that JUCE accepted
    # the std::function the Nim closure was bound into.
    doAssert ticks == 0,
             "the timer callback ran with no dispatch loop, " &
             "which means this test no longer says what it claims"

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


# std::exception is bound so that unhandledException can be overridden, which
# is how a JUCE application reports a crash. There is no way to raise a C++
# exception from Nim to call it with, so this checks the signature is callable
# rather than the handler running.
proc testUnhandledExceptionBinding() =
  doAssert compiles(
    proc(app: var JUCEApplicationBase, e: ptr CppException) =
      app.unhandledException(e, makeString("source.nim"), 42.cint))
  doAssert compiles(proc(e: CppException): constChar = e.what())

testUnhandledExceptionBinding()

# The synchronous message-thread call. JUCE takes a plain function pointer here
# rather than a std::function, so the binding is hand-written; this is what
# checks the pointer round-trips and the callback actually runs.
proc onMessageThread(userData: pointer): pointer {.cdecl.} =
  cast[ptr cint](userData)[] = 7.cint
  userData

proc testCallFunctionOnMessageThread() =
  initialiseJuce_GUI()

  var value = 0.cint
  let manager = MessageManager.getInstance()
  let returned = manager[].callFunctionOnMessageThread(onMessageThread, addr value)

  doAssert value == 7, "the callback did not run; value is " & $value
  doAssert returned == addr value, "the callback's return value did not come back"

  shutdownJuce_GUI()

testCallFunctionOnMessageThread()

# NetworkServiceDiscovery::Service ============================================
#
# A plain struct with no constructor of its own, so nothing could build one.

proc testServiceAggregate() =
    block:
        var service = makeNetworkServiceDiscoveryService()
        service.instanceID = makeString("june-test")
        doAssert $service.instanceID() == "june-test",
                 "the service holds " & $service.instanceID()

testServiceAggregate()

# The remaining generated subclasses ==========================================
#
# CustomJUCEApplicationBase is not here: building one trips JUCE's assertion
# that the process has a single application instance, the same reason
# newApplication is listed uncallable in check_handwritten_covered.py.

proc testRemainingEventsSubclasses() =
    block:
        var connection = newCustomInterprocessConnection(true, 0xf2b49e2c'u32)
        doAssert not connection.isNil(), "the connection was not built"
        connection[].setConnectionMadeHandler(proc() = discard)
        connection[].setConnectionLostHandler(proc() = discard)
        connection[].setMessageReceivedHandler(proc(message: ptr MemoryBlock) = discard)
        cdelete connection

testRemainingEventsSubclasses()

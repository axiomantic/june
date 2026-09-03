
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

# The macro spelling of a closure type =====================================
#
# june_function_utils exports CppFunctionObject, which builds the concrete
# CppFunctionObjectN<n> name from a proc signature. Everything else in the
# suite writes the concrete name, so until this test the macro was expanded by
# exactly one place in the lifting layer: a macro is only checked where it is
# used, exactly like an importcpp proc is only checked where it is called.

proc testClosureTypeMacros() =
    doAssert CppFunctionObject() is CppFunctionObjectN0
    doAssert CppFunctionObject(cint) is CppFunctionObjectN1[cint]

testClosureTypeMacros()

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

# The last of the events subclass handlers ====================================

proc testRemainingEventsHandlers() =
    initialiseJuce_GUI()

    block:
        var message = newCustomCallbackMessage()
        message[].setMessageCallbackHandler(proc() = discard)
        cdelete message

        var server = newCustomInterprocessConnectionServer()
        server[].setCreateConnectionObjectHandler(proc(): ptr InterprocessConnection = nil)
        cdelete server

        var listener = newCustomMessageListener()
        listener[].setHandleMessageHandler(proc(message: ptr Message) = discard)
        cdelete listener

        var multi = newCustomMultiTimer()
        multi[].setTimerCallbackHandler(proc(timerID: cint) = discard)
        cdelete multi

    shutdownJuce_GUI()

testRemainingEventsHandlers()

# The nested abstract classes =================================================
#
# The subclass generator keyed an abstract class on its own spelling, which
# never matched a declared Nim name for a nested one, so every Listener,
# LookAndFeelMethods and other nested interface was skipped with no withheld
# entry. Building each compiles the C++ class, and setting each handler is what
# type-checks and generates the setter.

proc testNestedSubclassesEvents() =
    initialiseJuce_GUI()
    block:
        var customMessageManagerMessageBase = newCustomMessageManagerMessageBase()
        doAssert not customMessageManagerMessageBase.isNil(), "newCustomMessageManagerMessageBase built nothing"
        customMessageManagerMessageBase[].setMessageCallbackHandler(proc() = discard)
        cdelete customMessageManagerMessageBase
    shutdownJuce_GUI()

testNestedSubclassesEvents()

# Every no-argument constructor ===============================================
#
# An importcpp string reaches the C++ compiler only at a call site, so a
# constructor nothing calls is never compiled. These had no caller.

proc testEveryNoArgConstructorEvents() =
    initialiseJuce_GUI()
    block:
        discard makeMessage()
        discard makeScopedJuceInitialiser_GUI()
        discard makeActionBroadcaster()
        discard makeChangeBroadcaster()
        discard makeChildProcessWorker()
        discard makeChildProcessCoordinator()
        discard makeScopedLowPowerModeDisabler()
    shutdownJuce_GUI()

testEveryNoArgConstructorEvents()

# LockingAsyncUpdater =========================================================
#
# The same shape as AsyncUpdater, but the callback is a std::function rather
# than a virtual, so it takes a Nim closure directly. handleUpdateNowIfNeeded
# runs a pending update on this thread, which is what makes it checkable with
# no message loop.

proc testLockingAsyncUpdater() =
    initialiseJuce_GUI()

    block:
        var updates = 0
        var updater = makeLockingAsyncUpdater(
            bindClosure(proc() = updates += 1))

        # Nothing pending, so nothing runs.
        updater.handleUpdateNowIfNeeded()
        doAssert updates == 0, "an update ran before one was asked for"

        updater.triggerAsyncUpdate()
        updater.handleUpdateNowIfNeeded()
        doAssert updates == 1, "the update ran " & $updates & " times"

        # A cancelled update does not run, which is the whole point of
        # cancelPendingUpdate.
        updater.triggerAsyncUpdate()
        updater.cancelPendingUpdate()
        updater.handleUpdateNowIfNeeded()
        doAssert updates == 1,
                 "a cancelled update ran anyway, leaving " & $updates

    shutdownJuce_GUI()

testLockingAsyncUpdater()

# MessageManagerLock ==========================================================
#
# Taking the message thread's lock. On the message thread itself - which is
# where a test runs - it is granted at once, and lockWasGained says so.

proc testMessageManagerLock() =
    initialiseJuce_GUI()

    block:
        let lock = makeMessageManagerLock(cast[ptr june.Thread](nil))
        doAssert lock.lockWasGained(),
                 "the message manager lock was refused on the message thread"

        # juce::MessageManager::Lock is a different class from
        # juce::MessageManagerLock, and both used to flatten to the same Nim
        # name: the type was declared as the nested one while every method
        # bound onto it came from the top-level one, so this constructor could
        # not be called at all.
        let inner = makeMessageManagerInnerLock()
        doAssert inner.tryEnter(),
                 "a fresh MessageManager::Lock refused tryEnter"
        inner.exit()

    shutdownJuce_GUI()

testMessageManagerLock()

# Every bound constant ========================================================
#
# A `let` with an importcpp is not checked against C++ unless something reads
# it: a constant naming juce::NoSuchClass::nope compiles clean while nothing
# touches it. Reading each is what compiles the spelling.

proc testEveryConstantEvents() =
    block:
        discard NotificationType_dontSendNotification
        discard NotificationType_sendNotification
        discard NotificationType_sendNotificationSync
        discard NotificationType_sendNotificationAsync
        discard InterprocessConnectionNotify_no
        discard InterprocessConnectionNotify_yes

testEveryConstantEvents()

# TimedCallback ===============================================================
#
# A Timer whose callback is a std::function, so it takes a Nim closure without
# a subclass. It is not started here: nothing would run it without a message
# loop, and a started timer would outlive the test.

proc testTimedCallback() =
    initialiseJuce_GUI()

    block:
        var fired = 0
        var callback = makeTimedCallback(bindClosure(proc() = fired += 1))
        doAssert not callback.isTimerRunning(), "a fresh TimedCallback is running"
        doAssert fired == 0, "the callback ran before the timer started"

    shutdownJuce_GUI()

testTimedCallback()

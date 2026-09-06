
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

        # These five reach TimedCallback through a using-declaration, not
        # through inheritance: it inherits Timer PRIVATELY, so it is not a
        # Timer and only the members it re-exports are callable. The interval
        # is read back rather than just set, so the call has to have landed.
        callback.startTimer(40.cint)
        doAssert callback.isTimerRunning(), "the timer did not start"
        doAssert callback.getTimerInterval() == 40,
                 "the interval is " & $callback.getTimerInterval() & ", not 40"
        callback.startTimerHz(25.cint)   # 25 per second is one every 40ms
        doAssert callback.getTimerInterval() == 40,
                 "25Hz gave an interval of " & $callback.getTimerInterval() &
                 "ms rather than 40ms"
        callback.stopTimer()
        doAssert not callback.isTimerRunning(), "the timer did not stop"
        doAssert fired == 0, "the callback ran with no message loop"

        # The private base itself is not a Nim parent, so nothing else Timer
        # declares comes with it.
        doAssert not compiles(callback.timerCallback()),
                 "a member the class does not re-export was offered anyway"

    shutdownJuce_GUI()

testTimedCallback()

# Private bases are not Nim parents ===========================================
#
# A privately inherited base is not a subtype outside the class, so binding it
# as the Nim parent offered every method it declares while the C++ compiler
# refused each one: triggerAsyncUpdate on an ApplicationCommandManager is "a
# private member of juce::AsyncUpdater". Nothing called them, so nothing said
# so. Fourteen classes inherited that way.

proc testPrivateBasesAreNotParents() =
    initialiseJuce_GUI()

    block:
        var manager = makeApplicationCommandManager()
        doAssert not compiles(manager.triggerAsyncUpdate()),
                 "AsyncUpdater's members are offered on ApplicationCommandManager"
        doAssert not compiles(manager.isUpdatePending()),
                 "isUpdatePending is offered on ApplicationCommandManager"

        # What the class declares itself is unaffected.
        doAssert manager.getNumCommands() == 0,
                 "a fresh manager holds " & $manager.getNumCommands() & " commands"

    block:
        # Abstract, so it comes from the generated subclass. It inherits Thread
        # privately, and the same rule applies through the subclass.
        let server = newCustomInterprocessConnectionServer()
        doAssert not compiles(server[].startThread()),
                 "Thread's members are offered on InterprocessConnectionServer"
        doAssert server[].getBoundPort() == -1,
                 "an unbound server reports port " & $server[].getBoundPort() &
                 " rather than -1"
        cdelete server

    shutdownJuce_GUI()

testPrivateBasesAreNotParents()

# Methods restated from a secondary base ======================================
#
# Message and CallbackMessage reach ReferenceCountedObject through a public
# base that is not their Nim parent, so those five are not inherited: the
# generator restates them, and a restatement nobody calls never reaches the C++
# compiler.

proc testReferenceCountingOnMessages() =
    initialiseJuce_GUI()

    block:
        # Heap allocated, because the reference count owns it: the last
        # decReferenceCount deletes the object.
        let message = newCustomCallbackMessage()
        doAssert message[].getReferenceCount() == 0,
                 "a fresh message starts at " & $message[].getReferenceCount()

        message[].incReferenceCount()
        doAssert message[].getReferenceCount() == 1,
                 "after one retain the count is " & $message[].getReferenceCount()
        message[].incReferenceCount()
        doAssert message[].getReferenceCount() == 2,
                 "after two retains the count is " & $message[].getReferenceCount()

        doAssert not message[].decReferenceCountWithoutDeleting(),
                 "the count reached zero after one release of two"
        doAssert message[].getReferenceCount() == 1,
                 "after one release the count is " & $message[].getReferenceCount()

        # decReferenceCount deletes the object when the count reaches zero, so
        # this is the end of its life and it must not be cdeleted afterwards.
        message[].decReferenceCount()

    block:
        var ran = 0
        let message = newCustomCallbackMessage()
        message[].setMessageCallbackHandler(proc() = ran += 1)

        # post() hands the message to the queue, which owns it from here: it is
        # deleted once delivered, so nothing may touch it afterwards and it
        # must not be cdeleted. Delivery needs a running message loop, and
        # JUCE only exposes one to run under JUCE_MODAL_LOOPS_PERMITTED, which
        # this build does not set - so what is asserted is that the queue took
        # it, not that it arrived.
        doAssert message[].post(), "the message manager refused the message"
        doAssert ran == 0, "the message ran with no loop to deliver it"

    block:
        # The action listener's handler setter, which had none until now: the
        # class could be built and attached but never told what to do.
        let listener = newCustomActionListener()
        var seen = 0
        listener[].setActionListenerCallbackHandler(
            proc(message: ptr String) = seen += 1)

        var broadcaster = makeActionBroadcaster()
        broadcaster.addActionListener(cast[ptr ActionListener](listener))
        broadcaster.sendActionMessage(makeString("hello"))
        doAssert seen == 0, "the action arrived with no loop to deliver it"
        broadcaster.removeActionListener(cast[ptr ActionListener](listener))
        cdelete listener

    shutdownJuce_GUI()

testReferenceCountingOnMessages()

# The child-process exit listener ==============================================
#
# The listener is a std::function<void(ChildProcess&)>, and the pointer inside
# that template argument was dropped, so the binding named a function taking a
# ChildProcess by value - a class that cannot be copied. Nothing called it.

proc testChildProcessExitedListener() =
    initialiseJuce_GUI()

    block:
        var manager = ChildProcessManager.getInstance()
        var exited = 0
        var guard = manager[].addChildProcessExitedListener(
            bindClosure(proc(process: ptr ChildProcess) = exited += 1))

        # No child process was started, so nothing has exited. The listener is
        # detached by releasing the guard, which is the whole of its contract.
        doAssert exited == 0, "the listener ran " & $exited & " times"
        guard.reset()

        ChildProcessManager.deleteInstance()

    shutdownJuce_GUI()

testChildProcessExitedListener()


# Every public field round-trips ===============================================
#
# A field getter and setter are importcpp procs like any other: they reach the
# C++ compiler only where something calls them, so a setter nothing assigns is
# never compiled. Each is set to a distinctive value and read back; where the
# field's type compares, the read is asserted against what went in.

proc testFieldRoundTrips() =
    block:
        var value = makeNetworkServiceDiscoveryService()
        value.address = makeIPAddress()
        discard value.address()
        value.description = makeString("a value")
        discard value.description()
        value.lastSeen = makeTime()
        discard value.lastSeen()
        value.port = 7.cint
        doAssert value.port() == 7.cint,
                 "NetworkServiceDiscoveryService.port came back as " & $value.port()

testFieldRoundTrips()

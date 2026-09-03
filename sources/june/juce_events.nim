import june_common

const juce_events = "../../JUCE/modules/juce_events/juce_events.h"

type
  MessageManager* {.header: juce_events, importcpp: "juce::MessageManager", inheritable, pure.} = object
  MessageManagerMessageBase* {.header: juce_events, importcpp: "juce::MessageManager::MessageBase", inheritable, pure.} = object
  MessageManagerLock* {.header: juce_events, importcpp: "juce::MessageManager::Lock", inheritable, pure.} = object
  Message* {.header: juce_events, importcpp: "juce::Message", inheritable, pure.} = object
  MessageListener* {.header: juce_events, importcpp: "juce::MessageListener", inheritable, pure.} = object
  CallbackMessage* {.header: juce_events, importcpp: "juce::CallbackMessage", inheritable, pure.} = object
  DeletedAtShutdown* {.header: juce_events, importcpp: "juce::DeletedAtShutdown", inheritable, pure.} = object
  JUCEApplicationBase* {.header: juce_events, importcpp: "juce::JUCEApplicationBase", inheritable, pure.} = object
  ScopedJuceInitialiser_GUI* {.header: juce_events, importcpp: "juce::ScopedJuceInitialiser_GUI", inheritable, pure.} = object
  MountedVolumeListChangeDetector* {.header: juce_events, importcpp: "juce::MountedVolumeListChangeDetector", inheritable, pure.} = object
  ActionBroadcaster* {.header: juce_events, importcpp: "juce::ActionBroadcaster", inheritable, pure.} = object
  ActionListener* {.header: juce_events, importcpp: "juce::ActionListener", inheritable, pure.} = object
  AsyncUpdater* {.header: juce_events, importcpp: "juce::AsyncUpdater", inheritable, pure.} = object
  LockingAsyncUpdater* {.header: juce_events, importcpp: "juce::LockingAsyncUpdater", inheritable, pure.} = object
  ChangeListener* {.header: juce_events, importcpp: "juce::ChangeListener", inheritable, pure.} = object
  ChangeBroadcaster* {.header: juce_events, importcpp: "juce::ChangeBroadcaster", inheritable, pure.} = object
  Timer* {.header: juce_events, importcpp: "juce::Timer", inheritable, pure.} = object
  TimedCallback* {.header: juce_events, importcpp: "juce::TimedCallback", inheritable, pure.} = object of Timer
  MultiTimer* {.header: juce_events, importcpp: "juce::MultiTimer", inheritable, pure.} = object
  ChildProcessManager* {.header: juce_events, importcpp: "juce::ChildProcessManager", inheritable, pure.} = object of DeletedAtShutdown
  InterprocessConnection* {.header: juce_events, importcpp: "juce::InterprocessConnection", inheritable, pure.} = object
  InterprocessConnectionServer* {.header: juce_events, importcpp: "juce::InterprocessConnectionServer", inheritable, pure.} = object of Thread
  ChildProcessWorker* {.header: juce_events, importcpp: "juce::ChildProcessWorker", inheritable, pure.} = object
  ChildProcessCoordinator* {.header: juce_events, importcpp: "juce::ChildProcessCoordinator", inheritable, pure.} = object
  NetworkServiceDiscovery* {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery", inheritable, pure.} = object
  NetworkServiceDiscoveryAdvertiser* {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery::Advertiser", inheritable, pure.} = object
  NetworkServiceDiscoveryService* {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery::Service", inheritable, pure.} = object
  NetworkServiceDiscoveryAvailableServiceList* {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery::AvailableServiceList", inheritable, pure.} = object
  ScopedLowPowerModeDisabler* {.header: juce_events, importcpp: "juce::ScopedLowPowerModeDisabler", inheritable, pure.} = object
  NotificationType* {.header: juce_events, importcpp: "juce::NotificationType".} = distinct cint
  InterprocessConnectionNotify* {.header: juce_events, importcpp: "juce::InterprocessConnection::Notify".} = distinct cint

# Comparison for the enums above, taken from their base type,
# and $ so a value can appear in a message. $ prints the number
# rather than the name: the binding holds the C++ enumerator and
# there is no table of names on this side to look one up in.
proc `==`*(a: NotificationType, b: NotificationType): bool {.borrow.}
proc `$`*(value: NotificationType): string {.borrow.}
proc `==`*(a: InterprocessConnectionNotify, b: InterprocessConnectionNotify): bool {.borrow.}
proc `$`*(value: InterprocessConnectionNotify): string {.borrow.}

let NotificationType_dontSendNotification* {.header: juce_events, importcpp: "juce::dontSendNotification".}: NotificationType
let NotificationType_sendNotification* {.header: juce_events, importcpp: "juce::sendNotification".}: NotificationType
let NotificationType_sendNotificationSync* {.header: juce_events, importcpp: "juce::sendNotificationSync".}: NotificationType
let NotificationType_sendNotificationAsync* {.header: juce_events, importcpp: "juce::sendNotificationAsync".}: NotificationType

let InterprocessConnectionNotify_no* {.header: juce_events, importcpp: "juce::InterprocessConnection::Notify::no".}: InterprocessConnectionNotify
let InterprocessConnectionNotify_yes* {.header: juce_events, importcpp: "juce::InterprocessConnection::Notify::yes".}: InterprocessConnectionNotify

proc getInstance*(this: typedesc[MessageManager]): ptr MessageManager {.header: juce_events, importcpp: "juce::MessageManager::getInstance()".}
proc getInstanceWithoutCreating*(this: typedesc[MessageManager]): ptr MessageManager {.header: juce_events, importcpp: "juce::MessageManager::getInstanceWithoutCreating()".}
proc deleteInstance*(this: typedesc[MessageManager]) {.header: juce_events, importcpp: "juce::MessageManager::deleteInstance()".}
proc runDispatchLoop*(this: var MessageManager) {.header: juce_events, importcpp: "#.runDispatchLoop()".}
proc stopDispatchLoop*(this: var MessageManager) {.header: juce_events, importcpp: "#.stopDispatchLoop()".}
proc hasStopMessageBeenSent*(this: MessageManager): bool {.header: juce_events, importcpp: "#.hasStopMessageBeenSent()".}
# proc callFunctionOnMessageThread*(this: var MessageManager, callback: ptr MessageCallbackFunction, userData: pointer): pointer {.header: juce_events, importcpp: "#.callFunctionOnMessageThread(@)".}  # excluded deliberately: see skip_class_method
proc isThisTheMessageThread*(this: MessageManager): bool {.header: juce_events, importcpp: "#.isThisTheMessageThread()".}
proc setCurrentThreadAsMessageThread*(this: var MessageManager) {.header: juce_events, importcpp: "#.setCurrentThreadAsMessageThread()".}
proc getCurrentMessageThread*(this: MessageManager): pointer {.header: juce_events, importcpp: "#.getCurrentMessageThread()".}
proc currentThreadHasLockedMessageManager*(this: MessageManager): bool {.header: juce_events, importcpp: "#.currentThreadHasLockedMessageManager()".}
proc existsAndIsLockedByCurrentThread*(this: typedesc[MessageManager]): bool {.header: juce_events, importcpp: "juce::MessageManager::existsAndIsLockedByCurrentThread()".}
proc existsAndIsCurrentThread*(this: typedesc[MessageManager]): bool {.header: juce_events, importcpp: "juce::MessageManager::existsAndIsCurrentThread()".}
proc broadcastMessage*(this: typedesc[MessageManager], messageText: String) {.header: juce_events, importcpp: "juce::MessageManager::broadcastMessage(@)".}
proc registerBroadcastListener*(this: var MessageManager, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.registerBroadcastListener(@)".}
proc deregisterBroadcastListener*(this: var MessageManager, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.deregisterBroadcastListener(@)".}
proc deliverBroadcastMessage*(this: var MessageManager, arg1: String) {.header: juce_events, importcpp: "#.deliverBroadcastMessage(@)".}
proc `==`*(this: MessageManager, other: MessageManager): bool {.error: "juce::MessageManager defines no operator==; compare a property instead".}

# proc makeMessageManagerMessageBase*(): MessageManagerMessageBase {.header: juce_events, importcpp: "juce::MessageManager::MessageBase(@)".}  # MessageManagerMessageBase is abstract; build a CustomMessageManagerMessageBase instead
proc messageCallback*(this: var MessageManagerMessageBase) {.header: juce_events, importcpp: "#.messageCallback()".}
proc post*(this: var MessageManagerMessageBase): bool {.header: juce_events, importcpp: "#.post()".}
proc `MessageManagerMessageBase=`*(this: var MessageManagerMessageBase, arg1: MessageManagerMessageBase): var MessageManagerMessageBase {.header: juce_events, importcpp: "#.operator=(@)".}
proc `==`*(this: MessageManagerMessageBase, other: MessageManagerMessageBase): bool {.error: "juce::MessageManager::MessageBase defines no operator==; compare a property instead".}

proc makeMessageManagerLock*(threadToCheckForExitSignal: ptr Thread): MessageManagerLock {.header: juce_events, importcpp: "juce::MessageManagerLock(@)".}
proc makeMessageManagerLock*(jobToCheckForExitSignal: ptr ThreadPoolJob): MessageManagerLock {.header: juce_events, importcpp: "juce::MessageManagerLock(@)".}
proc lockWasGained*(this: MessageManagerLock): bool {.header: juce_events, importcpp: "#.lockWasGained()".}
proc `==`*(this: MessageManagerLock, other: MessageManagerLock): bool {.error: "juce::MessageManagerLock defines no operator==; compare a property instead".}

proc makeMessage*(): Message {.header: juce_events, importcpp: "juce::Message(@)".}
proc `==`*(this: Message, other: Message): bool {.error: "juce::Message defines no operator==; compare a property instead".}

# proc makeMessageListener*(): MessageListener {.header: juce_events, importcpp: "juce::MessageListener(@)".}  # MessageListener is abstract; build a CustomMessageListener instead
proc handleMessage*(this: var MessageListener, message: Message) {.header: juce_events, importcpp: "#.handleMessage(@)".}
proc postMessage*(this: MessageListener, message: ptr Message) {.header: juce_events, importcpp: "#.postMessage(@)".}
proc `==`*(this: MessageListener, other: MessageListener): bool {.error: "juce::MessageListener defines no operator==; compare a property instead".}

# proc makeCallbackMessage*(): CallbackMessage {.header: juce_events, importcpp: "juce::CallbackMessage(@)".}  # CallbackMessage is abstract; build a CustomCallbackMessage instead
proc messageCallback*(this: var CallbackMessage) {.header: juce_events, importcpp: "#.messageCallback()".}
proc `==`*(this: CallbackMessage, other: CallbackMessage): bool {.error: "juce::CallbackMessage defines no operator==; compare a property instead".}

proc deleteAll*(this: typedesc[DeletedAtShutdown]) {.header: juce_events, importcpp: "juce::DeletedAtShutdown::deleteAll()".}
proc `==`*(this: DeletedAtShutdown, other: DeletedAtShutdown): bool {.error: "juce::DeletedAtShutdown defines no operator==; compare a property instead".}

# proc createInstance*(this: typedesc[JUCEApplicationBase]): JUCEApplicationBase ()() {.header: juce_events, importcpp: "(juce::JUCEApplicationBase::createInstance)".}  # a type that cannot be spelled in Nim
proc getInstance*(this: typedesc[JUCEApplicationBase]): ptr JUCEApplicationBase {.header: juce_events, importcpp: "juce::JUCEApplicationBase::getInstance()".}
proc getApplicationName*(this: var JUCEApplicationBase): String {.header: juce_events, importcpp: "#.getApplicationName()".}
proc getApplicationVersion*(this: var JUCEApplicationBase): String {.header: juce_events, importcpp: "#.getApplicationVersion()".}
proc moreThanOneInstanceAllowed*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.moreThanOneInstanceAllowed()".}
proc initialise*(this: var JUCEApplicationBase, commandLineParameters: String) {.header: juce_events, importcpp: "#.initialise(@)".}
proc shutdown*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.shutdown()".}
proc anotherInstanceStarted*(this: var JUCEApplicationBase, commandLine: String) {.header: juce_events, importcpp: "#.anotherInstanceStarted(@)".}
proc systemRequestedQuit*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.systemRequestedQuit()".}
proc suspended*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.suspended()".}
proc resumed*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.resumed()".}
proc unhandledException*(this: var JUCEApplicationBase, arg1: ptr CppException, sourceFilename: String, lineNumber: cint) {.header: juce_events, importcpp: "#.unhandledException(@)".}
proc memoryWarningReceived*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.memoryWarningReceived()".}
proc backButtonPressed*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.backButtonPressed()".}
proc quit*(this: typedesc[JUCEApplicationBase]) {.header: juce_events, importcpp: "juce::JUCEApplicationBase::quit()".}
proc getCommandLineParameterArray*(this: typedesc[JUCEApplicationBase]): StringArray {.header: juce_events, importcpp: "juce::JUCEApplicationBase::getCommandLineParameterArray()".}
proc getCommandLineParameters*(this: typedesc[JUCEApplicationBase]): String {.header: juce_events, importcpp: "juce::JUCEApplicationBase::getCommandLineParameters()".}
proc setApplicationReturnValue*(this: var JUCEApplicationBase, newReturnValue: cint) {.header: juce_events, importcpp: "#.setApplicationReturnValue(@)".}
proc getApplicationReturnValue*(this: JUCEApplicationBase): cint {.header: juce_events, importcpp: "#.getApplicationReturnValue()".}
proc isStandaloneApp*(this: typedesc[JUCEApplicationBase]): bool {.header: juce_events, importcpp: "juce::JUCEApplicationBase::isStandaloneApp()".}
proc isInitialising*(this: JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.isInitialising()".}
proc main*(this: typedesc[JUCEApplicationBase]): cint {.header: juce_events, importcpp: "juce::JUCEApplicationBase::main()".}
# proc main*(this: typedesc[JUCEApplicationBase], argc: cint, argv: constChar[]): cint {.header: juce_events, importcpp: "juce::JUCEApplicationBase::main(@)".}  # a C array parameter; every one of these has an overload taking a String or a value instead
proc appWillTerminateByForce*(this: typedesc[JUCEApplicationBase]) {.header: juce_events, importcpp: "juce::JUCEApplicationBase::appWillTerminateByForce()".}
proc initialiseApp*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.initialiseApp()".}
proc shutdownApp*(this: var JUCEApplicationBase): cint {.header: juce_events, importcpp: "#.shutdownApp()".}
proc sendUnhandledException*(this: typedesc[JUCEApplicationBase], arg1: ptr CppException, sourceFile: constChar, lineNumber: cint) {.header: juce_events, importcpp: "juce::JUCEApplicationBase::sendUnhandledException(@)".}
proc sendCommandLineToPreexistingInstance*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.sendCommandLineToPreexistingInstance()".}
proc `==`*(this: JUCEApplicationBase, other: JUCEApplicationBase): bool {.error: "juce::JUCEApplicationBase defines no operator==; compare a property instead".}

proc makeScopedJuceInitialiser_GUI*(): ScopedJuceInitialiser_GUI {.header: juce_events, importcpp: "juce::ScopedJuceInitialiser_GUI(@)".}
proc `ScopedJuceInitialiser_GUI=`*(this: var ScopedJuceInitialiser_GUI, arg1: ScopedJuceInitialiser_GUI): var ScopedJuceInitialiser_GUI {.header: juce_events, importcpp: "#.operator=(@)".}
proc `==`*(this: ScopedJuceInitialiser_GUI, other: ScopedJuceInitialiser_GUI): bool {.error: "juce::ScopedJuceInitialiser_GUI defines no operator==; compare a property instead".}

# proc makeMountedVolumeListChangeDetector*(): MountedVolumeListChangeDetector {.header: juce_events, importcpp: "juce::MountedVolumeListChangeDetector(@)".}  # MountedVolumeListChangeDetector is abstract; build a CustomMountedVolumeListChangeDetector instead
proc mountedVolumeListChanged*(this: var MountedVolumeListChangeDetector) {.header: juce_events, importcpp: "#.mountedVolumeListChanged()".}
proc `==`*(this: MountedVolumeListChangeDetector, other: MountedVolumeListChangeDetector): bool {.error: "juce::MountedVolumeListChangeDetector defines no operator==; compare a property instead".}

proc makeActionBroadcaster*(): ActionBroadcaster {.header: juce_events, importcpp: "juce::ActionBroadcaster(@)".}
proc addActionListener*(this: var ActionBroadcaster, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.addActionListener(@)".}
proc removeActionListener*(this: var ActionBroadcaster, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.removeActionListener(@)".}
proc removeAllActionListeners*(this: var ActionBroadcaster) {.header: juce_events, importcpp: "#.removeAllActionListeners()".}
proc sendActionMessage*(this: ActionBroadcaster, message: String) {.header: juce_events, importcpp: "#.sendActionMessage(@)".}
proc `==`*(this: ActionBroadcaster, other: ActionBroadcaster): bool {.error: "juce::ActionBroadcaster defines no operator==; compare a property instead".}

proc actionListenerCallback*(this: var ActionListener, message: String) {.header: juce_events, importcpp: "#.actionListenerCallback(@)".}
proc `==`*(this: ActionListener, other: ActionListener): bool {.error: "juce::ActionListener defines no operator==; compare a property instead".}

# proc makeAsyncUpdater*(): AsyncUpdater {.header: juce_events, importcpp: "juce::AsyncUpdater(@)".}  # AsyncUpdater is abstract; build a CustomAsyncUpdater instead
proc triggerAsyncUpdate*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.triggerAsyncUpdate()".}
proc cancelPendingUpdate*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.cancelPendingUpdate()".}
proc handleUpdateNowIfNeeded*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.handleUpdateNowIfNeeded()".}
proc isUpdatePending*(this: AsyncUpdater): bool {.header: juce_events, importcpp: "#.isUpdatePending()".}
proc handleAsyncUpdate*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.handleAsyncUpdate()".}
proc `==`*(this: AsyncUpdater, other: AsyncUpdater): bool {.error: "juce::AsyncUpdater defines no operator==; compare a property instead".}

proc makeLockingAsyncUpdater*(callbackToUse: CppFunctionObjectN0): LockingAsyncUpdater {.header: juce_events, importcpp: "juce::LockingAsyncUpdater(@)".}
proc `LockingAsyncUpdater=`*(this: var LockingAsyncUpdater, other: LockingAsyncUpdater): var LockingAsyncUpdater {.header: juce_events, importcpp: "#.operator=(@)".}
proc triggerAsyncUpdate*(this: var LockingAsyncUpdater) {.header: juce_events, importcpp: "#.triggerAsyncUpdate()".}
proc cancelPendingUpdate*(this: var LockingAsyncUpdater) {.header: juce_events, importcpp: "#.cancelPendingUpdate()".}
proc handleUpdateNowIfNeeded*(this: var LockingAsyncUpdater) {.header: juce_events, importcpp: "#.handleUpdateNowIfNeeded()".}
proc isUpdatePending*(this: LockingAsyncUpdater): bool {.header: juce_events, importcpp: "#.isUpdatePending()".}
proc `==`*(this: LockingAsyncUpdater, other: LockingAsyncUpdater): bool {.error: "juce::LockingAsyncUpdater defines no operator==; compare a property instead".}

proc changeListenerCallback*(this: var ChangeListener, source: ptr ChangeBroadcaster) {.header: juce_events, importcpp: "#.changeListenerCallback(@)".}
proc `==`*(this: ChangeListener, other: ChangeListener): bool {.error: "juce::ChangeListener defines no operator==; compare a property instead".}

proc makeChangeBroadcaster*(): ChangeBroadcaster {.header: juce_events, importcpp: "juce::ChangeBroadcaster(@)".}
proc addChangeListener*(this: var ChangeBroadcaster, listener: ptr ChangeListener) {.header: juce_events, importcpp: "#.addChangeListener(@)".}
proc removeChangeListener*(this: var ChangeBroadcaster, listener: ptr ChangeListener) {.header: juce_events, importcpp: "#.removeChangeListener(@)".}
proc removeAllChangeListeners*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.removeAllChangeListeners()".}
proc sendChangeMessage*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.sendChangeMessage()".}
proc sendSynchronousChangeMessage*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.sendSynchronousChangeMessage()".}
proc dispatchPendingMessages*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.dispatchPendingMessages()".}
proc `==`*(this: ChangeBroadcaster, other: ChangeBroadcaster): bool {.error: "juce::ChangeBroadcaster defines no operator==; compare a property instead".}

proc timerCallback*(this: var Timer) {.header: juce_events, importcpp: "#.timerCallback()".}
proc startTimer*(this: var Timer, intervalInMilliseconds: cint) {.header: juce_events, importcpp: "#.startTimer(@)".}
proc startTimerHz*(this: var Timer, timerFrequencyHz: cint) {.header: juce_events, importcpp: "#.startTimerHz(@)".}
proc stopTimer*(this: var Timer) {.header: juce_events, importcpp: "#.stopTimer()".}
proc isTimerRunning*(this: Timer): bool {.header: juce_events, importcpp: "#.isTimerRunning()".}
proc getTimerInterval*(this: Timer): cint {.header: juce_events, importcpp: "#.getTimerInterval()".}
proc callAfterDelay*(this: typedesc[Timer], milliseconds: cint, functionToCall: CppFunctionObjectN0) {.header: juce_events, importcpp: "juce::Timer::callAfterDelay(@)".}
proc callPendingTimersSynchronously*(this: typedesc[Timer]) {.header: juce_events, importcpp: "juce::Timer::callPendingTimersSynchronously()".}
proc `==`*(this: Timer, other: Timer): bool {.error: "juce::Timer defines no operator==; compare a property instead".}

proc makeTimedCallback*(callbackIn: CppFunctionObjectN0): TimedCallback {.header: juce_events, importcpp: "juce::TimedCallback(@)".}
proc `==`*(this: TimedCallback, other: TimedCallback): bool {.error: "juce::TimedCallback defines no operator==; compare a property instead".}

proc timerCallback*(this: var MultiTimer, timerID: cint) {.header: juce_events, importcpp: "#.timerCallback(@)".}
proc startTimer*(this: var MultiTimer, timerID: cint, intervalInMilliseconds: cint) {.header: juce_events, importcpp: "#.startTimer(@)".}
proc stopTimer*(this: var MultiTimer, timerID: cint) {.header: juce_events, importcpp: "#.stopTimer(@)".}
proc isTimerRunning*(this: MultiTimer, timerID: cint): bool {.header: juce_events, importcpp: "#.isTimerRunning(@)".}
proc getTimerInterval*(this: MultiTimer, timerID: cint): cint {.header: juce_events, importcpp: "#.getTimerInterval(@)".}
proc `==`*(this: MultiTimer, other: MultiTimer): bool {.error: "juce::MultiTimer defines no operator==; compare a property instead".}

# proc singletonHolder*(this: typedesc[ChildProcessManager]): juce::SingletonHolder<ChildProcessManager, juce::DummyCriticalSection, false> {.header: juce_events, importcpp: "(juce::ChildProcessManager::singletonHolder)".}  # JUCE's SingletonHolder, which is reached through the singleton it holds
proc getInstance*(this: typedesc[ChildProcessManager]): ptr ChildProcessManager {.header: juce_events, importcpp: "juce::ChildProcessManager::getInstance()".}
proc getInstanceWithoutCreating*(this: typedesc[ChildProcessManager]): ptr ChildProcessManager {.header: juce_events, importcpp: "juce::ChildProcessManager::getInstanceWithoutCreating()".}
proc deleteInstance*(this: typedesc[ChildProcessManager]) {.header: juce_events, importcpp: "juce::ChildProcessManager::deleteInstance()".}
proc clearSingletonInstance*(this: var ChildProcessManager) {.header: juce_events, importcpp: "#.clearSingletonInstance()".}
proc addChildProcessExitedListener*(this: var ChildProcessManager, listener: CppFunctionObjectN1[ChildProcess]): ErasedScopeGuard {.header: juce_events, importcpp: "#.addChildProcessExitedListener(@)".}
proc hasRunningProcess*(this: ChildProcessManager): bool {.header: juce_events, importcpp: "#.hasRunningProcess()".}
proc `==`*(this: ChildProcessManager, other: ChildProcessManager): bool {.error: "juce::ChildProcessManager defines no operator==; compare a property instead".}

# proc makeInterprocessConnection*(callbacksOnMessageThread: bool, magicMessageHeaderNumber: uint32): InterprocessConnection {.header: juce_events, importcpp: "juce::InterprocessConnection(@)".}  # InterprocessConnection is abstract; build a CustomInterprocessConnection instead
proc connectToSocket*(this: var InterprocessConnection, hostName: String, portNumber: cint, timeOutMillisecs: cint): bool {.header: juce_events, importcpp: "#.connectToSocket(@)".}
proc connectToPipe*(this: var InterprocessConnection, pipeName: String, pipeReceiveMessageTimeoutMs: cint): bool {.header: juce_events, importcpp: "#.connectToPipe(@)".}
proc createPipe*(this: var InterprocessConnection, pipeName: String, pipeReceiveMessageTimeoutMs: cint, mustNotExist: bool = false): bool {.header: juce_events, importcpp: "#.createPipe(@)".}
proc disconnect*(this: var InterprocessConnection, timeoutMs: cint = -1, notify: InterprocessConnectionNotify) {.header: juce_events, importcpp: "#.disconnect(@)".}
proc isConnected*(this: InterprocessConnection): bool {.header: juce_events, importcpp: "#.isConnected()".}
proc getSocket*(this: InterprocessConnection): ptr StreamingSocket {.header: juce_events, importcpp: "#.getSocket()".}
proc getPipe*(this: InterprocessConnection): ptr NamedPipe {.header: juce_events, importcpp: "#.getPipe()".}
proc getConnectedHostName*(this: InterprocessConnection): String {.header: juce_events, importcpp: "#.getConnectedHostName()".}
proc sendMessage*(this: var InterprocessConnection, message: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessage(@)".}
proc connectionMade*(this: var InterprocessConnection) {.header: juce_events, importcpp: "#.connectionMade()".}
proc connectionLost*(this: var InterprocessConnection) {.header: juce_events, importcpp: "#.connectionLost()".}
proc messageReceived*(this: var InterprocessConnection, message: MemoryBlock) {.header: juce_events, importcpp: "#.messageReceived(@)".}
proc `==`*(this: InterprocessConnection, other: InterprocessConnection): bool {.error: "juce::InterprocessConnection defines no operator==; compare a property instead".}

# proc makeInterprocessConnectionServer*(): InterprocessConnectionServer {.header: juce_events, importcpp: "juce::InterprocessConnectionServer(@)".}  # InterprocessConnectionServer is abstract; build a CustomInterprocessConnectionServer instead
proc beginWaitingForSocket*(this: var InterprocessConnectionServer, portNumber: cint, bindAddress: String): bool {.header: juce_events, importcpp: "#.beginWaitingForSocket(@)".}
proc stop*(this: var InterprocessConnectionServer) {.header: juce_events, importcpp: "#.stop()".}
proc getBoundPort*(this: InterprocessConnectionServer): cint {.header: juce_events, importcpp: "#.getBoundPort()".}
proc `==`*(this: InterprocessConnectionServer, other: InterprocessConnectionServer): bool {.error: "juce::InterprocessConnectionServer defines no operator==; compare a property instead".}

proc makeChildProcessWorker*(): ChildProcessWorker {.header: juce_events, importcpp: "juce::ChildProcessWorker(@)".}
proc initialiseFromCommandLine*(this: var ChildProcessWorker, commandLine: String, commandLineUniqueID: String, timeoutMs: cint = 0): bool {.header: juce_events, importcpp: "#.initialiseFromCommandLine(@)".}
proc handleMessageFromCoordinator*(this: var ChildProcessWorker, mb: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromCoordinator(@)".}
proc handleMessageFromMaster*(this: var ChildProcessWorker, arg1: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromMaster(@)".}
proc handleConnectionMade*(this: var ChildProcessWorker) {.header: juce_events, importcpp: "#.handleConnectionMade()".}
proc handleConnectionLost*(this: var ChildProcessWorker) {.header: juce_events, importcpp: "#.handleConnectionLost()".}
proc sendMessageToCoordinator*(this: var ChildProcessWorker, arg1: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToCoordinator(@)".}
proc sendMessageToMaster*(this: var ChildProcessWorker, mb: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToMaster(@)".}
proc `==`*(this: ChildProcessWorker, other: ChildProcessWorker): bool {.error: "juce::ChildProcessWorker defines no operator==; compare a property instead".}

proc makeChildProcessCoordinator*(): ChildProcessCoordinator {.header: juce_events, importcpp: "juce::ChildProcessCoordinator(@)".}
proc launchWorkerProcess*(this: var ChildProcessCoordinator, executableToLaunch: File, commandLineUniqueID: String, timeoutMs: cint = 0, streamFlags: cint): bool {.header: juce_events, importcpp: "#.launchWorkerProcess(@)".}
proc launchSlaveProcess*(this: var ChildProcessCoordinator, executableToLaunch: File, commandLineUniqueID: String, timeoutMs: cint = 0, streamFlags: cint): bool {.header: juce_events, importcpp: "#.launchSlaveProcess(@)".}
proc killWorkerProcess*(this: var ChildProcessCoordinator) {.header: juce_events, importcpp: "#.killWorkerProcess()".}
proc killSlaveProcess*(this: var ChildProcessCoordinator) {.header: juce_events, importcpp: "#.killSlaveProcess()".}
proc handleMessageFromWorker*(this: var ChildProcessCoordinator, arg1: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromWorker(@)".}
proc handleMessageFromSlave*(this: var ChildProcessCoordinator, arg1: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromSlave(@)".}
proc handleConnectionLost*(this: var ChildProcessCoordinator) {.header: juce_events, importcpp: "#.handleConnectionLost()".}
proc sendMessageToWorker*(this: var ChildProcessCoordinator, arg1: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToWorker(@)".}
proc sendMessageToSlave*(this: var ChildProcessCoordinator, mb: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToSlave(@)".}
proc `==`*(this: ChildProcessCoordinator, other: ChildProcessCoordinator): bool {.error: "juce::ChildProcessCoordinator defines no operator==; compare a property instead".}

proc `==`*(this: NetworkServiceDiscovery, other: NetworkServiceDiscovery): bool {.error: "juce::NetworkServiceDiscovery defines no operator==; compare a property instead".}

proc makeNetworkServiceDiscoveryAdvertiser*(serviceTypeUID: String, serviceDescription: String, broadcastPort: cint, connectionPort: cint, minTimeBetweenBroadcasts: RelativeTime): NetworkServiceDiscoveryAdvertiser {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery::Advertiser(@)".}
proc `==`*(this: NetworkServiceDiscoveryAdvertiser, other: NetworkServiceDiscoveryAdvertiser): bool {.error: "juce::NetworkServiceDiscovery::Advertiser defines no operator==; compare a property instead".}

proc makeNetworkServiceDiscoveryService*(): NetworkServiceDiscoveryService {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery::Service(@)".}  # implicit default constructor
proc instanceID*(this: NetworkServiceDiscoveryService): String {.header: juce_events, importcpp: "#.instanceID".}
proc instanceID*(this: var NetworkServiceDiscoveryService): var String {.header: juce_events, importcpp: "#.instanceID".}
proc `instanceID=`*(this: var NetworkServiceDiscoveryService, value: String) {.header: juce_events, importcpp: "#.instanceID = #".}
proc description*(this: NetworkServiceDiscoveryService): String {.header: juce_events, importcpp: "#.description".}
proc description*(this: var NetworkServiceDiscoveryService): var String {.header: juce_events, importcpp: "#.description".}
proc `description=`*(this: var NetworkServiceDiscoveryService, value: String) {.header: juce_events, importcpp: "#.description = #".}
proc address*(this: NetworkServiceDiscoveryService): IPAddress {.header: juce_events, importcpp: "#.address".}
proc address*(this: var NetworkServiceDiscoveryService): var IPAddress {.header: juce_events, importcpp: "#.address".}
proc `address=`*(this: var NetworkServiceDiscoveryService, value: IPAddress) {.header: juce_events, importcpp: "#.address = #".}
proc port*(this: NetworkServiceDiscoveryService): cint {.header: juce_events, importcpp: "#.port".}
proc port*(this: var NetworkServiceDiscoveryService): var cint {.header: juce_events, importcpp: "#.port".}
proc `port=`*(this: var NetworkServiceDiscoveryService, value: cint) {.header: juce_events, importcpp: "#.port = #".}
proc lastSeen*(this: NetworkServiceDiscoveryService): Time {.header: juce_events, importcpp: "#.lastSeen".}
proc lastSeen*(this: var NetworkServiceDiscoveryService): var Time {.header: juce_events, importcpp: "#.lastSeen".}
proc `lastSeen=`*(this: var NetworkServiceDiscoveryService, value: Time) {.header: juce_events, importcpp: "#.lastSeen = #".}
proc `==`*(this: NetworkServiceDiscoveryService, other: NetworkServiceDiscoveryService): bool {.error: "juce::NetworkServiceDiscovery::Service defines no operator==; compare a property instead".}

proc makeNetworkServiceDiscoveryAvailableServiceList*(serviceTypeUID: String, broadcastPort: cint): NetworkServiceDiscoveryAvailableServiceList {.header: juce_events, importcpp: "juce::NetworkServiceDiscovery::AvailableServiceList(@)".}
proc onChange*(this: NetworkServiceDiscoveryAvailableServiceList): CppFunctionObjectN0 {.header: juce_events, importcpp: "#.onChange".}
proc onChange*(this: var NetworkServiceDiscoveryAvailableServiceList): var CppFunctionObjectN0 {.header: juce_events, importcpp: "#.onChange".}
proc `onChange=`*(this: var NetworkServiceDiscoveryAvailableServiceList, value: CppFunctionObjectN0) {.header: juce_events, importcpp: "#.onChange = #".}
proc getServices*(this: NetworkServiceDiscoveryAvailableServiceList): CppVector[NetworkServiceDiscoveryService] {.header: juce_events, importcpp: "#.getServices()".}
proc `==`*(this: NetworkServiceDiscoveryAvailableServiceList, other: NetworkServiceDiscoveryAvailableServiceList): bool {.error: "juce::NetworkServiceDiscovery::AvailableServiceList defines no operator==; compare a property instead".}

proc makeScopedLowPowerModeDisabler*(): ScopedLowPowerModeDisabler {.header: juce_events, importcpp: "juce::ScopedLowPowerModeDisabler(@)".}
proc `==`*(this: ScopedLowPowerModeDisabler, other: ScopedLowPowerModeDisabler): bool {.error: "juce::ScopedLowPowerModeDisabler defines no operator==; compare a property instead".}

# proc initialiseJuce_GUI*() {.header: juce_events, importcpp: "juce::initialiseJuce_GUI()".}  # bound by hand in the _lifting file
# proc shutdownJuce_GUI*() {.header: juce_events, importcpp: "juce::shutdownJuce_GUI()".}  # bound by hand in the _lifting file




include juce_events_lifting


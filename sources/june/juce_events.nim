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

const
  NotificationType_dontSendNotification* = NotificationType(0)
  NotificationType_sendNotification* = NotificationType(1)
  NotificationType_sendNotificationSync* = NotificationType(2)
  NotificationType_sendNotificationAsync* = NotificationType(3)

const
  InterprocessConnectionNotify_no* = InterprocessConnectionNotify(0)
  InterprocessConnectionNotify_yes* = InterprocessConnectionNotify(1)

proc runDispatchLoop*(this: var MessageManager) {.header: juce_events, importcpp: "#.runDispatchLoop()".}
proc stopDispatchLoop*(this: var MessageManager) {.header: juce_events, importcpp: "#.stopDispatchLoop()".}
proc hasStopMessageBeenSent*(this: MessageManager): bool {.header: juce_events, importcpp: "#.hasStopMessageBeenSent()".}
# proc callFunctionOnMessageThread*(this: var MessageManager, callback: ptr MessageCallbackFunction, userData: pointer): pointer {.header: juce_events, importcpp: "#.callFunctionOnMessageThread(@)".}
proc isThisTheMessageThread*(this: MessageManager): bool {.header: juce_events, importcpp: "#.isThisTheMessageThread()".}
proc setCurrentThreadAsMessageThread*(this: var MessageManager) {.header: juce_events, importcpp: "#.setCurrentThreadAsMessageThread()".}
# proc getCurrentMessageThread*(this: MessageManager): Thread::ThreadID {.header: juce_events, importcpp: "#.getCurrentMessageThread()".}
proc currentThreadHasLockedMessageManager*(this: MessageManager): bool {.header: juce_events, importcpp: "#.currentThreadHasLockedMessageManager()".}
proc registerBroadcastListener*(this: var MessageManager, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.registerBroadcastListener(@)".}
proc deregisterBroadcastListener*(this: var MessageManager, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.deregisterBroadcastListener(@)".}
proc deliverBroadcastMessage*(this: var MessageManager, arg1: String) {.header: juce_events, importcpp: "#.deliverBroadcastMessage(@)".}

proc makeMessageManagerLock*(threadToCheckForExitSignal: ptr Thread): MessageManagerLock {.header: juce_events, importcpp: "juce::MessageManagerLock(@)".}
proc makeMessageManagerLock*(jobToCheckForExitSignal: ptr ThreadPoolJob): MessageManagerLock {.header: juce_events, importcpp: "juce::MessageManagerLock(@)".}
proc lockWasGained*(this: MessageManagerLock): bool {.header: juce_events, importcpp: "#.lockWasGained()".}

proc makeMessage*(): Message {.header: juce_events, importcpp: "juce::Message(@)".}

proc makeMessageListener*(): MessageListener {.header: juce_events, importcpp: "juce::MessageListener(@)".}
proc handleMessage*(this: var MessageListener, message: Message) {.header: juce_events, importcpp: "#.handleMessage(@)".}
proc postMessage*(this: MessageListener, message: ptr Message) {.header: juce_events, importcpp: "#.postMessage(@)".}

proc makeCallbackMessage*(): CallbackMessage {.header: juce_events, importcpp: "juce::CallbackMessage(@)".}
proc messageCallback*(this: var CallbackMessage) {.header: juce_events, importcpp: "#.messageCallback()".}


proc getApplicationName*(this: var JUCEApplicationBase): String {.header: juce_events, importcpp: "#.getApplicationName()".}
proc getApplicationVersion*(this: var JUCEApplicationBase): String {.header: juce_events, importcpp: "#.getApplicationVersion()".}
proc moreThanOneInstanceAllowed*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.moreThanOneInstanceAllowed()".}
proc initialise*(this: var JUCEApplicationBase, commandLineParameters: String) {.header: juce_events, importcpp: "#.initialise(@)".}
proc shutdown*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.shutdown()".}
proc anotherInstanceStarted*(this: var JUCEApplicationBase, commandLine: String) {.header: juce_events, importcpp: "#.anotherInstanceStarted(@)".}
proc systemRequestedQuit*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.systemRequestedQuit()".}
proc suspended*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.suspended()".}
proc resumed*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.resumed()".}
# proc unhandledException*(this: var JUCEApplicationBase, arg1: ptr std::exception, sourceFilename: String, lineNumber: int) {.header: juce_events, importcpp: "#.unhandledException(@)".}
proc memoryWarningReceived*(this: var JUCEApplicationBase) {.header: juce_events, importcpp: "#.memoryWarningReceived()".}
proc backButtonPressed*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.backButtonPressed()".}
proc setApplicationReturnValue*(this: var JUCEApplicationBase, newReturnValue: int) {.header: juce_events, importcpp: "#.setApplicationReturnValue(@)".}
proc getApplicationReturnValue*(this: JUCEApplicationBase): int {.header: juce_events, importcpp: "#.getApplicationReturnValue()".}
proc isInitialising*(this: JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.isInitialising()".}
proc initialiseApp*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.initialiseApp()".}
proc shutdownApp*(this: var JUCEApplicationBase): int {.header: juce_events, importcpp: "#.shutdownApp()".}
proc sendCommandLineToPreexistingInstance*(this: var JUCEApplicationBase): bool {.header: juce_events, importcpp: "#.sendCommandLineToPreexistingInstance()".}

proc makeScopedJuceInitialiser_GUI*(): ScopedJuceInitialiser_GUI {.header: juce_events, importcpp: "juce::ScopedJuceInitialiser_GUI(@)".}
proc `ScopedJuceInitialiser_GUI=`*(this: var ScopedJuceInitialiser_GUI, arg1: ScopedJuceInitialiser_GUI): var ScopedJuceInitialiser_GUI {.header: juce_events, importcpp: "#.operator=(@)".}
proc `ScopedJuceInitialiser_GUI=`*(this: var ScopedJuceInitialiser_GUI, arg1: lent ScopedJuceInitialiser_GUI): var ScopedJuceInitialiser_GUI {.header: juce_events, importcpp: "#.operator=(@)".}

proc makeMountedVolumeListChangeDetector*(): MountedVolumeListChangeDetector {.header: juce_events, importcpp: "juce::MountedVolumeListChangeDetector(@)".}
proc mountedVolumeListChanged*(this: var MountedVolumeListChangeDetector) {.header: juce_events, importcpp: "#.mountedVolumeListChanged()".}

proc makeActionBroadcaster*(): ActionBroadcaster {.header: juce_events, importcpp: "juce::ActionBroadcaster(@)".}
proc addActionListener*(this: var ActionBroadcaster, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.addActionListener(@)".}
proc removeActionListener*(this: var ActionBroadcaster, listener: ptr ActionListener) {.header: juce_events, importcpp: "#.removeActionListener(@)".}
proc removeAllActionListeners*(this: var ActionBroadcaster) {.header: juce_events, importcpp: "#.removeAllActionListeners()".}
proc sendActionMessage*(this: ActionBroadcaster, message: String) {.header: juce_events, importcpp: "#.sendActionMessage(@)".}

proc actionListenerCallback*(this: var ActionListener, message: String) {.header: juce_events, importcpp: "#.actionListenerCallback(@)".}

proc makeAsyncUpdater*(): AsyncUpdater {.header: juce_events, importcpp: "juce::AsyncUpdater(@)".}
proc triggerAsyncUpdate*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.triggerAsyncUpdate()".}
proc cancelPendingUpdate*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.cancelPendingUpdate()".}
proc handleUpdateNowIfNeeded*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.handleUpdateNowIfNeeded()".}
proc isUpdatePending*(this: AsyncUpdater): bool {.header: juce_events, importcpp: "#.isUpdatePending()".}
proc handleAsyncUpdate*(this: var AsyncUpdater) {.header: juce_events, importcpp: "#.handleAsyncUpdate()".}

proc makeLockingAsyncUpdater*(callbackToUse: CppFunctionObjectN0): LockingAsyncUpdater {.header: juce_events, importcpp: "juce::LockingAsyncUpdater(@)".}
proc `LockingAsyncUpdater=`*(this: var LockingAsyncUpdater, other: lent LockingAsyncUpdater): var LockingAsyncUpdater {.header: juce_events, importcpp: "#.operator=(@)".}
proc triggerAsyncUpdate*(this: var LockingAsyncUpdater) {.header: juce_events, importcpp: "#.triggerAsyncUpdate()".}
proc cancelPendingUpdate*(this: var LockingAsyncUpdater) {.header: juce_events, importcpp: "#.cancelPendingUpdate()".}
proc handleUpdateNowIfNeeded*(this: var LockingAsyncUpdater) {.header: juce_events, importcpp: "#.handleUpdateNowIfNeeded()".}
proc isUpdatePending*(this: LockingAsyncUpdater): bool {.header: juce_events, importcpp: "#.isUpdatePending()".}

proc changeListenerCallback*(this: var ChangeListener, source: ptr ChangeBroadcaster) {.header: juce_events, importcpp: "#.changeListenerCallback(@)".}

proc makeChangeBroadcaster*(): ChangeBroadcaster {.header: juce_events, importcpp: "juce::ChangeBroadcaster(@)".}
proc addChangeListener*(this: var ChangeBroadcaster, listener: ptr ChangeListener) {.header: juce_events, importcpp: "#.addChangeListener(@)".}
proc removeChangeListener*(this: var ChangeBroadcaster, listener: ptr ChangeListener) {.header: juce_events, importcpp: "#.removeChangeListener(@)".}
proc removeAllChangeListeners*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.removeAllChangeListeners()".}
proc sendChangeMessage*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.sendChangeMessage()".}
proc sendSynchronousChangeMessage*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.sendSynchronousChangeMessage()".}
proc dispatchPendingMessages*(this: var ChangeBroadcaster) {.header: juce_events, importcpp: "#.dispatchPendingMessages()".}

proc timerCallback*(this: var Timer) {.header: juce_events, importcpp: "#.timerCallback()".}
proc startTimer*(this: var Timer, intervalInMilliseconds: int) {.header: juce_events, importcpp: "#.startTimer(@)".}
proc startTimerHz*(this: var Timer, timerFrequencyHz: int) {.header: juce_events, importcpp: "#.startTimerHz(@)".}
proc stopTimer*(this: var Timer) {.header: juce_events, importcpp: "#.stopTimer()".}
proc isTimerRunning*(this: Timer): bool {.header: juce_events, importcpp: "#.isTimerRunning()".}
proc getTimerInterval*(this: Timer): int {.header: juce_events, importcpp: "#.getTimerInterval()".}

proc makeTimedCallback*(callbackIn: CppFunctionObjectN0): TimedCallback {.header: juce_events, importcpp: "juce::TimedCallback(@)".}

proc timerCallback*(this: var MultiTimer, timerID: int) {.header: juce_events, importcpp: "#.timerCallback(@)".}
proc startTimer*(this: var MultiTimer, timerID: int, intervalInMilliseconds: int) {.header: juce_events, importcpp: "#.startTimer(@)".}
proc stopTimer*(this: var MultiTimer, timerID: int) {.header: juce_events, importcpp: "#.stopTimer(@)".}
proc isTimerRunning*(this: MultiTimer, timerID: int): bool {.header: juce_events, importcpp: "#.isTimerRunning(@)".}
proc getTimerInterval*(this: MultiTimer, timerID: int): int {.header: juce_events, importcpp: "#.getTimerInterval(@)".}

proc clearSingletonInstance*(this: var ChildProcessManager) {.header: juce_events, importcpp: "#.clearSingletonInstance()".}
proc addChildProcessExitedListener*(this: var ChildProcessManager, listener: CppFunctionObjectN1[ChildProcess]): ErasedScopeGuard {.header: juce_events, importcpp: "#.addChildProcessExitedListener(@)".}
proc hasRunningProcess*(this: ChildProcessManager): bool {.header: juce_events, importcpp: "#.hasRunningProcess()".}

proc makeInterprocessConnection*(callbacksOnMessageThread: bool, magicMessageHeaderNumber: uint32): InterprocessConnection {.header: juce_events, importcpp: "juce::InterprocessConnection(@)".}
proc connectToSocket*(this: var InterprocessConnection, hostName: String, portNumber: int, timeOutMillisecs: int): bool {.header: juce_events, importcpp: "#.connectToSocket(@)".}
proc connectToPipe*(this: var InterprocessConnection, pipeName: String, pipeReceiveMessageTimeoutMs: int): bool {.header: juce_events, importcpp: "#.connectToPipe(@)".}
proc createPipe*(this: var InterprocessConnection, pipeName: String, pipeReceiveMessageTimeoutMs: int, mustNotExist: bool = false): bool {.header: juce_events, importcpp: "#.createPipe(@)".}
proc disconnect*(this: var InterprocessConnection, timeoutMs: int = -1, notify: InterprocessConnectionNotify) {.header: juce_events, importcpp: "#.disconnect(@)".}
proc isConnected*(this: InterprocessConnection): bool {.header: juce_events, importcpp: "#.isConnected()".}
proc getSocket*(this: InterprocessConnection): ptr StreamingSocket {.header: juce_events, importcpp: "#.getSocket()".}
proc getPipe*(this: InterprocessConnection): ptr NamedPipe {.header: juce_events, importcpp: "#.getPipe()".}
proc getConnectedHostName*(this: InterprocessConnection): String {.header: juce_events, importcpp: "#.getConnectedHostName()".}
proc sendMessage*(this: var InterprocessConnection, message: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessage(@)".}
proc connectionMade*(this: var InterprocessConnection) {.header: juce_events, importcpp: "#.connectionMade()".}
proc connectionLost*(this: var InterprocessConnection) {.header: juce_events, importcpp: "#.connectionLost()".}
proc messageReceived*(this: var InterprocessConnection, message: MemoryBlock) {.header: juce_events, importcpp: "#.messageReceived(@)".}

proc makeInterprocessConnectionServer*(): InterprocessConnectionServer {.header: juce_events, importcpp: "juce::InterprocessConnectionServer(@)".}
proc beginWaitingForSocket*(this: var InterprocessConnectionServer, portNumber: int, bindAddress: String): bool {.header: juce_events, importcpp: "#.beginWaitingForSocket(@)".}
proc stop*(this: var InterprocessConnectionServer) {.header: juce_events, importcpp: "#.stop()".}
proc getBoundPort*(this: InterprocessConnectionServer): int {.header: juce_events, importcpp: "#.getBoundPort()".}

proc makeChildProcessWorker*(): ChildProcessWorker {.header: juce_events, importcpp: "juce::ChildProcessWorker(@)".}
proc initialiseFromCommandLine*(this: var ChildProcessWorker, commandLine: String, commandLineUniqueID: String, timeoutMs: int = 0): bool {.header: juce_events, importcpp: "#.initialiseFromCommandLine(@)".}
proc handleMessageFromCoordinator*(this: var ChildProcessWorker, mb: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromCoordinator(@)".}
proc handleMessageFromMaster*(this: var ChildProcessWorker, arg1: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromMaster(@)".}
proc handleConnectionMade*(this: var ChildProcessWorker) {.header: juce_events, importcpp: "#.handleConnectionMade()".}
proc handleConnectionLost*(this: var ChildProcessWorker) {.header: juce_events, importcpp: "#.handleConnectionLost()".}
proc sendMessageToCoordinator*(this: var ChildProcessWorker, arg1: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToCoordinator(@)".}
proc sendMessageToMaster*(this: var ChildProcessWorker, mb: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToMaster(@)".}

proc makeChildProcessCoordinator*(): ChildProcessCoordinator {.header: juce_events, importcpp: "juce::ChildProcessCoordinator(@)".}
proc launchWorkerProcess*(this: var ChildProcessCoordinator, executableToLaunch: File, commandLineUniqueID: String, timeoutMs: int = 0, streamFlags: int): bool {.header: juce_events, importcpp: "#.launchWorkerProcess(@)".}
proc launchSlaveProcess*(this: var ChildProcessCoordinator, executableToLaunch: File, commandLineUniqueID: String, timeoutMs: int = 0, streamFlags: int): bool {.header: juce_events, importcpp: "#.launchSlaveProcess(@)".}
proc killWorkerProcess*(this: var ChildProcessCoordinator) {.header: juce_events, importcpp: "#.killWorkerProcess()".}
proc killSlaveProcess*(this: var ChildProcessCoordinator) {.header: juce_events, importcpp: "#.killSlaveProcess()".}
proc handleMessageFromWorker*(this: var ChildProcessCoordinator, arg1: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromWorker(@)".}
proc handleMessageFromSlave*(this: var ChildProcessCoordinator, arg1: MemoryBlock) {.header: juce_events, importcpp: "#.handleMessageFromSlave(@)".}
proc handleConnectionLost*(this: var ChildProcessCoordinator) {.header: juce_events, importcpp: "#.handleConnectionLost()".}
proc sendMessageToWorker*(this: var ChildProcessCoordinator, arg1: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToWorker(@)".}
proc sendMessageToSlave*(this: var ChildProcessCoordinator, mb: MemoryBlock): bool {.header: juce_events, importcpp: "#.sendMessageToSlave(@)".}


proc makeScopedLowPowerModeDisabler*(): ScopedLowPowerModeDisabler {.header: juce_events, importcpp: "juce::ScopedLowPowerModeDisabler(@)".}



include juce_events_lifting


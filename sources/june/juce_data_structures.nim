import june_common

const juce_data_structures = "../../JUCE/modules/juce_data_structures/juce_data_structures.h"

type
  UndoableAction* {.header: juce_data_structures, importcpp: "juce::UndoableAction", inheritable, pure.} = object
  UndoManager* {.header: juce_data_structures, importcpp: "juce::UndoManager", inheritable, pure.} = object of ChangeBroadcaster
  Value* {.header: juce_data_structures, importcpp: "juce::Value", inheritable, pure.} = object
  ValueListener* {.header: juce_data_structures, importcpp: "juce::Value::Listener", inheritable, pure.} = object
  ValueValueSource* {.header: juce_data_structures, importcpp: "juce::Value::ValueSource", inheritable, pure.} = object
  ValueTree* {.header: juce_data_structures, importcpp: "juce::ValueTree", inheritable, pure.} = object
  ValueTreeIterator* {.header: juce_data_structures, importcpp: "juce::ValueTree::Iterator", inheritable, pure.} = object
  ValueTreeListener* {.header: juce_data_structures, importcpp: "juce::ValueTree::Listener", inheritable, pure.} = object
  ValueTreeSynchroniser* {.header: juce_data_structures, importcpp: "juce::ValueTreeSynchroniser", inheritable, pure.} = object
  ValueTreePropertyWithDefault* {.header: juce_data_structures, importcpp: "juce::ValueTreePropertyWithDefault", inheritable, pure.} = object
  PropertiesFile* {.header: juce_data_structures, importcpp: "juce::PropertiesFile", inheritable, pure.} = object of PropertySet
  PropertiesFileOptions* {.header: juce_data_structures, importcpp: "juce::PropertiesFile::Options", inheritable, pure.} = object
  ApplicationProperties* {.header: juce_data_structures, importcpp: "juce::ApplicationProperties", inheritable, pure.} = object
  PropertiesFileStorageFormat* {.header: juce_data_structures, importcpp: "juce::PropertiesFile::StorageFormat".} = distinct cint

const
  PropertiesFileStorageFormat_storeAsBinary* = PropertiesFileStorageFormat(0)
  PropertiesFileStorageFormat_storeAsCompressedBinary* = PropertiesFileStorageFormat(1)
  PropertiesFileStorageFormat_storeAsXML* = PropertiesFileStorageFormat(2)

proc perform*(this: var UndoableAction): bool {.header: juce_data_structures, importcpp: "#.perform()".}
proc undo*(this: var UndoableAction): bool {.header: juce_data_structures, importcpp: "#.undo()".}
proc getSizeInUnits*(this: var UndoableAction): cint {.header: juce_data_structures, importcpp: "#.getSizeInUnits()".}
proc createCoalescedAction*(this: var UndoableAction, nextAction: ptr UndoableAction): ptr UndoableAction {.header: juce_data_structures, importcpp: "#.createCoalescedAction(@)".}

proc makeUndoManager*(maxNumberOfUnitsToKeep: cint, minimumTransactionsToKeep: cint): UndoManager {.header: juce_data_structures, importcpp: "juce::UndoManager(@)".}
proc clearUndoHistory*(this: var UndoManager) {.header: juce_data_structures, importcpp: "#.clearUndoHistory()".}
proc getNumberOfUnitsTakenUpByStoredCommands*(this: UndoManager): cint {.header: juce_data_structures, importcpp: "#.getNumberOfUnitsTakenUpByStoredCommands()".}
proc setMaxNumberOfStoredUnits*(this: var UndoManager, maxNumberOfUnitsToKeep: cint, minimumTransactionsToKeep: cint) {.header: juce_data_structures, importcpp: "#.setMaxNumberOfStoredUnits(@)".}
proc perform*(this: var UndoManager, action: ptr UndoableAction): bool {.header: juce_data_structures, importcpp: "#.perform(@)".}
proc perform*(this: var UndoManager, action: ptr UndoableAction, actionName: String): bool {.header: juce_data_structures, importcpp: "#.perform(@)".}
proc beginNewTransaction*(this: var UndoManager) {.header: juce_data_structures, importcpp: "#.beginNewTransaction()".}
proc beginNewTransaction*(this: var UndoManager, actionName: String) {.header: juce_data_structures, importcpp: "#.beginNewTransaction(@)".}
proc setCurrentTransactionName*(this: var UndoManager, newName: String) {.header: juce_data_structures, importcpp: "#.setCurrentTransactionName(@)".}
proc getCurrentTransactionName*(this: UndoManager): String {.header: juce_data_structures, importcpp: "#.getCurrentTransactionName()".}
proc canUndo*(this: UndoManager): bool {.header: juce_data_structures, importcpp: "#.canUndo()".}
proc undo*(this: var UndoManager): bool {.header: juce_data_structures, importcpp: "#.undo()".}
proc undoCurrentTransactionOnly*(this: var UndoManager): bool {.header: juce_data_structures, importcpp: "#.undoCurrentTransactionOnly()".}
proc getUndoDescription*(this: UndoManager): String {.header: juce_data_structures, importcpp: "#.getUndoDescription()".}
proc getUndoDescriptions*(this: UndoManager): StringArray {.header: juce_data_structures, importcpp: "#.getUndoDescriptions()".}
proc getTimeOfUndoTransaction*(this: UndoManager): Time {.header: juce_data_structures, importcpp: "#.getTimeOfUndoTransaction()".}
proc getActionsInCurrentTransaction*(this: UndoManager, actionsFound: Array[UndoableAction]) {.header: juce_data_structures, importcpp: "#.getActionsInCurrentTransaction(@)".}
proc getNumActionsInCurrentTransaction*(this: UndoManager): cint {.header: juce_data_structures, importcpp: "#.getNumActionsInCurrentTransaction()".}
proc canRedo*(this: UndoManager): bool {.header: juce_data_structures, importcpp: "#.canRedo()".}
proc redo*(this: var UndoManager): bool {.header: juce_data_structures, importcpp: "#.redo()".}
proc getRedoDescription*(this: UndoManager): String {.header: juce_data_structures, importcpp: "#.getRedoDescription()".}
proc getRedoDescriptions*(this: UndoManager): StringArray {.header: juce_data_structures, importcpp: "#.getRedoDescriptions()".}
proc getTimeOfRedoTransaction*(this: UndoManager): Time {.header: juce_data_structures, importcpp: "#.getTimeOfRedoTransaction()".}
proc isPerformingUndoRedo*(this: UndoManager): bool {.header: juce_data_structures, importcpp: "#.isPerformingUndoRedo()".}

proc makeValue*(): Value {.header: juce_data_structures, importcpp: "juce::Value(@)".}
proc makeValue*(initialValue: juce_var): Value {.header: juce_data_structures, importcpp: "juce::Value(@)".}
proc makeValue*(valueSource: ptr ValueValueSource): Value {.header: juce_data_structures, importcpp: "juce::Value(@)".}
proc getValue*(this: Value): juce_var {.header: juce_data_structures, importcpp: "#.getValue()".}
proc toString*(this: Value): String {.header: juce_data_structures, importcpp: "#.toString()".}
proc setValue*(this: var Value, newValue: juce_var) {.header: juce_data_structures, importcpp: "#.setValue(@)".}
proc `Value=`*(this: var Value, newValue: juce_var): var Value {.header: juce_data_structures, importcpp: "#.operator=(@)".}
proc `Value=`*(this: var Value, arg1: lent Value): var Value {.header: juce_data_structures, importcpp: "#.operator=(@)".}
proc referTo*(this: var Value, valueToReferTo: Value) {.header: juce_data_structures, importcpp: "#.referTo(@)".}
proc refersToSameSourceAs*(this: Value, other: Value): bool {.header: juce_data_structures, importcpp: "#.refersToSameSourceAs(@)".}
proc `==`*(this: Value, other: Value): bool {.header: juce_data_structures, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Value, other: Value): bool {.header: juce_data_structures, importcpp: "#.operator!=(@)".}
proc addListener*(this: var Value, listener: ptr ValueListener) {.header: juce_data_structures, importcpp: "#.addListener(@)".}
proc removeListener*(this: var Value, listener: ptr ValueListener) {.header: juce_data_structures, importcpp: "#.removeListener(@)".}
proc getValueSource*(this: var Value): var ValueValueSource {.header: juce_data_structures, importcpp: "#.getValueSource()".}

proc makeValueTree*(): ValueTree {.header: juce_data_structures, importcpp: "juce::ValueTree(@)".}
proc makeValueTree*(`type`: Identifier): ValueTree {.header: juce_data_structures, importcpp: "juce::ValueTree(@)".}
# proc makeValueTree*(`type`: Identifier, properties: std::initializer_list<NamedValueSet::NamedValue>, subTrees: std::initializer_list<ValueTree>): ValueTree {.header: juce_data_structures, importcpp: "juce::ValueTree(@)".}
proc `ValueTree=`*(this: var ValueTree, arg1: ValueTree): var ValueTree {.header: juce_data_structures, importcpp: "#.operator=(@)".}
proc `==`*(this: ValueTree, arg1: ValueTree): bool {.header: juce_data_structures, importcpp: "#.operator==(@)".}
# proc operator!=*(this: ValueTree, arg1: ValueTree): bool {.header: juce_data_structures, importcpp: "#.operator!=(@)".}
proc isEquivalentTo*(this: ValueTree, arg1: ValueTree): bool {.header: juce_data_structures, importcpp: "#.isEquivalentTo(@)".}
proc isValid*(this: ValueTree): bool {.header: juce_data_structures, importcpp: "#.isValid()".}
proc createCopy*(this: ValueTree): ValueTree {.header: juce_data_structures, importcpp: "#.createCopy()".}
proc copyPropertiesFrom*(this: var ValueTree, source: ValueTree, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.copyPropertiesFrom(@)".}
proc copyPropertiesAndChildrenFrom*(this: var ValueTree, source: ValueTree, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.copyPropertiesAndChildrenFrom(@)".}
proc getType*(this: ValueTree): Identifier {.header: juce_data_structures, importcpp: "#.getType()".}
proc hasType*(this: ValueTree, typeName: Identifier): bool {.header: juce_data_structures, importcpp: "#.hasType(@)".}
proc getProperty*(this: ValueTree, name: Identifier): juce_var {.header: juce_data_structures, importcpp: "#.getProperty(@)".}
proc getProperty*(this: ValueTree, name: Identifier, defaultReturnValue: juce_var): juce_var {.header: juce_data_structures, importcpp: "#.getProperty(@)".}
proc getPropertyPointer*(this: ValueTree, name: Identifier): ptr juce_var {.header: juce_data_structures, importcpp: "#.getPropertyPointer(@)".}
proc `[]`*(this: ValueTree, name: Identifier): juce_var {.header: juce_data_structures, importcpp: "#.operator[](@)".}
proc setProperty*(this: var ValueTree, name: Identifier, newValue: juce_var, undoManager: ptr UndoManager): var ValueTree {.header: juce_data_structures, importcpp: "#.setProperty(@)".}
proc hasProperty*(this: ValueTree, name: Identifier): bool {.header: juce_data_structures, importcpp: "#.hasProperty(@)".}
proc removeProperty*(this: var ValueTree, name: Identifier, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.removeProperty(@)".}
proc removeAllProperties*(this: var ValueTree, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.removeAllProperties(@)".}
proc getNumProperties*(this: ValueTree): cint {.header: juce_data_structures, importcpp: "#.getNumProperties()".}
proc getPropertyName*(this: ValueTree, index: cint): Identifier {.header: juce_data_structures, importcpp: "#.getPropertyName(@)".}
proc getPropertyAsValue*(this: var ValueTree, name: Identifier, undoManager: ptr UndoManager, shouldUpdateSynchronously: bool = false): Value {.header: juce_data_structures, importcpp: "#.getPropertyAsValue(@)".}
proc getNumChildren*(this: ValueTree): cint {.header: juce_data_structures, importcpp: "#.getNumChildren()".}
proc getChild*(this: ValueTree, index: cint): ValueTree {.header: juce_data_structures, importcpp: "#.getChild(@)".}
proc getChildWithName*(this: ValueTree, `type`: Identifier): ValueTree {.header: juce_data_structures, importcpp: "#.getChildWithName(@)".}
proc getOrCreateChildWithName*(this: var ValueTree, `type`: Identifier, undoManager: ptr UndoManager): ValueTree {.header: juce_data_structures, importcpp: "#.getOrCreateChildWithName(@)".}
proc getChildWithProperty*(this: ValueTree, propertyName: Identifier, propertyValue: juce_var): ValueTree {.header: juce_data_structures, importcpp: "#.getChildWithProperty(@)".}
proc addChild*(this: var ValueTree, child: ValueTree, index: cint, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.addChild(@)".}
proc appendChild*(this: var ValueTree, child: ValueTree, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.appendChild(@)".}
proc removeChild*(this: var ValueTree, child: ValueTree, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.removeChild(@)".}
proc removeChild*(this: var ValueTree, childIndex: cint, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.removeChild(@)".}
proc removeAllChildren*(this: var ValueTree, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.removeAllChildren(@)".}
proc moveChild*(this: var ValueTree, currentIndex: cint, newIndex: cint, undoManager: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.moveChild(@)".}
proc isAChildOf*(this: ValueTree, possibleParent: ValueTree): bool {.header: juce_data_structures, importcpp: "#.isAChildOf(@)".}
proc indexOf*(this: ValueTree, child: ValueTree): cint {.header: juce_data_structures, importcpp: "#.indexOf(@)".}
proc getParent*(this: ValueTree): ValueTree {.header: juce_data_structures, importcpp: "#.getParent()".}
proc getRoot*(this: ValueTree): ValueTree {.header: juce_data_structures, importcpp: "#.getRoot()".}
proc getSibling*(this: ValueTree, delta: cint): ValueTree {.header: juce_data_structures, importcpp: "#.getSibling(@)".}
# proc begin*(this: ValueTree): ValueTreeIterator {.header: juce_data_structures, importcpp: "#.begin()".}
# proc `end`*(this: ValueTree): ValueTreeIterator {.header: juce_data_structures, importcpp: "#.end()".}
proc createXml*(this: ValueTree): UniquePtr[XmlElement] {.header: juce_data_structures, importcpp: "#.createXml()".}
proc toXmlString*(this: ValueTree, format: XmlElementTextFormat): String {.header: juce_data_structures, importcpp: "#.toXmlString(@)".}
proc writeToStream*(this: ValueTree, output: var OutputStream) {.header: juce_data_structures, importcpp: "#.writeToStream(@)".}
proc addListener*(this: var ValueTree, listener: ptr ValueTreeListener) {.header: juce_data_structures, importcpp: "#.addListener(@)".}
proc removeListener*(this: var ValueTree, listener: ptr ValueTreeListener) {.header: juce_data_structures, importcpp: "#.removeListener(@)".}
proc setPropertyExcludingListener*(this: var ValueTree, listenerToExclude: ptr ValueTreeListener, name: Identifier, newValue: juce_var, undoManager: ptr UndoManager): var ValueTree {.header: juce_data_structures, importcpp: "#.setPropertyExcludingListener(@)".}
proc sendPropertyChangeMessage*(this: var ValueTree, property: Identifier) {.header: juce_data_structures, importcpp: "#.sendPropertyChangeMessage(@)".}
proc getReferenceCount*(this: ValueTree): cint {.header: juce_data_structures, importcpp: "#.getReferenceCount()".}

proc makeValueTreeSynchroniser*(tree: ValueTree): ValueTreeSynchroniser {.header: juce_data_structures, importcpp: "juce::ValueTreeSynchroniser(@)".}
proc stateChanged*(this: var ValueTreeSynchroniser, encodedChange: constPointer, encodedChangeSize: uint64) {.header: juce_data_structures, importcpp: "#.stateChanged(@)".}
proc sendFullSyncCallback*(this: var ValueTreeSynchroniser) {.header: juce_data_structures, importcpp: "#.sendFullSyncCallback()".}
proc getRoot*(this: var ValueTreeSynchroniser): ValueTree {.header: juce_data_structures, importcpp: "#.getRoot()".}

proc makeValueTreePropertyWithDefault*(): ValueTreePropertyWithDefault {.header: juce_data_structures, importcpp: "juce::ValueTreePropertyWithDefault(@)".}
proc makeValueTreePropertyWithDefault*(tree: var ValueTree, propertyID: Identifier, um: ptr UndoManager): ValueTreePropertyWithDefault {.header: juce_data_structures, importcpp: "juce::ValueTreePropertyWithDefault(@)".}
proc makeValueTreePropertyWithDefault*(tree: var ValueTree, propertyID: Identifier, um: ptr UndoManager, defaultToUse: juce_var): ValueTreePropertyWithDefault {.header: juce_data_structures, importcpp: "juce::ValueTreePropertyWithDefault(@)".}
proc makeValueTreePropertyWithDefault*(tree: var ValueTree, propertyID: Identifier, um: ptr UndoManager, defaultToUse: juce_var, arrayDelimiter: StringRef): ValueTreePropertyWithDefault {.header: juce_data_structures, importcpp: "juce::ValueTreePropertyWithDefault(@)".}
proc get*(this: ValueTreePropertyWithDefault): juce_var {.header: juce_data_structures, importcpp: "#.get()".}
proc getPropertyAsValue*(this: var ValueTreePropertyWithDefault): Value {.header: juce_data_structures, importcpp: "#.getPropertyAsValue()".}
proc getDefault*(this: ValueTreePropertyWithDefault): juce_var {.header: juce_data_structures, importcpp: "#.getDefault()".}
proc setDefault*(this: var ValueTreePropertyWithDefault, newDefault: juce_var) {.header: juce_data_structures, importcpp: "#.setDefault(@)".}
proc isUsingDefault*(this: ValueTreePropertyWithDefault): bool {.header: juce_data_structures, importcpp: "#.isUsingDefault()".}
proc resetToDefault*(this: var ValueTreePropertyWithDefault) {.header: juce_data_structures, importcpp: "#.resetToDefault()".}
proc `ValueTreePropertyWithDefault=`*(this: var ValueTreePropertyWithDefault, newValue: juce_var): var ValueTreePropertyWithDefault {.header: juce_data_structures, importcpp: "#.operator=(@)".}
proc setValue*(this: var ValueTreePropertyWithDefault, newValue: juce_var, undoManagerToUse: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.setValue(@)".}
proc referTo*(this: var ValueTreePropertyWithDefault, tree: ValueTree, property: Identifier, um: ptr UndoManager) {.header: juce_data_structures, importcpp: "#.referTo(@)".}
proc referTo*(this: var ValueTreePropertyWithDefault, tree: ValueTree, property: Identifier, um: ptr UndoManager, defaultVal: juce_var) {.header: juce_data_structures, importcpp: "#.referTo(@)".}
proc referTo*(this: var ValueTreePropertyWithDefault, tree: ValueTree, property: Identifier, um: ptr UndoManager, defaultVal: juce_var, arrayDelimiter: StringRef) {.header: juce_data_structures, importcpp: "#.referTo(@)".}
proc getValueTree*(this: var ValueTreePropertyWithDefault): var ValueTree {.header: juce_data_structures, importcpp: "#.getValueTree()".}
proc getPropertyID*(this: var ValueTreePropertyWithDefault): var Identifier {.header: juce_data_structures, importcpp: "#.getPropertyID()".}
proc getPropertyID*(this: ValueTreePropertyWithDefault): Identifier {.header: juce_data_structures, importcpp: "#.getPropertyID()".}
proc getUndoManager*(this: var ValueTreePropertyWithDefault): ptr UndoManager {.header: juce_data_structures, importcpp: "#.getUndoManager()".}
proc `ValueTreePropertyWithDefault=`*(this: var ValueTreePropertyWithDefault, other: ValueTreePropertyWithDefault): var ValueTreePropertyWithDefault {.header: juce_data_structures, importcpp: "#.operator=(@)".}

proc makePropertiesFile*(options: PropertiesFileOptions): PropertiesFile {.header: juce_data_structures, importcpp: "juce::PropertiesFile(@)".}
proc makePropertiesFile*(file: File, options: PropertiesFileOptions): PropertiesFile {.header: juce_data_structures, importcpp: "juce::PropertiesFile(@)".}
proc isValidFile*(this: PropertiesFile): bool {.header: juce_data_structures, importcpp: "#.isValidFile()".}
proc saveIfNeeded*(this: var PropertiesFile): bool {.header: juce_data_structures, importcpp: "#.saveIfNeeded()".}
proc save*(this: var PropertiesFile): bool {.header: juce_data_structures, importcpp: "#.save()".}
proc needsToBeSaved*(this: PropertiesFile): bool {.header: juce_data_structures, importcpp: "#.needsToBeSaved()".}
proc setNeedsToBeSaved*(this: var PropertiesFile, needsToBeSaved: bool) {.header: juce_data_structures, importcpp: "#.setNeedsToBeSaved(@)".}
proc reload*(this: var PropertiesFile): bool {.header: juce_data_structures, importcpp: "#.reload()".}
proc getFile*(this: PropertiesFile): File {.header: juce_data_structures, importcpp: "#.getFile()".}

proc makeApplicationProperties*(): ApplicationProperties {.header: juce_data_structures, importcpp: "juce::ApplicationProperties(@)".}
proc setStorageParameters*(this: var ApplicationProperties, options: PropertiesFileOptions) {.header: juce_data_structures, importcpp: "#.setStorageParameters(@)".}
proc getStorageParameters*(this: ApplicationProperties): PropertiesFileOptions {.header: juce_data_structures, importcpp: "#.getStorageParameters()".}
proc getUserSettings*(this: var ApplicationProperties): ptr PropertiesFile {.header: juce_data_structures, importcpp: "#.getUserSettings()".}
proc getCommonSettings*(this: var ApplicationProperties, returnUserPropsIfReadOnly: bool): ptr PropertiesFile {.header: juce_data_structures, importcpp: "#.getCommonSettings(@)".}
proc saveIfNeeded*(this: var ApplicationProperties): bool {.header: juce_data_structures, importcpp: "#.saveIfNeeded()".}
proc closeFiles*(this: var ApplicationProperties) {.header: juce_data_structures, importcpp: "#.closeFiles()".}



include juce_data_structures_lifting


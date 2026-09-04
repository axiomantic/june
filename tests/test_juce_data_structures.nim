
import june

# ValueTree was unusable before the bindings resolved types: every property
# accessor took and returned int, because Identifier and var did not survive
# type resolution.
proc testValueTree() =
  let nodeType = makeIdentifier("node")
  let colourId = makeIdentifier("colour")
  let sizeId = makeIdentifier("size")

  var tree = makeValueTree(nodeType)
  doAssert tree.isValid()
  doAssert $tree.getType().toString() == "node"
  doAssert tree.getNumProperties() == 0

  discard tree.setProperty(colourId, makejuce_var(0xff0000.cint), nil)
  discard tree.setProperty(sizeId, makejuce_var(42.cint), nil)
  doAssert tree.getNumProperties() == 2
  doAssert tree.hasProperty(colourId)
  doAssert not tree.hasProperty(makeIdentifier("missing"))
  doAssert $tree.getProperty(sizeId).toString() == "42"

  tree.removeProperty(colourId, nil)
  doAssert not tree.hasProperty(colourId)
  doAssert tree.getNumProperties() == 1

proc testChildren() =
  let rootType = makeIdentifier("root")
  let childType = makeIdentifier("child")

  var root = makeValueTree(rootType)
  doAssert root.getNumChildren() == 0

  let first = makeValueTree(childType)
  let second = makeValueTree(childType)
  root.appendChild(first, nil)
  root.appendChild(second, nil)
  doAssert root.getNumChildren() == 2
  doAssert $root.getChild(0).getType().toString() == "child"

  root.removeChild(0, nil)
  doAssert root.getNumChildren() == 1

testValueTree()
testChildren()

# Looping over a ValueTree. JUCE's begin() and end() have no Nim spelling, so
# without these iterators a caller has to write the index loop by hand.
proc testValueTreeIteration() =
  var tree = makeValueTree(makeIdentifier("root"))
  for name in ["alpha", "beta", "gamma"]:
    tree.appendChild(makeValueTree(makeIdentifier(name)), nil)

  var seen: seq[string] = @[]
  for child in tree:
    seen.add($child.getType().toString())
  doAssert seen == @["alpha", "beta", "gamma"], "iterated " & $seen

  var indexed: seq[cint] = @[]
  for index, child in tree:
    indexed.add(index)
  doAssert indexed == @[0.cint, 1.cint, 2.cint]

  discard tree.setProperty(makeIdentifier("size"), makejuce_var(42.cint), nil)
  var propertyNames: seq[string] = @[]
  for name, value in tree.properties():
    propertyNames.add($name.toString())
  doAssert propertyNames == @["size"], "properties " & $propertyNames

testValueTreeIteration()

# A generated UndoableAction, performed =======================================
#
# perform and undo are both pure virtual, so an undoable action could not be
# written in Nim. UndoManager owns the action once it is handed over, which is
# why nothing deletes it here.

proc testGeneratedUndoableAction() =
  var performed = 0
  var undone = 0

  var action = newCustomUndoableAction()
  action[].setPerformHandler(proc(): bool =
    performed += 1
    true)
  action[].setUndoHandler(proc(): bool =
    undone += 1
    true)

  var manager = makeUndoManager(30000.cint, 30.cint)
  doAssert manager.perform(cast[ptr UndoableAction](action)), "perform reported failure"
  doAssert performed == 1, "perform ran " & $performed & " times"
  doAssert undone == 0, "undo ran before it was asked to"

  doAssert manager.undo(), "undo reported failure"
  doAssert undone == 1, "undo ran " & $undone & " times"

testGeneratedUndoableAction()

# Value =======================================================================
#
# A shared reference to a var. Two Values referring to the same source see each
# other's writes, which is the whole point of the class and the only part worth
# asserting.

proc testValue() =
  var first = makeValue(makejuce_var(makeString("start")))
  doAssert $first.toString() == "start", "toString gave " & $first.toString()

  var second = makeValue()
  second.referTo(first)
  doAssert second.refersToSameSourceAs(first), "referTo did not share the source"

  first.setValue(makejuce_var(makeString("changed")))
  doAssert $second.toString() == "changed",
           "the other Value did not see the write: " & $second.toString()

  # A Value made on its own does not share with it.
  var separate = makeValue(makejuce_var(makeString("other")))
  doAssert not separate.refersToSameSourceAs(first), "an unrelated Value shared the source"

# ValueTreePropertyWithDefault ================================================
#
# A property that falls back to a default until something writes to it. The
# isUsingDefault flag is what distinguishes the two states, and it is exactly
# the sort of thing that reads true forever if bound wrong.

proc testValueTreePropertyWithDefault() =
  var tree = makeValueTree(makeIdentifier("settings"))
  var property = makeValueTreePropertyWithDefault(tree, makeIdentifier("volume"), nil)

  property.setDefault(makejuce_var(50.cint))
  doAssert property.isUsingDefault(), "a fresh property was not using its default"
  doAssert property.get().toString() == makejuce_var(50.cint).toString(),
           "the default did not come back"

  property.setValue(makejuce_var(80.cint), nil)
  doAssert not property.isUsingDefault(), "after a write it still reported the default"
  doAssert property.get().toString() == makejuce_var(80.cint).toString(),
           "the written value did not come back"

  property.resetToDefault()
  doAssert property.isUsingDefault(), "resetToDefault did not restore the default"

testValue()
testValueTreePropertyWithDefault()

# PropertiesFileOptions =======================================================
#
# The settings a PropertiesFile is opened with. Every field is reached through
# a var getter, so assigning one writes into the options rather than into a
# copy of them - which is the part worth asserting, because a copy would read
# back the old value and nothing else would say so.

proc testPropertiesFileOptions() =
  var options = makePropertiesFileOptions()
  doAssert $options.applicationName() == "", "a fresh options object had a name"
  doAssert not options.commonToAllUsers(), "a fresh options object was common to all users"

  options.applicationName = makeString("june-test")
  doAssert $options.applicationName() == "june-test",
           "the name came back as " & $options.applicationName()

  options.filenameSuffix = makeString("settings")
  doAssert $options.filenameSuffix() == "settings",
           "the suffix came back as " & $options.filenameSuffix()

  options.folderName = makeString("june")
  doAssert $options.folderName() == "june", "the folder came back as " & $options.folderName()

  options.commonToAllUsers = true
  doAssert options.commonToAllUsers(), "the flag did not stick"

  # The earlier fields survived the later writes.
  doAssert $options.applicationName() == "june-test",
           "a later write clobbered the name"

testPropertiesFileOptions()

# ConstPtr ====================================================================
#
# getPropertyPointer returns a const var*, which the generator used to bind as
# a plain `ptr juce_var`. C++ does not convert const var* to var*, so the proc
# could not be called at all - and nothing said so, because an importcpp string
# only reaches the C++ compiler at a call site.

proc testConstPtr() =
    block:
        var tree = makeValueTree(makeIdentifier(makeString("settings")))
        # setProperty returns the tree for chaining, which Nim will not drop
        # on its own.
        discard tree.setProperty(makeIdentifier(makeString("volume")),
                                 makejuce_var(11.cint), nil)

        let present = tree.getPropertyPointer(makeIdentifier(makeString("volume")))
        doAssert not present.isNil(), "the property that was just set has no pointer"
        doAssert present[].isInt(), "the property is not an int"
        doAssert present[].toInt() == 11,
                 "the property reads back as " & $present[].toInt()

        # A name the tree does not carry has no pointer, which is the other
        # half of the contract.
        let absent = tree.getPropertyPointer(makeIdentifier(makeString("balance")))
        doAssert absent.isNil(), "a property that was never set has a pointer"

testConstPtr()

# The remaining generated subclasses ==========================================

proc testRemainingDataStructuresSubclasses() =
    block:
        var tree = makeValueTree(makeIdentifier(makeString("root")))
        var synchroniser = newCustomValueTreeSynchroniser(tree)
        doAssert not synchroniser.isNil(), "the synchroniser was not built"
        synchroniser[].setStateChangedHandler(proc(encodedChange: pointer,
                                                   encodedChangeSize: csize_t) = discard)
        cdelete synchroniser

testRemainingDataStructuresSubclasses()
# Every closure arity ==========================================================
#
# june_function_utils declares bindClosure and a call operator for nought to
# nine arguments, with and without a result, but the bindings only reach N0-N3,
# N5, N9 and R0-R2. A Nim template is only type-checked where it is used and a
# generic proc only instantiated where it is called, so the rest had never been
# compiled at all. Each one is bound from a Nim closure here and called back
# through the std::function, so the arguments have to survive the round trip.
#
# Here rather than in test_juce_core: that module holds
# CppFunctionObjectR0[ThreadPoolJobJobStatus], for ThreadPool.addJob, and Nim
# renders one C++ type for that and for CppFunctionObjectR0[cint] because the
# enum is a distinct cint. Adding a cint-returning closure of arity nought
# there makes the assignment fail. basescalar and bindEnumClosure keep the
# distinct out of every Nim *closure* type; this is the same Nim limitation
# reaching the std::function type itself, and nothing in the bindings can
# reach it.

proc testEveryClosureArity() =
    block:
        var seen: seq[cint] = @[]
        seen = @[]
        var void0 = bindClosure(proc() =
                seen.add(0.cint))
        void0()
        doAssert seen == @[0.cint],
                 "the 0-argument void closure saw " & $seen
        seen = @[]
        var void1 = bindClosure(proc(a1: cint) =
                seen.add(a1))
        void1(1.cint)
        doAssert seen == @[1.cint],
                 "the 1-argument void closure saw " & $seen
        seen = @[]
        var void2 = bindClosure(proc(a1: cint, a2: cint) =
                seen.add(a1)
                seen.add(a2))
        void2(1.cint, 2.cint)
        doAssert seen == @[1.cint, 2.cint],
                 "the 2-argument void closure saw " & $seen
        seen = @[]
        var void3 = bindClosure(proc(a1: cint, a2: cint, a3: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3))
        void3(1.cint, 2.cint, 3.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint],
                 "the 3-argument void closure saw " & $seen
        seen = @[]
        var void4 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3)
                seen.add(a4))
        void4(1.cint, 2.cint, 3.cint, 4.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint, 4.cint],
                 "the 4-argument void closure saw " & $seen
        seen = @[]
        var void5 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3)
                seen.add(a4)
                seen.add(a5))
        void5(1.cint, 2.cint, 3.cint, 4.cint, 5.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint, 4.cint, 5.cint],
                 "the 5-argument void closure saw " & $seen
        seen = @[]
        var void6 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3)
                seen.add(a4)
                seen.add(a5)
                seen.add(a6))
        void6(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint],
                 "the 6-argument void closure saw " & $seen
        seen = @[]
        var void7 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint, a7: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3)
                seen.add(a4)
                seen.add(a5)
                seen.add(a6)
                seen.add(a7))
        void7(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint],
                 "the 7-argument void closure saw " & $seen
        seen = @[]
        var void8 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint, a7: cint, a8: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3)
                seen.add(a4)
                seen.add(a5)
                seen.add(a6)
                seen.add(a7)
                seen.add(a8))
        void8(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint],
                 "the 8-argument void closure saw " & $seen
        seen = @[]
        var void9 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint, a7: cint, a8: cint, a9: cint) =
                seen.add(a1)
                seen.add(a2)
                seen.add(a3)
                seen.add(a4)
                seen.add(a5)
                seen.add(a6)
                seen.add(a7)
                seen.add(a8)
                seen.add(a9))
        void9(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint, 9.cint)
        doAssert seen == @[1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint, 9.cint],
                 "the 9-argument void closure saw " & $seen
        var value0 = bindClosure(proc(): cint = 7.cint)
        doAssert value0() == 7.cint,
                 "the 0-argument closure returned " & $value0()
        var value1 = bindClosure(proc(a1: cint): cint = a1)
        doAssert value1(1.cint) == 1.cint,
                 "the 1-argument closure returned " & $value1(1.cint)
        var value2 = bindClosure(proc(a1: cint, a2: cint): cint = a1 + a2)
        doAssert value2(1.cint, 2.cint) == 3.cint,
                 "the 2-argument closure returned " & $value2(1.cint, 2.cint)
        var value3 = bindClosure(proc(a1: cint, a2: cint, a3: cint): cint = a1 + a2 + a3)
        doAssert value3(1.cint, 2.cint, 3.cint) == 6.cint,
                 "the 3-argument closure returned " & $value3(1.cint, 2.cint, 3.cint)
        var value4 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint): cint = a1 + a2 + a3 + a4)
        doAssert value4(1.cint, 2.cint, 3.cint, 4.cint) == 10.cint,
                 "the 4-argument closure returned " & $value4(1.cint, 2.cint, 3.cint, 4.cint)
        var value5 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint): cint = a1 + a2 + a3 + a4 + a5)
        doAssert value5(1.cint, 2.cint, 3.cint, 4.cint, 5.cint) == 15.cint,
                 "the 5-argument closure returned " & $value5(1.cint, 2.cint, 3.cint, 4.cint, 5.cint)
        var value6 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint): cint = a1 + a2 + a3 + a4 + a5 + a6)
        doAssert value6(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint) == 21.cint,
                 "the 6-argument closure returned " & $value6(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint)
        var value7 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint, a7: cint): cint = a1 + a2 + a3 + a4 + a5 + a6 + a7)
        doAssert value7(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint) == 28.cint,
                 "the 7-argument closure returned " & $value7(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint)
        var value8 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint, a7: cint, a8: cint): cint = a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8)
        doAssert value8(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint) == 36.cint,
                 "the 8-argument closure returned " & $value8(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint)
        var value9 = bindClosure(proc(a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint, a7: cint, a8: cint, a9: cint): cint = a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9)
        doAssert value9(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint, 9.cint) == 45.cint,
                 "the 9-argument closure returned " & $value9(1.cint, 2.cint, 3.cint, 4.cint, 5.cint, 6.cint, 7.cint, 8.cint, 9.cint)

testEveryClosureArity()

# The nested abstract classes =================================================
#
# The subclass generator keyed an abstract class on its own spelling, which
# never matched a declared Nim name for a nested one, so every Listener,
# LookAndFeelMethods and other nested interface was skipped with no withheld
# entry. Building each compiles the C++ class, and setting each handler is what
# type-checks and generates the setter.

proc testNestedSubclassesDataStructures() =

    block:
        var customValueListener = newCustomValueListener()
        doAssert not customValueListener.isNil(), "newCustomValueListener built nothing"
        customValueListener[].setValueChangedHandler(proc(value: ptr Value) = discard)
        cdelete customValueListener


testNestedSubclassesDataStructures()

# Every no-argument constructor ===============================================
#
# An importcpp string reaches the C++ compiler only at a call site, so a
# constructor nothing calls is never compiled. These had no caller.

proc testEveryNoArgConstructorDataStructures() =

    block:
        discard makeApplicationProperties()


testEveryNoArgConstructorDataStructures()

# Every bound constant ========================================================
#
# A `let` with an importcpp is not checked against C++ unless something reads
# it: a constant naming juce::NoSuchClass::nope compiles clean while nothing
# touches it. Reading each is what compiles the spelling.

proc testEveryConstantDataStructures() =
    block:
        discard PropertiesFileStorageFormat_storeAsBinary
        discard PropertiesFileStorageFormat_storeAsCompressedBinary
        discard PropertiesFileStorageFormat_storeAsXML

testEveryConstantDataStructures()

# ValueTree::Iterator =========================================================
#
# The C++ iterator behind the Nim one. Both ends of a two-child tree are built
# here, which is what the Nim iterator uses underneath.

proc testValueTreeIterator() =
    block:
        var tree = makeValueTree(makeIdentifier(makeString("root")))
        tree.addChild(makeValueTree(makeIdentifier(makeString("first"))), -1.cint, nil)
        tree.addChild(makeValueTree(makeIdentifier(makeString("second"))), -1.cint, nil)

        let start = makeValueTreeIterator(tree, false)
        let stop = makeValueTreeIterator(tree, true)
        doAssert start != stop, "the begin and end iterators of a filled tree are equal"

        let emptyTree = makeValueTree(makeIdentifier(makeString("empty")))
        doAssert makeValueTreeIterator(emptyTree, false) ==
                 makeValueTreeIterator(emptyTree, true),
                 "the begin and end iterators of an empty tree differ"

testValueTreeIterator()

# ChangeBroadcaster on PropertiesFile ==========================================
#
# PropertiesFile reaches ChangeBroadcaster through its second public base, so
# these six are not inherited - the generator restates them on the class, and a
# restatement nobody calls never reaches the C++ compiler.

proc testPropertiesFileBroadcasts() =
  initialiseJuce_GUI()

  let settings = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                     .getNonexistentChildFile(makeString("june-props"),
                                              makeString(".settings"))
  var options = makePropertiesFileOptions()
  var file = makePropertiesFile(settings, options)

  var changed = 0
  let listener = newCustomChangeListener()
  listener[].setChangeListenerCallbackHandler(
      proc(source: ptr ChangeBroadcaster) = changed += 1)

  file.addChangeListener(cast[ptr ChangeListener](listener))
  file.sendSynchronousChangeMessage()
  doAssert changed == 1,
           "the synchronous message reached the listener " & $changed & " times"

  file.sendChangeMessage()
  file.dispatchPendingMessages()
  doAssert changed == 2,
           "after dispatching, the listener has been called " & $changed & " times"

  file.removeChangeListener(cast[ptr ChangeListener](listener))
  file.sendSynchronousChangeMessage()
  doAssert changed == 2, "a removed listener was still called"

  file.addChangeListener(cast[ptr ChangeListener](listener))
  file.removeAllChangeListeners()
  file.sendSynchronousChangeMessage()
  doAssert changed == 2, "removeAllChangeListeners left one attached"

  cdelete listener
  discard settings.deleteFile()
  shutdownJuce_GUI()

testPropertiesFileBroadcasts()

# The actions in the current transaction =======================================
#
# getActionsInCurrentTransaction fills an Array<UndoableAction*>, and the
# pointer was dropped: it bound as Array[UndoableAction], an array of copies of
# an abstract class. Nothing called it.

proc testActionsInCurrentTransaction() =
  var manager = makeUndoManager(30000.cint, 30.cint)
  # Array<const UndoableAction*>, so ConstPtr rather than ptr: the const is
  # part of the C++ type and Array<T*> will not bind to Array<const T*>.
  var found = makeArray[ConstPtr[UndoableAction]]()

  manager.getActionsInCurrentTransaction(found)
  doAssert found.size() == 0,
           "a fresh manager reports " & $found.size() & " actions"

  var performed = 0
  let action = newCustomUndoableAction()
  action[].setPerformHandler(proc(): bool = performed += 1; true)
  action[].setUndoHandler(proc(): bool = true)

  manager.beginNewTransaction(makeString("one edit"))
  doAssert manager.perform(cast[ptr UndoableAction](action)),
           "the action did not perform"
  doAssert performed == 1, "the action ran " & $performed & " times"

  manager.getActionsInCurrentTransaction(found)
  doAssert found.size() == 1,
           "the transaction holds " & $found.size() & " actions"
  doAssert found[0] == cast[ptr UndoableAction](action),
           "the action in the transaction is not the one performed"

testActionsInCurrentTransaction()

# ValueTree's iterators yield exactly what the tree holds ======================
#
# Each is a hand-written loop over the indexed accessors. JUCE's own begin and
# end have no Nim spelling, so there is no second implementation to disagree
# with an off-by-one - the count has to be checked against the tree itself.

proc testValueTreeIteratorsAreComplete() =
  var tree = makeValueTree(makeIdentifier(makeString("root")))
  for index in 0 ..< 5:
    tree.addChild(makeValueTree(makeIdentifier(makeString("c" & $index))),
                  -1.cint, nil)
  for index in 0 ..< 4:
    discard tree.setProperty(makeIdentifier(makeString("p" & $index)),
                     makejuce_var(index.cint), nil)

  var children: seq[string] = @[]
  for child in tree:
    children.add($child.getType().toString())
  doAssert children.len == tree.getNumChildren().int,
           "items yielded " & $children.len & " of " & $tree.getNumChildren()
  for index in 0 ..< children.len:
    doAssert children[index] == $tree.getChild(index.cint).getType().toString(),
             "items yielded " & children[index] & " at " & $index

  var indexed: seq[int] = @[]
  for index, child in tree.pairs:
    indexed.add(index.int)
    doAssert $child.getType().toString() ==
             $tree.getChild(index).getType().toString(),
             "pairs yielded the wrong child at " & $index
  doAssert indexed.len == tree.getNumChildren().int,
           "pairs yielded " & $indexed.len & " of " & $tree.getNumChildren()
  doAssert indexed == @[0, 1, 2, 3, 4],
           "pairs yielded the indices " & $indexed

  var names: seq[string] = @[]
  for name, value in tree.properties:
    names.add($name.toString())
  doAssert names.len == tree.getNumProperties().int,
           "properties yielded " & $names.len & " of " & $tree.getNumProperties()
  for index in 0 ..< names.len:
    doAssert names[index] == $tree.getPropertyName(index.cint).toString(),
             "properties yielded " & names[index] & " at " & $index

testValueTreeIteratorsAreComplete()


# Every public field round-trips ===============================================
#
# A field getter and setter are importcpp procs like any other: they reach the
# C++ compiler only where something calls them, so a setter nothing assigns is
# never compiled. Each is set to a distinctive value and read back; where the
# field's type compares, the read is asserted against what went in.

proc testFieldRoundTrips() =
    block:
        var value = makePropertiesFileOptions()
        value.doNotSave = true
        doAssert value.doNotSave() == true,
                 "PropertiesFileOptions.doNotSave came back as " & $value.doNotSave()
        value.ignoreCaseOfKeyNames = true
        doAssert value.ignoreCaseOfKeyNames() == true,
                 "PropertiesFileOptions.ignoreCaseOfKeyNames came back as " & $value.ignoreCaseOfKeyNames()
        value.millisecondsBeforeSaving = 7.cint
        doAssert value.millisecondsBeforeSaving() == 7.cint,
                 "PropertiesFileOptions.millisecondsBeforeSaving came back as " & $value.millisecondsBeforeSaving()
        value.osxLibrarySubFolder = makeString("a value")
        discard value.osxLibrarySubFolder()
    block:
        var value = makeValueTreePropertyWithDefault()
        value.onDefaultChange = bindClosure(proc() = discard)
        discard value.onDefaultChange()

testFieldRoundTrips()

# ValueTree::Listener gives every method an empty body rather than making it
# pure, so no Custom subclass is generated and this constructor is the only way
# to get one. Building it is what compiles its importcpp.
proc testValueTreeListenerConstructs() =
  var listener = makeValueTreeListener()
  doAssert (addr listener) != nil, "the ValueTree listener did not build"

testValueTreeListenerConstructs()

# UndoManager groups actions into TRANSACTIONS, and that grouping is the whole
# of what it does beyond a stack: one undo reverses a transaction, not an
# action. Each action here counts its own calls, so the grouping is measured
# rather than assumed.
proc testUndoManagerTransactions() =
  proc countingAction(performed, undone: ptr int): ptr CustomUndoableAction =
    result = newCustomUndoableAction()
    let p = performed
    let u = undone
    result[].setPerformHandler(proc(): bool =
      p[] += 1
      true)
    result[].setUndoHandler(proc(): bool =
      u[] += 1
      true)

  block:
    var performed, undone = 0
    var manager = makeUndoManager(30000.cint, 30.cint)

    doAssert not manager.canUndo(), "a new manager can undo"
    doAssert not manager.canRedo(), "a new manager can redo"
    doAssert manager.getUndoDescription().isEmpty(),
             "a new manager describes an undo as " & $manager.getUndoDescription()
    doAssert not manager.isPerformingUndoRedo(),
             "a manager reports an undo in progress before anything ran"

    # Two actions in ONE transaction: one undo reverses both.
    manager.beginNewTransaction(makeString("edit"))
    doAssert manager.perform(cast[ptr UndoableAction](
                 countingAction(addr performed, addr undone))),
             "the first perform reported failure"
    doAssert manager.perform(cast[ptr UndoableAction](
                 countingAction(addr performed, addr undone))),
             "the second perform reported failure"
    doAssert performed == 2, "two actions ran " & $performed & " times"
    doAssert manager.getNumActionsInCurrentTransaction() == 2,
             "the transaction holds " &
             $manager.getNumActionsInCurrentTransaction() & " actions"

    doAssert manager.canUndo(), "the manager cannot undo after two actions"
    doAssert $manager.getUndoDescription() == "edit",
             "the undo describes itself as " & $manager.getUndoDescription()
    doAssert manager.getUndoDescriptions().size() == 1,
             "there are " & $manager.getUndoDescriptions().size() &
             " transactions to undo, not one"

    doAssert manager.undo(), "undo reported failure"
    doAssert undone == 2,
             "one undo reversed " & $undone & " of the two actions"
    doAssert not manager.canUndo(), "the manager can still undo"
    doAssert manager.canRedo(), "the manager cannot redo what it just undid"
    doAssert $manager.getRedoDescription() == "edit",
             "the redo describes itself as " & $manager.getRedoDescription()
    doAssert manager.getRedoDescriptions().size() == 1,
             "there are " & $manager.getRedoDescriptions().size() &
             " transactions to redo"

    doAssert manager.redo(), "redo reported failure"
    doAssert performed == 4, "the redo re-ran " & $(performed - 2) & " actions"

  block:
    var performed, undone = 0
    var manager = makeUndoManager(30000.cint, 30.cint)

    # Two SEPARATE transactions: each undo reverses one.
    manager.beginNewTransaction(makeString("first"))
    discard manager.perform(cast[ptr UndoableAction](
        countingAction(addr performed, addr undone)))
    manager.beginNewTransaction(makeString("second"))
    discard manager.perform(cast[ptr UndoableAction](
        countingAction(addr performed, addr undone)))

    doAssert manager.getUndoDescriptions().size() == 2,
             "there are " & $manager.getUndoDescriptions().size() &
             " transactions, not two"
    doAssert $manager.getUndoDescription() == "second",
             "the newest transaction is " & $manager.getUndoDescription()

    doAssert manager.undo(), "the first undo reported failure"
    doAssert undone == 1,
             "one undo reversed " & $undone & " actions across two transactions"
    doAssert $manager.getUndoDescription() == "first",
             "after one undo the next is " & $manager.getUndoDescription()
    doAssert manager.undo(), "the second undo reported failure"
    doAssert undone == 2, "two undos reversed " & $undone & " actions"
    doAssert not manager.canUndo(), "there is a third transaction"

  block:
    var performed, undone = 0
    var manager = makeUndoManager(30000.cint, 30.cint)

    # The transaction can be named after the fact, and undone on its own
    # without ending it.
    manager.beginNewTransaction()
    discard manager.perform(cast[ptr UndoableAction](
        countingAction(addr performed, addr undone)))
    manager.setCurrentTransactionName(makeString("renamed"))
    doAssert $manager.getCurrentTransactionName() == "renamed",
             "the transaction is called " & $manager.getCurrentTransactionName()

    doAssert manager.undoCurrentTransactionOnly(),
             "undoCurrentTransactionOnly reported failure"
    doAssert undone == 1,
             "undoCurrentTransactionOnly reversed " & $undone & " actions"
    doAssert manager.getNumActionsInCurrentTransaction() == 0,
             "the transaction still holds " &
             $manager.getNumActionsInCurrentTransaction() & " actions"

  block:
    var performed, undone = 0
    var manager = makeUndoManager(30000.cint, 30.cint)
    manager.beginNewTransaction(makeString("edit"))
    discard manager.perform(cast[ptr UndoableAction](
        countingAction(addr performed, addr undone)))

    doAssert manager.getNumberOfUnitsTakenUpByStoredCommands() >= 0,
             "the stored commands take up " &
             $manager.getNumberOfUnitsTakenUpByStoredCommands() & " units"
    doAssert manager.getTimeOfUndoTransaction().toMilliseconds() > 0,
             "the transaction has no timestamp"

    # Clearing throws the history away without undoing anything.
    manager.clearUndoHistory()
    doAssert not manager.canUndo(), "the history survived clearUndoHistory"
    doAssert undone == 0,
             "clearUndoHistory undid " & $undone & " actions"

    # And a new limit is accepted at any time.
    manager.setMaxNumberOfStoredUnits(100.cint, 2.cint)

testUndoManagerTransactions()

# ValueTree's navigation and its copying. A tree is a handle onto shared state,
# so an assignment shares and createCopy does not - the same distinction Image
# has, and the one a caller gets wrong.
proc testValueTreeNavigationAndCopies() =
  block:
    var root = makeValueTree(makeIdentifier("root"))
    doAssert root.hasType(makeIdentifier("root")),
             "the tree does not have the type it was made with"
    doAssert not root.hasType(makeIdentifier("other")),
             "the tree has a type it was never given"

    var first = makeValueTree(makeIdentifier("child"))
    discard first.setProperty(makeIdentifier("name"), makejuce_var(makeString("first")),
                      nil)
    var second = makeValueTree(makeIdentifier("child"))
    discard second.setProperty(makeIdentifier("name"),
                       makejuce_var(makeString("second")), nil)
    var other = makeValueTree(makeIdentifier("different"))

    root.appendChild(first, nil)
    root.appendChild(second, nil)
    root.appendChild(other, nil)
    doAssert root.getNumChildren() == 3,
             "the root holds " & $root.getNumChildren() & " children"

    # getParent walks back up, and the root has none.
    doAssert first.getParent() == root,
             "the child's parent is not the root"
    doAssert not root.getParent().isValid(),
             "the root has a parent"

    # getSibling walks the child list by an offset from this child.
    doAssert first.getSibling(1.cint) == second,
             "the next sibling of the first child is not the second"
    doAssert second.getSibling(-1.cint) == first,
             "the previous sibling of the second child is not the first"
    doAssert not first.getSibling(-1.cint).isValid(),
             "the first child has a previous sibling"
    doAssert not other.getSibling(1.cint).isValid(),
             "the last child has a next sibling"

    # getChildWithName finds the FIRST child of that type, and
    # getChildWithProperty finds by a value rather than a type.
    doAssert root.getChildWithName(makeIdentifier("child")) == first,
             "getChildWithName found a different child"
    doAssert not root.getChildWithName(makeIdentifier("absent")).isValid(),
             "getChildWithName invented a child"
    doAssert root.getChildWithProperty(makeIdentifier("name"),
                                       makejuce_var(makeString("second"))) ==
             second,
             "getChildWithProperty found a different child"
    doAssert not root.getChildWithProperty(
                 makeIdentifier("name"),
                 makejuce_var(makeString("absent"))).isValid(),
             "getChildWithProperty invented a child"

    # getOrCreateChildWithName returns the existing one rather than adding a
    # second, and adds one when there is none.
    doAssert root.getOrCreateChildWithName(makeIdentifier("child"), nil) == first,
             "getOrCreateChildWithName added a second child of an existing type"
    doAssert root.getNumChildren() == 3,
             "the root holds " & $root.getNumChildren() & " children after the " &
             "existing one was asked for"
    let created = root.getOrCreateChildWithName(makeIdentifier("fresh"), nil)
    doAssert created.isValid(), "getOrCreateChildWithName created nothing"
    doAssert root.getNumChildren() == 4,
             "the root holds " & $root.getNumChildren() & " children after one " &
             "was created"

    # moveChild reorders without adding or removing.
    root.moveChild(0.cint, 2.cint, nil)
    doAssert root.getChild(2.cint) == first,
             "the moved child is at index " & $root.indexOf(first)
    doAssert root.getNumChildren() == 4,
             "moving a child changed the count to " & $root.getNumChildren()

  block:
    # A tree is a handle onto shared state. An assignment shares it.
    var original = makeValueTree(makeIdentifier("root"))
    discard original.setProperty(makeIdentifier("value"), makejuce_var(1.cint), nil)

    var shared = original
    discard shared.setProperty(makeIdentifier("value"), makejuce_var(2.cint), nil)
    doAssert original.getProperty(makeIdentifier("value")).toInt() == 2,
             "writing through the shared handle did not reach the original"

    # createCopy is a deep copy: neither the properties nor the children are
    # shared afterwards.
    original.appendChild(makeValueTree(makeIdentifier("child")), nil)
    var copied = original.createCopy()
    doAssert copied.getNumChildren() == 1,
             "the copy holds " & $copied.getNumChildren() & " children"
    discard copied.setProperty(makeIdentifier("value"), makejuce_var(9.cint), nil)
    doAssert original.getProperty(makeIdentifier("value")).toInt() == 2,
             "writing to the copy reached the original"

    var copiedChild = copied.getChild(0.cint)
    discard copiedChild.setProperty(makeIdentifier("deep"),
                                    makejuce_var(1.cint), nil)
    doAssert not original.getChild(0.cint).hasProperty(makeIdentifier("deep")),
             "writing to the copy's child reached the original's child"

  block:
    # The property-copying methods differ in whether they bring the children.
    var source = makeValueTree(makeIdentifier("source"))
    discard source.setProperty(makeIdentifier("a"), makejuce_var(1.cint), nil)
    source.appendChild(makeValueTree(makeIdentifier("child")), nil)

    var propertiesOnly = makeValueTree(makeIdentifier("target"))
    propertiesOnly.copyPropertiesFrom(source, nil)
    doAssert propertiesOnly.getProperty(makeIdentifier("a")).toInt() == 1,
             "copyPropertiesFrom did not bring the property"
    doAssert propertiesOnly.getNumChildren() == 0,
             "copyPropertiesFrom brought " & $propertiesOnly.getNumChildren() &
             " children"

    var everything = makeValueTree(makeIdentifier("target"))
    everything.copyPropertiesAndChildrenFrom(source, nil)
    doAssert everything.getProperty(makeIdentifier("a")).toInt() == 1,
             "copyPropertiesAndChildrenFrom did not bring the property"
    doAssert everything.getNumChildren() == 1,
             "copyPropertiesAndChildrenFrom brought " &
             $everything.getNumChildren() & " children"

    # And removeAllProperties leaves the children alone, which is the mirror
    # of copyPropertiesFrom.
    everything.removeAllProperties(nil)
    doAssert everything.getNumProperties() == 0,
             "removeAllProperties left " & $everything.getNumProperties()
    doAssert everything.getNumChildren() == 1,
             "removeAllProperties removed a child too"

  block:
    # A property is also reachable as a Value, which is a view of the same
    # storage rather than a copy of it.
    var tree = makeValueTree(makeIdentifier("root"))
    discard tree.setProperty(makeIdentifier("value"), makejuce_var(5.cint), nil)

    var asValue = tree.getPropertyAsValue(makeIdentifier("value"), nil, false)
    doAssert asValue.getValue().toInt() == 5,
             "the value reads " & $asValue.getValue().toInt()
    asValue.setValue(makejuce_var(7.cint))
    doAssert tree.getProperty(makeIdentifier("value")).toInt() == 7,
             "writing through the Value did not reach the tree; it holds " &
             $tree.getProperty(makeIdentifier("value")).toInt()

    # setPropertyExcludingListener writes the same way; the exclusion only
    # decides who is told.
    discard tree.setPropertyExcludingListener(nil, makeIdentifier("value"),
                                      makejuce_var(11.cint), nil)
    doAssert tree.getProperty(makeIdentifier("value")).toInt() == 11,
             "the excluding setter left " &
             $tree.getProperty(makeIdentifier("value")).toInt()
    tree.sendPropertyChangeMessage(makeIdentifier("value"))

  block:
    # A tree round trips through its own XML string.
    var tree = makeValueTree(makeIdentifier("settings"))
    discard tree.setProperty(makeIdentifier("volume"), makejuce_var(11.cint), nil)
    tree.appendChild(makeValueTree(makeIdentifier("window")), nil)

    let text = tree.toXmlString(makeXmlElementTextFormat())
    doAssert text.isNotEmpty(), "toXmlString gave nothing"
    doAssert ($text).contains("settings"),
             "the XML does not name the tree: " & $text

    let rebuilt = ValueTree.fromXml(makeString($text))
    doAssert rebuilt.hasType(makeIdentifier("settings")),
             "the round trip changed the type"
    doAssert rebuilt.getProperty(makeIdentifier("volume")).toInt() == 11,
             "the round trip lost the property"
    doAssert rebuilt.getNumChildren() == 1,
             "the round trip left " & $rebuilt.getNumChildren() & " children"

testValueTreeNavigationAndCopies()

# PropertiesFile's saving and reloading =======================================

proc testPropertiesFileSaving() =
  initialiseJuce_GUI()

  let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                 .getNonexistentChildFile(makeString("june-props-save"),
                                          makeString(""))
  doAssert root.createDirectory().wasOk(), "could not make the temp directory"
  defer: discard root.deleteRecursively(false)

  block:
    let settings = root.getChildFile(makeStringRef("settings.xml"))
    var options = makePropertiesFileOptions()
    options.storageFormat = PropertiesFileStorageFormat_storeAsXML
    var file = makePropertiesFile(settings, options)

    doAssert file.getFile() == settings,
             "the properties file writes to " &
             $file.getFile().getFullPathName()

    # A file that does not exist yet still loaded fine: reload treats a
    # missing file as an empty one (juce_PropertiesFile.cpp: reload).
    doAssert file.isValidFile(), "a properties file over a new path is invalid"
    doAssert not file.needsToBeSaved(),
             "a fresh properties file already needs saving"

    # Setting a value marks it dirty, and saving clears that and writes the
    # file out.
    file.setValue("colour", makejuce_var(makeString("red")))
    doAssert file.needsToBeSaved(),
             "setting a value did not mark the file dirty"
    doAssert not settings.existsAsFile(),
             "the file was written before anything asked it to be"

    doAssert file.save(), "the properties file did not save"
    doAssert settings.existsAsFile(), "saving wrote no file"
    doAssert not file.needsToBeSaved(), "saving left the file dirty"
    doAssert "colour" in $settings.loadFileAsString(),
             "the saved file does not mention the key"

    # saveIfNeeded is a no-op when nothing changed, and saves when something
    # did (juce_PropertiesFile.cpp: saveIfNeeded).
    let unchanged = settings.getLastModificationTime().toMilliseconds()
    doAssert file.saveIfNeeded(), "saveIfNeeded reported failure"
    file.setValue("size", makejuce_var(12.cint))
    doAssert file.saveIfNeeded(), "saveIfNeeded did not save the change"
    doAssert "size" in $settings.loadFileAsString(),
             "the second key never reached the file"
    discard unchanged

    # setNeedsToBeSaved forces the flag either way, which is how a caller
    # tells the file that something outside it changed.
    file.setNeedsToBeSaved(true)
    doAssert file.needsToBeSaved(), "setNeedsToBeSaved(true) did not stick"
    file.setNeedsToBeSaved(false)
    doAssert not file.needsToBeSaved(), "setNeedsToBeSaved(false) did not stick"

    # And reload reads the file back, so a value removed in memory comes back.
    file.removeValue("colour")
    doAssert not file.containsKey("colour"), "removeValue left the key"
    doAssert file.reload(), "the properties file did not reload"
    doAssert file.containsKey("colour"),
             "reloading did not bring the saved key back"
    doAssert $file.getValue("colour", makeString("none")) == "red",
             "the reloaded colour is " &
             $file.getValue("colour", makeString("none"))

  block:
    # A file whose options say never to save reports failure from save
    # (juce_PropertiesFile.cpp: save returns false on doNotSave), and so does
    # one whose path is a directory.
    let settings = root.getChildFile(makeStringRef("unsaved.xml"))
    var options = makePropertiesFileOptions()
    options.doNotSave = true
    var file = makePropertiesFile(settings, options)
    file.setValue("key", makejuce_var(1.cint))
    doAssert not file.save(), "a file told not to save saved anyway"
    doAssert not settings.existsAsFile(), "a file told not to save wrote one"

    var directoryOptions = makePropertiesFileOptions()
    var overADirectory = makePropertiesFile(root, directoryOptions)
    doAssert not overADirectory.save(),
             "a properties file over a directory saved"

  block:
    # The binary formats round-trip as well as the XML one does.
    for format in [PropertiesFileStorageFormat_storeAsBinary,
                   PropertiesFileStorageFormat_storeAsCompressedBinary]:
      let settings = root.getNonexistentChildFile(makeString("binary"),
                                                  makeString(".settings"))
      var options = makePropertiesFileOptions()
      options.storageFormat = format
      var file = makePropertiesFile(settings, options)
      file.setValue("name", makejuce_var(makeString("june")))
      doAssert file.save(), "the binary properties file did not save"

      var reopened = makePropertiesFile(settings, options)
      doAssert reopened.isValidFile(), "the saved binary file is not valid"
      doAssert $reopened.getValue("name", makeString("none")) == "june",
               "the reopened file holds " &
               $reopened.getValue("name", makeString("none"))

  shutdownJuce_GUI()

testPropertiesFileSaving()

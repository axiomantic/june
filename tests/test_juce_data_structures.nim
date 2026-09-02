
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
        cdelete synchroniser

testRemainingDataStructuresSubclasses()

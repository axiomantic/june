
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


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

  discard tree.setProperty(colourId, makejuce_var(0xff0000), nil)
  discard tree.setProperty(sizeId, makejuce_var(42), nil)
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

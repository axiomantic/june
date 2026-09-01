
import june

# String tests ================================================================
var w = makeString("abcdef")
w = w.replaceCharacters("ad", "xy")
doAssert w == "xbcyef"
doAssert $w == "xbcyef"

# StringArray tests ===========================================================
var sa = StringArray()
doAssert sa.size() == 0
discard sa.addIfNotAlreadyThere("abcdef")
doAssert sa.size() == 1

# MemoryBlock tests ===========================================================
var mb = MemoryBlock()
doAssert mb.getSize() == 0
mb.setSize(1000)
doAssert mb.getSize() == 1000
mb.reset()
doAssert mb.getSize() == 0

var mb2 = MemoryBlock()
mb2.setSize(100)
mb2.fillWith(1'u8)
mb = mb2
doAssert mb == mb2

let data = cast[ptr UncheckedArray[uint8]](mb2.getData())
doAssert data[0] == 1'u8

# std::unique_ptr against a real JUCE API. File.createInputStream returns one,
# so this is the binding a caller actually meets rather than a synthetic case.
import std/[os, times]

proc testUniquePtr() =
  let path = getTempDir() / ("june_stream_" & $epochTime().int & ".txt")
  writeFile(path, "hello from june")
  defer: removeFile(path)

  let file = makeFile(toJuceString(path))
  doAssert file.existsAsFile()
  doAssert file.getSize() == 15

  let stream = file.createInputStream()
  doAssert not stream.isNil()
  doAssert stream.get()[].getTotalLength() == 15
  doAssert $file.loadFileAsString() == "hello from june"

  # Copying a UniquePtr is rejected by =copy, and moving it is allowed. That is
  # not asserted here: inside `compiles` the compiler moves rather than copies,
  # so the check would pass for the wrong reason.

testUniquePtr()

proc testNormalisableRange() =
  # How a Slider describes its range: a value mapped onto 0..1.
  let range = makeNormalisableRange(0.0, 100.0)
  doAssert range.convertTo0to1(50.0) == 0.5
  doAssert range.convertFrom0to1(0.25) == 25.0
  doAssert range.getRange().getStart() == 0.0
  doAssert range.getRange().getEnd() == 100.0

testNormalisableRange()

proc testOperators() =
  # Operators used to be mangled into names like `Colour==`, which is a legal
  # identifier and useless. Bound as operators, != > and >= come free: Nim
  # derives them, which is why they are deliberately not bound.
  let a = makeIdentifier("alpha")
  let b = makeIdentifier("alpha")
  let c = makeIdentifier("beta")
  doAssert a == b
  doAssert a != c

  let first = makeRange(0.cint, 10.cint)
  let same = makeRange(0.cint, 10.cint)
  let other = makeRange(5.cint, 20.cint)
  doAssert first == same
  doAssert first != other

  let text = makeString("abc")
  doAssert text == makeString("abc")
  doAssert text != makeString("xyz")

testOperators()

proc testDollar() =
  # Nim's default $ prints "()" for these: an importcpp object declares no
  # fields, so there is nothing for it to show. Where JUCE has a toString, $
  # uses it.
  doAssert $makeIdentifier("colour") == "colour"
  doAssert $makejuce_var(42.cint) == "42"
  doAssert $makeString("hello") == "hello"
  doAssert ($makeUuid()).len == 32

testDollar()


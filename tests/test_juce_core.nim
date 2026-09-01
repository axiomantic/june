
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

proc testStdString() =
  # String.toStdString is the usual way out to another C++ library, and had no
  # binding because std::string had no spelling.
  let text = makeString("hello world")
  let asStd = text.toStdString()
  doAssert asStd.len == 11
  doAssert not asStd.isEmpty()
  doAssert $asStd == "hello world"
  doAssert $makeString(asStd) == "hello world"

testStdString()


# The generator comments out every operator!=, operator> and operator>= it
# finds, which reads like 82 missing bindings. Nim derives all three from
# operator==, operator< and operator<= through templates in system, so they are
# already usable. This asserts that, rather than leaving it to be rediscovered.
proc testDerivedComparisonOperators() =
  let a = makeString("alpha")
  let b = makeString("beta")

  doAssert a == a
  doAssert a != b            # derived from `==`
  doAssert not (a != a)

  doAssert a < b
  doAssert b > a             # derived from `<`
  doAssert not (a > b)

  let identifierA = makeIdentifier("alpha")
  doAssert identifierA <= makeStringRef(b)
  doAssert makeStringRef(b) >= identifierA   # derived from `<=`

testDerivedComparisonOperators()

# Compound assignment used to be bound as `String+=`, a legal Nim identifier
# that cannot be written as an operator. The point of binding one is to write
# a += b, so this is the assertion that the spelling is usable.
proc testCompoundAssignment() =
  var text = makeString("ab")
  text += makeString("cd")
  doAssert $text == "abcd"

  text += "ef"
  doAssert $text == "abcdef"

  # C++ returns a reference to the target and Nim's form is a statement, so the
  # binding returns nothing. Chaining it is a compile error, not a silent no-op.
  doAssert typeof(text += makeString("x")) is void

  var bits = makeBigInteger(0b1100.cint)
  bits |= makeBigInteger(0b0011.cint)
  doAssert bits.toInteger() == 0b1111

testCompoundAssignment()

# juce::var is bound as juce_var because `var` is a Nim keyword. The rename was
# applied to class names but not inside a template argument, so these signatures
# were spelled Array[var] and Span[var]. Calling one is what proves the type is
# nameable; the declaration alone was tolerated.
proc testVarArrayTypes() =
  let number = makejuce_var(42.cint)
  doAssert number.getArray() == nil, "a number is not an array"
  doAssert number.isInt()

  var elements: Span[juce_var] = number.getArrayElements()
  doAssert elements.isEmpty()
  doAssert elements.size() == 0.csize_t

testVarArrayTypes()

# The container loops. Without these a caller writes the index loop by hand,
# because JUCE's begin() and end() have no Nim spelling.
proc testContainerIteration() =
  var names = makeStringArray()
  names.add(makeString("alpha"))
  names.add(makeString("beta"))

  var seen: seq[string] = @[]
  for name in names:
    seen.add($name)
  doAssert seen == @["alpha", "beta"], "iterated " & $seen

  var settings = makeNamedValueSet()
  discard settings.set(makeIdentifier("width"), makejuce_var(320.cint))
  discard settings.set(makeIdentifier("height"), makejuce_var(240.cint))

  var keys: seq[string] = @[]
  for name, value in settings:
    keys.add($name.toString())
  doAssert keys == @["width", "height"], "keys " & $keys

  var document = makeXmlElement(makeString("root"))
  document.addChildElement(cnew makeXmlElement(makeString("first")))
  document.addChildElement(cnew makeXmlElement(makeString("second")))

  var tags: seq[string] = @[]
  for child in document:
    tags.add($child[].getTagName())
  doAssert tags == @["first", "second"], "tags " & $tags

testContainerIteration()

# BigInteger's bitwise and shift operators. Nim spells shifts `shl` and `shr`,
# so those two are bound under the Nim name rather than the C++ one.
proc testBigIntegerOperators() =
  let a = makeBigInteger(0b1100.cint)
  let b = makeBigInteger(0b1010.cint)

  doAssert (a | b).toInteger() == 0b1110
  doAssert (a & b).toInteger() == 0b1000
  doAssert (a ^ b).toInteger() == 0b0110
  doAssert (a shl 2.cint).toInteger() == 0b110000
  doAssert (a shr 2.cint).toInteger() == 0b11

testBigIntegerOperators()

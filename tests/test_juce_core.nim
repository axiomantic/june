
import std/os

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

# The std:: containers JUCE exposes on its own interfaces. Without these the
# four procs that take or return one were unusable.
proc testStlContainers() =
  var headers = makeCppMap[String, String]()
  headers[makeString("accept")] = makeString("text/plain")
  doAssert headers.size() == 1.csize_t
  doAssert headers.contains(makeString("accept"))
  doAssert $headers[makeString("accept")] == "text/plain"

  var pairs = makeStringPairArray(true)
  pairs.addMap(headers)
  # The key parameter is a StringRef and the literal reaches it by converter,
  # which is the reason the generator keeps both of StringRef's own
  # constructors rather than choosing one.
  doAssert $pairs.getValue("accept", makeString("")) == "text/plain"

  var unordered = makeCppUnorderedMap[String, String]()
  unordered[makeString("host")] = makeString("localhost")
  doAssert unordered.size() == 1.csize_t
  doAssert unordered.contains(makeString("host"))
  pairs.addUnorderedMap(unordered)
  doAssert $pairs.getValue("host", makeString("")) == "localhost"

  var fifo = makeSingleThreadedAbstractFifo(8.cint)
  let ranges = fifo.write(3.cint)
  doAssert ranges.len() == 2
  var total = 0
  for range in ranges:
    total += range.getLength()
  doAssert total == 3, "the two ranges should cover the three written slots"

testStlContainers()

# Running a Nim closure on a JUCE thread pool. addJob takes a
# std::function returning a JobStatus, whose return type is nested inside
# ThreadPoolJob, so the binding was previously a comment.
proc testThreadPoolJob() =
  var pool = makeThreadPool()
  var ran = 0

  let job: CppFunctionObjectR0[ThreadPoolJobJobStatus] = bindClosure(
    proc(): ThreadPoolJobJobStatus =
      ran += 1
      ThreadPoolJobJobStatus_jobHasFinished)
  pool.addJob(job)

  # addJob queues the job. removeAllJobs drops one that has not started yet, so
  # waiting for the pool to drain can return before the body ever runs -- which
  # it did, on a slower scheduler. Wait for the job itself.
  var waitedMs = 0
  while ran == 0 and waitedMs < 10_000:
    sleep(10)
    waitedMs += 10

  doAssert ran == 1, "the job body ran " & $ran & " times after " & $waitedMs & "ms"
  discard pool.removeAllJobs(true, 2000.cint)

testThreadPoolJob()

# The generic container iterators. Each one is a hand-written loop over the
# indexed accessors, so nothing else would catch it going wrong.
proc testGenericContainerIteration() =
  var numbers: Array[cint]
  numbers.add(10.cint)
  numbers.add(20.cint)
  numbers.add(30.cint)

  var summed = 0
  for value in numbers:
    summed += value
  doAssert summed == 60, "Array iteration summed " & $summed

  # A Span comes from JUCE rather than being built in Nim: a juce::var holding
  # an array hands one out.
  var elements: Array[juce_var]
  elements.add(makejuce_var(1.cint))
  elements.add(makejuce_var(2.cint))
  let arrayVar = makejuce_var(elements)

  var spanned = 0
  for element in arrayVar.getArrayElements():
    spanned += 1
  doAssert spanned == 2, "Span iteration saw " & $spanned & " elements"

testGenericContainerIteration()

# Two JUCE overloads can differ only in the parameter name -- String(int64
# largeIntegerValue) and String(int64 decimalInteger) -- and both used to be
# emitted, which made every call matching them ambiguous and so uncallable.
proc testNoDuplicateOverloads() =
  doAssert compiles(makeString(5'i64))
  doAssert compiles(makeString(5'u64))
  doAssert $makeString(5'i64) == "5"

  doAssert compiles(makejuce_var(makeString("x")))
  doAssert makejuce_var(makeString("x")).isString()

testNoDuplicateOverloads()

# A Nim string reaches String, StringRef and constChar by three separate
# converters, so an overload set taking more than one of them can be ambiguous.
# Nim 2 resolves these and Nim 1.6 is stricter, which is why they are asserted
# here rather than reasoned about: the 1.6 jobs are what answers the question.
proc testStringLiteralOverloadResolution() =
  let greeting = makeString("Hello")
  doAssert greeting.equalsIgnoreCase("hello")
  doAssert greeting.compare("Hello") == 0

  var pool = makeStringPool()
  doAssert $pool.getPooledString("x") == "x"

  # StringRef keeps its own overload rather than the String one: there is a
  # converter from String to StringRef but none the other way, so dropping it
  # would leave no way to compare two StringRefs.
  doAssert makeStringRef(greeting) == makeStringRef(greeting)
  doAssert makeStringRef(greeting) == makeString("Hello")

testStringLiteralOverloadResolution()

# The equality guards. A JUCE class with no operator== gets a `==` that is a
# compile error naming the type, because Nim would otherwise compare the
# importcpp object structurally -- and those declare no fields, so every two
# values compared equal. Three hundred of them are generated and none of it is
# observable at run time, so this is the only thing that would notice the
# generator ceasing to emit them.
proc testEqualityGuards() =
  var first = makeFileSearchPath()
  var second = makeFileSearchPath()
  doAssert not compiles(first == second)

  # A class JUCE does give an operator== still compares.
  doAssert makeString("x") == makeString("x")
  doAssert makeRange(0.cint, 10.cint) == makeRange(0.cint, 10.cint)
  doAssert not (makeRange(0.cint, 10.cint) == makeRange(5.cint, 20.cint))

testEqualityGuards()

# Attaching a Nim closure to a DynamicObject as a method. The parameter is a
# std::function over var::NativeFunctionArgs, a nested name libclang prints
# unqualified, so this binding was a comment until that name resolved.
proc testDynamicObjectMethod() =
  # Heap-allocated because a var holds the object by reference-counted pointer.
  let obj = cnew(makeDynamicObject())

  # bindConstRefClosure rather than bindClosure: JUCE takes this one by const
  # reference, and NativeFunctionArgs holds a reference member, so a
  # std::function over it by value does not compile at all.
  let answer: CppFunctionObjectR1Ref[juce_var, juce_varNativeFunctionArgs] =
    bindConstRefClosure(proc(args: ptr juce_varNativeFunctionArgs): juce_var =
      makejuce_var(7.cint))

  doAssert not obj[].hasMethod(makeIdentifier("answer"))
  obj[].setMethod(makeIdentifier("answer"), answer)
  doAssert obj[].hasMethod(makeIdentifier("answer"))

  # And the closure is what JUCE calls: wrap the object in a var and invoke the
  # method through it, the way a script would.
  let asVar = makejuce_var(cast[ptr ReferenceCountedObject](obj))
  doAssert asVar.isObject()
  let returned = asVar.call(makeIdentifier("answer"))
  doAssert $returned.toString() == "7", "the method returned " & $returned.toString()

testDynamicObjectMethod()

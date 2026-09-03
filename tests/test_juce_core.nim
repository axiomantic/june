
import std/os
import std/strutils

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

  document.setAttribute(makeIdentifier("id"), makeString("root-1"))
  document.setAttribute(makeIdentifier("lang"), makeString("en"))
  var attributes: seq[string] = @[]
  for name, value in document.attributes():
    attributes.add($name & "=" & $value)
  doAssert attributes == @["id=root-1", "lang=en"], "attributes " & $attributes

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

  # bindEnumClosure, not bindClosure: the closure returns the base scalar so
  # that no Nim closure type names ThreadPoolJob::JobStatus, which is a
  # distinct cint. Nim renders one closure struct for that and for
  # `proc(): cint`, and a program holding both assigns a function pointer of
  # the wrong type.
  let job: CppFunctionObjectR0[ThreadPoolJobJobStatus] =
    bindEnumClosure[ThreadPoolJobJobStatus](
    proc(): cint =
      ran += 1
      cint(ThreadPoolJobJobStatus_jobHasFinished))
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
  # Only the u64 form is asserted with `compiles`: nothing else in the suite
  # calls it, so this is what checks that overload resolves. The i64 form is
  # called outright below, which checks the same thing more strongly.
  doAssert compiles(makeString(5'u64))
  doAssert $makeString(5'i64) == "5"

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

# JUCE declares String's + and == as free functions, and free functions were
# collected and then discarded, so concatenating two Strings was not possible.
proc testFreeFunctionOperators() =
  let greeting = makeString("Hello, ") + makeString("world")
  doAssert $greeting == "Hello, world", "concatenation gave " & $greeting

  doAssert makeString("a") == makeString("a")
  doAssert not (makeString("a") == makeString("b"))
  doAssert makeString("a") != makeString("b")

  # And a plain free function, which had no binding at all.
  doAssert countNumberOfBits(0b1011'u32) == 3
  doAssert findHighestSetBit(0b1000'u32) == 3

testFreeFunctionOperators()

# SystemStats::CrashHandlerFunction is a plain C++ function pointer, so the
# generator cannot spell it and the binding is hand-written. There is no way to
# fire a crash from a test, so this checks the handler installs.
proc onCrash(platformSpecificData: pointer) {.cdecl.} = discard

proc testCrashHandlerBinding() =
  # Called outright. A `compiles` assertion on the same expression could not
  # fail: the call above has to compile for this file to build at all.
  SystemStats.setApplicationCrashHandler(onCrash)

testCrashHandlerBinding()

# A conversion operator was not bound at all, which left juce::var with no way
# out but toString: the int, the double and the bool it holds were unreachable.
proc testConversionOperators() =
  let number = makejuce_var(42.cint)
  doAssert number.toInt() == 42, "the int came back as " & $number.toInt()
  doAssert number.toInt64() == 42'i64
  doAssert number.toBool()

  let fraction = makejuce_var(2.5'f64)
  doAssert fraction.toFloat64() == 2.5'f64, "the double came back as " & $fraction.toFloat64()
  doAssert fraction.toInt() == 2, "truncation gave " & $fraction.toInt()

  doAssert not makejuce_var(0.cint).toBool()

  # Result converts to bool, which is how a caller checks one.
  doAssert Result.ok().toBool()
  doAssert not Result.fail(makeString("no")).toBool()

testConversionOperators()

# A C++ function template becomes a Nim generic and the C++ compiler deduces
# the argument from the call. These are JUCE's own maths helpers, which had no
# binding because a FUNCTION_TEMPLATE is not a FUNCTION_DECL.
proc testFunctionTemplates() =
  doAssert jlimit(0.cint, 10.cint, 42.cint) == 10, "jlimit gave " & $jlimit(0.cint, 10.cint, 42.cint)
  doAssert jlimit(0.cint, 10.cint, -5.cint) == 0
  doAssert jlimit(0.0'f32, 1.0'f32, 0.5'f32) == 0.5'f32

  doAssert jmax(3.cint, 7.cint) == 7
  doAssert jmin(3.cint, 7.cint) == 3
  doAssert jmax(1.cint, 9.cint, 4.cint) == 9

  # jmap rescales from one range onto another.
  doAssert jmap(0.5'f64, 0.0'f64, 1.0'f64, 0.0'f64, 100.0'f64) == 50.0'f64

  doAssert degreesToRadians(180.0'f64) > 3.14'f64
  doAssert degreesToRadians(180.0'f64) < 3.15'f64
  doAssert radiansToDegrees(degreesToRadians(90.0'f64)) > 89.9'f64

  doAssert exactlyEqual(1.0'f64, 1.0'f64)
  doAssert not exactlyEqual(1.0'f64, 1.5'f64)

testFunctionTemplates()

# XmlElement is 56 bound procs and had only its attribute iterator covered.
# Round-tripping through the parser exercises the whole path: build, serialise,
# parse back, and read the same values out.
proc testXmlRoundTrip() =
  var root = makeXmlElement(makeString("settings"))
  root.setAttribute(makeIdentifier("version"), makeString("2"))
  root.setAttribute(makeIdentifier("name"), makeString("june"))

  var child = cnew makeXmlElement(makeString("window"))
  child[].setAttribute(makeIdentifier("width"), 640.cint)
  child[].addTextElement(makeString("hello"))
  root.addChildElement(child)

  doAssert root.hasTagName("settings")
  doAssert $root.getStringAttribute("name") == "june"
  doAssert root.getIntAttribute("version", 0.cint) == 2

  let serialised = $root.toString(makeXmlElementTextFormat())
  doAssert serialised.contains("<settings"), "serialised as " & serialised
  doAssert serialised.contains("width=\"640\""), "serialised as " & serialised

  # And it parses back to the same values.
  var document = makeXmlDocument(makeString(serialised))
  let parsed = document.getDocumentElement()
  # get() rather than isNil(): Nim emits one C++ function for a generic over an
  # importcpp type and reuses it across instantiations, which g++ rejects.
  doAssert parsed.get() != nil, "the document did not parse"
  doAssert parsed.get()[].hasTagName("settings")
  doAssert parsed.get()[].getIntAttribute("version", 0.cint) == 2

  let window = parsed.get()[].getChildByName("window")
  doAssert window != nil, "the child did not survive the round trip"
  doAssert window[].getIntAttribute("width", 0.cint) == 640
  doAssert $window[].getAllSubText() == "hello"

testXmlRoundTrip()

# URL =========================================================================
#
# URL parses on construction, so the accessors are pure value reads and need no
# network. withParameter returns a new URL rather than mutating the receiver.

proc testURL() =
  let url = makeURL(makeString("https://example.com:8080/a/b?x=1"))
  doAssert url.isWellFormed(), "a plain https URL was rejected"
  doAssert $url.getScheme() == "https", "scheme was " & $url.getScheme()
  doAssert $url.getDomain() == "example.com", "domain was " & $url.getDomain()
  doAssert url.getPort() == 8080, "port was " & $url.getPort()
  doAssert $url.getSubPath() == "a/b", "sub path was " & $url.getSubPath()

  # The query string is only included when asked for.
  doAssert not ($url.toString(false)).contains("x=1"), "toString(false) kept the query"
  doAssert ($url.toString(true)).contains("x=1"), "toString(true) dropped the query"

  # withParameter leaves the receiver alone.
  let extended = url.withParameter(makeString("y"), makeString("2"))
  doAssert ($extended.toString(true)).contains("y=2"), "the parameter was not added"
  doAssert not ($url.toString(true)).contains("y=2"), "withParameter mutated the original"

testURL()

# String-like overloads =======================================================
#
# A Nim string literal reaches String, StringRef and constChar through three
# separate converters, so a method overloaded on all three matches it three
# ways. Nim 1.6 called that ambiguous and the generator emitted only one of
# them; Nim 2.2 resolves it and all three are bound. These calls are what the
# generator would otherwise have to withhold.

proc testStringLikeOverloads() =
  var text = makeString("Hello")

  doAssert text.equalsIgnoreCase("HELLO"), "a literal did not resolve"
  doAssert text.equalsIgnoreCase(makeString("HELLO")), "a String did not resolve"
  doAssert text.equalsIgnoreCase(makeStringRef(makeString("HELLO"))),
           "a StringRef did not resolve"

  # += is overloaded the same way.
  text += "!"
  doAssert $text == "Hello!", "text is " & $text

  # And the StringRef constructor, which used to be withheld outright.
  doAssert $makeString(makeStringRef(makeString("x"))) == "x",
           "the StringRef constructor did not round trip"

  doAssert text.compare("Hello!") == 0, "compare returned " & $text.compare("Hello!")

testStringLikeOverloads()

# A generated subclass, used ==================================================
#
# Constructing one proves it is not abstract. This proves the handler is
# actually reached: writeText is JUCE's own code, and the only way it can put
# bytes anywhere is through the write() virtual the subclass overrides.

proc testGeneratedSubclassDispatch() =
  var written = 0
  var stream = newCustomOutputStream()
  stream[].setWriteHandler(proc(data: pointer, bytes: csize_t): bool =
    written += bytes.int
    true)
  stream[].setFlushHandler(proc() = discard)
  stream[].setGetPositionHandler(proc(): int64 = written.int64)
  stream[].setSetPositionHandler(proc(newPosition: int64): bool = false)

  # Called from C++, through the virtual.
  doAssert stream[].writeText(makeString("hello"), false, false, cast[constChar](nil)),
           "writeText reported failure"
  doAssert written == 5, "the handler saw " & $written & " bytes"

  # And the returning virtual reads back through JUCE's own accessor.
  doAssert stream[].getPosition() == 5, "getPosition returned " & $stream[].getPosition()

  cdelete stream

testGeneratedSubclassDispatch()

# A generated Thread, run ====================================================
#
# juce::Thread::run is pure virtual, so a background thread could not be
# written in Nim at all before the subclass existed. This starts one and waits
# for it, so the handler runs on a thread JUCE created rather than on this one.

proc testGeneratedThreadRuns() =
  var ran = false
  var thread = newCustomThread(makeString("june-test"), 0.csize_t)
  thread[].setRunHandler(proc() = ran = true)

  doAssert thread[].startThread(), "the thread did not start"
  doAssert thread[].waitForThreadToExit(5000.cint), "the thread did not finish in time"
  doAssert ran, "run() was never called"

  cdelete thread

testGeneratedThreadRuns()

# Time ========================================================================
#
# A value type over a millisecond count. The field accessors report LOCAL time
# whatever the constructor was given, so this builds its instant with
# useLocalTime set and compares round trips rather than absolute values, and
# depends on neither the clock nor the host's time zone.

proc testTime() =
  let moment = makeTime(2001.cint, 0.cint, 15.cint, 6.cint, 30.cint, 45.cint,
                        0.cint, true)
  doAssert moment.getYear() == 2001, "year was " & $moment.getYear()
  doAssert moment.getMonth() == 0, "month was " & $moment.getMonth()
  doAssert moment.getDayOfMonth() == 15, "day was " & $moment.getDayOfMonth()
  doAssert moment.getHours() == 6, "hours were " & $moment.getHours()
  doAssert moment.getMinutes() == 30, "minutes were " & $moment.getMinutes()
  doAssert moment.getSeconds() == 45, "seconds were " & $moment.getSeconds()

  # The millisecond count round-trips through the constructor that takes one.
  let copy = makeTime(moment.toMilliseconds())
  doAssert copy.toMilliseconds() == moment.toMilliseconds(),
           "the epoch millisecond count did not survive"
  doAssert copy.getYear() == 2001, "the round trip lost the year"
  doAssert copy.getHours() == 6, "the round trip lost the hour"

  # And so does the ISO 8601 form. Its text is UTC, so only the instant is
  # compared and not the digits.
  let parsed = Time.fromISO8601(makeStringRef(moment.toISO8601(true)))
  doAssert parsed.toMilliseconds() == moment.toMilliseconds(),
           "ISO 8601 round trip gave " & $parsed.toISO8601(true)

  # The epoch itself is zero.
  doAssert makeTime(0.int64).toMilliseconds() == 0, "the epoch was not zero"

testTime()

# Methods the skip table used to withhold ======================================
#
# Each of these was excluded by name with no reason recorded. Skipping by name
# also took overloads with it: ConsoleApplication::findAndRunCommand has one
# form taking an ArgumentList and one taking a C array, and only the second
# cannot be bound. The generator judges each signature on its own now, so the
# C array form is the only one still commented and it says why.

proc testRestoredBindings() =
  # Random, seeded so the sequence is reproducible.
  var random = makeRandom(12345.int64)
  let first = random.nextInt()
  let bounded = random.nextInt(10.cint)
  doAssert bounded >= 0 and bounded < 10, "bounded nextInt gave " & $bounded
  var again = makeRandom(12345.int64)
  doAssert again.nextInt() == first, "the seeded sequence did not reproduce"

  # String::quoted wraps in the character it is given.
  doAssert $makeString("hi").quoted(uint32('\'')) == "'hi'",
           "quoted gave " & $makeString("hi").quoted(uint32('\''))

  # DynamicObject::clone returns an owning pointer to a copy.
  var original = makeDynamicObject()
  original.setProperty(makeIdentifier("n"), makejuce_var(7.cint))
  let copied = original.clone()
  doAssert not copied.isNil(), "clone returned nothing"
  doAssert copied.get()[].hasProperty(makeIdentifier("n")), "the clone lost the property"

  # RelativeTime::getDescription returns the given text for a zero duration.
  doAssert $makeRelativeTime(0.0).getDescription(makeString("none")) == "none",
           "getDescription gave " & $makeRelativeTime(0.0).getDescription(makeString("none"))

  # StringArray::appendNumbersToDuplicates renames the second occurrence.
  var names = makeStringArray()
  names.add(makeString("dup"))
  names.add(makeString("dup"))
  # JUCE gives the two suffix strings defaults that the generator cannot spell,
  # so all four arguments are passed. " (" and ")" are what JUCE defaults to.
  var opening = " ("
  var closing = ")"
  names.appendNumbersToDuplicates(false, false,
                                  makeCharPointer_UTF8(cast[ptr char](opening[0].addr)),
                                  makeCharPointer_UTF8(cast[ptr char](closing[0].addr)))
  doAssert names.size() == 2, "the array holds " & $names.size()
  doAssert $names[1.cint] != "dup", "the duplicate was not renumbered"

testRestoredBindings()

# operator! and operator~ =====================================================
#
# Nim spells both as `not`: logical negation where the result is a bool, and
# bitwise complement otherwise. Neither collides with the built-in `not`, which
# is only defined for bool.

proc testNotOperators() =
  doAssert not (not Result.ok()), "operator! on an ok Result said it failed"
  doAssert (not Result.fail(makeString("boom"))), "operator! on a failed Result said it was fine"

testNotOperators()

# String and MemoryBlock iterators ============================================
#
# Both classes expose a C++ iterator, which has no Nim spelling, so each is
# commented in the bindings with "loop with the Nim iterator instead". These
# are that iterator; without them the reason pointed at something that did not
# exist.

proc testCoreIterators() =
  var seen = ""
  for character in makeString("abc"):
    seen.add(char(character))
  doAssert seen == "abc", "the String iterator gave " & seen

  # An empty string yields nothing rather than one empty item.
  var emptyCount = 0
  for _ in makeString(""):
    emptyCount += 1
  doAssert emptyCount == 0, "an empty String yielded " & $emptyCount & " items"

  var block1 = makeMemoryBlock(3.uint64, true)
  doAssert block1.getSize() == 3, "the block is " & $block1.getSize() & " bytes"
  var total = 0
  var count = 0
  for byteValue in block1:
    total += byteValue.int
    count += 1
  doAssert count == 3, "the MemoryBlock iterator yielded " & $count & " bytes"
  doAssert total == 0, "initialiseToZero left " & $total

testCoreIterators()

# Comparison operators ========================================================
#
# The generator comments out operator!=, operator> and operator>= on the
# grounds that Nim derives them, which covers over a hundred bindings and was
# never checked. It is checked here, together with the two String comparisons
# that need an exact overload: both < and <= reach a StringRef one and a free
# one through the same converter, and Nim calls that ambiguous.

proc testComparisonOperators() =
  let a = makeString("aaa")
  let b = makeString("bbb")

  doAssert a == a, "== on two Strings"
  doAssert a != b, "!= was not derived from =="
  doAssert not (a != a), "!= said a differs from itself"
  doAssert a < b, "< on two Strings"
  doAssert a <= b, "<= on two Strings"
  doAssert b > a, "> was not derived from <"
  doAssert b >= a, ">= was not derived from <="

  # Another class, so this is not a String-only accident.
  let small = makeRectangle(0.cint, 0.cint, 1.cint, 1.cint)
  let large = makeRectangle(0.cint, 0.cint, 2.cint, 2.cint)
  doAssert small != large, "Rectangle != was not derived from =="
  doAssert small == small, "Rectangle == on itself"

testComparisonOperators()

# String operators ============================================================
#
# String is the type three converters feed - from a Nim string, and on to
# StringRef both ways - so it is where an overload set is most likely to become
# ambiguous. That is what went wrong with <=. Every operator bound for String
# is exercised here with a String on the right and again with a literal.

proc testStringOperators() =
  let a = makeString("aa")
  let b = makeString("bb")

  doAssert $(a + b) == "aabb", "String + String gave " & $(a + b)
  doAssert $(a + "lit") == "aalit", "String + literal gave " & $(a + "lit")

  var appended = makeString("mm")
  appended += b
  doAssert $appended == "mmbb", "String += String gave " & $appended
  appended += "lit"
  doAssert $appended == "mmbblit", "String += literal gave " & $appended

  doAssert a[0.cint] == uint32('a'), "String [] gave " & $a[0.cint]
  doAssert a == makeString("aa"), "String == String"
  doAssert a == "aa", "String == literal"

testStringOperators()

# The other converter-exposed comparisons =====================================
#
# String was where <= went ambiguous, so the same check runs over the types the
# converters also reach. StringRef compares against a String rather than
# another StringRef, which is JUCE's own design, and it does not own its
# characters - the String it was made from has to outlive it, or the comparison
# reads freed memory and quietly returns the wrong answer.

proc testConverterComparisons() =
  let owned = makeString("aa")
  let reference = makeStringRef(owned)
  doAssert reference == makeString("aa"), "StringRef == String"
  doAssert reference < makeString("bb"), "StringRef < String"
  doAssert reference <= makeString("bb"), "StringRef <= String"

  let first = makeIdentifier("aa")
  let second = makeIdentifier("bb")
  doAssert first == first, "Identifier =="
  doAssert first != second, "Identifier !="

  let one = makejuce_var(1.cint)
  let two = makejuce_var(2.cint)
  doAssert one != two, "var !="
  doAssert one < two, "var <"
  doAssert one <= two, "var <="

testConverterComparisons()

# StringRef through a converter ===============================================
#
# The README says a Nim string passed straight to a StringRef parameter is
# safe, because the converter's temporary lives for the duration of the call,
# while a StringRef bound to a name outlives the String it came from and reads
# freed memory. This is the safe half, asserted rather than claimed.

proc testStringRefParameters() =
  var pairs = makeStringPairArray(true)
  pairs.set(makeString("alpha"), makeString("1"))

  doAssert pairs.containsKey("alpha"), "a literal did not reach the StringRef parameter"
  doAssert not pairs.containsKey("beta"), "a missing key was reported present"
  doAssert $pairs.getValue("alpha", makeString("none")) == "1",
           "getValue gave " & $pairs.getValue("alpha", makeString("none"))

  let key = makeString("alpha")
  doAssert pairs.containsKey(key), "a String did not reach the StringRef parameter"

testStringRefParameters()

# Uuid, BigInteger, PropertySet and MemoryOutputStream ========================
#
# Four value types with no coverage. All deterministic: the Uuid is built from
# a string rather than generated, so nothing here depends on randomness.

proc testUuid() =
  doAssert makeUuid(makeString("")).isNull(), "an empty Uuid was not null"

  let text = "0123456789abcdef0123456789abcdef"
  let id = makeUuid(makeString(text))
  doAssert not id.isNull(), "a Uuid built from digits was null"
  doAssert $id.toString() == text, "toString gave " & $id.toString()

  # The dashed form is the same digits with four dashes in it.
  let dashed = $id.toDashedString()
  doAssert dashed.len == text.len + 4, "dashed form is " & dashed
  doAssert dashed.replace("-", "") == text, "dashed form lost digits: " & dashed

  # Two Uuids built from the same text are equal.
  doAssert id == makeUuid(makeString(text)), "the same text gave different Uuids"

proc testBigInteger() =
  var value = makeBigInteger(0.cint)
  doAssert value.isZero(), "a zero BigInteger did not report zero"

  discard value.setBit(0.cint)
  doAssert value.isOne(), "setting bit 0 did not give one"
  doAssert value.toInteger() == 1, "toInteger gave " & $value.toInteger()

  discard value.setBit(3.cint)
  doAssert value.toInteger() == 9, "bits 0 and 3 gave " & $value.toInteger()

  discard value.clearBit(0.cint)
  doAssert value.toInteger() == 8, "clearing bit 0 gave " & $value.toInteger()

  # A bit range reads back as the integer it spells.
  var wide = makeBigInteger(0.cint)
  discard wide.setRange(4.cint, 4.cint, true)
  doAssert wide.getBitRangeAsInt(4.cint, 4.cint) == 15'u32,
           "the range read back as " & $wide.getBitRangeAsInt(4.cint, 4.cint)

  discard wide.clear()
  doAssert wide.isZero(), "clear left something behind"

proc testPropertySet() =
  var settings = makePropertySet(false)
  doAssert not settings.containsKey("missing"), "an empty set claimed a key"

  settings.setValue("name", makejuce_var(makeString("june")))
  settings.setValue("count", makejuce_var(7.cint))
  settings.setValue("on", makejuce_var(true))

  doAssert settings.containsKey("name"), "the key did not stick"
  doAssert $settings.getValue("name", makeString("none")) == "june",
           "getValue gave " & $settings.getValue("name", makeString("none"))
  doAssert settings.getIntValue("count", 0.cint) == 7,
           "getIntValue gave " & $settings.getIntValue("count", 0.cint)
  doAssert settings.getBoolValue("on", false), "getBoolValue lost the flag"

  # A missing key falls back to what the caller passed.
  doAssert settings.getIntValue("missing", 42.cint) == 42, "the default was ignored"

  settings.removeValue("name")
  doAssert not settings.containsKey("name"), "removeValue left the key"

  settings.clear()
  doAssert not settings.containsKey("count"), "clear left a key"

proc testMemoryOutputStream() =
  var stream = makeMemoryOutputStream(16.uint64)
  doAssert stream.getDataSize() == 0, "a fresh stream held " & $stream.getDataSize()

  doAssert stream.writeText(makeString("hello"), false, false, cast[constChar](nil)),
           "writeText reported failure"
  doAssert stream.getDataSize() == 5, "the stream holds " & $stream.getDataSize()
  doAssert $stream.toString() == "hello", "toString gave " & $stream.toString()

  stream.reset()
  doAssert stream.getDataSize() == 0, "reset left " & $stream.getDataSize() & " bytes"

testUuid()
testBigInteger()
testPropertySet()
testMemoryOutputStream()

# CharPointer_UTF8 ============================================================
#
# JUCE's UTF-8 cursor over a raw buffer. It does not own the bytes, so the Nim
# string behind it has to outlive it, the same contract StringRef has.

proc testCharPointerUTF8() =
  var buffer = "abc"
  let start = makeCharPointer_UTF8(cast[ptr char](buffer[0].addr))

  doAssert not start.isEmpty(), "a non-empty buffer reported empty"
  doAssert start.isNotEmpty(), "isNotEmpty disagreed with isEmpty"
  doAssert start.length() == 3'u64, "length gave " & $start.length()
  doAssert start.sizeInBytes() == 4'u64,
           "sizeInBytes gave " & $start.sizeInBytes() & ", the terminator included"

  # lengthUpTo stops counting where it is told to.
  doAssert start.lengthUpTo(2'u64) == 2'u64, "lengthUpTo gave " & $start.lengthUpTo(2'u64)

  # getAndAdvance walks the buffer one character at a time.
  var cursor = makeCharPointer_UTF8(cast[ptr char](buffer[0].addr))
  doAssert cursor.getAndAdvance() == uint32('a'), "the first character"
  doAssert cursor.getAndAdvance() == uint32('b'), "the second character"
  doAssert cursor.length() == 1'u64, "after two steps the rest is " & $cursor.length()

  var empty = ""
  doAssert makeCharPointer_UTF8(cast[ptr char](empty.cstring)).isEmpty(),
           "an empty buffer reported non-empty"

testCharPointerUTF8()

# ByteOrder and CharacterFunctions ============================================
#
# Both are namespaces of static functions, so every assertion here is exact and
# independent of the host - except isBigEndian, which is a property of it.

proc testByteOrder() =
  doAssert ByteOrder.swap(0x1234'u16) == 0x3412'u16,
           "16-bit swap gave " & $ByteOrder.swap(0x1234'u16)
  doAssert ByteOrder.swap(0x12345678'u32) == 0x78563412'u32,
           "32-bit swap gave " & $ByteOrder.swap(0x12345678'u32)
  doAssert ByteOrder.swap(0x0123456789abcdef'u64) == 0xefcdab8967452301'u64,
           "64-bit swap gave " & $ByteOrder.swap(0x0123456789abcdef'u64)

  # Swapping twice is the identity.
  doAssert ByteOrder.swap(ByteOrder.swap(0xbeef'u16)) == 0xbeef'u16,
           "a double swap did not round trip"

  # The two readers disagree on the same bytes, in the way the names say.
  var bytes = [0x01'u8, 0x02'u8, 0x03'u8, 0x04'u8]
  let raw = cast[constPointer](bytes[0].addr)
  doAssert ByteOrder.littleEndianInt(raw) == 0x04030201'u32,
           "littleEndianInt gave " & $ByteOrder.littleEndianInt(raw)
  doAssert ByteOrder.bigEndianInt(raw) == 0x01020304'u32,
           "bigEndianInt gave " & $ByteOrder.bigEndianInt(raw)

  # Whichever way the host runs, the two answers are byte-swaps of each other.
  doAssert ByteOrder.swap(ByteOrder.littleEndianInt(raw)) == ByteOrder.bigEndianInt(raw),
           "the two readers are not swaps of each other"

proc testCharacterFunctions() =
  doAssert CharacterFunctions.toUpperCase(uint32('a')) == uint32('A'), "toUpperCase"
  doAssert CharacterFunctions.toLowerCase(uint32('Z')) == uint32('z'), "toLowerCase"
  doAssert CharacterFunctions.isUpperCase(uint32('A')), "isUpperCase on A"
  doAssert not CharacterFunctions.isUpperCase(uint32('a')), "isUpperCase on a"
  doAssert CharacterFunctions.isLowerCase(uint32('a')), "isLowerCase on a"

  # isDigit and isWhitespace are each declared twice by JUCE, once for char and
  # once for juce_wchar. An argument from Nim converts to both, so the call was
  # ambiguous in C++ and neither overload could be used; the binding casts to
  # the type its own overload declares, which picks one.
  doAssert CharacterFunctions.isDigit(uint32('7')), "isDigit on 7"
  doAssert not CharacterFunctions.isDigit(uint32('x')), "isDigit on x"
  doAssert CharacterFunctions.isWhitespace(uint32(' ')), "isWhitespace on space"
  doAssert not CharacterFunctions.isWhitespace(uint32('x')), "isWhitespace on x"
  doAssert CharacterFunctions.isDigit('7'), "isDigit on the char overload"
  doAssert not CharacterFunctions.isDigit('x'), "isDigit on the char overload with x"

  # A character with no case is unchanged by either conversion.
  doAssert CharacterFunctions.toUpperCase(uint32('5')) == uint32('5'), "toUpperCase on a digit"
  doAssert CharacterFunctions.toLowerCase(uint32('5')) == uint32('5'), "toLowerCase on a digit"

testByteOrder()
testCharacterFunctions()

# juce_wchar is 32 bits =======================================================
#
# JUCE's character type is 32-bit, and the generator briefly mapped it to
# uint16 because libclang resolves juce_wchar to wchar_t. Everything that
# returned a character truncated silently: String's operator[] gave 0xF600 for
# U+1F600 rather than failing. This is the assertion that says it does not.

proc testWideCharacters() =
  let grinning = makeString("\u{1F600}")
  doAssert grinning.length() == 1, "JUCE stored " & $grinning.length() & " characters"
  doAssert uint32(grinning[0.cint]) == 0x1F600'u32,
           "the character came back as " & $uint32(grinning[0.cint])

  # And through the cursor, which returns the same type.
  var cursor = grinning.getCharPointer()
  doAssert uint32(cursor.getAndAdvance()) == 0x1F600'u32,
           "getAndAdvance gave " & $uint32(cursor.getAndAdvance())

testWideCharacters()

# Overloads that differ only by a scalar =======================================
#
# JUCE declares several methods once per numeric type. An argument from Nim
# converts to all of them, so C++ could not pick and none of the overloads was
# callable. The binding casts each argument to the type its own overload
# declares, which resolves it.

proc testScalarOverloads() =
  # RelativeTime::milliseconds is declared for int and for int64.
  doAssert RelativeTime.milliseconds(1500.cint).inSeconds() == 1.5,
           "the int overload gave " & $RelativeTime.milliseconds(1500.cint).inSeconds()
  doAssert RelativeTime.milliseconds(2000.int64).inSeconds() == 2.0,
           "the int64 overload gave " & $RelativeTime.milliseconds(2000.int64).inSeconds()

  # CharacterFunctions declares each test for char and for juce_wchar.
  doAssert CharacterFunctions.isLetter(uint32('q')), "isLetter on the wide overload"
  doAssert CharacterFunctions.isLetter('q'), "isLetter on the char overload"
  doAssert CharacterFunctions.isLetterOrDigit(uint32('7')), "isLetterOrDigit"
  doAssert CharacterFunctions.isPrintable(uint32('x')), "isPrintable"

testScalarOverloads()

# The string-like overload sets ===============================================
#
# Twenty-three bound methods are overloaded across String, StringRef and
# constChar. A Nim string reaches all three through converters and a String
# reaches two, so each of these is a chance for the call to become ambiguous -
# which is what happened to <=. Each set is called both ways here.

proc testStringLikeOverloadSets() =
  let text = makeString("abc")

  doAssert $makeIdentifier("lit").toString() == "lit", "makeIdentifier with a literal"
  doAssert $makeIdentifier(text).toString() == "abc", "makeIdentifier with a String"

  var fromLiteral = makeStringArray("lit")
  doAssert fromLiteral.size() == 1, "makeStringArray with a literal"
  var fromString = makeStringArray(text)
  doAssert fromString.size() == 1, "makeStringArray with a String"

  doAssert makeStringRef(text) == text, "makeStringRef with a String"

  doAssert text.compare("abc") == 0, "compare with a literal"
  doAssert text.compare(makeString("abc")) == 0, "compare with a String"
  doAssert text.equalsIgnoreCase("ABC"), "equalsIgnoreCase with a literal"

  var pool = makeStringPool()
  doAssert $pool.getPooledString(text) == "abc", "getPooledString with a String"

testStringLikeOverloadSets()

# CharPointer_UTF32 ===========================================================
#
# The 32-bit cursor, over a buffer this test owns. Worth its own coverage
# because its CharType is juce_wchar, the alias that was mapped to uint16 and
# truncated everything above U+FFFF: a UTF-32 cursor that cannot carry a
# non-BMP character is not a UTF-32 cursor.

proc testCharPointerUTF32() =
  # GRINNING FACE, KISS MARK, and a plain letter, then the terminator.
  var codepoints: array[4, WChar] = [WChar(0x1F600), WChar(0x1F48B), WChar(uint32('a')), WChar(0)]
  let start = makeCharPointer_UTF32(codepoints[0].addr)

  doAssert start.isNotEmpty(), "a filled buffer reported empty"
  doAssert start.length() == 3'u64, "length gave " & $start.length()

  var cursor = makeCharPointer_UTF32(codepoints[0].addr)
  doAssert cursor.getAndAdvance() == 0x1F600'u32,
           "the first codepoint came back as " & $cursor.getAndAdvance()
  doAssert cursor.getAndAdvance() == 0x1F48B'u32, "the second codepoint"
  doAssert cursor.getAndAdvance() == uint32('a'), "the third codepoint"

  # write puts a non-BMP codepoint back without narrowing it.
  var scratch: array[2, WChar] = [WChar(0), WChar(0)]
  var writer = makeCharPointer_UTF32(scratch[0].addr)
  writer.write(0x1F600'u32)
  doAssert scratch[0] == 0x1F600'u32, "write stored " & $scratch[0]

  var empty: array[1, WChar] = [WChar(0)]
  doAssert makeCharPointer_UTF32(empty[0].addr).isEmpty(),
           "a terminator-only buffer reported non-empty"

testCharPointerUTF32()

# CharPointer_UTF16 and the UTF-16 buffer =====================================
#
# copyToUTF16 fills a caller's buffer through a `short*`, and isValidString
# reads one back. Both are spelled `ptr int16` in Nim, which is a different
# question from the wchar_t one above: there the identities did not match and
# nothing was callable, here Nim's int16 is C++'s short and they do.

proc testUTF16Buffer() =
  var buffer: array[16, int16]
  let bytesWritten = makeString("hi").copyToUTF16(buffer[0].addr, 32'u64)
  doAssert bytesWritten > 0'u64, "copyToUTF16 wrote " & $bytesWritten

  doAssert CharPointer_UTF16.isValidString(buffer[0].addr, 32.cint),
           "isValidString rejected what copyToUTF16 produced"

  # The cursor over that buffer reads the characters back.
  var cursor = makeCharPointer_UTF16(buffer[0].addr)
  doAssert cursor.getAndAdvance() == uint32('h'), "the first character"
  doAssert cursor.getAndAdvance() == uint32('i'), "the second character"

testUTF16Buffer()

# NamedValueSet ===============================================================
#
# The property bag behind ValueTree and DynamicObject. Its iterator is already
# covered; these are the direct accessors.

proc testNamedValueSet() =
  var properties = makeNamedValueSet()
  doAssert properties.isEmpty(), "a fresh set was not empty"
  doAssert properties.size() == 0, "a fresh set holds " & $properties.size()

  let name = makeIdentifier("width")
  doAssert properties.set(name, makejuce_var(640.cint)), "set reported no change"
  doAssert properties.contains(name), "the name did not stick"
  doAssert properties.size() == 1, "the set holds " & $properties.size()
  doAssert not properties.isEmpty(), "a filled set reported empty"

  # Setting the same name to the same value reports no change.
  doAssert not properties.set(name, makejuce_var(640.cint)),
           "setting the same value reported a change"
  doAssert properties.set(name, makejuce_var(800.cint)),
           "setting a different value reported no change"

  # A missing name falls back to what the caller passed.
  let missing = makeIdentifier("height")
  doAssert properties.getWithDefault(missing, makejuce_var(480.cint)).toString() ==
           makejuce_var(480.cint).toString(), "the default was ignored"

  doAssert properties.remove(name), "remove reported nothing removed"
  doAssert properties.isEmpty(), "remove left the set non-empty"

testNamedValueSet()

# var's conversion operators ==================================================
#
# These are bound as static_cast, which narrows silently where C++ would. The
# 64-bit path is the one worth pinning: a var holding a value wider than 32
# bits has to survive toInt64 whole, and the truncation in toInt has to be the
# one C++ performs rather than one the binding introduced.

proc testVarConversions() =
  let wide = 0x1_0000_0001'i64
  let value = makejuce_var(wide)

  doAssert value.toInt64() == wide, "toInt64 gave " & $value.toInt64()
  doAssert value.toInt() == 1,
           "toInt gave " & $value.toInt() & "; C++ keeps the low 32 bits"
  doAssert value.toFloat64() == 4294967297.0, "toFloat64 gave " & $value.toFloat64()

  let fraction = makejuce_var(0.1'f64)
  doAssert fraction.toFloat64() == 0.1, "toFloat64 gave " & $fraction.toFloat64()

  doAssert not makejuce_var(0.cint).toBool(), "zero converted to true"
  doAssert makejuce_var(1.cint).toBool(), "one converted to false"

testVarConversions()

# The overloaded free functions ===============================================
#
# countNumberOfBits is declared for uint32 and for uint64, which is the same
# shape that made juce::var's constructors ambiguous under g++ and not under
# clang. Both are called here, so the Linux build is the one that answers
# whether they need the same cast.

proc testOverloadedFreeFunctions() =
  doAssert countNumberOfBits(0b1011'u32) == 3,
           "the 32-bit form gave " & $countNumberOfBits(0b1011'u32)
  doAssert countNumberOfBits(0b1011'u64) == 3,
           "the 64-bit form gave " & $countNumberOfBits(0b1011'u64)
  doAssert findHighestSetBit(0b1000'u32) == 3,
           "findHighestSetBit gave " & $findHighestSetBit(0b1000'u32)

testOverloadedFreeFunctions()

# String from each character-pointer form ======================================
#
# Every one of these constructors carries a cast now. They all have to produce
# the same string from the same text.

proc testStringConstructors() =
  let plain = makeString("abc")
  doAssert $makeString(plain.getCharPointer()) == "abc", "from a UTF-8 pointer"
  doAssert $makeString(makeStringRef(plain)) == "abc", "from a StringRef"
  doAssert $makeString(toConstChar("abc")) == "abc", "from a const char pointer"

testStringConstructors()

# IPAddress ===================================================================
#
# Built from four octets or from text, and read back as text. Its `address`
# field is a fixed-size C array, which is one of the bindings that genuinely
# cannot be spelled in Nim, so the text form is the way in and out.

proc testIPAddress() =
  let local = makeIPAddress(127'u8, 0'u8, 0'u8, 1'u8)
  doAssert $local.toString() == "127.0.0.1", "toString gave " & $local.toString()
  doAssert not local.isNull(), "a real address reported null"

  let parsed = makeIPAddress(makeString("127.0.0.1"))
  doAssert parsed == local, "the parsed address differs from the built one"

  doAssert makeIPAddress().isNull(), "a default address was not null"

# Expression ==================================================================
#
# JUCE's little arithmetic parser. evaluate returns a double, so this is also a
# check that the numeric path survives the binding.

proc testExpression() =
  var parseError = makeString("")
  let sum = makeExpression(makeString("2 + 3 * 4"), parseError)
  doAssert $parseError == "", "the parser reported " & $parseError
  doAssert sum.evaluate() == 14.0, "2 + 3 * 4 evaluated to " & $sum.evaluate()

  let constant = makeExpression(2.5)
  doAssert constant.evaluate() == 2.5, "a constant evaluated to " & $constant.evaluate()

testIPAddress()
testExpression()

# StringPairArray =============================================================
#
# The key/value store behind URL parameters and file metadata. Its lookups take
# a StringRef, so a Nim literal reaches them through the converter.

proc testStringPairArray() =
  var pairs = makeStringPairArray(true)
  doAssert pairs.size() == 0, "a fresh array holds " & $pairs.size()

  pairs.set(makeString("host"), makeString("example.com"))
  pairs.set(makeString("port"), makeString("8080"))
  doAssert pairs.size() == 2, "the array holds " & $pairs.size()
  doAssert $pairs.getValue("host", makeString("none")) == "example.com",
           "getValue gave " & $pairs.getValue("host", makeString("none"))

  # Built with ignoreCase, so a differently-cased key finds the same entry.
  doAssert pairs.containsKey("HOST"), "the case-insensitive lookup missed"

  # The keys and values come back as parallel arrays.
  doAssert pairs.getAllKeys().size() == 2, "getAllKeys returned the wrong count"
  doAssert pairs.getAllValues().size() == 2, "getAllValues returned the wrong count"

  pairs.remove("host")
  doAssert pairs.size() == 1, "after removal the array holds " & $pairs.size()
  pairs.clear()
  doAssert pairs.size() == 0, "clear left " & $pairs.size()

# MemoryInputStream ===========================================================
#
# Reads back what MemoryOutputStream wrote, which is the pair of concrete
# streams the abstract InputStream and OutputStream subclasses stand in for.

proc testMemoryInputStream() =
  var output = makeMemoryOutputStream(16.uint64)
  doAssert output.writeText(makeString("hello"), false, false, cast[constChar](nil)),
           "writeText reported failure"

  var input = makeMemoryInputStream(output.getData(), output.getDataSize(), false)
  doAssert input.getTotalLength() == 5, "the stream is " & $input.getTotalLength() & " bytes"
  doAssert input.getPosition() == 0, "a fresh stream is at " & $input.getPosition()
  doAssert not input.isExhausted(), "a full stream reported exhausted"

  var buffer: array[8, char]
  doAssert input.read(buffer[0].addr, 5.cint) == 5, "read returned the wrong count"
  doAssert buffer[0] == 'h' and buffer[4] == 'o', "the bytes came back wrong"
  doAssert input.isExhausted(), "the stream was not exhausted after reading it all"

  doAssert input.setPosition(0.int64), "setPosition reported failure"
  doAssert input.getPosition() == 0, "setPosition left it at " & $input.getPosition()

testStringPairArray()
testMemoryInputStream()

# The hand-written container generics =========================================
#
# Array, SparseSet and HeapBlock are hand-written wrappers, and a generic is
# only type-checked where it is instantiated. Nothing had called these, which
# is the state makeBorderSize was in when it turned out to name a constructor
# JUCE does not have.

proc testArrayHelpers() =
  var numbers = makeArray[cint]()
  doAssert numbers.isEmpty(), "a fresh Array was not empty"

  numbers.add(10.cint)
  numbers.add(20.cint)
  numbers.add(30.cint)
  doAssert numbers.size() == 3, "the array holds " & $numbers.size()
  doAssert numbers.getFirst() == 10, "getFirst gave " & $numbers.getFirst()
  doAssert numbers.getLast() == 30, "getLast gave " & $numbers.getLast()
  doAssert numbers.indexOf(20.cint) == 1, "indexOf gave " & $numbers.indexOf(20.cint)
  doAssert numbers.indexOf(99.cint) == -1, "a missing element was found"
  doAssert numbers.contains(20.cint), "contains missed a present element"

  numbers.clear()
  doAssert numbers.isEmpty(), "clear left something behind"

proc testHeapBlock() =
  var storage = makeHeapBlock[cint](4.csize_t)
  doAssert not storage.isNil(), "an allocated block reported nil"
  doAssert storage.get() != nil, "get returned nothing"

  # calloc reallocates and zeroes.
  storage.calloc(8.csize_t)
  doAssert not storage.isNil(), "after calloc the block reported nil"
  doAssert cast[ptr UncheckedArray[cint]](storage.get())[0] == 0,
           "calloc did not zero the storage"

testArrayHelpers()
testHeapBlock()

# SparseSet and the last hand-written helpers =================================
#
# SparseSet was bound with its readers and no way to fill it, so it could be
# constructed and never used. addRange, removeRange and clear are what make it
# a set rather than an empty one.

proc testSparseSet() =
  var occupied = makeSparseSet[cint]()
  doAssert occupied.isEmpty(), "a fresh set was not empty"
  doAssert occupied.getNumRanges() == 0, "a fresh set holds " & $occupied.getNumRanges()

  occupied.addRange(makeRange(0.cint, 10.cint))
  doAssert not occupied.isEmpty(), "a filled set reported empty"
  doAssert occupied.getNumRanges() == 1, "the set holds " & $occupied.getNumRanges() & " ranges"
  doAssert occupied.contains(5.cint), "the set did not contain a value inside its range"
  doAssert not occupied.contains(20.cint), "the set contained a value outside its range"

  # A second, separate range does not merge with the first.
  occupied.addRange(makeRange(20.cint, 30.cint))
  doAssert occupied.getNumRanges() == 2, "two separate ranges merged into " & $occupied.getNumRanges()
  doAssert occupied.getTotalRange().getEnd() == 30,
           "the total range ends at " & $occupied.getTotalRange().getEnd()

  occupied.removeRange(makeRange(20.cint, 30.cint))
  doAssert occupied.getNumRanges() == 1, "removeRange left " & $occupied.getNumRanges()

  occupied.clear()
  doAssert occupied.isEmpty(), "clear left something behind"

proc testValueReturningHelpers() =
  # The with* family returns a changed copy and leaves the receiver alone.
  let span = makeRange(10.cint, 20.cint)
  doAssert span.withStart(0.cint).getStart() == 0, "withStart"
  doAssert span.withEnd(30.cint).getEnd() == 30, "withEnd"
  doAssert span.withLength(5.cint).getLength() == 5, "withLength"
  doAssert span.getStart() == 10, "one of the with* helpers mutated the receiver"
  doAssert Range[cint].withStartAndLength(5.cint, 10.cint).getEnd() == 15,
           "withStartAndLength gave the wrong end"

  let point = makePoint(1.cint, 2.cint)
  doAssert point.withY(9.cint).getY() == 9, "withY"
  doAssert point.translated(3.cint, 4.cint).getX() == 4, "translated"
  doAssert point.getY() == 2, "withY mutated the receiver"

  let box = makeRectangle(0.cint, 0.cint, 20.cint, 10.cint)
  doAssert box.withWidth(5.cint).getWidth() == 5, "withWidth"
  doAssert box.withY(7.cint).getY() == 7, "withY on a Rectangle"
  doAssert box.translated(2.cint, 3.cint).getX() == 2, "translated on a Rectangle"
  doAssert box.getWidth() == 20, "one of the with* helpers mutated the rectangle"

  var owned = makeOwnedArray[Component]()
  doAssert owned.isEmpty(), "a fresh OwnedArray was not empty"

testSparseSet()
testValueReturningHelpers()

# The hand-written procs nothing had called ===================================
#
# The same reasoning as the generics: an importcpp string only reaches C++ at
# the call site, so a non-generic binding is unchecked until something calls
# it. These are the ones a test can safely reach.

proc testUncalledHandWritten() =
  # CppString has no constructor of its own; JUCE hands one out.
  let standard = makeString("hello").toStdString()
  doAssert standard.len() == 5, "the std::string is " & $standard.len() & " long"
  doAssert not standard.isEmpty(), "a filled std::string reported empty"
  doAssert $standard.cStr() == "hello", "cStr gave " & $standard.cStr()
  doAssert $standard == "hello", "the dollar operator gave " & $standard

  # And it round-trips back into a juce::String.
  doAssert $makeString(standard) == "hello", "the round trip through std::string lost the text"

  # fromUTF8 takes an explicit byte count rather than stopping at a terminator.
  doAssert $makeStringFromUTF8("abcdef".cstring, 3) == "abc",
           "makeStringFromUTF8 gave " & $makeStringFromUTF8("abcdef".cstring, 3)
  doAssert $makeStringFromUTF8("abc".cstring) == "abc",
           "the default count did not read to the terminator"

  # toRawUTF8 is what $ is built on, called directly here.
  doAssert makeString("xyz").toRawUTF8() == "xyz", "toRawUTF8 gave " & makeString("xyz").toRawUTF8()

testUncalledHandWritten()

# CharPointer_ASCII ===========================================================
#
# The last of the four character cursors. Its getAndAdvance returns a WChar
# like the others, even though every character it can hold fits in seven bits.

proc testCharPointerASCII() =
  var buffer = "hi!"
  let start = makeCharPointer_ASCII(cast[ptr char](buffer[0].addr))

  doAssert start.isNotEmpty(), "a filled buffer reported empty"
  doAssert start.length() == 3'u64, "length gave " & $start.length()

  var cursor = makeCharPointer_ASCII(cast[ptr char](buffer[0].addr))
  doAssert cursor.getAndAdvance() == 'h'.ord.uint32, "the first character"
  doAssert cursor.getAndAdvance() == 'i'.ord.uint32, "the second character"
  doAssert cursor.length() == 1'u64, "after two steps the rest is " & $cursor.length()

  var empty = ""
  doAssert makeCharPointer_ASCII(cast[ptr char](empty.cstring)).isEmpty(),
           "an empty buffer reported non-empty"

testCharPointerASCII()

# Enum equality ===============================================================
#
# Every bound enum is a distinct cint, which has none of cint's operators
# unless they are given to it. Comparing two enum values used to need a cast on
# both sides; each enum carries a borrowed == now.

proc testEnumEquality() =
  doAssert ImagePixelFormat_ARGB == ImagePixelFormat_ARGB,
           "an enum value did not equal itself"
  doAssert ImagePixelFormat_ARGB != ImagePixelFormat_RGB,
           "two different enum values compared equal"

  # != comes from Nim deriving it, which is the reason the generator does not
  # bind one.
  doAssert not (ImagePixelFormat_ARGB != ImagePixelFormat_ARGB),
           "the derived != disagreed with =="

  # And $ so a value can go in a message. It prints the number, not the name:
  # the binding holds the C++ enumerator and there is no table of names here.
  doAssert $ImagePixelFormat_ARGB == $ImagePixelFormat_ARGB,
           "printing disagreed with itself"
  doAssert $ImagePixelFormat_ARGB != $ImagePixelFormat_RGB,
           "two different formats printed the same"

testEnumEquality()

# Aggregates with an implicit default constructor ==============================
#
# JUCE declares these as plain structs with no constructor of their own, so
# libclang reports none and the generator emitted none: the type was declared,
# its fields had getters and setters, and there was no way to build one. Each
# is built here and a field is written and read back, which is what compiles
# the constructor - an importcpp string only reaches the C++ compiler at a
# call site.

proc testImplicitDefaultConstructors() =
    block:
        var change = makeTextDiffChange()
        change.insertedText = makeString("inserted")
        doAssert $change.insertedText() == "inserted",
                 "the change holds " & $change.insertedText()

        var argument = makeArgumentListArgument()
        argument.text = makeString("--verbose")
        doAssert $argument.text() == "--verbose", "the argument holds " & $argument.text()

        var command = makeConsoleApplicationCommand()
        command.commandOption = makeString("--help")
        doAssert $command.commandOption() == "--help",
                 "the command holds " & $command.commandOption()

        var poolOptions = makeThreadPoolOptions()
        poolOptions.threadName = makeString("workers")
        doAssert $poolOptions.threadName() == "workers",
                 "the options hold " & $poolOptions.threadName()

        var download = makeURLDownloadTaskOptions()
        download.extraHeaders = makeString("X-Test: 1")
        doAssert $download.extraHeaders() == "X-Test: 1",
                 "the options hold " & $download.extraHeaders()

        var attribute = makeXmlAttribute()
        attribute.value = makeString("42")
        doAssert $attribute.value() == "42", "the attribute holds " & $attribute.value()

        var entry = makeZipFileZipEntry()
        entry.filename = makeString("inside.txt")
        doAssert $entry.filename() == "inside.txt", "the entry holds " & $entry.filename()

        # NamedValue has no field of a type simple enough to write here, so
        # building it is the whole check: without a constructor it could not
        # be built at all.
        discard makeNamedValue()

testImplicitDefaultConstructors()

# The remaining generated subclasses ==========================================
#
# A subclass whose constructor nothing calls is never compiled: the C++ class
# is written into a header the type carries, and Nim includes that header only
# where the type itself is used. Discarding the returned pointer is not enough,
# which is how these went unnoticed.

proc testRemainingCoreSubclasses() =
    block:
        var job = newCustomThreadPoolJob(makeString("job"))
        doAssert not job.isNil(), "the job was not built"
        cdelete job

        # Setting a handler is what type-checks and generates the setter. An
        # uncalled one is neither, and the C++ field it assigns to is never
        # touched.
        # cint rather than the enum: runJob returns ThreadPoolJob::JobStatus,
        # which is a distinct cint, and the generator marks it basescalar so
        # the closure never names the distinct. The forwarder casts.
        job[].setRunJobHandler(proc(): cint = cint(ThreadPoolJobJobStatus_jobHasFinished))

        var unitTest = newCustomUnitTest(makeString("name"), makeString("category"))
        doAssert not unitTest.isNil(), "the unit test was not built"
        unitTest[].setRunTestHandler(proc() = discard)
        cdelete unitTest

        # Neither smart pointer had a constructor, so a Nim override of a
        # virtual returning one could not be written at all.
        let empty = makeUniquePtr[XmlElement]()
        doAssert empty.isNil(), "a default unique_ptr is not nil"
        var owned = makeUniquePtr[XmlElement](cnew(makeXmlElement(makeString("tag"))))
        doAssert not owned.isNil(), "a unique_ptr over a pointer is nil"
        doAssert $owned.get()[].getTagName() == "tag",
                 "the element is " & $owned.get()[].getTagName()

testRemainingCoreSubclasses()

# CppVector, CppString and CustomInputSource ==================================
#
# Neither std wrapper could be built, so a Nim override of a virtual returning
# one could not be written at all.

proc testStdWrappersAndInputSource() =
    block:
        let empty = makeCppVector[cint]()
        doAssert empty.size() == 0, "a default vector is not empty"

        let blank = makeCppString()
        doAssert blank.isEmpty(), "a default string is not empty"
        let hello = makeCppString("hello")
        doAssert hello.len() == 5, "the string holds " & $hello.len() & " characters"
        doAssert $hello == "hello", "the string reads back as " & $hello

        var source = newCustomInputSource()
        doAssert not source.isNil(), "the input source was not built"
        source[].setCreateInputStreamHandler(proc(): ptr InputStream = nil)
        source[].setCreateInputStreamForHandler(
            proc(relatedItemPath: ptr String): ptr InputStream = nil)
        source[].setHashCodeHandler(proc(): int64 = 1234'i64)
        cdelete source

testStdWrappersAndInputSource()

# The last of the core subclass handlers ======================================

proc testRemainingCoreHandlers() =
    block:
        var filter = newCustomFileFilter(makeString("filter"))
        filter[].setIsDirectorySuitableHandler(proc(file: ptr june.File): bool = true)
        cdelete filter

        var hiRes = newCustomHighResolutionTimer()
        hiRes[].setHiResTimerCallbackHandler(proc() = discard)
        cdelete hiRes

        var stream = newCustomInputStream()
        stream[].setGetTotalLengthHandler(proc(): int64 = 0'i64)
        stream[].setIsExhaustedHandler(proc(): bool = true)
        stream[].setReadHandler(proc(destBuffer: pointer, maxBytesToRead: cint): cint = 0.cint)
        cdelete stream

        var logger = newCustomLogger()
        logger[].setLogMessageHandler(proc(message: ptr String) = discard)
        cdelete logger

        # Set in the same program as setRunJobHandler on purpose. Both
        # closures return cint now, so the one closure struct Nim renders for
        # them is right for both. Before basescalar, runJob's closure named the
        # distinct enum, Nim typed the shared struct's function-pointer field
        # from whichever it emitted first, and this call assigned a pointer of
        # the wrong type.
        var client = newCustomTimeSliceClient()
        doAssert not client.isNil(), "the time slice client was not built"
        client[].setUseTimeSliceHandler(proc(): cint = -1.cint)
        cdelete client

testRemainingCoreHandlers()

# UnitTestRunner ==============================================================
#
# JUCE's own test harness, driven from Nim. A UnitTest registers itself when it
# is built, so the runner is asked for this one by name rather than being told
# to run everything. The result comes back through a ConstPtr, which is what
# getResult returns.

proc testUnitTestRunner() =
    block:
        var ran = 0
        var subject = newCustomUnitTest(makeString("june-runner-check"),
                                        makeString("june"))
        subject[].setRunTestHandler(proc() =
            ran += 1
            var self = cast[ptr UnitTest](subject)
            self[].beginTest(makeString("two expectations"))
            self[].expect(true, makeString("a true expectation failed"))
            self[].expect(false, makeString("deliberate failure")))

        var runner = makeUnitTestRunner()
        # Off, or the deliberate failure below trips a jassert in a debug build.
        runner.setAssertOnFailure(false)
        runner.setPassesAreLogged(false)
        runner.runTestsWithName(makeString("june-runner-check"))

        doAssert ran == 1, "the test body ran " & $ran & " times"
        doAssert runner.getNumResults() == 1,
                 "the runner produced " & $runner.getNumResults() & " results"

        let result = runner.getResult(0.cint)
        doAssert not result.isNil(), "the runner has no result to read"
        doAssert $result[].unitTestName() == "june-runner-check",
                 "the result is for " & $result[].unitTestName()
        doAssert $result[].subcategoryName() == "two expectations",
                 "the subcategory is " & $result[].subcategoryName()
        doAssert result[].passes() == 1,
                 "the result counted " & $result[].passes() & " passes"
        doAssert result[].failures() == 1,
                 "the result counted " & $result[].failures() & " failures"

        cdelete subject

# PerformanceCounter ==========================================================
#
# The statistics are arithmetic over the samples fed in, so they can be checked
# exactly without timing anything.

proc testPerformanceCounterStatistics() =
    block:
        var stats = makePerformanceCounterStatistics()
        stats.name = makeString("counter")
        doAssert stats.numRuns() == 0, "a fresh counter has " & $stats.numRuns() & " runs"

        stats.addResult(2.0)
        stats.addResult(4.0)
        stats.addResult(6.0)

        doAssert stats.numRuns() == 3, "the counter holds " & $stats.numRuns() & " runs"
        doAssert stats.totalSeconds() == 12.0,
                 "the total is " & $stats.totalSeconds()
        # addResult keeps the total, the extremes and the count, and leaves
        # averageSeconds alone: JUCE fills that in only in
        # getStatisticsAndReset, so a caller reading it off a Statistics it
        # accumulated itself gets nothing.
        doAssert stats.averageSeconds() == 0.0,
                 "addResult set the average to " & $stats.averageSeconds()
        stats.averageSeconds = stats.totalSeconds() / stats.numRuns().float64
        doAssert stats.averageSeconds() == 4.0,
                 "the average is " & $stats.averageSeconds()
        doAssert stats.minimumSeconds() == 2.0,
                 "the minimum is " & $stats.minimumSeconds()
        doAssert stats.maximumSeconds() == 6.0,
                 "the maximum is " & $stats.maximumSeconds()
        doAssert "counter" in $stats, "the description reads " & $stats

        stats.clear()
        doAssert stats.numRuns() == 0,
                 "after clearing the counter holds " & $stats.numRuns() & " runs"

testUnitTestRunner()
testPerformanceCounterStatistics()

# URL::InputStreamOptions =====================================================
#
# A builder: every withX returns a new options object rather than changing the
# one it was called on, so the original has to come back unchanged. The
# progress callback is a two-argument std::function, which nothing else in the
# suite binds.

proc testUrlInputStreamOptions() =
    block:
        let plain = makeURLInputStreamOptions(URLParameterHandling_inAddress)
        doAssert plain.getParameterHandling() == URLParameterHandling_inAddress,
                 "the options lost their parameter handling"
        doAssert $plain.getExtraHeaders() == "",
                 "a fresh options object carries headers: " & $plain.getExtraHeaders()

        let configured = plain
            .withExtraHeaders(makeString("X-June: 1"))
            .withConnectionTimeoutMs(2500.cint)
            .withNumRedirectsToFollow(3.cint)
            .withHttpRequestCmd(makeString("POST"))

        doAssert $configured.getExtraHeaders() == "X-June: 1",
                 "the headers read " & $configured.getExtraHeaders()
        doAssert configured.getConnectionTimeoutMs() == 2500,
                 "the timeout is " & $configured.getConnectionTimeoutMs()
        doAssert configured.getNumRedirectsToFollow() == 3,
                 "the redirect count is " & $configured.getNumRedirectsToFollow()
        doAssert $configured.getHttpRequestCmd() == "POST",
                 "the request command is " & $configured.getHttpRequestCmd()

        # The builder copies rather than mutating, so the original is untouched.
        doAssert $plain.getExtraHeaders() == "",
                 "withExtraHeaders changed the object it was called on"

        # A two-argument closure, reached back through the options and called.
        var seen: seq[(cint, cint)] = @[]
        let watched = plain.withProgressCallback(
            bindClosure(proc(sent: cint, total: cint): bool =
                seen.add((sent, total))
                true))
        var callback = watched.getProgressCallback()
        doAssert callback(10.cint, 100.cint), "the callback reported failure"
        doAssert seen == @[(10.cint, 100.cint)],
                 "the callback saw " & $seen

testUrlInputStreamOptions()

# The nested abstract classes =================================================
#
# The subclass generator keyed an abstract class on its own spelling, which
# never matched a declared Nim name for a nested one, so every Listener,
# LookAndFeelMethods and other nested interface was skipped with no withheld
# entry. Building each compiles the C++ class, and setting each handler is what
# type-checks and generates the setter.

proc testNestedSubclassesCore() =

    block:
        var customExpressionScopeVisitor = newCustomExpressionScopeVisitor()
        doAssert not customExpressionScopeVisitor.isNil(), "newCustomExpressionScopeVisitor built nothing"
        customExpressionScopeVisitor[].setVisitHandler(proc(arg0: ptr ExpressionScope) = discard)
        cdelete customExpressionScopeVisitor
        var customThreadListener = newCustomThreadListener()
        doAssert not customThreadListener.isNil(), "newCustomThreadListener built nothing"
        customThreadListener[].setExitSignalSentHandler(proc() = discard)
        cdelete customThreadListener
        var customThreadPoolJobSelector = newCustomThreadPoolJobSelector()
        doAssert not customThreadPoolJobSelector.isNil(), "newCustomThreadPoolJobSelector built nothing"
        customThreadPoolJobSelector[].setIsJobSuitableHandler(proc(job: ptr ThreadPoolJob): bool = false)
        cdelete customThreadPoolJobSelector
        var customURLDownloadTaskListener = newCustomURLDownloadTaskListener()
        doAssert not customURLDownloadTaskListener.isNil(), "newCustomURLDownloadTaskListener built nothing"
        customURLDownloadTaskListener[].setFinishedHandler(proc(task: ptr URLDownloadTask, success: bool) = discard)
        cdelete customURLDownloadTaskListener


testNestedSubclassesCore()

# FileSearchPath ==============================================================
#
# A list of directories with real filesystem behaviour behind it, so the
# answers are about directories that exist rather than about strings.

proc testFileSearchPath() =
    block:
        let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                       .getNonexistentChildFile(makeString("june-search"), makeString(""))
        doAssert root.createDirectory().wasOk(), "could not make the temp directory"
        let inner = root.getChildFile(makeStringRef("inner"))
        doAssert inner.createDirectory().wasOk(), "could not make the inner directory"
        let gone = root.getChildFile(makeStringRef("gone"))

        var path = makeFileSearchPath()
        doAssert path.getNumPaths() == 0,
                 "a fresh path holds " & $path.getNumPaths() & " directories"

        path.add(root)
        path.add(inner)
        doAssert path.getNumPaths() == 2,
                 "the path holds " & $path.getNumPaths() & " directories"
        doAssert path[0.cint] == root, "the first entry is not the root"

        # Adding the same directory twice is refused by addIfNotAlreadyThere
        # and allowed by add, which is the difference between them.
        doAssert not path.addIfNotAlreadyThere(root),
                 "adding a directory already in the path reported success"
        doAssert path.getNumPaths() == 2,
                 "addIfNotAlreadyThere left " & $path.getNumPaths() & " directories"
        path.add(root)
        doAssert path.getNumPaths() == 3,
                 "add refused a duplicate, leaving " & $path.getNumPaths()

        path.removeRedundantPaths()
        doAssert path.getNumPaths() < 3,
                 "removing redundant paths left all " & $path.getNumPaths() & " of them"

        # A directory that does not exist is dropped, and one that does is kept.
        path.add(gone)
        let beforePruning = path.getNumPaths()
        path.removeNonExistentPaths()
        doAssert path.getNumPaths() == beforePruning - 1,
                 "pruning removed " & $(beforePruning - path.getNumPaths()) &
                 " of the paths"

        # A file under a directory in the path is in the path, recursively.
        let deep = inner.getChildFile(makeStringRef("deep.txt"))
        doAssert deep.replaceWithText(makeString("x")), "could not write deep.txt"
        doAssert path.isFileInPath(deep, true),
                 "a file under a directory in the path was not found"
        doAssert not path.isFileInPath(
                     june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                         .getChildFile(makeStringRef("june-not-in-path.txt")), true),
                 "a file outside the path was found in it"

        doAssert root.deleteRecursively(), "could not remove the temp directory"

testFileSearchPath()

# Every no-argument constructor ===============================================
#
# An importcpp string reaches the C++ compiler only at a call site, so a
# constructor nothing calls is never compiled. These had no caller.

proc testEveryNoArgConstructorCore() =

    block:
        discard makeCriticalSection()
        discard makeDummyCriticalSection()
        discard makeErasedScopeGuard()
        discard makeRangedDirectoryIterator()
        discard makeTemporaryFile()
        discard makeExpressionScope()
        discard makeChildProcess()
        discard makeDynamicLibrary()
        discard makeSpinLock()
        discard makeReadWriteLock()
        discard makeMACAddress()
        discard makeNamedPipe()
        discard makeStreamingSocket()
        discard makeDatagramSocket()
        discard makeUnitTestRunnerTestResult()
        discard makeZipFileBuilder()
        discard makeAndroidDocumentInfo()
        discard makeAndroidDocument()
        discard makeAndroidDocumentIterator()


testEveryNoArgConstructorCore()

# The file streams ============================================================
#
# A real write followed by a real read, so the assertions are about bytes that
# reached the disk rather than about a buffer. BufferedInputStream wraps the
# reader, and has to give the same answers as the stream underneath it.

proc testFileStreams() =
    block:
        let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                       .getNonexistentChildFile(makeString("june-streams"), makeString(""))
        doAssert root.createDirectory().wasOk(), "could not make the temp directory"
        let target = root.getChildFile(makeStringRef("lines.txt"))

        block:
            var writer = makeFileOutputStream(target, 1024'u64)
            doAssert writer.openedOk(), "the file did not open for writing"
            doAssert writer.writeText(makeString("first\n"), false, false, "\n".toConstChar),
                     "writing the first line failed"
            doAssert writer.writeText(makeString("second\n"), false, false, "\n".toConstChar),
                     "writing the second line failed"
            writer.flush()
            doAssert writer.getPosition() == 13'i64,
                     "the writer is at " & $writer.getPosition() & " bytes"

        doAssert target.getSize() == 13'i64,
                 "the file holds " & $target.getSize() & " bytes"

        block:
            var reader = makeFileInputStream(target)
            doAssert reader.openedOk(), "the file did not open for reading"
            doAssert reader.getTotalLength() == 13'i64,
                     "the reader sees " & $reader.getTotalLength() & " bytes"
            doAssert $reader.readNextLine() == "first",
                     "the first line reads " & $reader.readNextLine()
            doAssert reader.getPosition() > 0'i64,
                     "the reader did not advance"
            doAssert $reader.readNextLine() == "second",
                     "the second line is not what was written"
            doAssert reader.isExhausted(), "the reader has more after two lines"

            # Seeking back gives the same bytes again, which says the position
            # is real rather than a counter.
            doAssert reader.setPosition(0'i64), "seeking to the start failed"
            doAssert $reader.readEntireStreamAsString() == "first\nsecond\n",
                     "the whole file reads back differently"

        block:
            # The buffered wrapper answers the same as the stream underneath.
            var source = makeFileInputStream(target)
            var buffered = makeBufferedInputStream(source, 4.cint)
            doAssert buffered.getTotalLength() == 13'i64,
                     "the buffered stream sees " & $buffered.getTotalLength() & " bytes"
            doAssert $buffered.readNextLine() == "first",
                     "the buffered stream read something else"

        doAssert root.deleteRecursively(), "could not remove the temp directory"

testFileStreams()

# LocalisedStrings ============================================================
#
# A translation table parsed from JUCE's own .lang format, so the assertions
# are about text that came back through the parser rather than a map that was
# filled by hand.

proc testLocalisedStrings() =
    block:
        let table = """language: Pirate
countries: pi

"Open" = "Broach"
"Save" = "Stow"
"""
        var strings = makeLocalisedStrings(makeString(table), false)

        doAssert $strings.getLanguageName() == "Pirate",
                 "the language is " & $strings.getLanguageName()
        doAssert strings.getCountryCodes().size() == 1,
                 "the table names " & $strings.getCountryCodes().size() & " countries"
        doAssert $strings.getCountryCodes()[0.cint] == "pi",
                 "the country is " & $strings.getCountryCodes()[0.cint]

        doAssert $strings.translate(makeString("Open")) == "Broach",
                 "Open translates to " & $strings.translate(makeString("Open"))
        doAssert $strings.translate(makeString("Save")) == "Stow",
                 "Save translates to " & $strings.translate(makeString("Save"))

        # A word with no entry comes back unchanged, which is what makes a
        # missing translation harmless.
        doAssert $strings.translate(makeString("Quit")) == "Quit",
                 "an untranslated word became " & $strings.translate(makeString("Quit"))
        doAssert $strings.translate(makeString("Quit"), makeString("Abandon ship")) ==
                 "Abandon ship",
                 "the fallback for an untranslated word was ignored"

        doAssert strings.getMappings().size() == 2,
                 "the table holds " & $strings.getMappings().size() & " mappings"

        # A second table merged in adds its entries without dropping the first.
        let extra = """language: Pirate
countries: pi

"Quit" = "Abandon ship"
"""
        strings.addStrings(makeLocalisedStrings(makeString(extra), false))
        doAssert $strings.translate(makeString("Quit")) == "Abandon ship",
                 "the merged entry is missing"
        doAssert $strings.translate(makeString("Open")) == "Broach",
                 "merging dropped the original entry"

testLocalisedStrings()

# The GZIP streams and SubregionStream ========================================
#
# A compress-then-decompress round trip, so the assertion is that the bytes
# came back rather than that something was written. The text is repetitive on
# purpose: compressed output has to be smaller than the input, which says the
# compressor really ran.

proc testCompressionAndSubregion() =
    block:
        let original = makeString("june june june june june june june june june june")
        var compressed = makeMemoryBlock()

        block:
            var sink = makeMemoryOutputStream(compressed, false)
            var deflater = makeGZIPCompressorOutputStream(sink, 9.cint, 15.cint)
            doAssert deflater.writeText(original, false, false, "\n".toConstChar),
                     "writing to the compressor failed"
            deflater.flush()

        doAssert compressed.getSize() > 0,
                 "the compressor produced " & $compressed.getSize() & " bytes"
        doAssert compressed.getSize().int < original.length(),
                 "compressing " & $original.length() & " bytes gave " &
                 $compressed.getSize() & ", which is no smaller"

        block:
            var source = makeMemoryInputStream(compressed, false)
            var inflater = makeGZIPDecompressorInputStream(source)
            doAssert $inflater.readEntireStreamAsString() == $original,
                     "the round trip did not give the text back"

    block:
        # A subregion is a window onto part of another stream, so it reports
        # its own length and reads only what is inside it.
        var digits = makeMemoryBlock()
        block:
            var writer = makeMemoryOutputStream(digits, false)
            doAssert writer.writeText(makeString("0123456789"), false, false,
                                      "\n".toConstChar),
                     "writing the digits failed"
            writer.flush()

        var whole = makeMemoryInputStream(digits, false)
        var middle = makeSubregionStream(
            cast[ptr InputStream](addr whole), 3'i64, 4'i64, false)

        doAssert middle.getTotalLength() == 4'i64,
                 "the subregion is " & $middle.getTotalLength() & " bytes"
        doAssert $middle.readEntireStreamAsString() == "3456",
                 "the subregion reads " & $middle.readEntireStreamAsString()

testCompressionAndSubregion()

# FileLogger ==================================================================
#
# Writes through to a file, so the assertions read the file back rather than
# asking the logger what it thinks it wrote.

proc testFileLogger() =
    block:
        let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                       .getNonexistentChildFile(makeString("june-logs"), makeString(""))
        doAssert root.createDirectory().wasOk(), "could not make the temp directory"
        let logFile = root.getChildFile(makeStringRef("session.log"))

        block:
            var logger = makeFileLogger(logFile, makeString("welcome"), 0'i64)
            doAssert logger.getLogFile() == logFile,
                     "the logger writes to " & $logger.getLogFile().getFullPathName()
            logger.logMessage(makeString("first message"))
            logger.logMessage(makeString("second message"))

        doAssert logFile.existsAsFile(), "the logger never created its file"
        let written = logFile.loadFileAsString()
        doAssert "welcome" in $written,
                 "the welcome message is missing from the log"
        doAssert "first message" in $written,
                 "the first message is missing from the log"
        doAssert "second message" in $written,
                 "the second message is missing from the log"

        # Order matters: a log that appended in the wrong order would still
        # contain both.
        doAssert ($written).find("first message") < ($written).find("second message"),
                 "the messages are in the wrong order"

        doAssert root.deleteRecursively(), "could not remove the temp directory"

testFileLogger()

# The small core classes ======================================================
#
# Five classes whose answers are exact: a filter that accepts one name and
# refuses another, an event that a wait can time out on, a file mapped into
# memory whose bytes are the ones on disk, and two value types.

proc testSmallCoreClasses() =
    block:
        # A filter takes patterns, so it has to accept one name and refuse
        # another rather than accepting everything.
        let filter = makeWildcardFileFilter(makeString("*.txt"), makeString("*"),
                                            makeString("text files"))
        let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                       .getNonexistentChildFile(makeString("june-small"), makeString(""))
        doAssert root.createDirectory().wasOk(), "could not make the temp directory"

        let accepted = root.getChildFile(makeStringRef("notes.txt"))
        let refused = root.getChildFile(makeStringRef("notes.dat"))
        doAssert accepted.replaceWithText(makeString("hello")), "could not write notes.txt"
        doAssert refused.replaceWithText(makeString("hello")), "could not write notes.dat"

        doAssert filter.isFileSuitable(accepted), "the filter refused notes.txt"
        doAssert not filter.isFileSuitable(refused), "the filter accepted notes.dat"
        doAssert filter.isDirectorySuitable(root), "the filter refused a directory"

        # An input source hands back a stream over the same file.
        var source = makeFileInputSource(accepted, false)
        var stream = source.createInputStream()
        doAssert stream != nil, "the input source produced no stream"
        doAssert $stream[].readEntireStreamAsString() == "hello",
                 "the stream read something else"
        cdelete stream
        doAssert source.hashCode() != 0'i64, "the input source hashes to zero"

        # The same file mapped into memory has the bytes that were written.
        block:
            let mapped = makeMemoryMappedFile(
                accepted, MemoryMappedFileAccessMode_readOnly, false)
            doAssert mapped.getSize() == 5'u64,
                     "the mapping is " & $mapped.getSize() & " bytes"
            let bytes = cast[ptr UncheckedArray[char]](mapped.getData())
            doAssert bytes[0] == 'h' and bytes[4] == 'o',
                     "the mapped bytes are not the ones written"

        doAssert root.deleteRecursively(), "could not remove the temp directory"

    block:
        # Manual reset, so the event stays signalled until it is reset.
        let event = makeWaitableEvent(true)
        doAssert not event.wait(1.0), "an unsignalled event let a wait through"
        event.signal()
        doAssert event.wait(1.0), "a signalled event blocked a wait"
        doAssert event.wait(1.0), "a manual-reset event cleared itself"
        event.reset()
        doAssert not event.wait(1.0), "the event stayed signalled after a reset"

    block:
        var symbol = makeExpressionSymbol(makeString("scope"), makeString("width"))
        doAssert $symbol.scopeUID() == "scope",
                 "the symbol names scope " & $symbol.scopeUID()
        doAssert $symbol.symbolName() == "width",
                 "the symbol is called " & $symbol.symbolName()
        symbol.symbolName = makeString("height")
        doAssert $symbol.symbolName() == "height",
                 "after renaming the symbol is called " & $symbol.symbolName()

testSmallCoreClasses()

# The scoped try-locks ========================================================
#
# A try-lock reports whether it got the lock rather than blocking. JUCE grants
# a write lock to a thread that already holds the only read lock -
# tryEnterWriteInternal takes that branch explicitly - so a single-threaded
# test sees the upgrade rather than a refusal, and that is what is asserted.

proc testScopedTryLocks() =
    block:
        var lock = makeReadWriteLock()

        block:
            var reader = makeScopedTryReadLock(lock)
            doAssert reader.isLocked(), "the read lock was not taken"

            # Read locks share, so a second reader on this thread is fine.
            var alsoReader = makeScopedTryReadLock(lock)
            doAssert alsoReader.isLocked(), "a second reader was refused"

            # And this thread can upgrade to the write lock, because it is the
            # only reader.
            var writer = makeScopedTryWriteLock(lock)
            doAssert writer.isLocked(),
                     "the only reader could not upgrade to a write lock"

        block:
            var writer = makeScopedTryWriteLock(lock)
            doAssert writer.isLocked(),
                     "the write lock was refused after the readers went"

        # Built without acquiring, so it starts unlocked and retryLock takes it.
        block:
            var later = makeScopedTryWriteLock(lock, false)
            doAssert not later.isLocked(),
                     "a lock built with acquireLockOnInitialisation false was taken"
            doAssert later.retryLock(), "retryLock did not take a free lock"
            doAssert later.isLocked(), "retryLock reported success and did not lock"

        block:
            var laterRead = makeScopedTryReadLock(lock, false)
            doAssert not laterRead.isLocked(),
                     "a read lock built without acquiring was taken"
            doAssert laterRead.retryLock(), "retryLock did not take a free read lock"

    block:
        # An inter-process lock over a name nothing else holds.
        var lock = makeInterProcessLock(makeString("june-test-lock"))
        doAssert lock.enter(1000.cint), "the inter-process lock was refused"
        lock.exit()

        # The scoped form takes it on construction and reports that it did.
        var scoped = makeInterProcessLockScopedLockType(lock)
        doAssert scoped.isLocked(),
                 "the scoped inter-process lock was not taken"

testScopedTryLocks()

# File::NaturalFileComparator =================================================
#
# Natural ordering puts file2 before file10, which a plain string comparison
# would not, and the folders-first flag changes the answer for a directory
# against a file.

proc testNaturalFileComparator() =
    block:
        let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                       .getNonexistentChildFile(makeString("june-sort"), makeString(""))
        doAssert root.createDirectory().wasOk(), "could not make the temp directory"

        let second = root.getChildFile(makeStringRef("file2.txt"))
        let tenth = root.getChildFile(makeStringRef("file10.txt"))
        doAssert second.replaceWithText(makeString("2")), "could not write file2"
        doAssert tenth.replaceWithText(makeString("10")), "could not write file10"
        let folder = root.getChildFile(makeStringRef("aaa"))
        doAssert folder.createDirectory().wasOk(), "could not make the folder"

        var natural = makeFileNaturalFileComparator(true)
        doAssert natural.foldersFirst(), "the comparator forgot foldersFirst"

        # 2 before 10: a plain string comparison would put "file10" first.
        doAssert natural.compareElements(second, tenth) < 0,
                 "file2 did not sort before file10"
        doAssert natural.compareElements(tenth, second) > 0,
                 "the comparison is not symmetric"

        # With folders first, the directory wins however its name sorts.
        doAssert natural.compareElements(folder, second) < 0,
                 "the folder did not sort before the file"

        natural.foldersFirst = false
        doAssert not natural.foldersFirst(), "the flag did not change"
        doAssert natural.compareElements(folder, second) < 0,
                 "aaa should still sort before file2 by name"
        doAssert natural.compareElements(second, folder) > 0,
                 "the comparison is not symmetric without foldersFirst"

        doAssert root.deleteRecursively(), "could not remove the temp directory"

testNaturalFileComparator()

# URLInputSource ==============================================================
#
# Built over a URL rather than a File. No network is touched: the source is
# asked what it hashes to and what a related path resolves to, both of which
# are string work.

proc testUrlInputSource() =
    block:
        let page = makeURL(makeString("https://example.invalid/docs/index.html"))
        doAssert $page.toString(false) == "https://example.invalid/docs/index.html",
                 "the URL reads " & $page.toString(false)

        var source = makeURLInputSource(page)
        doAssert source.hashCode() != 0'i64, "the source hashes to zero"

        # Two sources over the same URL agree, and one over a different URL
        # does not - which says the hash is of the URL rather than of nothing.
        var same = makeURLInputSource(makeURL(
            makeString("https://example.invalid/docs/index.html")))
        doAssert same.hashCode() == source.hashCode(),
                 "two sources over the same URL hash differently"

        var other = makeURLInputSource(makeURL(
            makeString("https://example.invalid/docs/other.html")))
        doAssert other.hashCode() != source.hashCode(),
                 "sources over different URLs hash the same"

testUrlInputSource()

# Every bound constant ========================================================
#
# A `let` with an importcpp is not checked against C++ unless something reads
# it: a constant naming juce::NoSuchClass::nope compiles clean while nothing
# touches it. Reading each is what compiles the spelling.

proc testEveryConstantCore() =
    block:
        discard IncrementRef_no
        discard IncrementRef_yes
        discard SystemStatsOperatingSystemType_UnknownOS
        discard SystemStatsOperatingSystemType_MacOSX
        discard SystemStatsOperatingSystemType_Windows
        discard SystemStatsOperatingSystemType_Linux
        discard SystemStatsOperatingSystemType_Android
        discard SystemStatsOperatingSystemType_iOS
        discard SystemStatsOperatingSystemType_WASM
        discard SystemStatsOperatingSystemType_MacOSX_10_7
        discard SystemStatsOperatingSystemType_MacOSX_10_8
        discard SystemStatsOperatingSystemType_MacOSX_10_9
        discard SystemStatsOperatingSystemType_MacOSX_10_10
        discard SystemStatsOperatingSystemType_MacOSX_10_11
        discard SystemStatsOperatingSystemType_MacOSX_10_12
        discard SystemStatsOperatingSystemType_MacOSX_10_13
        discard SystemStatsOperatingSystemType_MacOSX_10_14
        discard SystemStatsOperatingSystemType_MacOSX_10_15
        discard SystemStatsOperatingSystemType_MacOS_11
        discard SystemStatsOperatingSystemType_MacOS_12
        discard SystemStatsOperatingSystemType_MacOS_13
        discard SystemStatsOperatingSystemType_MacOS_14
        discard SystemStatsOperatingSystemType_MacOS_15
        discard SystemStatsOperatingSystemType_MacOS_26
        discard SystemStatsOperatingSystemType_Win2000
        discard SystemStatsOperatingSystemType_WinXP
        discard SystemStatsOperatingSystemType_WinVista
        discard SystemStatsOperatingSystemType_Windows7
        discard SystemStatsOperatingSystemType_Windows8_0
        discard SystemStatsOperatingSystemType_Windows8_1
        discard SystemStatsOperatingSystemType_Windows10
        discard SystemStatsOperatingSystemType_Windows11
        discard SystemStatsMachineIdFlags_macAddresses
        discard SystemStatsMachineIdFlags_fileSystemId
        discard SystemStatsMachineIdFlags_legacyUniqueId
        discard SystemStatsMachineIdFlags_uniqueId
        discard JSONSpacing_none
        discard JSONSpacing_singleLine
        discard JSONSpacing_multiLine
        discard JSONEncoding_utf8
        discard JSONEncoding_ascii
        discard FileTypesOfFileToFind_findDirectories
        discard FileTypesOfFileToFind_findFiles
        discard FileTypesOfFileToFind_findFilesAndDirectories
        discard FileTypesOfFileToFind_ignoreHiddenFiles
        discard FileFollowSymlinks_no
        discard FileFollowSymlinks_noCycles
        discard FileFollowSymlinks_yes
        discard FileSpecialLocationType_userHomeDirectory
        discard FileSpecialLocationType_userDocumentsDirectory
        discard FileSpecialLocationType_userDesktopDirectory
        discard FileSpecialLocationType_userMusicDirectory
        discard FileSpecialLocationType_userMoviesDirectory
        discard FileSpecialLocationType_userPicturesDirectory
        discard FileSpecialLocationType_userApplicationDataDirectory
        discard FileSpecialLocationType_commonApplicationDataDirectory
        discard FileSpecialLocationType_commonDocumentsDirectory
        discard FileSpecialLocationType_tempDirectory
        discard FileSpecialLocationType_currentExecutableFile
        discard FileSpecialLocationType_currentApplicationFile
        discard FileSpecialLocationType_invokedExecutableFile
        discard FileSpecialLocationType_hostApplicationPath
        discard FileSpecialLocationType_globalApplicationsDirectory
        discard MemoryMappedFileAccessMode_readOnly
        discard MemoryMappedFileAccessMode_readWrite
        discard TemporaryFileOptionFlags_useHiddenFile
        discard TemporaryFileOptionFlags_putNumbersInBrackets
        discard ExpressionType_constantType
        discard ExpressionType_functionType
        discard ExpressionType_operatorType
        discard ExpressionType_symbolType
        discard RuntimePermissionsPermissionID_recordAudio
        discard RuntimePermissionsPermissionID_bluetoothMidi
        discard RuntimePermissionsPermissionID_readExternalStorage
        discard RuntimePermissionsPermissionID_writeExternalStorage
        discard RuntimePermissionsPermissionID_camera
        discard RuntimePermissionsPermissionID_readMediaAudio
        discard RuntimePermissionsPermissionID_readMediaImages
        discard RuntimePermissionsPermissionID_readMediaVideo
        discard RuntimePermissionsPermissionID_postNotification
        discard ChildProcessStreamFlags_wantStdOut
        discard ChildProcessStreamFlags_wantStdErr
        discard ProcessProcessPriority_LowPriority
        discard ProcessProcessPriority_NormalPriority
        discard ProcessProcessPriority_HighPriority
        discard ProcessProcessPriority_RealtimePriority
        discard ThreadPriority_highest
        discard ThreadPriority_high
        discard ThreadPriority_normal
        discard ThreadPriority_low
        discard ThreadPriority_background
        discard ThreadPoolJobJobStatus_jobHasFinished
        discard ThreadPoolJobJobStatus_jobNeedsRunningAgain
        discard URLParameterHandling_inAddress
        discard URLParameterHandling_inPostData
        discard GZIPCompressorOutputStreamWindowBitsValues_windowBitsRaw
        discard GZIPCompressorOutputStreamWindowBitsValues_windowBitsGZIP
        discard GZIPDecompressorInputStreamFormat_zlibFormat
        discard GZIPDecompressorInputStreamFormat_deflateFormat
        discard GZIPDecompressorInputStreamFormat_gzipFormat
        discard ZipFileOverwriteFiles_no
        discard ZipFileOverwriteFiles_yes
        discard ZipFileFollowSymlinks_no
        discard ZipFileFollowSymlinks_yes

testEveryConstantCore()

# Every static variable =======================================================
#
# Bound as a proc over the typedesc, so it is compiled only where it is called,
# exactly like the constants. Reading each is what checks its C++ spelling.

proc testEveryStaticVariableCore() =
    block:
        discard Thread.`osDefaultStackSize`()

testEveryStaticVariableCore()

# Every getter on a value class ===============================================
#
# A proc with an importcpp is compiled only at a call site, so a getter nothing
# reads is never checked against C++. These classes are pure values - building
# one starts no thread and opens no socket - so reading every getter on a
# default-built one is safe. The sweep is deliberately not over every class:
# makeThreadPool starts threads and makeStreamingSocket does real work.
#
# Two calls are left out of it. Expression.getSymbolOrFunction on an expression
# that is not a function trips a jassertfalse that says so in as many words,
# and Time.setSystemTimeToThisTime would set the machine's clock - it is a
# jassertfalse on macOS and a real attempt elsewhere.
#
# Unlike the constant and static-variable sweeps this one carries no checker:
# which classes are safe to build and read blindly is a judgement rather than a
# rule, so a getter added to one of these later is not swept automatically.
#
# String.convertToPrecomposedUnicode is left out because JUCE declares it on
# macOS only, and the committed generated files are the macOS output.

proc testEveryValueGetter() =
    block:
        let argumentListArgumentValue = makeArgumentListArgument()
        discard argumentListArgumentValue.`resolveAsFile`()
        discard argumentListArgumentValue.`resolveAsExistingFile`()
        discard argumentListArgumentValue.`resolveAsExistingFolder`()
        discard argumentListArgumentValue.`isLongOption`()
        discard argumentListArgumentValue.`isShortOption`()
        discard argumentListArgumentValue.`getLongOptionValue`()
        discard argumentListArgumentValue.`isOption`()
        let bigIntegerValue = makeBigInteger()
        discard bigIntegerValue.`countNumberOfSetBits`()
        discard bigIntegerValue.`getHighestBit`()
        discard bigIntegerValue.`isNegative`()
        discard bigIntegerValue.`toMemoryBlock`()
        let consoleApplicationCommandValue = makeConsoleApplicationCommand()
        discard consoleApplicationCommandValue.`argumentDescription`()
        discard consoleApplicationCommandValue.`shortDescription`()
        discard consoleApplicationCommandValue.`longDescription`()
        let expressionValue = makeExpression()
        discard expressionValue.`usesAnySymbols`()
        discard expressionValue.`getNumInputs`()
        let iPAddressValue = makeIPAddress()
        discard iPAddressValue.`isIPv6`()
        let identifierValue = makeIdentifier()
        discard identifierValue.`toCharPointer_UTF8`()
        let mACAddressValue = makeMACAddress()
        discard mACAddressValue.`getBytes`()
        let memoryBlockValue = makeMemoryBlock()
        discard memoryBlockValue.`toBase64Encoding`()
        let namedValueSetValue = makeNamedValueSet()
        discard namedValueSetValue.`asSpan`()
        let randomValue = makeRandom()
        discard randomValue.`getSeed`()
        let relativeTimeValue = makeRelativeTime()
        discard relativeTimeValue.`inMilliseconds`()
        discard relativeTimeValue.`inMinutes`()
        discard relativeTimeValue.`inHours`()
        discard relativeTimeValue.`inDays`()
        discard relativeTimeValue.`inWeeks`()
        discard relativeTimeValue.`getApproximateDescription`()
        let stringValue = makeString()
        discard stringValue.`hashCode64`()
        discard stringValue.`containsNonWhitespaceChars`()
        discard stringValue.`getLastCharacter`()
        discard stringValue.`trim`()
        discard stringValue.`trimStart`()
        discard stringValue.`trimEnd`()
        discard stringValue.`isQuotedString`()
        discard stringValue.`unquoted`()
        discard stringValue.`getLargeIntValue`()
        discard stringValue.`getTrailingIntValue`()
        discard stringValue.`getFloatValue`()
        discard stringValue.`getDoubleValue`()
        discard stringValue.`getHexValue32`()
        discard stringValue.`getHexValue64`()
        discard stringValue.`toUTF8`()
        discard stringValue.`toRawUTF8Impl`()
        discard stringValue.`toUTF16`()
        discard stringValue.`toUTF32`()
        discard stringValue.`toWideCharPointer`()
        discard stringValue.`getNumBytesAsUTF8`()
        discard stringValue.`getReferenceCount`()
        let stringPairArrayValue = makeStringPairArray(true)
        discard stringPairArrayValue.`getIgnoresCase`()
        let textDiffChangeValue = makeTextDiffChange()
        discard textDiffChangeValue.`isDeletion`()
        let threadPoolOptionsValue = makeThreadPoolOptions()
        discard threadPoolOptionsValue.`numberOfThreads`()
        discard threadPoolOptionsValue.`threadStackSizeBytes`()
        discard threadPoolOptionsValue.`desiredThreadPriority`()
        let timeValue = makeTime()
        discard timeValue.`getDayOfWeek`()
        discard timeValue.`getDayOfYear`()
        discard timeValue.`isAfternoon`()
        discard timeValue.`getHoursInAmPmFormat`()
        discard timeValue.`getMilliseconds`()
        discard timeValue.`isDaylightSavingTime`()
        discard timeValue.`getTimeZone`()
        discard timeValue.`getUTCOffsetSeconds`()
        let uRLDownloadTaskOptionsValue = makeURLDownloadTaskOptions()
        discard uRLDownloadTaskOptionsValue.`sharedContainer`()
        discard uRLDownloadTaskOptionsValue.`usePost`()
        let unitTestRunnerTestResultValue = makeUnitTestRunnerTestResult()
        discard unitTestRunnerTestResultValue.`startTime`()
        discard unitTestRunnerTestResultValue.`endTime`()
        let uuidValue = makeUuid()
        discard uuidValue.`getTimeLow`()
        discard uuidValue.`getTimeMid`()
        discard uuidValue.`getTimeHighAndVersion`()
        discard uuidValue.`getClockSeqAndReserved`()
        discard uuidValue.`getClockSeqLow`()
        discard uuidValue.`getNode`()
        discard uuidValue.`getRawData`()
        let xmlElementTextFormatValue = makeXmlElementTextFormat()
        discard xmlElementTextFormatValue.`dtd`()
        discard xmlElementTextFormatValue.`customHeader`()
        discard xmlElementTextFormatValue.`customEncoding`()
        discard xmlElementTextFormatValue.`addDefaultHeader`()
        discard xmlElementTextFormatValue.`lineWrapLength`()
        discard xmlElementTextFormatValue.`newLineChars`()
        discard xmlElementTextFormatValue.`singleLine`()
        discard xmlElementTextFormatValue.`withoutHeader`()
        let zipFileZipEntryValue = makeZipFileZipEntry()
        discard zipFileZipEntryValue.`uncompressedSize`()
        discard zipFileZipEntryValue.`fileTime`()
        discard zipFileZipEntryValue.`isSymbolicLink`()
        discard zipFileZipEntryValue.`externalFileAttributes`()
        let juce_varValue = makejuce_var()
        discard juce_varValue.`getBinaryData`()
        discard juce_varValue.`getObject`()
        discard juce_varValue.`getDynamicObject`()
        discard juce_varValue.`isVoid`()
        discard juce_varValue.`isUndefined`()
        discard juce_varValue.`isInt64`()
        discard juce_varValue.`isBool`()
        discard juce_varValue.`isDouble`()
        discard juce_varValue.`isArray`()
        discard juce_varValue.`isBinaryData`()
        discard juce_varValue.`isMethod`()
        discard juce_varValue.`getObjectElements`()
        discard juce_varValue.`getNativeFunction`()

testEveryValueGetter()

# WebInputStream, without connecting ==========================================
#
# Everything here is request-side state, so no network is touched: the builders
# return the stream itself and getRequestHeaders reads back what was set.
# connect, getStatusCode, getTotalLength, getResponseHeaders and read are left
# alone. Three of those open a connection without saying so in their name:
# JUCE's getResponseHeaders, getTotalLength and read each call connect(nullptr)
# first, so reading a "property" off one of them would go to the network.

proc testWebInputStreamRequestSide() =
    block:
        let target = makeURL(makeString("https://example.invalid/api"))
        var request = makeWebInputStream(target, false)

        # A stream that has not connected is already in the error state: JUCE
        # reads it straight off the platform implementation, which has nothing
        # to report success about yet.
        doAssert request.isError(),
                 "a stream that never connected reports no error"

        # The builders hand back the same stream, so they chain.
        discard request
            .withExtraHeaders(makeString("X-June: 1\r\nX-Other: 2"))
            .withCustomRequestCommand(makeString("PUT"))
            .withConnectionTimeout(2500.cint)
            .withNumRedirectsToFollow(3.cint)

        let headers = request.getRequestHeaders()
        doAssert headers.size() == 2,
                 "the request carries " & $headers.size() & " headers"
        doAssert $headers.getValue(makeString("X-June"), makeString("")) == "1",
                 "X-June reads " &
                 $headers.getValue(makeString("X-June"), makeString(""))
        doAssert $headers.getValue(makeString("X-Other"), makeString("")) == "2",
                 "X-Other reads " &
                 $headers.getValue(makeString("X-Other"), makeString(""))

        # Cancelling a stream that never connected is harmless.
        request.cancel()
        doAssert request.isError(),
                 "a cancelled stream does not report an error"

testWebInputStreamRequestSide()

# The scoped helpers and the remaining statics ================================
#
# RAII types that do their work in a constructor and a destructor, so building
# one is most of what there is to check.

proc testScopedHelpers() =
    block:
        # A scoped lock over a ReadWriteLock takes it and gives it back.
        var lock = makeReadWriteLock()
        block:
            # Held, so a second reader is granted and the lock is not free.
            let reader = makeScopedReadLock(lock)
            doAssert lock.tryEnterRead(), "a second reader was refused"
            lock.exitRead()
        # Released by the scope ending, so a writer gets it outright.
        doAssert lock.tryEnterWrite(),
                 "the write lock was refused after the scoped reader ended"
        lock.exitWrite()

        block:
            let writer = makeScopedWriteLock(lock)
            discard writer
        doAssert lock.tryEnterWrite(),
                 "the write lock was refused after the scoped writer ended"
        lock.exitWrite()

        # The dummy critical section is the no-op lock JUCE uses where a
        # container is told it needs no locking.
        let dummy = makeDummyCriticalSection()
        let dummyScoped = makeDummyCriticalSectionScopedLockType(dummy)
        discard dummyScoped

        # A time measurement writes the elapsed seconds into the variable it
        # was given, when it goes out of scope.
        var elapsed = -1.0
        block:
            let measured = makeScopedTimeMeasurement(elapsed)
            discard measured
        doAssert elapsed >= 0.0,
                 "the measurement left " & $elapsed & " seconds behind"

        # JSONUtils::makeObjectWithKeyFirst reorders a JSON object so one key
        # comes first.
        var members = makeCppMap[Identifier, juce_var]()
        let reordered = JSONUtils.makeObjectWithKeyFirst(
            members, makeIdentifier(makeString("id")))
        doAssert reordered.isObject(),
                 "reordering an empty map did not give an object back"

        Process.makeForegroundProcess()

        # AndroidDocumentIterator's factory. The document is empty on a
        # desktop build, so the iterator is the end one, but the binding is
        # compiled either way.
        let emptyDocument = makeAndroidDocument()
        let documentIterator = AndroidDocumentIterator.makeNonRecursive(emptyDocument)
        discard documentIterator

testScopedHelpers()

# The derived comparison operators ============================================
#
# 37 procs are withheld with the reason "Nim derives > and >= from < and <=",
# and 71 more with "Nim derives != from ==". Nothing had checked that the
# derivation happens, which is the whole basis for leaving them out.

proc testDerivedOperators() =
    block:
        let first = makeFile(makeString("/aaa"))
        let second = makeFile(makeString("/bbb"))

        doAssert first < second, "aaa did not sort before bbb"
        doAssert second > first, "the derived > disagrees with the bound <"
        doAssert not (second < first), "the comparison is not antisymmetric"

        # JUCE declares no operator<= for File, so no >= derives either. That
        # is faithful rather than a gap: the C++ class has neither.
        doAssert not compiles(first >= second),
                 ">= exists for a class JUCE gives no <="

    block:
        # != comes from ==, for a class that has one.
        let one = makeIdentifier(makeString("alpha"))
        let same = makeIdentifier(makeString("alpha"))
        let other = makeIdentifier(makeString("beta"))
        doAssert one == same, "two identical identifiers are not equal"
        doAssert one != other, "the derived != disagrees with the bound =="
        doAssert not (one != same), "the derived != contradicts itself"

testDerivedOperators()

# StringArray from a C array of strings ========================================
#
# These four constructors take const char* const* and const wchar_t* const*.
# Both spellings glue the star to the next word, which defeated the pointer
# test in remap_type: the char forms bound as a single constChar and the wchar
# forms lost one of their two pointer levels.

proc testStringArrayFromCArray() =
    block:
        var names = [cstring"alpha", cstring"beta", cstring"gamma"]
        let counted = makeStringArray(cast[ptr constChar](addr names[0]), 3)
        doAssert counted.size() == 3, "counted char array gave " & $counted.size()
        doAssert $counted[0] == "alpha", "first entry is " & $counted[0]
        doAssert $counted[2] == "gamma", "last entry is " & $counted[2]

        # The one-argument form reads until it meets a null pointer.
        var terminated = [cstring"alpha", cstring"beta", cstring(nil)]
        let sentinel = makeStringArray(cast[ptr constChar](addr terminated[0]))
        doAssert sentinel.size() == 2, "sentinel char array gave " & $sentinel.size()
        doAssert $sentinel[1] == "beta", "second entry is " & $sentinel[1]

    block:
        # UTF-32 literals, NUL terminated, then an array of pointers to them.
        var one = [WChar(ord('o')), WChar(ord('n')), WChar(ord('e')), WChar(0)]
        var two = [WChar(ord('t')), WChar(ord('w')), WChar(ord('o')), WChar(0)]

        var table = [addr one[0], addr two[0]]
        let counted = makeStringArray(addr table[0], 2)
        doAssert counted.size() == 2, "counted wchar array gave " & $counted.size()
        doAssert $counted[0] == "one", "first entry is " & $counted[0]
        doAssert $counted[1] == "two", "second entry is " & $counted[1]

        var terminated = [addr one[0], addr two[0], cast[ptr WChar](nil)]
        let sentinel = makeStringArray(addr terminated[0])
        doAssert sentinel.size() == 2, "sentinel wchar array gave " & $sentinel.size()
        doAssert $sentinel[1] == "two", "second entry is " & $sentinel[1]

testStringArrayFromCArray()

# UnitTest's registry ==========================================================
#
# Every UnitTest registers itself in a static Array<UnitTest*>, and the pointer
# was dropped: the array bound as Array[UnitTest], which is an array of copies
# of a non-copyable class. Nothing called these, so nothing said so.

proc testUnitTestRegistry() =
    block:
        let before = UnitTest.getAllTests().size()
        let registered = newCustomUnitTest(makeString("june registry test"),
                                           makeString("june"))
        doAssert UnitTest.getAllTests().size() == before + 1,
                 "the registry went from " & $before & " to " &
                 $UnitTest.getAllTests().size()

        var ran = 0
        registered[].setRunTestHandler(proc() = ran += 1)

        let byName = UnitTest.getTestsWithName(makeString("june registry test"))
        doAssert byName.size() == 1,
                 "searching by name found " & $byName.size() & " tests"
        doAssert byName[0] == cast[ptr UnitTest](registered),
                 "the test found by name is not the one registered"

        let byCategory = UnitTest.getTestsInCategory(makeString("june"))
        doAssert byCategory.size() == 1,
                 "searching by category found " & $byCategory.size() & " tests"
        doAssert byCategory[0] == cast[ptr UnitTest](registered),
                 "the test found by category is not the one registered"

        var runner = makeUnitTestRunner()
        runner.setAssertOnFailure(false)
        runner.runTests(byName)
        doAssert ran == 1, "the registered test ran " & $ran & " times"

        cdelete registered
        doAssert UnitTest.getAllTests().size() == before,
                 "the registry did not shrink when the test was deleted"

testUnitTestRegistry()

# std::function over a const reference =========================================
#
# JUCE asks for std::function<void(const T&)> where T cannot be passed by value.
# Only the value-returning form of that had a Nim type, so the void-returning
# ones bound as std::function<void(T)> - a type C++ cannot even form when T is
# non-copyable. And a field of that type was read as a reference field, because
# its spelling carries an ampersand inside the template argument, so it got no
# setter: readable, and impossible to install.

proc testConstReferenceFunctionObjects() =
    block:
        var command = makeConsoleApplicationCommand()
        command.commandOption = makeString("--greet")

        var seen = 0
        # A Nim string rather than a juce::String: the closure environment is
        # Nim-managed memory, and a C++ object captured into it is not
        # constructed or destroyed the way C++ requires.
        var received = ""
        command.command = bindConstRefClosure(proc(arguments: ptr ArgumentList) =
            seen += 1
            received = $arguments[].executableName)

        var held = command.command()
        var arguments = makeArgumentList(makeString("june"), makeString("--greet"))
        held(addr arguments)

        doAssert seen == 1, "the command ran " & $seen & " times"
        doAssert received == "june",
                 "the command saw the executable as " & received

testConstReferenceFunctionObjects()

# What a closure may capture ===================================================
#
# Nim allocates a closure's environment as zeroed memory rather than
# constructing it, and String::operator= releases whatever the target held
# before (juce_String.cpp:274). From zeroed memory that is a null buffer and
# the release writes through it, so capturing a String crashes - as does
# capturing anything holding one. A type built on ReferenceCountedObjectPtr
# checks for null when it assigns, so those are unaffected.
#
# Nothing releases what the object owns either, because the environment is
# never destructed: capturing an Image or a ValueTree leaks it, which JUCE's
# leak detector reports by name.
#
# Neither the crash nor the leak can be asserted - one takes the process down
# and the other only shows at exit. What is asserted here is the conversion the
# README recommends, and that a type owning nothing survives being captured.

proc testWhatAClosureMayCapture() =
    initialiseJuce_GUI()

    block:
        # The recommended conversion: a Nim string, not a juce::String.
        let name = $makeString("Ada")
        var greeted = ""
        let greet = proc() = greeted = "hello " & name
        greet()
        doAssert greeted == "hello Ada", "the closure produced " & greeted

    block:
        # Plain-value types.
        let colour = makeColour(10'u8, 20'u8, 30'u8, 255'u8)
        let bounds = makeRectangle(1.cint, 2.cint, 3.cint, 4.cint)
        var red = 0'u8
        var width = 0.cint
        let read = proc() =
            red = colour.getRed()
            width = bounds.getWidth()
        read()
        doAssert red == 10, "the captured colour reports red " & $red
        doAssert width == 3, "the captured rectangle is " & $width & " wide"

    block:
        # A reference counted one does not crash, and it does not get released
        # either: the environment is never destructed, so JUCE's leak detector
        # reports the ValueTree at exit. Read what is needed before the closure
        # and capture that instead.
        let tree = makeValueTree(makeIdentifier(makeString("root")))
        let typeName = $tree.getType().toString()
        var seen = ""
        let inspect = proc() = seen = typeName
        inspect()
        doAssert seen == "root", "the closure produced " & seen

    shutdownJuce_GUI()

testWhatAClosureMayCapture()

# Nim's int into an overloaded JUCE call =======================================
#
# JUCE gives String six integer constructors, and a plain Nim integer literal
# converts to all of them at equal cost, so `makeString(5)` was ambiguous and a
# caller had to write `makeString(5.cint)`. A proc taking Nim's own `int` is an
# exact match for a literal and wins outright. Only where the set has an int64
# form and one return type: a Nim int IS an int64 here, so the conversion is
# lossless and the target is not a choice.

proc testIntegerLiteralOverloads() =
    block:
        doAssert $makeString(5) == "5", "makeString(5) gave " & $makeString(5)
        doAssert $makeString(-2147483648) == "-2147483648",
                 "a value below int32 came back as " & $makeString(-2147483648)
        doAssert $makeString(4294967296) == "4294967296",
                 "a value above uint32 came back as " & $makeString(4294967296)

        # Adding the int form must not make any concrete width ambiguous, so
        # every one JUCE declares is passed through a variable of that type.
        var asCint: cint = 1
        var asInt16: int16 = 2
        var asUint16: uint16 = 3
        var asUint32: uint32 = 4
        var asInt64: int64 = 5
        var asUint64: uint64 = 6
        var asInt: int = 7
        doAssert $makeString(asCint) & $makeString(asInt16) &
                 $makeString(asUint16) & $makeString(asUint32) &
                 $makeString(asInt64) & $makeString(asUint64) &
                 $makeString(asInt) == "1234567",
                 "one of the seven widths did not come back as itself"

    block:
        let value = makejuce_var(7)
        doAssert value.isInt64() or value.isInt(),
                 "makejuce_var(7) is neither an int nor an int64"
        doAssert $value.toString() == "7", "it holds " & $value.toString()

        var target = makejuce_var()
        discard `juce_var=`(target, 13)
        doAssert $target.toString() == "13",
                 "assigning 13 left " & $target.toString()

    block:
        doAssert makeBigInteger(9).toInt64() == 9,
                 "makeBigInteger(9) holds " & $makeBigInteger(9).toInt64()

    block:
        # Through variables rather than literals. A literal is emitted as one
        # and C++ resolves it to `int`; a variable carries Nim's own int64,
        # which is `long` on Linux where JUCE's int64 is `long long`, so the
        # four integer overloads were ambiguous there until each argument
        # carried its declared type. A static method with more than one
        # argument could not cast piecewise before, because the typedesc
        # swallowed the first placeholder.
        var key = 11
        var wide: int64 = 11
        let limit = 100.cint
        doAssert DefaultHashFunctions.generateHash(key, limit) ==
                 DefaultHashFunctions.generateHash(wide, limit),
                 "the int form hashed differently from the int64 form"
        doAssert DefaultHashFunctions.generateHash(key, limit) < 100,
                 "the hash is outside its upper limit"

        var wider: uint64 = 11
        doAssert DefaultHashFunctions.generateHash(wider, limit) ==
                 DefaultHashFunctions.generateHash(wide, limit),
                 "the uint64 form hashed differently from the int64 form"

    block:
        doAssert RelativeTime.milliseconds(250).inSeconds() == 0.25,
                 "250ms is " & $RelativeTime.milliseconds(250).inSeconds() & "s"

testIntegerLiteralOverloads()

# Free functions that overload on a scalar =====================================
#
# The generator casts each argument to the type its overload declares wherever
# a set differs only in a scalar, which is what tells C++ which overload a call
# means. It did that for methods and constructors and not for free functions,
# and the difference showed on Linux: Nim's uint64 is `unsigned long` there
# while JUCE's is `unsigned long long`, so countNumberOfBits(someUint64) was
# ambiguous. Through variables rather than literals, which is what exposes it.

proc testScalarOverloadedFreeFunctions() =
    block:
        var wide: uint64 = 255
        var narrow: uint32 = 255
        doAssert countNumberOfBits(wide) == 8,
                 "255 as a uint64 has " & $countNumberOfBits(wide) & " bits set"
        doAssert countNumberOfBits(narrow) == 8,
                 "255 as a uint32 has " & $countNumberOfBits(narrow) & " bits set"

        var half: uint64 = 0xFFFFFFFFFFFFFFFF'u64
        doAssert countNumberOfBits(half) == 64,
                 "an all-ones uint64 has " & $countNumberOfBits(half) & " bits set"

    block:
        # operator<< over String gained the same casts.
        var line = makeString("n=")
        var big: int64 = 42
        discard line.shl(big)
        doAssert $line == "n=42", "the shifted string is " & $line

        var small: cint = 7
        discard line.shl(makeString(", m="))
        discard line.shl(small)
        doAssert $line == "n=42, m=7", "the shifted string is " & $line

testScalarOverloadedFreeFunctions()

# The pool acts on the status a job returns ====================================
#
# ThreadPoolJob::runJob returns a JobStatus, which is a distinct cint, and the
# handler returns the base scalar so that no Nim closure type names it - Nim
# renders one closure struct for that and for `proc(): cint`. Setting the
# handler proves it compiles and running the job proves the body is reached.
# Neither shows that the value coming back is the value JUCE reads: a cast that
# swapped jobHasFinished for jobNeedsRunningAgain would run the body either
# way. The pool re-runs a job that asks for it, so counting the runs is what
# tells the two apart.

proc testJobStatusIsActedOn() =
    block:
        var pool = makeThreadPool()
        var runs = 0

        let job = newCustomThreadPoolJob(makeString("repeating"))
        job[].setRunJobHandler(proc(): cint =
            runs += 1
            # Three times round, then done. A status JUCE misread as "finished"
            # would stop after one; one misread as "run again" would never stop.
            if runs < 3: cint(ThreadPoolJobJobStatus_jobNeedsRunningAgain)
            else: cint(ThreadPoolJobJobStatus_jobHasFinished))

        pool.addJob(cast[ptr ThreadPoolJob](job), false)

        var waited = 0
        while runs < 3 and waited < 10_000:
            sleep(10)
            waited += 10
        doAssert runs == 3,
                 "the job ran " & $runs & " times in " & $waited &
                 "ms, so the status it returned was not the one JUCE read"

        # Settled: having said it was finished, it is not run again.
        discard pool.removeAllJobs(true, 2000.cint)
        sleep(50)
        doAssert runs == 3,
                 "the job ran " & $runs & " times after saying it had finished"
        cdelete job

testJobStatusIsActedOn()

# Every iterator yields exactly what its container holds =======================
#
# The iterators are hand-written loops over the indexed accessors, which is the
# one place an off-by-one has nothing to catch it: JUCE's own begin and end
# have no Nim spelling, so there is no second implementation to disagree with.
# Existing tests iterate small fixed sets and check the contents, which catches
# truncation by accident and nothing else. These compare the yielded count
# against the container's own idea of its size, and the yielded order against
# indexed access, for a size big enough that an off-by-one is not the whole set.

proc testIteratorsAreComplete() =
    block:
        var numbers: Array[cint]
        for value in 0 ..< 7:
            numbers.add(value.cint)

        var seen: seq[cint] = @[]
        for value in numbers:
            seen.add(value)
        doAssert seen.len == numbers.size().int,
                 "Array yielded " & $seen.len & " of " & $numbers.size()
        for index in 0 ..< seen.len:
            doAssert seen[index] == numbers[index.cint],
                     "Array yielded " & $seen[index] & " at " & $index &
                     " where the index gives " & $numbers[index.cint]

    block:
        var words = makeStringArray()
        for value in 0 ..< 5:
            words.add(makeString("w" & $value))

        var seen: seq[string] = @[]
        for value in words:
            seen.add($value)
        doAssert seen.len == words.size().int,
                 "StringArray yielded " & $seen.len & " of " & $words.size()
        for index in 0 ..< seen.len:
            doAssert seen[index] == $words[index.cint],
                     "StringArray yielded " & seen[index] & " at " & $index

    block:
        # MemoryBlock has no indexed accessor of its own, which is why its
        # iterator reaches through getData - so the values come from fillWith
        # rather than from an index.
        var bytes = makeMemoryBlock(6'u64, true)
        bytes.fillWith(0xAB'u8)

        var seen: seq[uint8] = @[]
        for value in bytes:
            seen.add(value)
        doAssert seen.len == bytes.getSize().int,
                 "MemoryBlock yielded " & $seen.len & " of " & $bytes.getSize()
        for index in 0 ..< seen.len:
            doAssert seen[index] == 0xAB'u8,
                     "MemoryBlock yielded " & $seen[index] & " at " & $index

        # And it follows the size rather than a remembered one.
        bytes.setSize(9'u64, true)
        var after = 0
        for value in bytes:
            after += 1
        doAssert after == 9, "after growing to 9 the iterator yielded " & $after

    block:
        let text = makeString("abcdef")
        var seen: seq[uint32] = @[]
        for codepoint in text:
            seen.add(codepoint)
        doAssert seen.len == text.length().int,
                 "String yielded " & $seen.len & " of " & $text.length()
        doAssert seen[0] == uint32(ord('a')) and seen[^1] == uint32(ord('f')),
                 "String yielded the wrong ends"

    block:
        var document = makeXmlElement(makeString("root"))
        for value in 0 ..< 4:
            document.setAttribute(makeIdentifier(makeString("a" & $value)),
                                  makeString("v" & $value))
            discard document.createNewChildElement(makeString("child" & $value))

        var children: seq[string] = @[]
        for child in document:
            children.add($child[].getTagName())
        doAssert children.len == document.getNumChildElements().int,
                 "XmlElement yielded " & $children.len & " children of " &
                 $document.getNumChildElements()
        for index in 0 ..< children.len:
            doAssert children[index] ==
                     $document.getChildElement(index.cint)[].getTagName(),
                     "XmlElement yielded " & children[index] & " at " & $index

        var names: seq[string] = @[]
        for name, value in document.attributes:
            names.add($name)
        doAssert names.len == document.getNumAttributes().int,
                 "XmlElement yielded " & $names.len & " attributes of " &
                 $document.getNumAttributes()
        for index in 0 ..< names.len:
            doAssert names[index] == $document.getAttributeName(index.cint),
                     "XmlElement yielded the attribute " & names[index] &
                     " at " & $index

    block:
        var settings = makeNamedValueSet()
        for index in 0 ..< 4:
            discard settings.set(makeIdentifier(makeString("k" & $index)),
                                 makejuce_var(index.cint))

        var keys: seq[string] = @[]
        for name, value in settings.pairs:
            keys.add($name.toString())
        doAssert keys.len == settings.size().int,
                 "NamedValueSet yielded " & $keys.len & " of " & $settings.size()
        for index in 0 ..< keys.len:
            doAssert keys[index] == $settings.getName(index.cint).toString(),
                     "NamedValueSet yielded " & keys[index] & " at " & $index

    block:
        # A Span is only ever handed out by JUCE - nothing in the binding
        # builds one - so a juce::var holding an array is where it comes from.
        var elements: Array[juce_var]
        for value in 0 ..< 6:
            elements.add(makejuce_var(value.cint))
        let arrayVar = makejuce_var(elements)
        let span = arrayVar.getArrayElements()

        var seen: seq[int] = @[]
        for element in span:
            seen.add(element.toInt().int)
        doAssert seen.len == span.size().int,
                 "Span yielded " & $seen.len & " of " & $span.size()
        doAssert seen == @[0, 1, 2, 3, 4, 5],
                 "Span yielded " & $seen

testIteratorsAreComplete()

# What a generated constructor forwards ========================================
#
# Each generated subclass has a template forwarding constructor, so `new
# june::CustomThread(name, size)` reaches juce::Thread's own. The coverage check
# requires every one to be built, which proves the arguments type-check; it does
# not prove they arrive. A forwarding constructor that dropped or reordered one
# would build an object in the wrong state and say nothing.

proc testGeneratedConstructorsForward() =
    block:
        let worker = newCustomThread(makeString("june-worker"), 0.csize_t)
        doAssert $worker[].getThreadName() == "june-worker",
                 "the thread is called " & $worker[].getThreadName()
        cdelete worker

    block:
        let job = newCustomThreadPoolJob(makeString("june-job"))
        doAssert $job[].getJobName() == "june-job",
                 "the job is called " & $job[].getJobName()
        cdelete job

    block:
        # Two Strings in a row, which is where a reordering would show.
        let unitTest = newCustomUnitTest(makeString("the name"),
                                         makeString("the category"))
        doAssert $unitTest[].getName() == "the name",
                 "the test is called " & $unitTest[].getName()
        doAssert $unitTest[].getCategory() == "the category",
                 "the category is " & $unitTest[].getCategory()
        cdelete unitTest

testGeneratedConstructorsForward()

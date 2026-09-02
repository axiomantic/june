
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
  SystemStats.setApplicationCrashHandler(onCrash)
  doAssert compiles(SystemStats.setApplicationCrashHandler(onCrash))

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
  doAssert $makeString("hi").quoted(uint16('\'')) == "'hi'",
           "quoted gave " & $makeString("hi").quoted(uint16('\''))

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

  doAssert a[0.cint] == uint16('a'), "String [] gave " & $a[0.cint]
  doAssert a == makeString("aa"), "String == String"
  doAssert a == "aa", "String == literal"

testStringOperators()

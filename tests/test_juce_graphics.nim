
import june

# Everything here runs inside a proc on purpose. At top level Nim emits these as
# file-scope statics, and a JUCE Image constructed during static initialisation
# comes out null, so the Graphics constructor asserts and drawing segfaults.
proc testGeometry() =
  # Rectangle ==================================================================
  var r = makeRectangle(10.cint, 20.cint, 100.cint, 50.cint)
  doAssert r.getX() == 10
  doAssert r.getY() == 20
  doAssert r.getWidth() == 100
  doAssert r.getHeight() == 50
  doAssert r.getRight() == 110
  doAssert r.getBottom() == 70
  doAssert not r.isEmpty()
  doAssert r.contains(makePoint(50.cint, 50.cint))
  doAssert not r.contains(makePoint(5.cint, 5.cint))

  # removeFrom* mutates the rectangle and returns the slice it took off.
  let top = r.removeFromTop(20.cint)
  doAssert top.getHeight() == 20
  doAssert top.getY() == 20
  doAssert r.getHeight() == 30
  doAssert r.getY() == 40

  let reduced = makeRectangle(0.cint, 0.cint, 100.cint, 100.cint).reduced(10.cint)
  doAssert reduced.getX() == 10
  doAssert reduced.getWidth() == 80

  # Point ======================================================================
  let p = makePoint(3.cfloat, 4.cfloat)
  doAssert p.getX() == 3.0'f32
  doAssert p.distanceFrom(makePoint(0.cfloat, 0.cfloat)) == 5.0'f32
  doAssert p.withX(10.cfloat).getX() == 10.0'f32

  # Line =======================================================================
  let line = makeLine(0.cfloat, 0.cfloat, 3.cfloat, 4.cfloat)
  doAssert line.getLength() == 5.0'f32
  doAssert line.getEnd().getY() == 4.0'f32

  # Conversions ================================================================
  doAssert makeRectangle(1.cint, 2.cint, 3.cint, 4.cint).toFloat().getWidth() == 3.0'f32

  # Equality has to be bound explicitly. Without it Nim compares an importcpp
  # object structurally, and these declare no fields, so every two values came
  # out equal - which is what caught this.
  doAssert makeRectangle(1.cint, 2.cint, 3.cint, 4.cint) == makeRectangle(1.cint, 2.cint, 3.cint, 4.cint)
  doAssert makeRectangle(1.cint, 2.cint, 3.cint, 4.cint) != makeRectangle(9.cint, 9.cint, 9.cint, 9.cint)
  doAssert makePoint(1.cint, 2.cint) == makePoint(1.cint, 2.cint)
  doAssert makePoint(1.cint, 2.cint) != makePoint(3.cint, 4.cint)
  doAssert makeLine(0.cfloat, 0.cfloat, 3.cfloat, 4.cfloat) != makeLine(1.cfloat, 1.cfloat, 2.cfloat, 2.cfloat)

  # $ goes through JUCE's toString. Without it Nim prints "()".
  doAssert $makeRectangle(1.cint, 2.cint, 3.cint, 4.cint) == "1 2 3 4"
  doAssert $makePoint(5.cint, 6.cint) == "5, 6"

proc testDrawing() =
  let img = makeImage(ImagePixelFormat_ARGB, 40.cint, 30.cint, true)
  doAssert img.getWidth() == 40
  doAssert img.getBounds().getHeight() == 30

  var g = makeGraphics(img)
  g.setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))
  g.fillRect(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint))

  # The pixels prove the Rectangle overload reached JUCE and drew.
  doAssert img.getPixelAt(5.cint, 5.cint).getRed() == 255
  doAssert img.getPixelAt(5.cint, 5.cint).getBlue() == 0
  doAssert img.getPixelAt(20.cint, 20.cint).getRed() == 0



proc testText() =
  let img = makeImage(ImagePixelFormat_ARGB, 60.cint, 20.cint, true)
  var g = makeGraphics(img)
  g.setColour(makeColour(255'u8, 255'u8, 255'u8, 255'u8))

  # Justification arrives by converter, so the flag constant can be passed
  # directly rather than wrapped at every call site.
  g.drawText("hi", img.getBounds(), JustificationFlags_centred, false)

  var litPixels = 0
  for x in 0.cint ..< 60.cint:
    for y in 0.cint ..< 20.cint:
      if img.getPixelAt(x, y).getRed() > 0:
        litPixels += 1
  doAssert litPixels > 0, "drawText produced no pixels"

testGeometry()

# Image, Graphics and the font machinery reach for JUCE singletons, which assert
# at exit unless the GUI was initialised and shut down around them.
initialiseJuce_GUI()
testDrawing()
testText()
shutdownJuce_GUI()


# FontOptions declares these two with `auto`, so the deduced return type arrives
# from libclang as optional<decay_t<float>> rather than std::optional<float>.
# This is the check that they resolve, and that a std::optional round-trips.
proc testFontOptionsOverrides() =
  let plain = makeFontOptions()
  doAssert not plain.getAscentOverride().hasValue()

  let withAscent = plain.withAscentOverride(makeCppOptional(0.25'f32))
  doAssert withAscent.getAscentOverride().hasValue()
  doAssert withAscent.getAscentOverride().value() == 0.25'f32
  doAssert withAscent.getAscentOverride().valueOr(-1.0'f32) == 0.25'f32

  let cleared = withAscent.withAscentOverride(makeCppOptionalEmpty[cfloat]())
  doAssert not cleared.getAscentOverride().hasValue()
  doAssert cleared.getAscentOverride().valueOr(-1.0'f32) == -1.0'f32

testFontOptionsOverrides()

# HeapBlock is JUCE's owning raw buffer, and createLookupTable is the one place
# a caller has to supply one.
proc testColourGradientLookupTable() =
  let gradient = makeColourGradient(
    makeColour(255'u8, 0'u8, 0'u8, 255'u8), 0.0'f32, 0.0'f32,
    makeColour(0'u8, 0'u8, 255'u8, 255'u8), 100.0'f32, 0.0'f32, false)

  var table = makeHeapBlock[PixelARGB](0.csize_t)
  let entries = gradient.createLookupTable(makeAffineTransform(), table)

  doAssert entries > 0, "the lookup table came back with " & $entries & " entries"
  doAssert not table.isNil(), "the gradient allocated nothing"

  # The first entry is the gradient's start colour.
  doAssert table[0.cint].getRed() == 255'u8
  doAssert table[0.cint].getBlue() == 0'u8

testColourGradientLookupTable()

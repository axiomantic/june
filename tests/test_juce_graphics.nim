
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

testGeometry()
testDrawing()

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

testText()


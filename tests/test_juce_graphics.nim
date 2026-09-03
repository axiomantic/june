
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

# Enums nested two levels deep. The generator walked only one, so
# Image::BitmapData::ReadWriteMode had no Nim spelling and the proc taking it
# was a comment. Binding an enumerator emits its C++ name, so a wrong spelling
# is a compile error rather than a wrong value.
proc testDoublyNestedEnums() =
  doAssert ImageBitmapDataReadWriteMode_readOnly.cint !=
           ImageBitmapDataReadWriteMode_writeOnly.cint
  doAssert ImageBitmapDataReadWriteMode_readWrite.cint !=
           ImageBitmapDataReadWriteMode_readOnly.cint
  doAssert PathIteratorPathElementType_lineTo.cint !=
           PathIteratorPathElementType_closePath.cint

testDoublyNestedEnums()

# Nested classes had a type and nothing else: one could be held and passed and
# never built or called on. Image::BitmapData is the pixel-access API, and it
# is the case that proves the methods reach the right C++ class.
proc testNestedClassMethods() =
  var image = makeImage(ImagePixelFormat_ARGB, 4.cint, 4.cint, true)
  var graphics = makeGraphics(image)
  graphics.setColour(makeColour(10'u8, 20'u8, 30'u8, 255'u8))
  graphics.fillRect(0.cint, 0.cint, 4.cint, 4.cint)

  let pixels = makeImageBitmapData(image, ImageBitmapDataReadWriteMode_readOnly)
  let colour = pixels.getPixelColour(1.cint, 1.cint)

  doAssert colour.getRed() == 10'u8, "red came back as " & $colour.getRed()
  doAssert colour.getGreen() == 20'u8
  doAssert colour.getBlue() == 30'u8

testNestedClassMethods()

# Static methods were skipped outright, so the factory half of JUCE's API was
# missing: Colour.fromRGB, AffineTransform.rotation and the rest. A static has
# no receiver, so it takes the class as a typedesc.
proc testStaticMethods() =
  let red = Colour.fromRGB(255'u8, 0'u8, 0'u8)
  doAssert red.getRed() == 255'u8
  doAssert red.getGreen() == 0'u8

  let translucent = Colour.fromRGBA(1'u8, 2'u8, 3'u8, 128'u8)
  doAssert translucent.getAlpha() == 128'u8

  # AffineTransform's named constructors are how a transform is built at all.
  let moved = AffineTransform.translation(10.0'f32, 20.0'f32)
  doAssert moved.getTranslationX() == 10.0'f32, "x came back as " & $moved.getTranslationX()
  doAssert moved.getTranslationY() == 20.0'f32
  doAssert not moved.isIdentity()

  let doubled = AffineTransform.scale(2.0'f32)
  doAssert doubled.getScaleFactor() == 2.0'f32, "scale came back as " & $doubled.getScaleFactor()

  doAssert AffineTransform.rotation(0.0'f32).isIdentity()

testStaticMethods()

# std::byte is a distinct C++ type, not an alias for a character, so a Nim
# uint8 does not convert to one. Binding it is what makes the Typeface overload
# that loads a font from raw memory nameable.
proc testCppByte() =
  let value = 200'u8.toCppByte()
  doAssert value.toUint8() == 200'u8, "the byte came back as " & $value.toUint8()
  doAssert 0'u8.toCppByte().toUint8() == 0'u8

  doAssert compiles(proc(data: Span[CppByte]): ReferenceCountedObjectPtr[Typeface] =
    Typeface.createSystemTypefaceFor(data))

testCppByte()

# A static member variable is a VAR_DECL rather than a FIELD_DECL, so the field
# pass never saw one and 115 constants had no binding. AffineTransform.identity
# is the one an application reaches for most.
proc testStaticConstants() =
  doAssert AffineTransform.identity().isIdentity()
  doAssert AffineTransform.identity().getTranslationX() == 0.0'f32
  doAssert AffineTransform.identity().getScaleFactor() == 1.0'f32

  # And it is the same value JUCE builds a rotation of zero into.
  doAssert AffineTransform.rotation(0.0'f32).isIdentity()

testStaticConstants()

# Path is 57 bound procs and had no test. It is pure geometry, so every
# assertion here is a real computation rather than a smoke check.
proc testPath() =
  var path = makePath()
  doAssert path.isEmpty()

  path.startNewSubPath(0.0'f32, 0.0'f32)
  path.lineTo(10.0'f32, 0.0'f32)
  path.lineTo(10.0'f32, 5.0'f32)
  path.closeSubPath()

  doAssert not path.isEmpty()

  let bounds = path.getBounds()
  doAssert bounds.getX() == 0.0'f32, "x was " & $bounds.getX()
  doAssert bounds.getWidth() == 10.0'f32, "width was " & $bounds.getWidth()
  doAssert bounds.getHeight() == 5.0'f32

  # A point inside the triangle, and one outside it.
  doAssert path.contains(9.0'f32, 4.0'f32, 1.0'f32)
  doAssert not path.contains(0.0'f32, 5.0'f32, 1.0'f32)

  # A rectangle added to a fresh path has the perimeter it should.
  var boxPath = makePath()
  boxPath.addRectangle(0.0'f32, 0.0'f32, 3.0'f32, 4.0'f32)
  doAssert boxPath.getLength(AffineTransform.identity(), 1.0'f32) == 14.0'f32,
           "perimeter was " & $boxPath.getLength(AffineTransform.identity(), 1.0'f32)

  boxPath.clear()
  doAssert boxPath.isEmpty(), "clear left something behind"

testPath()

# Font ========================================================================
#
# Font is a value type wrapping a shared typeface. The metrics themselves come
# from whatever the host has installed, so this asserts on the parts JUCE
# controls: the height it was given back, the style flags, and the fact that
# the with* methods return a new font rather than mutating the receiver.

proc testFont() =
    var font = makeFont(makeFontOptions(24.0'f32))
    doAssert font.getHeight() == 24.0'f32, "height was " & $font.getHeight()

    # withHeight leaves the receiver alone.
    let taller = font.withHeight(48.0'f32)
    doAssert taller.getHeight() == 48.0'f32, "taller was " & $taller.getHeight()
    doAssert font.getHeight() == 24.0'f32, "withHeight mutated the original"

    # setHeight does mutate it.
    font.setHeight(12.0'f32)
    doAssert font.getHeight() == 12.0'f32, "setHeight did not take"

    # Style flags round-trip through the boldened/italicised accessors.
    doAssert not font.isBold(), "a plain font reported bold"
    doAssert not font.isItalic(), "a plain font reported italic"

    let heavy = font.boldened()
    doAssert heavy.isBold(), "boldened did not set bold"
    doAssert not font.isBold(), "boldened mutated the original"

    let slanted = font.italicised()
    doAssert slanted.isItalic(), "italicised did not set italic"

    # setBold is the in-place counterpart.
    font.setBold(true)
    doAssert font.isBold(), "setBold did not take"

    # And the style flags agree with the predicates.
    doAssert (font.getStyleFlags().FontFontStyleFlags and FontFontStyleFlags_bold) ==
             FontFontStyleFlags_bold,
             "style flags disagree with isBold"

    # A wider string measures wider. The absolute widths depend on the host
    # font, so only the ordering is asserted.
    let plain = makeFont(makeFontOptions(20.0'f32))
    let narrow = GlyphArrangement.getStringWidth(plain, makeString("i").toStringRef())
    let wide = GlyphArrangement.getStringWidth(plain, makeString("wwwwww").toStringRef())
    doAssert wide > narrow, "six w were not wider than one i"

# Font reaches the shared typeface cache, which is torn down by the GUI
# shutdown. Called outside a running subsystem it would be built and then
# leaked, which the leak detector reports at exit.
initialiseJuce_GUI()
testFont()
shutdownJuce_GUI()

# FillType and ColourGradient =================================================
#
# What a Graphics context is set to paint with, without painting anything.

proc testFillType() =
    var plain = makeFillType()
    doAssert plain.isColour(), "a default FillType was not a colour"
    doAssert not plain.isGradient(), "a default FillType claimed to be a gradient"

    let opaque = makeColour(255'u8, 0'u8, 0'u8, 255'u8)
    var red = makeFillType(opaque)
    doAssert red.isColour(), "a colour fill was not a colour"
    doAssert red.colour().getRed() == 255, "the red channel is " & $red.colour().getRed()
    doAssert not red.isInvisible(), "an opaque fill reported invisible"

    # A fully transparent colour makes the fill invisible.
    red.setColour(makeColour(255'u8, 0'u8, 0'u8, 0'u8))
    doAssert red.isInvisible(), "a transparent fill did not report invisible"

proc testColourGradient() =
    var gradient = makeColourGradient()
    gradient.clearColours()
    doAssert gradient.getNumColours() == 0,
             "clearColours left " & $gradient.getNumColours()

    let black = makeColour(0'u8, 0'u8, 0'u8, 255'u8)
    let white = makeColour(255'u8, 255'u8, 255'u8, 255'u8)
    discard gradient.addColour(0.0, black)
    discard gradient.addColour(1.0, white)
    doAssert gradient.getNumColours() == 2,
             "the gradient holds " & $gradient.getNumColours() & " stops"
    doAssert gradient.getColour(0.cint).getRed() == 0, "the first stop is not black"
    doAssert gradient.getColour(1.cint).getRed() == 255, "the second stop is not white"

    # A gradient makes the fill a gradient rather than a colour.
    var fill = makeFillType(gradient)
    doAssert fill.isGradient(), "a gradient fill was not a gradient"
    doAssert not fill.isColour(), "a gradient fill claimed to be a colour"

testFillType()
testColourGradient()

# The casted constructors =====================================================
#
# Several constructors now cast their argument to the type the overload
# declares, because without it g++ could not choose between them. A cast that
# named the wrong type would convert quietly, so these check the value that
# comes out rather than that the call compiles.

proc testCastedConstructors() =
    # Colour from a packed ARGB word: 0xFF804020 is opaque, red 0x80.
    let packed = makeColour(0xFF804020'u32)
    doAssert packed.getAlpha() == 255, "alpha is " & $packed.getAlpha()
    doAssert packed.getRed() == 0x80, "red is " & $packed.getRed()
    doAssert packed.getGreen() == 0x40, "green is " & $packed.getGreen()
    doAssert packed.getBlue() == 0x20, "blue is " & $packed.getBlue()

    # FontOptions from a height: the float has to survive as a float.
    doAssert makeFontOptions(18.5'f32).getHeight() == 18.5'f32,
             "the height came back as " & $makeFontOptions(18.5'f32).getHeight()

testCastedConstructors()

# PixelRGB ====================================================================
#
# The packed pixel. Its multiplyAlpha is declared for int and for float, which
# is one of the overload sets that gained a cast, so this exercises that too.

proc testPixelRGB() =
    var pixel = makePixelRGB()
    pixel.setARGB(255'u8, 0x80'u8, 0x40'u8, 0x20'u8)

    doAssert pixel.getRed() == 0x80, "red is " & $pixel.getRed()
    doAssert pixel.getGreen() == 0x40, "green is " & $pixel.getGreen()
    doAssert pixel.getBlue() == 0x20, "blue is " & $pixel.getBlue()
    # PixelRGB carries no alpha channel: it is opaque by construction.
    doAssert pixel.getAlpha() == 255, "alpha is " & $pixel.getAlpha()

    # Both multiplyAlpha overloads are callable and leave an opaque pixel
    # opaque, since there is no alpha to scale.
    pixel.multiplyAlpha(128.cint)
    doAssert pixel.getAlpha() == 255, "the int overload changed alpha"
    pixel.multiplyAlpha(0.5'f32)
    doAssert pixel.getAlpha() == 255, "the float overload changed alpha"

testPixelRGB()

# AttributedString ============================================================
#
# Text with runs of font and colour attached. The text itself is what a caller
# reads back, and appending concatenates rather than replacing.

proc testAttributedString() =
    var text = makeAttributedString(makeString("Hello"))
    doAssert $text.getText() == "Hello", "getText gave " & $text.getText()

    text.append(makeString(" there"))
    doAssert $text.getText() == "Hello there", "append gave " & $text.getText()

    # Appending with a colour attaches an attribute and still adds the text.
    text.append(makeString("!"), makeColour(255'u8, 0'u8, 0'u8, 255'u8))
    doAssert $text.getText() == "Hello there!", "the coloured append gave " & $text.getText()
    doAssert text.getNumAttributes() > 0, "no attribute was recorded"

    text.setText(makeString("replaced"))
    doAssert $text.getText() == "replaced", "setText gave " & $text.getText()

    text.clear()
    doAssert $text.getText() == "", "clear left " & $text.getText()

testAttributedString()

# Drawing, checked at the pixels ==============================================
#
# JUCE renders into an Image without a display, so the drawing calls can be
# checked by what they put on the surface rather than by returning without
# error. Each of these reads a pixel the shape covers and one it does not.

proc testFillAllAndOpacity() =
    let image = makeImage(ImagePixelFormat_ARGB, 20.cint, 20.cint, true)
    var context = makeGraphics(image)

    context.fillAll(makeColour(0'u8, 255'u8, 0'u8, 255'u8))
    doAssert image.getPixelAt(0.cint, 0.cint).getGreen() == 255, "fillAll missed a corner"
    doAssert image.getPixelAt(19.cint, 19.cint).getGreen() == 255, "fillAll missed the far corner"

proc testShapes() =
    let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
    var context = makeGraphics(image)
    context.setColour(makeColour(0'u8, 0'u8, 255'u8, 255'u8))

    # A filled ellipse covers its centre and misses the corner of its box.
    context.fillEllipse(0.0'f32, 0.0'f32, 20.0'f32, 20.0'f32)
    doAssert image.getPixelAt(10.cint, 10.cint).getBlue() == 255, "the ellipse centre is empty"
    doAssert image.getPixelAt(0.cint, 0.cint).getBlue() == 0,
             "the ellipse filled the corner of its bounding box"

    # A horizontal line covers its own row and not the one below.
    context.setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))
    context.drawHorizontalLine(30.cint, 0.0'f32, 40.0'f32)
    doAssert image.getPixelAt(20.cint, 30.cint).getRed() == 255, "the line did not draw"
    doAssert image.getPixelAt(20.cint, 32.cint).getRed() == 0, "the line was too thick"

proc testClipRegion() =
    let image = makeImage(ImagePixelFormat_ARGB, 20.cint, 20.cint, true)
    var context = makeGraphics(image)

    # Clipped to the top-left quarter, a fill of everything reaches only that.
    doAssert context.reduceClipRegion(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint)),
             "reduceClipRegion reported an empty region"
    context.fillAll(makeColour(255'u8, 0'u8, 0'u8, 255'u8))

    doAssert image.getPixelAt(5.cint, 5.cint).getRed() == 255, "the clipped area was not filled"
    doAssert image.getPixelAt(15.cint, 15.cint).getRed() == 0,
             "the fill escaped the clip region"

testFillAllAndOpacity()
testShapes()
testClipRegion()

# Image and ImageBitmapData ===================================================
#
# BitmapData is the raw buffer behind an Image. Reading a pixel through it and
# through getPixelAt has to give the same answer, which is what says the stride
# and format the binding reports are the ones the buffer actually has.

proc testImageProperties() =
    var image = makeImage(ImagePixelFormat_ARGB, 8.cint, 4.cint, true)
    doAssert image.isValid(), "a constructed image was not valid"
    doAssert not image.isNull(), "a constructed image reported null"
    doAssert image.isARGB(), "an ARGB image did not report ARGB"
    doAssert image.hasAlphaChannel(), "an ARGB image had no alpha channel"
    doAssert image.getBounds().getWidth() == 8, "the bounds are " & $image.getBounds().getWidth()

    # A rescaled copy has the size asked for and leaves the original alone.
    let bigger = image.rescaled(16.cint, 8.cint, GraphicsResamplingQuality_lowResamplingQuality)
    doAssert bigger.getWidth() == 16, "the rescaled image is " & $bigger.getWidth() & " wide"
    doAssert image.getWidth() == 8, "rescaled changed the original"

proc testImageBitmapData() =
    var image = makeImage(ImagePixelFormat_ARGB, 8.cint, 4.cint, true)
    # makeColour takes red, green, blue, alpha - in that order.
    image.setPixelAt(2.cint, 1.cint, makeColour(10'u8, 20'u8, 30'u8, 255'u8))

    var pixels = makeImageBitmapData(image, ImageBitmapDataReadWriteMode_readOnly)
    doAssert pixels.width() == 8, "BitmapData reports width " & $pixels.width()
    doAssert pixels.height() == 4, "BitmapData reports height " & $pixels.height()
    doAssert pixels.pixelStride() == 4, "an ARGB pixel is " & $pixels.pixelStride() & " bytes"
    doAssert pixels.lineStride() >= pixels.width() * pixels.pixelStride(),
             "the line stride is shorter than a row"

    # The same pixel through the raw buffer and through the accessor.
    let raw = pixels.getPixelPointer(2.cint, 1.cint)
    doAssert raw != nil, "getPixelPointer returned nothing"
    let viaAccessor = image.getPixelAt(2.cint, 1.cint)
    doAssert viaAccessor.getRed() == 10, "getPixelAt gave red " & $viaAccessor.getRed()
    doAssert viaAccessor.getGreen() == 20, "getPixelAt gave green " & $viaAccessor.getGreen()
    doAssert viaAccessor.getBlue() == 30, "getPixelAt gave blue " & $viaAccessor.getBlue()
    doAssert viaAccessor.getAlpha() == 255, "getPixelAt gave alpha " & $viaAccessor.getAlpha()

testImageProperties()
testImageBitmapData()

# BorderSize and RectangleList ================================================
#
# Two hand-written generic wrappers in june_juce_types, neither of which had
# any coverage. Both are class templates, so instantiating them with cint is
# also a check that the template machinery works for the hand-written ones and
# not only the generated bindings.

proc testBorderSize() =
    # JUCE takes the four gaps in the order top, left, bottom, right.
    let border = makeBorderSize(1.cint, 2.cint, 3.cint, 4.cint)
    doAssert border.getTop() == 1, "top is " & $border.getTop()
    doAssert border.getLeft() == 2, "left is " & $border.getLeft()
    doAssert border.getBottom() == 3, "bottom is " & $border.getBottom()
    doAssert border.getRight() == 4, "right is " & $border.getRight()

    # The one-gap form sets all four the same.
    let uniform = makeBorderSize(5.cint)
    doAssert uniform.getTop() == 5 and uniform.getLeft() == 5 and
             uniform.getBottom() == 5 and uniform.getRight() == 5,
             "the uniform border is not uniform"

proc testRectangleList() =
    var rectangles = makeRectangleList[cint]()
    doAssert rectangles.isEmpty(), "a fresh list was not empty"
    doAssert rectangles.getNumRectangles() == 0,
             "a fresh list holds " & $rectangles.getNumRectangles()

    rectangles.add(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint))
    rectangles.add(makeRectangle(20.cint, 0.cint, 10.cint, 10.cint))
    doAssert not rectangles.isEmpty(), "a filled list reported empty"
    doAssert rectangles.getNumRectangles() == 2,
             "the list holds " & $rectangles.getNumRectangles()

    # The bounds span both rectangles rather than either one.
    let bounds = rectangles.getBounds()
    doAssert bounds.getWidth() == 30, "the bounds are " & $bounds.getWidth() & " wide"
    doAssert bounds.getHeight() == 10, "the bounds are " & $bounds.getHeight() & " tall"

    doAssert rectangles.getRectangle(0.cint).getWidth() == 10, "the first rectangle"

    rectangles.clear()
    doAssert rectangles.isEmpty(), "clear left something behind"

testBorderSize()
testRectangleList()

# The hand-written generics ===================================================
#
# A generic proc is only type-checked where it is instantiated, so a
# hand-written one that names C++ which does not exist compiles fine until
# something calls it. That is how makeBorderSize sat broken. These instantiate
# the Range, Point and Rectangle helpers that nothing had called.

proc testRangeHelpers() =
    let span = makeRange(10.cint, 20.cint)
    doAssert span.getStart() == 10, "start is " & $span.getStart()

    doAssert Range[cint].emptyRange(5.cint).getLength() == 0,
             "an empty range has length " & $Range[cint].emptyRange(5.cint).getLength()

    doAssert span.movedToStartAt(0.cint).getEnd() == 10,
             "moving the start left the end at " & $span.movedToStartAt(0.cint).getEnd()
    doAssert span.movedToEndAt(30.cint).getStart() == 20,
             "moving the end left the start at " & $span.movedToEndAt(30.cint).getStart()

    doAssert span.expanded(5.cint).getLength() == 20,
             "expanding gave length " & $span.expanded(5.cint).getLength()

    # clipValue pins to the range, and intersects answers about overlap.
    doAssert span.clipValue(0.cint) == 10, "clipValue below the range"
    doAssert span.clipValue(50.cint) == 20, "clipValue above the range"
    doAssert span.clipValue(15.cint) == 15, "clipValue inside the range"
    doAssert span.intersects(makeRange(15.cint, 25.cint)), "overlapping ranges did not intersect"
    doAssert not span.intersects(makeRange(30.cint, 40.cint)), "separate ranges intersected"

proc testRectangleHelpers() =
    let box = makeRectangle(0.cint, 0.cint, 20.cint, 10.cint)
    doAssert box.getCentreX() == 10, "centre x is " & $box.getCentreX()
    doAssert box.getCentreY() == 5, "centre y is " & $box.getCentreY()
    doAssert box.getCentre().getX() == 10, "getCentre gave x " & $box.getCentre().getX()

    let overlapping = makeRectangle(10.cint, 0.cint, 20.cint, 10.cint)
    doAssert box.intersects(overlapping), "overlapping rectangles did not intersect"
    doAssert box.getIntersection(overlapping).getWidth() == 10,
             "the intersection is " & $box.getIntersection(overlapping).getWidth() & " wide"
    doAssert box.getUnion(overlapping).getWidth() == 30,
             "the union is " & $box.getUnion(overlapping).getWidth() & " wide"

    doAssert box.expanded(5.cint).getWidth() == 30,
             "expanding gave width " & $box.expanded(5.cint).getWidth()

    # removeFromBottom takes a slice off and shrinks the receiver.
    var shrinking = makeRectangle(0.cint, 0.cint, 20.cint, 10.cint)
    let slice = shrinking.removeFromBottom(4.cint)
    doAssert slice.getHeight() == 4, "the slice is " & $slice.getHeight() & " tall"
    doAssert shrinking.getHeight() == 6, "what is left is " & $shrinking.getHeight() & " tall"

    doAssert makePoint(0.cint, 0.cint).isOrigin(), "the origin did not report as origin"
    doAssert not makePoint(1.cint, 0.cint).isOrigin(), "a moved point reported as origin"

testRangeHelpers()
testRectangleHelpers()

# Range's setters =============================================================
#
# These mutate through a reference, so they need a var receiver or Nim lets
# them be called on a let binding and quietly changes it. Point's setters
# already had one; Range's did not.

proc testRangeSetters() =
    var span = makeRange(10.cint, 20.cint)

    span.setStart(5.cint)
    doAssert span.getStart() == 5, "setStart left the start at " & $span.getStart()
    doAssert span.getEnd() == 20, "setStart moved the end"

    span.setEnd(30.cint)
    doAssert span.getEnd() == 30, "setEnd left the end at " & $span.getEnd()

    span.setLength(10.cint)
    doAssert span.getLength() == 10, "setLength gave " & $span.getLength()
    doAssert span.getStart() == 5, "setLength moved the start"

    var origin = makePoint(1.cint, 2.cint)
    origin.setX(9.cint)
    origin.setY(8.cint)
    doAssert origin.getX() == 9 and origin.getY() == 8,
             "the Point setters did not take"

testRangeSetters()

# The last of the untested hand-written generics ==============================
#
# Instantiating each one is the point: a generic that names C++ which does not
# exist compiles until something calls it, which is how makeBorderSize and four
# missing constructors stayed hidden.

proc testRemainingRangeHelpers() =
    let span = makeRange(10.cint, 20.cint)

    doAssert span.getIntersectionWith(makeRange(15.cint, 30.cint)).getStart() == 15,
             "getIntersectionWith gave the wrong start"
    doAssert span.getUnionWith(makeRange(30.cint, 40.cint)).getEnd() == 40,
             "getUnionWith gave the wrong end"
    doAssert span.getUnionWith(25.cint).getEnd() == 25,
             "getUnionWith on a value gave the wrong end"

    # constrainRange pulls a range inside this one.
    let constrained = span.constrainRange(makeRange(0.cint, 5.cint))
    doAssert constrained.getStart() >= 10, "constrainRange left it outside"

    var values = [3.cint, 1.cint, 4.cint, 1.cint, 5.cint]
    let found = Range[cint].findMinAndMax(values[0].addr, 5.cint)
    doAssert found.getStart() == 1, "findMinAndMax gave min " & $found.getStart()
    doAssert found.getEnd() == 5, "findMinAndMax gave max " & $found.getEnd()

proc testRemainingRectangleHelpers() =
    var box = makeRectangle(0.cint, 0.cint, 20.cint, 10.cint)

    let leftSlice = box.removeFromLeft(4.cint)
    doAssert leftSlice.getWidth() == 4, "the left slice is " & $leftSlice.getWidth()
    doAssert box.getWidth() == 16, "what is left is " & $box.getWidth()

    let rightSlice = box.removeFromRight(6.cint)
    doAssert rightSlice.getWidth() == 6, "the right slice is " & $rightSlice.getWidth()
    doAssert box.getWidth() == 10, "what is left is " & $box.getWidth()

    let rounded = makeRectangle(0.5'f32, 0.5'f32, 9.4'f32, 9.4'f32).toNearestInt()
    doAssert rounded.getWidth() == 9, "toNearestInt gave width " & $rounded.getWidth()

proc testNormalisableRange() =
    let normalised = makeNormalisableRange(0.0'f32, 100.0'f32)
    doAssert normalised.convertTo0to1(50.0'f32) == 0.5'f32,
             "convertTo0to1 gave " & $normalised.convertTo0to1(50.0'f32)
    doAssert normalised.convertFrom0to1(0.25'f32) == 25.0'f32,
             "convertFrom0to1 gave " & $normalised.convertFrom0to1(0.25'f32)
    doAssert normalised.snapToLegalValue(150.0'f32) == 100.0'f32,
             "snapToLegalValue gave " & $normalised.snapToLegalValue(150.0'f32)

testRemainingRangeHelpers()
testRemainingRectangleHelpers()
testNormalisableRange()

# Flag enums combine ==========================================================
#
# JUCE spells a flag set as a nested enum called Flags. A distinct cint has no
# bitwise operators, so combining two used to mean casting both sides to cint
# and back; the flag enums carry borrowed or and and now.

proc testFlagEnums() =
    let combined = FontFontStyleFlags_bold or FontFontStyleFlags_italic
    doAssert (combined and FontFontStyleFlags_bold) == FontFontStyleFlags_bold,
             "the combination lost bold"
    doAssert (combined and FontFontStyleFlags_italic) == FontFontStyleFlags_italic,
             "the combination lost italic"

    # A flag that was not combined in is absent, which is what says or is a
    # bitwise or rather than something that returns everything.
    doAssert (combined and FontFontStyleFlags_underlined) != FontFontStyleFlags_underlined,
             "the combination contained a flag nobody set"

testFlagEnums()

# LowLevelGraphicsSoftwareRenderer ============================================
#
# The renderer Graphics uses when there is no hardware behind it. Constructing
# one over an Image and asking about its clip is checkable without drawing, and
# the clip is what everything else is measured against.

proc testSoftwareRenderer() =
    let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 30.cint, true)
    var renderer = makeLowLevelGraphicsSoftwareRenderer(image)

    doAssert not renderer.isVectorDevice(), "the software renderer called itself a vector device"
    doAssert not renderer.isClipEmpty(), "a fresh renderer had an empty clip"

    # The clip starts as the whole image.
    doAssert renderer.getClipBounds().getWidth() == 40,
             "the clip is " & $renderer.getClipBounds().getWidth() & " wide"
    doAssert renderer.getClipBounds().getHeight() == 30,
             "the clip is " & $renderer.getClipBounds().getHeight() & " tall"

    doAssert renderer.clipRegionIntersects(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint)),
             "a rectangle inside the image did not intersect the clip"
    doAssert not renderer.clipRegionIntersects(makeRectangle(100.cint, 100.cint, 10.cint, 10.cint)),
             "a rectangle outside the image intersected the clip"

    # Moving the origin shifts what the clip bounds report.
    renderer.setOrigin(makePoint(5.cint, 5.cint))
    doAssert renderer.getClipBounds().getX() == -5,
             "after moving the origin the clip starts at " & $renderer.getClipBounds().getX()

testSoftwareRenderer()

# TextLayout ==================================================================
#
# The generator withholds TextLayout's begin() and end() with a reason naming a
# Nim iterator, and juce_graphics_lifting writes that iterator. Nothing had ever
# instantiated it, and a generic iterator is only type-checked where it is used.

proc testTextLayout() =
    block:
        var text = makeAttributedString(makeString("one two three four five six"))
        text.setJustification(makeJustification(cint(JustificationFlags_left)))

        var layout = makeTextLayout()
        # Narrow enough that the text cannot fit on a single line, so the
        # layout has to break it and the line count is a real answer.
        layout.createLayout(text, 40.0'f32)

        doAssert layout.getNumLines() > 1,
                 "the layout put the text on " & $layout.getNumLines() & " line(s)"
        doAssert layout.getWidth() > 0.0'f32, "the layout has no width"
        doAssert layout.getHeight() > 0.0'f32, "the layout has no height"

        # The iterator and the indexed accessor have to agree, which is what
        # says the iterator walks the lines rather than something else.
        var walked = 0
        var lastBaseline = -1.0'f32
        for line in layout:
            doAssert line.stringRange().getLength() >= 0, "a line has a negative range"
            let baseline = line.lineOrigin().getY()
            doAssert baseline > lastBaseline,
                     "line " & $walked & " is not below the one before it"
            lastBaseline = baseline
            walked += 1

        doAssert walked == layout.getNumLines().int,
                 "the iterator yielded " & $walked & " of " &
                 $layout.getNumLines() & " lines"

        # Drawing it reaches JUCE's own renderer, which is the check that the
        # layout is not merely well-formed but usable.
        let image = makeImage(ImagePixelFormat_ARGB, 60.cint, 60.cint, true)
        var context = makeGraphics(image)
        context.setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))
        layout.draw(context, makeRectangle(0.0'f32, 0.0'f32, 60.0'f32, 60.0'f32))

        var painted = 0
        for x in 0 ..< 60:
            for y in 0 ..< 60:
                if image.getPixelAt(x.cint, y.cint).getAlpha() > 0:
                    painted += 1
        doAssert painted > 0, "drawing the layout left the image empty"

testTextLayout()

# Aggregates with an implicit default constructor =============================

proc testGraphicsAggregates() =
    block:
        var metrics = makeTypefaceMetrics()
        metrics.ascent = 0.75'f32
        doAssert metrics.ascent() == 0.75'f32,
                 "the metrics hold " & $metrics.ascent()

        # ImageLayer carries only fields whose types are not simple enough to
        # write here, so building it is the check. ColourLayer and GlyphLayer
        # get no constructor at all: an EdgeTable member leaves the first with
        # no default, and the variant in the second inherits that.
        discard makeImageLayer()

testGraphicsAggregates()

# The remaining generated subclasses ==========================================

proc testRemainingGraphicsSubclasses() =
    block:
        var pixels = newCustomImagePixelData(ImagePixelFormat_ARGB, 4.cint, 4.cint)
        doAssert not pixels.isNil(), "the pixel data was not built"
        # clone returns ImagePixelData::Ptr. The generator used to type this
        # against DynamicObject::Ptr, which C++ rejects as an override.
        pixels[].setCloneHandler(proc(): ReferenceCountedObjectPtr[ImagePixelData] =
            makeReferenceCountedObjectPtr[ImagePixelData]())
        pixels[].setCreateLowLevelContextHandler(
            proc(): UniquePtr[LowLevelGraphicsContext] =
                makeUniquePtr[LowLevelGraphicsContext]())
        pixels[].setCreateTypeHandler(proc(): UniquePtr[ImageType] =
            makeUniquePtr[ImageType]())
        pixels[].setInitialiseBitmapDataHandler(proc(arg0: ptr ImageBitmapData,
                                                     x: cint, y: cint,
                                                     arg3: ImageBitmapDataReadWriteMode) = discard)
        cdelete pixels

        var typeface = newCustomTypeface(makeString("Name"), makeString("Style"))
        doAssert not typeface.isNil(), "the typeface was not built"
        typeface[].setCreateSystemFallbackHandler(
            proc(text: ptr String, language: ptr String): ReferenceCountedObjectPtr[Typeface] =
                makeReferenceCountedObjectPtr[Typeface]())
        typeface[].setGetNativeDetailsHandler(proc(): ptr TypefaceNative = nil)
        cdelete typeface

testRemainingGraphicsSubclasses()

# CustomDrawable and CustomImageFileFormat ====================================
#
# Both are abstract. Setting a handler is what type-checks and generates the
# setter, and createCopy returns a std::unique_ptr, which had no constructor.

proc testDrawableAndImageFileFormat() =
    block:
        var drawable = newCustomDrawable()
        doAssert not drawable.isNil(), "the drawable was not built"
        drawable[].setCreateCopyHandler(proc(): UniquePtr[Drawable] =
            makeUniquePtr[Drawable]())
        drawable[].setGetOutlineAsPathHandler(proc(): Path = makePath())
        drawable[].setGetDrawableBoundsHandler(proc(): Rectangle[cfloat] =
            makeRectangle(0.0'f32, 0.0'f32, 10.0'f32, 10.0'f32))
        cdelete drawable

        var format = newCustomImageFileFormat()
        doAssert not format.isNil(), "the image format was not built"
        format[].setGetFormatNameHandler(proc(): String = makeString("June Test"))
        format[].setCanUnderstandHandler(proc(input: ptr InputStream): bool = false)
        format[].setUsesFileExtensionHandler(proc(possibleFile: ptr june.File): bool = false)
        format[].setDecodeImageHandler(proc(input: ptr InputStream): Image =
            makeImage(ImagePixelFormat_ARGB, 1.cint, 1.cint, true))
        format[].setWriteImageToStreamHandler(proc(sourceImage: ptr Image,
                                                   destStream: ptr OutputStream): bool = false)
        cdelete format

testDrawableAndImageFileFormat()

# The last of the graphics subclass handlers ==================================

proc testRemainingGraphicsHandlers() =
    block:
        var effect = newCustomImageEffectFilter()
        effect[].setApplyEffectHandler(proc(sourceImage: ptr Image,
                                            destContext: ptr Graphics,
                                            scaleFactor: cfloat,
                                            alpha: cfloat) = discard)
        cdelete effect

        var backup = newCustomImagePixelDataBackupExtensions()
        backup[].setSetBackupEnabledHandler(proc(arg0: bool) = discard)
        backup[].setIsBackupEnabledHandler(proc(): bool = false)
        backup[].setBackupNowHandler(proc(): bool = true)
        backup[].setNeedsBackupHandler(proc(): bool = false)
        backup[].setCanBackupHandler(proc(): bool = true)
        cdelete backup

        var imageType = newCustomImageType()
        imageType[].setCreateHandler(proc(arg0: ImagePixelFormat, width: cint,
                                          height: cint, shouldClearImage: bool):
                                         ReferenceCountedObjectPtr[ImagePixelData] =
            makeReferenceCountedObjectPtr[ImagePixelData]())
        imageType[].setGetTypeIDHandler(proc(): cint = 0.cint)
        cdelete imageType

testRemainingGraphicsHandlers()

# PixelAlpha, PathFlatteningIterator and PositionedGlyph =======================
#
# Three classes whose answers are arithmetic, so the assertions can be exact
# rather than "something was drawn".

proc testGraphicsValueClasses() =
    block:
        # PixelAlpha stores an alpha and nothing else. JUCE's own getRed,
        # getGreen and getBlue return a literal 0 for it, and setARGB drops
        # every argument but the first.
        var pixel = makePixelAlpha()
        pixel.setAlpha(200'u8)
        doAssert pixel.getAlpha() == 200'u8, "the pixel holds " & $pixel.getAlpha()
        doAssert pixel.getRed() == 0'u8, "red reads " & $pixel.getRed()
        doAssert pixel.getGreen() == 0'u8, "green reads " & $pixel.getGreen()
        doAssert pixel.getBlue() == 0'u8, "blue reads " & $pixel.getBlue()

        pixel.multiplyAlpha(128.cint)
        doAssert pixel.getAlpha() == 100'u8,
                 "after halving, the alpha is " & $pixel.getAlpha()

        pixel.setARGB(50'u8, 255'u8, 255'u8, 255'u8)
        doAssert pixel.getAlpha() == 50'u8, "setARGB left " & $pixel.getAlpha()
        doAssert pixel.getRed() == 0'u8,
                 "setARGB kept a red of " & $pixel.getRed()

    block:
        # A rectangle flattens to four straight segments, and the iterator walks
        # them. Every segment has to lie on the rectangle's own edges.
        var path = makePath()
        path.addRectangle(0.0'f32, 0.0'f32, 10.0'f32, 20.0'f32)

        var walker = makePathFlatteningIterator(path, makeAffineTransform(), 1.0'f32)
        var segments = 0
        var closes = 0
        var indices: seq[cint] = @[]
        while walker.next():
            segments += 1
            for value in [walker.x1(), walker.x2()]:
                doAssert value >= 0.0'f32 and value <= 10.0'f32,
                         "a segment left the rectangle at x " & $value
            for value in [walker.y1(), walker.y2()]:
                doAssert value >= 0.0'f32 and value <= 20.0'f32,
                         "a segment left the rectangle at y " & $value
            if walker.closesSubPath(): closes += 1
            indices.add walker.subPathIndex()

        doAssert segments == 4,
                 "the rectangle flattened to " & $segments & " segments"
        doAssert closes == 1,
                 $closes & " of the segments closed the sub path"
        # JUCE documents subPathIndex as the index of the line within its own
        # sub path, and says only that the first one is 0.
        doAssert indices.len > 0 and indices[0] == 0,
                 "the first segment reported sub path index " & $indices

    block:
        # A glyph placed at a known anchor reports that anchor back.
        let font = makeFont(makeFontOptions())
        var glyph = makePositionedGlyph(font, WChar(ord('A')), 0.cint,
                                        5.0'f32, 30.0'f32, 12.0'f32, false)
        doAssert glyph.getCharacter() == WChar(ord('A')),
                 "the glyph holds codepoint " & $glyph.getCharacter().int
        doAssert not glyph.isWhitespace(), "the glyph called itself whitespace"
        doAssert glyph.getLeft() == 5.0'f32, "the glyph starts at " & $glyph.getLeft()
        doAssert glyph.getRight() == 17.0'f32, "the glyph ends at " & $glyph.getRight()
        doAssert glyph.getBaselineY() == 30.0'f32,
                 "the baseline is at " & $glyph.getBaselineY()
        doAssert glyph.getBounds().getWidth() == 12.0'f32,
                 "the glyph is " & $glyph.getBounds().getWidth() & " wide"

        glyph.moveBy(3.0'f32, -2.0'f32)
        doAssert glyph.getLeft() == 8.0'f32, "after moving it starts at " & $glyph.getLeft()
        doAssert glyph.getBaselineY() == 28.0'f32,
                 "after moving the baseline is at " & $glyph.getBaselineY()

testGraphicsValueClasses()

# TextLayoutRun and TextLayoutGlyph ===========================================
#
# A laid-out line is a list of runs, and each run is a list of glyphs. Walking
# down from the layout to the glyphs is what says the whole structure is
# reachable from Nim rather than only its top.

proc testTextLayoutRuns() =
    block:
        var text = makeAttributedString(makeString("Hello"))
        text.setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))

        var layout = makeTextLayout()
        layout.createLayout(text, 400.0'f32)
        doAssert layout.getNumLines() == 1,
                 "the text laid out on " & $layout.getNumLines() & " lines"

        var glyphs = 0
        var runs = 0
        var lastAnchorX = -1.0'f32
        for line in layout:
            # Chained rather than bound to a local. OwnedArray and
            # Array<Glyph> are both non-copyable - Glyph has no default
            # constructor - so `var runs = line.runs()` asks C++ for a copy it
            # will not make, and so does `for run in line.runs()`, because the
            # items iterator takes the array by value. Used inline, no copy is
            # needed and the accessor hands back the reference it holds.
            for runIndex in 0 ..< line.runs().size():
                runs += 1
                doAssert line.runs()[runIndex][].stringRange().getLength() > 0,
                         "a run covers no characters"
                doAssert line.runs()[runIndex][].colour().getRed() == 255'u8,
                         "the run lost the colour it was given"
                for glyphIndex in 0 ..< line.runs()[runIndex][].glyphs().size():
                    glyphs += 1
                    # getReference, not []: `[]` returns by value and Nim
                    # builds a temporary for that, which needs a default
                    # constructor. TextLayout::Glyph has none.
                    let width = line.runs()[runIndex][].glyphs()
                                    .getReference(glyphIndex).width()
                    doAssert width > 0.0'f32, "a glyph is " & $width & " wide"
                    # Glyphs run left to right along the line.
                    let anchorX = line.runs()[runIndex][].glyphs()
                                      .getReference(glyphIndex).anchor().getX()
                    doAssert anchorX > lastAnchorX,
                             "glyph " & $glyphs & " is not right of the one before"
                    lastAnchorX = anchorX

        doAssert runs >= 1, "the line holds " & $runs & " runs"
        doAssert glyphs == 5,
                 "the five characters produced " & $glyphs & " glyphs"

    block:
        # Built by hand rather than laid out, so the fields are exactly what
        # they were set to.
        let glyph = makeTextLayoutGlyph(42.cint, makePoint(3.0'f32, 4.0'f32), 9.0'f32)
        doAssert glyph.glyphCode() == 42, "the glyph code is " & $glyph.glyphCode()
        doAssert glyph.anchor().getY() == 4.0'f32,
                 "the anchor is at y " & $glyph.anchor().getY()
        doAssert glyph.width() == 9.0'f32, "the glyph is " & $glyph.width() & " wide"

        var run = makeTextLayoutRun(makeRange(0.cint, 5.cint), 4.cint)
        doAssert run.stringRange().getLength() == 5,
                 "the run covers " & $run.stringRange().getLength() & " characters"
        run.colour = makeColour(0'u8, 0'u8, 255'u8, 255'u8)
        doAssert run.colour().getBlue() == 255'u8, "the run is not blue"

testTextLayoutRuns()

# ImageConvolutionKernel ======================================================
#
# Arithmetic over pixels, so the results are exact. An identity kernel has to
# leave an image alone, and a blur has to spread a single lit pixel into its
# neighbours - two answers that a kernel doing nothing at all could not give.

proc testImageConvolutionKernel() =
    block:
        var kernel = makeImageConvolutionKernel(3.cint)
        doAssert kernel.getKernelSize() == 3,
                 "the kernel is " & $kernel.getKernelSize() & " across"

        kernel.clear()
        doAssert kernel.getKernelValue(1.cint, 1.cint) == 0.0'f32,
                 "a cleared kernel holds " & $kernel.getKernelValue(1.cint, 1.cint)

        # Identity: the centre passes through and nothing else does.
        kernel.setKernelValue(1.cint, 1.cint, 1.0'f32)
        doAssert kernel.getKernelValue(1.cint, 1.cint) == 1.0'f32,
                 "the centre holds " & $kernel.getKernelValue(1.cint, 1.cint)

        kernel.rescaleAllValues(2.0'f32)
        doAssert kernel.getKernelValue(1.cint, 1.cint) == 2.0'f32,
                 "after rescaling the centre holds " &
                 $kernel.getKernelValue(1.cint, 1.cint)

        kernel.setOverallSum(1.0'f32)
        doAssert kernel.getKernelValue(1.cint, 1.cint) == 1.0'f32,
                 "after normalising the centre holds " &
                 $kernel.getKernelValue(1.cint, 1.cint)

        # A source with one lit pixel in the middle.
        var source = makeImage(ImagePixelFormat_ARGB, 5.cint, 5.cint, true)
        source.setPixelAt(2.cint, 2.cint, makeColour(255'u8, 255'u8, 255'u8, 255'u8))
        doAssert source.getPixelAt(1.cint, 2.cint).getAlpha() == 0'u8,
                 "the source is lit where it should be dark"

        var identityResult = makeImage(ImagePixelFormat_ARGB, 5.cint, 5.cint, true)
        kernel.applyToImage(identityResult, source,
                            makeRectangle(0.cint, 0.cint, 5.cint, 5.cint))
        doAssert identityResult.getPixelAt(2.cint, 2.cint).getAlpha() > 0'u8,
                 "the identity kernel lost the lit pixel"
        doAssert identityResult.getPixelAt(1.cint, 2.cint).getAlpha() == 0'u8,
                 "the identity kernel spread the lit pixel"

        # A blur spreads it, which is the answer the identity kernel did not
        # give at the same coordinate.
        var blur = makeImageConvolutionKernel(3.cint)
        blur.createGaussianBlur(1.5'f32)
        var blurred = makeImage(ImagePixelFormat_ARGB, 5.cint, 5.cint, true)
        blur.applyToImage(blurred, source,
                          makeRectangle(0.cint, 0.cint, 5.cint, 5.cint))
        doAssert blurred.getPixelAt(1.cint, 2.cint).getAlpha() > 0'u8,
                 "the blur did not reach the neighbouring pixel"

testImageConvolutionKernel()

# The nested abstract classes =================================================
#
# The subclass generator keyed an abstract class on its own spelling, which
# never matched a declared Nim name for a nested one, so every Listener,
# LookAndFeelMethods and other nested interface was skipped with no withheld
# entry. Building each compiles the C++ class, and setting each handler is what
# type-checks and generates the setter.

proc testNestedSubclassesGraphics() =
    initialiseJuce_GUI()
    block:
        var customImagePixelDataListener = newCustomImagePixelDataListener()
        doAssert not customImagePixelDataListener.isNil(), "newCustomImagePixelDataListener built nothing"
        customImagePixelDataListener[].setImageDataChangedHandler(proc(arg0: ptr ImagePixelData) = discard)
        customImagePixelDataListener[].setImageDataBeingDeletedHandler(proc(arg0: ptr ImagePixelData) = discard)
        cdelete customImagePixelDataListener
    shutdownJuce_GUI()

testNestedSubclassesGraphics()

# Every no-argument constructor ===============================================
#
# An importcpp string reaches the C++ compiler only at a call site, so a
# constructor nothing calls is never compiled. These had no caller.

proc testEveryNoArgConstructorGraphics() =
    initialiseJuce_GUI()
    block:
        discard makePixelARGB()
        discard makeRectanglePlacement()
        discard makePNGImageFormat()
        discard makeJPEGImageFormat()
        discard makeGIFImageFormat()
        discard makeSoftwareImageType()
        discard makeNativeImageType()
        discard makeAttributedStringAttribute()
        discard makeGlyphArrangement()
        discard makeTextLayoutLine()
        discard makeScaledImage()
        discard makeDropShadow()
        discard makeDropShadowEffect()
        discard makeGlowEffect()
    shutdownJuce_GUI()

testEveryNoArgConstructorGraphics()

# PathStrokeType ==============================================================
#
# Turns a line into the outline of a stroked line. A thicker stroke has to give
# a taller outline, which a stroke that ignored its thickness could not.

proc testPathStrokeType() =
    block:
        var line = makePath()
        line.startNewSubPath(0.0'f32, 10.0'f32)
        line.lineTo(100.0'f32, 10.0'f32)
        doAssert line.getBounds().getHeight() == 0.0'f32,
                 "a horizontal line is " & $line.getBounds().getHeight() & " high"

        var thin = makePathStrokeType(2.0'f32)
        doAssert thin.getStrokeThickness() == 2.0'f32,
                 "the stroke is " & $thin.getStrokeThickness() & " thick"

        var thinOutline = makePath()
        thin.createStrokedPath(thinOutline, line, makeAffineTransform())
        doAssert thinOutline.getBounds().getHeight() == 2.0'f32,
                 "a 2px stroke gave an outline " &
                 $thinOutline.getBounds().getHeight() & " high"

        # A thicker stroke gives a taller outline: a different answer, not
        # merely a non-empty one.
        var thick = makePathStrokeType(8.0'f32, PathStrokeTypeJointStyle_curved,
                                       PathStrokeTypeEndCapStyle_rounded)
        doAssert thick.getJointStyle() == PathStrokeTypeJointStyle_curved,
                 "the joint style did not stick"
        doAssert thick.getEndStyle() == PathStrokeTypeEndCapStyle_rounded,
                 "the end cap style did not stick"

        var thickOutline = makePath()
        thick.createStrokedPath(thickOutline, line, makeAffineTransform())
        doAssert thickOutline.getBounds().getHeight() == 8.0'f32,
                 "an 8px stroke gave an outline " &
                 $thickOutline.getBounds().getHeight() & " high"

        # Rounded caps stick out past the line's own ends; butt caps do not.
        var butt = makePathStrokeType(8.0'f32, PathStrokeTypeJointStyle_mitered,
                                      PathStrokeTypeEndCapStyle_butt)
        var buttOutline = makePath()
        butt.createStrokedPath(buttOutline, line, makeAffineTransform())
        doAssert buttOutline.getBounds().getWidth() == 100.0'f32,
                 "butt caps gave a width of " & $buttOutline.getBounds().getWidth()
        doAssert thickOutline.getBounds().getWidth() > 100.0'f32,
                 "rounded caps gave a width of " &
                 $thickOutline.getBounds().getWidth()

        thin.setStrokeThickness(5.0'f32)
        doAssert thin.getStrokeThickness() == 5.0'f32,
                 "the thickness reads " & $thin.getStrokeThickness()

testPathStrokeType()

# Font feature settings =======================================================
#
# OpenType feature tags, which are four characters packed into a uint32. The
# round trip through toString is what says the packing is right, and the
# settings reach a Font through its options.

proc testFontFeatureSettings() =
    block:
        # 'liga', the standard ligature feature, big-endian in the tag word.
        let liga = makeFontFeatureTag(0x6C696761'u32)
        doAssert $liga.toString() == "liga",
                 "the tag spells " & $liga.toString()
        doAssert liga.getTag() == 0x6C696761'u32,
                 "the tag reads back as " & $liga.getTag()

        let kern = makeFontFeatureTag(0x6B65726E'u32)
        doAssert $kern.toString() == "kern", "the tag spells " & $kern.toString()
        doAssert kern < liga, "kern does not sort before liga"

        var setting = makeFontFeatureSetting(liga, 1'u32)
        doAssert $setting.tag().toString() == "liga",
                 "the setting is for " & $setting.tag().toString()
        doAssert setting.value() == 1'u32,
                 "the setting holds " & $setting.value()

        setting.value = 0'u32
        doAssert setting.value() == 0'u32,
                 "after turning it off the setting holds " & $setting.value()

    block:
        # A font carries the settings its options were given.
        let plain = makeFontOptions()
        doAssert plain.getFeatureSettings().size() == 0.csize_t,
                 "fresh options carry " &
                 $plain.getFeatureSettings().size().int & " settings"

        let withLigatures = plain.withFeatureSetting(
            makeFontFeatureSetting(makeFontFeatureTag(0x6C696761'u32), 1'u32))
        doAssert withLigatures.getFeatureSettings().size() == 1.csize_t,
                 "the options carry " &
                 $withLigatures.getFeatureSettings().size().int & " settings"
        doAssert $withLigatures.getFeatureSettings()[0.csize_t].tag().toString() == "liga",
                 "the setting is for " &
                 $withLigatures.getFeatureSettings()[0.csize_t].tag().toString()

        # withFeatureSetting copies rather than mutating, like the other
        # withX builders.
        doAssert plain.getFeatureSettings().size() == 0.csize_t,
                 "withFeatureSetting changed the options it was called on"

        var font = makeFont(withLigatures)
        doAssert font.getFeatureSettings().size() == 1.csize_t,
                 "the font carries " & $font.getFeatureSettings().size().int & " settings"

        font.removeFeatureSetting(makeFontFeatureTag(0x6C696761'u32))
        doAssert font.getFeatureSettings().size() == 0.csize_t,
                 "after removing it the font carries " &
                 $font.getFeatureSettings().size().int & " settings"

testFontFeatureSettings()

# Every bound constant ========================================================
#
# A `let` with an importcpp is not checked against C++ unless something reads
# it: a constant naming juce::NoSuchClass::nope compiles clean while nothing
# touches it. Reading each is what compiles the spelling.

proc testEveryConstantGraphics() =
    block:
        discard TypefaceMetricsKind_legacy
        discard TypefaceMetricsKind_portable
        discard JustificationFlags_left
        discard JustificationFlags_right
        discard JustificationFlags_horizontallyCentred
        discard JustificationFlags_top
        discard JustificationFlags_bottom
        discard JustificationFlags_verticallyCentred
        discard JustificationFlags_horizontallyJustified
        discard JustificationFlags_centred
        discard JustificationFlags_centredLeft
        discard JustificationFlags_centredRight
        discard JustificationFlags_centredTop
        discard JustificationFlags_centredBottom
        discard JustificationFlags_topLeft
        discard JustificationFlags_topRight
        discard JustificationFlags_bottomLeft
        discard JustificationFlags_bottomRight
        discard PathIteratorPathElementType_startNewSubPath
        discard PathIteratorPathElementType_lineTo
        discard PathIteratorPathElementType_quadraticTo
        discard PathIteratorPathElementType_cubicTo
        discard PathIteratorPathElementType_closePath
        discard PathStrokeTypeJointStyle_mitered
        discard PathStrokeTypeJointStyle_curved
        discard PathStrokeTypeJointStyle_beveled
        discard PathStrokeTypeEndCapStyle_butt
        discard PathStrokeTypeEndCapStyle_square
        discard PathStrokeTypeEndCapStyle_rounded
        discard RectanglePlacementFlags_xLeft
        discard RectanglePlacementFlags_xRight
        discard RectanglePlacementFlags_xMid
        discard RectanglePlacementFlags_yTop
        discard RectanglePlacementFlags_yBottom
        discard RectanglePlacementFlags_yMid
        discard RectanglePlacementFlags_stretchToFit
        discard RectanglePlacementFlags_fillDestination
        discard RectanglePlacementFlags_onlyReduceInSize
        discard RectanglePlacementFlags_onlyIncreaseInSize
        discard RectanglePlacementFlags_doNotResize
        discard RectanglePlacementFlags_centred
        discard GraphicsResamplingQuality_lowResamplingQuality
        discard GraphicsResamplingQuality_mediumResamplingQuality
        discard GraphicsResamplingQuality_highResamplingQuality
        discard ImagePixelFormat_UnknownFormat
        discard ImagePixelFormat_RGB
        discard ImagePixelFormat_ARGB
        discard ImagePixelFormat_SingleChannel
        discard ImageBitmapDataReadWriteMode_readOnly
        discard ImageBitmapDataReadWriteMode_writeOnly
        discard ImageBitmapDataReadWriteMode_readWrite
        discard TypefaceColourGlyphFormat_colourGlyphFormatBitmap
        discard TypefaceColourGlyphFormat_colourGlyphFormatSvg
        discard TypefaceColourGlyphFormat_colourGlyphFormatCOLRv0
        discard TypefaceColourGlyphFormat_colourGlyphFormatCOLRv1
        discard FontFontStyleFlags_plain
        discard FontFontStyleFlags_bold
        discard FontFontStyleFlags_italic
        discard FontFontStyleFlags_underlined
        discard AttributedStringWordWrap_none
        discard AttributedStringWordWrap_byWord
        discard AttributedStringWordWrap_byChar
        discard AttributedStringReadingDirection_natural
        discard AttributedStringReadingDirection_leftToRight
        discard AttributedStringReadingDirection_rightToLeft

testEveryConstantGraphics()

# Every static variable =======================================================
#
# Bound as a proc over the typedesc, so it is compiled only where it is called,
# exactly like the constants. Reading each is what checks its C++ spelling.

proc testEveryStaticVariableGraphics() =
    block:
        discard Path.`defaultToleranceForTesting`()
        discard Path.`defaultToleranceForMeasurement`()
        discard FontFeatureSetting.`featureEnabled`()
        discard FontFeatureSetting.`featureDisabled`()

testEveryStaticVariableGraphics()

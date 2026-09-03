
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

# Graphics::ScopedSaveState ===================================================
#
# Saves the graphics state on construction and restores it when the scope ends,
# so a clip applied inside it does not survive.

proc testScopedSaveState() =
    block:
        let surface = makeImage(ImagePixelFormat_ARGB, 20.cint, 20.cint, true)
        var context = makeGraphics(surface)
        context.setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))

        block:
            let saved = makeGraphicsScopedSaveState(context)
            discard context.reduceClipRegion(makeRectangle(0.cint, 0.cint, 5.cint, 5.cint))
            context.fillAll()

        # The clip went with the scope, so this fill reaches the whole surface.
        context.fillAll()
        doAssert surface.getPixelAt(15.cint, 15.cint).getRed() == 255'u8,
                 "the clip outlived the scope that set it"

testScopedSaveState()

# The graphics iterators yield exactly what their containers hold ==============
#
# Each is a hand-written loop over the indexed accessors, so an off-by-one has
# nothing to disagree with it. The count is checked against the container's own
# answer, and the order against indexed access.

proc testGraphicsIteratorsAreComplete() =
    block:
        var glyphs = makeGlyphArrangement()
        glyphs.addLineOfText(makeFont(makeFontOptions()), makeString("abcdef"),
                             0.0'f32, 10.0'f32)
        doAssert glyphs.getNumGlyphs() > 0, "the arrangement laid out no glyphs"

        var walked = 0
        var lastX = -1.0'f32
        for glyph in glyphs:
            doAssert glyph.getLeft() >= lastX,
                     "glyph " & $walked & " starts left of the one before it"
            lastX = glyph.getLeft()
            walked += 1
        doAssert walked == glyphs.getNumGlyphs().int,
                 "GlyphArrangement yielded " & $walked & " of " &
                 $glyphs.getNumGlyphs()

    block:
        var region: RectangleList[cint]
        for index in 0 ..< 4:
            region.add(makeRectangle((index * 20).cint, 0.cint, 10.cint, 10.cint))

        var seen: seq[cint] = @[]
        for rectangle in region:
            seen.add(rectangle.getX())
        doAssert seen.len == region.getNumRectangles().int,
                 "RectangleList yielded " & $seen.len & " of " &
                 $region.getNumRectangles()
        for index in 0 ..< seen.len:
            doAssert seen[index] == region.getRectangle(index.cint).getX(),
                     "RectangleList yielded x=" & $seen[index] & " at " & $index

    block:
        # An OwnedArray is only ever handed out by JUCE, and a laid-out line of
        # text is where one with anything in it comes from.
        var text = makeAttributedString(makeString("one two three"))
        var layout = makeTextLayout()
        layout.createLayout(text, 200.0'f32)
        doAssert layout.getNumLines() > 0, "the layout produced no lines"

        # The var getter, which hands back the field itself. There is no
        # by-value one: OwnedArray deletes its copy constructor, so the
        # generator withholds that getter with the reason on the line.
        var line = layout.getLine(0.cint)
        doAssert line.runs().size() > 0, "the line holds no runs"

        var walked = 0
        for run in line.runs():
            doAssert not run.isNil, "a run came back nil"
            walked += 1
        doAssert walked == line.runs().size().int,
                 "OwnedArray yielded " & $walked & " of " & $line.runs().size()

# Bracketed, like the other tests that reach a Font: the shared typeface cache
# is torn down by the GUI shutdown, and built outside one it is reported as a
# leak at exit.
initialiseJuce_GUI()
testGraphicsIteratorsAreComplete()
shutdownJuce_GUI()

# What a generated constructor forwards ========================================
#
# The forwarding constructor with mixed argument types: an enum and two ints
# for the pixel data, two Strings for the typeface. Building one proves the
# arguments type-check, which is what the coverage check requires; reading them
# back is what proves they arrive in the order they were given.

proc testGeneratedConstructorsForwardGraphics() =
    block:
        let data = newCustomImagePixelData(ImagePixelFormat_ARGB, 13.cint, 29.cint)
        doAssert data[].pixelFormat() == ImagePixelFormat_ARGB,
                 "the pixel data has a different format from the one given"
        doAssert data[].width() == 13,
                 "the pixel data is " & $data[].width() & " wide, not 13"
        doAssert data[].height() == 29,
                 "the pixel data is " & $data[].height() & " tall, not 29"
        cdelete data

    block:
        let typeface = newCustomTypeface(makeString("a name"), makeString("a style"))
        doAssert $typeface[].getName() == "a name",
                 "the typeface is called " & $typeface[].getName()
        doAssert $typeface[].getStyle() == "a style",
                 "the typeface style is " & $typeface[].getStyle()
        cdelete typeface

initialiseJuce_GUI()
testGeneratedConstructorsForwardGraphics()
shutdownJuce_GUI()


# Every public field round-trips ===============================================
#
# A field getter and setter are importcpp procs like any other: they reach the
# C++ compiler only where something calls them, so a setter nothing assigns is
# never compiled. Each is set to a distinctive value and read back; where the
# field's type compares, the read is asserted against what went in.

proc testFieldRoundTrips() =
    block:
        var value = makeAffineTransform()
        value.mat00 = 1.5'f32
        doAssert value.mat00() == 1.5'f32,
                 "AffineTransform.mat00 came back as " & $value.mat00()
        value.mat01 = 1.5'f32
        doAssert value.mat01() == 1.5'f32,
                 "AffineTransform.mat01 came back as " & $value.mat01()
        value.mat02 = 1.5'f32
        doAssert value.mat02() == 1.5'f32,
                 "AffineTransform.mat02 came back as " & $value.mat02()
        value.mat10 = 1.5'f32
        doAssert value.mat10() == 1.5'f32,
                 "AffineTransform.mat10 came back as " & $value.mat10()
        value.mat11 = 1.5'f32
        doAssert value.mat11() == 1.5'f32,
                 "AffineTransform.mat11 came back as " & $value.mat11()
        value.mat12 = 1.5'f32
        doAssert value.mat12() == 1.5'f32,
                 "AffineTransform.mat12 came back as " & $value.mat12()
    block:
        var value = makeAttributedStringAttribute()
        value.font = makeFont()
        discard value.font()
        value.range = makeRange(1.cint, 5.cint)
        discard value.range()
    block:
        var value = makeColourGradient()
        value.isRadial = true
        doAssert value.isRadial() == true,
                 "ColourGradient.isRadial came back as " & $value.isRadial()
        value.point1 = makePoint(1.0'f32, 2.0'f32)
        discard value.point1()
        value.point2 = makePoint(1.0'f32, 2.0'f32)
        discard value.point2()
    block:
        var value = makeDropShadow()
        value.offset = makePoint(1.cint, 2.cint)
        discard value.offset()
        value.radius = 7.cint
        doAssert value.radius() == 7.cint,
                 "DropShadow.radius came back as " & $value.radius()
    block:
        var value = makeFillType()
        value.image = makeImage()
        discard value.image()
        value.transform = makeAffineTransform()
        discard value.transform()
    block:
        var value = makeImageLayer()
        value.image = makeImage()
        discard value.image()
        value.transform = makeAffineTransform()
        discard value.transform()
    block:
        var value = makeTextLayoutLine()
        value.descent = 1.5'f32
        doAssert value.descent() == 1.5'f32,
                 "TextLayoutLine.descent came back as " & $value.descent()
        value.leading = 1.5'f32
        doAssert value.leading() == 1.5'f32,
                 "TextLayoutLine.leading came back as " & $value.leading()
        value.lineOrigin = makePoint(1.0'f32, 2.0'f32)
        discard value.lineOrigin()
        value.stringRange = makeRange(1.cint, 5.cint)
        discard value.stringRange()
    block:
        var value = makeTextLayoutRun()
        value.font = makeFont()
        discard value.font()
        value.stringRange = makeRange(1.cint, 5.cint)
        discard value.stringRange()
    block:
        var value = makeTypefaceMetrics()
        value.heightToPoints = 1.5'f32
        doAssert value.heightToPoints() == 1.5'f32,
                 "TypefaceMetrics.heightToPoints came back as " & $value.heightToPoints()

testFieldRoundTrips()

# The remaining graphics fields ================================================

proc testRemainingGraphicsFields() =
    block:
        var fill = makeFillType()
        fill.gradient = makeUniquePtr[ColourGradient]()
        doAssert fill.gradient().isNil, "the gradient is not the empty one it was set to"

    block:
        var setting = makeFontFeatureSetting(makeFontFeatureTag(0x6C696761'u32),
                                             1'u32)
        setting.tag = makeFontFeatureTag(0x6B65726E'u32)
        discard setting.tag()

    block:
        var iterator1 = makePathIterator(makePath())
        iterator1.elementType = PathIteratorPathElementType_startNewSubPath
        iterator1.x1 = 1.0'f32
        iterator1.y1 = 2.0'f32
        iterator1.x2 = 3.0'f32
        iterator1.y2 = 4.0'f32
        iterator1.x3 = 5.0'f32
        iterator1.y3 = 6.0'f32
        doAssert iterator1.elementType() == PathIteratorPathElementType_startNewSubPath,
                 "the element type did not come back as it was set"
        doAssert iterator1.x1() == 1.0'f32 and iterator1.y1() == 2.0'f32,
                 "the first point is " & $iterator1.x1() & "," & $iterator1.y1()
        doAssert iterator1.x2() == 3.0'f32 and iterator1.y2() == 4.0'f32,
                 "the second point is " & $iterator1.x2() & "," & $iterator1.y2()
        doAssert iterator1.x3() == 5.0'f32 and iterator1.y3() == 6.0'f32,
                 "the third point is " & $iterator1.x3() & "," & $iterator1.y3()

    block:
        var flat = makePathFlatteningIterator(makePath(), makeAffineTransform(),
                                              6.0'f32)
        flat.x1 = 1.0'f32
        flat.y1 = 2.0'f32
        flat.x2 = 3.0'f32
        flat.y2 = 4.0'f32
        flat.closesSubPath = true
        flat.subPathIndex = 2.cint
        doAssert flat.x1() == 1.0'f32 and flat.y2() == 4.0'f32,
                 "the flattened points did not come back as they were set"
        doAssert flat.closesSubPath(), "closesSubPath came back false"
        doAssert flat.subPathIndex() == 2,
                 "the sub-path index is " & $flat.subPathIndex()

    block:
        var glyph = makeTextLayoutGlyph(7.cint, makePoint(1.0'f32, 2.0'f32), 3.0'f32)
        glyph.glyphCode = 9.cint
        glyph.anchor = makePoint(4.0'f32, 5.0'f32)
        doAssert glyph.glyphCode() == 9, "the glyph code is " & $glyph.glyphCode()
        doAssert glyph.anchor() == makePoint(4.0'f32, 5.0'f32),
                 "the anchor did not come back as it was set"

    block:
        var run = makeTextLayoutRun()
        discard run.glyphs()
        var line = makeTextLayoutLine()
        discard line.runs()

    block:
        var relative = makeRelativePointPath()
        discard relative.elements()

initialiseJuce_GUI()
testRemainingGraphicsFields()
shutdownJuce_GUI()

# The image data fields ========================================================
#
# BitmapData is how a program reaches an Image's pixels, and its fields are the
# whole description of the buffer: none had been written or read.

proc testImageDataFields() =
    block:
        var image = makeImage(ImagePixelFormat_ARGB, 8.cint, 6.cint, true)
        var data = makeImageBitmapData(image, 0.cint, 0.cint, 8.cint, 6.cint,
                                       ImageBitmapDataReadWriteMode_readWrite)

        doAssert data.width() == 8, "the data is " & $data.width() & " wide"
        doAssert data.height() == 6, "the data is " & $data.height() & " tall"
        doAssert data.pixelFormat() == ImagePixelFormat_ARGB,
                 "the pixel format is not the image's"
        doAssert data.pixelStride() == 4,
                 "an ARGB pixel is " & $data.pixelStride() & " bytes"
        doAssert data.lineStride() >= data.width() * data.pixelStride(),
                 "the line stride is " & $data.lineStride() &
                 ", less than a row of pixels"
        doAssert data.size() > 0'u64, "the buffer reports no size"
        doAssert data.data() != nil, "the buffer has no data pointer"

        # Written as well as read, which is what puts the setters in front of
        # the compiler. The values go back to what they were.
        let stride = data.lineStride()
        data.lineStride = 99.cint
        doAssert data.lineStride() == 99,
                 "the line stride is " & $data.lineStride() & " after being set"
        data.lineStride = stride
        data.pixelStride = data.pixelStride()
        data.width = data.width()
        data.height = data.height()
        data.pixelFormat = data.pixelFormat()
        data.size = data.size()
        data.data = data.data()
        data.dataReleaser = makeUniquePtr[ImageBitmapDataBitmapDataReleaser]()
        doAssert data.dataReleaser().isNil,
                 "the releaser is not the empty pointer it was set to"

    block:
        let pixels = newCustomImagePixelData(ImagePixelFormat_ARGB, 4.cint, 4.cint)
        pixels[].userData = makeNamedValueSet()
        doAssert pixels[].userData().size() == 0,
                 "the user data holds " & $pixels[].userData().size() & " entries"
        doAssert pixels[].pixelFormat() == ImagePixelFormat_ARGB,
                 "the pixel data format is not the one it was built with"
        cdelete pixels

initialiseJuce_GUI()
testImageDataFields()
shutdownJuce_GUI()

# TextLayoutRun's glyphs =======================================================

proc testTextLayoutRunGlyphs() =
    var run = makeTextLayoutRun()
    run.glyphs = makeArray[TextLayoutGlyph]()
    doAssert run.glyphs().size() == 0,
             "the run holds " & $run.glyphs().size() & " glyphs"

testTextLayoutRunGlyphs()

# Font's metrics and its style flags. testFont above covers height and bold;
# this covers the two height scales, the derived metrics, italic, underline,
# and the horizontal scale and kerning that a caller sets alongside them.
proc testFontMetrics() =
    # A real typeface is loaded here, and the cache that holds it is cleared
    # by shutdownJuce_GUI. Without the pair the run ends with a leak report.
    initialiseJuce_GUI()

    block:
        var font = makeFont(makeFontOptions(24.0'f32))

        # A font is measured either in pixels or in points, and the two are
        # related by a factor the font reports.
        let factor = font.getHeightToPointsFactor()
        doAssert factor > 0.0'f32, "the height to points factor is " & $factor
        doAssert abs(font.getHeightInPoints() - 24.0'f32 * factor) < 1.0e-3'f32,
                 "24 pixels is " & $font.getHeightInPoints() & " points, and the " &
                 "factor says it should be " & $(24.0'f32 * factor)

        # setPointHeight sets the other scale, and the pixel height follows.
        font.setPointHeight(36.0'f32)
        doAssert abs(font.getHeightInPoints() - 36.0'f32) < 1.0e-3'f32,
                 "the point height is " & $font.getHeightInPoints()
        doAssert abs(font.getHeight() - 36.0'f32 / factor) < 1.0e-3'f32,
                 "the pixel height is " & $font.getHeight() & " and not " &
                 $(36.0'f32 / factor)

        # withPointHeight leaves the receiver alone, as withHeight does.
        let inPoints = font.withPointHeight(12.0'f32)
        doAssert abs(inPoints.getHeightInPoints() - 12.0'f32) < 1.0e-3'f32,
                 "withPointHeight gave " & $inPoints.getHeightInPoints()
        doAssert abs(font.getHeightInPoints() - 36.0'f32) < 1.0e-3'f32,
                 "withPointHeight mutated the original"

    block:
        # Ascent and descent divide the height between them.
        let font = makeFont(makeFontOptions(32.0'f32))
        doAssert font.getAscent() > 0.0'f32,
                 "the ascent is " & $font.getAscent()
        doAssert font.getDescent() > 0.0'f32,
                 "the descent is " & $font.getDescent()
        doAssert abs(font.getAscent() + font.getDescent() - font.getHeight()) <
                 1.0e-3'f32,
                 "the ascent " & $font.getAscent() & " and descent " &
                 $font.getDescent() & " do not add up to the height " &
                 $font.getHeight()

        # The point forms are equal to the pixel forms, and that is not a
        # coincidence of this typeface. getAscent scales the raw ascent by
        # 1/(ascent+descent) and multiplies by the pixel height, while
        # getAscentInPoints multiplies the raw ascent by the point height,
        # which is the pixel height times that same 1/(ascent+descent)
        # (juce_Font.cpp:796 and :827). The two expressions are the same
        # product in a different order.
        doAssert abs(font.getAscentInPoints() - font.getAscent()) < 1.0e-3'f32,
                 "the ascent is " & $font.getAscent() & " but " &
                 $font.getAscentInPoints() & " in points"
        doAssert abs(font.getDescentInPoints() - font.getDescent()) < 1.0e-3'f32,
                 "the descent is " & $font.getDescent() & " but " &
                 $font.getDescentInPoints() & " in points"

    block:
        # Italic and underline are independent of one another and of bold.
        var font = makeFont(makeFontOptions(16.0'f32))
        doAssert not font.isItalic(), "a plain font is italic"
        doAssert not font.isUnderlined(), "a plain font is underlined"
        doAssert not font.isBold(), "a plain font is bold"

        font.setItalic(true)
        doAssert font.isItalic(), "setItalic did not take"
        doAssert not font.isBold(), "setItalic made the font bold too"
        doAssert not font.isUnderlined(), "setItalic underlined the font too"

        font.setUnderline(true)
        doAssert font.isUnderlined(), "setUnderline did not take"
        doAssert font.isItalic(), "setUnderline dropped italic"

        # italicised derives a copy; the receiver keeps its own flags.
        var plain = makeFont(makeFontOptions(16.0'f32))
        let slanted = plain.italicised()
        doAssert slanted.isItalic(), "italicised produced an upright font"
        doAssert not plain.isItalic(), "italicised mutated the original"

        # setStyleFlags replaces the set rather than adding to it.
        var styled = makeFont(makeFontOptions(16.0'f32))
        styled.setStyleFlags(FontFontStyleFlags_bold.cint or
                             FontFontStyleFlags_italic.cint)
        doAssert styled.isBold() and styled.isItalic(),
                 "setting two flags at once lost one of them"
        styled.setStyleFlags(FontFontStyleFlags_plain.cint)
        doAssert not styled.isBold() and not styled.isItalic(),
                 "setStyleFlags added to the set instead of replacing it"

    block:
        # The horizontal scale and the extra kerning both round trip, and the
        # with- forms leave the receiver alone.
        var font = makeFont(makeFontOptions(20.0'f32))
        doAssert font.getHorizontalScale() == 1.0'f32,
                 "the default horizontal scale is " & $font.getHorizontalScale()
        doAssert font.getExtraKerningFactor() == 0.0'f32,
                 "the default kerning is " & $font.getExtraKerningFactor()

        font.setHorizontalScale(1.5'f32)
        doAssert abs(font.getHorizontalScale() - 1.5'f32) < 1.0e-6'f32,
                 "the horizontal scale is " & $font.getHorizontalScale()
        font.setExtraKerningFactor(0.25'f32)
        doAssert abs(font.getExtraKerningFactor() - 0.25'f32) < 1.0e-6'f32,
                 "the kerning is " & $font.getExtraKerningFactor()

        let wider = font.withHorizontalScale(2.0'f32)
        doAssert abs(wider.getHorizontalScale() - 2.0'f32) < 1.0e-6'f32,
                 "withHorizontalScale gave " & $wider.getHorizontalScale()
        doAssert abs(font.getHorizontalScale() - 1.5'f32) < 1.0e-6'f32,
                 "withHorizontalScale mutated the original"

        let kerned = font.withExtraKerningFactor(0.5'f32)
        doAssert abs(kerned.getExtraKerningFactor() - 0.5'f32) < 1.0e-6'f32,
                 "withExtraKerningFactor gave " & $kerned.getExtraKerningFactor()
        doAssert abs(font.getExtraKerningFactor() - 0.25'f32) < 1.0e-6'f32,
                 "withExtraKerningFactor mutated the original"

        # A wider font is a different font, and equality notices.
        doAssert not (font == wider), "two fonts of different width are equal"
        doAssert font == font.withHorizontalScale(1.5'f32),
                 "a font is not equal to a copy of itself"

    block:
        # The typeface name and style are text, and a font names the family it
        # was asked for even before anything is drawn with it.
        var font = makeFont(makeFontOptions(18.0'f32))
        font.setTypefaceName(Font.getDefaultMonospacedFontName())
        doAssert $font.getTypefaceName() == $Font.getDefaultMonospacedFontName(),
                 "the typeface name reads as " & $font.getTypefaceName()

        doAssert Font.getDefaultSansSerifFontName().isNotEmpty(),
                 "the default sans serif name is empty"
        doAssert Font.getDefaultSerifFontName().isNotEmpty(),
                 "the default serif name is empty"
        doAssert Font.getDefaultStyle().isNotEmpty(),
                 "the default style is empty"

        # A font survives a round trip through its own string form.
        let described = font.toString()
        doAssert described.isNotEmpty(), "toString gave an empty description"
        let rebuilt = Font.fromString(described)
        doAssert $rebuilt.toString() == $described,
                 "a round trip turned " & $described & " into " & $rebuilt.toString()

    shutdownJuce_GUI()

testFontMetrics()

# Colour is a value type over a packed ARGB word, with three ways of naming the
# same colour: bytes, floats, and the HSV/HSL polar forms. The invariant worth
# asserting is that all three agree, and that the with- forms change one
# component and leave the rest alone.
proc testColour() =
    block:
        # The bytes go in and come back out unchanged.
        let orange = Colour.fromRGB(255'u8, 128'u8, 0'u8)
        doAssert orange.getRed() == 255'u8, "red is " & $orange.getRed()
        doAssert orange.getGreen() == 128'u8, "green is " & $orange.getGreen()
        doAssert orange.getBlue() == 0'u8, "blue is " & $orange.getBlue()

        # fromRGB is opaque; fromRGBA carries the alpha through.
        doAssert orange.getAlpha() == 255'u8,
                 "fromRGB gave alpha " & $orange.getAlpha()
        doAssert orange.isOpaque(), "an opaque colour reports transparent"
        doAssert not orange.isTransparent(), "an opaque colour reports transparent"

        let half = Colour.fromRGBA(255'u8, 128'u8, 0'u8, 128'u8)
        doAssert half.getAlpha() == 128'u8, "the alpha is " & $half.getAlpha()
        doAssert not half.isOpaque(), "a half transparent colour reports opaque"
        doAssert not half.isTransparent(),
                 "a half transparent colour reports fully transparent"

        let invisible = orange.withAlpha(0'u8)
        doAssert invisible.isTransparent(),
                 "a zero alpha colour is not transparent"
        doAssert invisible.getRed() == 255'u8,
                 "withAlpha changed the red channel to " & $invisible.getRed()

        # The packed word holds all four channels.
        doAssert orange.getARGB() == 0xFFFF8000'u32,
                 "the packed word is " & $orange.getARGB()

        # Two colours built the same way are equal; a different alpha is a
        # different colour.
        doAssert orange == Colour.fromRGB(255'u8, 128'u8, 0'u8),
                 "two identical colours are not equal"
        doAssert not (orange == half), "alpha is not part of the identity"

    block:
        # The float channels are the byte channels over 255.
        let colour = Colour.fromRGB(255'u8, 0'u8, 51'u8)
        doAssert abs(colour.getFloatRed() - 1.0'f32) < 1.0e-6'f32,
                 "float red is " & $colour.getFloatRed()
        doAssert abs(colour.getFloatGreen()) < 1.0e-6'f32,
                 "float green is " & $colour.getFloatGreen()
        doAssert abs(colour.getFloatBlue() - 51.0'f32 / 255.0'f32) < 1.0e-6'f32,
                 "float blue is " & $colour.getFloatBlue()
        doAssert abs(colour.getFloatAlpha() - 1.0'f32) < 1.0e-6'f32,
                 "float alpha is " & $colour.getFloatAlpha()

        # And the float constructor is the inverse of the float accessors.
        let rebuilt = Colour.fromFloatRGBA(colour.getFloatRed(),
                                           colour.getFloatGreen(),
                                           colour.getFloatBlue(),
                                           colour.getFloatAlpha())
        doAssert rebuilt == colour,
                 "a round trip through the float channels changed the colour"

    block:
        # HSV: a pure hue has full saturation and full brightness, and the hue
        # survives the trip.
        let red = Colour.fromHSV(0.0'f32, 1.0'f32, 1.0'f32, 1.0'f32)
        doAssert red.getRed() == 255'u8 and red.getGreen() == 0'u8 and
                 red.getBlue() == 0'u8,
                 "hue 0 is not red; it is " & $red.toString()
        doAssert abs(red.getSaturation() - 1.0'f32) < 1.0e-3'f32,
                 "the saturation is " & $red.getSaturation()
        doAssert abs(red.getBrightness() - 1.0'f32) < 1.0e-3'f32,
                 "the brightness is " & $red.getBrightness()

        # A third of the way round the wheel is green.
        let green = Colour.fromHSV(1.0'f32 / 3.0'f32, 1.0'f32, 1.0'f32, 1.0'f32)
        doAssert green.getGreen() == 255'u8 and green.getRed() == 0'u8,
                 "a third of the way round is not green; it is " & $green.toString()

        # getHSB reports the same three numbers the constructor took.
        var hue, saturation, brightness: cfloat
        green.getHSB(hue, saturation, brightness)
        doAssert abs(hue - 1.0'f32 / 3.0'f32) < 1.0e-2'f32,
                 "getHSB reported hue " & $hue
        doAssert abs(saturation - 1.0'f32) < 1.0e-3'f32,
                 "getHSB reported saturation " & $saturation
        doAssert abs(brightness - 1.0'f32) < 1.0e-3'f32,
                 "getHSB reported brightness " & $brightness

        # withRotatedHue walks the wheel, and a full turn comes back.
        doAssert red.withRotatedHue(1.0'f32 / 3.0'f32) == green,
                 "rotating red by a third did not give green"
        doAssert red.withRotatedHue(1.0'f32) == red,
                 "a full turn did not come back to where it started"

        # The HSL form is a different decomposition of the same colour, and
        # getHSL reads back what fromHSL was given.
        let fromHsl = Colour.fromHSL(0.5'f32, 0.8'f32, 0.6'f32, 1.0'f32)
        var h, s, l: cfloat
        fromHsl.getHSL(h, s, l)
        doAssert abs(h - 0.5'f32) < 1.0e-2'f32, "getHSL reported hue " & $h
        doAssert abs(s - 0.8'f32) < 1.0e-2'f32, "getHSL reported saturation " & $s
        doAssert abs(l - 0.6'f32) < 1.0e-2'f32, "getHSL reported lightness " & $l
        doAssert abs(fromHsl.getLightness() - l) < 1.0e-6'f32,
                 "getLightness and getHSL disagree"
        doAssert abs(fromHsl.getSaturationHSL() - s) < 1.0e-6'f32,
                 "getSaturationHSL and getHSL disagree"

    block:
        # A grey has no saturation, and its three channels are equal.
        let grey = Colour.greyLevel(0.5'f32)
        doAssert grey.getRed() == grey.getGreen() and
                 grey.getGreen() == grey.getBlue(),
                 "a grey is not neutral: " & $grey.toString()
        doAssert grey.getSaturation() == 0.0'f32,
                 "a grey has saturation " & $grey.getSaturation()

        # brighter and darker move the brightness in opposite directions.
        doAssert grey.brighter().getBrightness() > grey.getBrightness(),
                 "brighter did not brighten"
        doAssert grey.darker().getBrightness() < grey.getBrightness(),
                 "darker did not darken"

        # withBrightness sets it outright, and leaves the hue alone.
        let blue = Colour.fromHSV(0.6'f32, 1.0'f32, 1.0'f32, 1.0'f32)
        let dimmed = blue.withBrightness(0.25'f32)
        doAssert abs(dimmed.getBrightness() - 0.25'f32) < 1.0e-2'f32,
                 "the brightness is " & $dimmed.getBrightness()
        doAssert abs(dimmed.getHue() - blue.getHue()) < 1.0e-2'f32,
                 "withBrightness moved the hue from " & $blue.getHue() &
                 " to " & $dimmed.getHue()
        doAssert abs(blue.getBrightness() - 1.0'f32) < 1.0e-3'f32,
                 "withBrightness mutated the original"

        # withMultipliedBrightness scales it instead.
        doAssert abs(blue.withMultipliedBrightness(0.5'f32).getBrightness() -
                     0.5'f32) < 1.0e-2'f32,
                 "halving the brightness gave " &
                 $blue.withMultipliedBrightness(0.5'f32).getBrightness()

    block:
        # Interpolation walks between two colours, and the ends are the colours
        # themselves.
        let black = Colour.fromRGB(0'u8, 0'u8, 0'u8)
        let white = Colour.fromRGB(255'u8, 255'u8, 255'u8)
        doAssert black.interpolatedWith(white, 0.0'f32) == black,
                 "interpolating none of the way moved the colour"
        doAssert black.interpolatedWith(white, 1.0'f32) == white,
                 "interpolating all of the way did not arrive"
        let middle = black.interpolatedWith(white, 0.5'f32)
        doAssert middle.getRed() > 100'u8 and middle.getRed() < 155'u8,
                 "the midpoint red is " & $middle.getRed()

        # An opaque foreground hides whatever it is laid over.
        doAssert black.overlaidWith(white) == white,
                 "an opaque overlay did not cover the background"
        doAssert black.overlaidWith(white.withAlpha(0'u8)) == black,
                 "a fully transparent overlay changed the background"

        # contrasting picks a colour that stands against its argument, which is
        # what a caller uses it for: text over a known background.
        doAssert white.contrasting().getPerceivedBrightness() <
                 white.getPerceivedBrightness(),
                 "the contrast to white is not darker than white"
        doAssert black.contrasting().getPerceivedBrightness() >
                 black.getPerceivedBrightness(),
                 "the contrast to black is not lighter than black"

    block:
        # A colour survives a round trip through its own string form.
        let colour = Colour.fromRGBA(18'u8, 52'u8, 86'u8, 120'u8)
        let text = colour.toString()
        doAssert Colour.fromString(makeStringRef($text)) == colour,
                 "a round trip through " & $text & " changed the colour"
        doAssert colour.toDisplayString(true).isNotEmpty(),
                 "the display string with alpha is empty"
        doAssert colour.toDisplayString(false).isNotEmpty(),
                 "the display string without alpha is empty"

testColour()

# Path is a list of subpaths built by moving a pen. The assertions that matter
# are the ones a wrong argument order would break: where the bounds land, where
# the pen ends up, and what a transform does to both.
proc testPathGeometry() =
    block:
        # The pen position follows the drawing, which testPath above never
        # looks at. The bounds are relative to where the subpath started, not
        # to the origin.
        var path = makePath()
        path.startNewSubPath(10.0'f32, 20.0'f32)
        doAssert path.getCurrentPosition() == makePoint(10.0'f32, 20.0'f32),
                 "the pen is at " & $path.getCurrentPosition()

        path.lineTo(110.0'f32, 20.0'f32)
        doAssert path.getCurrentPosition() == makePoint(110.0'f32, 20.0'f32),
                 "lineTo left the pen at " & $path.getCurrentPosition()

        path.lineTo(110.0'f32, 70.0'f32)
        path.closeSubPath()

        let bounds = path.getBounds()
        doAssert bounds.getX() == 10.0'f32 and bounds.getY() == 20.0'f32,
                 "the bounds start at " & $bounds.getX() & "," & $bounds.getY()
        doAssert bounds.getWidth() == 100.0'f32 and bounds.getHeight() == 50.0'f32,
                 "the bounds are " & $bounds.getWidth() & "x" & $bounds.getHeight()

    block:
        # A closed rectangle contains its middle and not a point outside it.
        var path = makePath()
        path.addRectangle(0.0'f32, 0.0'f32, 100.0'f32, 50.0'f32)
        doAssert path.contains(50.0'f32, 25.0'f32, 1.0'f32),
                 "the path does not contain its own centre"
        doAssert not path.contains(500.0'f32, 500.0'f32, 1.0'f32),
                 "the path contains a point far outside it"
        doAssert path.contains(makePoint(50.0'f32, 25.0'f32), 1.0'f32),
                 "the Point overload disagrees with the x/y overload"

        # A line through the middle crosses the outline; one far away does not.
        doAssert path.intersectsLine(
                     makeLine(-10.0'f32, 25.0'f32, 110.0'f32, 25.0'f32), 1.0'f32),
                 "a line through the rectangle does not cross it"
        doAssert not path.intersectsLine(
                     makeLine(-10.0'f32, 500.0'f32, 110.0'f32, 500.0'f32), 1.0'f32),
                 "a line far below the rectangle crosses it"

        # The perimeter of a 100x50 rectangle is 300.
        doAssert abs(path.getLength(AffineTransform.identity(), 1.0'f32) - 300.0'f32) <
                 0.5'f32,
                 "the perimeter measures " &
                 $path.getLength(AffineTransform.identity(), 1.0'f32)

        # addRectangle starts its subpath at the BOTTOM left corner and walks
        # anticlockwise (juce_Path.cpp:339), so distance zero along the path is
        # (0, 50) and not the origin.
        let start = path.getPointAlongPath(0.0'f32, AffineTransform.identity(),
                                           1.0'f32)
        doAssert start == makePoint(0.0'f32, 50.0'f32),
                 "the path starts at " & $start

        # A quarter of the perimeter along, the pen has walked the 50-tall left
        # edge and is at the top left corner.
        let quarter = path.getPointAlongPath(50.0'f32, AffineTransform.identity(),
                                             1.0'f32)
        doAssert quarter == makePoint(0.0'f32, 0.0'f32),
                 "50 along the perimeter is " & $quarter

        # getNearestPoint writes the point through its out parameter, and what
        # it RETURNS is the distance along the path to that point, not the
        # distance from the target to it. A spot above the top edge is nearest
        # to (50, 0), which is 50 up the left edge plus 50 along the top.
        var onPath: Point[cfloat]
        let along = path.getNearestPoint(makePoint(50.0'f32, -30.0'f32), onPath,
                                         AffineTransform.identity(), 1.0'f32)
        doAssert onPath == makePoint(50.0'f32, 0.0'f32),
                 "the nearest point to a spot above the top edge is " & $onPath
        doAssert abs(along - 100.0'f32) < 1.0'f32,
                 "the distance along the path measures " & $along

    block:
        # A transform moves the path, and getBoundsTransformed reports where the
        # bounds would land without moving anything.
        var path = makePath()
        path.addRectangle(0.0'f32, 0.0'f32, 10.0'f32, 10.0'f32)
        let shift = AffineTransform.translation(100.0'f32, 200.0'f32)

        let shifted = path.getBoundsTransformed(shift)
        doAssert shifted.getX() == 100.0'f32 and shifted.getY() == 200.0'f32,
                 "the transformed bounds start at " & $shifted.getX() & "," &
                 $shifted.getY()
        doAssert path.getBounds().getX() == 0.0'f32,
                 "getBoundsTransformed moved the path itself"

        path.applyTransform(shift)
        doAssert path.getBounds().getX() == 100.0'f32,
                 "applyTransform left the path at " & $path.getBounds().getX()

        # scaleToFit puts the path inside the rectangle it is given.
        path.scaleToFit(0.0'f32, 0.0'f32, 200.0'f32, 200.0'f32, true)
        let fitted = path.getBounds()
        doAssert fitted.getWidth() <= 200.0'f32 and fitted.getHeight() <= 200.0'f32,
                 "after scaleToFit the path is " & $fitted.getWidth() & "x" &
                 $fitted.getHeight()

    block:
        # addPath appends: the combined bounds enclose both.
        var left = makePath()
        left.addRectangle(0.0'f32, 0.0'f32, 10.0'f32, 10.0'f32)
        var right = makePath()
        right.addRectangle(90.0'f32, 0.0'f32, 10.0'f32, 10.0'f32)

        left.addPath(right)
        doAssert left.getBounds().getWidth() == 100.0'f32,
                 "the combined width is " & $left.getBounds().getWidth()

        # And the transforming overload places the appended copy.
        var target = makePath()
        target.addRectangle(0.0'f32, 0.0'f32, 10.0'f32, 10.0'f32)
        var source = makePath()
        source.addRectangle(0.0'f32, 0.0'f32, 10.0'f32, 10.0'f32)
        target.addPath(source, AffineTransform.translation(190.0'f32, 0.0'f32))
        doAssert target.getBounds().getWidth() == 200.0'f32,
                 "the transformed append gave a width of " &
                 $target.getBounds().getWidth()

    block:
        # swapWithPath exchanges the two, so each ends up with the other's bounds.
        var small = makePath()
        small.addRectangle(0.0'f32, 0.0'f32, 1.0'f32, 1.0'f32)
        var large = makePath()
        large.addRectangle(0.0'f32, 0.0'f32, 100.0'f32, 100.0'f32)

        small.swapWithPath(large)
        doAssert small.getBounds().getWidth() == 100.0'f32,
                 "after the swap the first path is " &
                 $small.getBounds().getWidth() & " wide"
        doAssert large.getBounds().getWidth() == 1.0'f32,
                 "after the swap the second path is " &
                 $large.getBounds().getWidth() & " wide"

    block:
        # The winding rule decides whether a hole inside a shape is filled.
        var path = makePath()
        path.addRectangle(0.0'f32, 0.0'f32, 100.0'f32, 100.0'f32)
        path.addRectangle(25.0'f32, 25.0'f32, 50.0'f32, 50.0'f32)

        doAssert path.isUsingNonZeroWinding(),
                 "a path does not start with the non-zero winding rule"
        doAssert path.contains(50.0'f32, 50.0'f32, 1.0'f32),
                 "the non-zero rule left the inner square empty"

        path.setUsingNonZeroWinding(false)
        doAssert not path.isUsingNonZeroWinding(),
                 "the winding rule did not change"
        doAssert not path.contains(50.0'f32, 50.0'f32, 1.0'f32),
                 "the even-odd rule filled the inner square"

    block:
        # A path survives a round trip through its own string form.
        var path = makePath()
        path.addTriangle(0.0'f32, 0.0'f32, 10.0'f32, 0.0'f32, 5.0'f32, 8.0'f32)
        let text = path.toString()
        doAssert text.isNotEmpty(), "toString gave an empty description"

        var rebuilt = makePath()
        rebuilt.restoreFromString(makeStringRef($text))
        doAssert rebuilt.getBounds().getWidth() == path.getBounds().getWidth() and
                 rebuilt.getBounds().getHeight() == path.getBounds().getHeight(),
                 "the round trip changed the bounds to " &
                 $rebuilt.getBounds().getWidth() & "x" &
                 $rebuilt.getBounds().getHeight()

testPathGeometry()

# Graphics is where a wrong argument order goes unnoticed, because a drawing
# call returns nothing. These assert on the PIXELS: what got painted and, just
# as importantly, what did not.
proc litPixelCount(image: Image): int =
    for x in 0.cint ..< image.getWidth():
        for y in 0.cint ..< image.getHeight():
            if image.getPixelAt(x, y).getAlpha() > 0'u8:
                result += 1

proc testGraphicsShapes() =
    block:
        # drawRect outlines and fillRect fills: the centre tells them apart.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)
        g.drawRect(makeRectangle(10.cint, 10.cint, 20.cint, 20.cint), 1.cint)

        doAssert image.getPixelAt(10.cint, 10.cint).getAlpha() > 0'u8,
                 "the outline's corner was not drawn"
        doAssert image.getPixelAt(20.cint, 20.cint).getAlpha() == 0'u8,
                 "drawRect filled the middle"
        doAssert image.getPixelAt(35.cint, 35.cint).getAlpha() == 0'u8,
                 "drawRect painted outside its rectangle"

    block:
        # A line is drawn between the two points it is given, and nowhere else.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)
        g.drawLine(5.0'f32, 20.0'f32, 35.0'f32, 20.0'f32, 1.0'f32)

        doAssert image.getPixelAt(20.cint, 20.cint).getAlpha() > 0'u8,
                 "the line's midpoint was not drawn"
        doAssert image.getPixelAt(20.cint, 5.cint).getAlpha() == 0'u8,
                 "the line painted well above itself"
        doAssert image.getPixelAt(2.cint, 20.cint).getAlpha() == 0'u8,
                 "the line ran past its start"

        # drawVerticalLine takes the other axis, which is the pair a caller
        # confuses.
        let other = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g2 = makeGraphics(other)
        g2.setColour(Colours_white)
        g2.drawVerticalLine(20.cint, 5.0'f32, 35.0'f32)
        doAssert other.getPixelAt(20.cint, 20.cint).getAlpha() > 0'u8,
                 "the vertical line's midpoint was not drawn"
        doAssert other.getPixelAt(5.cint, 20.cint).getAlpha() == 0'u8,
                 "drawVerticalLine drew a horizontal line"

    block:
        # A path fills the shape it describes; stroking it leaves the middle
        # empty.
        var triangle = makePath()
        triangle.addTriangle(20.0'f32, 2.0'f32, 38.0'f32, 38.0'f32,
                             2.0'f32, 38.0'f32)

        let filled = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(filled)
        g.setColour(Colours_white)
        g.fillPath(triangle)
        doAssert filled.getPixelAt(20.cint, 30.cint).getAlpha() > 0'u8,
                 "fillPath left the inside of the triangle empty"

        let stroked = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g2 = makeGraphics(stroked)
        g2.setColour(Colours_white)
        g2.strokePath(triangle, makePathStrokeType(1.0'f32),
                      AffineTransform.identity())
        doAssert stroked.getPixelAt(20.cint, 30.cint).getAlpha() == 0'u8,
                 "strokePath filled the inside of the triangle"
        doAssert litPixelCount(stroked) < litPixelCount(filled),
                 "the stroked triangle lit " & $litPixelCount(stroked) &
                 " pixels and the filled one " & $litPixelCount(filled)

    block:
        # An ellipse leaves its corners clear, which is how it differs from the
        # rectangle that bounds it.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)
        g.fillEllipse(makeRectangle(0.0'f32, 0.0'f32, 40.0'f32, 40.0'f32))
        doAssert image.getPixelAt(20.cint, 20.cint).getAlpha() > 0'u8,
                 "the ellipse's centre is empty"
        doAssert image.getPixelAt(0.cint, 0.cint).getAlpha() == 0'u8,
                 "the ellipse filled its bounding box's corner"

        # And a rounded rectangle leaves less of the corner than a square one.
        let rounded = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g2 = makeGraphics(rounded)
        g2.setColour(Colours_white)
        g2.fillRoundedRectangle(0.0'f32, 0.0'f32, 40.0'f32, 40.0'f32, 10.0'f32)
        doAssert rounded.getPixelAt(0.cint, 0.cint).getAlpha() == 0'u8,
                 "the rounded rectangle filled its corner"
        doAssert litPixelCount(rounded) > litPixelCount(image),
                 "the rounded rectangle lit " & $litPixelCount(rounded) &
                 " pixels and the ellipse " & $litPixelCount(image) &
                 ", so it is not the fatter shape"

proc testGraphicsState() =
    block:
        # The clip region is part of the saved state, and restoreState puts it
        # back. Drawing outside the clip paints nothing.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)

        g.saveState()
        discard g.reduceClipRegion(makeRectangle(0.cint, 0.cint, 20.cint, 20.cint))
        g.fillAll()
        doAssert image.getPixelAt(10.cint, 10.cint).getAlpha() > 0'u8,
                 "the clipped fill painted nothing inside the clip"
        doAssert image.getPixelAt(30.cint, 30.cint).getAlpha() == 0'u8,
                 "the fill escaped the clip region"
        g.restoreState()

        # With the clip restored, the same call reaches the whole image.
        g.fillAll()
        doAssert image.getPixelAt(30.cint, 30.cint).getAlpha() > 0'u8,
                 "restoreState did not put the clip region back"

    block:
        # excludeClipRegion is the complement: it removes a hole.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)
        g.excludeClipRegion(makeRectangle(10.cint, 10.cint, 20.cint, 20.cint))
        g.fillAll()
        doAssert image.getPixelAt(2.cint, 2.cint).getAlpha() > 0'u8,
                 "the fill missed the area outside the hole"
        doAssert image.getPixelAt(20.cint, 20.cint).getAlpha() == 0'u8,
                 "the fill reached inside the excluded hole"

    block:
        # Opacity multiplies into the alpha that is written.
        let image = makeImage(ImagePixelFormat_ARGB, 10.cint, 10.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)
        g.setOpacity(0.5'f32)
        g.fillAll()
        let alpha = image.getPixelAt(5.cint, 5.cint).getAlpha()
        doAssert alpha > 100'u8 and alpha < 155'u8,
                 "a half opaque fill wrote alpha " & $alpha

    block:
        # A transform moves what is drawn afterwards, and only afterwards.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setColour(Colours_white)
        g.addTransform(AffineTransform.translation(20.0'f32, 20.0'f32))
        g.fillRect(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint))

        doAssert image.getPixelAt(25.cint, 25.cint).getAlpha() > 0'u8,
                 "the transformed rectangle did not land where it was moved to"
        doAssert image.getPixelAt(5.cint, 5.cint).getAlpha() == 0'u8,
                 "the rectangle was drawn at its untransformed position too"

    block:
        # A gradient paints different colours at its two ends.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 10.cint, true)
        var g = makeGraphics(image)
        g.setGradientFill(makeColourGradient(Colours_black, 0.0'f32, 0.0'f32,
                                             Colours_white, 40.0'f32, 0.0'f32,
                                             false))
        g.fillAll()
        doAssert image.getPixelAt(38.cint, 5.cint).getRed() >
                 image.getPixelAt(1.cint, 5.cint).getRed(),
                 "the gradient's far end (" &
                 $image.getPixelAt(38.cint, 5.cint).getRed() &
                 ") is not lighter than its near end (" &
                 $image.getPixelAt(1.cint, 5.cint).getRed() & ")"

    block:
        # An image drawn into another arrives at the position it was given.
        let source = makeImage(ImagePixelFormat_ARGB, 10.cint, 10.cint, true)
        var sourceGraphics = makeGraphics(source)
        sourceGraphics.setColour(Colours_white)
        sourceGraphics.fillAll()

        let target = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(target)
        g.drawImageAt(source, 20.cint, 20.cint, false)
        doAssert target.getPixelAt(25.cint, 25.cint).getAlpha() > 0'u8,
                 "the image did not arrive where it was placed"
        doAssert target.getPixelAt(5.cint, 5.cint).getAlpha() == 0'u8,
                 "the image was drawn at the origin as well"

    block:
        # The font a Graphics carries is the one it was last given.
        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 40.cint, true)
        var g = makeGraphics(image)
        g.setFont(makeFont(makeFontOptions(23.0'f32)))
        doAssert g.getCurrentFont().getHeight() == 23.0'f32,
                 "the current font is " & $g.getCurrentFont().getHeight() & " tall"

initialiseJuce_GUI()
testGraphicsShapes()
testGraphicsState()
shutdownJuce_GUI()

# FontOptions is a value builder: every with- method returns a new options
# object and leaves the receiver alone. testFontOptionsOverrides covers the
# ascent and descent overrides; this covers the rest.
proc testFontOptionsBuilding() =
    block:
        let base = makeFontOptions(20.0'f32)
        doAssert base.getHeight() == 20.0'f32,
                 "the height is " & $base.getHeight()
        doAssert base.getName().isEmpty(),
                 "a new options object names " & $base.getName()
        doAssert $base.getStyle() == "Regular",
                 "a new options object has the style " & $base.getStyle()
        doAssert base.getKerningFactor() == 0.0'f32,
                 "the default kerning is " & $base.getKerningFactor()
        doAssert base.getHorizontalScale() == 1.0'f32,
                 "the default horizontal scale is " & $base.getHorizontalScale()
        doAssert not base.getUnderline(), "a new options object is underlined"
        doAssert base.getFallbackEnabled(),
                 "fallbacks start disabled"
        doAssert base.getFallbacks().size() == 0,
                 "a new options object lists " & $base.getFallbacks().size() &
                 " fallbacks"

        # Each with- method changes one field and leaves the neighbours alone.
        let named = base.withName(makeString("Courier"))
        doAssert $named.getName() == "Courier",
                 "the name is " & $named.getName()
        doAssert named.getHeight() == 20.0'f32,
                 "withName changed the height to " & $named.getHeight()
        doAssert base.getName().isEmpty(),
                 "withName changed the original to " & $base.getName()

        let styled = named.withStyle(makeString("Bold"))
        doAssert $styled.getStyle() == "Bold",
                 "the style is " & $styled.getStyle()
        doAssert $styled.getName() == "Courier",
                 "withStyle changed the name to " & $styled.getName()

        doAssert base.withUnderline(true).getUnderline(),
                 "withUnderline did not take"
        doAssert not base.withUnderline(true).withUnderline(false).getUnderline(),
                 "withUnderline could not be turned back off"

        doAssert base.withKerningFactor(0.3'f32).getKerningFactor() == 0.3'f32,
                 "the kerning is " &
                 $base.withKerningFactor(0.3'f32).getKerningFactor()
        doAssert base.withHorizontalScale(1.75'f32).getHorizontalScale() ==
                 1.75'f32,
                 "the horizontal scale is " &
                 $base.withHorizontalScale(1.75'f32).getHorizontalScale()
        doAssert not base.withFallbackEnabled(false).getFallbackEnabled(),
                 "withFallbackEnabled did not take"

        # The point height and the pixel height are alternatives: setting one
        # clears the other, which is how the type says which was asked for.
        # The UNSET one reads as -1, not as zero, so that a genuine height of
        # zero stays distinguishable from "not asked for".
        doAssert base.getPointHeight() == -1.0'f32,
                 "a height-in-pixels options object reports " &
                 $base.getPointHeight() & " points"
        let inPoints = makeFontOptions(20.0'f32).withPointHeight(14.0'f32)
        doAssert inPoints.getPointHeight() == 14.0'f32,
                 "the point height is " & $inPoints.getPointHeight()
        doAssert inPoints.getHeight() == -1.0'f32,
                 "asking for points left the pixel height at " &
                 $inPoints.getHeight()

    block:
        # The fallback list is carried whole.
        var fallbacks = makeCppVector[String]()
        doAssert fallbacks.isEmpty(), "a new vector is not empty"
        fallbacks.add(makeString("Menlo"))
        fallbacks.add(makeString("Monaco"))
        doAssert fallbacks.size() == 2,
                 "the vector holds " & $fallbacks.size() & " entries"

        let options = makeFontOptions(12.0'f32).withFallbacks(fallbacks)
        doAssert options.getFallbacks().size() == 2,
                 "the options carry " & $options.getFallbacks().size() &
                 " fallbacks"
        doAssert $options.getFallbacks()[0.csize_t] == "Menlo",
                 "the first fallback is " & $options.getFallbacks()[0.csize_t]

        # And the vector empties again, so all three of the hand-written
        # std::vector helpers are exercised. The coverage gate matches by
        # NAME, and add/clear/isEmpty are all names other bindings use too,
        # so it cannot see these three on its own.
        fallbacks.clear()
        doAssert fallbacks.isEmpty(), "clear left " & $fallbacks.size() & " entries"

    block:
        # Two options objects built the same way are equal, and one different
        # field is enough to order them.
        let first = makeFontOptions(10.0'f32).withName(makeString("A"))
        let same = makeFontOptions(10.0'f32).withName(makeString("A"))
        let other = makeFontOptions(10.0'f32).withName(makeString("B"))

        doAssert first == same, "two identical options objects are not equal"
        doAssert not (first == other), "options with different names are equal"
        doAssert (first < other) or (other < first),
                 "two different options objects do not order"

testFontOptionsBuilding()

# Path's shape helpers. Each one is a separate binding with a long argument
# list, and the assertions are on the BOUNDS it produces, which is what a
# swapped pair of arguments changes.
proc testPathShapes() =
    block:
        # The curves take their control points before the end point.
        var path = makePath()
        path.startNewSubPath(0.0'f32, 0.0'f32)
        path.quadraticTo(50.0'f32, 100.0'f32, 100.0'f32, 0.0'f32)
        doAssert path.getCurrentPosition() == makePoint(100.0'f32, 0.0'f32),
                 "the quadratic ended at " & $path.getCurrentPosition()
        # getBounds is NOT tight around a curve: quadraticTo extends the bounds
        # by the control point as well as the end point
        # (juce_Path.cpp:253), so a curve that only bulges towards (0, 100)
        # still reports 100 tall. contains() draws the distinction - the
        # control point itself is outside the shape.
        doAssert path.getBounds().getHeight() == 100.0'f32,
                 "the quadratic's bounds are " & $path.getBounds().getHeight() &
                 " tall, so the control point is no longer counted"
        doAssert not path.contains(50.0'f32, 95.0'f32, 1.0'f32),
                 "the curve reaches its own control point"

        var cubic = makePath()
        cubic.startNewSubPath(0.0'f32, 0.0'f32)
        cubic.cubicTo(0.0'f32, 100.0'f32, 100.0'f32, 100.0'f32,
                      100.0'f32, 0.0'f32)
        doAssert cubic.getCurrentPosition() == makePoint(100.0'f32, 0.0'f32),
                 "the cubic ended at " & $cubic.getCurrentPosition()
        doAssert cubic.getBounds().getHeight() > 0.0'f32,
                 "the cubic did not bend"

    block:
        # Every add* helper puts its shape where it was told to.
        var rounded = makePath()
        rounded.addRoundedRectangle(10.0'f32, 20.0'f32, 100.0'f32, 50.0'f32,
                                    8.0'f32)
        doAssert rounded.getBounds().getX() == 10.0'f32 and
                 rounded.getBounds().getWidth() == 100.0'f32,
                 "the rounded rectangle is at " & $rounded.getBounds().getX() &
                 " and " & $rounded.getBounds().getWidth() & " wide"

        var ellipse = makePath()
        ellipse.addEllipse(makeRectangle(5.0'f32, 5.0'f32, 40.0'f32, 20.0'f32))
        doAssert ellipse.getBounds().getWidth() == 40.0'f32 and
                 ellipse.getBounds().getHeight() == 20.0'f32,
                 "the ellipse measures " & $ellipse.getBounds().getWidth() & "x" &
                 $ellipse.getBounds().getHeight()

        var quad = makePath()
        quad.addQuadrilateral(0.0'f32, 0.0'f32, 30.0'f32, 5.0'f32,
                              25.0'f32, 40.0'f32, -5.0'f32, 35.0'f32)
        doAssert quad.getBounds().getX() == -5.0'f32,
                 "the quadrilateral starts at " & $quad.getBounds().getX()
        doAssert quad.getBounds().getWidth() == 35.0'f32,
                 "the quadrilateral is " & $quad.getBounds().getWidth() & " wide"

        # A polygon and a star are both drawn around a centre with a radius, so
        # the bounds are twice the radius across.
        var polygon = makePath()
        polygon.addPolygon(makePoint(50.0'f32, 50.0'f32), 6.cint, 20.0'f32,
                           0.0'f32)
        doAssert polygon.getBounds().getWidth() <= 40.0'f32 and
                 polygon.getBounds().getWidth() > 30.0'f32,
                 "a hexagon of radius 20 measures " &
                 $polygon.getBounds().getWidth() & " across"

        var star = makePath()
        star.addStar(makePoint(50.0'f32, 50.0'f32), 5.cint, 8.0'f32, 20.0'f32,
                     0.0'f32)
        doAssert star.getBounds().getWidth() <= 40.0'f32,
                 "a star of outer radius 20 measures " &
                 $star.getBounds().getWidth() & " across"
        doAssert star.getBounds().getWidth() > polygon.getBounds().getWidth() * 0.5'f32,
                 "the star is far smaller than its outer radius"

        # An arc over part of a circle is smaller than the whole circle.
        var quarter = makePath()
        quarter.addCentredArc(50.0'f32, 50.0'f32, 20.0'f32, 20.0'f32, 0.0'f32,
                              0.0'f32, 1.5707963'f32, true)
        doAssert quarter.getBounds().getWidth() < 40.0'f32,
                 "a quarter arc measures " & $quarter.getBounds().getWidth() &
                 " across, which is the whole circle"

        var pie = makePath()
        pie.addPieSegment(makeRectangle(0.0'f32, 0.0'f32, 40.0'f32, 40.0'f32),
                          0.0'f32, 3.1415927'f32, 0.5'f32)
        doAssert not pie.isEmpty(), "the pie segment drew nothing"
        doAssert pie.getBounds().getWidth() <= 40.0'f32,
                 "the pie segment escaped its bounds at " &
                 $pie.getBounds().getWidth() & " across"

        # A line segment and an arrow are both thick shapes rather than lines,
        # and the arrow is the wider of the two for the same line.
        let line = makeLine(0.0'f32, 0.0'f32, 100.0'f32, 0.0'f32)
        var segment = makePath()
        segment.addLineSegment(line, 2.0'f32)
        doAssert segment.getBounds().getHeight() >= 2.0'f32,
                 "the line segment is " & $segment.getBounds().getHeight() &
                 " thick"

        var arrow = makePath()
        arrow.addArrow(line, 2.0'f32, 12.0'f32, 20.0'f32)
        doAssert arrow.getBounds().getHeight() > segment.getBounds().getHeight(),
                 "the arrow is " & $arrow.getBounds().getHeight() &
                 " tall and the plain segment " &
                 $segment.getBounds().getHeight()

        var bubble = makePath()
        bubble.addBubble(makeRectangle(20.0'f32, 20.0'f32, 60.0'f32, 30.0'f32),
                         makeRectangle(0.0'f32, 0.0'f32, 100.0'f32, 100.0'f32),
                         makePoint(50.0'f32, 80.0'f32), 5.0'f32, 10.0'f32)
        doAssert bubble.getBounds().getHeight() > 30.0'f32,
                 "the bubble is " & $bubble.getBounds().getHeight() &
                 " tall, so its arrow was not added"

    block:
        # createPathWithRoundedCorners softens the corners without moving the
        # shape off its bounds.
        var square = makePath()
        square.addRectangle(0.0'f32, 0.0'f32, 40.0'f32, 40.0'f32)
        let softened = square.createPathWithRoundedCorners(8.0'f32)
        doAssert softened.getBounds().getWidth() == 40.0'f32,
                 "the softened shape is " & $softened.getBounds().getWidth() &
                 " wide"
        doAssert not softened.contains(0.5'f32, 0.5'f32, 0.5'f32),
                 "the corner was not rounded off"
        doAssert square.contains(0.5'f32, 0.5'f32, 0.5'f32),
                 "createPathWithRoundedCorners changed the original"

    block:
        # getTransformToScaleToFit describes the move without making it.
        var path = makePath()
        path.addRectangle(0.0'f32, 0.0'f32, 10.0'f32, 10.0'f32)
        let transform = path.getTransformToScaleToFit(
                            makeRectangle(0.0'f32, 0.0'f32, 100.0'f32, 100.0'f32),
                            true, makeJustification(
                                JustificationFlags_centred.cint))
        doAssert path.getBounds().getWidth() == 10.0'f32,
                 "getTransformToScaleToFit changed the path itself"
        doAssert path.getBoundsTransformed(transform).getWidth() == 100.0'f32,
                 "the transform scales the path to " &
                 $path.getBoundsTransformed(transform).getWidth()

    block:
        # getClippedLine keeps whichever half of a line it is asked for.
        var box = makePath()
        box.addRectangle(0.0'f32, 0.0'f32, 100.0'f32, 100.0'f32)
        let crossing = makeLine(-50.0'f32, 50.0'f32, 50.0'f32, 50.0'f32)

        let inside = box.getClippedLine(crossing, false)
        let outside = box.getClippedLine(crossing, true)
        doAssert inside.getLength() < crossing.getLength(),
                 "the clipped line is " & $inside.getLength() &
                 " long and the original " & $crossing.getLength()
        doAssert outside.getLength() < crossing.getLength(),
                 "the outside half is " & $outside.getLength() & " long"
        doAssert abs(inside.getLength() + outside.getLength() -
                     crossing.getLength()) < 1.0'f32,
                 "the two halves measure " & $inside.getLength() & " and " &
                 $outside.getLength() & ", which is not the whole line"

    block:
        # A path survives a round trip through a stream, and preallocating
        # space changes nothing a caller can see.
        var path = makePath()
        path.preallocateSpace(64.cint)
        path.addStar(makePoint(0.0'f32, 0.0'f32), 7.cint, 4.0'f32, 10.0'f32,
                     0.0'f32)

        var output = makeMemoryOutputStream(256'u64)
        path.writePathToStream(output)
        doAssert output.getDataSize() > 0'u64,
                 "writePathToStream wrote " & $output.getDataSize() & " bytes"

        var input = makeMemoryInputStream(output.getData(),
                                          output.getDataSize(), false)
        var restored = makePath()
        restored.loadPathFromStream(input)
        doAssert restored.getBounds().getWidth() == path.getBounds().getWidth(),
                 "the round trip through a stream gave a shape " &
                 $restored.getBounds().getWidth() & " wide"

        # And straight from the bytes, which is the other door to the same
        # decoder.
        var fromData = makePath()
        fromData.loadPathFromData(output.getData(), output.getDataSize())
        doAssert fromData.getBounds().getWidth() == path.getBounds().getWidth(),
                 "loading from raw data gave a shape " &
                 $fromData.getBounds().getWidth() & " wide"

testPathShapes()

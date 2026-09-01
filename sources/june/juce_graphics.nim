import june_common

const juce_graphics = "../../JUCE/modules/juce_graphics/juce_graphics.h"

type
  AffineTransform* {.header: juce_graphics, importcpp: "juce::AffineTransform", inheritable, pure.} = object
  Justification* {.header: juce_graphics, importcpp: "juce::Justification", inheritable, pure.} = object
  Path* {.header: juce_graphics, importcpp: "juce::Path", inheritable, pure.} = object
  PathIterator* {.header: juce_graphics, importcpp: "juce::Path::Iterator", inheritable, pure.} = object
  PixelARGB* {.header: juce_graphics, importcpp: "juce::PixelARGB", inheritable, pure.} = object
  PixelRGB* {.header: juce_graphics, importcpp: "juce::PixelRGB", inheritable, pure.} = object
  PixelAlpha* {.header: juce_graphics, importcpp: "juce::PixelAlpha", inheritable, pure.} = object
  Colour* {.header: juce_graphics, importcpp: "juce::Colour", inheritable, pure.} = object
  ColourGradient* {.header: juce_graphics, importcpp: "juce::ColourGradient", inheritable, pure.} = object
  EdgeTable* {.header: juce_graphics, importcpp: "juce::EdgeTable", inheritable, pure.} = object
  PathFlatteningIterator* {.header: juce_graphics, importcpp: "juce::PathFlatteningIterator", inheritable, pure.} = object
  PathStrokeType* {.header: juce_graphics, importcpp: "juce::PathStrokeType", inheritable, pure.} = object
  RectanglePlacement* {.header: juce_graphics, importcpp: "juce::RectanglePlacement", inheritable, pure.} = object
  ImageCache* {.header: juce_graphics, importcpp: "juce::ImageCache", inheritable, pure.} = object
  ImageConvolutionKernel* {.header: juce_graphics, importcpp: "juce::ImageConvolutionKernel", inheritable, pure.} = object
  ImageFileFormat* {.header: juce_graphics, importcpp: "juce::ImageFileFormat", inheritable, pure.} = object
  PNGImageFormat* {.header: juce_graphics, importcpp: "juce::PNGImageFormat", inheritable, pure.} = object of ImageFileFormat
  JPEGImageFormat* {.header: juce_graphics, importcpp: "juce::JPEGImageFormat", inheritable, pure.} = object of ImageFileFormat
  GIFImageFormat* {.header: juce_graphics, importcpp: "juce::GIFImageFormat", inheritable, pure.} = object of ImageFileFormat
  GlyphArrangementOptions* {.header: juce_graphics, importcpp: "juce::GlyphArrangementOptions", inheritable, pure.} = object
  Graphics* {.header: juce_graphics, importcpp: "juce::Graphics", inheritable, pure.} = object
  GraphicsScopedSaveState* {.header: juce_graphics, importcpp: "juce::Graphics::ScopedSaveState", inheritable, pure.} = object
  Image* {.header: juce_graphics, importcpp: "juce::Image", inheritable, pure.} = object
  ImageBitmapData* {.header: juce_graphics, importcpp: "juce::Image::BitmapData", inheritable, pure.} = object
  ImagePixelDataBackupExtensions* {.header: juce_graphics, importcpp: "juce::ImagePixelDataBackupExtensions", inheritable, pure.} = object
  ImagePixelData* {.header: juce_graphics, importcpp: "juce::ImagePixelData", inheritable, pure.} = object of ReferenceCountedObject
  ImagePixelDataListener* {.header: juce_graphics, importcpp: "juce::ImagePixelData::Listener", inheritable, pure.} = object
  ImageType* {.header: juce_graphics, importcpp: "juce::ImageType", inheritable, pure.} = object
  SoftwareImageType* {.header: juce_graphics, importcpp: "juce::SoftwareImageType", inheritable, pure.} = object of ImageType
  NativeImageType* {.header: juce_graphics, importcpp: "juce::NativeImageType", inheritable, pure.} = object of ImageType
  FillType* {.header: juce_graphics, importcpp: "juce::FillType", inheritable, pure.} = object
  FontFeatureTag* {.header: juce_graphics, importcpp: "juce::FontFeatureTag", inheritable, pure.} = object
  FontFeatureSetting* {.header: juce_graphics, importcpp: "juce::FontFeatureSetting", inheritable, pure.} = object
  ColourLayer* {.header: juce_graphics, importcpp: "juce::ColourLayer", inheritable, pure.} = object
  ImageLayer* {.header: juce_graphics, importcpp: "juce::ImageLayer", inheritable, pure.} = object
  GlyphLayer* {.header: juce_graphics, importcpp: "juce::GlyphLayer", inheritable, pure.} = object
  TypefaceMetrics* {.header: juce_graphics, importcpp: "juce::TypefaceMetrics", inheritable, pure.} = object
  Typeface* {.header: juce_graphics, importcpp: "juce::Typeface", inheritable, pure.} = object of ReferenceCountedObject
  TypefaceNative* {.header: juce_graphics, importcpp: "juce::Typeface::Native", inheritable, pure.} = object
  FontOptions* {.header: juce_graphics, importcpp: "juce::FontOptions", inheritable, pure.} = object
  Font* {.header: juce_graphics, importcpp: "juce::Font", inheritable, pure.} = object
  FontNative* {.header: juce_graphics, importcpp: "juce::Font::Native", inheritable, pure.} = object
  AttributedString* {.header: juce_graphics, importcpp: "juce::AttributedString", inheritable, pure.} = object
  AttributedStringAttribute* {.header: juce_graphics, importcpp: "juce::AttributedString::Attribute", inheritable, pure.} = object
  PositionedGlyph* {.header: juce_graphics, importcpp: "juce::PositionedGlyph", inheritable, pure.} = object
  GlyphArrangement* {.header: juce_graphics, importcpp: "juce::GlyphArrangement", inheritable, pure.} = object
  TextLayout* {.header: juce_graphics, importcpp: "juce::TextLayout", inheritable, pure.} = object
  TextLayoutGlyph* {.header: juce_graphics, importcpp: "juce::TextLayout::Glyph", inheritable, pure.} = object
  TextLayoutRun* {.header: juce_graphics, importcpp: "juce::TextLayout::Run", inheritable, pure.} = object
  TextLayoutLine* {.header: juce_graphics, importcpp: "juce::TextLayout::Line", inheritable, pure.} = object
  LowLevelGraphicsContext* {.header: juce_graphics, importcpp: "juce::LowLevelGraphicsContext", inheritable, pure.} = object
  ScaledImage* {.header: juce_graphics, importcpp: "juce::ScaledImage", inheritable, pure.} = object
  LowLevelGraphicsSoftwareRenderer* {.header: juce_graphics, importcpp: "juce::LowLevelGraphicsSoftwareRenderer", inheritable, pure.} = object of LowLevelGraphicsContext
  ImageEffectFilter* {.header: juce_graphics, importcpp: "juce::ImageEffectFilter", inheritable, pure.} = object
  DropShadow* {.header: juce_graphics, importcpp: "juce::DropShadow", inheritable, pure.} = object
  DropShadowEffect* {.header: juce_graphics, importcpp: "juce::DropShadowEffect", inheritable, pure.} = object of ImageEffectFilter
  GlowEffect* {.header: juce_graphics, importcpp: "juce::GlowEffect", inheritable, pure.} = object of ImageEffectFilter
  ImagePixelDataNativeExtensions* {.header: juce_graphics, importcpp: "juce::ImagePixelDataNativeExtensions", inheritable, pure.} = object
  TypefaceMetricsKind* {.header: juce_graphics, importcpp: "juce::TypefaceMetricsKind".} = distinct cint
  JustificationFlags* {.header: juce_graphics, importcpp: "juce::Justification::Flags".} = distinct cint
  PathStrokeTypeJointStyle* {.header: juce_graphics, importcpp: "juce::PathStrokeType::JointStyle".} = distinct cint
  PathStrokeTypeEndCapStyle* {.header: juce_graphics, importcpp: "juce::PathStrokeType::EndCapStyle".} = distinct cint
  RectanglePlacementFlags* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::Flags".} = distinct cint
  GraphicsResamplingQuality* {.header: juce_graphics, importcpp: "juce::Graphics::ResamplingQuality".} = distinct cint
  ImagePixelFormat* {.header: juce_graphics, importcpp: "juce::Image::PixelFormat".} = distinct cint
  TypefaceColourGlyphFormat* {.header: juce_graphics, importcpp: "juce::Typeface::ColourGlyphFormat".} = distinct cint
  FontFontStyleFlags* {.header: juce_graphics, importcpp: "juce::Font::FontStyleFlags".} = distinct cint
  AttributedStringWordWrap* {.header: juce_graphics, importcpp: "juce::AttributedString::WordWrap".} = distinct cint
  AttributedStringReadingDirection* {.header: juce_graphics, importcpp: "juce::AttributedString::ReadingDirection".} = distinct cint

const
  TypefaceMetricsKind_legacy* = TypefaceMetricsKind(0)
  TypefaceMetricsKind_portable* = TypefaceMetricsKind(1)

const
  JustificationFlags_left* = JustificationFlags(1)
  JustificationFlags_right* = JustificationFlags(2)
  JustificationFlags_horizontallyCentred* = JustificationFlags(4)
  JustificationFlags_top* = JustificationFlags(8)
  JustificationFlags_bottom* = JustificationFlags(16)
  JustificationFlags_verticallyCentred* = JustificationFlags(32)
  JustificationFlags_horizontallyJustified* = JustificationFlags(64)
  JustificationFlags_centred* = JustificationFlags(36)
  JustificationFlags_centredLeft* = JustificationFlags(33)
  JustificationFlags_centredRight* = JustificationFlags(34)
  JustificationFlags_centredTop* = JustificationFlags(12)
  JustificationFlags_centredBottom* = JustificationFlags(20)
  JustificationFlags_topLeft* = JustificationFlags(9)
  JustificationFlags_topRight* = JustificationFlags(10)
  JustificationFlags_bottomLeft* = JustificationFlags(17)
  JustificationFlags_bottomRight* = JustificationFlags(18)

const
  PathStrokeTypeJointStyle_mitered* = PathStrokeTypeJointStyle(0)
  PathStrokeTypeJointStyle_curved* = PathStrokeTypeJointStyle(1)
  PathStrokeTypeJointStyle_beveled* = PathStrokeTypeJointStyle(2)

const
  PathStrokeTypeEndCapStyle_butt* = PathStrokeTypeEndCapStyle(0)
  PathStrokeTypeEndCapStyle_square* = PathStrokeTypeEndCapStyle(1)
  PathStrokeTypeEndCapStyle_rounded* = PathStrokeTypeEndCapStyle(2)

const
  RectanglePlacementFlags_xLeft* = RectanglePlacementFlags(1)
  RectanglePlacementFlags_xRight* = RectanglePlacementFlags(2)
  RectanglePlacementFlags_xMid* = RectanglePlacementFlags(4)
  RectanglePlacementFlags_yTop* = RectanglePlacementFlags(8)
  RectanglePlacementFlags_yBottom* = RectanglePlacementFlags(16)
  RectanglePlacementFlags_yMid* = RectanglePlacementFlags(32)
  RectanglePlacementFlags_stretchToFit* = RectanglePlacementFlags(64)
  RectanglePlacementFlags_fillDestination* = RectanglePlacementFlags(128)
  RectanglePlacementFlags_onlyReduceInSize* = RectanglePlacementFlags(256)
  RectanglePlacementFlags_onlyIncreaseInSize* = RectanglePlacementFlags(512)
  RectanglePlacementFlags_doNotResize* = RectanglePlacementFlags(768)
  RectanglePlacementFlags_centred* = RectanglePlacementFlags(36)

const
  GraphicsResamplingQuality_lowResamplingQuality* = GraphicsResamplingQuality(0)
  GraphicsResamplingQuality_mediumResamplingQuality* = GraphicsResamplingQuality(1)
  GraphicsResamplingQuality_highResamplingQuality* = GraphicsResamplingQuality(2)

const
  ImagePixelFormat_UnknownFormat* = ImagePixelFormat(0)
  ImagePixelFormat_RGB* = ImagePixelFormat(1)
  ImagePixelFormat_ARGB* = ImagePixelFormat(2)
  ImagePixelFormat_SingleChannel* = ImagePixelFormat(3)

const
  TypefaceColourGlyphFormat_colourGlyphFormatBitmap* = TypefaceColourGlyphFormat(1)
  TypefaceColourGlyphFormat_colourGlyphFormatSvg* = TypefaceColourGlyphFormat(2)
  TypefaceColourGlyphFormat_colourGlyphFormatCOLRv0* = TypefaceColourGlyphFormat(4)
  TypefaceColourGlyphFormat_colourGlyphFormatCOLRv1* = TypefaceColourGlyphFormat(8)

const
  FontFontStyleFlags_plain* = FontFontStyleFlags(0)
  FontFontStyleFlags_bold* = FontFontStyleFlags(1)
  FontFontStyleFlags_italic* = FontFontStyleFlags(2)
  FontFontStyleFlags_underlined* = FontFontStyleFlags(4)

const
  AttributedStringWordWrap_none* = AttributedStringWordWrap(0)
  AttributedStringWordWrap_byWord* = AttributedStringWordWrap(1)
  AttributedStringWordWrap_byChar* = AttributedStringWordWrap(2)

const
  AttributedStringReadingDirection_natural* = AttributedStringReadingDirection(0)
  AttributedStringReadingDirection_leftToRight* = AttributedStringReadingDirection(1)
  AttributedStringReadingDirection_rightToLeft* = AttributedStringReadingDirection(2)

const
  PixelARGB_indexA*: cint = 3
  PixelARGB_indexR*: cint = 2
  PixelARGB_indexG*: cint = 1
  PixelARGB_indexB*: cint = 0

const
  PixelRGB_indexR*: cint = 0
  PixelRGB_indexG*: cint = 1
  PixelRGB_indexB*: cint = 2

const
  PixelAlpha_indexA*: cint = 0

proc makeAffineTransform*(): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform(@)".}
proc makeAffineTransform*(mat00: float, mat01: float, mat02: float, mat10: float, mat11: float, mat12: float): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform(@)".}
proc `AffineTransform=`*(this: var AffineTransform, arg1: AffineTransform): var AffineTransform {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `AffineTransform==`*(this: AffineTransform, other: AffineTransform): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `AffineTransform!=`*(this: AffineTransform, other: AffineTransform): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc translated*(this: AffineTransform, deltaX: float, deltaY: float): AffineTransform {.header: juce_graphics, importcpp: "#.translated(@)".}
proc withAbsoluteTranslation*(this: AffineTransform, translationX: float, translationY: float): AffineTransform {.header: juce_graphics, importcpp: "#.withAbsoluteTranslation(@)".}
proc rotated*(this: AffineTransform, angleInRadians: float): AffineTransform {.header: juce_graphics, importcpp: "#.rotated(@)".}
proc rotated*(this: AffineTransform, angleInRadians: float, pivotX: float, pivotY: float): AffineTransform {.header: juce_graphics, importcpp: "#.rotated(@)".}
proc scaled*(this: AffineTransform, factorX: float, factorY: float): AffineTransform {.header: juce_graphics, importcpp: "#.scaled(@)".}
proc scaled*(this: AffineTransform, factor: float): AffineTransform {.header: juce_graphics, importcpp: "#.scaled(@)".}
proc scaled*(this: AffineTransform, factorX: float, factorY: float, pivotX: float, pivotY: float): AffineTransform {.header: juce_graphics, importcpp: "#.scaled(@)".}
proc sheared*(this: AffineTransform, shearX: float, shearY: float): AffineTransform {.header: juce_graphics, importcpp: "#.sheared(@)".}
proc inverted*(this: AffineTransform): AffineTransform {.header: juce_graphics, importcpp: "#.inverted()".}
proc followedBy*(this: AffineTransform, other: AffineTransform): AffineTransform {.header: juce_graphics, importcpp: "#.followedBy(@)".}
proc isIdentity*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isIdentity()".}
proc isSingularity*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isSingularity()".}
proc isOnlyTranslation*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isOnlyTranslation()".}
proc isOnlyTranslationOrScale*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isOnlyTranslationOrScale()".}
proc getTranslationX*(this: AffineTransform): float {.header: juce_graphics, importcpp: "#.getTranslationX()".}
proc getTranslationY*(this: AffineTransform): float {.header: juce_graphics, importcpp: "#.getTranslationY()".}
proc getDeterminant*(this: AffineTransform): float {.header: juce_graphics, importcpp: "#.getDeterminant()".}
proc getScaleFactor*(this: AffineTransform): float {.header: juce_graphics, importcpp: "#.getScaleFactor()".}

proc makeJustification*(justificationFlags: int): Justification {.header: juce_graphics, importcpp: "juce::Justification(@)".}
proc `Justification=`*(this: var Justification, arg1: Justification): var Justification {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Justification==`*(this: Justification, other: Justification): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `Justification!=`*(this: Justification, other: Justification): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc getFlags*(this: Justification): int {.header: juce_graphics, importcpp: "#.getFlags()".}
proc testFlags*(this: Justification, flagsToTest: int): bool {.header: juce_graphics, importcpp: "#.testFlags(@)".}
proc getOnlyVerticalFlags*(this: Justification): int {.header: juce_graphics, importcpp: "#.getOnlyVerticalFlags()".}
proc getOnlyHorizontalFlags*(this: Justification): int {.header: juce_graphics, importcpp: "#.getOnlyHorizontalFlags()".}

proc makePath*(): Path {.header: juce_graphics, importcpp: "juce::Path(@)".}
proc `Path=`*(this: var Path, arg1: Path): var Path {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Path=`*(this: var Path, arg1: lent Path): var Path {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Path==`*(this: Path, arg1: Path): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `Path!=`*(this: Path, arg1: Path): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc isEmpty*(this: Path): bool {.header: juce_graphics, importcpp: "#.isEmpty()".}
proc getBounds*(this: Path): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getBoundsTransformed*(this: Path, transform: AffineTransform): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBoundsTransformed(@)".}
proc contains*(this: Path, x: float, y: float, tolerance: float): bool {.header: juce_graphics, importcpp: "#.contains(@)".}
proc contains*(this: Path, point: Point[cfloat], tolerance: float): bool {.header: juce_graphics, importcpp: "#.contains(@)".}
proc intersectsLine*(this: Path, line: Line[cfloat], tolerance: float): bool {.header: juce_graphics, importcpp: "#.intersectsLine(@)".}
proc getClippedLine*(this: Path, line: Line[cfloat], keepSectionOutsidePath: bool): Line[cfloat] {.header: juce_graphics, importcpp: "#.getClippedLine(@)".}
proc getLength*(this: Path, transform: AffineTransform, tolerance: float): float {.header: juce_graphics, importcpp: "#.getLength(@)".}
proc getPointAlongPath*(this: Path, distanceFromStart: float, transform: AffineTransform, tolerance: float): Point[cfloat] {.header: juce_graphics, importcpp: "#.getPointAlongPath(@)".}
proc getNearestPoint*(this: Path, targetPoint: Point[cfloat], pointOnPath: Point[cfloat], transform: AffineTransform, tolerance: float): float {.header: juce_graphics, importcpp: "#.getNearestPoint(@)".}
proc clear*(this: var Path) {.header: juce_graphics, importcpp: "#.clear()".}
proc startNewSubPath*(this: var Path, startX: float, startY: float) {.header: juce_graphics, importcpp: "#.startNewSubPath(@)".}
proc startNewSubPath*(this: var Path, start: Point[cfloat]) {.header: juce_graphics, importcpp: "#.startNewSubPath(@)".}
proc closeSubPath*(this: var Path) {.header: juce_graphics, importcpp: "#.closeSubPath()".}
proc lineTo*(this: var Path, endX: float, endY: float) {.header: juce_graphics, importcpp: "#.lineTo(@)".}
proc lineTo*(this: var Path, `end`: Point[cfloat]) {.header: juce_graphics, importcpp: "#.lineTo(@)".}
proc quadraticTo*(this: var Path, controlPointX: float, controlPointY: float, endPointX: float, endPointY: float) {.header: juce_graphics, importcpp: "#.quadraticTo(@)".}
proc quadraticTo*(this: var Path, controlPoint: Point[cfloat], endPoint: Point[cfloat]) {.header: juce_graphics, importcpp: "#.quadraticTo(@)".}
proc cubicTo*(this: var Path, controlPoint1X: float, controlPoint1Y: float, controlPoint2X: float, controlPoint2Y: float, endPointX: float, endPointY: float) {.header: juce_graphics, importcpp: "#.cubicTo(@)".}
proc cubicTo*(this: var Path, controlPoint1: Point[cfloat], controlPoint2: Point[cfloat], endPoint: Point[cfloat]) {.header: juce_graphics, importcpp: "#.cubicTo(@)".}
proc getCurrentPosition*(this: Path): Point[cfloat] {.header: juce_graphics, importcpp: "#.getCurrentPosition()".}
proc addRectangle*(this: var Path, x: float, y: float, width: float, height: float) {.header: juce_graphics, importcpp: "#.addRectangle(@)".}
proc addRoundedRectangle*(this: var Path, x: float, y: float, width: float, height: float, cornerSize: float) {.header: juce_graphics, importcpp: "#.addRoundedRectangle(@)".}
proc addRoundedRectangle*(this: var Path, x: float, y: float, width: float, height: float, cornerSizeX: float, cornerSizeY: float) {.header: juce_graphics, importcpp: "#.addRoundedRectangle(@)".}
proc addRoundedRectangle*(this: var Path, x: float, y: float, width: float, height: float, cornerSizeX: float, cornerSizeY: float, curveTopLeft: bool, curveTopRight: bool, curveBottomLeft: bool, curveBottomRight: bool) {.header: juce_graphics, importcpp: "#.addRoundedRectangle(@)".}
proc addTriangle*(this: var Path, x1: float, y1: float, x2: float, y2: float, x3: float, y3: float) {.header: juce_graphics, importcpp: "#.addTriangle(@)".}
proc addTriangle*(this: var Path, point1: Point[cfloat], point2: Point[cfloat], point3: Point[cfloat]) {.header: juce_graphics, importcpp: "#.addTriangle(@)".}
proc addQuadrilateral*(this: var Path, x1: float, y1: float, x2: float, y2: float, x3: float, y3: float, x4: float, y4: float) {.header: juce_graphics, importcpp: "#.addQuadrilateral(@)".}
proc addEllipse*(this: var Path, x: float, y: float, width: float, height: float) {.header: juce_graphics, importcpp: "#.addEllipse(@)".}
proc addEllipse*(this: var Path, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.addEllipse(@)".}
proc addArc*(this: var Path, x: float, y: float, width: float, height: float, fromRadians: float, toRadians: float, startAsNewSubPath: bool = false) {.header: juce_graphics, importcpp: "#.addArc(@)".}
proc addCentredArc*(this: var Path, centreX: float, centreY: float, radiusX: float, radiusY: float, rotationOfEllipse: float, fromRadians: float, toRadians: float, startAsNewSubPath: bool = false) {.header: juce_graphics, importcpp: "#.addCentredArc(@)".}
proc addPieSegment*(this: var Path, x: float, y: float, width: float, height: float, fromRadians: float, toRadians: float, innerCircleProportionalSize: float) {.header: juce_graphics, importcpp: "#.addPieSegment(@)".}
proc addPieSegment*(this: var Path, segmentBounds: Rectangle[cfloat], fromRadians: float, toRadians: float, innerCircleProportionalSize: float) {.header: juce_graphics, importcpp: "#.addPieSegment(@)".}
proc addLineSegment*(this: var Path, line: Line[cfloat], lineThickness: float) {.header: juce_graphics, importcpp: "#.addLineSegment(@)".}
proc addArrow*(this: var Path, line: Line[cfloat], lineThickness: float, arrowheadWidth: float, arrowheadLength: float) {.header: juce_graphics, importcpp: "#.addArrow(@)".}
proc addPolygon*(this: var Path, centre: Point[cfloat], numberOfSides: int, radius: float, startAngle: float = 0.0f) {.header: juce_graphics, importcpp: "#.addPolygon(@)".}
proc addStar*(this: var Path, centre: Point[cfloat], numberOfPoints: int, innerRadius: float, outerRadius: float, startAngle: float = 0.0f) {.header: juce_graphics, importcpp: "#.addStar(@)".}
proc addBubble*(this: var Path, bodyArea: Rectangle[cfloat], maximumArea: Rectangle[cfloat], arrowTipPosition: Point[cfloat], cornerSize: float, arrowBaseWidth: float) {.header: juce_graphics, importcpp: "#.addBubble(@)".}
proc addPath*(this: var Path, pathToAppend: Path) {.header: juce_graphics, importcpp: "#.addPath(@)".}
proc addPath*(this: var Path, pathToAppend: Path, transformToApply: AffineTransform) {.header: juce_graphics, importcpp: "#.addPath(@)".}
proc swapWithPath*(this: var Path, arg1: var Path) {.header: juce_graphics, importcpp: "#.swapWithPath(@)".}
proc preallocateSpace*(this: var Path, numExtraCoordsToMakeSpaceFor: int) {.header: juce_graphics, importcpp: "#.preallocateSpace(@)".}
proc applyTransform*(this: var Path, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.applyTransform(@)".}
proc scaleToFit*(this: var Path, x: float, y: float, width: float, height: float, preserveProportions: bool) {.header: juce_graphics, importcpp: "#.scaleToFit(@)".}
proc getTransformToScaleToFit*(this: Path, x: float, y: float, width: float, height: float, preserveProportions: bool, justificationType: Justification): AffineTransform {.header: juce_graphics, importcpp: "#.getTransformToScaleToFit(@)".}
proc getTransformToScaleToFit*(this: Path, area: Rectangle[cfloat], preserveProportions: bool, justificationType: Justification): AffineTransform {.header: juce_graphics, importcpp: "#.getTransformToScaleToFit(@)".}
proc createPathWithRoundedCorners*(this: Path, cornerRadius: float): Path {.header: juce_graphics, importcpp: "#.createPathWithRoundedCorners(@)".}
proc setUsingNonZeroWinding*(this: var Path, isNonZeroWinding: bool) {.header: juce_graphics, importcpp: "#.setUsingNonZeroWinding(@)".}
proc isUsingNonZeroWinding*(this: Path): bool {.header: juce_graphics, importcpp: "#.isUsingNonZeroWinding()".}
proc loadPathFromStream*(this: var Path, source: var InputStream) {.header: juce_graphics, importcpp: "#.loadPathFromStream(@)".}
proc loadPathFromData*(this: var Path, data: constPointer, numberOfBytes: csize_t) {.header: juce_graphics, importcpp: "#.loadPathFromData(@)".}
proc writePathToStream*(this: Path, destination: var OutputStream) {.header: juce_graphics, importcpp: "#.writePathToStream(@)".}
proc toString*(this: Path): String {.header: juce_graphics, importcpp: "#.toString()".}
proc restoreFromString*(this: var Path, stringVersion: StringRef) {.header: juce_graphics, importcpp: "#.restoreFromString(@)".}

proc makePixelARGB*(): PixelARGB {.header: juce_graphics, importcpp: "juce::PixelARGB(@)".}
proc makePixelARGB*(a: uint8, r: uint8, g: uint8, b: uint8): PixelARGB {.header: juce_graphics, importcpp: "juce::PixelARGB(@)".}
proc getNativeARGB*(this: PixelARGB): uint32 {.header: juce_graphics, importcpp: "#.getNativeARGB()".}
proc getInARGBMaskOrder*(this: PixelARGB): uint32 {.header: juce_graphics, importcpp: "#.getInARGBMaskOrder()".}
proc getInARGBMemoryOrder*(this: PixelARGB): uint32 {.header: juce_graphics, importcpp: "#.getInARGBMemoryOrder()".}
proc getEvenBytes*(this: PixelARGB): uint32 {.header: juce_graphics, importcpp: "#.getEvenBytes()".}
proc getOddBytes*(this: PixelARGB): uint32 {.header: juce_graphics, importcpp: "#.getOddBytes()".}
proc getAlpha*(this: PixelARGB): uint8 {.header: juce_graphics, importcpp: "#.getAlpha()".}
proc getRed*(this: PixelARGB): uint8 {.header: juce_graphics, importcpp: "#.getRed()".}
proc getGreen*(this: PixelARGB): uint8 {.header: juce_graphics, importcpp: "#.getGreen()".}
proc getBlue*(this: PixelARGB): uint8 {.header: juce_graphics, importcpp: "#.getBlue()".}
proc setARGB*(this: var PixelARGB, a: uint8, r: uint8, g: uint8, b: uint8) {.header: juce_graphics, importcpp: "#.setARGB(@)".}
proc blend*(this: var PixelARGB, src: PixelRGB) {.header: juce_graphics, importcpp: "#.blend(@)".}
proc setAlpha*(this: var PixelARGB, newAlpha: uint8) {.header: juce_graphics, importcpp: "#.setAlpha(@)".}
proc multiplyAlpha*(this: var PixelARGB, multiplier: int) {.header: juce_graphics, importcpp: "#.multiplyAlpha(@)".}
proc multiplyAlpha*(this: var PixelARGB, multiplier: float) {.header: juce_graphics, importcpp: "#.multiplyAlpha(@)".}
proc getUnpremultiplied*(this: PixelARGB): PixelARGB {.header: juce_graphics, importcpp: "#.getUnpremultiplied()".}
proc premultiply*(this: var PixelARGB) {.header: juce_graphics, importcpp: "#.premultiply()".}
proc unpremultiply*(this: var PixelARGB) {.header: juce_graphics, importcpp: "#.unpremultiply()".}
proc desaturate*(this: var PixelARGB) {.header: juce_graphics, importcpp: "#.desaturate()".}

proc makePixelRGB*(): PixelRGB {.header: juce_graphics, importcpp: "juce::PixelRGB(@)".}
proc getNativeARGB*(this: PixelRGB): uint32 {.header: juce_graphics, importcpp: "#.getNativeARGB()".}
proc getInARGBMaskOrder*(this: PixelRGB): uint32 {.header: juce_graphics, importcpp: "#.getInARGBMaskOrder()".}
proc getInARGBMemoryOrder*(this: PixelRGB): uint32 {.header: juce_graphics, importcpp: "#.getInARGBMemoryOrder()".}
proc getEvenBytes*(this: PixelRGB): uint32 {.header: juce_graphics, importcpp: "#.getEvenBytes()".}
proc getOddBytes*(this: PixelRGB): uint32 {.header: juce_graphics, importcpp: "#.getOddBytes()".}
proc getAlpha*(this: PixelRGB): uint8 {.header: juce_graphics, importcpp: "#.getAlpha()".}
proc getRed*(this: PixelRGB): uint8 {.header: juce_graphics, importcpp: "#.getRed()".}
proc getGreen*(this: PixelRGB): uint8 {.header: juce_graphics, importcpp: "#.getGreen()".}
proc getBlue*(this: PixelRGB): uint8 {.header: juce_graphics, importcpp: "#.getBlue()".}
proc setARGB*(this: var PixelRGB, arg1: uint8, red: uint8, green: uint8, blue: uint8) {.header: juce_graphics, importcpp: "#.setARGB(@)".}
proc blend*(this: var PixelRGB, src: PixelRGB) {.header: juce_graphics, importcpp: "#.blend(@)".}
proc setAlpha*(this: var PixelRGB, arg1: uint8) {.header: juce_graphics, importcpp: "#.setAlpha(@)".}
proc multiplyAlpha*(this: var PixelRGB, arg1: int) {.header: juce_graphics, importcpp: "#.multiplyAlpha(@)".}
proc multiplyAlpha*(this: var PixelRGB, arg1: float) {.header: juce_graphics, importcpp: "#.multiplyAlpha(@)".}
proc premultiply*(this: var PixelRGB) {.header: juce_graphics, importcpp: "#.premultiply()".}
proc unpremultiply*(this: var PixelRGB) {.header: juce_graphics, importcpp: "#.unpremultiply()".}
proc desaturate*(this: var PixelRGB) {.header: juce_graphics, importcpp: "#.desaturate()".}

proc makePixelAlpha*(): PixelAlpha {.header: juce_graphics, importcpp: "juce::PixelAlpha(@)".}
proc getNativeARGB*(this: PixelAlpha): uint32 {.header: juce_graphics, importcpp: "#.getNativeARGB()".}
proc getInARGBMaskOrder*(this: PixelAlpha): uint32 {.header: juce_graphics, importcpp: "#.getInARGBMaskOrder()".}
proc getInARGBMemoryOrder*(this: PixelAlpha): uint32 {.header: juce_graphics, importcpp: "#.getInARGBMemoryOrder()".}
proc getEvenBytes*(this: PixelAlpha): uint32 {.header: juce_graphics, importcpp: "#.getEvenBytes()".}
proc getOddBytes*(this: PixelAlpha): uint32 {.header: juce_graphics, importcpp: "#.getOddBytes()".}
proc getAlpha*(this: PixelAlpha): uint8 {.header: juce_graphics, importcpp: "#.getAlpha()".}
proc getRed*(this: PixelAlpha): uint8 {.header: juce_graphics, importcpp: "#.getRed()".}
proc getGreen*(this: PixelAlpha): uint8 {.header: juce_graphics, importcpp: "#.getGreen()".}
proc getBlue*(this: PixelAlpha): uint8 {.header: juce_graphics, importcpp: "#.getBlue()".}
proc setARGB*(this: var PixelAlpha, a: uint8, arg2: uint8, arg3: uint8, arg4: uint8) {.header: juce_graphics, importcpp: "#.setARGB(@)".}
proc setAlpha*(this: var PixelAlpha, newAlpha: uint8) {.header: juce_graphics, importcpp: "#.setAlpha(@)".}
proc multiplyAlpha*(this: var PixelAlpha, multiplier: int) {.header: juce_graphics, importcpp: "#.multiplyAlpha(@)".}
proc multiplyAlpha*(this: var PixelAlpha, multiplier: float) {.header: juce_graphics, importcpp: "#.multiplyAlpha(@)".}
proc premultiply*(this: var PixelAlpha) {.header: juce_graphics, importcpp: "#.premultiply()".}
proc unpremultiply*(this: var PixelAlpha) {.header: juce_graphics, importcpp: "#.unpremultiply()".}
proc desaturate*(this: var PixelAlpha) {.header: juce_graphics, importcpp: "#.desaturate()".}

proc makeColour*(): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(argb: uint32): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(red: uint8, green: uint8, blue: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(red: uint8, green: uint8, blue: uint8, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(red: uint8, green: uint8, blue: uint8, alpha: float): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(hue: float, saturation: float, brightness: float, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(hue: float, saturation: float, brightness: float, alpha: float): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(argb: PixelARGB): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(rgb: PixelRGB): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(alpha: PixelAlpha): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc `Colour=`*(this: var Colour, arg1: Colour): var Colour {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Colour==`*(this: Colour, other: Colour): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `Colour!=`*(this: Colour, other: Colour): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc getRed*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getRed()".}
proc getGreen*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getGreen()".}
proc getBlue*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getBlue()".}
proc getFloatRed*(this: Colour): float {.header: juce_graphics, importcpp: "#.getFloatRed()".}
proc getFloatGreen*(this: Colour): float {.header: juce_graphics, importcpp: "#.getFloatGreen()".}
proc getFloatBlue*(this: Colour): float {.header: juce_graphics, importcpp: "#.getFloatBlue()".}
proc getPixelARGB*(this: Colour): PixelARGB {.header: juce_graphics, importcpp: "#.getPixelARGB()".}
proc getNonPremultipliedPixelARGB*(this: Colour): PixelARGB {.header: juce_graphics, importcpp: "#.getNonPremultipliedPixelARGB()".}
proc getARGB*(this: Colour): uint32 {.header: juce_graphics, importcpp: "#.getARGB()".}
proc getAlpha*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getAlpha()".}
proc getFloatAlpha*(this: Colour): float {.header: juce_graphics, importcpp: "#.getFloatAlpha()".}
proc isOpaque*(this: Colour): bool {.header: juce_graphics, importcpp: "#.isOpaque()".}
proc isTransparent*(this: Colour): bool {.header: juce_graphics, importcpp: "#.isTransparent()".}
proc withAlpha*(this: Colour, newAlpha: uint8): Colour {.header: juce_graphics, importcpp: "#.withAlpha(@)".}
proc withAlpha*(this: Colour, newAlpha: float): Colour {.header: juce_graphics, importcpp: "#.withAlpha(@)".}
proc withMultipliedAlpha*(this: Colour, alphaMultiplier: float): Colour {.header: juce_graphics, importcpp: "#.withMultipliedAlpha(@)".}
proc overlaidWith*(this: Colour, foregroundColour: Colour): Colour {.header: juce_graphics, importcpp: "#.overlaidWith(@)".}
proc interpolatedWith*(this: Colour, other: Colour, proportionOfOther: float): Colour {.header: juce_graphics, importcpp: "#.interpolatedWith(@)".}
proc getHue*(this: Colour): float {.header: juce_graphics, importcpp: "#.getHue()".}
proc getSaturation*(this: Colour): float {.header: juce_graphics, importcpp: "#.getSaturation()".}
proc getSaturationHSL*(this: Colour): float {.header: juce_graphics, importcpp: "#.getSaturationHSL()".}
proc getBrightness*(this: Colour): float {.header: juce_graphics, importcpp: "#.getBrightness()".}
proc getLightness*(this: Colour): float {.header: juce_graphics, importcpp: "#.getLightness()".}
proc getPerceivedBrightness*(this: Colour): float {.header: juce_graphics, importcpp: "#.getPerceivedBrightness()".}
proc getHSB*(this: Colour, hue: var float, saturation: var float, brightness: var float) {.header: juce_graphics, importcpp: "#.getHSB(@)".}
proc getHSL*(this: Colour, hue: var float, saturation: var float, lightness: var float) {.header: juce_graphics, importcpp: "#.getHSL(@)".}
proc withHue*(this: Colour, newHue: float): Colour {.header: juce_graphics, importcpp: "#.withHue(@)".}
proc withSaturation*(this: Colour, newSaturation: float): Colour {.header: juce_graphics, importcpp: "#.withSaturation(@)".}
proc withSaturationHSL*(this: Colour, newSaturation: float): Colour {.header: juce_graphics, importcpp: "#.withSaturationHSL(@)".}
proc withBrightness*(this: Colour, newBrightness: float): Colour {.header: juce_graphics, importcpp: "#.withBrightness(@)".}
proc withLightness*(this: Colour, newLightness: float): Colour {.header: juce_graphics, importcpp: "#.withLightness(@)".}
proc withRotatedHue*(this: Colour, amountToRotate: float): Colour {.header: juce_graphics, importcpp: "#.withRotatedHue(@)".}
proc withMultipliedSaturation*(this: Colour, multiplier: float): Colour {.header: juce_graphics, importcpp: "#.withMultipliedSaturation(@)".}
proc withMultipliedSaturationHSL*(this: Colour, multiplier: float): Colour {.header: juce_graphics, importcpp: "#.withMultipliedSaturationHSL(@)".}
proc withMultipliedBrightness*(this: Colour, amount: float): Colour {.header: juce_graphics, importcpp: "#.withMultipliedBrightness(@)".}
proc withMultipliedLightness*(this: Colour, amount: float): Colour {.header: juce_graphics, importcpp: "#.withMultipliedLightness(@)".}
proc brighter*(this: Colour, amountBrighter: float = 0.4f): Colour {.header: juce_graphics, importcpp: "#.brighter(@)".}
proc darker*(this: Colour, amountDarker: float = 0.4f): Colour {.header: juce_graphics, importcpp: "#.darker(@)".}
proc contrasting*(this: Colour, amount: float = 1.0f): Colour {.header: juce_graphics, importcpp: "#.contrasting(@)".}
proc contrasting*(this: Colour, targetColour: Colour, minLuminosityDiff: float): Colour {.header: juce_graphics, importcpp: "#.contrasting(@)".}
proc toString*(this: Colour): String {.header: juce_graphics, importcpp: "#.toString()".}
proc toDisplayString*(this: Colour, includeAlphaValue: bool): String {.header: juce_graphics, importcpp: "#.toDisplayString(@)".}

proc makeColourGradient*(): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient(@)".}
proc makeColourGradient*(colour1: Colour, x1: float, y1: float, colour2: Colour, x2: float, y2: float, isRadial: bool): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient(@)".}
proc makeColourGradient*(colour1: Colour, point1: Point[cfloat], colour2: Colour, point2: Point[cfloat], isRadial: bool): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient(@)".}
proc `ColourGradient=`*(this: var ColourGradient, arg1: ColourGradient): var ColourGradient {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `ColourGradient=`*(this: var ColourGradient, arg1: lent ColourGradient): var ColourGradient {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc clearColours*(this: var ColourGradient) {.header: juce_graphics, importcpp: "#.clearColours()".}
proc addColour*(this: var ColourGradient, proportionAlongGradient: float64, colour: Colour): int {.header: juce_graphics, importcpp: "#.addColour(@)".}
proc removeColour*(this: var ColourGradient, index: int) {.header: juce_graphics, importcpp: "#.removeColour(@)".}
proc multiplyOpacity*(this: var ColourGradient, multiplier: float) {.header: juce_graphics, importcpp: "#.multiplyOpacity(@)".}
proc getNumColours*(this: ColourGradient): int {.header: juce_graphics, importcpp: "#.getNumColours()".}
proc getColourPosition*(this: ColourGradient, index: int): float64 {.header: juce_graphics, importcpp: "#.getColourPosition(@)".}
proc getColour*(this: ColourGradient, index: int): Colour {.header: juce_graphics, importcpp: "#.getColour(@)".}
proc setColour*(this: var ColourGradient, index: int, newColour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc getColourAtPosition*(this: ColourGradient, position: float64): Colour {.header: juce_graphics, importcpp: "#.getColourAtPosition(@)".}
# proc createLookupTable*(this: ColourGradient, transform: AffineTransform, resultLookupTable: HeapBlock<PixelARGB>): int {.header: juce_graphics, importcpp: "#.createLookupTable(@)".}
proc createLookupTable*(this: ColourGradient, resultLookupTable: ptr PixelARGB, numEntries: int) {.header: juce_graphics, importcpp: "#.createLookupTable(@)".}
proc isOpaque*(this: ColourGradient): bool {.header: juce_graphics, importcpp: "#.isOpaque()".}
proc isInvisible*(this: ColourGradient): bool {.header: juce_graphics, importcpp: "#.isInvisible()".}
proc `ColourGradient==`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `ColourGradient!=`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc `ColourGradient<`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `ColourGradient<=`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
proc `ColourGradient>`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}
proc `ColourGradient>=`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}

proc makeEdgeTable*(clipLimits: Rectangle[cint], pathToAdd: Path, transform: AffineTransform): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectangleToAdd: Rectangle[cint]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectangleToAdd: Rectangle[cfloat]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectanglesToAdd: RectangleList[cint]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectanglesToAdd: RectangleList[cfloat]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc clipToRectangle*(this: var EdgeTable, r: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.clipToRectangle(@)".}
proc excludeRectangle*(this: var EdgeTable, r: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeRectangle(@)".}
proc clipToEdgeTable*(this: var EdgeTable, arg1: EdgeTable) {.header: juce_graphics, importcpp: "#.clipToEdgeTable(@)".}
proc clipLineToMask*(this: var EdgeTable, x: int, y: int, mask: ptr uint8, maskStride: int, numPixels: int) {.header: juce_graphics, importcpp: "#.clipLineToMask(@)".}
proc isEmpty*(this: var EdgeTable): bool {.header: juce_graphics, importcpp: "#.isEmpty()".}
proc getMaximumBounds*(this: EdgeTable): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getMaximumBounds()".}
proc translate*(this: var EdgeTable, dx: float, dy: int) {.header: juce_graphics, importcpp: "#.translate(@)".}
proc multiplyLevels*(this: var EdgeTable, factor: float) {.header: juce_graphics, importcpp: "#.multiplyLevels(@)".}
proc optimiseTable*(this: var EdgeTable) {.header: juce_graphics, importcpp: "#.optimiseTable()".}

proc makePathFlatteningIterator*(path: Path, transform: AffineTransform, tolerance: float): PathFlatteningIterator {.header: juce_graphics, importcpp: "juce::PathFlatteningIterator(@)".}
proc next*(this: var PathFlatteningIterator): bool {.header: juce_graphics, importcpp: "#.next()".}
proc isLastInSubpath*(this: PathFlatteningIterator): bool {.header: juce_graphics, importcpp: "#.isLastInSubpath()".}

proc makePathStrokeType*(strokeThickness: float): PathStrokeType {.header: juce_graphics, importcpp: "juce::PathStrokeType(@)".}
proc makePathStrokeType*(strokeThickness: float, jointStyle: PathStrokeTypeJointStyle, endStyle: PathStrokeTypeEndCapStyle): PathStrokeType {.header: juce_graphics, importcpp: "juce::PathStrokeType(@)".}
proc `PathStrokeType=`*(this: var PathStrokeType, arg1: PathStrokeType): var PathStrokeType {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc createStrokedPath*(this: PathStrokeType, destPath: var Path, sourcePath: Path, transform: AffineTransform, extraAccuracy: float = 1.0f) {.header: juce_graphics, importcpp: "#.createStrokedPath(@)".}
proc createDashedStroke*(this: PathStrokeType, destPath: var Path, sourcePath: Path, dashLengths: ptr float, numDashLengths: int, transform: AffineTransform, extraAccuracy: float = 1.0f) {.header: juce_graphics, importcpp: "#.createDashedStroke(@)".}
proc createStrokeWithArrowheads*(this: PathStrokeType, destPath: var Path, sourcePath: Path, arrowheadStartWidth: float, arrowheadStartLength: float, arrowheadEndWidth: float, arrowheadEndLength: float, transform: AffineTransform, extraAccuracy: float = 1.0f) {.header: juce_graphics, importcpp: "#.createStrokeWithArrowheads(@)".}
proc getStrokeThickness*(this: PathStrokeType): float {.header: juce_graphics, importcpp: "#.getStrokeThickness()".}
proc setStrokeThickness*(this: var PathStrokeType, newThickness: float) {.header: juce_graphics, importcpp: "#.setStrokeThickness(@)".}
proc getJointStyle*(this: PathStrokeType): PathStrokeTypeJointStyle {.header: juce_graphics, importcpp: "#.getJointStyle()".}
proc setJointStyle*(this: var PathStrokeType, newStyle: PathStrokeTypeJointStyle) {.header: juce_graphics, importcpp: "#.setJointStyle(@)".}
proc getEndStyle*(this: PathStrokeType): PathStrokeTypeEndCapStyle {.header: juce_graphics, importcpp: "#.getEndStyle()".}
proc setEndStyle*(this: var PathStrokeType, newStyle: PathStrokeTypeEndCapStyle) {.header: juce_graphics, importcpp: "#.setEndStyle(@)".}
proc `PathStrokeType==`*(this: PathStrokeType, arg1: PathStrokeType): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `PathStrokeType!=`*(this: PathStrokeType, arg1: PathStrokeType): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}

proc makeRectanglePlacement*(placementFlags: int): RectanglePlacement {.header: juce_graphics, importcpp: "juce::RectanglePlacement(@)".}
proc makeRectanglePlacement*(): RectanglePlacement {.header: juce_graphics, importcpp: "juce::RectanglePlacement(@)".}
proc `RectanglePlacement=`*(this: var RectanglePlacement, arg1: RectanglePlacement): var RectanglePlacement {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `RectanglePlacement==`*(this: RectanglePlacement, arg1: RectanglePlacement): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `RectanglePlacement!=`*(this: RectanglePlacement, arg1: RectanglePlacement): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc getFlags*(this: RectanglePlacement): int {.header: juce_graphics, importcpp: "#.getFlags()".}
proc testFlags*(this: RectanglePlacement, flagsToTest: int): bool {.header: juce_graphics, importcpp: "#.testFlags(@)".}
proc applyTo*(this: RectanglePlacement, sourceX: var float64, sourceY: var float64, sourceW: var float64, sourceH: var float64, destinationX: float64, destinationY: float64, destinationW: float64, destinationH: float64) {.header: juce_graphics, importcpp: "#.applyTo(@)".}
proc getTransformToFit*(this: RectanglePlacement, source: Rectangle[cfloat], destination: Rectangle[cfloat]): AffineTransform {.header: juce_graphics, importcpp: "#.getTransformToFit(@)".}


proc makeImageConvolutionKernel*(size: int): ImageConvolutionKernel {.header: juce_graphics, importcpp: "juce::ImageConvolutionKernel(@)".}
proc clear*(this: var ImageConvolutionKernel) {.header: juce_graphics, importcpp: "#.clear()".}
proc getKernelValue*(this: ImageConvolutionKernel, x: int, y: int): float {.header: juce_graphics, importcpp: "#.getKernelValue(@)".}
proc setKernelValue*(this: var ImageConvolutionKernel, x: int, y: int, value: float) {.header: juce_graphics, importcpp: "#.setKernelValue(@)".}
proc setOverallSum*(this: var ImageConvolutionKernel, desiredTotalSum: float) {.header: juce_graphics, importcpp: "#.setOverallSum(@)".}
proc rescaleAllValues*(this: var ImageConvolutionKernel, multiplier: float) {.header: juce_graphics, importcpp: "#.rescaleAllValues(@)".}
proc createGaussianBlur*(this: var ImageConvolutionKernel, blurRadius: float) {.header: juce_graphics, importcpp: "#.createGaussianBlur(@)".}
proc getKernelSize*(this: ImageConvolutionKernel): int {.header: juce_graphics, importcpp: "#.getKernelSize()".}
proc applyToImage*(this: ImageConvolutionKernel, destImage: var Image, sourceImage: Image, destinationArea: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.applyToImage(@)".}

proc getFormatName*(this: var ImageFileFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc canUnderstand*(this: var ImageFileFormat, input: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc usesFileExtension*(this: var ImageFileFormat, possibleFile: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc decodeImage*(this: var ImageFileFormat, input: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var ImageFileFormat, sourceImage: Image, destStream: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}

proc makePNGImageFormat*(): PNGImageFormat {.header: juce_graphics, importcpp: "juce::PNGImageFormat(@)".}
proc getFormatName*(this: var PNGImageFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc usesFileExtension*(this: var PNGImageFormat, arg1: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc canUnderstand*(this: var PNGImageFormat, arg1: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc decodeImage*(this: var PNGImageFormat, arg1: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var PNGImageFormat, arg1: Image, arg2: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}

proc makeJPEGImageFormat*(): JPEGImageFormat {.header: juce_graphics, importcpp: "juce::JPEGImageFormat(@)".}
proc setQuality*(this: var JPEGImageFormat, newQuality: float) {.header: juce_graphics, importcpp: "#.setQuality(@)".}
proc getFormatName*(this: var JPEGImageFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc usesFileExtension*(this: var JPEGImageFormat, arg1: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc canUnderstand*(this: var JPEGImageFormat, arg1: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc decodeImage*(this: var JPEGImageFormat, arg1: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var JPEGImageFormat, arg1: Image, arg2: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}

proc makeGIFImageFormat*(): GIFImageFormat {.header: juce_graphics, importcpp: "juce::GIFImageFormat(@)".}
proc getFormatName*(this: var GIFImageFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc usesFileExtension*(this: var GIFImageFormat, arg1: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc canUnderstand*(this: var GIFImageFormat, arg1: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc decodeImage*(this: var GIFImageFormat, arg1: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var GIFImageFormat, arg1: Image, arg2: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}

proc withLineSpacing*(this: GlyphArrangementOptions, x: float): GlyphArrangementOptions {.header: juce_graphics, importcpp: "#.withLineSpacing(@)".}
proc withLineHeightMultiple*(this: GlyphArrangementOptions, x: float): GlyphArrangementOptions {.header: juce_graphics, importcpp: "#.withLineHeightMultiple(@)".}
proc getLineSpacing*(this: GlyphArrangementOptions): float {.header: juce_graphics, importcpp: "#.getLineSpacing()".}
proc getLineHeightMultiple*(this: GlyphArrangementOptions): float {.header: juce_graphics, importcpp: "#.getLineHeightMultiple()".}
proc `GlyphArrangementOptions==`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `GlyphArrangementOptions!=`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc `GlyphArrangementOptions<`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `GlyphArrangementOptions<=`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
proc `GlyphArrangementOptions>`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}
proc `GlyphArrangementOptions>=`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}

proc makeGraphics*(imageToDrawOnto: Image): Graphics {.header: juce_graphics, importcpp: "juce::Graphics(@)".}
proc makeGraphics*(arg1: var LowLevelGraphicsContext): Graphics {.header: juce_graphics, importcpp: "juce::Graphics(@)".}
proc setColour*(this: var Graphics, newColour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setOpacity*(this: var Graphics, newOpacity: float) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
proc setGradientFill*(this: var Graphics, gradient: ColourGradient) {.header: juce_graphics, importcpp: "#.setGradientFill(@)".}
proc setGradientFill*(this: var Graphics, gradient: lent ColourGradient) {.header: juce_graphics, importcpp: "#.setGradientFill(@)".}
proc setTiledImageFill*(this: var Graphics, imageToUse: Image, anchorX: int, anchorY: int, opacity: float) {.header: juce_graphics, importcpp: "#.setTiledImageFill(@)".}
proc setFillType*(this: var Graphics, newFill: FillType) {.header: juce_graphics, importcpp: "#.setFillType(@)".}
proc setFont*(this: var Graphics, newFont: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc setFont*(this: var Graphics, newFontHeight: float) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc getCurrentFont*(this: Graphics): Font {.header: juce_graphics, importcpp: "#.getCurrentFont()".}
proc drawSingleLineText*(this: Graphics, text: String, startX: int, baselineY: int, justification: Justification) {.header: juce_graphics, importcpp: "#.drawSingleLineText(@)".}
proc drawMultiLineText*(this: Graphics, text: String, startX: int, baselineY: int, maximumLineWidth: int, justification: Justification, leading: float = 0.0f) {.header: juce_graphics, importcpp: "#.drawMultiLineText(@)".}
proc drawText*(this: Graphics, text: String, x: int, y: int, width: int, height: int, justificationType: Justification, useEllipsesIfTooBig: bool = true) {.header: juce_graphics, importcpp: "#.drawText(@)".}
proc drawText*(this: Graphics, text: String, area: Rectangle[cint], justificationType: Justification, useEllipsesIfTooBig: bool = true) {.header: juce_graphics, importcpp: "#.drawText(@)".}
proc drawText*(this: Graphics, text: String, area: Rectangle[cfloat], justificationType: Justification, useEllipsesIfTooBig: bool = true) {.header: juce_graphics, importcpp: "#.drawText(@)".}
proc drawFittedText*(this: Graphics, text: String, x: int, y: int, width: int, height: int, justificationFlags: Justification, maximumNumberOfLines: int, minimumHorizontalScale: float = 0.0f, options: GlyphArrangementOptions) {.header: juce_graphics, importcpp: "#.drawFittedText(@)".}
proc drawFittedText*(this: Graphics, text: String, area: Rectangle[cint], justificationFlags: Justification, maximumNumberOfLines: int, minimumHorizontalScale: float = 0.0f, options: GlyphArrangementOptions) {.header: juce_graphics, importcpp: "#.drawFittedText(@)".}
proc fillAll*(this: Graphics) {.header: juce_graphics, importcpp: "#.fillAll()".}
proc fillAll*(this: Graphics, colourToUse: Colour) {.header: juce_graphics, importcpp: "#.fillAll(@)".}
proc fillRect*(this: Graphics, rectangle: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: Graphics, rectangle: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: Graphics, x: int, y: int, width: int, height: int) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: Graphics, x: float, y: float, width: float, height: float) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRectList*(this: Graphics, rectangles: RectangleList[cfloat]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillRectList*(this: Graphics, rectangles: RectangleList[cint]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillRoundedRectangle*(this: Graphics, x: float, y: float, width: float, height: float, cornerSize: float) {.header: juce_graphics, importcpp: "#.fillRoundedRectangle(@)".}
proc fillRoundedRectangle*(this: Graphics, rectangle: Rectangle[cfloat], cornerSize: float) {.header: juce_graphics, importcpp: "#.fillRoundedRectangle(@)".}
proc fillCheckerBoard*(this: Graphics, area: Rectangle[cfloat], checkWidth: float, checkHeight: float, colour1: Colour, colour2: Colour) {.header: juce_graphics, importcpp: "#.fillCheckerBoard(@)".}
proc drawRect*(this: Graphics, x: int, y: int, width: int, height: int, lineThickness: int = 1) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc drawRect*(this: Graphics, x: float, y: float, width: float, height: float, lineThickness: float = 1.0f) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc drawRect*(this: Graphics, rectangle: Rectangle[cint], lineThickness: int = 1) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc drawRect*(this: Graphics, rectangle: Rectangle[cfloat], lineThickness: float = 1.0f) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc drawRoundedRectangle*(this: Graphics, x: float, y: float, width: float, height: float, cornerSize: float, lineThickness: float) {.header: juce_graphics, importcpp: "#.drawRoundedRectangle(@)".}
proc drawRoundedRectangle*(this: Graphics, rectangle: Rectangle[cfloat], cornerSize: float, lineThickness: float) {.header: juce_graphics, importcpp: "#.drawRoundedRectangle(@)".}
proc fillEllipse*(this: Graphics, x: float, y: float, width: float, height: float) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
proc fillEllipse*(this: Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
proc drawEllipse*(this: Graphics, x: float, y: float, width: float, height: float, lineThickness: float) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc drawEllipse*(this: Graphics, area: Rectangle[cfloat], lineThickness: float) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc drawLine*(this: Graphics, startX: float, startY: float, endX: float, endY: float) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLine*(this: Graphics, startX: float, startY: float, endX: float, endY: float, lineThickness: float) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLine*(this: Graphics, line: Line[cfloat]) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLine*(this: Graphics, line: Line[cfloat], lineThickness: float) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawDashedLine*(this: Graphics, line: Line[cfloat], dashLengths: ptr float, numDashLengths: int, lineThickness: float = 1.0f, dashIndexToStartFrom: int = 0) {.header: juce_graphics, importcpp: "#.drawDashedLine(@)".}
proc drawVerticalLine*(this: Graphics, x: int, top: float, bottom: float) {.header: juce_graphics, importcpp: "#.drawVerticalLine(@)".}
proc drawHorizontalLine*(this: Graphics, y: int, left: float, right: float) {.header: juce_graphics, importcpp: "#.drawHorizontalLine(@)".}
proc fillPath*(this: Graphics, path: Path) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc fillPath*(this: Graphics, path: Path, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc strokePath*(this: Graphics, path: Path, strokeType: PathStrokeType, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.strokePath(@)".}
proc drawArrow*(this: Graphics, line: Line[cfloat], lineThickness: float, arrowheadWidth: float, arrowheadLength: float) {.header: juce_graphics, importcpp: "#.drawArrow(@)".}
proc setImageResamplingQuality*(this: var Graphics, newQuality: GraphicsResamplingQuality) {.header: juce_graphics, importcpp: "#.setImageResamplingQuality(@)".}
proc drawImageAt*(this: Graphics, imageToDraw: Image, topLeftX: int, topLeftY: int, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImageAt(@)".}
proc drawImage*(this: Graphics, imageToDraw: Image, destX: int, destY: int, destWidth: int, destHeight: int, sourceX: int, sourceY: int, sourceWidth: int, sourceHeight: int, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawImageTransformed*(this: Graphics, imageToDraw: Image, transform: AffineTransform, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImageTransformed(@)".}
proc drawImage*(this: Graphics, imageToDraw: Image, targetArea: Rectangle[cfloat], placementWithinTarget: RectanglePlacement, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawImageWithin*(this: Graphics, imageToDraw: Image, destX: int, destY: int, destWidth: int, destHeight: int, placementWithinTarget: RectanglePlacement, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImageWithin(@)".}
proc getClipBounds*(this: Graphics): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getClipBounds()".}
proc clipRegionIntersects*(this: Graphics, area: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipRegionIntersects(@)".}
proc reduceClipRegion*(this: var Graphics, x: int, y: int, width: int, height: int): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, area: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, clipRegion: RectangleList[cint]): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, path: Path, transform: AffineTransform): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, image: Image, transform: AffineTransform): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc excludeClipRegion*(this: var Graphics, rectangleToExclude: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeClipRegion(@)".}
proc isClipEmpty*(this: Graphics): bool {.header: juce_graphics, importcpp: "#.isClipEmpty()".}
proc saveState*(this: var Graphics) {.header: juce_graphics, importcpp: "#.saveState()".}
proc restoreState*(this: var Graphics) {.header: juce_graphics, importcpp: "#.restoreState()".}
proc beginTransparencyLayer*(this: var Graphics, layerOpacity: float) {.header: juce_graphics, importcpp: "#.beginTransparencyLayer(@)".}
proc endTransparencyLayer*(this: var Graphics) {.header: juce_graphics, importcpp: "#.endTransparencyLayer()".}
proc setOrigin*(this: var Graphics, newOrigin: Point[cint]) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc setOrigin*(this: var Graphics, newOriginX: int, newOriginY: int) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc addTransform*(this: var Graphics, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.addTransform(@)".}
proc resetToDefaultState*(this: var Graphics) {.header: juce_graphics, importcpp: "#.resetToDefaultState()".}
proc isVectorDevice*(this: Graphics): bool {.header: juce_graphics, importcpp: "#.isVectorDevice()".}
proc getInternalContext*(this: Graphics): var LowLevelGraphicsContext {.header: juce_graphics, importcpp: "#.getInternalContext()".}

proc makeImage*(): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc makeImage*(format: ImagePixelFormat, imageWidth: int, imageHeight: int, clearImage: bool): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc makeImage*(format: ImagePixelFormat, imageWidth: int, imageHeight: int, clearImage: bool, `type`: ImageType): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc makeImage*(arg1: ReferenceCountedObjectPtr[ImagePixelData]): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc `Image=`*(this: var Image, arg1: Image): var Image {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Image=`*(this: var Image, arg1: lent Image): var Image {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Image==`*(this: Image, other: Image): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `Image!=`*(this: Image, other: Image): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc isValid*(this: Image): bool {.header: juce_graphics, importcpp: "#.isValid()".}
proc isNull*(this: Image): bool {.header: juce_graphics, importcpp: "#.isNull()".}
proc getWidth*(this: Image): int {.header: juce_graphics, importcpp: "#.getWidth()".}
proc getHeight*(this: Image): int {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getBounds*(this: Image): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getFormat*(this: Image): ImagePixelFormat {.header: juce_graphics, importcpp: "#.getFormat()".}
proc isARGB*(this: Image): bool {.header: juce_graphics, importcpp: "#.isARGB()".}
proc isRGB*(this: Image): bool {.header: juce_graphics, importcpp: "#.isRGB()".}
proc isSingleChannel*(this: Image): bool {.header: juce_graphics, importcpp: "#.isSingleChannel()".}
proc hasAlphaChannel*(this: Image): bool {.header: juce_graphics, importcpp: "#.hasAlphaChannel()".}
proc clear*(this: var Image, area: Rectangle[cint], colourToClearTo: Colour) {.header: juce_graphics, importcpp: "#.clear(@)".}
# proc rescaled*(this: Image, newWidth: int, newHeight: int, quality: Graphics::ResamplingQuality): Image {.header: juce_graphics, importcpp: "#.rescaled(@)".}
proc createCopy*(this: Image): Image {.header: juce_graphics, importcpp: "#.createCopy()".}
proc convertedToFormat*(this: Image, newFormat: ImagePixelFormat): Image {.header: juce_graphics, importcpp: "#.convertedToFormat(@)".}
proc duplicateIfShared*(this: var Image) {.header: juce_graphics, importcpp: "#.duplicateIfShared()".}
proc getClippedImage*(this: Image, area: Rectangle[cint]): Image {.header: juce_graphics, importcpp: "#.getClippedImage(@)".}
proc getPixelAt*(this: Image, x: int, y: int): Colour {.header: juce_graphics, importcpp: "#.getPixelAt(@)".}
proc setPixelAt*(this: var Image, x: int, y: int, colour: Colour) {.header: juce_graphics, importcpp: "#.setPixelAt(@)".}
proc multiplyAlphaAt*(this: var Image, x: int, y: int, multiplier: float) {.header: juce_graphics, importcpp: "#.multiplyAlphaAt(@)".}
proc multiplyAllAlphas*(this: var Image, amountToMultiplyBy: float) {.header: juce_graphics, importcpp: "#.multiplyAllAlphas(@)".}
proc desaturate*(this: var Image) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc setBackupEnabled*(this: var Image, arg1: bool): bool {.header: juce_graphics, importcpp: "#.setBackupEnabled(@)".}
proc moveImageSection*(this: var Image, destX: int, destY: int, sourceX: int, sourceY: int, width: int, height: int) {.header: juce_graphics, importcpp: "#.moveImageSection(@)".}
proc createSolidAreaMask*(this: Image, result: RectangleList[cint], alphaThreshold: float) {.header: juce_graphics, importcpp: "#.createSolidAreaMask(@)".}
proc getProperties*(this: Image): ptr NamedValueSet {.header: juce_graphics, importcpp: "#.getProperties()".}
proc createLowLevelContext*(this: Image): UniquePtr[LowLevelGraphicsContext] {.header: juce_graphics, importcpp: "#.createLowLevelContext()".}
proc getReferenceCount*(this: Image): int {.header: juce_graphics, importcpp: "#.getReferenceCount()".}
proc getPixelData*(this: Image): ReferenceCountedObjectPtr[ImagePixelData] {.header: juce_graphics, importcpp: "#.getPixelData()".}

proc setBackupEnabled*(this: var ImagePixelDataBackupExtensions, arg1: bool) {.header: juce_graphics, importcpp: "#.setBackupEnabled(@)".}
proc isBackupEnabled*(this: ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.isBackupEnabled()".}
proc backupNow*(this: var ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.backupNow()".}
proc needsBackup*(this: ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.needsBackup()".}
proc canBackup*(this: ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.canBackup()".}

# proc makeImagePixelData*(arg1: Image::PixelFormat, width: int, height: int): ImagePixelData {.header: juce_graphics, importcpp: "juce::ImagePixelData(@)".}
proc createLowLevelContext*(this: var ImagePixelData): UniquePtr[LowLevelGraphicsContext] {.header: juce_graphics, importcpp: "#.createLowLevelContext()".}
# proc clone*(this: var ImagePixelData): Ptr {.header: juce_graphics, importcpp: "#.clone()".}
proc createType*(this: ImagePixelData): UniquePtr[ImageType] {.header: juce_graphics, importcpp: "#.createType()".}
# proc getBackupExtensions*(this: var ImagePixelData): ptr BackupExtensions {.header: juce_graphics, importcpp: "#.getBackupExtensions()".}
# proc getBackupExtensions*(this: ImagePixelData): ptr BackupExtensions {.header: juce_graphics, importcpp: "#.getBackupExtensions()".}
# proc initialiseBitmapData*(this: var ImagePixelData, arg1: var Image::BitmapData, x: int, y: int, arg4: Image::BitmapData::ReadWriteMode) {.header: juce_graphics, importcpp: "#.initialiseBitmapData(@)".}
proc getSharedCount*(this: ImagePixelData): int {.header: juce_graphics, importcpp: "#.getSharedCount()".}
proc moveImageSection*(this: var ImagePixelData, destTopLeft: Point[cint], sourceRect: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.moveImageSection(@)".}
proc applyGaussianBlurEffectInArea*(this: var ImagePixelData, bounds: Rectangle[cint], radius: float) {.header: juce_graphics, importcpp: "#.applyGaussianBlurEffectInArea(@)".}
proc applyGaussianBlurEffect*(this: var ImagePixelData, radius: float) {.header: juce_graphics, importcpp: "#.applyGaussianBlurEffect(@)".}
proc applySingleChannelBoxBlurEffectInArea*(this: var ImagePixelData, bounds: Rectangle[cint], radius: int) {.header: juce_graphics, importcpp: "#.applySingleChannelBoxBlurEffectInArea(@)".}
proc applySingleChannelBoxBlurEffect*(this: var ImagePixelData, radius: int) {.header: juce_graphics, importcpp: "#.applySingleChannelBoxBlurEffect(@)".}
proc multiplyAllAlphasInArea*(this: var ImagePixelData, bounds: Rectangle[cint], amount: float) {.header: juce_graphics, importcpp: "#.multiplyAllAlphasInArea(@)".}
proc multiplyAllAlphas*(this: var ImagePixelData, amount: float) {.header: juce_graphics, importcpp: "#.multiplyAllAlphas(@)".}
proc desaturateInArea*(this: var ImagePixelData, bounds: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.desaturateInArea(@)".}
proc desaturate*(this: var ImagePixelData) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc sendDataChangeMessage*(this: var ImagePixelData) {.header: juce_graphics, importcpp: "#.sendDataChangeMessage()".}
# proc getNativeExtensions*(this: var ImagePixelData): NativeExtensions {.header: juce_graphics, importcpp: "#.getNativeExtensions()".}

proc makeImageType*(): ImageType {.header: juce_graphics, importcpp: "juce::ImageType(@)".}
# proc create*(this: ImageType, arg1: Image::PixelFormat, width: int, height: int, shouldClearImage: bool): ImagePixelData::Ptr {.header: juce_graphics, importcpp: "#.create(@)".}
proc getTypeID*(this: ImageType): int {.header: juce_graphics, importcpp: "#.getTypeID()".}
proc convert*(this: ImageType, source: Image): Image {.header: juce_graphics, importcpp: "#.convert(@)".}

proc makeSoftwareImageType*(): SoftwareImageType {.header: juce_graphics, importcpp: "juce::SoftwareImageType(@)".}
# proc create*(this: SoftwareImageType, arg1: Image::PixelFormat, width: int, height: int, clearImage: bool): ImagePixelData::Ptr {.header: juce_graphics, importcpp: "#.create(@)".}
proc getTypeID*(this: SoftwareImageType): int {.header: juce_graphics, importcpp: "#.getTypeID()".}

proc makeNativeImageType*(): NativeImageType {.header: juce_graphics, importcpp: "juce::NativeImageType(@)".}
# proc create*(this: NativeImageType, arg1: Image::PixelFormat, width: int, height: int, clearImage: bool): ImagePixelData::Ptr {.header: juce_graphics, importcpp: "#.create(@)".}
proc getTypeID*(this: NativeImageType): int {.header: juce_graphics, importcpp: "#.getTypeID()".}

proc makeFillType*(): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(colour: Colour): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(gradient: ColourGradient): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(gradient: lent ColourGradient): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(image: Image, transform: AffineTransform): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc `FillType=`*(this: var FillType, arg1: FillType): var FillType {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `FillType=`*(this: var FillType, arg1: lent FillType): var FillType {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc isColour*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isColour()".}
proc isGradient*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isGradient()".}
proc isTiledImage*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isTiledImage()".}
proc setColour*(this: var FillType, newColour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setGradient*(this: var FillType, newGradient: ColourGradient) {.header: juce_graphics, importcpp: "#.setGradient(@)".}
proc setTiledImage*(this: var FillType, image: Image, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.setTiledImage(@)".}
proc setOpacity*(this: var FillType, newOpacity: float) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
proc getOpacity*(this: FillType): float {.header: juce_graphics, importcpp: "#.getOpacity()".}
proc isInvisible*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isInvisible()".}
proc transformed*(this: FillType, transform: AffineTransform): FillType {.header: juce_graphics, importcpp: "#.transformed(@)".}
proc `FillType==`*(this: FillType, arg1: FillType): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `FillType!=`*(this: FillType, arg1: FillType): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}

# proc makeFontFeatureTag*(string: char ()[5]): FontFeatureTag {.header: juce_graphics, importcpp: "juce::FontFeatureTag(@)".}
proc makeFontFeatureTag*(tagValue: uint32): FontFeatureTag {.header: juce_graphics, importcpp: "juce::FontFeatureTag(@)".}
proc toString*(this: FontFeatureTag): String {.header: juce_graphics, importcpp: "#.toString()".}
proc getTag*(this: FontFeatureTag): uint32 {.header: juce_graphics, importcpp: "#.getTag()".}
proc `FontFeatureTag<`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `FontFeatureTag<=`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
proc `FontFeatureTag>`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}
proc `FontFeatureTag>=`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}
proc `FontFeatureTag==`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `FontFeatureTag!=`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}

proc makeFontFeatureSetting*(featureTag: FontFeatureTag, featureValue: uint32): FontFeatureSetting {.header: juce_graphics, importcpp: "juce::FontFeatureSetting(@)".}
proc `FontFeatureSetting<`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `FontFeatureSetting<=`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
proc `FontFeatureSetting>`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}
proc `FontFeatureSetting>=`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}
proc `FontFeatureSetting==`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `FontFeatureSetting!=`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}





proc getName*(this: Typeface): String {.header: juce_graphics, importcpp: "#.getName()".}
proc getStyle*(this: Typeface): String {.header: juce_graphics, importcpp: "#.getStyle()".}
proc getMetrics*(this: Typeface, arg1: TypefaceMetricsKind): TypefaceMetrics {.header: juce_graphics, importcpp: "#.getMetrics(@)".}
proc getOutlineForGlyph*(this: Typeface, glyphNumber: int, path: var Path) {.header: juce_graphics, importcpp: "#.getOutlineForGlyph(@)".}
proc getGlyphBounds*(this: Typeface, glyphNumber: int): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getGlyphBounds(@)".}
proc getLayersForGlyph*(this: Typeface, glyphNumber: int, arg2: AffineTransform): CppVector[GlyphLayer] {.header: juce_graphics, importcpp: "#.getLayersForGlyph(@)".}
proc getColourGlyphFormats*(this: Typeface): int {.header: juce_graphics, importcpp: "#.getColourGlyphFormats()".}
proc getNominalGlyphForCodepoint*(this: Typeface, arg1: uint32): CppOptional[uint32] {.header: juce_graphics, importcpp: "#.getNominalGlyphForCodepoint(@)".}
# proc createSystemFallback*(this: Typeface, text: String, language: String): Typeface::Ptr {.header: juce_graphics, importcpp: "#.createSystemFallback(@)".}
proc getSupportedFeatures*(this: Typeface): CppVector[FontFeatureTag] {.header: juce_graphics, importcpp: "#.getSupportedFeatures()".}
proc getNativeDetails*(this: Typeface): ptr TypefaceNative {.header: juce_graphics, importcpp: "#.getNativeDetails()".}

proc makeFontOptions*(): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(fontHeight: float): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(fontHeight: float, styleFlags: int): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(typefaceName: String, fontHeight: float, styleFlags: int): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(typefaceName: String, typefaceStyle: String, fontHeight: float): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
# proc makeFontOptions*(typeface: Typeface::Ptr): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc withName*(this: FontOptions, x: String): FontOptions {.header: juce_graphics, importcpp: "#.withName(@)".}
proc withStyle*(this: FontOptions, x: String): FontOptions {.header: juce_graphics, importcpp: "#.withStyle(@)".}
# proc withTypeface*(this: FontOptions, x: Typeface::Ptr): FontOptions {.header: juce_graphics, importcpp: "#.withTypeface(@)".}
proc withFallbacks*(this: FontOptions, x: CppVector[String]): FontOptions {.header: juce_graphics, importcpp: "#.withFallbacks(@)".}
proc withFallbackEnabled*(this: FontOptions, x: bool = true): FontOptions {.header: juce_graphics, importcpp: "#.withFallbackEnabled(@)".}
proc withHeight*(this: FontOptions, x: float): FontOptions {.header: juce_graphics, importcpp: "#.withHeight(@)".}
proc withPointHeight*(this: FontOptions, x: float): FontOptions {.header: juce_graphics, importcpp: "#.withPointHeight(@)".}
proc withKerningFactor*(this: FontOptions, x: float): FontOptions {.header: juce_graphics, importcpp: "#.withKerningFactor(@)".}
proc withHorizontalScale*(this: FontOptions, x: float): FontOptions {.header: juce_graphics, importcpp: "#.withHorizontalScale(@)".}
proc withUnderline*(this: FontOptions, x: bool = true): FontOptions {.header: juce_graphics, importcpp: "#.withUnderline(@)".}
proc withMetricsKind*(this: FontOptions, x: TypefaceMetricsKind): FontOptions {.header: juce_graphics, importcpp: "#.withMetricsKind(@)".}
proc withAscentOverride*(this: FontOptions, x: CppOptional[cfloat]): FontOptions {.header: juce_graphics, importcpp: "#.withAscentOverride(@)".}
proc withDescentOverride*(this: FontOptions, x: CppOptional[cfloat]): FontOptions {.header: juce_graphics, importcpp: "#.withDescentOverride(@)".}
proc withFeatureSetting*(this: FontOptions, featureSetting: FontFeatureSetting): FontOptions {.header: juce_graphics, importcpp: "#.withFeatureSetting(@)".}
proc withFeatureRemoved*(this: FontOptions, featureTag: FontFeatureTag): FontOptions {.header: juce_graphics, importcpp: "#.withFeatureRemoved(@)".}
proc withFeatureEnabled*(this: FontOptions, tag: FontFeatureTag): FontOptions {.header: juce_graphics, importcpp: "#.withFeatureEnabled(@)".}
proc withFeatureDisabled*(this: FontOptions, tag: FontFeatureTag): FontOptions {.header: juce_graphics, importcpp: "#.withFeatureDisabled(@)".}
proc getName*(this: FontOptions): String {.header: juce_graphics, importcpp: "#.getName()".}
proc getStyle*(this: FontOptions): String {.header: juce_graphics, importcpp: "#.getStyle()".}
# proc getTypeface*(this: FontOptions): Typeface::Ptr {.header: juce_graphics, importcpp: "#.getTypeface()".}
proc getFallbacks*(this: FontOptions): CppVector[String] {.header: juce_graphics, importcpp: "#.getFallbacks()".}
proc getHeight*(this: FontOptions): float {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getPointHeight*(this: FontOptions): float {.header: juce_graphics, importcpp: "#.getPointHeight()".}
proc getKerningFactor*(this: FontOptions): float {.header: juce_graphics, importcpp: "#.getKerningFactor()".}
proc getHorizontalScale*(this: FontOptions): float {.header: juce_graphics, importcpp: "#.getHorizontalScale()".}
proc getFallbackEnabled*(this: FontOptions): bool {.header: juce_graphics, importcpp: "#.getFallbackEnabled()".}
proc getUnderline*(this: FontOptions): bool {.header: juce_graphics, importcpp: "#.getUnderline()".}
proc getMetricsKind*(this: FontOptions): TypefaceMetricsKind {.header: juce_graphics, importcpp: "#.getMetricsKind()".}
# proc getAscentOverride*(this: FontOptions): optional<decay_t< float >> {.header: juce_graphics, importcpp: "#.getAscentOverride()".}
# proc getDescentOverride*(this: FontOptions): optional<decay_t< float >> {.header: juce_graphics, importcpp: "#.getDescentOverride()".}
proc getFeatureSettings*(this: FontOptions): Span[FontFeatureSetting] {.header: juce_graphics, importcpp: "#.getFeatureSettings()".}
proc `FontOptions==`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `FontOptions!=`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc `FontOptions<`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `FontOptions<=`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
proc `FontOptions>`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}
proc `FontOptions>=`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}

proc makeFont*(options: FontOptions): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(fontHeight: float, styleFlags: int): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(typefaceName: String, fontHeight: float, styleFlags: int): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(typefaceName: String, typefaceStyle: String, fontHeight: float): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
# proc makeFont*(typeface: Typeface::Ptr): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc `Font=`*(this: var Font, other: lent Font): var Font {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Font=`*(this: var Font, other: Font): var Font {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `Font==`*(this: Font, other: Font): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
proc `Font!=`*(this: Font, other: Font): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}
proc setTypefaceName*(this: var Font, faceName: String) {.header: juce_graphics, importcpp: "#.setTypefaceName(@)".}
proc getTypefaceName*(this: Font): String {.header: juce_graphics, importcpp: "#.getTypefaceName()".}
proc getTypefaceStyle*(this: Font): String {.header: juce_graphics, importcpp: "#.getTypefaceStyle()".}
proc setTypefaceStyle*(this: var Font, newStyle: String) {.header: juce_graphics, importcpp: "#.setTypefaceStyle(@)".}
proc withTypefaceStyle*(this: Font, newStyle: String): Font {.header: juce_graphics, importcpp: "#.withTypefaceStyle(@)".}
proc getAvailableStyles*(this: Font): StringArray {.header: juce_graphics, importcpp: "#.getAvailableStyles()".}
proc setPreferredFallbackFamilies*(this: var Font, fallbacks: StringArray) {.header: juce_graphics, importcpp: "#.setPreferredFallbackFamilies(@)".}
proc getPreferredFallbackFamilies*(this: Font): StringArray {.header: juce_graphics, importcpp: "#.getPreferredFallbackFamilies()".}
proc setFallbackEnabled*(this: var Font, enabled: bool) {.header: juce_graphics, importcpp: "#.setFallbackEnabled(@)".}
proc getFallbackEnabled*(this: Font): bool {.header: juce_graphics, importcpp: "#.getFallbackEnabled()".}
proc withHeight*(this: Font, height: float): Font {.header: juce_graphics, importcpp: "#.withHeight(@)".}
proc withPointHeight*(this: Font, heightInPoints: float): Font {.header: juce_graphics, importcpp: "#.withPointHeight(@)".}
proc setHeight*(this: var Font, newHeight: float) {.header: juce_graphics, importcpp: "#.setHeight(@)".}
proc setPointHeight*(this: var Font, newHeight: float) {.header: juce_graphics, importcpp: "#.setPointHeight(@)".}
proc setHeightWithoutChangingWidth*(this: var Font, newHeight: float) {.header: juce_graphics, importcpp: "#.setHeightWithoutChangingWidth(@)".}
proc getHeight*(this: Font): float {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getHeightInPoints*(this: Font): float {.header: juce_graphics, importcpp: "#.getHeightInPoints()".}
proc getAscent*(this: Font): float {.header: juce_graphics, importcpp: "#.getAscent()".}
proc getAscentInPoints*(this: Font): float {.header: juce_graphics, importcpp: "#.getAscentInPoints()".}
proc getDescent*(this: Font): float {.header: juce_graphics, importcpp: "#.getDescent()".}
proc getDescentInPoints*(this: Font): float {.header: juce_graphics, importcpp: "#.getDescentInPoints()".}
proc getStyleFlags*(this: Font): int {.header: juce_graphics, importcpp: "#.getStyleFlags()".}
proc withStyle*(this: Font, styleFlags: int): Font {.header: juce_graphics, importcpp: "#.withStyle(@)".}
proc setStyleFlags*(this: var Font, newFlags: int) {.header: juce_graphics, importcpp: "#.setStyleFlags(@)".}
proc setBold*(this: var Font, shouldBeBold: bool) {.header: juce_graphics, importcpp: "#.setBold(@)".}
proc boldened*(this: Font): Font {.header: juce_graphics, importcpp: "#.boldened()".}
proc isBold*(this: Font): bool {.header: juce_graphics, importcpp: "#.isBold()".}
proc setItalic*(this: var Font, shouldBeItalic: bool) {.header: juce_graphics, importcpp: "#.setItalic(@)".}
proc italicised*(this: Font): Font {.header: juce_graphics, importcpp: "#.italicised()".}
proc isItalic*(this: Font): bool {.header: juce_graphics, importcpp: "#.isItalic()".}
proc setUnderline*(this: var Font, shouldBeUnderlined: bool) {.header: juce_graphics, importcpp: "#.setUnderline(@)".}
proc isUnderlined*(this: Font): bool {.header: juce_graphics, importcpp: "#.isUnderlined()".}
proc getMetricsKind*(this: Font): TypefaceMetricsKind {.header: juce_graphics, importcpp: "#.getMetricsKind()".}
proc getFeatureSettings*(this: Font): Span[FontFeatureSetting] {.header: juce_graphics, importcpp: "#.getFeatureSettings()".}
proc setFeatureSetting*(this: var Font, featureSetting: FontFeatureSetting) {.header: juce_graphics, importcpp: "#.setFeatureSetting(@)".}
proc removeFeatureSetting*(this: var Font, featureToRemove: FontFeatureTag) {.header: juce_graphics, importcpp: "#.removeFeatureSetting(@)".}
proc getHorizontalScale*(this: Font): float {.header: juce_graphics, importcpp: "#.getHorizontalScale()".}
proc withHorizontalScale*(this: Font, scaleFactor: float): Font {.header: juce_graphics, importcpp: "#.withHorizontalScale(@)".}
proc setHorizontalScale*(this: var Font, scaleFactor: float) {.header: juce_graphics, importcpp: "#.setHorizontalScale(@)".}
proc getExtraKerningFactor*(this: Font): float {.header: juce_graphics, importcpp: "#.getExtraKerningFactor()".}
proc withExtraKerningFactor*(this: Font, extraKerning: float): Font {.header: juce_graphics, importcpp: "#.withExtraKerningFactor(@)".}
proc setExtraKerningFactor*(this: var Font, extraKerning: float) {.header: juce_graphics, importcpp: "#.setExtraKerningFactor(@)".}
proc getAscentOverride*(this: Font): CppOptional[cfloat] {.header: juce_graphics, importcpp: "#.getAscentOverride()".}
proc setAscentOverride*(this: var Font, arg1: CppOptional[cfloat]) {.header: juce_graphics, importcpp: "#.setAscentOverride(@)".}
proc getDescentOverride*(this: Font): CppOptional[cfloat] {.header: juce_graphics, importcpp: "#.getDescentOverride()".}
proc setDescentOverride*(this: var Font, arg1: CppOptional[cfloat]) {.header: juce_graphics, importcpp: "#.setDescentOverride(@)".}
proc setSizeAndStyle*(this: var Font, newHeight: float, newStyleFlags: int, newHorizontalScale: float, newKerningAmount: float) {.header: juce_graphics, importcpp: "#.setSizeAndStyle(@)".}
proc setSizeAndStyle*(this: var Font, newHeight: float, newStyle: String, newHorizontalScale: float, newKerningAmount: float) {.header: juce_graphics, importcpp: "#.setSizeAndStyle(@)".}
# proc getTypefacePtr*(this: Font): Typeface::Ptr {.header: juce_graphics, importcpp: "#.getTypefacePtr()".}
proc findSuitableFontForText*(this: Font, text: String, language: String): Font {.header: juce_graphics, importcpp: "#.findSuitableFontForText(@)".}
proc toString*(this: Font): String {.header: juce_graphics, importcpp: "#.toString()".}
proc getNativeDetails*(this: Font): FontNative {.header: juce_graphics, importcpp: "#.getNativeDetails()".}
proc getHeightToPointsFactor*(this: Font): float {.header: juce_graphics, importcpp: "#.getHeightToPointsFactor()".}

proc makeAttributedString*(): AttributedString {.header: juce_graphics, importcpp: "juce::AttributedString(@)".}
proc makeAttributedString*(newString: String): AttributedString {.header: juce_graphics, importcpp: "juce::AttributedString(@)".}
proc `AttributedString=`*(this: var AttributedString, arg1: AttributedString): var AttributedString {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `AttributedString=`*(this: var AttributedString, arg1: lent AttributedString): var AttributedString {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc getText*(this: AttributedString): String {.header: juce_graphics, importcpp: "#.getText()".}
proc setText*(this: var AttributedString, newText: String) {.header: juce_graphics, importcpp: "#.setText(@)".}
proc append*(this: var AttributedString, textToAppend: String) {.header: juce_graphics, importcpp: "#.append(@)".}
proc append*(this: var AttributedString, textToAppend: String, font: Font) {.header: juce_graphics, importcpp: "#.append(@)".}
proc append*(this: var AttributedString, textToAppend: String, colour: Colour) {.header: juce_graphics, importcpp: "#.append(@)".}
proc append*(this: var AttributedString, textToAppend: String, font: Font, colour: Colour) {.header: juce_graphics, importcpp: "#.append(@)".}
proc append*(this: var AttributedString, other: AttributedString) {.header: juce_graphics, importcpp: "#.append(@)".}
proc clear*(this: var AttributedString) {.header: juce_graphics, importcpp: "#.clear()".}
proc draw*(this: AttributedString, g: var Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc getJustification*(this: AttributedString): Justification {.header: juce_graphics, importcpp: "#.getJustification()".}
proc setJustification*(this: var AttributedString, newJustification: Justification) {.header: juce_graphics, importcpp: "#.setJustification(@)".}
proc getWordWrap*(this: AttributedString): AttributedStringWordWrap {.header: juce_graphics, importcpp: "#.getWordWrap()".}
proc setWordWrap*(this: var AttributedString, newWordWrap: AttributedStringWordWrap) {.header: juce_graphics, importcpp: "#.setWordWrap(@)".}
proc getReadingDirection*(this: AttributedString): AttributedStringReadingDirection {.header: juce_graphics, importcpp: "#.getReadingDirection()".}
proc setReadingDirection*(this: var AttributedString, newReadingDirection: AttributedStringReadingDirection) {.header: juce_graphics, importcpp: "#.setReadingDirection(@)".}
proc getLineSpacing*(this: AttributedString): float {.header: juce_graphics, importcpp: "#.getLineSpacing()".}
proc setLineSpacing*(this: var AttributedString, newLineSpacing: float) {.header: juce_graphics, importcpp: "#.setLineSpacing(@)".}
proc getNumAttributes*(this: AttributedString): int {.header: juce_graphics, importcpp: "#.getNumAttributes()".}
proc getAttribute*(this: AttributedString, index: int): AttributedStringAttribute {.header: juce_graphics, importcpp: "#.getAttribute(@)".}
proc setColour*(this: var AttributedString, range: Range[cint], colour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setColour*(this: var AttributedString, colour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setFont*(this: var AttributedString, range: Range[cint], font: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc setFont*(this: var AttributedString, font: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}

proc makePositionedGlyph*(): PositionedGlyph {.header: juce_graphics, importcpp: "juce::PositionedGlyph(@)".}
proc makePositionedGlyph*(font: Font, character: uint32, glyphNumber: int, anchorX: float, baselineY: float, width: float, isWhitespace: bool): PositionedGlyph {.header: juce_graphics, importcpp: "juce::PositionedGlyph(@)".}
proc getCharacter*(this: PositionedGlyph): uint32 {.header: juce_graphics, importcpp: "#.getCharacter()".}
proc isWhitespace*(this: PositionedGlyph): bool {.header: juce_graphics, importcpp: "#.isWhitespace()".}
proc getLeft*(this: PositionedGlyph): float {.header: juce_graphics, importcpp: "#.getLeft()".}
proc getRight*(this: PositionedGlyph): float {.header: juce_graphics, importcpp: "#.getRight()".}
proc getBaselineY*(this: PositionedGlyph): float {.header: juce_graphics, importcpp: "#.getBaselineY()".}
proc getTop*(this: PositionedGlyph): float {.header: juce_graphics, importcpp: "#.getTop()".}
proc getBottom*(this: PositionedGlyph): float {.header: juce_graphics, importcpp: "#.getBottom()".}
proc getBounds*(this: PositionedGlyph): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getGlyphIndex*(this: PositionedGlyph): int {.header: juce_graphics, importcpp: "#.getGlyphIndex()".}
proc moveBy*(this: var PositionedGlyph, deltaX: float, deltaY: float) {.header: juce_graphics, importcpp: "#.moveBy(@)".}
proc draw*(this: PositionedGlyph, g: var Graphics) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc draw*(this: PositionedGlyph, g: var Graphics, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc createPath*(this: PositionedGlyph, path: var Path) {.header: juce_graphics, importcpp: "#.createPath(@)".}
proc hitTest*(this: PositionedGlyph, x: float, y: float): bool {.header: juce_graphics, importcpp: "#.hitTest(@)".}

proc makeGlyphArrangement*(): GlyphArrangement {.header: juce_graphics, importcpp: "juce::GlyphArrangement(@)".}
proc `GlyphArrangement=`*(this: var GlyphArrangement, arg1: GlyphArrangement): var GlyphArrangement {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `GlyphArrangement=`*(this: var GlyphArrangement, arg1: lent GlyphArrangement): var GlyphArrangement {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc getNumGlyphs*(this: GlyphArrangement): int {.header: juce_graphics, importcpp: "#.getNumGlyphs()".}
proc getGlyph*(this: var GlyphArrangement, index: int): var PositionedGlyph {.header: juce_graphics, importcpp: "#.getGlyph(@)".}
# proc begin*(this: GlyphArrangement): ptr PositionedGlyph {.header: juce_graphics, importcpp: "#.begin()".}
# proc `end`*(this: GlyphArrangement): ptr PositionedGlyph {.header: juce_graphics, importcpp: "#.end()".}
proc clear*(this: var GlyphArrangement) {.header: juce_graphics, importcpp: "#.clear()".}
proc addLineOfText*(this: var GlyphArrangement, font: Font, text: String, x: float, y: float) {.header: juce_graphics, importcpp: "#.addLineOfText(@)".}
proc addCurtailedLineOfText*(this: var GlyphArrangement, font: Font, text: String, x: float, y: float, maxWidthPixels: float, useEllipsis: bool) {.header: juce_graphics, importcpp: "#.addCurtailedLineOfText(@)".}
proc addJustifiedText*(this: var GlyphArrangement, font: Font, text: String, x: float, y: float, maxLineWidth: float, horizontalLayout: Justification, leading: float = 0.0f) {.header: juce_graphics, importcpp: "#.addJustifiedText(@)".}
proc addFittedText*(this: var GlyphArrangement, font: Font, text: String, x: float, y: float, width: float, height: float, layout: Justification, maximumLinesToUse: int, minimumHorizontalScale: float = 0.0f, options: GlyphArrangementOptions) {.header: juce_graphics, importcpp: "#.addFittedText(@)".}
proc addGlyphArrangement*(this: var GlyphArrangement, arg1: GlyphArrangement) {.header: juce_graphics, importcpp: "#.addGlyphArrangement(@)".}
proc addGlyph*(this: var GlyphArrangement, arg1: PositionedGlyph) {.header: juce_graphics, importcpp: "#.addGlyph(@)".}
proc draw*(this: GlyphArrangement, arg1: Graphics) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc draw*(this: GlyphArrangement, arg1: Graphics, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc createPath*(this: GlyphArrangement, path: var Path) {.header: juce_graphics, importcpp: "#.createPath(@)".}
proc findGlyphIndexAt*(this: GlyphArrangement, x: float, y: float): int {.header: juce_graphics, importcpp: "#.findGlyphIndexAt(@)".}
proc getBoundingBox*(this: GlyphArrangement, startIndex: int, numGlyphs: int, includeWhitespace: bool): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBoundingBox(@)".}
proc moveRangeOfGlyphs*(this: var GlyphArrangement, startIndex: int, numGlyphs: int, deltaX: float, deltaY: float) {.header: juce_graphics, importcpp: "#.moveRangeOfGlyphs(@)".}
proc removeRangeOfGlyphs*(this: var GlyphArrangement, startIndex: int, numGlyphs: int) {.header: juce_graphics, importcpp: "#.removeRangeOfGlyphs(@)".}
proc stretchRangeOfGlyphs*(this: var GlyphArrangement, startIndex: int, numGlyphs: int, horizontalScaleFactor: float) {.header: juce_graphics, importcpp: "#.stretchRangeOfGlyphs(@)".}
proc justifyGlyphs*(this: var GlyphArrangement, startIndex: int, numGlyphs: int, x: float, y: float, width: float, height: float, justification: Justification) {.header: juce_graphics, importcpp: "#.justifyGlyphs(@)".}

proc makeTextLayout*(): TextLayout {.header: juce_graphics, importcpp: "juce::TextLayout(@)".}
proc `TextLayout=`*(this: var TextLayout, arg1: TextLayout): var TextLayout {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `TextLayout=`*(this: var TextLayout, arg1: lent TextLayout): var TextLayout {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc createLayout*(this: var TextLayout, arg1: AttributedString, maxWidth: float) {.header: juce_graphics, importcpp: "#.createLayout(@)".}
proc createLayout*(this: var TextLayout, arg1: AttributedString, maxWidth: float, maxHeight: float) {.header: juce_graphics, importcpp: "#.createLayout(@)".}
proc createLayoutWithBalancedLineLengths*(this: var TextLayout, arg1: AttributedString, maxWidth: float) {.header: juce_graphics, importcpp: "#.createLayoutWithBalancedLineLengths(@)".}
proc createLayoutWithBalancedLineLengths*(this: var TextLayout, arg1: AttributedString, maxWidth: float, maxHeight: float) {.header: juce_graphics, importcpp: "#.createLayoutWithBalancedLineLengths(@)".}
proc draw*(this: TextLayout, arg1: var Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc getWidth*(this: TextLayout): float {.header: juce_graphics, importcpp: "#.getWidth()".}
proc getHeight*(this: TextLayout): float {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getNumLines*(this: TextLayout): int {.header: juce_graphics, importcpp: "#.getNumLines()".}
proc getLine*(this: TextLayout, index: int): var TextLayoutLine {.header: juce_graphics, importcpp: "#.getLine(@)".}
proc addLine*(this: var TextLayout, arg1: UniquePtr[TextLayoutLine]) {.header: juce_graphics, importcpp: "#.addLine(@)".}
proc ensureStorageAllocated*(this: var TextLayout, numLinesNeeded: int) {.header: juce_graphics, importcpp: "#.ensureStorageAllocated(@)".}
# proc begin*(this: var TextLayout): iterator {.header: juce_graphics, importcpp: "#.begin()".}
# proc begin*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.begin()".}
# proc cbegin*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.cbegin()".}
# proc `end`*(this: var TextLayout): iterator {.header: juce_graphics, importcpp: "#.end()".}
# proc `end`*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.end()".}
# proc cend*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.cend()".}
proc recalculateSize*(this: var TextLayout) {.header: juce_graphics, importcpp: "#.recalculateSize()".}

proc isVectorDevice*(this: LowLevelGraphicsContext): bool {.header: juce_graphics, importcpp: "#.isVectorDevice()".}
proc setOrigin*(this: var LowLevelGraphicsContext, arg1: Point[cint]) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc addTransform*(this: var LowLevelGraphicsContext, arg1: AffineTransform) {.header: juce_graphics, importcpp: "#.addTransform(@)".}
proc getPhysicalPixelScaleFactor*(this: LowLevelGraphicsContext): float {.header: juce_graphics, importcpp: "#.getPhysicalPixelScaleFactor()".}
proc clipToRectangle*(this: var LowLevelGraphicsContext, arg1: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipToRectangle(@)".}
proc clipToRectangleList*(this: var LowLevelGraphicsContext, arg1: RectangleList[cint]): bool {.header: juce_graphics, importcpp: "#.clipToRectangleList(@)".}
proc excludeClipRectangle*(this: var LowLevelGraphicsContext, arg1: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeClipRectangle(@)".}
proc clipToPath*(this: var LowLevelGraphicsContext, arg1: Path, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.clipToPath(@)".}
proc clipToImageAlpha*(this: var LowLevelGraphicsContext, arg1: Image, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.clipToImageAlpha(@)".}
proc clipRegionIntersects*(this: var LowLevelGraphicsContext, arg1: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipRegionIntersects(@)".}
proc getClipBounds*(this: LowLevelGraphicsContext): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getClipBounds()".}
proc isClipEmpty*(this: LowLevelGraphicsContext): bool {.header: juce_graphics, importcpp: "#.isClipEmpty()".}
proc saveState*(this: var LowLevelGraphicsContext) {.header: juce_graphics, importcpp: "#.saveState()".}
proc restoreState*(this: var LowLevelGraphicsContext) {.header: juce_graphics, importcpp: "#.restoreState()".}
proc beginTransparencyLayer*(this: var LowLevelGraphicsContext, opacity: float) {.header: juce_graphics, importcpp: "#.beginTransparencyLayer(@)".}
proc endTransparencyLayer*(this: var LowLevelGraphicsContext) {.header: juce_graphics, importcpp: "#.endTransparencyLayer()".}
proc setFill*(this: var LowLevelGraphicsContext, arg1: FillType) {.header: juce_graphics, importcpp: "#.setFill(@)".}
proc setOpacity*(this: var LowLevelGraphicsContext, arg1: float) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
# proc setInterpolationQuality*(this: var LowLevelGraphicsContext, arg1: Graphics::ResamplingQuality) {.header: juce_graphics, importcpp: "#.setInterpolationQuality(@)".}
proc fillAll*(this: var LowLevelGraphicsContext) {.header: juce_graphics, importcpp: "#.fillAll()".}
proc fillRect*(this: var LowLevelGraphicsContext, arg1: Rectangle[cint], replaceExistingContents: bool) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: var LowLevelGraphicsContext, arg1: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRectList*(this: var LowLevelGraphicsContext, arg1: RectangleList[cfloat]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillPath*(this: var LowLevelGraphicsContext, arg1: Path, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc drawRect*(this: var LowLevelGraphicsContext, rect: Rectangle[cfloat], lineThickness: float) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc strokePath*(this: var LowLevelGraphicsContext, path: Path, strokeType: PathStrokeType, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.strokePath(@)".}
proc drawImage*(this: var LowLevelGraphicsContext, arg1: Image, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawLine*(this: var LowLevelGraphicsContext, arg1: Line[cfloat]) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLineWithThickness*(this: var LowLevelGraphicsContext, line: Line[cfloat], lineThickness: float) {.header: juce_graphics, importcpp: "#.drawLineWithThickness(@)".}
proc setFont*(this: var LowLevelGraphicsContext, arg1: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc getFont*(this: var LowLevelGraphicsContext): Font {.header: juce_graphics, importcpp: "#.getFont()".}
proc drawGlyphs*(this: var LowLevelGraphicsContext, arg1: Span[uint16], arg2: Span[Point[cfloat]], arg3: AffineTransform) {.header: juce_graphics, importcpp: "#.drawGlyphs(@)".}
proc getPreferredImageTypeForTemporaryImages*(this: LowLevelGraphicsContext): UniquePtr[ImageType] {.header: juce_graphics, importcpp: "#.getPreferredImageTypeForTemporaryImages()".}
proc drawRoundedRectangle*(this: var LowLevelGraphicsContext, r: Rectangle[cfloat], cornerSize: float, lineThickness: float) {.header: juce_graphics, importcpp: "#.drawRoundedRectangle(@)".}
proc fillRoundedRectangle*(this: var LowLevelGraphicsContext, r: Rectangle[cfloat], cornerSize: float) {.header: juce_graphics, importcpp: "#.fillRoundedRectangle(@)".}
proc drawEllipse*(this: var LowLevelGraphicsContext, area: Rectangle[cfloat], lineThickness: float) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc fillEllipse*(this: var LowLevelGraphicsContext, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
# proc getFrameId*(this: LowLevelGraphicsContext): uint64_t {.header: juce_graphics, importcpp: "#.getFrameId()".}

proc makeScaledImage*(): ScaledImage {.header: juce_graphics, importcpp: "juce::ScaledImage(@)".}
proc makeScaledImage*(imageIn: Image): ScaledImage {.header: juce_graphics, importcpp: "juce::ScaledImage(@)".}
proc makeScaledImage*(imageIn: Image, scaleIn: float64): ScaledImage {.header: juce_graphics, importcpp: "juce::ScaledImage(@)".}
proc getImage*(this: ScaledImage): Image {.header: juce_graphics, importcpp: "#.getImage()".}
proc getScale*(this: ScaledImage): float64 {.header: juce_graphics, importcpp: "#.getScale()".}
proc getScaledBounds*(this: ScaledImage): Rectangle[cdouble] {.header: juce_graphics, importcpp: "#.getScaledBounds()".}

proc makeLowLevelGraphicsSoftwareRenderer*(imageToRenderOnto: Image): LowLevelGraphicsSoftwareRenderer {.header: juce_graphics, importcpp: "juce::LowLevelGraphicsSoftwareRenderer(@)".}
proc makeLowLevelGraphicsSoftwareRenderer*(imageToRenderOnto: Image, origin: Point[cint], initialClip: RectangleList[cint]): LowLevelGraphicsSoftwareRenderer {.header: juce_graphics, importcpp: "juce::LowLevelGraphicsSoftwareRenderer(@)".}
proc getPreferredImageTypeForTemporaryImages*(this: LowLevelGraphicsSoftwareRenderer): UniquePtr[ImageType] {.header: juce_graphics, importcpp: "#.getPreferredImageTypeForTemporaryImages()".}
proc isVectorDevice*(this: LowLevelGraphicsSoftwareRenderer): bool {.header: juce_graphics, importcpp: "#.isVectorDevice()".}
proc getClipBounds*(this: LowLevelGraphicsSoftwareRenderer): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getClipBounds()".}
proc isClipEmpty*(this: LowLevelGraphicsSoftwareRenderer): bool {.header: juce_graphics, importcpp: "#.isClipEmpty()".}
proc setOrigin*(this: var LowLevelGraphicsSoftwareRenderer, o: Point[cint]) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc addTransform*(this: var LowLevelGraphicsSoftwareRenderer, t: AffineTransform) {.header: juce_graphics, importcpp: "#.addTransform(@)".}
proc getPhysicalPixelScaleFactor*(this: LowLevelGraphicsSoftwareRenderer): float {.header: juce_graphics, importcpp: "#.getPhysicalPixelScaleFactor()".}
proc clipRegionIntersects*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipRegionIntersects(@)".}
proc clipToRectangle*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipToRectangle(@)".}
proc clipToRectangleList*(this: var LowLevelGraphicsSoftwareRenderer, r: RectangleList[cint]): bool {.header: juce_graphics, importcpp: "#.clipToRectangleList(@)".}
proc excludeClipRectangle*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeClipRectangle(@)".}
proc clipToPath*(this: var LowLevelGraphicsSoftwareRenderer, path: Path, t: AffineTransform) {.header: juce_graphics, importcpp: "#.clipToPath(@)".}
proc clipToImageAlpha*(this: var LowLevelGraphicsSoftwareRenderer, im: Image, t: AffineTransform) {.header: juce_graphics, importcpp: "#.clipToImageAlpha(@)".}
proc saveState*(this: var LowLevelGraphicsSoftwareRenderer) {.header: juce_graphics, importcpp: "#.saveState()".}
proc restoreState*(this: var LowLevelGraphicsSoftwareRenderer) {.header: juce_graphics, importcpp: "#.restoreState()".}
proc beginTransparencyLayer*(this: var LowLevelGraphicsSoftwareRenderer, opacity: float) {.header: juce_graphics, importcpp: "#.beginTransparencyLayer(@)".}
proc endTransparencyLayer*(this: var LowLevelGraphicsSoftwareRenderer) {.header: juce_graphics, importcpp: "#.endTransparencyLayer()".}
proc setFill*(this: var LowLevelGraphicsSoftwareRenderer, fillType: FillType) {.header: juce_graphics, importcpp: "#.setFill(@)".}
proc setOpacity*(this: var LowLevelGraphicsSoftwareRenderer, newOpacity: float) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
# proc setInterpolationQuality*(this: var LowLevelGraphicsSoftwareRenderer, quality: Graphics::ResamplingQuality) {.header: juce_graphics, importcpp: "#.setInterpolationQuality(@)".}
proc fillRect*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint], replace: bool) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRectList*(this: var LowLevelGraphicsSoftwareRenderer, list: RectangleList[cfloat]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillPath*(this: var LowLevelGraphicsSoftwareRenderer, path: Path, t: AffineTransform) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc drawImage*(this: var LowLevelGraphicsSoftwareRenderer, im: Image, t: AffineTransform) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawLine*(this: var LowLevelGraphicsSoftwareRenderer, line: Line[cfloat]) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc setFont*(this: var LowLevelGraphicsSoftwareRenderer, newFont: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc getFont*(this: var LowLevelGraphicsSoftwareRenderer): Font {.header: juce_graphics, importcpp: "#.getFont()".}
# proc getFrameId*(this: LowLevelGraphicsSoftwareRenderer): uint64_t {.header: juce_graphics, importcpp: "#.getFrameId()".}
proc drawGlyphs*(this: var LowLevelGraphicsSoftwareRenderer, glyphs: Span[uint16], positions: Span[Point[cfloat]], t: AffineTransform) {.header: juce_graphics, importcpp: "#.drawGlyphs(@)".}

proc applyEffect*(this: var ImageEffectFilter, sourceImage: var Image, destContext: var Graphics, scaleFactor: float, alpha: float) {.header: juce_graphics, importcpp: "#.applyEffect(@)".}

proc makeDropShadow*(): DropShadow {.header: juce_graphics, importcpp: "juce::DropShadow(@)".}
proc makeDropShadow*(shadowColour: Colour, radius: int, offset: Point[cint]): DropShadow {.header: juce_graphics, importcpp: "juce::DropShadow(@)".}
proc drawForImage*(this: DropShadow, g: var Graphics, srcImage: Image) {.header: juce_graphics, importcpp: "#.drawForImage(@)".}
proc drawForPath*(this: DropShadow, g: var Graphics, path: Path) {.header: juce_graphics, importcpp: "#.drawForPath(@)".}
proc drawForRectangle*(this: DropShadow, g: var Graphics, area: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.drawForRectangle(@)".}

proc makeDropShadowEffect*(): DropShadowEffect {.header: juce_graphics, importcpp: "juce::DropShadowEffect(@)".}
proc setShadowProperties*(this: var DropShadowEffect, newShadow: DropShadow) {.header: juce_graphics, importcpp: "#.setShadowProperties(@)".}
proc applyEffect*(this: var DropShadowEffect, sourceImage: var Image, destContext: var Graphics, scaleFactor: float, alpha: float) {.header: juce_graphics, importcpp: "#.applyEffect(@)".}

proc makeGlowEffect*(): GlowEffect {.header: juce_graphics, importcpp: "juce::GlowEffect(@)".}
proc setGlowProperties*(this: var GlowEffect, newRadius: float, newColour: Colour, offset: Point[cint]) {.header: juce_graphics, importcpp: "#.setGlowProperties(@)".}
proc applyEffect*(this: var GlowEffect, arg1: var Image, arg2: var Graphics, scaleFactor: float, alpha: float) {.header: juce_graphics, importcpp: "#.applyEffect(@)".}




include juce_graphics_lifting


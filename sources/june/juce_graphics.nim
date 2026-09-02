# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

import june_common

const juce_graphics = "<juce_graphics/juce_graphics.h>"

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
  ImageBitmapDataBitmapDataReleaser* {.header: juce_graphics, importcpp: "juce::Image::BitmapData::BitmapDataReleaser", inheritable, pure.} = object
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
  PathIteratorPathElementType* {.header: juce_graphics, importcpp: "juce::Path::Iterator::PathElementType".} = distinct cint
  PathStrokeTypeJointStyle* {.header: juce_graphics, importcpp: "juce::PathStrokeType::JointStyle".} = distinct cint
  PathStrokeTypeEndCapStyle* {.header: juce_graphics, importcpp: "juce::PathStrokeType::EndCapStyle".} = distinct cint
  RectanglePlacementFlags* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::Flags".} = distinct cint
  GraphicsResamplingQuality* {.header: juce_graphics, importcpp: "juce::Graphics::ResamplingQuality".} = distinct cint
  ImagePixelFormat* {.header: juce_graphics, importcpp: "juce::Image::PixelFormat".} = distinct cint
  ImageBitmapDataReadWriteMode* {.header: juce_graphics, importcpp: "juce::Image::BitmapData::ReadWriteMode".} = distinct cint
  TypefaceColourGlyphFormat* {.header: juce_graphics, importcpp: "juce::Typeface::ColourGlyphFormat".} = distinct cint
  FontFontStyleFlags* {.header: juce_graphics, importcpp: "juce::Font::FontStyleFlags".} = distinct cint
  AttributedStringWordWrap* {.header: juce_graphics, importcpp: "juce::AttributedString::WordWrap".} = distinct cint
  AttributedStringReadingDirection* {.header: juce_graphics, importcpp: "juce::AttributedString::ReadingDirection".} = distinct cint

# Comparison for the enums above, taken from their base type.
proc `==`*(a: TypefaceMetricsKind, b: TypefaceMetricsKind): bool {.borrow.}
proc `==`*(a: JustificationFlags, b: JustificationFlags): bool {.borrow.}
proc `==`*(a: PathIteratorPathElementType, b: PathIteratorPathElementType): bool {.borrow.}
proc `==`*(a: PathStrokeTypeJointStyle, b: PathStrokeTypeJointStyle): bool {.borrow.}
proc `==`*(a: PathStrokeTypeEndCapStyle, b: PathStrokeTypeEndCapStyle): bool {.borrow.}
proc `==`*(a: RectanglePlacementFlags, b: RectanglePlacementFlags): bool {.borrow.}
proc `==`*(a: GraphicsResamplingQuality, b: GraphicsResamplingQuality): bool {.borrow.}
proc `==`*(a: ImagePixelFormat, b: ImagePixelFormat): bool {.borrow.}
proc `==`*(a: ImageBitmapDataReadWriteMode, b: ImageBitmapDataReadWriteMode): bool {.borrow.}
proc `==`*(a: TypefaceColourGlyphFormat, b: TypefaceColourGlyphFormat): bool {.borrow.}
proc `==`*(a: FontFontStyleFlags, b: FontFontStyleFlags): bool {.borrow.}
proc `==`*(a: AttributedStringWordWrap, b: AttributedStringWordWrap): bool {.borrow.}
proc `==`*(a: AttributedStringReadingDirection, b: AttributedStringReadingDirection): bool {.borrow.}

# Bitwise operators for the flag sets among them.
proc `or`*(a: JustificationFlags, b: JustificationFlags): JustificationFlags {.borrow.}
proc `and`*(a: JustificationFlags, b: JustificationFlags): JustificationFlags {.borrow.}
proc `or`*(a: RectanglePlacementFlags, b: RectanglePlacementFlags): RectanglePlacementFlags {.borrow.}
proc `and`*(a: RectanglePlacementFlags, b: RectanglePlacementFlags): RectanglePlacementFlags {.borrow.}
proc `or`*(a: FontFontStyleFlags, b: FontFontStyleFlags): FontFontStyleFlags {.borrow.}
proc `and`*(a: FontFontStyleFlags, b: FontFontStyleFlags): FontFontStyleFlags {.borrow.}

let TypefaceMetricsKind_legacy* {.header: juce_graphics, importcpp: "juce::TypefaceMetricsKind::legacy".}: TypefaceMetricsKind
let TypefaceMetricsKind_portable* {.header: juce_graphics, importcpp: "juce::TypefaceMetricsKind::portable".}: TypefaceMetricsKind

let JustificationFlags_left* {.header: juce_graphics, importcpp: "juce::Justification::left".}: JustificationFlags
let JustificationFlags_right* {.header: juce_graphics, importcpp: "juce::Justification::right".}: JustificationFlags
let JustificationFlags_horizontallyCentred* {.header: juce_graphics, importcpp: "juce::Justification::horizontallyCentred".}: JustificationFlags
let JustificationFlags_top* {.header: juce_graphics, importcpp: "juce::Justification::top".}: JustificationFlags
let JustificationFlags_bottom* {.header: juce_graphics, importcpp: "juce::Justification::bottom".}: JustificationFlags
let JustificationFlags_verticallyCentred* {.header: juce_graphics, importcpp: "juce::Justification::verticallyCentred".}: JustificationFlags
let JustificationFlags_horizontallyJustified* {.header: juce_graphics, importcpp: "juce::Justification::horizontallyJustified".}: JustificationFlags
let JustificationFlags_centred* {.header: juce_graphics, importcpp: "juce::Justification::centred".}: JustificationFlags
let JustificationFlags_centredLeft* {.header: juce_graphics, importcpp: "juce::Justification::centredLeft".}: JustificationFlags
let JustificationFlags_centredRight* {.header: juce_graphics, importcpp: "juce::Justification::centredRight".}: JustificationFlags
let JustificationFlags_centredTop* {.header: juce_graphics, importcpp: "juce::Justification::centredTop".}: JustificationFlags
let JustificationFlags_centredBottom* {.header: juce_graphics, importcpp: "juce::Justification::centredBottom".}: JustificationFlags
let JustificationFlags_topLeft* {.header: juce_graphics, importcpp: "juce::Justification::topLeft".}: JustificationFlags
let JustificationFlags_topRight* {.header: juce_graphics, importcpp: "juce::Justification::topRight".}: JustificationFlags
let JustificationFlags_bottomLeft* {.header: juce_graphics, importcpp: "juce::Justification::bottomLeft".}: JustificationFlags
let JustificationFlags_bottomRight* {.header: juce_graphics, importcpp: "juce::Justification::bottomRight".}: JustificationFlags

let PathIteratorPathElementType_startNewSubPath* {.header: juce_graphics, importcpp: "juce::Path::Iterator::startNewSubPath".}: PathIteratorPathElementType
let PathIteratorPathElementType_lineTo* {.header: juce_graphics, importcpp: "juce::Path::Iterator::lineTo".}: PathIteratorPathElementType
let PathIteratorPathElementType_quadraticTo* {.header: juce_graphics, importcpp: "juce::Path::Iterator::quadraticTo".}: PathIteratorPathElementType
let PathIteratorPathElementType_cubicTo* {.header: juce_graphics, importcpp: "juce::Path::Iterator::cubicTo".}: PathIteratorPathElementType
let PathIteratorPathElementType_closePath* {.header: juce_graphics, importcpp: "juce::Path::Iterator::closePath".}: PathIteratorPathElementType

let PathStrokeTypeJointStyle_mitered* {.header: juce_graphics, importcpp: "juce::PathStrokeType::mitered".}: PathStrokeTypeJointStyle
let PathStrokeTypeJointStyle_curved* {.header: juce_graphics, importcpp: "juce::PathStrokeType::curved".}: PathStrokeTypeJointStyle
let PathStrokeTypeJointStyle_beveled* {.header: juce_graphics, importcpp: "juce::PathStrokeType::beveled".}: PathStrokeTypeJointStyle

let PathStrokeTypeEndCapStyle_butt* {.header: juce_graphics, importcpp: "juce::PathStrokeType::butt".}: PathStrokeTypeEndCapStyle
let PathStrokeTypeEndCapStyle_square* {.header: juce_graphics, importcpp: "juce::PathStrokeType::square".}: PathStrokeTypeEndCapStyle
let PathStrokeTypeEndCapStyle_rounded* {.header: juce_graphics, importcpp: "juce::PathStrokeType::rounded".}: PathStrokeTypeEndCapStyle

let RectanglePlacementFlags_xLeft* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::xLeft".}: RectanglePlacementFlags
let RectanglePlacementFlags_xRight* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::xRight".}: RectanglePlacementFlags
let RectanglePlacementFlags_xMid* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::xMid".}: RectanglePlacementFlags
let RectanglePlacementFlags_yTop* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::yTop".}: RectanglePlacementFlags
let RectanglePlacementFlags_yBottom* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::yBottom".}: RectanglePlacementFlags
let RectanglePlacementFlags_yMid* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::yMid".}: RectanglePlacementFlags
let RectanglePlacementFlags_stretchToFit* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::stretchToFit".}: RectanglePlacementFlags
let RectanglePlacementFlags_fillDestination* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::fillDestination".}: RectanglePlacementFlags
let RectanglePlacementFlags_onlyReduceInSize* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::onlyReduceInSize".}: RectanglePlacementFlags
let RectanglePlacementFlags_onlyIncreaseInSize* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::onlyIncreaseInSize".}: RectanglePlacementFlags
let RectanglePlacementFlags_doNotResize* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::doNotResize".}: RectanglePlacementFlags
let RectanglePlacementFlags_centred* {.header: juce_graphics, importcpp: "juce::RectanglePlacement::centred".}: RectanglePlacementFlags

let GraphicsResamplingQuality_lowResamplingQuality* {.header: juce_graphics, importcpp: "juce::Graphics::lowResamplingQuality".}: GraphicsResamplingQuality
let GraphicsResamplingQuality_mediumResamplingQuality* {.header: juce_graphics, importcpp: "juce::Graphics::mediumResamplingQuality".}: GraphicsResamplingQuality
let GraphicsResamplingQuality_highResamplingQuality* {.header: juce_graphics, importcpp: "juce::Graphics::highResamplingQuality".}: GraphicsResamplingQuality

let ImagePixelFormat_UnknownFormat* {.header: juce_graphics, importcpp: "juce::Image::UnknownFormat".}: ImagePixelFormat
let ImagePixelFormat_RGB* {.header: juce_graphics, importcpp: "juce::Image::RGB".}: ImagePixelFormat
let ImagePixelFormat_ARGB* {.header: juce_graphics, importcpp: "juce::Image::ARGB".}: ImagePixelFormat
let ImagePixelFormat_SingleChannel* {.header: juce_graphics, importcpp: "juce::Image::SingleChannel".}: ImagePixelFormat

let ImageBitmapDataReadWriteMode_readOnly* {.header: juce_graphics, importcpp: "juce::Image::BitmapData::readOnly".}: ImageBitmapDataReadWriteMode
let ImageBitmapDataReadWriteMode_writeOnly* {.header: juce_graphics, importcpp: "juce::Image::BitmapData::writeOnly".}: ImageBitmapDataReadWriteMode
let ImageBitmapDataReadWriteMode_readWrite* {.header: juce_graphics, importcpp: "juce::Image::BitmapData::readWrite".}: ImageBitmapDataReadWriteMode

let TypefaceColourGlyphFormat_colourGlyphFormatBitmap* {.header: juce_graphics, importcpp: "juce::Typeface::colourGlyphFormatBitmap".}: TypefaceColourGlyphFormat
let TypefaceColourGlyphFormat_colourGlyphFormatSvg* {.header: juce_graphics, importcpp: "juce::Typeface::colourGlyphFormatSvg".}: TypefaceColourGlyphFormat
let TypefaceColourGlyphFormat_colourGlyphFormatCOLRv0* {.header: juce_graphics, importcpp: "juce::Typeface::colourGlyphFormatCOLRv0".}: TypefaceColourGlyphFormat
let TypefaceColourGlyphFormat_colourGlyphFormatCOLRv1* {.header: juce_graphics, importcpp: "juce::Typeface::colourGlyphFormatCOLRv1".}: TypefaceColourGlyphFormat

let FontFontStyleFlags_plain* {.header: juce_graphics, importcpp: "juce::Font::plain".}: FontFontStyleFlags
let FontFontStyleFlags_bold* {.header: juce_graphics, importcpp: "juce::Font::bold".}: FontFontStyleFlags
let FontFontStyleFlags_italic* {.header: juce_graphics, importcpp: "juce::Font::italic".}: FontFontStyleFlags
let FontFontStyleFlags_underlined* {.header: juce_graphics, importcpp: "juce::Font::underlined".}: FontFontStyleFlags

let AttributedStringWordWrap_none* {.header: juce_graphics, importcpp: "juce::AttributedString::none".}: AttributedStringWordWrap
let AttributedStringWordWrap_byWord* {.header: juce_graphics, importcpp: "juce::AttributedString::byWord".}: AttributedStringWordWrap
let AttributedStringWordWrap_byChar* {.header: juce_graphics, importcpp: "juce::AttributedString::byChar".}: AttributedStringWordWrap

let AttributedStringReadingDirection_natural* {.header: juce_graphics, importcpp: "juce::AttributedString::natural".}: AttributedStringReadingDirection
let AttributedStringReadingDirection_leftToRight* {.header: juce_graphics, importcpp: "juce::AttributedString::leftToRight".}: AttributedStringReadingDirection
let AttributedStringReadingDirection_rightToLeft* {.header: juce_graphics, importcpp: "juce::AttributedString::rightToLeft".}: AttributedStringReadingDirection

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
proc makeAffineTransform*(mat00: cfloat, mat01: cfloat, mat02: cfloat, mat10: cfloat, mat11: cfloat, mat12: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform(@)".}
proc identity*(this: typedesc[AffineTransform]): AffineTransform {.header: juce_graphics, importcpp: "(juce::AffineTransform::identity)".}
proc mat00*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.mat00".}
proc mat00*(this: var AffineTransform): var cfloat {.header: juce_graphics, importcpp: "#.mat00".}
proc `mat00=`*(this: var AffineTransform, value: cfloat) {.header: juce_graphics, importcpp: "#.mat00 = #".}
proc mat01*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.mat01".}
proc mat01*(this: var AffineTransform): var cfloat {.header: juce_graphics, importcpp: "#.mat01".}
proc `mat01=`*(this: var AffineTransform, value: cfloat) {.header: juce_graphics, importcpp: "#.mat01 = #".}
proc mat02*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.mat02".}
proc mat02*(this: var AffineTransform): var cfloat {.header: juce_graphics, importcpp: "#.mat02".}
proc `mat02=`*(this: var AffineTransform, value: cfloat) {.header: juce_graphics, importcpp: "#.mat02 = #".}
proc mat10*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.mat10".}
proc mat10*(this: var AffineTransform): var cfloat {.header: juce_graphics, importcpp: "#.mat10".}
proc `mat10=`*(this: var AffineTransform, value: cfloat) {.header: juce_graphics, importcpp: "#.mat10 = #".}
proc mat11*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.mat11".}
proc mat11*(this: var AffineTransform): var cfloat {.header: juce_graphics, importcpp: "#.mat11".}
proc `mat11=`*(this: var AffineTransform, value: cfloat) {.header: juce_graphics, importcpp: "#.mat11 = #".}
proc mat12*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.mat12".}
proc mat12*(this: var AffineTransform): var cfloat {.header: juce_graphics, importcpp: "#.mat12".}
proc `mat12=`*(this: var AffineTransform, value: cfloat) {.header: juce_graphics, importcpp: "#.mat12 = #".}
proc `AffineTransform=`*(this: var AffineTransform, arg1: AffineTransform): var AffineTransform {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: AffineTransform, other: AffineTransform): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: AffineTransform, other: AffineTransform): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc translated*(this: AffineTransform, deltaX: cfloat, deltaY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.translated(@)".}
proc translation*(this: typedesc[AffineTransform], deltaX: cfloat, deltaY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::translation(@)".}
proc withAbsoluteTranslation*(this: AffineTransform, translationX: cfloat, translationY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.withAbsoluteTranslation(@)".}
proc rotated*(this: AffineTransform, angleInRadians: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.rotated(@)".}
proc rotated*(this: AffineTransform, angleInRadians: cfloat, pivotX: cfloat, pivotY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.rotated(@)".}
proc rotation*(this: typedesc[AffineTransform], angleInRadians: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::rotation(@)".}
proc rotation*(this: typedesc[AffineTransform], angleInRadians: cfloat, pivotX: cfloat, pivotY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::rotation(@)".}
proc scaled*(this: AffineTransform, factorX: cfloat, factorY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.scaled(@)".}
proc scaled*(this: AffineTransform, factor: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.scaled(@)".}
proc scaled*(this: AffineTransform, factorX: cfloat, factorY: cfloat, pivotX: cfloat, pivotY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.scaled(@)".}
proc scale*(this: typedesc[AffineTransform], factorX: cfloat, factorY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::scale(@)".}
proc scale*(this: typedesc[AffineTransform], factor: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::scale(@)".}
proc scale*(this: typedesc[AffineTransform], factorX: cfloat, factorY: cfloat, pivotX: cfloat, pivotY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::scale(@)".}
proc sheared*(this: AffineTransform, shearX: cfloat, shearY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "#.sheared(@)".}
proc shear*(this: typedesc[AffineTransform], shearX: cfloat, shearY: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::shear(@)".}
proc verticalFlip*(this: typedesc[AffineTransform], height: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::verticalFlip(@)".}
proc horizontalFlip*(this: typedesc[AffineTransform], width: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::horizontalFlip(@)".}
proc inverted*(this: AffineTransform): AffineTransform {.header: juce_graphics, importcpp: "#.inverted()".}
proc fromTargetPoints*(this: typedesc[AffineTransform], x00: cfloat, y00: cfloat, x10: cfloat, y10: cfloat, x01: cfloat, y01: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::fromTargetPoints(@)".}
proc fromTargetPoints*(this: typedesc[AffineTransform], sourceX1: cfloat, sourceY1: cfloat, targetX1: cfloat, targetY1: cfloat, sourceX2: cfloat, sourceY2: cfloat, targetX2: cfloat, targetY2: cfloat, sourceX3: cfloat, sourceY3: cfloat, targetX3: cfloat, targetY3: cfloat): AffineTransform {.header: juce_graphics, importcpp: "juce::AffineTransform::fromTargetPoints(@)".}
proc followedBy*(this: AffineTransform, other: AffineTransform): AffineTransform {.header: juce_graphics, importcpp: "#.followedBy(@)".}
proc isIdentity*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isIdentity()".}
proc isSingularity*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isSingularity()".}
proc isOnlyTranslation*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isOnlyTranslation()".}
proc isOnlyTranslationOrScale*(this: AffineTransform): bool {.header: juce_graphics, importcpp: "#.isOnlyTranslationOrScale()".}
proc getTranslationX*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.getTranslationX()".}
proc getTranslationY*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.getTranslationY()".}
proc getDeterminant*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.getDeterminant()".}
proc getScaleFactor*(this: AffineTransform): cfloat {.header: juce_graphics, importcpp: "#.getScaleFactor()".}

proc makeJustification*(justificationFlags: cint): Justification {.header: juce_graphics, importcpp: "juce::Justification(@)".}
proc `Justification=`*(this: var Justification, arg1: Justification): var Justification {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: Justification, other: Justification): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Justification, other: Justification): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc getFlags*(this: Justification): cint {.header: juce_graphics, importcpp: "#.getFlags()".}
proc testFlags*(this: Justification, flagsToTest: cint): bool {.header: juce_graphics, importcpp: "#.testFlags(@)".}
proc getOnlyVerticalFlags*(this: Justification): cint {.header: juce_graphics, importcpp: "#.getOnlyVerticalFlags()".}
proc getOnlyHorizontalFlags*(this: Justification): cint {.header: juce_graphics, importcpp: "#.getOnlyHorizontalFlags()".}

proc makePath*(): Path {.header: juce_graphics, importcpp: "juce::Path(@)".}
proc defaultToleranceForTesting*(this: typedesc[Path]): cfloat {.header: juce_graphics, importcpp: "(juce::Path::defaultToleranceForTesting)".}
proc defaultToleranceForMeasurement*(this: typedesc[Path]): cfloat {.header: juce_graphics, importcpp: "(juce::Path::defaultToleranceForMeasurement)".}
proc `Path=`*(this: var Path, arg1: Path): var Path {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: Path, arg1: Path): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Path, arg1: Path): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc isEmpty*(this: Path): bool {.header: juce_graphics, importcpp: "#.isEmpty()".}
proc getBounds*(this: Path): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getBoundsTransformed*(this: Path, transform: AffineTransform): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBoundsTransformed(@)".}
proc contains*(this: Path, x: cfloat, y: cfloat, tolerance: cfloat): bool {.header: juce_graphics, importcpp: "#.contains(@)".}
proc contains*(this: Path, point: Point[cfloat], tolerance: cfloat): bool {.header: juce_graphics, importcpp: "#.contains(@)".}
proc intersectsLine*(this: Path, line: Line[cfloat], tolerance: cfloat): bool {.header: juce_graphics, importcpp: "#.intersectsLine(@)".}
proc getClippedLine*(this: Path, line: Line[cfloat], keepSectionOutsidePath: bool): Line[cfloat] {.header: juce_graphics, importcpp: "#.getClippedLine(@)".}
proc getLength*(this: Path, transform: AffineTransform, tolerance: cfloat): cfloat {.header: juce_graphics, importcpp: "#.getLength(@)".}
proc getPointAlongPath*(this: Path, distanceFromStart: cfloat, transform: AffineTransform, tolerance: cfloat): Point[cfloat] {.header: juce_graphics, importcpp: "#.getPointAlongPath(@)".}
proc getNearestPoint*(this: Path, targetPoint: Point[cfloat], pointOnPath: Point[cfloat], transform: AffineTransform, tolerance: cfloat): cfloat {.header: juce_graphics, importcpp: "#.getNearestPoint(@)".}
proc clear*(this: var Path) {.header: juce_graphics, importcpp: "#.clear()".}
proc startNewSubPath*(this: var Path, startX: cfloat, startY: cfloat) {.header: juce_graphics, importcpp: "#.startNewSubPath(@)".}
proc startNewSubPath*(this: var Path, start: Point[cfloat]) {.header: juce_graphics, importcpp: "#.startNewSubPath(@)".}
proc closeSubPath*(this: var Path) {.header: juce_graphics, importcpp: "#.closeSubPath()".}
proc lineTo*(this: var Path, endX: cfloat, endY: cfloat) {.header: juce_graphics, importcpp: "#.lineTo(@)".}
proc lineTo*(this: var Path, `end`: Point[cfloat]) {.header: juce_graphics, importcpp: "#.lineTo(@)".}
proc quadraticTo*(this: var Path, controlPointX: cfloat, controlPointY: cfloat, endPointX: cfloat, endPointY: cfloat) {.header: juce_graphics, importcpp: "#.quadraticTo(@)".}
proc quadraticTo*(this: var Path, controlPoint: Point[cfloat], endPoint: Point[cfloat]) {.header: juce_graphics, importcpp: "#.quadraticTo(@)".}
proc cubicTo*(this: var Path, controlPoint1X: cfloat, controlPoint1Y: cfloat, controlPoint2X: cfloat, controlPoint2Y: cfloat, endPointX: cfloat, endPointY: cfloat) {.header: juce_graphics, importcpp: "#.cubicTo(@)".}
proc cubicTo*(this: var Path, controlPoint1: Point[cfloat], controlPoint2: Point[cfloat], endPoint: Point[cfloat]) {.header: juce_graphics, importcpp: "#.cubicTo(@)".}
proc getCurrentPosition*(this: Path): Point[cfloat] {.header: juce_graphics, importcpp: "#.getCurrentPosition()".}
proc addRectangle*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat) {.header: juce_graphics, importcpp: "#.addRectangle(@)".}
proc addRoundedRectangle*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, cornerSize: cfloat) {.header: juce_graphics, importcpp: "#.addRoundedRectangle(@)".}
proc addRoundedRectangle*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, cornerSizeX: cfloat, cornerSizeY: cfloat) {.header: juce_graphics, importcpp: "#.addRoundedRectangle(@)".}
proc addRoundedRectangle*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, cornerSizeX: cfloat, cornerSizeY: cfloat, curveTopLeft: bool, curveTopRight: bool, curveBottomLeft: bool, curveBottomRight: bool) {.header: juce_graphics, importcpp: "#.addRoundedRectangle(@)".}
proc addTriangle*(this: var Path, x1: cfloat, y1: cfloat, x2: cfloat, y2: cfloat, x3: cfloat, y3: cfloat) {.header: juce_graphics, importcpp: "#.addTriangle(@)".}
proc addTriangle*(this: var Path, point1: Point[cfloat], point2: Point[cfloat], point3: Point[cfloat]) {.header: juce_graphics, importcpp: "#.addTriangle(@)".}
proc addQuadrilateral*(this: var Path, x1: cfloat, y1: cfloat, x2: cfloat, y2: cfloat, x3: cfloat, y3: cfloat, x4: cfloat, y4: cfloat) {.header: juce_graphics, importcpp: "#.addQuadrilateral(@)".}
proc addEllipse*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat) {.header: juce_graphics, importcpp: "#.addEllipse(@)".}
proc addEllipse*(this: var Path, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.addEllipse(@)".}
proc addArc*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, fromRadians: cfloat, toRadians: cfloat, startAsNewSubPath: bool = false) {.header: juce_graphics, importcpp: "#.addArc(@)".}
proc addCentredArc*(this: var Path, centreX: cfloat, centreY: cfloat, radiusX: cfloat, radiusY: cfloat, rotationOfEllipse: cfloat, fromRadians: cfloat, toRadians: cfloat, startAsNewSubPath: bool = false) {.header: juce_graphics, importcpp: "#.addCentredArc(@)".}
proc addPieSegment*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, fromRadians: cfloat, toRadians: cfloat, innerCircleProportionalSize: cfloat) {.header: juce_graphics, importcpp: "#.addPieSegment(@)".}
proc addPieSegment*(this: var Path, segmentBounds: Rectangle[cfloat], fromRadians: cfloat, toRadians: cfloat, innerCircleProportionalSize: cfloat) {.header: juce_graphics, importcpp: "#.addPieSegment(@)".}
proc addLineSegment*(this: var Path, line: Line[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.addLineSegment(@)".}
proc addArrow*(this: var Path, line: Line[cfloat], lineThickness: cfloat, arrowheadWidth: cfloat, arrowheadLength: cfloat) {.header: juce_graphics, importcpp: "#.addArrow(@)".}
proc addPolygon*(this: var Path, centre: Point[cfloat], numberOfSides: cint, radius: cfloat, startAngle: cfloat = 0.0f) {.header: juce_graphics, importcpp: "#.addPolygon(@)".}
proc addStar*(this: var Path, centre: Point[cfloat], numberOfPoints: cint, innerRadius: cfloat, outerRadius: cfloat, startAngle: cfloat = 0.0f) {.header: juce_graphics, importcpp: "#.addStar(@)".}
proc addBubble*(this: var Path, bodyArea: Rectangle[cfloat], maximumArea: Rectangle[cfloat], arrowTipPosition: Point[cfloat], cornerSize: cfloat, arrowBaseWidth: cfloat) {.header: juce_graphics, importcpp: "#.addBubble(@)".}
proc addPath*(this: var Path, pathToAppend: Path) {.header: juce_graphics, importcpp: "#.addPath(@)".}
proc addPath*(this: var Path, pathToAppend: Path, transformToApply: AffineTransform) {.header: juce_graphics, importcpp: "#.addPath(@)".}
proc swapWithPath*(this: var Path, arg1: var Path) {.header: juce_graphics, importcpp: "#.swapWithPath(@)".}
proc preallocateSpace*(this: var Path, numExtraCoordsToMakeSpaceFor: cint) {.header: juce_graphics, importcpp: "#.preallocateSpace(@)".}
proc applyTransform*(this: var Path, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.applyTransform(@)".}
proc scaleToFit*(this: var Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, preserveProportions: bool) {.header: juce_graphics, importcpp: "#.scaleToFit(@)".}
proc getTransformToScaleToFit*(this: Path, x: cfloat, y: cfloat, width: cfloat, height: cfloat, preserveProportions: bool, justificationType: Justification): AffineTransform {.header: juce_graphics, importcpp: "#.getTransformToScaleToFit(@)".}
proc getTransformToScaleToFit*(this: Path, area: Rectangle[cfloat], preserveProportions: bool, justificationType: Justification): AffineTransform {.header: juce_graphics, importcpp: "#.getTransformToScaleToFit(@)".}
proc createPathWithRoundedCorners*(this: Path, cornerRadius: cfloat): Path {.header: juce_graphics, importcpp: "#.createPathWithRoundedCorners(@)".}
proc setUsingNonZeroWinding*(this: var Path, isNonZeroWinding: bool) {.header: juce_graphics, importcpp: "#.setUsingNonZeroWinding(@)".}
proc isUsingNonZeroWinding*(this: Path): bool {.header: juce_graphics, importcpp: "#.isUsingNonZeroWinding()".}
proc loadPathFromStream*(this: var Path, source: var InputStream) {.header: juce_graphics, importcpp: "#.loadPathFromStream(@)".}
proc loadPathFromData*(this: var Path, data: constPointer, numberOfBytes: uint64) {.header: juce_graphics, importcpp: "#.loadPathFromData(@)".}
proc writePathToStream*(this: Path, destination: var OutputStream) {.header: juce_graphics, importcpp: "#.writePathToStream(@)".}
proc toString*(this: Path): String {.header: juce_graphics, importcpp: "#.toString()".}
proc restoreFromString*(this: var Path, stringVersion: StringRef) {.header: juce_graphics, importcpp: "#.restoreFromString(@)".}

proc makePathIterator*(path: Path): PathIterator {.header: juce_graphics, importcpp: "juce::Path::Iterator(@)".}
proc elementType*(this: PathIterator): PathIteratorPathElementType {.header: juce_graphics, importcpp: "#.elementType".}
proc elementType*(this: var PathIterator): var PathIteratorPathElementType {.header: juce_graphics, importcpp: "#.elementType".}
proc `elementType=`*(this: var PathIterator, value: PathIteratorPathElementType) {.header: juce_graphics, importcpp: "#.elementType = #".}
proc x1*(this: PathIterator): cfloat {.header: juce_graphics, importcpp: "#.x1".}
proc x1*(this: var PathIterator): var cfloat {.header: juce_graphics, importcpp: "#.x1".}
proc `x1=`*(this: var PathIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.x1 = #".}
proc y1*(this: PathIterator): cfloat {.header: juce_graphics, importcpp: "#.y1".}
proc y1*(this: var PathIterator): var cfloat {.header: juce_graphics, importcpp: "#.y1".}
proc `y1=`*(this: var PathIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.y1 = #".}
proc x2*(this: PathIterator): cfloat {.header: juce_graphics, importcpp: "#.x2".}
proc x2*(this: var PathIterator): var cfloat {.header: juce_graphics, importcpp: "#.x2".}
proc `x2=`*(this: var PathIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.x2 = #".}
proc y2*(this: PathIterator): cfloat {.header: juce_graphics, importcpp: "#.y2".}
proc y2*(this: var PathIterator): var cfloat {.header: juce_graphics, importcpp: "#.y2".}
proc `y2=`*(this: var PathIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.y2 = #".}
proc x3*(this: PathIterator): cfloat {.header: juce_graphics, importcpp: "#.x3".}
proc x3*(this: var PathIterator): var cfloat {.header: juce_graphics, importcpp: "#.x3".}
proc `x3=`*(this: var PathIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.x3 = #".}
proc y3*(this: PathIterator): cfloat {.header: juce_graphics, importcpp: "#.y3".}
proc y3*(this: var PathIterator): var cfloat {.header: juce_graphics, importcpp: "#.y3".}
proc `y3=`*(this: var PathIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.y3 = #".}
proc next*(this: var PathIterator): bool {.header: juce_graphics, importcpp: "#.next()".}
proc `==`*(this: PathIterator, other: PathIterator): bool {.error: "juce::Path::Iterator defines no operator==; compare a property instead".}

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
proc multiplyAlpha*(this: var PixelARGB, multiplier: cint) {.header: juce_graphics, importcpp: "#.multiplyAlpha((int) #)".}
proc multiplyAlpha*(this: var PixelARGB, multiplier: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAlpha((float) #)".}
proc getUnpremultiplied*(this: PixelARGB): PixelARGB {.header: juce_graphics, importcpp: "#.getUnpremultiplied()".}
proc premultiply*(this: var PixelARGB) {.header: juce_graphics, importcpp: "#.premultiply()".}
proc unpremultiply*(this: var PixelARGB) {.header: juce_graphics, importcpp: "#.unpremultiply()".}
proc desaturate*(this: var PixelARGB) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc `==`*(this: PixelARGB, other: PixelARGB): bool {.error: "juce::PixelARGB defines no operator==; compare a property instead".}

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
proc multiplyAlpha*(this: var PixelRGB, arg1: cint) {.header: juce_graphics, importcpp: "#.multiplyAlpha((int) #)".}
proc multiplyAlpha*(this: var PixelRGB, arg1: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAlpha((float) #)".}
proc premultiply*(this: var PixelRGB) {.header: juce_graphics, importcpp: "#.premultiply()".}
proc unpremultiply*(this: var PixelRGB) {.header: juce_graphics, importcpp: "#.unpremultiply()".}
proc desaturate*(this: var PixelRGB) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc `==`*(this: PixelRGB, other: PixelRGB): bool {.error: "juce::PixelRGB defines no operator==; compare a property instead".}

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
proc multiplyAlpha*(this: var PixelAlpha, multiplier: cint) {.header: juce_graphics, importcpp: "#.multiplyAlpha((int) #)".}
proc multiplyAlpha*(this: var PixelAlpha, multiplier: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAlpha((float) #)".}
proc premultiply*(this: var PixelAlpha) {.header: juce_graphics, importcpp: "#.premultiply()".}
proc unpremultiply*(this: var PixelAlpha) {.header: juce_graphics, importcpp: "#.unpremultiply()".}
proc desaturate*(this: var PixelAlpha) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc `==`*(this: PixelAlpha, other: PixelAlpha): bool {.error: "juce::PixelAlpha defines no operator==; compare a property instead".}

proc makeColour*(): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(argb: uint32): Colour {.header: juce_graphics, importcpp: "juce::Colour((unsigned int) @)".}
proc makeColour*(red: uint8, green: uint8, blue: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(red: uint8, green: uint8, blue: uint8, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(red: uint8, green: uint8, blue: uint8, alpha: cfloat): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(hue: cfloat, saturation: cfloat, brightness: cfloat, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(hue: cfloat, saturation: cfloat, brightness: cfloat, alpha: cfloat): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)".}
proc makeColour*(argb: PixelARGB): Colour {.header: juce_graphics, importcpp: "juce::Colour((juce::PixelARGB) @)".}
proc makeColour*(rgb: PixelRGB): Colour {.header: juce_graphics, importcpp: "juce::Colour((juce::PixelRGB) @)".}
proc makeColour*(alpha: PixelAlpha): Colour {.header: juce_graphics, importcpp: "juce::Colour((juce::PixelAlpha) @)".}
proc fromRGB*(this: typedesc[Colour], red: uint8, green: uint8, blue: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromRGB(@)".}
proc fromRGBA*(this: typedesc[Colour], red: uint8, green: uint8, blue: uint8, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromRGBA(@)".}
proc fromFloatRGBA*(this: typedesc[Colour], red: cfloat, green: cfloat, blue: cfloat, alpha: cfloat): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromFloatRGBA(@)".}
proc fromHSV*(this: typedesc[Colour], hue: cfloat, saturation: cfloat, brightness: cfloat, alpha: cfloat): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromHSV(@)".}
proc fromHSV*(this: typedesc[Colour], hue: cfloat, saturation: cfloat, brightness: cfloat, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromHSV(@)".}
proc fromHSL*(this: typedesc[Colour], hue: cfloat, saturation: cfloat, lightness: cfloat, alpha: cfloat): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromHSL(@)".}
proc fromHSL*(this: typedesc[Colour], hue: cfloat, saturation: cfloat, lightness: cfloat, alpha: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromHSL(@)".}
proc `Colour=`*(this: var Colour, arg1: Colour): var Colour {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: Colour, other: Colour): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Colour, other: Colour): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc getRed*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getRed()".}
proc getGreen*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getGreen()".}
proc getBlue*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getBlue()".}
proc getFloatRed*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getFloatRed()".}
proc getFloatGreen*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getFloatGreen()".}
proc getFloatBlue*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getFloatBlue()".}
proc getPixelARGB*(this: Colour): PixelARGB {.header: juce_graphics, importcpp: "#.getPixelARGB()".}
proc getNonPremultipliedPixelARGB*(this: Colour): PixelARGB {.header: juce_graphics, importcpp: "#.getNonPremultipliedPixelARGB()".}
proc getARGB*(this: Colour): uint32 {.header: juce_graphics, importcpp: "#.getARGB()".}
proc getAlpha*(this: Colour): uint8 {.header: juce_graphics, importcpp: "#.getAlpha()".}
proc getFloatAlpha*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getFloatAlpha()".}
proc isOpaque*(this: Colour): bool {.header: juce_graphics, importcpp: "#.isOpaque()".}
proc isTransparent*(this: Colour): bool {.header: juce_graphics, importcpp: "#.isTransparent()".}
proc withAlpha*(this: Colour, newAlpha: uint8): Colour {.header: juce_graphics, importcpp: "#.withAlpha((unsigned char) #)".}
proc withAlpha*(this: Colour, newAlpha: cfloat): Colour {.header: juce_graphics, importcpp: "#.withAlpha((float) #)".}
proc withMultipliedAlpha*(this: Colour, alphaMultiplier: cfloat): Colour {.header: juce_graphics, importcpp: "#.withMultipliedAlpha(@)".}
proc overlaidWith*(this: Colour, foregroundColour: Colour): Colour {.header: juce_graphics, importcpp: "#.overlaidWith(@)".}
proc interpolatedWith*(this: Colour, other: Colour, proportionOfOther: cfloat): Colour {.header: juce_graphics, importcpp: "#.interpolatedWith(@)".}
proc getHue*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getHue()".}
proc getSaturation*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getSaturation()".}
proc getSaturationHSL*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getSaturationHSL()".}
proc getBrightness*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getBrightness()".}
proc getLightness*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getLightness()".}
proc getPerceivedBrightness*(this: Colour): cfloat {.header: juce_graphics, importcpp: "#.getPerceivedBrightness()".}
proc getHSB*(this: Colour, hue: var cfloat, saturation: var cfloat, brightness: var cfloat) {.header: juce_graphics, importcpp: "#.getHSB(@)".}
proc getHSL*(this: Colour, hue: var cfloat, saturation: var cfloat, lightness: var cfloat) {.header: juce_graphics, importcpp: "#.getHSL(@)".}
proc withHue*(this: Colour, newHue: cfloat): Colour {.header: juce_graphics, importcpp: "#.withHue(@)".}
proc withSaturation*(this: Colour, newSaturation: cfloat): Colour {.header: juce_graphics, importcpp: "#.withSaturation(@)".}
proc withSaturationHSL*(this: Colour, newSaturation: cfloat): Colour {.header: juce_graphics, importcpp: "#.withSaturationHSL(@)".}
proc withBrightness*(this: Colour, newBrightness: cfloat): Colour {.header: juce_graphics, importcpp: "#.withBrightness(@)".}
proc withLightness*(this: Colour, newLightness: cfloat): Colour {.header: juce_graphics, importcpp: "#.withLightness(@)".}
proc withRotatedHue*(this: Colour, amountToRotate: cfloat): Colour {.header: juce_graphics, importcpp: "#.withRotatedHue(@)".}
proc withMultipliedSaturation*(this: Colour, multiplier: cfloat): Colour {.header: juce_graphics, importcpp: "#.withMultipliedSaturation(@)".}
proc withMultipliedSaturationHSL*(this: Colour, multiplier: cfloat): Colour {.header: juce_graphics, importcpp: "#.withMultipliedSaturationHSL(@)".}
proc withMultipliedBrightness*(this: Colour, amount: cfloat): Colour {.header: juce_graphics, importcpp: "#.withMultipliedBrightness(@)".}
proc withMultipliedLightness*(this: Colour, amount: cfloat): Colour {.header: juce_graphics, importcpp: "#.withMultipliedLightness(@)".}
proc brighter*(this: Colour, amountBrighter: cfloat = 0.4f): Colour {.header: juce_graphics, importcpp: "#.brighter(@)".}
proc darker*(this: Colour, amountDarker: cfloat = 0.4f): Colour {.header: juce_graphics, importcpp: "#.darker(@)".}
proc contrasting*(this: Colour, amount: cfloat = 1.0f): Colour {.header: juce_graphics, importcpp: "#.contrasting(@)".}
proc contrasting*(this: Colour, targetColour: Colour, minLuminosityDiff: cfloat): Colour {.header: juce_graphics, importcpp: "#.contrasting(@)".}
proc contrasting*(this: typedesc[Colour], colour1: Colour, colour2: Colour): Colour {.header: juce_graphics, importcpp: "juce::Colour::contrasting(@)".}
proc greyLevel*(this: typedesc[Colour], brightness: cfloat): Colour {.header: juce_graphics, importcpp: "juce::Colour::greyLevel(@)".}
proc toString*(this: Colour): String {.header: juce_graphics, importcpp: "#.toString()".}
proc fromString*(this: typedesc[Colour], encodedColourString: StringRef): Colour {.header: juce_graphics, importcpp: "juce::Colour::fromString(@)".}
proc toDisplayString*(this: Colour, includeAlphaValue: bool): String {.header: juce_graphics, importcpp: "#.toDisplayString(@)".}

proc makeColourGradient*(): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient(@)".}
proc makeColourGradient*(colour1: Colour, x1: cfloat, y1: cfloat, colour2: Colour, x2: cfloat, y2: cfloat, isRadial: bool): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient(@)".}
proc makeColourGradient*(colour1: Colour, point1: Point[cfloat], colour2: Colour, point2: Point[cfloat], isRadial: bool): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient(@)".}
proc point1*(this: ColourGradient): Point[cfloat] {.header: juce_graphics, importcpp: "#.point1".}
proc point1*(this: var ColourGradient): var Point[cfloat] {.header: juce_graphics, importcpp: "#.point1".}
proc `point1=`*(this: var ColourGradient, value: Point[cfloat]) {.header: juce_graphics, importcpp: "#.point1 = #".}
proc point2*(this: ColourGradient): Point[cfloat] {.header: juce_graphics, importcpp: "#.point2".}
proc point2*(this: var ColourGradient): var Point[cfloat] {.header: juce_graphics, importcpp: "#.point2".}
proc `point2=`*(this: var ColourGradient, value: Point[cfloat]) {.header: juce_graphics, importcpp: "#.point2 = #".}
proc isRadial*(this: ColourGradient): bool {.header: juce_graphics, importcpp: "#.isRadial".}
proc isRadial*(this: var ColourGradient): var bool {.header: juce_graphics, importcpp: "#.isRadial".}
proc `isRadial=`*(this: var ColourGradient, value: bool) {.header: juce_graphics, importcpp: "#.isRadial = #".}
proc `ColourGradient=`*(this: var ColourGradient, arg1: ColourGradient): var ColourGradient {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc vertical*(this: typedesc[ColourGradient], colour1: Colour, y1: cfloat, colour2: Colour, y2: cfloat): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient::vertical(@)".}
proc horizontal*(this: typedesc[ColourGradient], colour1: Colour, x1: cfloat, colour2: Colour, x2: cfloat): ColourGradient {.header: juce_graphics, importcpp: "juce::ColourGradient::horizontal(@)".}
proc clearColours*(this: var ColourGradient) {.header: juce_graphics, importcpp: "#.clearColours()".}
proc addColour*(this: var ColourGradient, proportionAlongGradient: float64, colour: Colour): cint {.header: juce_graphics, importcpp: "#.addColour(@)".}
proc removeColour*(this: var ColourGradient, index: cint) {.header: juce_graphics, importcpp: "#.removeColour(@)".}
proc multiplyOpacity*(this: var ColourGradient, multiplier: cfloat) {.header: juce_graphics, importcpp: "#.multiplyOpacity(@)".}
proc getNumColours*(this: ColourGradient): cint {.header: juce_graphics, importcpp: "#.getNumColours()".}
proc getColourPosition*(this: ColourGradient, index: cint): float64 {.header: juce_graphics, importcpp: "#.getColourPosition(@)".}
proc getColour*(this: ColourGradient, index: cint): Colour {.header: juce_graphics, importcpp: "#.getColour(@)".}
proc setColour*(this: var ColourGradient, index: cint, newColour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc getColourAtPosition*(this: ColourGradient, position: float64): Colour {.header: juce_graphics, importcpp: "#.getColourAtPosition(@)".}
proc createLookupTable*(this: ColourGradient, transform: AffineTransform, resultLookupTable: HeapBlock[PixelARGB]): cint {.header: juce_graphics, importcpp: "#.createLookupTable(@)".}
proc createLookupTable*(this: ColourGradient, resultLookupTable: ptr PixelARGB, numEntries: cint) {.header: juce_graphics, importcpp: "#.createLookupTable(@)".}
proc isOpaque*(this: ColourGradient): bool {.header: juce_graphics, importcpp: "#.isOpaque()".}
proc isInvisible*(this: ColourGradient): bool {.header: juce_graphics, importcpp: "#.isInvisible()".}
proc `==`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc `<`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `<=`*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
# proc operator>*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}  # Nim derives > and >= from < and <=
# proc operator>=*(this: ColourGradient, arg1: ColourGradient): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}  # Nim derives > and >= from < and <=

proc makeEdgeTable*(clipLimits: Rectangle[cint], pathToAdd: Path, transform: AffineTransform): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectangleToAdd: Rectangle[cint]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectangleToAdd: Rectangle[cfloat]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectanglesToAdd: RectangleList[cint]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc makeEdgeTable*(rectanglesToAdd: RectangleList[cfloat]): EdgeTable {.header: juce_graphics, importcpp: "juce::EdgeTable(@)".}
proc clipToRectangle*(this: var EdgeTable, r: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.clipToRectangle(@)".}
proc excludeRectangle*(this: var EdgeTable, r: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeRectangle(@)".}
proc clipToEdgeTable*(this: var EdgeTable, arg1: EdgeTable) {.header: juce_graphics, importcpp: "#.clipToEdgeTable(@)".}
proc clipLineToMask*(this: var EdgeTable, x: cint, y: cint, mask: ptr uint8, maskStride: cint, numPixels: cint) {.header: juce_graphics, importcpp: "#.clipLineToMask(@)".}
proc isEmpty*(this: var EdgeTable): bool {.header: juce_graphics, importcpp: "#.isEmpty()".}
proc getMaximumBounds*(this: EdgeTable): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getMaximumBounds()".}
proc translate*(this: var EdgeTable, dx: cfloat, dy: cint) {.header: juce_graphics, importcpp: "#.translate(@)".}
proc multiplyLevels*(this: var EdgeTable, factor: cfloat) {.header: juce_graphics, importcpp: "#.multiplyLevels(@)".}
proc optimiseTable*(this: var EdgeTable) {.header: juce_graphics, importcpp: "#.optimiseTable()".}
proc `==`*(this: EdgeTable, other: EdgeTable): bool {.error: "juce::EdgeTable defines no operator==; compare a property instead".}

proc makePathFlatteningIterator*(path: Path, transform: AffineTransform, tolerance: cfloat): PathFlatteningIterator {.header: juce_graphics, importcpp: "juce::PathFlatteningIterator(@)".}
proc x1*(this: PathFlatteningIterator): cfloat {.header: juce_graphics, importcpp: "#.x1".}
proc x1*(this: var PathFlatteningIterator): var cfloat {.header: juce_graphics, importcpp: "#.x1".}
proc `x1=`*(this: var PathFlatteningIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.x1 = #".}
proc y1*(this: PathFlatteningIterator): cfloat {.header: juce_graphics, importcpp: "#.y1".}
proc y1*(this: var PathFlatteningIterator): var cfloat {.header: juce_graphics, importcpp: "#.y1".}
proc `y1=`*(this: var PathFlatteningIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.y1 = #".}
proc x2*(this: PathFlatteningIterator): cfloat {.header: juce_graphics, importcpp: "#.x2".}
proc x2*(this: var PathFlatteningIterator): var cfloat {.header: juce_graphics, importcpp: "#.x2".}
proc `x2=`*(this: var PathFlatteningIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.x2 = #".}
proc y2*(this: PathFlatteningIterator): cfloat {.header: juce_graphics, importcpp: "#.y2".}
proc y2*(this: var PathFlatteningIterator): var cfloat {.header: juce_graphics, importcpp: "#.y2".}
proc `y2=`*(this: var PathFlatteningIterator, value: cfloat) {.header: juce_graphics, importcpp: "#.y2 = #".}
proc closesSubPath*(this: PathFlatteningIterator): bool {.header: juce_graphics, importcpp: "#.closesSubPath".}
proc closesSubPath*(this: var PathFlatteningIterator): var bool {.header: juce_graphics, importcpp: "#.closesSubPath".}
proc `closesSubPath=`*(this: var PathFlatteningIterator, value: bool) {.header: juce_graphics, importcpp: "#.closesSubPath = #".}
proc subPathIndex*(this: PathFlatteningIterator): cint {.header: juce_graphics, importcpp: "#.subPathIndex".}
proc subPathIndex*(this: var PathFlatteningIterator): var cint {.header: juce_graphics, importcpp: "#.subPathIndex".}
proc `subPathIndex=`*(this: var PathFlatteningIterator, value: cint) {.header: juce_graphics, importcpp: "#.subPathIndex = #".}
proc next*(this: var PathFlatteningIterator): bool {.header: juce_graphics, importcpp: "#.next()".}
proc isLastInSubpath*(this: PathFlatteningIterator): bool {.header: juce_graphics, importcpp: "#.isLastInSubpath()".}
proc `==`*(this: PathFlatteningIterator, other: PathFlatteningIterator): bool {.error: "juce::PathFlatteningIterator defines no operator==; compare a property instead".}

proc makePathStrokeType*(strokeThickness: cfloat): PathStrokeType {.header: juce_graphics, importcpp: "juce::PathStrokeType(@)".}
proc makePathStrokeType*(strokeThickness: cfloat, jointStyle: PathStrokeTypeJointStyle, endStyle: PathStrokeTypeEndCapStyle): PathStrokeType {.header: juce_graphics, importcpp: "juce::PathStrokeType(@)".}
proc `PathStrokeType=`*(this: var PathStrokeType, arg1: PathStrokeType): var PathStrokeType {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc createStrokedPath*(this: PathStrokeType, destPath: var Path, sourcePath: Path, transform: AffineTransform, extraAccuracy: cfloat = 1.0f) {.header: juce_graphics, importcpp: "#.createStrokedPath(@)".}
proc createDashedStroke*(this: PathStrokeType, destPath: var Path, sourcePath: Path, dashLengths: ptr cfloat, numDashLengths: cint, transform: AffineTransform, extraAccuracy: cfloat = 1.0f) {.header: juce_graphics, importcpp: "#.createDashedStroke(@)".}
proc createStrokeWithArrowheads*(this: PathStrokeType, destPath: var Path, sourcePath: Path, arrowheadStartWidth: cfloat, arrowheadStartLength: cfloat, arrowheadEndWidth: cfloat, arrowheadEndLength: cfloat, transform: AffineTransform, extraAccuracy: cfloat = 1.0f) {.header: juce_graphics, importcpp: "#.createStrokeWithArrowheads(@)".}
proc getStrokeThickness*(this: PathStrokeType): cfloat {.header: juce_graphics, importcpp: "#.getStrokeThickness()".}
proc setStrokeThickness*(this: var PathStrokeType, newThickness: cfloat) {.header: juce_graphics, importcpp: "#.setStrokeThickness(@)".}
proc getJointStyle*(this: PathStrokeType): PathStrokeTypeJointStyle {.header: juce_graphics, importcpp: "#.getJointStyle()".}
proc setJointStyle*(this: var PathStrokeType, newStyle: PathStrokeTypeJointStyle) {.header: juce_graphics, importcpp: "#.setJointStyle(@)".}
proc getEndStyle*(this: PathStrokeType): PathStrokeTypeEndCapStyle {.header: juce_graphics, importcpp: "#.getEndStyle()".}
proc setEndStyle*(this: var PathStrokeType, newStyle: PathStrokeTypeEndCapStyle) {.header: juce_graphics, importcpp: "#.setEndStyle(@)".}
proc `==`*(this: PathStrokeType, arg1: PathStrokeType): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: PathStrokeType, arg1: PathStrokeType): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==

proc makeRectanglePlacement*(placementFlags: cint): RectanglePlacement {.header: juce_graphics, importcpp: "juce::RectanglePlacement(@)".}
proc makeRectanglePlacement*(): RectanglePlacement {.header: juce_graphics, importcpp: "juce::RectanglePlacement(@)".}
proc `RectanglePlacement=`*(this: var RectanglePlacement, arg1: RectanglePlacement): var RectanglePlacement {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: RectanglePlacement, arg1: RectanglePlacement): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RectanglePlacement, arg1: RectanglePlacement): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc getFlags*(this: RectanglePlacement): cint {.header: juce_graphics, importcpp: "#.getFlags()".}
proc testFlags*(this: RectanglePlacement, flagsToTest: cint): bool {.header: juce_graphics, importcpp: "#.testFlags(@)".}
proc applyTo*(this: RectanglePlacement, sourceX: var float64, sourceY: var float64, sourceW: var float64, sourceH: var float64, destinationX: float64, destinationY: float64, destinationW: float64, destinationH: float64) {.header: juce_graphics, importcpp: "#.applyTo(@)".}
proc getTransformToFit*(this: RectanglePlacement, source: Rectangle[cfloat], destination: Rectangle[cfloat]): AffineTransform {.header: juce_graphics, importcpp: "#.getTransformToFit(@)".}

proc getFromFile*(this: typedesc[ImageCache], file: File): Image {.header: juce_graphics, importcpp: "juce::ImageCache::getFromFile(@)".}
proc getFromMemory*(this: typedesc[ImageCache], imageData: constPointer, dataSize: cint): Image {.header: juce_graphics, importcpp: "juce::ImageCache::getFromMemory(@)".}
proc getFromHashCode*(this: typedesc[ImageCache], hashCode: int64): Image {.header: juce_graphics, importcpp: "juce::ImageCache::getFromHashCode(@)".}
proc addImageToCache*(this: typedesc[ImageCache], image: Image, hashCode: int64) {.header: juce_graphics, importcpp: "juce::ImageCache::addImageToCache(@)".}
proc setCacheTimeout*(this: typedesc[ImageCache], millisecs: cint) {.header: juce_graphics, importcpp: "juce::ImageCache::setCacheTimeout(@)".}
proc releaseUnusedImages*(this: typedesc[ImageCache]) {.header: juce_graphics, importcpp: "juce::ImageCache::releaseUnusedImages()".}
proc `==`*(this: ImageCache, other: ImageCache): bool {.error: "juce::ImageCache defines no operator==; compare a property instead".}

proc makeImageConvolutionKernel*(size: cint): ImageConvolutionKernel {.header: juce_graphics, importcpp: "juce::ImageConvolutionKernel(@)".}
proc clear*(this: var ImageConvolutionKernel) {.header: juce_graphics, importcpp: "#.clear()".}
proc getKernelValue*(this: ImageConvolutionKernel, x: cint, y: cint): cfloat {.header: juce_graphics, importcpp: "#.getKernelValue(@)".}
proc setKernelValue*(this: var ImageConvolutionKernel, x: cint, y: cint, value: cfloat) {.header: juce_graphics, importcpp: "#.setKernelValue(@)".}
proc setOverallSum*(this: var ImageConvolutionKernel, desiredTotalSum: cfloat) {.header: juce_graphics, importcpp: "#.setOverallSum(@)".}
proc rescaleAllValues*(this: var ImageConvolutionKernel, multiplier: cfloat) {.header: juce_graphics, importcpp: "#.rescaleAllValues(@)".}
proc createGaussianBlur*(this: var ImageConvolutionKernel, blurRadius: cfloat) {.header: juce_graphics, importcpp: "#.createGaussianBlur(@)".}
proc getKernelSize*(this: ImageConvolutionKernel): cint {.header: juce_graphics, importcpp: "#.getKernelSize()".}
proc applyToImage*(this: ImageConvolutionKernel, destImage: var Image, sourceImage: Image, destinationArea: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.applyToImage(@)".}
proc `==`*(this: ImageConvolutionKernel, other: ImageConvolutionKernel): bool {.error: "juce::ImageConvolutionKernel defines no operator==; compare a property instead".}

proc getFormatName*(this: var ImageFileFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc canUnderstand*(this: var ImageFileFormat, input: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc usesFileExtension*(this: var ImageFileFormat, possibleFile: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc decodeImage*(this: var ImageFileFormat, input: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var ImageFileFormat, sourceImage: Image, destStream: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}
proc findImageFormatForStream*(this: typedesc[ImageFileFormat], input: var InputStream): ptr ImageFileFormat {.header: juce_graphics, importcpp: "juce::ImageFileFormat::findImageFormatForStream(@)".}
proc findImageFormatForFileExtension*(this: typedesc[ImageFileFormat], file: File): ptr ImageFileFormat {.header: juce_graphics, importcpp: "juce::ImageFileFormat::findImageFormatForFileExtension(@)".}
proc loadFrom*(this: typedesc[ImageFileFormat], input: var InputStream): Image {.header: juce_graphics, importcpp: "juce::ImageFileFormat::loadFrom(@)".}
proc loadFrom*(this: typedesc[ImageFileFormat], file: File): Image {.header: juce_graphics, importcpp: "juce::ImageFileFormat::loadFrom(@)".}
proc loadFrom*(this: typedesc[ImageFileFormat], rawData: constPointer, numBytesOfData: uint64): Image {.header: juce_graphics, importcpp: "juce::ImageFileFormat::loadFrom(@)".}
proc `==`*(this: ImageFileFormat, other: ImageFileFormat): bool {.error: "juce::ImageFileFormat defines no operator==; compare a property instead".}

proc makePNGImageFormat*(): PNGImageFormat {.header: juce_graphics, importcpp: "juce::PNGImageFormat(@)".}
proc getFormatName*(this: var PNGImageFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc usesFileExtension*(this: var PNGImageFormat, arg1: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc canUnderstand*(this: var PNGImageFormat, arg1: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc decodeImage*(this: var PNGImageFormat, arg1: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var PNGImageFormat, arg1: Image, arg2: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}
proc `==`*(this: PNGImageFormat, other: PNGImageFormat): bool {.error: "juce::PNGImageFormat defines no operator==; compare a property instead".}

proc makeJPEGImageFormat*(): JPEGImageFormat {.header: juce_graphics, importcpp: "juce::JPEGImageFormat(@)".}
proc setQuality*(this: var JPEGImageFormat, newQuality: cfloat) {.header: juce_graphics, importcpp: "#.setQuality(@)".}
proc getFormatName*(this: var JPEGImageFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc usesFileExtension*(this: var JPEGImageFormat, arg1: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc canUnderstand*(this: var JPEGImageFormat, arg1: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc decodeImage*(this: var JPEGImageFormat, arg1: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var JPEGImageFormat, arg1: Image, arg2: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}
proc `==`*(this: JPEGImageFormat, other: JPEGImageFormat): bool {.error: "juce::JPEGImageFormat defines no operator==; compare a property instead".}

proc makeGIFImageFormat*(): GIFImageFormat {.header: juce_graphics, importcpp: "juce::GIFImageFormat(@)".}
proc getFormatName*(this: var GIFImageFormat): String {.header: juce_graphics, importcpp: "#.getFormatName()".}
proc usesFileExtension*(this: var GIFImageFormat, arg1: File): bool {.header: juce_graphics, importcpp: "#.usesFileExtension(@)".}
proc canUnderstand*(this: var GIFImageFormat, arg1: var InputStream): bool {.header: juce_graphics, importcpp: "#.canUnderstand(@)".}
proc decodeImage*(this: var GIFImageFormat, arg1: var InputStream): Image {.header: juce_graphics, importcpp: "#.decodeImage(@)".}
proc writeImageToStream*(this: var GIFImageFormat, arg1: Image, arg2: var OutputStream): bool {.header: juce_graphics, importcpp: "#.writeImageToStream(@)".}
proc `==`*(this: GIFImageFormat, other: GIFImageFormat): bool {.error: "juce::GIFImageFormat defines no operator==; compare a property instead".}

proc withLineSpacing*(this: GlyphArrangementOptions, x: cfloat): GlyphArrangementOptions {.header: juce_graphics, importcpp: "#.withLineSpacing(@)".}
proc withLineHeightMultiple*(this: GlyphArrangementOptions, x: cfloat): GlyphArrangementOptions {.header: juce_graphics, importcpp: "#.withLineHeightMultiple(@)".}
proc getLineSpacing*(this: GlyphArrangementOptions): cfloat {.header: juce_graphics, importcpp: "#.getLineSpacing()".}
proc getLineHeightMultiple*(this: GlyphArrangementOptions): cfloat {.header: juce_graphics, importcpp: "#.getLineHeightMultiple()".}
proc `==`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc `<`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `<=`*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
# proc operator>*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}  # Nim derives > and >= from < and <=
# proc operator>=*(this: GlyphArrangementOptions, other: GlyphArrangementOptions): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}  # Nim derives > and >= from < and <=

proc makeGraphics*(imageToDrawOnto: Image): Graphics {.header: juce_graphics, importcpp: "juce::Graphics(@)".}
proc makeGraphics*(arg1: var LowLevelGraphicsContext): Graphics {.header: juce_graphics, importcpp: "juce::Graphics(@)".}
proc setColour*(this: var Graphics, newColour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setOpacity*(this: var Graphics, newOpacity: cfloat) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
proc setGradientFill*(this: var Graphics, gradient: ColourGradient) {.header: juce_graphics, importcpp: "#.setGradientFill(@)".}
proc setTiledImageFill*(this: var Graphics, imageToUse: Image, anchorX: cint, anchorY: cint, opacity: cfloat) {.header: juce_graphics, importcpp: "#.setTiledImageFill(@)".}
proc setFillType*(this: var Graphics, newFill: FillType) {.header: juce_graphics, importcpp: "#.setFillType(@)".}
proc setFont*(this: var Graphics, newFont: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc setFont*(this: var Graphics, newFontHeight: cfloat) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc getCurrentFont*(this: Graphics): Font {.header: juce_graphics, importcpp: "#.getCurrentFont()".}
proc drawSingleLineText*(this: Graphics, text: String, startX: cint, baselineY: cint, justification: Justification) {.header: juce_graphics, importcpp: "#.drawSingleLineText(@)".}
proc drawMultiLineText*(this: Graphics, text: String, startX: cint, baselineY: cint, maximumLineWidth: cint, justification: Justification, leading: cfloat = 0.0f) {.header: juce_graphics, importcpp: "#.drawMultiLineText(@)".}
proc drawText*(this: Graphics, text: String, x: cint, y: cint, width: cint, height: cint, justificationType: Justification, useEllipsesIfTooBig: bool = true) {.header: juce_graphics, importcpp: "#.drawText(@)".}
proc drawText*(this: Graphics, text: String, area: Rectangle[cint], justificationType: Justification, useEllipsesIfTooBig: bool = true) {.header: juce_graphics, importcpp: "#.drawText(@)".}
proc drawText*(this: Graphics, text: String, area: Rectangle[cfloat], justificationType: Justification, useEllipsesIfTooBig: bool = true) {.header: juce_graphics, importcpp: "#.drawText(@)".}
proc drawFittedText*(this: Graphics, text: String, x: cint, y: cint, width: cint, height: cint, justificationFlags: Justification, maximumNumberOfLines: cint, minimumHorizontalScale: cfloat = 0.0f, options: GlyphArrangementOptions) {.header: juce_graphics, importcpp: "#.drawFittedText(@)".}
proc drawFittedText*(this: Graphics, text: String, area: Rectangle[cint], justificationFlags: Justification, maximumNumberOfLines: cint, minimumHorizontalScale: cfloat = 0.0f, options: GlyphArrangementOptions) {.header: juce_graphics, importcpp: "#.drawFittedText(@)".}
proc fillAll*(this: Graphics) {.header: juce_graphics, importcpp: "#.fillAll()".}
proc fillAll*(this: Graphics, colourToUse: Colour) {.header: juce_graphics, importcpp: "#.fillAll(@)".}
proc fillRect*(this: Graphics, rectangle: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.fillRect((juce::Rectangle<int>) #)".}
proc fillRect*(this: Graphics, rectangle: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect((juce::Rectangle<float>) #)".}
proc fillRect*(this: Graphics, x: cint, y: cint, width: cint, height: cint) {.header: juce_graphics, importcpp: "#.fillRect((int) #, (int) #, (int) #, (int) #)".}
proc fillRect*(this: Graphics, x: cfloat, y: cfloat, width: cfloat, height: cfloat) {.header: juce_graphics, importcpp: "#.fillRect((float) #, (float) #, (float) #, (float) #)".}
proc fillRectList*(this: Graphics, rectangles: RectangleList[cfloat]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillRectList*(this: Graphics, rectangles: RectangleList[cint]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillRoundedRectangle*(this: Graphics, x: cfloat, y: cfloat, width: cfloat, height: cfloat, cornerSize: cfloat) {.header: juce_graphics, importcpp: "#.fillRoundedRectangle(@)".}
proc fillRoundedRectangle*(this: Graphics, rectangle: Rectangle[cfloat], cornerSize: cfloat) {.header: juce_graphics, importcpp: "#.fillRoundedRectangle(@)".}
proc fillCheckerBoard*(this: Graphics, area: Rectangle[cfloat], checkWidth: cfloat, checkHeight: cfloat, colour1: Colour, colour2: Colour) {.header: juce_graphics, importcpp: "#.fillCheckerBoard(@)".}
proc drawRect*(this: Graphics, x: cint, y: cint, width: cint, height: cint, lineThickness: cint = 1) {.header: juce_graphics, importcpp: "#.drawRect((int) #, (int) #, (int) #, (int) #, (int) #)".}
proc drawRect*(this: Graphics, x: cfloat, y: cfloat, width: cfloat, height: cfloat, lineThickness: cfloat = 1.0f) {.header: juce_graphics, importcpp: "#.drawRect((float) #, (float) #, (float) #, (float) #, (float) #)".}
proc drawRect*(this: Graphics, rectangle: Rectangle[cint], lineThickness: cint = 1) {.header: juce_graphics, importcpp: "#.drawRect((juce::Rectangle<int>) #, (int) #)".}
proc drawRect*(this: Graphics, rectangle: Rectangle[cfloat], lineThickness: cfloat = 1.0f) {.header: juce_graphics, importcpp: "#.drawRect((juce::Rectangle<float>) #, (float) #)".}
proc drawRoundedRectangle*(this: Graphics, x: cfloat, y: cfloat, width: cfloat, height: cfloat, cornerSize: cfloat, lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawRoundedRectangle(@)".}
proc drawRoundedRectangle*(this: Graphics, rectangle: Rectangle[cfloat], cornerSize: cfloat, lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawRoundedRectangle(@)".}
proc fillEllipse*(this: Graphics, x: cfloat, y: cfloat, width: cfloat, height: cfloat) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
proc fillEllipse*(this: Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
proc drawEllipse*(this: Graphics, x: cfloat, y: cfloat, width: cfloat, height: cfloat, lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc drawEllipse*(this: Graphics, area: Rectangle[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc drawLine*(this: Graphics, startX: cfloat, startY: cfloat, endX: cfloat, endY: cfloat) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLine*(this: Graphics, startX: cfloat, startY: cfloat, endX: cfloat, endY: cfloat, lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLine*(this: Graphics, line: Line[cfloat]) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLine*(this: Graphics, line: Line[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawDashedLine*(this: Graphics, line: Line[cfloat], dashLengths: ptr cfloat, numDashLengths: cint, lineThickness: cfloat = 1.0f, dashIndexToStartFrom: cint = 0) {.header: juce_graphics, importcpp: "#.drawDashedLine(@)".}
proc drawVerticalLine*(this: Graphics, x: cint, top: cfloat, bottom: cfloat) {.header: juce_graphics, importcpp: "#.drawVerticalLine(@)".}
proc drawHorizontalLine*(this: Graphics, y: cint, left: cfloat, right: cfloat) {.header: juce_graphics, importcpp: "#.drawHorizontalLine(@)".}
proc fillPath*(this: Graphics, path: Path) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc fillPath*(this: Graphics, path: Path, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc strokePath*(this: Graphics, path: Path, strokeType: PathStrokeType, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.strokePath(@)".}
proc drawArrow*(this: Graphics, line: Line[cfloat], lineThickness: cfloat, arrowheadWidth: cfloat, arrowheadLength: cfloat) {.header: juce_graphics, importcpp: "#.drawArrow(@)".}
proc setImageResamplingQuality*(this: var Graphics, newQuality: GraphicsResamplingQuality) {.header: juce_graphics, importcpp: "#.setImageResamplingQuality(@)".}
proc drawImageAt*(this: Graphics, imageToDraw: Image, topLeftX: cint, topLeftY: cint, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImageAt(@)".}
proc drawImage*(this: Graphics, imageToDraw: Image, destX: cint, destY: cint, destWidth: cint, destHeight: cint, sourceX: cint, sourceY: cint, sourceWidth: cint, sourceHeight: cint, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawImageTransformed*(this: Graphics, imageToDraw: Image, transform: AffineTransform, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImageTransformed(@)".}
proc drawImage*(this: Graphics, imageToDraw: Image, targetArea: Rectangle[cfloat], placementWithinTarget: RectanglePlacement, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawImageWithin*(this: Graphics, imageToDraw: Image, destX: cint, destY: cint, destWidth: cint, destHeight: cint, placementWithinTarget: RectanglePlacement, fillAlphaChannelWithCurrentBrush: bool = false) {.header: juce_graphics, importcpp: "#.drawImageWithin(@)".}
proc getClipBounds*(this: Graphics): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getClipBounds()".}
proc clipRegionIntersects*(this: Graphics, area: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipRegionIntersects(@)".}
proc reduceClipRegion*(this: var Graphics, x: cint, y: cint, width: cint, height: cint): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, area: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, clipRegion: RectangleList[cint]): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, path: Path, transform: AffineTransform): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc reduceClipRegion*(this: var Graphics, image: Image, transform: AffineTransform): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc excludeClipRegion*(this: var Graphics, rectangleToExclude: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeClipRegion(@)".}
proc isClipEmpty*(this: Graphics): bool {.header: juce_graphics, importcpp: "#.isClipEmpty()".}
proc saveState*(this: var Graphics) {.header: juce_graphics, importcpp: "#.saveState()".}
proc restoreState*(this: var Graphics) {.header: juce_graphics, importcpp: "#.restoreState()".}
proc beginTransparencyLayer*(this: var Graphics, layerOpacity: cfloat) {.header: juce_graphics, importcpp: "#.beginTransparencyLayer(@)".}
proc endTransparencyLayer*(this: var Graphics) {.header: juce_graphics, importcpp: "#.endTransparencyLayer()".}
proc setOrigin*(this: var Graphics, newOrigin: Point[cint]) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc setOrigin*(this: var Graphics, newOriginX: cint, newOriginY: cint) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc addTransform*(this: var Graphics, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.addTransform(@)".}
proc resetToDefaultState*(this: var Graphics) {.header: juce_graphics, importcpp: "#.resetToDefaultState()".}
proc isVectorDevice*(this: Graphics): bool {.header: juce_graphics, importcpp: "#.isVectorDevice()".}
proc getInternalContext*(this: Graphics): var LowLevelGraphicsContext {.header: juce_graphics, importcpp: "#.getInternalContext()".}
proc `==`*(this: Graphics, other: Graphics): bool {.error: "juce::Graphics defines no operator==; compare a property instead".}

proc makeGraphicsScopedSaveState*(arg1: var Graphics): GraphicsScopedSaveState {.header: juce_graphics, importcpp: "juce::Graphics::ScopedSaveState(@)".}
proc `==`*(this: GraphicsScopedSaveState, other: GraphicsScopedSaveState): bool {.error: "juce::Graphics::ScopedSaveState defines no operator==; compare a property instead".}

proc makeImage*(): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc makeImage*(format: ImagePixelFormat, imageWidth: cint, imageHeight: cint, clearImage: bool): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc makeImage*(format: ImagePixelFormat, imageWidth: cint, imageHeight: cint, clearImage: bool, `type`: ImageType): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc makeImage*(arg1: ReferenceCountedObjectPtr[ImagePixelData]): Image {.header: juce_graphics, importcpp: "juce::Image(@)".}
proc `Image=`*(this: var Image, arg1: Image): var Image {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: Image, other: Image): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Image, other: Image): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc isValid*(this: Image): bool {.header: juce_graphics, importcpp: "#.isValid()".}
proc isNull*(this: Image): bool {.header: juce_graphics, importcpp: "#.isNull()".}
proc getWidth*(this: Image): cint {.header: juce_graphics, importcpp: "#.getWidth()".}
proc getHeight*(this: Image): cint {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getBounds*(this: Image): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getFormat*(this: Image): ImagePixelFormat {.header: juce_graphics, importcpp: "#.getFormat()".}
proc isARGB*(this: Image): bool {.header: juce_graphics, importcpp: "#.isARGB()".}
proc isRGB*(this: Image): bool {.header: juce_graphics, importcpp: "#.isRGB()".}
proc isSingleChannel*(this: Image): bool {.header: juce_graphics, importcpp: "#.isSingleChannel()".}
proc hasAlphaChannel*(this: Image): bool {.header: juce_graphics, importcpp: "#.hasAlphaChannel()".}
proc clear*(this: var Image, area: Rectangle[cint], colourToClearTo: Colour) {.header: juce_graphics, importcpp: "#.clear(@)".}
proc rescaled*(this: Image, newWidth: cint, newHeight: cint, quality: GraphicsResamplingQuality): Image {.header: juce_graphics, importcpp: "#.rescaled(@)".}
proc createCopy*(this: Image): Image {.header: juce_graphics, importcpp: "#.createCopy()".}
proc convertedToFormat*(this: Image, newFormat: ImagePixelFormat): Image {.header: juce_graphics, importcpp: "#.convertedToFormat(@)".}
proc duplicateIfShared*(this: var Image) {.header: juce_graphics, importcpp: "#.duplicateIfShared()".}
proc getClippedImage*(this: Image, area: Rectangle[cint]): Image {.header: juce_graphics, importcpp: "#.getClippedImage(@)".}
proc getPixelAt*(this: Image, x: cint, y: cint): Colour {.header: juce_graphics, importcpp: "#.getPixelAt(@)".}
proc setPixelAt*(this: var Image, x: cint, y: cint, colour: Colour) {.header: juce_graphics, importcpp: "#.setPixelAt(@)".}
proc multiplyAlphaAt*(this: var Image, x: cint, y: cint, multiplier: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAlphaAt(@)".}
proc multiplyAllAlphas*(this: var Image, amountToMultiplyBy: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAllAlphas(@)".}
proc desaturate*(this: var Image) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc setBackupEnabled*(this: var Image, arg1: bool): bool {.header: juce_graphics, importcpp: "#.setBackupEnabled(@)".}
proc moveImageSection*(this: var Image, destX: cint, destY: cint, sourceX: cint, sourceY: cint, width: cint, height: cint) {.header: juce_graphics, importcpp: "#.moveImageSection(@)".}
proc createSolidAreaMask*(this: Image, result: RectangleList[cint], alphaThreshold: cfloat) {.header: juce_graphics, importcpp: "#.createSolidAreaMask(@)".}
proc getProperties*(this: Image): ptr NamedValueSet {.header: juce_graphics, importcpp: "#.getProperties()".}
proc createLowLevelContext*(this: Image): UniquePtr[LowLevelGraphicsContext] {.header: juce_graphics, importcpp: "#.createLowLevelContext()".}
proc getReferenceCount*(this: Image): cint {.header: juce_graphics, importcpp: "#.getReferenceCount()".}
proc getPixelData*(this: Image): ReferenceCountedObjectPtr[ImagePixelData] {.header: juce_graphics, importcpp: "#.getPixelData()".}

proc makeImageBitmapData*(image: var Image, x: cint, y: cint, w: cint, h: cint, mode: ImageBitmapDataReadWriteMode): ImageBitmapData {.header: juce_graphics, importcpp: "juce::Image::BitmapData(@)".}
proc makeImageBitmapData*(image: Image, arg2: Rectangle[cint], mode: ImageBitmapDataReadWriteMode): ImageBitmapData {.header: juce_graphics, importcpp: "juce::Image::BitmapData(@)".}
proc makeImageBitmapData*(image: Image, x: cint, y: cint, w: cint, h: cint): ImageBitmapData {.header: juce_graphics, importcpp: "juce::Image::BitmapData(@)".}
proc makeImageBitmapData*(image: Image, mode: ImageBitmapDataReadWriteMode): ImageBitmapData {.header: juce_graphics, importcpp: "juce::Image::BitmapData(@)".}
proc data*(this: ImageBitmapData): ptr uint8 {.header: juce_graphics, importcpp: "#.data".}
proc data*(this: var ImageBitmapData): var ptr uint8 {.header: juce_graphics, importcpp: "#.data".}
proc `data=`*(this: var ImageBitmapData, value: ptr uint8) {.header: juce_graphics, importcpp: "#.data = #".}
proc size*(this: ImageBitmapData): uint64 {.header: juce_graphics, importcpp: "#.size".}
proc size*(this: var ImageBitmapData): var uint64 {.header: juce_graphics, importcpp: "#.size".}
proc `size=`*(this: var ImageBitmapData, value: uint64) {.header: juce_graphics, importcpp: "#.size = #".}
proc pixelFormat*(this: ImageBitmapData): ImagePixelFormat {.header: juce_graphics, importcpp: "#.pixelFormat".}
proc pixelFormat*(this: var ImageBitmapData): var ImagePixelFormat {.header: juce_graphics, importcpp: "#.pixelFormat".}
proc `pixelFormat=`*(this: var ImageBitmapData, value: ImagePixelFormat) {.header: juce_graphics, importcpp: "#.pixelFormat = #".}
proc lineStride*(this: ImageBitmapData): cint {.header: juce_graphics, importcpp: "#.lineStride".}
proc lineStride*(this: var ImageBitmapData): var cint {.header: juce_graphics, importcpp: "#.lineStride".}
proc `lineStride=`*(this: var ImageBitmapData, value: cint) {.header: juce_graphics, importcpp: "#.lineStride = #".}
proc pixelStride*(this: ImageBitmapData): cint {.header: juce_graphics, importcpp: "#.pixelStride".}
proc pixelStride*(this: var ImageBitmapData): var cint {.header: juce_graphics, importcpp: "#.pixelStride".}
proc `pixelStride=`*(this: var ImageBitmapData, value: cint) {.header: juce_graphics, importcpp: "#.pixelStride = #".}
proc width*(this: ImageBitmapData): cint {.header: juce_graphics, importcpp: "#.width".}
proc width*(this: var ImageBitmapData): var cint {.header: juce_graphics, importcpp: "#.width".}
proc `width=`*(this: var ImageBitmapData, value: cint) {.header: juce_graphics, importcpp: "#.width = #".}
proc height*(this: ImageBitmapData): cint {.header: juce_graphics, importcpp: "#.height".}
proc height*(this: var ImageBitmapData): var cint {.header: juce_graphics, importcpp: "#.height".}
proc `height=`*(this: var ImageBitmapData, value: cint) {.header: juce_graphics, importcpp: "#.height = #".}
proc dataReleaser*(this: ImageBitmapData): UniquePtr[ImageBitmapDataBitmapDataReleaser] {.header: juce_graphics, importcpp: "#.dataReleaser".}
proc dataReleaser*(this: var ImageBitmapData): var UniquePtr[ImageBitmapDataBitmapDataReleaser] {.header: juce_graphics, importcpp: "#.dataReleaser".}
proc `dataReleaser=`*(this: var ImageBitmapData, value: UniquePtr[ImageBitmapDataBitmapDataReleaser]) {.header: juce_graphics, importcpp: "#.dataReleaser = #".}
proc getLinePointer*(this: ImageBitmapData, y: cint): ptr uint8 {.header: juce_graphics, importcpp: "#.getLinePointer(@)".}
proc getPixelPointer*(this: ImageBitmapData, x: cint, y: cint): ptr uint8 {.header: juce_graphics, importcpp: "#.getPixelPointer(@)".}
proc getPixelColour*(this: ImageBitmapData, x: cint, y: cint): Colour {.header: juce_graphics, importcpp: "#.getPixelColour(@)".}
proc setPixelColour*(this: ImageBitmapData, x: cint, y: cint, colour: Colour) {.header: juce_graphics, importcpp: "#.setPixelColour(@)".}
proc getBounds*(this: ImageBitmapData): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc convertFrom*(this: var ImageBitmapData, src: ImageBitmapData): bool {.header: juce_graphics, importcpp: "#.convertFrom(@)".}
proc `==`*(this: ImageBitmapData, other: ImageBitmapData): bool {.error: "juce::Image::BitmapData defines no operator==; compare a property instead".}

proc `==`*(this: ImageBitmapDataBitmapDataReleaser, other: ImageBitmapDataBitmapDataReleaser): bool {.error: "juce::Image::BitmapData::BitmapDataReleaser defines no operator==; compare a property instead".}

proc setBackupEnabled*(this: var ImagePixelDataBackupExtensions, arg1: bool) {.header: juce_graphics, importcpp: "#.setBackupEnabled(@)".}
proc isBackupEnabled*(this: ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.isBackupEnabled()".}
proc backupNow*(this: var ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.backupNow()".}
proc needsBackup*(this: ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.needsBackup()".}
proc canBackup*(this: ImagePixelDataBackupExtensions): bool {.header: juce_graphics, importcpp: "#.canBackup()".}
proc `==`*(this: ImagePixelDataBackupExtensions, other: ImagePixelDataBackupExtensions): bool {.error: "juce::ImagePixelDataBackupExtensions defines no operator==; compare a property instead".}

proc makeImagePixelData*(arg1: ImagePixelFormat, width: cint, height: cint): ImagePixelData {.header: juce_graphics, importcpp: "juce::ImagePixelData(@)".}
proc pixelFormat*(this: ImagePixelData): ImagePixelFormat {.header: juce_graphics, importcpp: "#.pixelFormat".}
proc width*(this: ImagePixelData): cint {.header: juce_graphics, importcpp: "#.width".}
proc height*(this: ImagePixelData): cint {.header: juce_graphics, importcpp: "#.height".}
proc userData*(this: ImagePixelData): NamedValueSet {.header: juce_graphics, importcpp: "#.userData".}
proc userData*(this: var ImagePixelData): var NamedValueSet {.header: juce_graphics, importcpp: "#.userData".}
proc `userData=`*(this: var ImagePixelData, value: NamedValueSet) {.header: juce_graphics, importcpp: "#.userData = #".}
# proc listeners*(this: ImagePixelData): ListenerList<Listener> {.header: juce_graphics, importcpp: "#.listeners".}  # a type that cannot be spelled in Nim
# proc listeners*(this: var ImagePixelData): var ListenerList<Listener> {.header: juce_graphics, importcpp: "#.listeners".}  # a type that cannot be spelled in Nim
# proc `listeners=`*(this: var ImagePixelData, value: ListenerList<Listener>) {.header: juce_graphics, importcpp: "#.listeners = #".}  # a type that cannot be spelled in Nim
proc createLowLevelContext*(this: var ImagePixelData): UniquePtr[LowLevelGraphicsContext] {.header: juce_graphics, importcpp: "#.createLowLevelContext()".}
proc clone*(this: var ImagePixelData): ReferenceCountedObjectPtr[ImagePixelData] {.header: juce_graphics, importcpp: "#.clone()".}
proc createType*(this: ImagePixelData): UniquePtr[ImageType] {.header: juce_graphics, importcpp: "#.createType()".}
proc getBackupExtensions*(this: var ImagePixelData): ptr ImagePixelDataBackupExtensions {.header: juce_graphics, importcpp: "#.getBackupExtensions()".}
proc getBackupExtensions*(this: ImagePixelData): ptr ImagePixelDataBackupExtensions {.header: juce_graphics, importcpp: "#.getBackupExtensions()".}
proc initialiseBitmapData*(this: var ImagePixelData, arg1: var ImageBitmapData, x: cint, y: cint, arg4: ImageBitmapDataReadWriteMode) {.header: juce_graphics, importcpp: "#.initialiseBitmapData(@)".}
proc getSharedCount*(this: ImagePixelData): cint {.header: juce_graphics, importcpp: "#.getSharedCount()".}
proc moveImageSection*(this: var ImagePixelData, destTopLeft: Point[cint], sourceRect: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.moveImageSection(@)".}
proc applyGaussianBlurEffectInArea*(this: var ImagePixelData, bounds: Rectangle[cint], radius: cfloat) {.header: juce_graphics, importcpp: "#.applyGaussianBlurEffectInArea(@)".}
proc applyGaussianBlurEffect*(this: var ImagePixelData, radius: cfloat) {.header: juce_graphics, importcpp: "#.applyGaussianBlurEffect(@)".}
proc applySingleChannelBoxBlurEffectInArea*(this: var ImagePixelData, bounds: Rectangle[cint], radius: cint) {.header: juce_graphics, importcpp: "#.applySingleChannelBoxBlurEffectInArea(@)".}
proc applySingleChannelBoxBlurEffect*(this: var ImagePixelData, radius: cint) {.header: juce_graphics, importcpp: "#.applySingleChannelBoxBlurEffect(@)".}
proc multiplyAllAlphasInArea*(this: var ImagePixelData, bounds: Rectangle[cint], amount: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAllAlphasInArea(@)".}
proc multiplyAllAlphas*(this: var ImagePixelData, amount: cfloat) {.header: juce_graphics, importcpp: "#.multiplyAllAlphas(@)".}
proc desaturateInArea*(this: var ImagePixelData, bounds: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.desaturateInArea(@)".}
proc desaturate*(this: var ImagePixelData) {.header: juce_graphics, importcpp: "#.desaturate()".}
proc sendDataChangeMessage*(this: var ImagePixelData) {.header: juce_graphics, importcpp: "#.sendDataChangeMessage()".}
proc getNativeExtensions*(this: var ImagePixelData): ImagePixelDataNativeExtensions {.header: juce_graphics, importcpp: "#.getNativeExtensions()".}
proc `==`*(this: ImagePixelData, other: ImagePixelData): bool {.error: "juce::ImagePixelData defines no operator==; compare a property instead".}

proc imageDataChanged*(this: var ImagePixelDataListener, arg1: ptr ImagePixelData) {.header: juce_graphics, importcpp: "#.imageDataChanged(@)".}
proc imageDataBeingDeleted*(this: var ImagePixelDataListener, arg1: ptr ImagePixelData) {.header: juce_graphics, importcpp: "#.imageDataBeingDeleted(@)".}
proc `==`*(this: ImagePixelDataListener, other: ImagePixelDataListener): bool {.error: "juce::ImagePixelData::Listener defines no operator==; compare a property instead".}

proc makeImageType*(): ImageType {.header: juce_graphics, importcpp: "juce::ImageType(@)".}
proc create*(this: ImageType, arg1: ImagePixelFormat, width: cint, height: cint, shouldClearImage: bool): ReferenceCountedObjectPtr[ImagePixelData] {.header: juce_graphics, importcpp: "#.create(@)".}
proc getTypeID*(this: ImageType): cint {.header: juce_graphics, importcpp: "#.getTypeID()".}
proc convert*(this: ImageType, source: Image): Image {.header: juce_graphics, importcpp: "#.convert(@)".}
proc `==`*(this: ImageType, other: ImageType): bool {.error: "juce::ImageType defines no operator==; compare a property instead".}

proc makeSoftwareImageType*(): SoftwareImageType {.header: juce_graphics, importcpp: "juce::SoftwareImageType(@)".}
proc create*(this: SoftwareImageType, arg1: ImagePixelFormat, width: cint, height: cint, clearImage: bool): ReferenceCountedObjectPtr[ImagePixelData] {.header: juce_graphics, importcpp: "#.create(@)".}
proc getTypeID*(this: SoftwareImageType): cint {.header: juce_graphics, importcpp: "#.getTypeID()".}
proc `==`*(this: SoftwareImageType, other: SoftwareImageType): bool {.error: "juce::SoftwareImageType defines no operator==; compare a property instead".}

proc makeNativeImageType*(): NativeImageType {.header: juce_graphics, importcpp: "juce::NativeImageType(@)".}
proc create*(this: NativeImageType, arg1: ImagePixelFormat, width: cint, height: cint, clearImage: bool): ReferenceCountedObjectPtr[ImagePixelData] {.header: juce_graphics, importcpp: "#.create(@)".}
proc getTypeID*(this: NativeImageType): cint {.header: juce_graphics, importcpp: "#.getTypeID()".}
proc `==`*(this: NativeImageType, other: NativeImageType): bool {.error: "juce::NativeImageType defines no operator==; compare a property instead".}

proc makeFillType*(): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(colour: Colour): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(gradient: ColourGradient): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc makeFillType*(image: Image, transform: AffineTransform): FillType {.header: juce_graphics, importcpp: "juce::FillType(@)".}
proc colour*(this: FillType): Colour {.header: juce_graphics, importcpp: "#.colour".}
proc colour*(this: var FillType): var Colour {.header: juce_graphics, importcpp: "#.colour".}
proc `colour=`*(this: var FillType, value: Colour) {.header: juce_graphics, importcpp: "#.colour = #".}
proc gradient*(this: FillType): UniquePtr[ColourGradient] {.header: juce_graphics, importcpp: "#.gradient".}
proc gradient*(this: var FillType): var UniquePtr[ColourGradient] {.header: juce_graphics, importcpp: "#.gradient".}
proc `gradient=`*(this: var FillType, value: UniquePtr[ColourGradient]) {.header: juce_graphics, importcpp: "#.gradient = #".}
proc image*(this: FillType): Image {.header: juce_graphics, importcpp: "#.image".}
proc image*(this: var FillType): var Image {.header: juce_graphics, importcpp: "#.image".}
proc `image=`*(this: var FillType, value: Image) {.header: juce_graphics, importcpp: "#.image = #".}
proc transform*(this: FillType): AffineTransform {.header: juce_graphics, importcpp: "#.transform".}
proc transform*(this: var FillType): var AffineTransform {.header: juce_graphics, importcpp: "#.transform".}
proc `transform=`*(this: var FillType, value: AffineTransform) {.header: juce_graphics, importcpp: "#.transform = #".}
proc `FillType=`*(this: var FillType, arg1: FillType): var FillType {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc isColour*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isColour()".}
proc isGradient*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isGradient()".}
proc isTiledImage*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isTiledImage()".}
proc setColour*(this: var FillType, newColour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setGradient*(this: var FillType, newGradient: ColourGradient) {.header: juce_graphics, importcpp: "#.setGradient(@)".}
proc setTiledImage*(this: var FillType, image: Image, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.setTiledImage(@)".}
proc setOpacity*(this: var FillType, newOpacity: cfloat) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
proc getOpacity*(this: FillType): cfloat {.header: juce_graphics, importcpp: "#.getOpacity()".}
proc isInvisible*(this: FillType): bool {.header: juce_graphics, importcpp: "#.isInvisible()".}
proc transformed*(this: FillType, transform: AffineTransform): FillType {.header: juce_graphics, importcpp: "#.transformed(@)".}
proc `==`*(this: FillType, arg1: FillType): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: FillType, arg1: FillType): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==

# proc makeFontFeatureTag*(string: char ()[5]): FontFeatureTag {.header: juce_graphics, importcpp: "juce::FontFeatureTag(@)".}  # a C array parameter; every one of these has an overload taking a String or a value instead
proc makeFontFeatureTag*(tagValue: uint32): FontFeatureTag {.header: juce_graphics, importcpp: "juce::FontFeatureTag(@)".}
proc fromString*(this: typedesc[FontFeatureTag], tagString: String): FontFeatureTag {.header: juce_graphics, importcpp: "juce::FontFeatureTag::fromString(@)".}
proc toString*(this: FontFeatureTag): String {.header: juce_graphics, importcpp: "#.toString()".}
proc getTag*(this: FontFeatureTag): uint32 {.header: juce_graphics, importcpp: "#.getTag()".}
proc `<`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `<=`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
# proc operator>*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}  # Nim derives > and >= from < and <=
# proc operator>=*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}  # Nim derives > and >= from < and <=
proc `==`*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: FontFeatureTag, other: FontFeatureTag): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==

proc makeFontFeatureSetting*(featureTag: FontFeatureTag, featureValue: uint32): FontFeatureSetting {.header: juce_graphics, importcpp: "juce::FontFeatureSetting(@)".}
proc featureEnabled*(this: typedesc[FontFeatureSetting]): cint {.header: juce_graphics, importcpp: "(juce::FontFeatureSetting::featureEnabled)".}
proc featureDisabled*(this: typedesc[FontFeatureSetting]): cint {.header: juce_graphics, importcpp: "(juce::FontFeatureSetting::featureDisabled)".}
proc tag*(this: FontFeatureSetting): FontFeatureTag {.header: juce_graphics, importcpp: "#.tag".}
proc tag*(this: var FontFeatureSetting): var FontFeatureTag {.header: juce_graphics, importcpp: "#.tag".}
proc `tag=`*(this: var FontFeatureSetting, value: FontFeatureTag) {.header: juce_graphics, importcpp: "#.tag = #".}
proc value*(this: FontFeatureSetting): uint32 {.header: juce_graphics, importcpp: "#.value".}
proc value*(this: var FontFeatureSetting): var uint32 {.header: juce_graphics, importcpp: "#.value".}
proc `value=`*(this: var FontFeatureSetting, value: uint32) {.header: juce_graphics, importcpp: "#.value = #".}
proc `<`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `<=`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
# proc operator>*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}  # Nim derives > and >= from < and <=
# proc operator>=*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}  # Nim derives > and >= from < and <=
proc `==`*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: FontFeatureSetting, other: FontFeatureSetting): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==

proc clip*(this: ColourLayer): EdgeTable {.header: juce_graphics, importcpp: "#.clip".}
proc clip*(this: var ColourLayer): var EdgeTable {.header: juce_graphics, importcpp: "#.clip".}
proc `clip=`*(this: var ColourLayer, value: EdgeTable) {.header: juce_graphics, importcpp: "#.clip = #".}
proc colour*(this: ColourLayer): CppOptional[Colour] {.header: juce_graphics, importcpp: "#.colour".}
proc colour*(this: var ColourLayer): var CppOptional[Colour] {.header: juce_graphics, importcpp: "#.colour".}
proc `colour=`*(this: var ColourLayer, value: CppOptional[Colour]) {.header: juce_graphics, importcpp: "#.colour = #".}
proc `==`*(this: ColourLayer, other: ColourLayer): bool {.error: "juce::ColourLayer defines no operator==; compare a property instead".}

proc image*(this: ImageLayer): Image {.header: juce_graphics, importcpp: "#.image".}
proc image*(this: var ImageLayer): var Image {.header: juce_graphics, importcpp: "#.image".}
proc `image=`*(this: var ImageLayer, value: Image) {.header: juce_graphics, importcpp: "#.image = #".}
proc transform*(this: ImageLayer): AffineTransform {.header: juce_graphics, importcpp: "#.transform".}
proc transform*(this: var ImageLayer): var AffineTransform {.header: juce_graphics, importcpp: "#.transform".}
proc `transform=`*(this: var ImageLayer, value: AffineTransform) {.header: juce_graphics, importcpp: "#.transform = #".}
proc `==`*(this: ImageLayer, other: ImageLayer): bool {.error: "juce::ImageLayer defines no operator==; compare a property instead".}

# proc layer*(this: GlyphLayer): std::variant<ColourLayer, ImageLayer> {.header: juce_graphics, importcpp: "#.layer".}  # a type that cannot be spelled in Nim
# proc layer*(this: var GlyphLayer): var std::variant<ColourLayer, ImageLayer> {.header: juce_graphics, importcpp: "#.layer".}  # a type that cannot be spelled in Nim
# proc `layer=`*(this: var GlyphLayer, value: std::variant<ColourLayer, ImageLayer>) {.header: juce_graphics, importcpp: "#.layer = #".}  # a type that cannot be spelled in Nim
proc `==`*(this: GlyphLayer, other: GlyphLayer): bool {.error: "juce::GlyphLayer defines no operator==; compare a property instead".}

proc ascent*(this: TypefaceMetrics): cfloat {.header: juce_graphics, importcpp: "#.ascent".}
proc ascent*(this: var TypefaceMetrics): var cfloat {.header: juce_graphics, importcpp: "#.ascent".}
proc `ascent=`*(this: var TypefaceMetrics, value: cfloat) {.header: juce_graphics, importcpp: "#.ascent = #".}
proc heightToPoints*(this: TypefaceMetrics): cfloat {.header: juce_graphics, importcpp: "#.heightToPoints".}
proc heightToPoints*(this: var TypefaceMetrics): var cfloat {.header: juce_graphics, importcpp: "#.heightToPoints".}
proc `heightToPoints=`*(this: var TypefaceMetrics, value: cfloat) {.header: juce_graphics, importcpp: "#.heightToPoints = #".}
proc `==`*(this: TypefaceMetrics, other: TypefaceMetrics): bool {.error: "juce::TypefaceMetrics defines no operator==; compare a property instead".}

proc getName*(this: Typeface): String {.header: juce_graphics, importcpp: "#.getName()".}
proc getStyle*(this: Typeface): String {.header: juce_graphics, importcpp: "#.getStyle()".}
proc createSystemTypefaceFor*(this: typedesc[Typeface], font: Font): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "juce::Typeface::createSystemTypefaceFor(@)".}
proc createSystemTypefaceFor*(this: typedesc[Typeface], fontFileData: constPointer, fontFileDataSize: uint64): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "juce::Typeface::createSystemTypefaceFor(@)".}
proc createSystemTypefaceFor*(this: typedesc[Typeface], arg1: Span[CppByte]): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "juce::Typeface::createSystemTypefaceFor(@)".}
proc getMetrics*(this: Typeface, arg1: TypefaceMetricsKind): TypefaceMetrics {.header: juce_graphics, importcpp: "#.getMetrics(@)".}
proc getOutlineForGlyph*(this: Typeface, glyphNumber: cint, path: var Path) {.header: juce_graphics, importcpp: "#.getOutlineForGlyph(@)".}
proc getGlyphBounds*(this: Typeface, glyphNumber: cint): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getGlyphBounds(@)".}
proc getLayersForGlyph*(this: Typeface, glyphNumber: cint, arg2: AffineTransform): CppVector[GlyphLayer] {.header: juce_graphics, importcpp: "#.getLayersForGlyph(@)".}
proc getColourGlyphFormats*(this: Typeface): cint {.header: juce_graphics, importcpp: "#.getColourGlyphFormats()".}
proc setTypefaceCacheSize*(this: typedesc[Typeface], numFontsToCache: cint) {.header: juce_graphics, importcpp: "juce::Typeface::setTypefaceCacheSize(@)".}
proc clearTypefaceCache*(this: typedesc[Typeface]) {.header: juce_graphics, importcpp: "juce::Typeface::clearTypefaceCache()".}
proc scanFolderForFonts*(this: typedesc[Typeface], folder: File) {.header: juce_graphics, importcpp: "juce::Typeface::scanFolderForFonts(@)".}
proc getNominalGlyphForCodepoint*(this: Typeface, arg1: WChar): CppOptional[uint32] {.header: juce_graphics, importcpp: "#.getNominalGlyphForCodepoint(@)".}
proc createSystemFallback*(this: Typeface, text: String, language: String): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "#.createSystemFallback(@)".}
proc findSystemTypeface*(this: typedesc[Typeface]): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "juce::Typeface::findSystemTypeface()".}
proc getSupportedFeatures*(this: Typeface): CppVector[FontFeatureTag] {.header: juce_graphics, importcpp: "#.getSupportedFeatures()".}
proc getNativeDetails*(this: Typeface): ptr TypefaceNative {.header: juce_graphics, importcpp: "#.getNativeDetails()".}
proc `==`*(this: Typeface, other: Typeface): bool {.error: "juce::Typeface defines no operator==; compare a property instead".}

proc `==`*(this: TypefaceNative, other: TypefaceNative): bool {.error: "juce::Typeface::Native defines no operator==; compare a property instead".}

proc makeFontOptions*(): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(fontHeight: cfloat): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions((float) @)".}
proc makeFontOptions*(fontHeight: cfloat, styleFlags: cint): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(typefaceName: String, fontHeight: cfloat, styleFlags: cint): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(typefaceName: String, typefaceStyle: String, fontHeight: cfloat): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions(@)".}
proc makeFontOptions*(typeface: ReferenceCountedObjectPtr[Typeface]): FontOptions {.header: juce_graphics, importcpp: "juce::FontOptions((const juce::ReferenceCountedObjectPtr<juce::Typeface> &) @)".}
proc withName*(this: FontOptions, x: String): FontOptions {.header: juce_graphics, importcpp: "#.withName(@)".}
proc withStyle*(this: FontOptions, x: String): FontOptions {.header: juce_graphics, importcpp: "#.withStyle(@)".}
proc withTypeface*(this: FontOptions, x: ReferenceCountedObjectPtr[Typeface]): FontOptions {.header: juce_graphics, importcpp: "#.withTypeface(@)".}
proc withFallbacks*(this: FontOptions, x: CppVector[String]): FontOptions {.header: juce_graphics, importcpp: "#.withFallbacks(@)".}
proc withFallbackEnabled*(this: FontOptions, x: bool = true): FontOptions {.header: juce_graphics, importcpp: "#.withFallbackEnabled(@)".}
proc withHeight*(this: FontOptions, x: cfloat): FontOptions {.header: juce_graphics, importcpp: "#.withHeight(@)".}
proc withPointHeight*(this: FontOptions, x: cfloat): FontOptions {.header: juce_graphics, importcpp: "#.withPointHeight(@)".}
proc withKerningFactor*(this: FontOptions, x: cfloat): FontOptions {.header: juce_graphics, importcpp: "#.withKerningFactor(@)".}
proc withHorizontalScale*(this: FontOptions, x: cfloat): FontOptions {.header: juce_graphics, importcpp: "#.withHorizontalScale(@)".}
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
proc getTypeface*(this: FontOptions): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "#.getTypeface()".}
proc getFallbacks*(this: FontOptions): CppVector[String] {.header: juce_graphics, importcpp: "#.getFallbacks()".}
proc getHeight*(this: FontOptions): cfloat {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getPointHeight*(this: FontOptions): cfloat {.header: juce_graphics, importcpp: "#.getPointHeight()".}
proc getKerningFactor*(this: FontOptions): cfloat {.header: juce_graphics, importcpp: "#.getKerningFactor()".}
proc getHorizontalScale*(this: FontOptions): cfloat {.header: juce_graphics, importcpp: "#.getHorizontalScale()".}
proc getFallbackEnabled*(this: FontOptions): bool {.header: juce_graphics, importcpp: "#.getFallbackEnabled()".}
proc getUnderline*(this: FontOptions): bool {.header: juce_graphics, importcpp: "#.getUnderline()".}
proc getMetricsKind*(this: FontOptions): TypefaceMetricsKind {.header: juce_graphics, importcpp: "#.getMetricsKind()".}
proc getAscentOverride*(this: FontOptions): CppOptional[cfloat] {.header: juce_graphics, importcpp: "#.getAscentOverride()".}
proc getDescentOverride*(this: FontOptions): CppOptional[cfloat] {.header: juce_graphics, importcpp: "#.getDescentOverride()".}
proc getFeatureSettings*(this: FontOptions): Span[FontFeatureSetting] {.header: juce_graphics, importcpp: "#.getFeatureSettings()".}
proc `==`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc `<`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator<(@)".}
proc `<=`*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator<=(@)".}
# proc operator>*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator>(@)".}  # Nim derives > and >= from < and <=
# proc operator>=*(this: FontOptions, other: FontOptions): bool {.header: juce_graphics, importcpp: "#.operator>=(@)".}  # Nim derives > and >= from < and <=

proc makeFont*(options: FontOptions): Font {.header: juce_graphics, importcpp: "juce::Font((juce::FontOptions) @)".}
proc makeFont*(fontHeight: cfloat, styleFlags: cint): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(typefaceName: String, fontHeight: cfloat, styleFlags: cint): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(typefaceName: String, typefaceStyle: String, fontHeight: cfloat): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc makeFont*(typeface: ReferenceCountedObjectPtr[Typeface]): Font {.header: juce_graphics, importcpp: "juce::Font((const juce::ReferenceCountedObjectPtr<juce::Typeface> &) @)".}
proc makeFont*(): Font {.header: juce_graphics, importcpp: "juce::Font(@)".}
proc `Font=`*(this: var Font, other: Font): var Font {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: Font, other: Font): bool {.header: juce_graphics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Font, other: Font): bool {.header: juce_graphics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
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
proc getDefaultSansSerifFontName*(this: typedesc[Font]): String {.header: juce_graphics, importcpp: "juce::Font::getDefaultSansSerifFontName()".}
proc getSystemUIFontName*(this: typedesc[Font]): String {.header: juce_graphics, importcpp: "juce::Font::getSystemUIFontName()".}
proc getDefaultSerifFontName*(this: typedesc[Font]): String {.header: juce_graphics, importcpp: "juce::Font::getDefaultSerifFontName()".}
proc getDefaultMonospacedFontName*(this: typedesc[Font]): String {.header: juce_graphics, importcpp: "juce::Font::getDefaultMonospacedFontName()".}
proc getDefaultStyle*(this: typedesc[Font]): String {.header: juce_graphics, importcpp: "juce::Font::getDefaultStyle()".}
proc getDefaultTypefaceForFont*(this: typedesc[Font], font: Font): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "juce::Font::getDefaultTypefaceForFont(@)".}
proc withHeight*(this: Font, height: cfloat): Font {.header: juce_graphics, importcpp: "#.withHeight(@)".}
proc withPointHeight*(this: Font, heightInPoints: cfloat): Font {.header: juce_graphics, importcpp: "#.withPointHeight(@)".}
proc setHeight*(this: var Font, newHeight: cfloat) {.header: juce_graphics, importcpp: "#.setHeight(@)".}
proc setPointHeight*(this: var Font, newHeight: cfloat) {.header: juce_graphics, importcpp: "#.setPointHeight(@)".}
proc setHeightWithoutChangingWidth*(this: var Font, newHeight: cfloat) {.header: juce_graphics, importcpp: "#.setHeightWithoutChangingWidth(@)".}
proc getHeight*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getHeightInPoints*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getHeightInPoints()".}
proc getAscent*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getAscent()".}
proc getAscentInPoints*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getAscentInPoints()".}
proc getDescent*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getDescent()".}
proc getDescentInPoints*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getDescentInPoints()".}
proc getStyleFlags*(this: Font): cint {.header: juce_graphics, importcpp: "#.getStyleFlags()".}
proc withStyle*(this: Font, styleFlags: cint): Font {.header: juce_graphics, importcpp: "#.withStyle(@)".}
proc setStyleFlags*(this: var Font, newFlags: cint) {.header: juce_graphics, importcpp: "#.setStyleFlags(@)".}
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
proc getHorizontalScale*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getHorizontalScale()".}
proc withHorizontalScale*(this: Font, scaleFactor: cfloat): Font {.header: juce_graphics, importcpp: "#.withHorizontalScale(@)".}
proc setHorizontalScale*(this: var Font, scaleFactor: cfloat) {.header: juce_graphics, importcpp: "#.setHorizontalScale(@)".}
proc getDefaultMinimumHorizontalScaleFactor*(this: typedesc[Font]): cfloat {.header: juce_graphics, importcpp: "juce::Font::getDefaultMinimumHorizontalScaleFactor()".}
proc setDefaultMinimumHorizontalScaleFactor*(this: typedesc[Font], newMinimumScaleFactor: cfloat) {.header: juce_graphics, importcpp: "juce::Font::setDefaultMinimumHorizontalScaleFactor(@)".}
proc getExtraKerningFactor*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getExtraKerningFactor()".}
proc withExtraKerningFactor*(this: Font, extraKerning: cfloat): Font {.header: juce_graphics, importcpp: "#.withExtraKerningFactor(@)".}
proc setExtraKerningFactor*(this: var Font, extraKerning: cfloat) {.header: juce_graphics, importcpp: "#.setExtraKerningFactor(@)".}
proc getAscentOverride*(this: Font): CppOptional[cfloat] {.header: juce_graphics, importcpp: "#.getAscentOverride()".}
proc setAscentOverride*(this: var Font, arg1: CppOptional[cfloat]) {.header: juce_graphics, importcpp: "#.setAscentOverride(@)".}
proc getDescentOverride*(this: Font): CppOptional[cfloat] {.header: juce_graphics, importcpp: "#.getDescentOverride()".}
proc setDescentOverride*(this: var Font, arg1: CppOptional[cfloat]) {.header: juce_graphics, importcpp: "#.setDescentOverride(@)".}
proc setSizeAndStyle*(this: var Font, newHeight: cfloat, newStyleFlags: cint, newHorizontalScale: cfloat, newKerningAmount: cfloat) {.header: juce_graphics, importcpp: "#.setSizeAndStyle(@)".}
proc setSizeAndStyle*(this: var Font, newHeight: cfloat, newStyle: String, newHorizontalScale: cfloat, newKerningAmount: cfloat) {.header: juce_graphics, importcpp: "#.setSizeAndStyle(@)".}
proc getTypefacePtr*(this: Font): ReferenceCountedObjectPtr[Typeface] {.header: juce_graphics, importcpp: "#.getTypefacePtr()".}
proc findFonts*(this: typedesc[Font], results: Array[Font]) {.header: juce_graphics, importcpp: "juce::Font::findFonts(@)".}
proc findAllTypefaceNames*(this: typedesc[Font]): StringArray {.header: juce_graphics, importcpp: "juce::Font::findAllTypefaceNames()".}
proc findAllTypefaceStyles*(this: typedesc[Font], family: String): StringArray {.header: juce_graphics, importcpp: "juce::Font::findAllTypefaceStyles(@)".}
proc findSuitableFontForText*(this: Font, text: String, language: String): Font {.header: juce_graphics, importcpp: "#.findSuitableFontForText(@)".}
proc toString*(this: Font): String {.header: juce_graphics, importcpp: "#.toString()".}
proc fromString*(this: typedesc[Font], fontDescription: String): Font {.header: juce_graphics, importcpp: "juce::Font::fromString(@)".}
proc getNativeDetails*(this: Font): FontNative {.header: juce_graphics, importcpp: "#.getNativeDetails()".}
proc getHeightToPointsFactor*(this: Font): cfloat {.header: juce_graphics, importcpp: "#.getHeightToPointsFactor()".}

proc `==`*(this: FontNative, other: FontNative): bool {.error: "juce::Font::Native defines no operator==; compare a property instead".}

proc makeAttributedString*(): AttributedString {.header: juce_graphics, importcpp: "juce::AttributedString(@)".}
proc makeAttributedString*(newString: String): AttributedString {.header: juce_graphics, importcpp: "juce::AttributedString(@)".}
proc `AttributedString=`*(this: var AttributedString, arg1: AttributedString): var AttributedString {.header: juce_graphics, importcpp: "#.operator=(@)".}
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
proc getLineSpacing*(this: AttributedString): cfloat {.header: juce_graphics, importcpp: "#.getLineSpacing()".}
proc setLineSpacing*(this: var AttributedString, newLineSpacing: cfloat) {.header: juce_graphics, importcpp: "#.setLineSpacing(@)".}
proc getNumAttributes*(this: AttributedString): cint {.header: juce_graphics, importcpp: "#.getNumAttributes()".}
proc getAttribute*(this: AttributedString, index: cint): AttributedStringAttribute {.header: juce_graphics, importcpp: "#.getAttribute(@)".}
proc setColour*(this: var AttributedString, range: Range[cint], colour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setColour*(this: var AttributedString, colour: Colour) {.header: juce_graphics, importcpp: "#.setColour(@)".}
proc setFont*(this: var AttributedString, range: Range[cint], font: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc setFont*(this: var AttributedString, font: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc `==`*(this: AttributedString, other: AttributedString): bool {.error: "juce::AttributedString defines no operator==; compare a property instead".}

proc makeAttributedStringAttribute*(): AttributedStringAttribute {.header: juce_graphics, importcpp: "juce::AttributedString::Attribute(@)".}
proc makeAttributedStringAttribute*(range: Range[cint], font: Font, colour: Colour): AttributedStringAttribute {.header: juce_graphics, importcpp: "juce::AttributedString::Attribute(@)".}
proc range*(this: AttributedStringAttribute): Range[cint] {.header: juce_graphics, importcpp: "#.range".}
proc range*(this: var AttributedStringAttribute): var Range[cint] {.header: juce_graphics, importcpp: "#.range".}
proc `range=`*(this: var AttributedStringAttribute, value: Range[cint]) {.header: juce_graphics, importcpp: "#.range = #".}
proc font*(this: AttributedStringAttribute): Font {.header: juce_graphics, importcpp: "#.font".}
proc font*(this: var AttributedStringAttribute): var Font {.header: juce_graphics, importcpp: "#.font".}
proc `font=`*(this: var AttributedStringAttribute, value: Font) {.header: juce_graphics, importcpp: "#.font = #".}
proc colour*(this: AttributedStringAttribute): Colour {.header: juce_graphics, importcpp: "#.colour".}
proc colour*(this: var AttributedStringAttribute): var Colour {.header: juce_graphics, importcpp: "#.colour".}
proc `colour=`*(this: var AttributedStringAttribute, value: Colour) {.header: juce_graphics, importcpp: "#.colour = #".}
proc `AttributedStringAttribute=`*(this: var AttributedStringAttribute, arg1: AttributedStringAttribute): var AttributedStringAttribute {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `AttributedStringAttribute=`*(this: var AttributedStringAttribute, arg1: var AttributedStringAttribute): var AttributedStringAttribute {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `==`*(this: AttributedStringAttribute, other: AttributedStringAttribute): bool {.error: "juce::AttributedString::Attribute defines no operator==; compare a property instead".}

proc makePositionedGlyph*(): PositionedGlyph {.header: juce_graphics, importcpp: "juce::PositionedGlyph(@)".}
proc makePositionedGlyph*(font: Font, character: WChar, glyphNumber: cint, anchorX: cfloat, baselineY: cfloat, width: cfloat, isWhitespace: bool): PositionedGlyph {.header: juce_graphics, importcpp: "juce::PositionedGlyph(@)".}
proc getCharacter*(this: PositionedGlyph): WChar {.header: juce_graphics, importcpp: "#.getCharacter()".}
proc isWhitespace*(this: PositionedGlyph): bool {.header: juce_graphics, importcpp: "#.isWhitespace()".}
proc getLeft*(this: PositionedGlyph): cfloat {.header: juce_graphics, importcpp: "#.getLeft()".}
proc getRight*(this: PositionedGlyph): cfloat {.header: juce_graphics, importcpp: "#.getRight()".}
proc getBaselineY*(this: PositionedGlyph): cfloat {.header: juce_graphics, importcpp: "#.getBaselineY()".}
proc getTop*(this: PositionedGlyph): cfloat {.header: juce_graphics, importcpp: "#.getTop()".}
proc getBottom*(this: PositionedGlyph): cfloat {.header: juce_graphics, importcpp: "#.getBottom()".}
proc getBounds*(this: PositionedGlyph): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getGlyphIndex*(this: PositionedGlyph): cint {.header: juce_graphics, importcpp: "#.getGlyphIndex()".}
proc moveBy*(this: var PositionedGlyph, deltaX: cfloat, deltaY: cfloat) {.header: juce_graphics, importcpp: "#.moveBy(@)".}
proc draw*(this: PositionedGlyph, g: var Graphics) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc draw*(this: PositionedGlyph, g: var Graphics, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc createPath*(this: PositionedGlyph, path: var Path) {.header: juce_graphics, importcpp: "#.createPath(@)".}
proc hitTest*(this: PositionedGlyph, x: cfloat, y: cfloat): bool {.header: juce_graphics, importcpp: "#.hitTest(@)".}
proc `==`*(this: PositionedGlyph, other: PositionedGlyph): bool {.error: "juce::PositionedGlyph defines no operator==; compare a property instead".}

proc makeGlyphArrangement*(): GlyphArrangement {.header: juce_graphics, importcpp: "juce::GlyphArrangement(@)".}
proc `GlyphArrangement=`*(this: var GlyphArrangement, arg1: GlyphArrangement): var GlyphArrangement {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc getNumGlyphs*(this: GlyphArrangement): cint {.header: juce_graphics, importcpp: "#.getNumGlyphs()".}
proc getGlyph*(this: var GlyphArrangement, index: cint): var PositionedGlyph {.header: juce_graphics, importcpp: "#.getGlyph(@)".}
# proc begin*(this: GlyphArrangement): ptr PositionedGlyph {.header: juce_graphics, importcpp: "#.begin()".}  # a C++ iterator; loop with the Nim iterator instead
# proc `end`*(this: GlyphArrangement): ptr PositionedGlyph {.header: juce_graphics, importcpp: "#.end()".}  # a C++ iterator; loop with the Nim iterator instead
proc clear*(this: var GlyphArrangement) {.header: juce_graphics, importcpp: "#.clear()".}
proc addLineOfText*(this: var GlyphArrangement, font: Font, text: String, x: cfloat, y: cfloat) {.header: juce_graphics, importcpp: "#.addLineOfText(@)".}
proc addCurtailedLineOfText*(this: var GlyphArrangement, font: Font, text: String, x: cfloat, y: cfloat, maxWidthPixels: cfloat, useEllipsis: bool) {.header: juce_graphics, importcpp: "#.addCurtailedLineOfText(@)".}
proc addJustifiedText*(this: var GlyphArrangement, font: Font, text: String, x: cfloat, y: cfloat, maxLineWidth: cfloat, horizontalLayout: Justification, leading: cfloat = 0.0f) {.header: juce_graphics, importcpp: "#.addJustifiedText(@)".}
proc addFittedText*(this: var GlyphArrangement, font: Font, text: String, x: cfloat, y: cfloat, width: cfloat, height: cfloat, layout: Justification, maximumLinesToUse: cint, minimumHorizontalScale: cfloat = 0.0f, options: GlyphArrangementOptions) {.header: juce_graphics, importcpp: "#.addFittedText(@)".}
proc addGlyphArrangement*(this: var GlyphArrangement, arg1: GlyphArrangement) {.header: juce_graphics, importcpp: "#.addGlyphArrangement(@)".}
proc addGlyph*(this: var GlyphArrangement, arg1: PositionedGlyph) {.header: juce_graphics, importcpp: "#.addGlyph(@)".}
proc draw*(this: GlyphArrangement, arg1: Graphics) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc draw*(this: GlyphArrangement, arg1: Graphics, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc createPath*(this: GlyphArrangement, path: var Path) {.header: juce_graphics, importcpp: "#.createPath(@)".}
proc findGlyphIndexAt*(this: GlyphArrangement, x: cfloat, y: cfloat): cint {.header: juce_graphics, importcpp: "#.findGlyphIndexAt(@)".}
proc getBoundingBox*(this: GlyphArrangement, startIndex: cint, numGlyphs: cint, includeWhitespace: bool): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBoundingBox(@)".}
proc moveRangeOfGlyphs*(this: var GlyphArrangement, startIndex: cint, numGlyphs: cint, deltaX: cfloat, deltaY: cfloat) {.header: juce_graphics, importcpp: "#.moveRangeOfGlyphs(@)".}
proc removeRangeOfGlyphs*(this: var GlyphArrangement, startIndex: cint, numGlyphs: cint) {.header: juce_graphics, importcpp: "#.removeRangeOfGlyphs(@)".}
proc stretchRangeOfGlyphs*(this: var GlyphArrangement, startIndex: cint, numGlyphs: cint, horizontalScaleFactor: cfloat) {.header: juce_graphics, importcpp: "#.stretchRangeOfGlyphs(@)".}
proc justifyGlyphs*(this: var GlyphArrangement, startIndex: cint, numGlyphs: cint, x: cfloat, y: cfloat, width: cfloat, height: cfloat, justification: Justification) {.header: juce_graphics, importcpp: "#.justifyGlyphs(@)".}
proc getStringBounds*(this: typedesc[GlyphArrangement], font: Font, text: StringRef): Rectangle[cfloat] {.header: juce_graphics, importcpp: "juce::GlyphArrangement::getStringBounds(@)".}
proc getStringWidth*(this: typedesc[GlyphArrangement], font: Font, text: StringRef): cfloat {.header: juce_graphics, importcpp: "juce::GlyphArrangement::getStringWidth(@)".}
proc getStringWidthInt*(this: typedesc[GlyphArrangement], font: Font, text: StringRef): cint {.header: juce_graphics, importcpp: "juce::GlyphArrangement::getStringWidthInt(@)".}
proc `==`*(this: GlyphArrangement, other: GlyphArrangement): bool {.error: "juce::GlyphArrangement defines no operator==; compare a property instead".}

proc makeTextLayout*(): TextLayout {.header: juce_graphics, importcpp: "juce::TextLayout(@)".}
proc `TextLayout=`*(this: var TextLayout, arg1: TextLayout): var TextLayout {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc createLayout*(this: var TextLayout, arg1: AttributedString, maxWidth: cfloat) {.header: juce_graphics, importcpp: "#.createLayout(@)".}
proc createLayout*(this: var TextLayout, arg1: AttributedString, maxWidth: cfloat, maxHeight: cfloat) {.header: juce_graphics, importcpp: "#.createLayout(@)".}
proc createLayoutWithBalancedLineLengths*(this: var TextLayout, arg1: AttributedString, maxWidth: cfloat) {.header: juce_graphics, importcpp: "#.createLayoutWithBalancedLineLengths(@)".}
proc createLayoutWithBalancedLineLengths*(this: var TextLayout, arg1: AttributedString, maxWidth: cfloat, maxHeight: cfloat) {.header: juce_graphics, importcpp: "#.createLayoutWithBalancedLineLengths(@)".}
proc draw*(this: TextLayout, arg1: var Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.draw(@)".}
proc getWidth*(this: TextLayout): cfloat {.header: juce_graphics, importcpp: "#.getWidth()".}
proc getHeight*(this: TextLayout): cfloat {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getNumLines*(this: TextLayout): cint {.header: juce_graphics, importcpp: "#.getNumLines()".}
proc getLine*(this: TextLayout, index: cint): var TextLayoutLine {.header: juce_graphics, importcpp: "#.getLine(@)".}
proc addLine*(this: var TextLayout, arg1: UniquePtr[TextLayoutLine]) {.header: juce_graphics, importcpp: "#.addLine(@)".}
proc ensureStorageAllocated*(this: var TextLayout, numLinesNeeded: cint) {.header: juce_graphics, importcpp: "#.ensureStorageAllocated(@)".}
# proc begin*(this: var TextLayout): iterator {.header: juce_graphics, importcpp: "#.begin()".}  # a C++ iterator; loop with the Nim iterator instead
# proc begin*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.begin()".}  # a C++ iterator; loop with the Nim iterator instead
# proc cbegin*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.cbegin()".}  # a C++ iterator; loop with the Nim iterator instead
# proc `end`*(this: var TextLayout): iterator {.header: juce_graphics, importcpp: "#.end()".}  # a C++ iterator; loop with the Nim iterator instead
# proc `end`*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.end()".}  # a C++ iterator; loop with the Nim iterator instead
# proc cend*(this: TextLayout): _iterator {.header: juce_graphics, importcpp: "#.cend()".}  # a C++ iterator; loop with the Nim iterator instead
proc recalculateSize*(this: var TextLayout) {.header: juce_graphics, importcpp: "#.recalculateSize()".}
proc getStringBounds*(this: typedesc[TextLayout], string: AttributedString): Rectangle[cfloat] {.header: juce_graphics, importcpp: "juce::TextLayout::getStringBounds(@)".}
proc getStringBounds*(this: typedesc[TextLayout], font: Font, text: StringRef): Rectangle[cfloat] {.header: juce_graphics, importcpp: "juce::TextLayout::getStringBounds(@)".}
proc getStringWidth*(this: typedesc[TextLayout], string: AttributedString): cfloat {.header: juce_graphics, importcpp: "juce::TextLayout::getStringWidth(@)".}
proc getStringWidth*(this: typedesc[TextLayout], font: Font, text: StringRef): cfloat {.header: juce_graphics, importcpp: "juce::TextLayout::getStringWidth(@)".}
proc `==`*(this: TextLayout, other: TextLayout): bool {.error: "juce::TextLayout defines no operator==; compare a property instead".}

proc makeTextLayoutGlyph*(glyphCode: cint, anchor: Point[cfloat], width: cfloat): TextLayoutGlyph {.header: juce_graphics, importcpp: "juce::TextLayout::Glyph(@)".}
proc glyphCode*(this: TextLayoutGlyph): cint {.header: juce_graphics, importcpp: "#.glyphCode".}
proc glyphCode*(this: var TextLayoutGlyph): var cint {.header: juce_graphics, importcpp: "#.glyphCode".}
proc `glyphCode=`*(this: var TextLayoutGlyph, value: cint) {.header: juce_graphics, importcpp: "#.glyphCode = #".}
proc anchor*(this: TextLayoutGlyph): Point[cfloat] {.header: juce_graphics, importcpp: "#.anchor".}
proc anchor*(this: var TextLayoutGlyph): var Point[cfloat] {.header: juce_graphics, importcpp: "#.anchor".}
proc `anchor=`*(this: var TextLayoutGlyph, value: Point[cfloat]) {.header: juce_graphics, importcpp: "#.anchor = #".}
proc width*(this: TextLayoutGlyph): cfloat {.header: juce_graphics, importcpp: "#.width".}
proc width*(this: var TextLayoutGlyph): var cfloat {.header: juce_graphics, importcpp: "#.width".}
proc `width=`*(this: var TextLayoutGlyph, value: cfloat) {.header: juce_graphics, importcpp: "#.width = #".}
proc `==`*(this: TextLayoutGlyph, other: TextLayoutGlyph): bool {.error: "juce::TextLayout::Glyph defines no operator==; compare a property instead".}

proc makeTextLayoutRun*(): TextLayoutRun {.header: juce_graphics, importcpp: "juce::TextLayout::Run(@)".}
proc makeTextLayoutRun*(stringRange: Range[cint], numGlyphsToPreallocate: cint): TextLayoutRun {.header: juce_graphics, importcpp: "juce::TextLayout::Run(@)".}
proc font*(this: TextLayoutRun): Font {.header: juce_graphics, importcpp: "#.font".}
proc font*(this: var TextLayoutRun): var Font {.header: juce_graphics, importcpp: "#.font".}
proc `font=`*(this: var TextLayoutRun, value: Font) {.header: juce_graphics, importcpp: "#.font = #".}
proc colour*(this: TextLayoutRun): Colour {.header: juce_graphics, importcpp: "#.colour".}
proc colour*(this: var TextLayoutRun): var Colour {.header: juce_graphics, importcpp: "#.colour".}
proc `colour=`*(this: var TextLayoutRun, value: Colour) {.header: juce_graphics, importcpp: "#.colour = #".}
proc glyphs*(this: TextLayoutRun): Array[TextLayoutGlyph] {.header: juce_graphics, importcpp: "#.glyphs".}
proc glyphs*(this: var TextLayoutRun): var Array[TextLayoutGlyph] {.header: juce_graphics, importcpp: "#.glyphs".}
proc `glyphs=`*(this: var TextLayoutRun, value: Array[TextLayoutGlyph]) {.header: juce_graphics, importcpp: "#.glyphs = #".}
proc stringRange*(this: TextLayoutRun): Range[cint] {.header: juce_graphics, importcpp: "#.stringRange".}
proc stringRange*(this: var TextLayoutRun): var Range[cint] {.header: juce_graphics, importcpp: "#.stringRange".}
proc `stringRange=`*(this: var TextLayoutRun, value: Range[cint]) {.header: juce_graphics, importcpp: "#.stringRange = #".}
proc getRunBoundsX*(this: TextLayoutRun): Range[cfloat] {.header: juce_graphics, importcpp: "#.getRunBoundsX()".}
proc `==`*(this: TextLayoutRun, other: TextLayoutRun): bool {.error: "juce::TextLayout::Run defines no operator==; compare a property instead".}

proc makeTextLayoutLine*(): TextLayoutLine {.header: juce_graphics, importcpp: "juce::TextLayout::Line(@)".}
proc makeTextLayoutLine*(stringRange: Range[cint], lineOrigin: Point[cfloat], ascent: cfloat, descent: cfloat, leading: cfloat, numRunsToPreallocate: cint): TextLayoutLine {.header: juce_graphics, importcpp: "juce::TextLayout::Line(@)".}
proc runs*(this: TextLayoutLine): OwnedArray[TextLayoutRun] {.header: juce_graphics, importcpp: "#.runs".}
proc runs*(this: var TextLayoutLine): var OwnedArray[TextLayoutRun] {.header: juce_graphics, importcpp: "#.runs".}
proc `runs=`*(this: var TextLayoutLine, value: OwnedArray[TextLayoutRun]) {.header: juce_graphics, importcpp: "#.runs = #".}
proc stringRange*(this: TextLayoutLine): Range[cint] {.header: juce_graphics, importcpp: "#.stringRange".}
proc stringRange*(this: var TextLayoutLine): var Range[cint] {.header: juce_graphics, importcpp: "#.stringRange".}
proc `stringRange=`*(this: var TextLayoutLine, value: Range[cint]) {.header: juce_graphics, importcpp: "#.stringRange = #".}
proc lineOrigin*(this: TextLayoutLine): Point[cfloat] {.header: juce_graphics, importcpp: "#.lineOrigin".}
proc lineOrigin*(this: var TextLayoutLine): var Point[cfloat] {.header: juce_graphics, importcpp: "#.lineOrigin".}
proc `lineOrigin=`*(this: var TextLayoutLine, value: Point[cfloat]) {.header: juce_graphics, importcpp: "#.lineOrigin = #".}
proc ascent*(this: TextLayoutLine): cfloat {.header: juce_graphics, importcpp: "#.ascent".}
proc ascent*(this: var TextLayoutLine): var cfloat {.header: juce_graphics, importcpp: "#.ascent".}
proc `ascent=`*(this: var TextLayoutLine, value: cfloat) {.header: juce_graphics, importcpp: "#.ascent = #".}
proc descent*(this: TextLayoutLine): cfloat {.header: juce_graphics, importcpp: "#.descent".}
proc descent*(this: var TextLayoutLine): var cfloat {.header: juce_graphics, importcpp: "#.descent".}
proc `descent=`*(this: var TextLayoutLine, value: cfloat) {.header: juce_graphics, importcpp: "#.descent = #".}
proc leading*(this: TextLayoutLine): cfloat {.header: juce_graphics, importcpp: "#.leading".}
proc leading*(this: var TextLayoutLine): var cfloat {.header: juce_graphics, importcpp: "#.leading".}
proc `leading=`*(this: var TextLayoutLine, value: cfloat) {.header: juce_graphics, importcpp: "#.leading = #".}
proc `TextLayoutLine=`*(this: var TextLayoutLine, arg1: TextLayoutLine): var TextLayoutLine {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc `TextLayoutLine=`*(this: var TextLayoutLine, arg1: var TextLayoutLine): var TextLayoutLine {.header: juce_graphics, importcpp: "#.operator=(@)".}
proc getLineBoundsX*(this: TextLayoutLine): Range[cfloat] {.header: juce_graphics, importcpp: "#.getLineBoundsX()".}
proc getLineBoundsY*(this: TextLayoutLine): Range[cfloat] {.header: juce_graphics, importcpp: "#.getLineBoundsY()".}
proc getLineBounds*(this: TextLayoutLine): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getLineBounds()".}
proc swap*(this: var TextLayoutLine, other: var TextLayoutLine) {.header: juce_graphics, importcpp: "#.swap(@)".}
proc `==`*(this: TextLayoutLine, other: TextLayoutLine): bool {.error: "juce::TextLayout::Line defines no operator==; compare a property instead".}

proc isVectorDevice*(this: LowLevelGraphicsContext): bool {.header: juce_graphics, importcpp: "#.isVectorDevice()".}
proc setOrigin*(this: var LowLevelGraphicsContext, arg1: Point[cint]) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc addTransform*(this: var LowLevelGraphicsContext, arg1: AffineTransform) {.header: juce_graphics, importcpp: "#.addTransform(@)".}
proc getPhysicalPixelScaleFactor*(this: LowLevelGraphicsContext): cfloat {.header: juce_graphics, importcpp: "#.getPhysicalPixelScaleFactor()".}
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
proc beginTransparencyLayer*(this: var LowLevelGraphicsContext, opacity: cfloat) {.header: juce_graphics, importcpp: "#.beginTransparencyLayer(@)".}
proc endTransparencyLayer*(this: var LowLevelGraphicsContext) {.header: juce_graphics, importcpp: "#.endTransparencyLayer()".}
proc setFill*(this: var LowLevelGraphicsContext, arg1: FillType) {.header: juce_graphics, importcpp: "#.setFill(@)".}
proc setOpacity*(this: var LowLevelGraphicsContext, arg1: cfloat) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
proc setInterpolationQuality*(this: var LowLevelGraphicsContext, arg1: GraphicsResamplingQuality) {.header: juce_graphics, importcpp: "#.setInterpolationQuality(@)".}
proc fillAll*(this: var LowLevelGraphicsContext) {.header: juce_graphics, importcpp: "#.fillAll()".}
proc fillRect*(this: var LowLevelGraphicsContext, arg1: Rectangle[cint], replaceExistingContents: bool) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: var LowLevelGraphicsContext, arg1: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRectList*(this: var LowLevelGraphicsContext, arg1: RectangleList[cfloat]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillPath*(this: var LowLevelGraphicsContext, arg1: Path, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc drawRect*(this: var LowLevelGraphicsContext, rect: Rectangle[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc strokePath*(this: var LowLevelGraphicsContext, path: Path, strokeType: PathStrokeType, transform: AffineTransform) {.header: juce_graphics, importcpp: "#.strokePath(@)".}
proc drawImage*(this: var LowLevelGraphicsContext, arg1: Image, arg2: AffineTransform) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawLine*(this: var LowLevelGraphicsContext, arg1: Line[cfloat]) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc drawLineWithThickness*(this: var LowLevelGraphicsContext, line: Line[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawLineWithThickness(@)".}
proc setFont*(this: var LowLevelGraphicsContext, arg1: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc getFont*(this: var LowLevelGraphicsContext): Font {.header: juce_graphics, importcpp: "#.getFont()".}
proc drawGlyphs*(this: var LowLevelGraphicsContext, arg1: Span[uint16], arg2: Span[Point[cfloat]], arg3: AffineTransform) {.header: juce_graphics, importcpp: "#.drawGlyphs(@)".}
proc getPreferredImageTypeForTemporaryImages*(this: LowLevelGraphicsContext): UniquePtr[ImageType] {.header: juce_graphics, importcpp: "#.getPreferredImageTypeForTemporaryImages()".}
proc drawRoundedRectangle*(this: var LowLevelGraphicsContext, r: Rectangle[cfloat], cornerSize: cfloat, lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawRoundedRectangle(@)".}
proc fillRoundedRectangle*(this: var LowLevelGraphicsContext, r: Rectangle[cfloat], cornerSize: cfloat) {.header: juce_graphics, importcpp: "#.fillRoundedRectangle(@)".}
proc drawEllipse*(this: var LowLevelGraphicsContext, area: Rectangle[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc fillEllipse*(this: var LowLevelGraphicsContext, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
proc getFrameId*(this: LowLevelGraphicsContext): uint64 {.header: juce_graphics, importcpp: "#.getFrameId()".}
proc `==`*(this: LowLevelGraphicsContext, other: LowLevelGraphicsContext): bool {.error: "juce::LowLevelGraphicsContext defines no operator==; compare a property instead".}

proc makeScaledImage*(): ScaledImage {.header: juce_graphics, importcpp: "juce::ScaledImage(@)".}
proc makeScaledImage*(imageIn: Image): ScaledImage {.header: juce_graphics, importcpp: "juce::ScaledImage(@)".}
proc makeScaledImage*(imageIn: Image, scaleIn: float64): ScaledImage {.header: juce_graphics, importcpp: "juce::ScaledImage(@)".}
proc getImage*(this: ScaledImage): Image {.header: juce_graphics, importcpp: "#.getImage()".}
proc getScale*(this: ScaledImage): float64 {.header: juce_graphics, importcpp: "#.getScale()".}
proc getScaledBounds*(this: ScaledImage): Rectangle[cdouble] {.header: juce_graphics, importcpp: "#.getScaledBounds()".}
proc `==`*(this: ScaledImage, other: ScaledImage): bool {.error: "juce::ScaledImage defines no operator==; compare a property instead".}

proc makeLowLevelGraphicsSoftwareRenderer*(imageToRenderOnto: Image): LowLevelGraphicsSoftwareRenderer {.header: juce_graphics, importcpp: "juce::LowLevelGraphicsSoftwareRenderer(@)".}
proc makeLowLevelGraphicsSoftwareRenderer*(imageToRenderOnto: Image, origin: Point[cint], initialClip: RectangleList[cint]): LowLevelGraphicsSoftwareRenderer {.header: juce_graphics, importcpp: "juce::LowLevelGraphicsSoftwareRenderer(@)".}
proc getPreferredImageTypeForTemporaryImages*(this: LowLevelGraphicsSoftwareRenderer): UniquePtr[ImageType] {.header: juce_graphics, importcpp: "#.getPreferredImageTypeForTemporaryImages()".}
proc isVectorDevice*(this: LowLevelGraphicsSoftwareRenderer): bool {.header: juce_graphics, importcpp: "#.isVectorDevice()".}
proc getClipBounds*(this: LowLevelGraphicsSoftwareRenderer): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getClipBounds()".}
proc isClipEmpty*(this: LowLevelGraphicsSoftwareRenderer): bool {.header: juce_graphics, importcpp: "#.isClipEmpty()".}
proc setOrigin*(this: var LowLevelGraphicsSoftwareRenderer, o: Point[cint]) {.header: juce_graphics, importcpp: "#.setOrigin(@)".}
proc addTransform*(this: var LowLevelGraphicsSoftwareRenderer, t: AffineTransform) {.header: juce_graphics, importcpp: "#.addTransform(@)".}
proc getPhysicalPixelScaleFactor*(this: LowLevelGraphicsSoftwareRenderer): cfloat {.header: juce_graphics, importcpp: "#.getPhysicalPixelScaleFactor()".}
proc clipRegionIntersects*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipRegionIntersects(@)".}
proc clipToRectangle*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.clipToRectangle(@)".}
proc clipToRectangleList*(this: var LowLevelGraphicsSoftwareRenderer, r: RectangleList[cint]): bool {.header: juce_graphics, importcpp: "#.clipToRectangleList(@)".}
proc excludeClipRectangle*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.excludeClipRectangle(@)".}
proc clipToPath*(this: var LowLevelGraphicsSoftwareRenderer, path: Path, t: AffineTransform) {.header: juce_graphics, importcpp: "#.clipToPath(@)".}
proc clipToImageAlpha*(this: var LowLevelGraphicsSoftwareRenderer, im: Image, t: AffineTransform) {.header: juce_graphics, importcpp: "#.clipToImageAlpha(@)".}
proc saveState*(this: var LowLevelGraphicsSoftwareRenderer) {.header: juce_graphics, importcpp: "#.saveState()".}
proc restoreState*(this: var LowLevelGraphicsSoftwareRenderer) {.header: juce_graphics, importcpp: "#.restoreState()".}
proc beginTransparencyLayer*(this: var LowLevelGraphicsSoftwareRenderer, opacity: cfloat) {.header: juce_graphics, importcpp: "#.beginTransparencyLayer(@)".}
proc endTransparencyLayer*(this: var LowLevelGraphicsSoftwareRenderer) {.header: juce_graphics, importcpp: "#.endTransparencyLayer()".}
proc setFill*(this: var LowLevelGraphicsSoftwareRenderer, fillType: FillType) {.header: juce_graphics, importcpp: "#.setFill(@)".}
proc setOpacity*(this: var LowLevelGraphicsSoftwareRenderer, newOpacity: cfloat) {.header: juce_graphics, importcpp: "#.setOpacity(@)".}
proc setInterpolationQuality*(this: var LowLevelGraphicsSoftwareRenderer, quality: GraphicsResamplingQuality) {.header: juce_graphics, importcpp: "#.setInterpolationQuality(@)".}
proc fillRect*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cint], replace: bool) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: var LowLevelGraphicsSoftwareRenderer, r: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRectList*(this: var LowLevelGraphicsSoftwareRenderer, list: RectangleList[cfloat]) {.header: juce_graphics, importcpp: "#.fillRectList(@)".}
proc fillPath*(this: var LowLevelGraphicsSoftwareRenderer, path: Path, t: AffineTransform) {.header: juce_graphics, importcpp: "#.fillPath(@)".}
proc drawImage*(this: var LowLevelGraphicsSoftwareRenderer, im: Image, t: AffineTransform) {.header: juce_graphics, importcpp: "#.drawImage(@)".}
proc drawLine*(this: var LowLevelGraphicsSoftwareRenderer, line: Line[cfloat]) {.header: juce_graphics, importcpp: "#.drawLine(@)".}
proc setFont*(this: var LowLevelGraphicsSoftwareRenderer, newFont: Font) {.header: juce_graphics, importcpp: "#.setFont(@)".}
proc getFont*(this: var LowLevelGraphicsSoftwareRenderer): Font {.header: juce_graphics, importcpp: "#.getFont()".}
proc getFrameId*(this: LowLevelGraphicsSoftwareRenderer): uint64 {.header: juce_graphics, importcpp: "#.getFrameId()".}
proc drawGlyphs*(this: var LowLevelGraphicsSoftwareRenderer, glyphs: Span[uint16], positions: Span[Point[cfloat]], t: AffineTransform) {.header: juce_graphics, importcpp: "#.drawGlyphs(@)".}
proc `==`*(this: LowLevelGraphicsSoftwareRenderer, other: LowLevelGraphicsSoftwareRenderer): bool {.error: "juce::LowLevelGraphicsSoftwareRenderer defines no operator==; compare a property instead".}

proc applyEffect*(this: var ImageEffectFilter, sourceImage: var Image, destContext: var Graphics, scaleFactor: cfloat, alpha: cfloat) {.header: juce_graphics, importcpp: "#.applyEffect(@)".}
proc `==`*(this: ImageEffectFilter, other: ImageEffectFilter): bool {.error: "juce::ImageEffectFilter defines no operator==; compare a property instead".}

proc makeDropShadow*(): DropShadow {.header: juce_graphics, importcpp: "juce::DropShadow(@)".}
proc makeDropShadow*(shadowColour: Colour, radius: cint, offset: Point[cint]): DropShadow {.header: juce_graphics, importcpp: "juce::DropShadow(@)".}
proc colour*(this: DropShadow): Colour {.header: juce_graphics, importcpp: "#.colour".}
proc colour*(this: var DropShadow): var Colour {.header: juce_graphics, importcpp: "#.colour".}
proc `colour=`*(this: var DropShadow, value: Colour) {.header: juce_graphics, importcpp: "#.colour = #".}
proc radius*(this: DropShadow): cint {.header: juce_graphics, importcpp: "#.radius".}
proc radius*(this: var DropShadow): var cint {.header: juce_graphics, importcpp: "#.radius".}
proc `radius=`*(this: var DropShadow, value: cint) {.header: juce_graphics, importcpp: "#.radius = #".}
proc offset*(this: DropShadow): Point[cint] {.header: juce_graphics, importcpp: "#.offset".}
proc offset*(this: var DropShadow): var Point[cint] {.header: juce_graphics, importcpp: "#.offset".}
proc `offset=`*(this: var DropShadow, value: Point[cint]) {.header: juce_graphics, importcpp: "#.offset = #".}
proc drawForImage*(this: DropShadow, g: var Graphics, srcImage: Image) {.header: juce_graphics, importcpp: "#.drawForImage(@)".}
proc drawForPath*(this: DropShadow, g: var Graphics, path: Path) {.header: juce_graphics, importcpp: "#.drawForPath(@)".}
proc drawForRectangle*(this: DropShadow, g: var Graphics, area: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.drawForRectangle(@)".}
proc `==`*(this: DropShadow, other: DropShadow): bool {.error: "juce::DropShadow defines no operator==; compare a property instead".}

proc makeDropShadowEffect*(): DropShadowEffect {.header: juce_graphics, importcpp: "juce::DropShadowEffect(@)".}
proc setShadowProperties*(this: var DropShadowEffect, newShadow: DropShadow) {.header: juce_graphics, importcpp: "#.setShadowProperties(@)".}
proc applyEffect*(this: var DropShadowEffect, sourceImage: var Image, destContext: var Graphics, scaleFactor: cfloat, alpha: cfloat) {.header: juce_graphics, importcpp: "#.applyEffect(@)".}
proc `==`*(this: DropShadowEffect, other: DropShadowEffect): bool {.error: "juce::DropShadowEffect defines no operator==; compare a property instead".}

proc makeGlowEffect*(): GlowEffect {.header: juce_graphics, importcpp: "juce::GlowEffect(@)".}
proc setGlowProperties*(this: var GlowEffect, newRadius: cfloat, newColour: Colour, offset: Point[cint]) {.header: juce_graphics, importcpp: "#.setGlowProperties(@)".}
proc applyEffect*(this: var GlowEffect, arg1: var Image, arg2: var Graphics, scaleFactor: cfloat, alpha: cfloat) {.header: juce_graphics, importcpp: "#.applyEffect(@)".}
proc `==`*(this: GlowEffect, other: GlowEffect): bool {.error: "juce::GlowEffect defines no operator==; compare a property instead".}

proc `==`*(this: ImagePixelDataNativeExtensions, other: ImagePixelDataNativeExtensions): bool {.error: "juce::ImagePixelDataNativeExtensions defines no operator==; compare a property instead".}

proc maskPixelComponents*(x: uint32): uint32 {.header: juce_graphics, importcpp: "juce::maskPixelComponents(@)".}
proc clampPixelComponents*(x: uint32): uint32 {.header: juce_graphics, importcpp: "juce::clampPixelComponents(@)".}




include juce_graphics_lifting

proc `$`*(this: Path): string = $this.toString()
proc `$`*(this: Colour): string = $this.toString()
proc `$`*(this: FontFeatureTag): string = $this.toString()
proc `$`*(this: Font): string = $this.toString()

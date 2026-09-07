# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.


# Everything the generator can express now lives in juce_graphics.nim, including
# the Rectangle overloads and the constructors. What stays here is ergonomics it
# has no way to infer.

# Justification is a class wrapping a flag set, so drawText would otherwise need
# makeJustification(JustificationFlags_centred.cint) at every call site.
#
# noinit is required, not cosmetic: Nim value-initialises a proc's result, and
# for an importcpp type that emits `juce::Justification result{}`. Justification
# has no default constructor, so the C++ compiler rejects it. Any proc returning
# a JUCE type that lacks a default constructor needs this.
converter toJustification*(flags: JustificationFlags): Justification {.noinit.} =
    makeJustification(flags.cint)

# Declared here rather than beside the types in june_juce_types: String is not
# declared until juce_core, which is included after it, and $ on a String comes
# from juce_core_lifting, later still. Nim's default $ prints "()" for an
# importcpp object, which declares no fields.
proc toString*[T](this: Rectangle[T]): String {.header: juce_graphics, importcpp: "#.toString()".}
proc toString*[T](this: Point[T]): String {.header: juce_graphics, importcpp: "#.toString()".}

proc `$`*[T](this: Rectangle[T]): string = $this.toString()
proc `$`*[T](this: Point[T]): string = $this.toString()


# Subclasses for the abstract classes of this module. Generated; see
# tools/generate_subclasses.py.
include juce_graphics_subclasses

# Both expose a C++ iterator with no Nim spelling. The indexed accessors give
# the same loop, and both hand back a reference, so the receiver is var.

iterator items*(this: var GlyphArrangement): var PositionedGlyph =
    for index in 0 ..< this.getNumGlyphs():
        yield this.getGlyph(index)

iterator items*(this: var TextLayout): var TextLayoutLine =
    for index in 0 ..< this.getNumLines():
        yield this.getLine(index)

# A transform is APPLIED through the point or the rectangle, not through the
# transform: AffineTransform's own transformPoint takes its arguments by
# reference and writes back through them, which has no Nim spelling that reads
# well. These are the const forms JUCE gives Point and Rectangle for that job.
#
# They live here rather than beside the other Point methods in
# june_juce_types.nim because AffineTransform is declared in the generated
# juce_graphics bindings, which that file is compiled before.
proc transformedBy*[T](this: Point[T], transform: AffineTransform): Point[T]
    {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.transformedBy(@)".}
proc transformedBy*[T](this: Rectangle[T],
                       transform: AffineTransform): Rectangle[T]
    {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.transformedBy(@)".}

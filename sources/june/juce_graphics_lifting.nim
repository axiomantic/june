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


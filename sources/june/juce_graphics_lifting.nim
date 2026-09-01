# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.


# Rectangle-taking overloads ==================================================
#
# The generator emits these commented out, because it cannot spell a template.

# Not a {.constructor.}: that pragma makes Nim ignore the importcpp pattern and
# emit Image(args) verbatim, losing the cast the PixelFormat parameter needs.
proc makeImage*(format: cint, width: cint, height: cint, clearImage: bool): Image {.header: juce_graphics, importcpp: "juce::Image((juce::Image::PixelFormat)#, @)".}
proc makeGraphics*(imageToDrawOnto: Image): Graphics {.header: juce_graphics, importcpp: "juce::Graphics(@)", constructor.}

const
    ImagePixelFormat_RGB* = 1.cint
    ImagePixelFormat_ARGB* = 2.cint
    ImagePixelFormat_SingleChannel* = 3.cint

# Constructors are not generated at all, so the ones the tests and examples need
# are declared here.
proc makeColour*(r: uint8, g: uint8, b: uint8, a: uint8): Colour {.header: juce_graphics, importcpp: "juce::Colour(@)", constructor.}

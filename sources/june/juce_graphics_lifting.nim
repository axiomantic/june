# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# Geometry ====================================================================
#
# These are C++ class templates, so they are bound by hand rather than
# generated: the generator has no notion of a template. Instantiate them with
# cint or cfloat, never Nim's int or float. Nim substitutes the parameter's C++
# name into the template, and Nim's int is 64-bit, so Point[int] would ask for
# juce::Point<long long>, which JUCE never instantiates.

type
    Point*[T] {.header: juce_graphics, importcpp: "juce::Point".} = object
    Rectangle*[T] {.header: juce_graphics, importcpp: "juce::Rectangle".} = object
    Line*[T] {.header: juce_graphics, importcpp: "juce::Line".} = object
    BorderSize*[T] {.header: juce_graphics, importcpp: "juce::BorderSize".} = object

# Point
proc makePoint*[T](): Point[T] {.header: juce_graphics, importcpp: "juce::Point<'*0>()", constructor.}
proc makePoint*[T](x: T, y: T): Point[T] {.header: juce_graphics, importcpp: "juce::Point<'*0>(@)", constructor.}

proc getX*[T](this: Point[T]): T {.header: juce_graphics, importcpp: "#.getX()".}
proc getY*[T](this: Point[T]): T {.header: juce_graphics, importcpp: "#.getY()".}
proc setX*[T](this: var Point[T], newX: T) {.header: juce_graphics, importcpp: "#.setX(@)".}
proc setY*[T](this: var Point[T], newY: T) {.header: juce_graphics, importcpp: "#.setY(@)".}
proc withX*[T](this: Point[T], newX: T): Point[T] {.header: juce_graphics, importcpp: "#.withX(@)".}
proc withY*[T](this: Point[T], newY: T): Point[T] {.header: juce_graphics, importcpp: "#.withY(@)".}
proc isOrigin*[T](this: Point[T]): bool {.header: juce_graphics, importcpp: "#.isOrigin()".}
proc translated*[T](this: Point[T], deltaX: T, deltaY: T): Point[T] {.header: juce_graphics, importcpp: "#.translated(@)".}
proc distanceFrom*[T](this: Point[T], other: Point[T]): T {.header: juce_graphics, importcpp: "#.getDistanceFrom(@)".}
proc toFloat*[T](this: Point[T]): Point[cfloat] {.header: juce_graphics, importcpp: "#.toFloat()".}
proc toInt*[T](this: Point[T]): Point[cint] {.header: juce_graphics, importcpp: "#.toInt()".}

# Rectangle
proc makeRectangle*[T](): Rectangle[T] {.header: juce_graphics, importcpp: "juce::Rectangle<'*0>()", constructor.}
proc makeRectangle*[T](width: T, height: T): Rectangle[T] {.header: juce_graphics, importcpp: "juce::Rectangle<'*0>(@)", constructor.}
proc makeRectangle*[T](x: T, y: T, width: T, height: T): Rectangle[T] {.header: juce_graphics, importcpp: "juce::Rectangle<'*0>(@)", constructor.}

proc getX*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getX()".}
proc getY*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getY()".}
proc getWidth*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getWidth()".}
proc getHeight*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getHeight()".}
proc getRight*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getRight()".}
proc getBottom*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getBottom()".}
proc getCentreX*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getCentreX()".}
proc getCentreY*[T](this: Rectangle[T]): T {.header: juce_graphics, importcpp: "#.getCentreY()".}
proc isEmpty*[T](this: Rectangle[T]): bool {.header: juce_graphics, importcpp: "#.isEmpty()".}
proc contains*[T](this: Rectangle[T], point: Point[T]): bool {.header: juce_graphics, importcpp: "#.contains(@)".}
proc contains*[T](this: Rectangle[T], other: Rectangle[T]): bool {.header: juce_graphics, importcpp: "#.contains(@)".}
proc intersects*[T](this: Rectangle[T], other: Rectangle[T]): bool {.header: juce_graphics, importcpp: "#.intersects(@)".}
proc getIntersection*[T](this: Rectangle[T], other: Rectangle[T]): Rectangle[T] {.header: juce_graphics, importcpp: "#.getIntersection(@)".}
proc getUnion*[T](this: Rectangle[T], other: Rectangle[T]): Rectangle[T] {.header: juce_graphics, importcpp: "#.getUnion(@)".}
proc withX*[T](this: Rectangle[T], newX: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.withX(@)".}
proc withY*[T](this: Rectangle[T], newY: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.withY(@)".}
proc withWidth*[T](this: Rectangle[T], newWidth: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.withWidth(@)".}
proc withHeight*[T](this: Rectangle[T], newHeight: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.withHeight(@)".}
proc translated*[T](this: Rectangle[T], deltaX: T, deltaY: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.translated(@)".}
proc expanded*[T](this: Rectangle[T], delta: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.expanded(@)".}
proc reduced*[T](this: Rectangle[T], delta: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.reduced(@)".}
proc getCentre*[T](this: Rectangle[T]): Point[T] {.header: juce_graphics, importcpp: "#.getCentre()".}
proc getPosition*[T](this: Rectangle[T]): Point[T] {.header: juce_graphics, importcpp: "#.getPosition()".}
proc toFloat*[T](this: Rectangle[T]): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.toFloat()".}
proc toNearestInt*[T](this: Rectangle[T]): Rectangle[cint] {.header: juce_graphics, importcpp: "#.toNearestInt()".}

# The layout idiom: each of these mutates the rectangle and returns the slice
# taken off it, so a component lays its children out by repeatedly carving.
proc removeFromTop*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.removeFromTop(@)".}
proc removeFromBottom*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.removeFromBottom(@)".}
proc removeFromLeft*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.removeFromLeft(@)".}
proc removeFromRight*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: juce_graphics, importcpp: "#.removeFromRight(@)".}

# Line
proc makeLine*[T](startX: T, startY: T, endX: T, endY: T): Line[T] {.header: juce_graphics, importcpp: "juce::Line<'*0>(@)", constructor.}
proc getStart*[T](this: Line[T]): Point[T] {.header: juce_graphics, importcpp: "#.getStart()".}
proc getEnd*[T](this: Line[T]): Point[T] {.header: juce_graphics, importcpp: "#.getEnd()".}
proc getLength*[T](this: Line[T]): T {.header: juce_graphics, importcpp: "#.getLength()".}

# BorderSize
proc makeBorderSize*[T](topAndBottom: T, leftAndRight: T): BorderSize[T] {.header: juce_graphics, importcpp: "juce::BorderSize<'*0>(@)", constructor.}
proc getTop*[T](this: BorderSize[T]): T {.header: juce_graphics, importcpp: "#.getTop()".}
proc getBottom*[T](this: BorderSize[T]): T {.header: juce_graphics, importcpp: "#.getBottom()".}
proc getLeft*[T](this: BorderSize[T]): T {.header: juce_graphics, importcpp: "#.getLeft()".}
proc getRight*[T](this: BorderSize[T]): T {.header: juce_graphics, importcpp: "#.getRight()".}

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

proc getBounds*(this: Image): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getBounds()".}
proc getBounds*(this: Path): Rectangle[cfloat] {.header: juce_graphics, importcpp: "#.getBounds()".}

proc fillRect*(this: Graphics, area: Rectangle[cint]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc fillRect*(this: Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillRect(@)".}
proc drawRect*(this: Graphics, area: Rectangle[cint], lineThickness: cint = 1) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc drawRect*(this: Graphics, area: Rectangle[cfloat], lineThickness: cfloat = 1.0) {.header: juce_graphics, importcpp: "#.drawRect(@)".}
proc fillEllipse*(this: Graphics, area: Rectangle[cfloat]) {.header: juce_graphics, importcpp: "#.fillEllipse(@)".}
proc drawEllipse*(this: Graphics, area: Rectangle[cfloat], lineThickness: cfloat) {.header: juce_graphics, importcpp: "#.drawEllipse(@)".}
proc reduceClipRegion*(this: var Graphics, area: Rectangle[cint]): bool {.header: juce_graphics, importcpp: "#.reduceClipRegion(@)".}
proc getClipBounds*(this: Graphics): Rectangle[cint] {.header: juce_graphics, importcpp: "#.getClipBounds()".}

proc getPixelAt*(this: Image, x: cint, y: cint): Colour {.header: juce_graphics, importcpp: "#.getPixelAt(@)".}

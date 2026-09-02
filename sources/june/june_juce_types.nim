# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# JUCE's class templates, bound by hand because the generator cannot spell a
# template. They live ahead of the generated modules because those reference
# them: a proc taking Rectangle[cint] cannot be declared before Rectangle exists.

# Header paths are spelled out rather than bound to a const: every module is
# included into one scope, and the generated modules declare those names.

# Range
type
    Range*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range".} = object

proc makeRange*[T](): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>()", constructor.}
proc makeRange*[T](startValue: T, endValue: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>(@)", constructor.}
proc makeRange*[T](other: Range[T]): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>(@)", constructor.}

proc between*[T](this: typedesc[Range[T]], position1: T, position2: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>::between(@)".}
proc withStartAndLength*[T](this: typedesc[Range[T]], startValue: T, length: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>::withStartAndLength(@)".}
proc emptyRange*[T](this: typedesc[Range[T]], start: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>::emptyRange(@)".}
proc findMinAndMax*[T](this: typedesc[Range[T]], values: ptr T, numValues: cint): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Range<'*0>::findMinAndMax(@)".}

# Bind == explicitly. Without it Nim falls back to structural equality, and an
# importcpp object declares no fields, so it compares nothing and reports every
# two values equal. != follows from == by derivation.
proc `==`*[T](this: Range[T], other: Range[T]): bool {.header: "<juce_core/juce_core.h>", importcpp: "# == #".}

proc getStart*[T](this: Range[T]): T {.header: "<juce_core/juce_core.h>", importcpp: "#.getStart(@)".}
proc getLength*[T](this: Range[T]): T {.header: "<juce_core/juce_core.h>", importcpp: "#.getLength(@)".}
proc getEnd*[T](this: Range[T]): T {.header: "<juce_core/juce_core.h>", importcpp: "#.getEnd(@)".}
proc isEmpty*[T](this: Range[T]): bool {.header: "<juce_core/juce_core.h>", importcpp: "#.isEmpty()".}
proc setStart*[T](this: Range[T], newStart: T) {.header: "<juce_core/juce_core.h>", importcpp: "#.setStart(@)".}
proc withStart*[T](this: Range[T], newStart: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.withStart(@)".}
proc movedToStartAt*[T](this: Range[T], newStart: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.movedToStartAt(@)".}
proc setEnd*[T](this: Range[T], newEnd: T) {.header: "<juce_core/juce_core.h>", importcpp: "#.setEnd(@)".}
proc withEnd*[T](this: Range[T], newEnd: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.withEnd(@)".}
proc movedToEndAt*[T](this: Range[T], newEnd: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.movedToEndAt(@)".}
proc setLength*[T](this: Range[T], newLength: T) {.header: "<juce_core/juce_core.h>", importcpp: "#.setLength(@)".}
proc withLength*[T](this: Range[T], newLength: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.withLength(@)".}
proc expanded*[T](this: Range[T], amount: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.expanded(@)".}
proc contains*[T](this: Range[T], position: T): bool {.header: "<juce_core/juce_core.h>", importcpp: "#.contains(@)".}
proc clipValue*[T](this: Range[T], value: T): T {.header: "<juce_core/juce_core.h>", importcpp: "#.clipValue(@)".}
proc contains*[T](this: Range[T], other: Range[T]): bool {.header: "<juce_core/juce_core.h>", importcpp: "#.contains(@)".}
proc intersects*[T](this: Range[T], other: Range[T]): bool {.header: "<juce_core/juce_core.h>", importcpp: "#.intersects(@)".}
proc getIntersectionWith*[T](this: Range[T], other: Range[T]): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.getIntersectionWith(@)".}
proc getUnionWith*[T](this: Range[T], other: Range[T]): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.getUnionWith(@)".}
proc getUnionWith*[T](this: Range[T], valueToInclude: T): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.getUnionWith(@)".}
proc constrainRange*[T](this: Range[T], rangeToConstrain: Range[T]): Range[T] {.header: "<juce_core/juce_core.h>", importcpp: "#.constrainRange(@)".}

# Geometry ====================================================================
#
# These are C++ class templates, so they are bound by hand rather than
# generated: the generator has no notion of a template. Instantiate them with
# cint or cfloat, never Nim's int or float. Nim substitutes the parameter's C++
# name into the template, and Nim's int is 64-bit, so Point[int] would ask for
# juce::Point<long long>, which JUCE never instantiates.

type
    Point*[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Point".} = object
    Rectangle*[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Rectangle".} = object
    Line*[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Line".} = object
    BorderSize*[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::BorderSize".} = object

# Point
proc makePoint*[T](): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Point<'*0>()", constructor.}
proc makePoint*[T](x: T, y: T): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Point<'*0>(@)", constructor.}

proc `==`*[T](this: Point[T], other: Point[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "# == #".}

proc getX*[T](this: Point[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getX()".}
proc getY*[T](this: Point[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getY()".}
proc setX*[T](this: var Point[T], newX: T) {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.setX(@)".}
proc setY*[T](this: var Point[T], newY: T) {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.setY(@)".}
proc withX*[T](this: Point[T], newX: T): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.withX(@)".}
proc withY*[T](this: Point[T], newY: T): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.withY(@)".}
proc isOrigin*[T](this: Point[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.isOrigin()".}
proc translated*[T](this: Point[T], deltaX: T, deltaY: T): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.translated(@)".}
proc distanceFrom*[T](this: Point[T], other: Point[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getDistanceFrom(@)".}
proc toFloat*[T](this: Point[T]): Point[cfloat] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.toFloat()".}
proc toInt*[T](this: Point[T]): Point[cint] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.toInt()".}

# Rectangle
proc makeRectangle*[T](): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Rectangle<'*0>()", constructor.}
proc makeRectangle*[T](width: T, height: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Rectangle<'*0>(@)", constructor.}
proc makeRectangle*[T](x: T, y: T, width: T, height: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Rectangle<'*0>(@)", constructor.}

proc `==`*[T](this: Rectangle[T], other: Rectangle[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "# == #".}

proc getX*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getX()".}
proc getY*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getY()".}
proc getWidth*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getWidth()".}
proc getHeight*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getHeight()".}
proc getRight*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getRight()".}
proc getBottom*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getBottom()".}
proc getCentreX*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getCentreX()".}
proc getCentreY*[T](this: Rectangle[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getCentreY()".}
proc isEmpty*[T](this: Rectangle[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.isEmpty()".}
proc contains*[T](this: Rectangle[T], point: Point[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.contains(@)".}
proc contains*[T](this: Rectangle[T], other: Rectangle[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.contains(@)".}
proc intersects*[T](this: Rectangle[T], other: Rectangle[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.intersects(@)".}
proc getIntersection*[T](this: Rectangle[T], other: Rectangle[T]): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getIntersection(@)".}
proc getUnion*[T](this: Rectangle[T], other: Rectangle[T]): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getUnion(@)".}
proc withX*[T](this: Rectangle[T], newX: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.withX(@)".}
proc withY*[T](this: Rectangle[T], newY: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.withY(@)".}
proc withWidth*[T](this: Rectangle[T], newWidth: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.withWidth(@)".}
proc withHeight*[T](this: Rectangle[T], newHeight: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.withHeight(@)".}
proc translated*[T](this: Rectangle[T], deltaX: T, deltaY: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.translated(@)".}
proc expanded*[T](this: Rectangle[T], delta: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.expanded(@)".}
proc reduced*[T](this: Rectangle[T], delta: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.reduced(@)".}
proc getCentre*[T](this: Rectangle[T]): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getCentre()".}
proc getPosition*[T](this: Rectangle[T]): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getPosition()".}
proc toFloat*[T](this: Rectangle[T]): Rectangle[cfloat] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.toFloat()".}
proc toNearestInt*[T](this: Rectangle[T]): Rectangle[cint] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.toNearestInt()".}

# The layout idiom: each of these mutates the rectangle and returns the slice
# taken off it, so a component lays its children out by repeatedly carving.
proc removeFromTop*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.removeFromTop(@)".}
proc removeFromBottom*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.removeFromBottom(@)".}
proc removeFromLeft*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.removeFromLeft(@)".}
proc removeFromRight*[T](this: var Rectangle[T], amount: T): Rectangle[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.removeFromRight(@)".}

# Line
proc makeLine*[T](startX: T, startY: T, endX: T, endY: T): Line[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Line<'*0>(@)", constructor.}
proc `==`*[T](this: Line[T], other: Line[T]): bool {.header: "<juce_graphics/juce_graphics.h>", importcpp: "# == #".}

proc getStart*[T](this: Line[T]): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getStart()".}
proc getEnd*[T](this: Line[T]): Point[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getEnd()".}
proc getLength*[T](this: Line[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getLength()".}

# BorderSize
#
# JUCE declares a four-gap constructor and a one-gap one, and nothing between.
# The binding here used to take two - a top-and-bottom and a left-and-right -
# which named a constructor that does not exist, so it never compiled for
# anyone who called it.
proc makeBorderSize*[T](): BorderSize[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::BorderSize<'*0>()", constructor.}
proc makeBorderSize*[T](allGaps: T): BorderSize[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::BorderSize<'*0>(@)", constructor.}
proc makeBorderSize*[T](top: T, left: T, bottom: T, right: T): BorderSize[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::BorderSize<'*0>(@)", constructor.}
proc getTop*[T](this: BorderSize[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getTop()".}
proc getBottom*[T](this: BorderSize[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getBottom()".}
proc getLeft*[T](this: BorderSize[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getLeft()".}
proc getRight*[T](this: BorderSize[T]): T {.header: "<juce_graphics/juce_graphics.h>", importcpp: "#.getRight()".}

# Containers ==================================================================

type
    Array*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Array".} = object
    OwnedArray*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::OwnedArray".} = object
    ReferenceCountedObjectPtr*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::ReferenceCountedObjectPtr".} = object
    Span*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Span".} = object
    HeapBlock*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::HeapBlock".} = object
    WeakReference*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::WeakReference".} = object
    OptionalScopedPointer*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::OptionalScopedPointer".} = object
    RectangleList*[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::RectangleList".} = object
    Parallelogram*[T] {.header: "<juce_graphics/juce_graphics.h>", importcpp: "juce::Parallelogram".} = object

# Array
# HeapBlock is JUCE's owning raw buffer. It is move-only, so it takes the same
# treatment as UniquePtr: copying is a compile error, and the destructor is
# left to C++.
proc `=copy`*[T](dst: var HeapBlock[T], src: HeapBlock[T]) {.error: "a HeapBlock cannot be copied".}
proc `=destroy`*[T](this: var HeapBlock[T]) = discard

proc makeHeapBlock*[T](): HeapBlock[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::HeapBlock<'*0>()".}
proc makeHeapBlock*[T](numElements: csize_t): HeapBlock[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::HeapBlock<'*0>(@)".}
proc `[]`*[T](this: HeapBlock[T], index: cint): T {.importcpp: "#[#]".}
proc `[]=`*[T](this: var HeapBlock[T], index: cint, value: T) {.importcpp: "#[#] = #".}
proc get*[T](this: HeapBlock[T]): ptr T {.importcpp: "#.get()".}
proc isNil*[T](this: HeapBlock[T]): bool {.importcpp: "(#.get() == nullptr)".}
proc calloc*[T](this: var HeapBlock[T], numElements: csize_t) {.importcpp: "#.calloc(@)".}

# A weak reference goes nil when what it points at is deleted, which is the
# whole reason to hold one.
proc get*[T](this: WeakReference[T]): ptr T {.importcpp: "#.get()".}
proc wasObjectDeleted*[T](this: WeakReference[T]): bool {.importcpp: "#.wasObjectDeleted()".}
proc isNil*[T](this: WeakReference[T]): bool {.importcpp: "(#.get() == nullptr)".}

# OptionalScopedPointer may or may not own what it points at, so like the other
# owning wrappers it cannot be copied.
proc `=copy`*[T](dst: var OptionalScopedPointer[T], src: OptionalScopedPointer[T]) {.error: "an OptionalScopedPointer cannot be copied".}
proc `=destroy`*[T](this: var OptionalScopedPointer[T]) = discard
proc get*[T](this: OptionalScopedPointer[T]): ptr T {.importcpp: "#.get()".}
proc release*[T](this: var OptionalScopedPointer[T]): ptr T {.importcpp: "#.release()".}
proc isNil*[T](this: OptionalScopedPointer[T]): bool {.importcpp: "(#.get() == nullptr)".}

proc size*[T](this: Array[T]): cint {.importcpp: "#.size()".}
proc isEmpty*[T](this: Array[T]): bool {.importcpp: "#.isEmpty()".}
proc `[]`*[T](this: Array[T], index: cint): T {.importcpp: "#[#]".}
proc getFirst*[T](this: Array[T]): T {.importcpp: "#.getFirst()".}
proc getLast*[T](this: Array[T]): T {.importcpp: "#.getLast()".}
proc indexOf*[T](this: Array[T], element: T): cint {.importcpp: "#.indexOf(@)".}
proc contains*[T](this: Array[T], element: T): bool {.importcpp: "#.contains(@)".}
proc add*[T](this: var Array[T], element: T) {.importcpp: "#.add(@)".}
proc clear*[T](this: var Array[T]) {.importcpp: "#.clear()".}

iterator items*[T](this: Array[T]): T =
  for index in 0.cint ..< this.size():
    yield this[index]

# OwnedArray holds pointers it owns, so indexing yields a ptr rather than a value.
proc size*[T](this: OwnedArray[T]): cint {.importcpp: "#.size()".}
proc isEmpty*[T](this: OwnedArray[T]): bool {.importcpp: "#.isEmpty()".}
proc `[]`*[T](this: OwnedArray[T], index: cint): ptr T {.importcpp: "#[#]".}

iterator items*[T](this: OwnedArray[T]): ptr T =
  for index in 0.cint ..< this.size():
    yield this[index]

# ReferenceCountedObjectPtr
proc get*[T](this: ReferenceCountedObjectPtr[T]): ptr T {.importcpp: "#.get()".}
proc isNil*[T](this: ReferenceCountedObjectPtr[T]): bool {.importcpp: "(# == nullptr)".}

# Span
proc size*[T](this: Span[T]): csize_t {.importcpp: "#.size()".}
proc isEmpty*[T](this: Span[T]): bool {.importcpp: "#.empty()".}
proc `[]`*[T](this: Span[T], index: csize_t): T {.importcpp: "#[#]".}

iterator items*[T](this: Span[T]): T =
  for index in 0.csize_t ..< this.size():
    yield this[index]

# RectangleList
#
# The accessors were here without a constructor, so the type could be named -
# fillRectList and reduceClipRegion both take one - and never built.
proc makeRectangleList*[T](): RectangleList[T] {.importcpp: "juce::RectangleList<'*0>()", constructor.}
proc makeRectangleList*[T](rect: Rectangle[T]): RectangleList[T] {.importcpp: "juce::RectangleList<'*0>(@)", constructor.}

proc getNumRectangles*[T](this: RectangleList[T]): cint {.importcpp: "#.getNumRectangles()".}
proc getRectangle*[T](this: RectangleList[T], index: cint): Rectangle[T] {.importcpp: "#.getRectangle(@)".}
proc isEmpty*[T](this: RectangleList[T]): bool {.importcpp: "#.isEmpty()".}
proc getBounds*[T](this: RectangleList[T]): Rectangle[T] {.importcpp: "#.getBounds()".}
proc add*[T](this: var RectangleList[T], rect: Rectangle[T]) {.importcpp: "#.add(@)".}
proc clear*[T](this: var RectangleList[T]) {.importcpp: "#.clear()".}

iterator items*[T](this: RectangleList[T]): Rectangle[T] =
  for index in 0.cint ..< this.getNumRectangles():
    yield this.getRectangle(index)

# SparseSet
type
    SparseSet*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::SparseSet".} = object

proc isEmpty*[T](this: SparseSet[T]): bool {.importcpp: "#.isEmpty()".}
proc size*[T](this: SparseSet[T]): T {.importcpp: "#.size()".}
proc `[]`*[T](this: SparseSet[T], index: T): T {.importcpp: "#[#]".}
proc contains*[T](this: SparseSet[T], valueToLookFor: T): bool {.importcpp: "#.contains(@)".}
proc getNumRanges*[T](this: SparseSet[T]): cint {.importcpp: "#.getNumRanges()".}
proc getRange*[T](this: SparseSet[T], rangeIndex: cint): Range[T] {.importcpp: "#.getRange(@)".}
proc getTotalRange*[T](this: SparseSet[T]): Range[T] {.importcpp: "#.getTotalRange()".}

# NormalisableRange maps a value onto 0..1, which is how a Slider describes its
# range.
type
    NormalisableRange*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::NormalisableRange".} = object

proc makeNormalisableRange*[T](rangeStart: T, rangeEnd: T): NormalisableRange[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::NormalisableRange<'*0>(@)".}
proc convertTo0to1*[T](this: NormalisableRange[T], v: T): T {.importcpp: "#.convertTo0to1(@)".}
proc convertFrom0to1*[T](this: NormalisableRange[T], v: T): T {.importcpp: "#.convertFrom0to1(@)".}
proc snapToLegalValue*[T](this: NormalisableRange[T], v: T): T {.importcpp: "#.snapToLegalValue(@)".}
proc getRange*[T](this: NormalisableRange[T]): Range[T] {.importcpp: "#.getRange()".}

# JUCE's own Optional, distinct from std::optional in june_stl.
type
    Optional*[T] {.header: "<juce_core/juce_core.h>", importcpp: "juce::Optional".} = object

proc hasValue*[T](this: Optional[T]): bool {.importcpp: "#.hasValue()".}
proc value*[T](this: Optional[T]): T {.importcpp: "(*#)".}
proc reset*[T](this: var Optional[T]) {.importcpp: "#.reset()".}


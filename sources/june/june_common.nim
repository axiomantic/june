# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

import std/strutils

type
  #wcharConstImpl {.importc:"const wchar_t*".} = object
  cstringConstImpl {.importc:"const char*".} = cstring
  voidpConstImpl {.importc:"const void*".} = pointer
  #juce_wchar* = distinct wcharConstImpl
  constChar* = distinct cstringConstImpl

  # C++'s wchar_t, which Nim has no type for. An alias to uint32 carrying the
  # C name: the width is right on the platforms this binds, and the C++ name is
  # what a pointer to it has to be spelled as. Nim converts to and from uint32
  # without a cast, so a caller sees an ordinary codepoint.
  #
  # Spelling it uint32 instead made every binding taking a wchar_t* uncallable,
  # because C++ does not convert `unsigned int*` to `wchar_t*`.
  WChar* {.importc: "wchar_t", nodecl.} = uint32
  constPointer* = distinct voidpConstImpl


converter toConstChar*(text: string): constChar = cast[constChar](text.cstring)


# A pointer to const, which Nim has no type for. `ptr T` is mutable, and C++
# does not convert `const T*` to `T*`, so binding a method that returns one as
# `ptr T` produced a proc that could not be called at all: 25 of them sat in the
# generated files, uncompiled, because an importcpp string only reaches the C++
# compiler at a call site.
#
# It is distinct rather than an alias so that nothing implicitly turns it back
# into a `ptr T`. `[]` yields the value for reading, which is enough to call any
# method JUCE declares const and is refused for one taking `var T` - which is
# exactly what the C++ const means.
type ConstPtr*[T] {.importcpp: "const '0 *", nodecl.} = object

proc isNil*[T](p: ConstPtr[T]): bool {.importcpp: "(# == nullptr)", nodecl.}
proc `[]`*[T](p: ConstPtr[T]): lent T {.importcpp: "(*#)", nodecl.}
proc `==`*[T](a: ConstPtr[T], b: ConstPtr[T]): bool {.importcpp: "(# == #)", nodecl.}

proc cnew*[T](x: T): ptr T {.importcpp: "(new '*0#@)", nodecl.}
proc cdelete*[T](x: ptr T) {.importcpp: "(delete @)", nodecl.}

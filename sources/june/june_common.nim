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


proc cnew*[T](x: T): ptr T {.importcpp: "(new '*0#@)", nodecl.}
proc cdelete*[T](x: ptr T) {.importcpp: "(delete @)", nodecl.}

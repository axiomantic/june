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
# C++ converts a `T*` to a `const T*` on its own, so the mixed comparison is
# the one a caller reaches for: a container of ConstPtr holds the same objects
# something else handed back as a plain pointer.
proc `==`*[T](a: ConstPtr[T], b: ptr T): bool {.importcpp: "(# == #)", nodecl.}
proc `==`*[T](a: ptr T, b: ConstPtr[T]): bool {.importcpp: "(# == #)", nodecl.}

# `#@` splices the CONSTRUCTOR'S arguments into `new T ...`, and it puts no
# separator between the first and the rest: a two-argument constructor reaches
# clang as `new juce::FileInputSource(fileNIM_FALSE)`. So cnew is good for a
# construction of at most one argument, which is every use the library has.
#
# The alternative, `(new '*0(@))`, wraps the whole expression instead - and
# C++17 elides the temporary, so it costs nothing and works for any arity. It
# is not used because it then needs the argument to BE the construction: given
# a Nim value of the type, it asks for a copy, and the classes this is most
# useful for are exactly the ones that delete theirs.
#
# A class whose heap form is worth having anyway gets a named `new...` binding
# of its own; newFileInputSource in juce_core_lifting is the first.
proc cnew*[T](x: T): ptr T {.importcpp: "(new '*0#@)", nodecl.}
proc cdelete*[T](x: ptr T) {.importcpp: "(delete @)", nodecl.}

# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# JUCE's public interface returns and accepts a handful of C++ standard library
# types. Nim emits C++, so the C++ compiler runs their destructors at scope exit
# and none of these need a destructor hook of their own; writing one that called
# the C++ destructor would free twice.

type
  UniquePtr*[T] {.header: "<memory>", importcpp: "std::unique_ptr<'0>", bycopy.} = object
  CppOptional*[T] {.header: "<optional>", importcpp: "std::optional<'0>", bycopy.} = object
  CppVector*[T] {.header: "<vector>", importcpp: "std::vector<'0>", bycopy.} = object

# A unique_ptr is the sole owner of its pointee, so copying one in Nim would
# compile into a C++ copy that does not exist. Reject it at compile time.
proc `=copy`*[T](dst: var UniquePtr[T], src: UniquePtr[T]) {.error: "a UniquePtr cannot be copied".}

proc get*[T](this: UniquePtr[T]): ptr T {.importcpp: "#.get()".}
proc release*[T](this: var UniquePtr[T]): ptr T {.importcpp: "#.release()".}
proc reset*[T](this: var UniquePtr[T]) {.importcpp: "#.reset()".}
proc isNil*[T](this: UniquePtr[T]): bool {.importcpp: "(# == nullptr)".}

proc hasValue*[T](this: CppOptional[T]): bool {.importcpp: "#.has_value()".}
proc value*[T](this: CppOptional[T]): T {.importcpp: "#.value()".}
proc valueOr*[T](this: CppOptional[T], fallback: T): T {.importcpp: "#.value_or(@)".}

proc size*[T](this: CppVector[T]): csize_t {.importcpp: "#.size()".}
proc `[]`*[T](this: CppVector[T], index: csize_t): T {.importcpp: "#[#]".}

iterator items*[T](this: CppVector[T]): T =
  for index in 0 ..< this.size():
    yield this[index]

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
  CppString* {.header: "<string>", importcpp: "std::string", bycopy.} = object
  # Bound so that JUCEApplication's unhandledException can be overridden. The
  # only thing worth reading off one is its message.
  CppException* {.header: "<exception>", importcpp: "std::exception", inheritable, pure.} = object
  # Opaque: the only things C++ offers on one are comparison and a name whose
  # spelling is implementation defined.
  CppTypeIndex* {.header: "<typeindex>", importcpp: "std::type_index", bycopy.} = object
  # std::byte is a distinct type in C++ rather than an alias for a character,
  # so it needs its own binding: a Nim uint8 does not convert to one.
  CppByte* {.header: "<cstddef>", importcpp: "std::byte".} = distinct uint8
  CppMap*[K, V] {.header: "<map>", importcpp: "std::map<'0, '1>", bycopy.} = object
  CppUnorderedMap*[K, V] {.header: "<unordered_map>", importcpp: "std::unordered_map<'0, '1>", bycopy.} = object
  # The size is a value rather than a type, so it is a static parameter: Nim
  # writes the literal into the pattern where a type would otherwise go.
  CppArray*[T; N: static int] {.header: "<array>", importcpp: "std::array<'0, '1>", bycopy.} = object

# A unique_ptr is the sole owner of its pointee, so copying one in Nim would
# compile into a C++ copy that does not exist. Reject it at compile time.
proc `=copy`*[T](dst: var UniquePtr[T], src: UniquePtr[T]) {.error: "a UniquePtr cannot be copied".}

# Declaring =copy makes Nim synthesise the other lifetime hooks, and the
# synthesised =destroy is emitted for the uninstantiated generic: it comes out
# as `std::unique_ptr<'0>&`, with the pattern never substituted, and does not
# compile. Supplying an empty one keeps Nim from writing that. It has nothing to
# do: the value is a C++ object, so its own destructor runs at scope exit.
proc `=destroy`*[T](this: var UniquePtr[T]) = discard

proc get*[T](this: UniquePtr[T]): ptr T {.importcpp: "#.get()".}
proc release*[T](this: var UniquePtr[T]): ptr T {.importcpp: "#.release()".}
proc reset*[T](this: var UniquePtr[T]) {.importcpp: "#.reset()".}
proc isNil*[T](this: UniquePtr[T]): bool {.importcpp: "(# == nullptr)".}

# `'0` is the return type, so the pattern names std::optional<T> once rather
# than wrapping the already-optional return type in another one.
proc makeCppOptional*[T](value: T): CppOptional[T] {.importcpp: "'0(@)", header: "<optional>".}
proc makeCppOptionalEmpty*[T](): CppOptional[T] {.importcpp: "'0()", header: "<optional>".}

proc hasValue*[T](this: CppOptional[T]): bool {.importcpp: "#.has_value()".}
proc value*[T](this: CppOptional[T]): T {.importcpp: "#.value()".}
proc valueOr*[T](this: CppOptional[T], fallback: T): T {.importcpp: "#.value_or(@)".}

proc what*(this: CppException): constChar {.importcpp: "#.what()".}

proc `==`*(this: CppTypeIndex, other: CppTypeIndex): bool {.importcpp: "(# == #)".}
proc `<`*(this: CppTypeIndex, other: CppTypeIndex): bool {.importcpp: "(# < #)".}
proc name*(this: CppTypeIndex): constChar {.importcpp: "#.name()".}

proc toCppByte*(value: uint8): CppByte {.importcpp: "std::byte{#}", header: "<cstddef>".}
proc toUint8*(value: CppByte): uint8 {.importcpp: "std::to_integer<unsigned char>(#)", header: "<cstddef>".}

proc size*[K, V](this: CppMap[K, V]): csize_t {.importcpp: "#.size()".}
proc isEmpty*[K, V](this: CppMap[K, V]): bool {.importcpp: "#.empty()".}
proc contains*[K, V](this: CppMap[K, V], key: K): bool {.importcpp: "(#.count(#) > 0)".}
proc `[]`*[K, V](this: CppMap[K, V], key: K): V {.importcpp: "#.at(#)".}
proc `[]=`*[K, V](this: var CppMap[K, V], key: K, value: V) {.importcpp: "#[#] = #".}
proc makeCppMap*[K, V](): CppMap[K, V] {.importcpp: "'0()", header: "<map>".}

proc size*[K, V](this: CppUnorderedMap[K, V]): csize_t {.importcpp: "#.size()".}
proc isEmpty*[K, V](this: CppUnorderedMap[K, V]): bool {.importcpp: "#.empty()".}
proc contains*[K, V](this: CppUnorderedMap[K, V], key: K): bool {.importcpp: "(#.count(#) > 0)".}
proc `[]`*[K, V](this: CppUnorderedMap[K, V], key: K): V {.importcpp: "#.at(#)".}
proc `[]=`*[K, V](this: var CppUnorderedMap[K, V], key: K, value: V) {.importcpp: "#[#] = #".}
proc makeCppUnorderedMap*[K, V](): CppUnorderedMap[K, V] {.importcpp: "'0()", header: "<unordered_map>".}

proc len*[T; N: static int](this: CppArray[T, N]): int = N
proc `[]`*[T; N: static int](this: CppArray[T, N], index: csize_t): T {.importcpp: "#[#]".}

iterator items*[T; N: static int](this: CppArray[T, N]): T =
    for index in 0 ..< N:
        yield this[index.csize_t]

proc size*[T](this: CppVector[T]): csize_t {.importcpp: "#.size()".}
proc `[]`*[T](this: CppVector[T], index: csize_t): T {.importcpp: "#[#]".}

iterator items*[T](this: CppVector[T]): T =
  for index in 0 ..< this.size():
    yield this[index]

# std::string. JUCE's String.toStdString returns one, which is the usual way out
# to another C++ library.
# c_str returns a const char*, and Nim's cstring is char*, so the constness has
# to be cast away. Nothing writes through it.
proc cStr*(this: CppString): cstring {.importcpp: "const_cast<char*>(#.c_str())".}
proc len*(this: CppString): csize_t {.importcpp: "#.size()".}
proc isEmpty*(this: CppString): bool {.importcpp: "#.empty()".}
proc `==`*(this: CppString, other: CppString): bool {.importcpp: "# == #".}
proc `$`*(this: CppString): string = $this.cStr()


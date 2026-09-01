# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# String
# fromUTF8 takes an explicit byte count, which the plain constructors do not.
proc makeStringFromUTF8*(text: cstring, bufferSizeBytes: int = -1): String {.header: juce_core, importcpp: "juce::String::fromUTF8(@)".}

proc toRawUTF8*(this: String): string =
    result = newString(this.length())
    copyMem(result.cstring, cast[ptr char](this.toRawUTF8Impl()), this.length())

proc `$`*(text: String): string = text.toRawUTF8

# JUCE declares these as free functions, and the generator only sees members, so
# they arrive as the no-equality guard rather than as operators.
proc `==`*(this: String, other: String): bool {.header: juce_core, importcpp: "# == #".}
proc `<`*(this: String, other: String): bool {.header: juce_core, importcpp: "# < #".}
proc `==`*(this: juce_var, other: juce_var): bool {.header: juce_core, importcpp: "# == #".}

converter toJuceString*(text: string): String = makeString(text)
# No implicit String -> string. With toJuceString going the other way, any
# mixed comparison had two equally good paths and Nim 1.6 and 2.0 call it
# ambiguous. Use $ to get a Nim string.

# StringRef
converter toStringRef*(text: String): StringRef = makeStringRef(text)
# StringRef does not own its characters, so this is only safe for the duration
# of the call it is passed to - the same contract StringRef has in C++.
converter toStringRef*(text: string): StringRef = makeStringRef(toConstChar(text))

#[
    Range& operator= (const Range&) = default;
    inline Range operator+= (const ValueType amountToAdd) noexcept
    inline Range operator-= (const ValueType amountToSubtract) noexcept
    constexpr Range operator+ (const ValueType amountToAdd) const noexcept
    constexpr Range operator- (const ValueType amountToSubtract) const noexcept
    constexpr bool operator== (Range other) const noexcept
    constexpr bool operator!= (Range other) const noexcept
]#

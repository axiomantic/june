# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# String
proc makeString*(text: cstring, bufferSizeByts: int = -1): String {.header: juce_core, importcpp: "juce::String::fromUTF8(@)".}

proc toRawUTF8*(this: String): string =
    result = newString(this.length())
    copyMem(result.cstring, cast[ptr char](this.toRawUTF8Impl()), this.length())

proc `$`*(text: String): string = text.toRawUTF8

converter toJuceString*(text: string): String = makeString(text)
converter toNimString*(text: String): string = text.toRawUTF8

# StringRef
proc makeStringRef*(text: cstring): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)", constructor.}
proc makeStringRef*(text: String): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)", constructor.}

converter toStringRef*(text: String): StringRef = makeStringRef(text)
converter toStringRef*(text: string): StringRef = makeStringRef(text.cstring)

#[
    Range& operator= (const Range&) = default;
    inline Range operator+= (const ValueType amountToAdd) noexcept
    inline Range operator-= (const ValueType amountToSubtract) noexcept
    constexpr Range operator+ (const ValueType amountToAdd) const noexcept
    constexpr Range operator- (const ValueType amountToSubtract) const noexcept
    constexpr bool operator== (Range other) const noexcept
    constexpr bool operator!= (Range other) const noexcept
]#

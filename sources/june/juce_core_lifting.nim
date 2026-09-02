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

# JUCE has no operator< taking two Strings: StringRef declares one taking a
# String, and there is a free one taking a String and a StringRef. Comparing
# two Strings reaches both through the same converter, so Nim calls it
# ambiguous. This one is an exact match and outranks both.
proc `<`*(this: String, other: String): bool {.header: juce_core, importcpp: "# < #".}

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

# The containers a caller loops over. JUCE exposes begin() and end() for some of
# these, which have no Nim spelling; the indexed accessors express the same loop.
iterator items*(this: StringArray): String =
    for index in 0 ..< this.size():
        yield this[index]

iterator items*(this: XmlElement): ptr XmlElement =
    for index in 0 ..< this.getNumChildElements():
        yield this.getChildElement(index)

# XmlElement's own attribute iterator is Iterator<AttributeIteratorTraits>, an
# alias over a class template with no Nim spelling. The indexed accessors give
# the same loop.
iterator attributes*(this: XmlElement): tuple[name: String, value: String] =
    for index in 0 ..< this.getNumAttributes():
        yield (this.getAttributeName(index), this.getAttributeValue(index))

iterator pairs*(this: NamedValueSet): tuple[name: Identifier, value: juce_var] =
    for index in 0 ..< this.size():
        yield (this.getName(index), this.getValueAt(index))


# SystemStats::CrashHandlerFunction is a plain C++ function pointer, which the
# generator cannot spell, so setApplicationCrashHandler is a comment there.
type CrashHandlerFunction* = proc(platformSpecificData: pointer) {.cdecl.}

proc setApplicationCrashHandler*(this: typedesc[SystemStats], handler: CrashHandlerFunction)
    {.header: juce_core, importcpp: "juce::SystemStats::setApplicationCrashHandler(@)".}

# Subclasses for the abstract classes of this module. Generated; see
# tools/generate_subclasses.py.
include juce_core_subclasses

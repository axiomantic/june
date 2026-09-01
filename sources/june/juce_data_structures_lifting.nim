# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# Iterating a ValueTree's children. JUCE offers begin() and end(), which have no
# Nim spelling, but the indexed accessors do the same job and let the loop be
# written the way a Nim programmer expects.
iterator items*(this: ValueTree): ValueTree =
    for index in 0 ..< this.getNumChildren():
        yield this.getChild(index)

iterator pairs*(this: ValueTree): tuple[index: cint, child: ValueTree] =
    for index in 0 ..< this.getNumChildren():
        yield (index, this.getChild(index))

# The properties of a ValueTree, which are otherwise reachable only by asking
# for a name at an index.
iterator properties*(this: ValueTree): tuple[name: Identifier, value: juce_var] =
    for index in 0 ..< this.getNumProperties():
        yield (this.getPropertyName(index), this.getProperty(this.getPropertyName(index)))

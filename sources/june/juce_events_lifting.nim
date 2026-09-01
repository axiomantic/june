# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

proc initialiseJuce_GUI*() {.header: juce_events, importcpp: "juce::initialiseJuce_GUI()".}
proc shutdownJuce_GUI*() {.header: juce_events, importcpp: "juce::shutdownJuce_GUI()".}

proc getInstance*(this: typedesc[MessageManager]): ptr MessageManager {.header: juce_events, importcpp: "juce::MessageManager::getInstance()".}

# callAsync is a C++ template taking any callable, so the generator cannot bind
# it. A std::function<void()> satisfies it, and that is what CppFunctionObjectN0
# already is. Returns false when the message manager has gone.
proc callAsync*(this: typedesc[MessageManager], callback: CppFunctionObjectN0): bool {.header: juce_events, importcpp: "juce::MessageManager::callAsync(@)".}

# Timer =======================================================================
#
# timerCallback is pure virtual, so a Timer cannot be instantiated at all
# without a subclass. That subclass had no way to exist before.

defineCppClassInternal CustomTimer of Timer:
    include "juce_events/juce_events.h"
    proc timerCallback() = discard

proc newCustomTimer*(): ptr CustomTimer {.importcpp: "(new june::CustomTimer)".}


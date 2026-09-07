# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

proc initialiseJuce_GUI*() {.header: juce_events, importcpp: "juce::initialiseJuce_GUI()".}
proc shutdownJuce_GUI*() {.header: juce_events, importcpp: "juce::shutdownJuce_GUI()".}

# callAsync is a C++ template taking any callable, so the generator cannot bind
# it. A std::function<void()> satisfies it, and that is what CppFunctionObjectN0
# already is. Returns false when the message manager has gone.
proc callAsync*(this: typedesc[MessageManager], callback: CppFunctionObjectN0): bool {.header: juce_events, importcpp: "juce::MessageManager::callAsync(@)".}

# The synchronous counterpart. callAsync queues and returns; this one blocks
# until the callback has run on the message thread and hands back what it
# returned. JUCE takes a plain function pointer rather than a std::function,
# which is a C++ function type the generator cannot spell, so it is written
# here instead.
type MessageCallbackFunction* = proc(userData: pointer): pointer {.cdecl.}

proc callFunctionOnMessageThread*(this: var MessageManager, callback: MessageCallbackFunction,
                                  userData: pointer): pointer
    {.header: juce_events, importcpp: "#.callFunctionOnMessageThread(@)".}

# Timer =======================================================================
#
# timerCallback is pure virtual, so a Timer cannot be instantiated at all
# without a subclass. That subclass had no way to exist before.

defineCppClassInternal CustomTimer of Timer:
    include "juce_events/juce_events.h"
    proc timerCallback() = discard

proc newCustomTimer*(): ptr CustomTimer {.importcpp: "(new june::CustomTimer)".}

# AsyncUpdater, ActionListener and ChangeListener =============================
#
# All three have a pure virtual, so none could be instantiated without a
# subclass, and no subclass was possible.

defineCppClassInternal CustomAsyncUpdater of AsyncUpdater:
    include "juce_events/juce_events.h"
    proc handleAsyncUpdate() = discard

proc newCustomAsyncUpdater*(): ptr CustomAsyncUpdater {.importcpp: "(new june::CustomAsyncUpdater)".}

defineCppClassInternal CustomActionListener of ActionListener:
    include "juce_events/juce_events.h"
    proc actionListenerCallback(message: constptr[String]) = discard

proc newCustomActionListener*(): ptr CustomActionListener {.importcpp: "(new june::CustomActionListener)".}

defineCppClassInternal CustomChangeListener of ChangeListener:
    include "juce_events/juce_events.h"
    proc changeListenerCallback(source: ptr ChangeBroadcaster) = discard

proc newCustomChangeListener*(): ptr CustomChangeListener {.importcpp: "(new june::CustomChangeListener)".}


# Subclasses for the abstract classes of this module. Generated; see
# tools/generate_subclasses.py.
include juce_events_subclasses

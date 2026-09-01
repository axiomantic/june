# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# JUCEApplication =============================================================

#dumpAstGen:
#  type
#    JUCEApplication* {.importcpp: "june::JUCEApplication".} = object of JUCEApplicationImpl
#      onGetApplicationName*: CppFunctionObjectR0[String] # proc(this: ptr JUCEApplication): String {.cdecl.}


defineCppClassInternal JUCEApplication of JUCEApplication:
    include "juce_gui_basics/juce_gui_basics.h"
    proc getApplicationName(): constval[String] = discard
    proc getApplicationVersion(): constval[String] = discard
    proc moreThanOneInstanceAllowed(): bool = discard
    proc anotherInstanceStarted(commandLine: constref[String]) = discard
    proc initialise(commandLine: constref[String]) = discard
    proc shutdown() = discard
    proc systemRequestedQuit() = discard
    proc suspended() = discard
    proc resumed() = discard

#[
type
  JUCEApplication* {.importcpp: "june::JUCEApplication".} = object of JUCEApplicationImpl
    onGetApplicationName*: CppFunctionObject(proc(): String) # proc(this: ptr JUCEApplication): String {.cdecl.}
    onGetApplicationVersion*: proc(this: ptr JUCEApplication): String {.cdecl.}
    onMoreThanOneInstanceAllowed*: proc(this: ptr JUCEApplication): bool {.cdecl.}
    onAnotherInstanceStarted*: proc(this: ptr JUCEApplication, commandLine: String) {.cdecl.}
    onInitialise*: proc(this: ptr JUCEApplication, commandLine: String) {.cdecl.}
    onShutdown*: proc(this: ptr JUCEApplication) {.cdecl.}
    onSystemRequestedQuit*: proc(this: ptr JUCEApplication) {.cdecl.}
    onSuspended*: proc(this: ptr JUCEApplication) {.cdecl.}
    onResumed*: proc(this: ptr JUCEApplication) {.cdecl.}
]#

proc newApplication*(): ptr JUCEApplication {.importcpp: "(new june::JUCEApplication)".}
proc constructApplication*(): JUCEApplication {.importcpp: "june::JUCEApplication()".}

proc quit*(this: var JUCEApplicationBase) {.header: juce_gui_basics, importcpp: "juce::JUCEApplication::quit()".}
proc getCommandLineParameterArray*(this: var JUCEApplicationBase): StringArray {.header: juce_gui_basics, importcpp: "juce::JUCEApplication::getCommandLineParameterArray()".}
proc getCommandLineParameters*(this: var JUCEApplicationBase): String {.header: juce_gui_basics, importcpp: "juce::JUCEApplication::getCommandLineParameters()".}

proc getInstance*(this: typedesc[JUCEApplication]): var JUCEApplication {.header: juce_gui_basics, importcpp: "(*dynamic_cast<june::JUCEApplication*>(juce::JUCEApplication::getInstance()))".}

# Document Window =============================================================

const DocumentWindow_minimiseButton* = 1
const DocumentWindow_maximiseButton* = 2
const DocumentWindow_closeButton* = 4
const DocumentWindow_allButtons* = 7

defineCppClassInternal DocumentWindow of DocumentWindow:
    include "juce_gui_basics/juce_gui_basics.h"
    proc closeButtonPressed() = discard

#type
#  DocumentWindow* {.importcpp: "june::DocumentWindow".} = object of DocumentWindowImpl
#    onCloseButtonPressed*: proc(this: ptr DocumentWindow) {.cdecl.}

proc newDocumentWindow*(name: String, colour: Colour, requiredButtons: int, addToDesktop: bool = true): ptr DocumentWindow {.importcpp: "(new june::DocumentWindow(@))".}

proc minimiseButton*(this: typedesc[DocumentWindow]): cint {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::minimiseButton".}
proc maximiseButton*(this: typedesc[DocumentWindow]): cint {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::maximiseButton".}
proc closeButton*(this: typedesc[DocumentWindow]): cint {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::closeButton".}
proc allButtons*(this: typedesc[DocumentWindow]): cint {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::allButtons".}

# Component ===================================================================
#
# Subclassing Component is what an ordinary JUCE app is built out of, and it was
# not possible: defineCppClass needs a generated june:: subclass to derive from,
# and only JUCEApplication and DocumentWindow had one.
#
# The subclass is named CustomComponent rather than taking the Component name.
# Component is the root of the widget hierarchy: renaming the generated type
# would make Button a sibling of Component rather than a Component, and
# `Button is Component` would stop holding.

defineCppClassInternal CustomComponent of Component:
    include "juce_gui_basics/juce_gui_basics.h"
    proc paint(g: varref[Graphics]) = discard
    proc resized() = discard
    proc moved() = discard
    proc visibilityChanged() = discard
    proc parentHierarchyChanged() = discard
    proc childrenChanged() = discard
    proc mouseDown(event: constptr[MouseEvent]) = discard
    proc mouseUp(event: constptr[MouseEvent]) = discard
    proc mouseDrag(event: constptr[MouseEvent]) = discard
    proc mouseMove(event: constptr[MouseEvent]) = discard
    proc mouseEnter(event: constptr[MouseEvent]) = discard
    proc mouseExit(event: constptr[MouseEvent]) = discard

proc newCustomComponent*(): ptr CustomComponent {.importcpp: "(new june::CustomComponent)".}

# paint receives a pointer because its C++ parameter is a mutable Graphics&,
# which a std::function cannot take by value - Graphics is not copyable.
#
# The binding goes through a typed temporary. Assigning the bindClosure call
# straight to the field makes Nim emit the importcpp pattern unsubstituted, as
# `std::function<void('0)>`, which does not compile. Binding it to a variable of
# the field's type first produces the right instantiation, so the wart lives
# here once instead of at every call site.
# Every handler is set through one of these rather than by assigning the field.
# Assigning a bindClosure call straight to a callback field makes Nim emit the
# importcpp pattern unsubstituted, as `std::function<void('0)>`, and emit broken
# #line directives. Binding to a variable of the field's type first produces the
# right instantiation, so the workaround lives here once.
template defineHandlerSetter(setterName, fieldName, ArgType: untyped) =
    proc setterName*(this: var CustomComponent, handler: proc(arg: ptr ArgType) {.closure.}) =
        let bound: CppFunctionObjectN1[ptr ArgType] = bindClosure(handler)
        this.fieldName = bound

defineHandlerSetter(setPaintHandler, onPaint, Graphics)
defineHandlerSetter(setMouseDownHandler, onMouseDown, MouseEvent)
defineHandlerSetter(setMouseUpHandler, onMouseUp, MouseEvent)
defineHandlerSetter(setMouseDragHandler, onMouseDrag, MouseEvent)
defineHandlerSetter(setMouseMoveHandler, onMouseMove, MouseEvent)
defineHandlerSetter(setMouseEnterHandler, onMouseEnter, MouseEvent)
defineHandlerSetter(setMouseExitHandler, onMouseExit, MouseEvent)

# Button ======================================================================
#
# paintButton is pure virtual, so a Button cannot be instantiated without a
# subclass either. Its constructor takes a name, which the generated subclass
# inherits through the using-declaration the macro emits.

defineCppClassInternal CustomButton of Button:
    include "juce_gui_basics/juce_gui_basics.h"
    proc paintButton(g: varref[Graphics], shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) = discard
    proc clicked() = discard
    proc buttonStateChanged() = discard

proc newCustomButton*(name: String): ptr CustomButton {.importcpp: "(new june::CustomButton(@))".}

proc setPaintButtonHandler*(this: var CustomButton,
                           handler: proc(g: ptr Graphics, highlighted: bool, down: bool) {.closure.}) =
    let bound: CppFunctionObjectN3[ptr Graphics, bool, bool] = bindClosure(handler)
    this.onPaintButton = bound

# Slider and Label ============================================================
#
# Neither has a pure virtual, so both can be used as they are. Subclassing is
# how an application reacts to them without wiring up a listener.

defineCppClassInternal CustomSlider of Slider:
    include "juce_gui_basics/juce_gui_basics.h"
    proc valueChanged() = discard
    proc startedDragging() = discard
    proc stoppedDragging() = discard

proc newCustomSlider*(): ptr CustomSlider {.importcpp: "(new june::CustomSlider)".}

defineCppClassInternal CustomLabel of Label:
    include "juce_gui_basics/juce_gui_basics.h"
    proc textWasEdited() = discard
    proc textWasChanged() = discard

proc newCustomLabel*(): ptr CustomLabel {.importcpp: "(new june::CustomLabel)".}


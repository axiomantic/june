
import june

{.emit: """/*INCLUDESECTION*/
#include <june.h>
""".}

# defineCppClass is the public macro, and nothing exercised it. A user subclasses
# one of the library's june:: classes with it, which is how an application is
# written; defineCppClassInternal is the library-side variant used above.
defineCppClass MyPanel of CustomComponent:
  discard

proc constructMyPanel(): MyPanel = MyPanel()

proc testUserSubclass() =
  initialiseJuce_GUI()
  block:
    let panel = cnew constructMyPanel()
    doAssert MyPanel is CustomComponent
    doAssert MyPanel is Component
    panel[].setBounds(makeRectangle(0.cint, 0.cint, 12.cint, 12.cint))
    doAssert panel[].getWidth() == 12
    cdelete panel
  shutdownJuce_GUI()

# The generator discarded the inheritance it computed, so every widget type was
# unrelated to Component and none of Component's methods reached it.
proc testInheritance() =
  doAssert Button is Component
  doAssert TextButton is Button
  doAssert TextButton is Component
  doAssert ResizableWindow is TopLevelWindow
  doAssert TopLevelWindow is Component
  doAssert Slider is Component

  # Inheritance is what makes Component's methods reachable from a widget.
  doAssert compiles(proc (b: var TextButton) = b.setVisible(true))
  doAssert compiles(proc (s: var Slider) = s.setBounds(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint)))

proc testEnums() =
  # Nested enums are spelled bare inside their own class, which is why they had
  # to be mapped per class rather than by qualified name alone.
  doAssert SliderSliderStyle_LinearHorizontal.cint != SliderSliderStyle_Rotary.cint
  doAssert ComponentFocusChangeType_focusChangedByMouseClick.cint >= 0

testInheritance()
testEnums()

# Subclassing a Component is what an ordinary JUCE app is built from, and it was
# not possible: defineCppClass needs a generated june:: subclass, and only
# JUCEApplication and DocumentWindow had one.
proc testCustomComponent() =
  let component = newCustomComponent()
  doAssert not isNil(component)
  doAssert CustomComponent is Component

  component[].setBounds(makeRectangle(0.cint, 0.cint, 40.cint, 30.cint))
  doAssert component[].getWidth() == 40
  doAssert component[].getHeight() == 30

  var paintCalls = 0
  component[].setPaintHandler(proc(g: ptr Graphics) =
    paintCalls += 1
    g[].setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))
    g[].fillRect(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint))
  )

  let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 30.cint, true)
  var graphics = makeGraphics(image)
  component[].paintEntireComponent(graphics, false)

  # JUCE called into Nim, and what Nim drew is in the image.
  doAssert paintCalls == 1
  doAssert image.getPixelAt(5.cint, 5.cint).getRed() == 255
  doAssert image.getPixelAt(20.cint, 20.cint).getRed() == 0

  cdelete component

testCustomComponent()

proc testMouseHandlers() =
  # Binding only. Delivering a real mouse event needs a MouseInputSource and a
  # desktop, so what is checked here is that the handlers bind and that their
  # C++ signatures match the virtuals they override - which is what fails when
  # they do not.
  let component = newCustomComponent()
  var events = 0
  component[].setMouseDownHandler(proc(e: ptr MouseEvent) = events += 1)
  component[].setMouseUpHandler(proc(e: ptr MouseEvent) = events += 1)
  component[].setMouseDragHandler(proc(e: ptr MouseEvent) = events += 1)
  component[].setMouseMoveHandler(proc(e: ptr MouseEvent) = events += 1)
  component[].setMouseEnterHandler(proc(e: ptr MouseEvent) = events += 1)
  component[].setMouseExitHandler(proc(e: ptr MouseEvent) = events += 1)
  doAssert events == 0
  cdelete component

testMouseHandlers()

# Button's paintButton is pure virtual, so a Button could not be instantiated at
# all without a subclass. Its constructor is protected, which is why the
# generated subclass declares a forwarding constructor rather than inheriting
# one: an inherited constructor keeps the base's access.
proc testCustomButton() =
  # Constructing a Button starts JUCE's timer infrastructure and its look and
  # feel singleton, both of which assert at exit unless the GUI was initialised.
  initialiseJuce_GUI()

  block:
    let button = newCustomButton("Press me")
    doAssert CustomButton is Button
    doAssert CustomButton is Component
    doAssert $button[].getButtonText() == "Press me"

    button[].setBounds(makeRectangle(0.cint, 0.cint, 30.cint, 20.cint))
    doAssert button[].getWidth() == 30

    var paintCalls = 0
    button[].setPaintButtonHandler(proc(g: ptr Graphics, highlighted: bool, down: bool) =
      paintCalls += 1
      g[].setColour(makeColour(0'u8, 255'u8, 0'u8, 255'u8))
      g[].fillRect(makeRectangle(0.cint, 0.cint, 8.cint, 8.cint))
    )

    let image = makeImage(ImagePixelFormat_ARGB, 30.cint, 20.cint, true)
    var graphics = makeGraphics(image)
    button[].paintEntireComponent(graphics, false)

    doAssert paintCalls == 1
    doAssert image.getPixelAt(4.cint, 4.cint).getGreen() == 255
    cdelete button

  shutdownJuce_GUI()

testCustomButton()

# bindClosure hands C++ the raw environment pointer without taking a reference to
# it, so a handler set from a scope that then exits used to have its captures
# collected out from under it. The failure was a corrupted capture rather than a
# crash, which is why it needed looking for.
proc setHandlerFromAScopeThatExits(component: ptr CustomComponent) =
  var captured = @[1, 2, 3, 4, 5, 6, 7, 8]
  component[].setPaintHandler(proc(g: ptr Graphics) =
    doAssert captured.len == 8, "the captured environment was collected"
    doAssert captured[7] == 8, "the captured environment was corrupted"
    g[].setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))
    g[].fillRect(makeRectangle(0.cint, 0.cint, 5.cint, 5.cint))
  )

# The same applies to a handler assigned straight to its field rather than
# through a setter, which is how the no-argument overrides are used.
proc setResizedHandlerFromAScopeThatExits(component: ptr CustomComponent, counter: ref int) =
  var captured = @[9, 8, 7, 6, 5, 4, 3, 2]
  component[].onResized = bindClosure(proc() =
    doAssert captured.len == 8, "the captured environment was collected"
    doAssert captured[0] == 9, "the captured environment was corrupted"
    counter[] += 1
  )

proc testClosureLifetime() =
  initialiseJuce_GUI()

  block:
    let component = newCustomComponent()
    component[].setBounds(makeRectangle(0.cint, 0.cint, 20.cint, 20.cint))
    setHandlerFromAScopeThatExits(component)

    # Churn the heap so a freed environment is likely to be reused.
    var noise: seq[seq[int]] = @[]
    for i in 0 ..< 2000:
      noise.add(@[i, i, i, i, i, i, i, i])
    GC_fullCollect()

    let image = makeImage(ImagePixelFormat_ARGB, 20.cint, 20.cint, true)
    var graphics = makeGraphics(image)
    component[].paintEntireComponent(graphics, false)
    doAssert image.getPixelAt(2.cint, 2.cint).getRed() == 255

    # And for a directly assigned handler.
    let resizes = new(int)
    setResizedHandlerFromAScopeThatExits(component, resizes)
    GC_fullCollect()
    component[].setBounds(makeRectangle(0.cint, 0.cint, 25.cint, 25.cint))
    doAssert resizes[] > 0, "the resized handler was not called"

    cdelete component

  shutdownJuce_GUI()

testClosureLifetime()

testUserSubclass()

# Slider and Label have no pure virtual, so both were usable already.
# Subclassing is how an application reacts to them without a listener.
proc testSliderAndLabel() =
  initialiseJuce_GUI()

  block:
    let slider = newCustomSlider()
    doAssert CustomSlider is Slider
    doAssert CustomSlider is Component

    var changes = 0
    slider[].onValueChanged = bindClosure(proc() = changes += 1)
    slider[].setRange(0.0, 10.0, 1.0)
    slider[].setValue(5.0, NotificationType_sendNotificationSync)

    doAssert slider[].getValue() == 5.0
    doAssert changes > 0, "valueChanged did not reach Nim"
    cdelete slider

  block:
    let label = newCustomLabel()
    doAssert CustomLabel is Label
    label[].setText("hi", NotificationType_dontSendNotification)
    doAssert $label[].getText() == "hi"
    cdelete label

  shutdownJuce_GUI()

testSliderAndLabel()


# LookAndFeel is how a JUCE application is themed. The assertion that matters is
# that an override installed from Nim is the one JUCE calls when it draws a
# widget, rather than the LookAndFeel_V4 drawing it would otherwise use.
proc testLookAndFeel() =
  initialiseJuce_GUI()

  var backgrounds = 0
  var labels = 0
  var rotaries = 0
  var rotaryWidth = 0.cint
  var rotaryEndAngle = 0.cfloat

  # Everything JUCE owns is destroyed inside this block. A juce::Button holds a
  # repeat timer, and destroying one after shutdownJuce_GUI trips the assertion
  # that a timer has outlived the platform event system.
  block:
    let laf = newCustomLookAndFeel()
    doAssert CustomLookAndFeel is LookAndFeel_V4
    doAssert CustomLookAndFeel is LookAndFeel

    laf[].setDrawButtonBackgroundHandler(
      proc(g: ptr Graphics, button: ptr Button, colour: ptr Colour,
           highlighted: bool, down: bool) = backgrounds += 1)
    laf[].setDrawLabelHandler(proc(g: ptr Graphics, label: ptr Label) = labels += 1)
    # The rotary handler is the one with cint and cfloat parameters, so it is
    # what checks that the C++ std::function and the Nim one agree on widths:
    # a mismatch either fails to compile or delivers garbage sizes.
    laf[].setDrawRotarySliderHandler(
      proc(g: ptr Graphics, x, y, width, height: cint,
           pos, startAngle, endAngle: cfloat, slider: ptr Slider) =
        rotaries += 1
        rotaryWidth = width
        rotaryEndAngle = endAngle)

    let image = makeImage(ImagePixelFormat_ARGB, 80.cint, 40.cint, true)
    var graphics = makeGraphics(image)

    # A TextButton rather than a CustomButton: drawButtonBackground is called
    # from TextButton::paintButton, which a CustomButton overrides.
    block:
      var button = makeTextButton()
      button.setLookAndFeel(laf)
      button.setBounds(0.cint, 0.cint, 80.cint, 20.cint)
      button.paintEntireComponent(graphics, false)
      button.setLookAndFeel(nil)

    block:
      var slider = makeSlider()
      slider.setSliderStyle(SliderSliderStyle_Rotary)
      slider.setLookAndFeel(laf)
      slider.setBounds(0.cint, 0.cint, 64.cint, 64.cint)
      slider.paintEntireComponent(graphics, false)
      slider.setLookAndFeel(nil)

    let label = newCustomLabel()
    label[].setLookAndFeel(laf)
    label[].setBounds(0.cint, 20.cint, 80.cint, 20.cint)
    label[].setText("hi", NotificationType_dontSendNotification)
    label[].paintEntireComponent(graphics, false)
    label[].setLookAndFeel(nil)
    cdelete label
    cdelete laf

  doAssert backgrounds > 0, "drawButtonBackground override was not called"
  doAssert labels > 0, "drawLabel override was not called"
  doAssert rotaries > 0, "drawRotarySlider override was not called"
  # A range rather than an exact width: JUCE passes the rotary area, which
  # excludes the text box, so the exact number is a layout detail. What is being
  # checked is that a cint and a cfloat survive the round trip as themselves --
  # a width disagreement shows up here as a wild number, not a near miss.
  doAssert rotaryWidth > 0 and rotaryWidth <= 64,
           "the cint width arrived as " & $rotaryWidth
  doAssert rotaryEndAngle > 0.0'f32 and rotaryEndAngle < 100.0'f32,
           "the cfloat end angle arrived as " & $rotaryEndAngle

  shutdownJuce_GUI()

testLookAndFeel()

# std::type_index, which AccessibilityHandler hands out. One cannot be built
# without a handler, so this checks the type is nameable and its operations are
# callable rather than comparing two real ones.
proc testTypeIndexBinding() =
  doAssert compiles(proc(handler: AccessibilityHandler): CppTypeIndex = handler.getTypeIndex())
  doAssert compiles(proc(a, b: CppTypeIndex): bool = a == b)
  doAssert compiles(proc(a: CppTypeIndex): constChar = a.name())

testTypeIndexBinding()

# A Slider listener. CustomSlider covers reacting to one slider; this is the
# other shape, one object watching several and told which one changed.
proc testSliderListener() =
  initialiseJuce_GUI()

  var changed = 0
  var lastWidth = 0.cint

  block:
    let listener = newCustomSliderListener()
    listener[].setSliderValueChangedHandler(proc(slider: ptr Slider) =
      changed += 1
      lastWidth = slider[].getWidth())

    var first = makeSlider()
    var second = makeSlider()
    first.setBounds(0.cint, 0.cint, 30.cint, 20.cint)
    second.setBounds(0.cint, 0.cint, 50.cint, 20.cint)
    first.addListener(cast[ptr SliderListener](listener))
    second.addListener(cast[ptr SliderListener](listener))

    first.setRange(0.0, 10.0, 1.0)
    first.setValue(3.0, NotificationType_sendNotificationSync)
    doAssert changed == 1, "the listener saw " & $changed & " changes"
    doAssert lastWidth == 30, "the wrong slider was reported: width " & $lastWidth

    second.setRange(0.0, 10.0, 1.0)
    second.setValue(4.0, NotificationType_sendNotificationSync)
    doAssert changed == 2, "one listener should hear both sliders"
    doAssert lastWidth == 50, "the second slider should be the one reported"

    first.removeListener(cast[ptr SliderListener](listener))
    first.setValue(9.0, NotificationType_sendNotificationSync)
    doAssert changed == 2, "removeListener did not detach it"

    second.removeListener(cast[ptr SliderListener](listener))
    cdelete listener

  shutdownJuce_GUI()

testSliderListener()

# LookAndFeel_V4's colour scheme is a nested class, so it had a type and no
# way to read or change anything on it. Theming a JUCE application is what it
# is for.
proc testColourSchemeMethods() =
  initialiseJuce_GUI()

  block:
    var lookAndFeel = makeLookAndFeel_V4()
    var scheme = lookAndFeel.getCurrentColourScheme()

    scheme.setUIColour(LookAndFeel_V4ColourSchemeUIColour_windowBackground,
                       makeColour(12'u8, 34'u8, 56'u8, 255'u8))
    let readBack = scheme.getUIColour(LookAndFeel_V4ColourSchemeUIColour_windowBackground)

    doAssert readBack.getRed() == 12'u8, "red came back as " & $readBack.getRed()
    doAssert readBack.getGreen() == 34'u8
    doAssert readBack.getBlue() == 56'u8

    # A different colour is untouched by the one just set.
    let other = scheme.getUIColour(LookAndFeel_V4ColourSchemeUIColour_defaultText)
    doAssert not (other.getRed() == 12'u8 and other.getGreen() == 34'u8 and
                  other.getBlue() == 56'u8), "setUIColour changed the wrong entry"

  shutdownJuce_GUI()

testColourSchemeMethods()

# PopupMenu::Options is a fluent builder, and a nested class: each with* method
# returns a fresh Options by value. It is the case that would catch a nested
# binding whose receiver or return type went to the wrong class.
proc testPopupMenuOptions() =
  initialiseJuce_GUI()

  let options = makePopupMenuOptions()
    .withMinimumWidth(220.cint)
    .withMaximumNumColumns(3.cint)
    .withTargetScreenArea(makeRectangle(10.cint, 20.cint, 30.cint, 40.cint))

  doAssert options.getMinimumWidth() == 220, "width came back as " & $options.getMinimumWidth()
  doAssert options.getTargetScreenArea().getX() == 10
  doAssert options.getTargetScreenArea().getHeight() == 40

  # Each step returns a new value rather than mutating in place.
  let narrower = options.withMinimumWidth(100.cint)
  doAssert options.getMinimumWidth() == 220, "the builder mutated the original"
  doAssert narrower.getMinimumWidth() == 100

  shutdownJuce_GUI()

testPopupMenuOptions()

# A public field was not bound at all, so a JUCE struct that is nothing but
# fields bound to nothing usable. Slider::RotaryParameters is two angles and a
# flag, and it is what setRotaryParameters takes.
proc testFieldAccessors() =
  initialiseJuce_GUI()

  block:
    # RotaryParameters declares no constructor of its own, so one comes from
    # the slider that already has a set of them.
    var slider = makeSlider()
    var parameters = slider.getRotaryParameters()
    parameters.startAngleRadians = 1.5'f32
    parameters.endAngleRadians = 4.5'f32
    parameters.stopAtEnd = true

    doAssert parameters.startAngleRadians == 1.5'f32,
             "start came back as " & $parameters.startAngleRadians
    doAssert parameters.endAngleRadians == 4.5'f32
    doAssert parameters.stopAtEnd

    # And JUCE reads the same memory back through its own API.
    slider.setRotaryParameters(parameters)
    let readBack = slider.getRotaryParameters()
    doAssert readBack.startAngleRadians == 1.5'f32,
             "JUCE read back " & $readBack.startAngleRadians
    doAssert readBack.endAngleRadians == 4.5'f32

  shutdownJuce_GUI()

testFieldAccessors()

# WeakReference goes nil when what it points at is deleted, which is the whole
# reason a drag-and-drop details struct holds one rather than a raw pointer.
proc testWeakReferenceField() =
  initialiseJuce_GUI()

  block:
    let component = newCustomComponent()
    var details = makeDragAndDropTargetSourceDetails(
      makejuce_var(1.cint), cast[ptr Component](component), makePoint(0.cint, 0.cint))

    doAssert not details.sourceComponent.isNil()
    doAssert details.sourceComponent.get() == cast[ptr Component](component)
    doAssert not details.sourceComponent.wasObjectDeleted()

    cdelete component
    doAssert details.sourceComponent.wasObjectDeleted(),
             "the weak reference did not notice the deletion"
    doAssert details.sourceComponent.isNil()

  shutdownJuce_GUI()

testWeakReferenceField()

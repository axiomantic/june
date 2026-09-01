
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

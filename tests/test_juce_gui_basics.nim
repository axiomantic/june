
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

# TextEditor is the largest untested widget at 121 bound procs. Everything here
# is state the editor holds, so none of it needs a window on screen.
proc testTextEditor() =
  initialiseJuce_GUI()

  block:
    var editor = makeTextEditor(makeString("editor"), 0'u16)
    doAssert editor.isEmpty()
    doAssert editor.getTotalNumChars() == 0

    editor.setText(makeString("hello world"), false)
    doAssert not editor.isEmpty()
    doAssert $editor.getText() == "hello world"
    doAssert editor.getTotalNumChars() == 11

    doAssert $editor.getTextInRange(makeRange(0.cint, 5.cint)) == "hello"

    editor.setHighlightedRegion(makeRange(6.cint, 11.cint))
    doAssert $editor.getHighlightedText() == "world",
             "the highlight gave " & $editor.getHighlightedText()

    editor.setCaretPosition(0.cint)
    editor.insertTextAtCaret(makeString(">> "))
    doAssert $editor.getText() == ">> hello world", "insert gave " & $editor.getText()

    editor.setReadOnly(true)
    doAssert editor.isReadOnly()
    editor.setMultiLine(true)
    doAssert editor.isMultiLine()

  shutdownJuce_GUI()

testTextEditor()

# ComboBox, the next largest at 62.
proc testComboBox() =
  initialiseJuce_GUI()

  block:
    var box = makeComboBox(makeString("choices"))
    doAssert box.getNumItems() == 0

    box.addItem(makeString("first"), 1.cint)
    box.addItem(makeString("second"), 2.cint)
    doAssert box.getNumItems() == 2
    doAssert $box.getItemText(0.cint) == "first"
    doAssert $box.getItemText(1.cint) == "second"

    doAssert box.getSelectedId() == 0, "nothing should be selected yet"
    box.setSelectedId(2.cint, NotificationType_dontSendNotification)
    doAssert box.getSelectedId() == 2
    doAssert $box.getText() == "second", "the box shows " & $box.getText()

    box.clear(NotificationType_dontSendNotification)
    doAssert box.getNumItems() == 0
    doAssert box.getSelectedId() == 0

  shutdownJuce_GUI()

testComboBox()

# FlexBox lays items out by computation, so it needs no window and every number
# is checkable. It also exercises the field accessors, which had no binding at
# all before: FlexItem is a struct whose API is its fields.
proc testFlexBoxLayout() =
  initialiseJuce_GUI()

  block:
    var box = makeFlexBox()

    # JUCE's FlexItem(w, h) records the size in currentBounds and the minimums
    # and leaves width and height as notAssigned, which is -1. Asserting that
    # rather than what the constructor looks like it does.
    var first = makeFlexItem(30.0'f32, 20.0'f32)
    doAssert first.width == -1.0'f32, "width was " & $first.width
    doAssert first.minWidth == 30.0'f32, "minWidth was " & $first.minWidth
    doAssert first.currentBounds.getWidth() == 30.0'f32

    # The layout uses width, so set it.
    first.width = 30.0'f32
    first.height = 20.0'f32
    var second = makeFlexItem(50.0'f32, 20.0'f32)
    second.width = 50.0'f32
    second.height = 20.0'f32

    # items is reached through the var getter, so this appends to the field
    # rather than to a copy of it.
    box.items.add(first)
    box.items.add(second)
    doAssert box.items.size() == 2, "the box holds " & $box.items.size() & " items"

    box.performLayout(makeRectangle(0.0'f32, 0.0'f32, 100.0'f32, 20.0'f32))

    # Laid out along a row, the second item starts where the first ends.
    let firstBounds = box.items[0.cint].currentBounds
    let secondBounds = box.items[1.cint].currentBounds
    doAssert firstBounds.getX() == 0.0'f32, "first x is " & $firstBounds.getX()
    doAssert firstBounds.getWidth() == 30.0'f32, "first width is " & $firstBounds.getWidth()
    doAssert secondBounds.getX() == 30.0'f32, "second x is " & $secondBounds.getX()
    doAssert secondBounds.getWidth() == 50.0'f32

  shutdownJuce_GUI()

testFlexBoxLayout()

# KeyPress and ModifierKeys ===================================================
#
# Both are value types built from an integer key code and a flag set, so they
# describe a keystroke without one having happened.

proc testKeyPress() =
    let modifiers = makeModifierKeys(ModifierKeysFlags_shiftModifier.cint)
    doAssert modifiers.isShiftDown(), "shiftModifier did not read back as shift"
    doAssert not makeModifierKeys().isShiftDown(), "empty modifiers reported shift"

    let press = makeKeyPress('a'.ord.cint, modifiers, uint16('a'))
    doAssert press.isValid(), "a constructed key press was invalid"
    doAssert press.getKeyCode() == 'a'.ord.cint, "key code was " & $press.getKeyCode()
    doAssert press.getTextCharacter() == uint16('a'), "text character did not survive"
    doAssert press.getModifiers().isShiftDown(), "the modifiers did not survive"

    # A default-constructed KeyPress describes no key at all.
    doAssert not makeKeyPress().isValid(), "a default KeyPress claimed to be valid"

    # The textual description round-trips through createFromDescription. JUCE
    # normalises the key to upper case on the way out ("shift + A"), so it is
    # the description that is stable across the trip, not the key code.
    let description = press.getTextDescription()
    let described = KeyPress.createFromDescription(description)
    doAssert $described.getTextDescription() == $description,
             "round trip turned " & $description & " into " & $described.getTextDescription()
    doAssert described.getModifiers().isShiftDown(), "the round trip lost shift"

testKeyPress()

# Grid ========================================================================
#
# The CSS-grid layout engine. Like FlexBox this needs no components on screen:
# performLayout writes the computed rectangle into each item's currentBounds.
# templateColumns, templateRows and items are all reached through the var field
# getters, so these append to the grid rather than to a copy of it.

proc testGridLayout() =
    initialiseJuce_GUI()

    block:
        var grid = makeGrid()
        grid.templateColumns.add(makeGridTrackInfo(makeGridPx(40.0'f32)))
        grid.templateColumns.add(makeGridTrackInfo(makeGridPx(40.0'f32)))
        grid.templateRows.add(makeGridTrackInfo(makeGridPx(30.0'f32)))
        grid.templateRows.add(makeGridTrackInfo(makeGridPx(30.0'f32)))
        doAssert grid.templateColumns.size() == 2,
                 "the grid has " & $grid.templateColumns.size() & " columns"

        for _ in 0 ..< 4:
            grid.items.add(makeGridItem())
        doAssert grid.items.size() == 4, "the grid holds " & $grid.items.size() & " items"

        grid.performLayout(makeRectangle(0.cint, 0.cint, 80.cint, 60.cint))

        # Two 40px columns by two 30px rows, filled in row-major order.
        let expected = [(0.0'f32, 0.0'f32), (40.0'f32, 0.0'f32),
                        (0.0'f32, 30.0'f32), (40.0'f32, 30.0'f32)]
        for index, (x, y) in expected:
            let bounds = grid.items[index.cint].currentBounds
            doAssert bounds.getX() == x,
                     "item " & $index & " x is " & $bounds.getX() & ", wanted " & $x
            doAssert bounds.getY() == y,
                     "item " & $index & " y is " & $bounds.getY() & ", wanted " & $y
            doAssert bounds.getWidth() == 40.0'f32,
                     "item " & $index & " width is " & $bounds.getWidth()
            doAssert bounds.getHeight() == 30.0'f32,
                     "item " & $index & " height is " & $bounds.getHeight()

    shutdownJuce_GUI()

testGridLayout()

# Viewport and Desktop ========================================================
#
# A Viewport scrolls a larger component behind a smaller window onto it. None of
# that needs the component to be visible on screen.

proc testViewportAndDesktop() =
    initialiseJuce_GUI()

    block:
        var viewport = makeViewport(makeString("scroller"))
        viewport.setSize(100.cint, 100.cint)
        doAssert viewport.getViewedComponent() == nil, "a fresh viewport had a viewed component"

        # The viewport takes ownership, so this is not freed here.
        var content = newCustomComponent()
        content[].setSize(400.cint, 400.cint)
        viewport.setViewedComponent(content, true)
        doAssert viewport.getViewedComponent() == cast[ptr Component](content),
                 "the viewport is showing a different component"

        # The visible window is smaller than the content, so it can scroll.
        doAssert viewport.getViewWidth() <= 100, "view width is " & $viewport.getViewWidth()

        viewport.setViewPosition(30.cint, 40.cint)
        doAssert viewport.getViewPositionX() == 30, "x is " & $viewport.getViewPositionX()
        doAssert viewport.getViewPositionY() == 40, "y is " & $viewport.getViewPositionY()

        # getInstance returns var Desktop, a C++ reference. Binding it with
        # `var d = ...` would copy, and Desktop's copy constructor is deleted,
        # so the singleton is called through directly.
        let original = Desktop.getInstance().getGlobalScaleFactor()
        Desktop.getInstance().setGlobalScaleFactor(2.0'f32)
        doAssert Desktop.getInstance().getGlobalScaleFactor() == 2.0'f32,
                 "scale factor is " & $Desktop.getInstance().getGlobalScaleFactor()
        Desktop.getInstance().setGlobalScaleFactor(original)

    shutdownJuce_GUI()

testViewportAndDesktop()

# Direct callback assignment ==================================================
#
# Assigning a bindClosure result straight to a callback field, with no typed
# temporary in between. The field's type is generic, which is the case that used
# to make Nim emit its importcpp pattern verbatim - `std::function<void('0)>` -
# and hand invalid C++ to the compiler. bindClosure is a template so that the
# type is first rendered here, at the call site. If it ever becomes a proc
# again, this file stops compiling. The returning shape, CppFunctionObjectR0,
# is covered the same way by the application handlers in the examples.

proc testDirectCallbackAssignment() =
    initialiseJuce_GUI()

    block:
        var painted = 0
        var component = newCustomComponent()
        component[].onPaint = bindClosure(proc(g: ptr Graphics) = inc painted)

        var resized = 0
        component[].onResized = bindClosure(proc() = inc resized)

        component[].setSize(10.cint, 10.cint)
        doAssert resized == 1, "resized ran " & $resized & " times"

        cdelete component

    shutdownJuce_GUI()

testDirectCallbackAssignment()

# ListBoxModel ================================================================
#
# getNumRows and paintListBoxItem are both pure virtual, so a ListBox could not
# be given a model at all before there was a subclass. getNumRows is also the
# only override in the library whose virtual returns a value, so this is what
# covers the generated forwarder's returning form: the callback's result when
# one is set, and a default-constructed value when none is.

proc testListBoxModel() =
    initialiseJuce_GUI()

    block:
        var model = newCustomListBoxModel()

        # No handler yet, so the forwarder takes its `else return {}` branch.
        doAssert model[].getNumRows() == 0,
                 "an unset callback returned " & $model[].getNumRows()

        model[].setNumRowsHandler(proc(): cint = 7)
        doAssert model[].getNumRows() == 7,
                 "getNumRows returned " & $model[].getNumRows()

        # And the same value arrives through the C++ virtual, called by JUCE
        # rather than by Nim.
        var box = makeListBox(makeString("list"), cast[ptr ListBoxModel](model))
        box.updateContent()
        doAssert box.getListBoxModel() == cast[ptr ListBoxModel](model),
                 "the box is holding a different model"
        doAssert box.getListBoxModel()[].getNumRows() == 7,
                 "through the box it is " & $box.getListBoxModel()[].getNumRows()

        cdelete model

    shutdownJuce_GUI()

testListBoxModel()

# Generated subclasses: construction ==========================================
#
# Every generated subclass, actually constructed. Compiling one is not evidence
# that it works, twice over. The generated C++ class has a template forwarding
# constructor, so `new june::CustomThread` is instantiated only where something
# calls it, and a class whose base has no default constructor builds cleanly
# right up until it is used. And a subclass that leaves an inherited pure
# virtual unimplemented is still abstract, which also only shows at the `new`.
#
# CustomJUCEApplicationBase is left out: its constructor asserts unless it is
# the process's one application instance, so constructing it here would be
# invalid by design rather than a defect in the binding.

proc testGeneratedSubclassesConstruct() =
    initialiseJuce_GUI()

    block:
        let value = newCustomHighResolutionTimer()
        doAssert not value.isNil, "newCustomHighResolutionTimer returned nil"
        cdelete value

    block:
        let value = newCustomInputSource()
        doAssert not value.isNil, "newCustomInputSource returned nil"
        cdelete value

    block:
        let value = newCustomInputStream()
        doAssert not value.isNil, "newCustomInputStream returned nil"
        cdelete value

    block:
        let value = newCustomLogger()
        doAssert not value.isNil, "newCustomLogger returned nil"
        cdelete value

    block:
        let value = newCustomOutputStream()
        doAssert not value.isNil, "newCustomOutputStream returned nil"
        cdelete value

    block:
        let value = newCustomTimeSliceClient()
        doAssert not value.isNil, "newCustomTimeSliceClient returned nil"
        cdelete value

    block:
        let value = newCustomUndoableAction()
        doAssert not value.isNil, "newCustomUndoableAction returned nil"
        cdelete value

    block:
        let value = newCustomCallbackMessage()
        doAssert not value.isNil, "newCustomCallbackMessage returned nil"
        cdelete value

    block:
        let value = newCustomInterprocessConnectionServer()
        doAssert not value.isNil, "newCustomInterprocessConnectionServer returned nil"
        cdelete value

    block:
        let value = newCustomMessageListener()
        doAssert not value.isNil, "newCustomMessageListener returned nil"
        cdelete value

    block:
        let value = newCustomMultiTimer()
        doAssert not value.isNil, "newCustomMultiTimer returned nil"
        cdelete value

    block:
        let value = newCustomImageEffectFilter()
        doAssert not value.isNil, "newCustomImageEffectFilter returned nil"
        cdelete value

    block:
        let value = newCustomImageFileFormat()
        doAssert not value.isNil, "newCustomImageFileFormat returned nil"
        cdelete value

    block:
        let value = newCustomImagePixelDataBackupExtensions()
        doAssert not value.isNil, "newCustomImagePixelDataBackupExtensions returned nil"
        cdelete value

    block:
        let value = newCustomImageType()
        doAssert not value.isNil, "newCustomImageType returned nil"
        cdelete value

    block:
        let value = newCustomAccessibilityCellInterface()
        doAssert not value.isNil, "newCustomAccessibilityCellInterface returned nil"
        cdelete value

    block:
        let value = newCustomAccessibilityNumericValueInterface()
        doAssert not value.isNil, "newCustomAccessibilityNumericValueInterface returned nil"
        cdelete value

    block:
        let value = newCustomAccessibilityRangedNumericValueInterface()
        doAssert not value.isNil, "newCustomAccessibilityRangedNumericValueInterface returned nil"
        cdelete value

    block:
        let value = newCustomAccessibilityTextInterface()
        doAssert not value.isNil, "newCustomAccessibilityTextInterface returned nil"
        cdelete value

    block:
        let value = newCustomAccessibilityTextValueInterface()
        doAssert not value.isNil, "newCustomAccessibilityTextValueInterface returned nil"
        cdelete value

    block:
        let value = newCustomAccessibilityValueInterface()
        doAssert not value.isNil, "newCustomAccessibilityValueInterface returned nil"
        cdelete value

    block:
        let value = newCustomApplicationCommandManagerListener()
        doAssert not value.isNil, "newCustomApplicationCommandManagerListener returned nil"
        cdelete value

    block:
        let value = newCustomApplicationCommandTarget()
        doAssert not value.isNil, "newCustomApplicationCommandTarget returned nil"
        cdelete value

    block:
        let value = newCustomBorderedComponentBoundsConstrainer()
        doAssert not value.isNil, "newCustomBorderedComponentBoundsConstrainer returned nil"
        cdelete value

    block:
        let value = newCustomBubbleComponent()
        doAssert not value.isNil, "newCustomBubbleComponent returned nil"
        cdelete value

    block:
        let value = newCustomCachedComponentImage()
        doAssert not value.isNil, "newCustomCachedComponentImage returned nil"
        cdelete value

    block:
        let value = newCustomComponentTraverser()
        doAssert not value.isNil, "newCustomComponentTraverser returned nil"
        cdelete value

    block:
        let value = newCustomDarkModeSettingListener()
        doAssert not value.isNil, "newCustomDarkModeSettingListener returned nil"
        cdelete value

    block:
        let value = newCustomDragAndDropTarget()
        doAssert not value.isNil, "newCustomDragAndDropTarget returned nil"
        cdelete value

    block:
        let value = newCustomDrawable()
        doAssert not value.isNil, "newCustomDrawable returned nil"
        cdelete value

    block:
        let value = newCustomDrawableShape()
        doAssert not value.isNil, "newCustomDrawableShape returned nil"
        cdelete value

    block:
        let value = newCustomFileBrowserListener()
        doAssert not value.isNil, "newCustomFileBrowserListener returned nil"
        cdelete value

    block:
        let value = newCustomFileDragAndDropTarget()
        doAssert not value.isNil, "newCustomFileDragAndDropTarget returned nil"
        cdelete value

    block:
        let value = newCustomFilePreviewComponent()
        doAssert not value.isNil, "newCustomFilePreviewComponent returned nil"
        cdelete value

    block:
        let value = newCustomFilenameComponentListener()
        doAssert not value.isNil, "newCustomFilenameComponentListener returned nil"
        cdelete value

    block:
        let value = newCustomFocusChangeListener()
        doAssert not value.isNil, "newCustomFocusChangeListener returned nil"
        cdelete value

    block:
        let value = newCustomKeyListener()
        doAssert not value.isNil, "newCustomKeyListener returned nil"
        cdelete value

    block:
        let value = newCustomMenuBarModel()
        doAssert not value.isNil, "newCustomMenuBarModel returned nil"
        cdelete value

    block:
        let value = newCustomTableListBoxModel()
        doAssert not value.isNil, "newCustomTableListBoxModel returned nil"
        cdelete value

    block:
        let value = newCustomTextDragAndDropTarget()
        doAssert not value.isNil, "newCustomTextDragAndDropTarget returned nil"
        cdelete value

    block:
        let value = newCustomTextInputTarget()
        doAssert not value.isNil, "newCustomTextInputTarget returned nil"
        cdelete value

    block:
        let value = newCustomToolbarItemFactory()
        doAssert not value.isNil, "newCustomToolbarItemFactory returned nil"
        cdelete value

    block:
        let value = newCustomTooltipClient()
        doAssert not value.isNil, "newCustomTooltipClient returned nil"
        cdelete value

    block:
        let value = newCustomTreeViewItem()
        doAssert not value.isNil, "newCustomTreeViewItem returned nil"
        cdelete value

    # The constructor that takes arguments, which needs a value each.
    block:
        let thread = newCustomThread(makeString("worker"), 0.csize_t)
        doAssert not thread.isNil, "newCustomThread returned nil"
        cdelete thread

    shutdownJuce_GUI()

testGeneratedSubclassesConstruct()

# TreeViewItem ================================================================
#
# mightContainSubItems is pure virtual, so a tree could not be populated from
# Nim at all. JUCE itself only asks it while painting or handling a click, both
# of which need an owner view on screen, so the call here is made through the
# binding: Nim calls the C++ virtual, which calls the std::function, which
# calls back into Nim. That is the whole path the override exists for.
#
# The items are not attached to a TreeView on purpose: a visible one builds an
# ItemComponent per row and, with no message loop running to tear them down,
# the leak detector reports them at exit.

proc testTreeViewItem() =
    initialiseJuce_GUI()

    block:
        var asked = 0
        var root = newCustomTreeViewItem()
        root[].setMightContainSubItemsHandler(proc(): bool =
            asked += 1
            true)

        var leaf = newCustomTreeViewItem()
        leaf[].setMightContainSubItemsHandler(proc(): bool = false)

        doAssert root[].mightContainSubItems(), "the root's handler did not answer"
        doAssert asked == 1, "the handler ran " & $asked & " times"
        doAssert not leaf[].mightContainSubItems(), "the leaf's handler did not answer"

        # The tree itself: a sub item is owned by the item it is added to.
        root[].addSubItem(cast[ptr TreeViewItem](leaf), -1.cint)
        doAssert root[].getNumSubItems() == 1,
                 "the root holds " & $root[].getNumSubItems() & " items"
        doAssert root[].getSubItem(0.cint) == cast[ptr TreeViewItem](leaf),
                 "the sub item is not the one that was added"

        root[].setOpen(true)
        doAssert root[].isOpen(), "the root did not open"

        # Deleting the root takes the sub item with it.
        cdelete root

    shutdownJuce_GUI()

testTreeViewItem()

# ScrollBar ===================================================================
#
# The scrolling model on its own: a range limit, a visible range inside it, and
# the clamping between them. None of it needs the bar on screen.

proc testScrollBar() =
    initialiseJuce_GUI()

    block:
        var bar = makeScrollBar(true)
        doAssert bar.isVertical(), "a vertical bar reported horizontal"

        bar.setRangeLimits(0.0, 100.0, NotificationType_dontSendNotification)
        doAssert bar.getMinimumRangeLimit() == 0.0, "minimum is " & $bar.getMinimumRangeLimit()
        doAssert bar.getMaximumRangeLimit() == 100.0, "maximum is " & $bar.getMaximumRangeLimit()

        bar.setCurrentRange(10.0, 20.0, NotificationType_dontSendNotification)
        doAssert bar.getCurrentRangeStart() == 10.0, "start is " & $bar.getCurrentRangeStart()
        doAssert bar.getCurrentRangeSize() == 20.0, "size is " & $bar.getCurrentRangeSize()

        # Moving the start keeps the size and stays inside the limits.
        bar.setCurrentRangeStart(50.0, NotificationType_dontSendNotification)
        doAssert bar.getCurrentRangeStart() == 50.0, "start is " & $bar.getCurrentRangeStart()
        doAssert bar.getCurrentRangeSize() == 20.0, "size changed to " & $bar.getCurrentRangeSize()

        # Past the end, JUCE clamps so the visible range still fits.
        bar.setCurrentRangeStart(1000.0, NotificationType_dontSendNotification)
        doAssert bar.getCurrentRangeStart() == 80.0,
                 "clamped start is " & $bar.getCurrentRangeStart()

    shutdownJuce_GUI()

testScrollBar()

# TableHeaderComponent, GridItem and PopupMenuItem ============================
#
# Three classes whose interesting parts are data rather than pixels: a column
# model, a layout item's properties, and a menu entry.

proc testTableHeaderColumns() =
    initialiseJuce_GUI()

    block:
        var header = makeTableHeaderComponent()
        doAssert header.getNumColumns(false) == 0, "a fresh header had columns"

        header.addColumn(makeString("Name"), 1.cint, 120.cint, 30.cint, -1.cint, 1.cint, -1.cint)
        header.addColumn(makeString("Size"), 2.cint, 80.cint, 30.cint, -1.cint, 1.cint, -1.cint)
        doAssert header.getNumColumns(false) == 2,
                 "the header holds " & $header.getNumColumns(false) & " columns"
        doAssert $header.getColumnName(1.cint) == "Name",
                 "column 1 is " & $header.getColumnName(1.cint)
        doAssert header.getColumnWidth(1.cint) == 120,
                 "column 1 is " & $header.getColumnWidth(1.cint) & " wide"

        header.setColumnName(1.cint, makeString("Renamed"))
        doAssert $header.getColumnName(1.cint) == "Renamed", "setColumnName did not take"

        header.setColumnWidth(2.cint, 200.cint)
        doAssert header.getColumnWidth(2.cint) == 200, "setColumnWidth did not take"

        header.removeColumn(1.cint)
        doAssert header.getNumColumns(false) == 1,
                 "after removal there are " & $header.getNumColumns(false)

        header.removeAllColumns()
        doAssert header.getNumColumns(false) == 0, "removeAllColumns left something"

    shutdownJuce_GUI()

proc testGridItemProperties() =
    var item = makeGridItem()
    doAssert item.associatedComponent() == nil, "a fresh GridItem had a component"
    doAssert item.order() == 0, "order started at " & $item.order()

    item.order = 3.cint
    doAssert item.order() == 3, "order is " & $item.order()

    # A GridItem built around a component remembers it.
    var component = newCustomComponent()
    var attached = makeGridItem(component)
    doAssert attached.associatedComponent() == cast[ptr Component](component),
             "the GridItem is holding a different component"
    cdelete component

proc testPopupMenuItem() =
    # The two constructors disagree on the id, and it is JUCE that does so: the
    # field is declared `int itemID = 0`, and Item(String) sets it to -1.
    doAssert makePopupMenuItem().itemID() == 0,
             "a default item had id " & $makePopupMenuItem().itemID()

    var item = makePopupMenuItem(makeString("Open"))
    doAssert $item.text() == "Open", "the item text is " & $item.text()
    doAssert item.itemID() == -1,
             "an item built from text had id " & $item.itemID()

    item.itemID = 7.cint
    doAssert item.itemID() == 7, "itemID is " & $item.itemID()

    item.text = makeString("Close")
    doAssert $item.text() == "Close", "the text did not change"

testTableHeaderColumns()
testGridItemProperties()
testPopupMenuItem()

# TabbedButtonBar =============================================================
#
# The tab strip's model: a list of named tabs and which one is current. None of
# it needs the bar on screen, though it does need the GUI subsystem for the
# buttons it builds per tab.

proc testTabbedButtonBar() =
    initialiseJuce_GUI()

    block:
        var bar = makeTabbedButtonBar(TabbedButtonBarOrientation_TabsAtTop)
        doAssert not bar.isVertical(), "tabs at the top reported vertical"
        doAssert bar.getNumTabs() == 0, "a fresh bar holds " & $bar.getNumTabs() & " tabs"

        let grey = makeColour(128'u8, 128'u8, 128'u8, 255'u8)
        bar.addTab(makeString("First"), grey, 0.cint)
        bar.addTab(makeString("Second"), grey, 1.cint)
        doAssert bar.getNumTabs() == 2, "the bar holds " & $bar.getNumTabs() & " tabs"
        doAssert bar.getTabNames().size() == 2, "getTabNames returned the wrong count"

        bar.setTabName(0.cint, makeString("Renamed"))
        doAssert $bar.getTabNames()[0.cint] == "Renamed",
                 "the first tab is " & $bar.getTabNames()[0.cint]

        bar.setCurrentTabIndex(1.cint, false)
        doAssert bar.getCurrentTabIndex() == 1,
                 "the current tab is " & $bar.getCurrentTabIndex()

        # An orientation change flips what isVertical reports.
        bar.setOrientation(TabbedButtonBarOrientation_TabsAtLeft)
        doAssert bar.isVertical(), "tabs at the left did not report vertical"

        bar.clearTabs()
        doAssert bar.getNumTabs() == 0, "clearTabs left " & $bar.getNumTabs()

    shutdownJuce_GUI()

testTabbedButtonBar()

# LookAndFeel_V2, at the pixels ===============================================
#
# The look and feel is almost entirely paint calls, so the only way to say
# anything about it is to give it a surface and read back what it drew. These
# call its methods directly rather than through a component, which is what
# makes them checkable without anything on screen.

proc testLookAndFeelDraws() =
    initialiseJuce_GUI()

    block:
        var feel = makeLookAndFeel_V2()
        let image = makeImage(ImagePixelFormat_ARGB, 60.cint, 40.cint, true)
        var context = makeGraphics(image)

        # Nothing has been drawn, so the surface is still transparent.
        doAssert image.getPixelAt(30.cint, 20.cint).getAlpha() == 0,
                 "a cleared image was not transparent"

        var button = newCustomButton(makeString("Press"))
        button[].setBounds(makeRectangle(0.cint, 0.cint, 60.cint, 40.cint))
        feel.drawButtonBackground(context, cast[ptr Button](button)[],
                                  makeColour(255'u8, 0'u8, 0'u8, 255'u8), false, false)

        # The background covers the middle of the button.
        doAssert image.getPixelAt(30.cint, 20.cint).getAlpha() > 0,
                 "drawButtonBackground left the surface transparent"

        cdelete button

    block:
        # The rotary slider draws into the area it is given and not outside it.
        var feel = makeLookAndFeel_V2()
        let image = makeImage(ImagePixelFormat_ARGB, 80.cint, 40.cint, true)
        var context = makeGraphics(image)
        var slider = newCustomSlider()
        slider[].setBounds(makeRectangle(0.cint, 0.cint, 40.cint, 40.cint))

        feel.drawRotarySlider(context, 0.cint, 0.cint, 40.cint, 40.cint,
                              0.5'f32, 0.0'f32, 3.14'f32, cast[ptr Slider](slider)[])

        doAssert image.getPixelAt(20.cint, 20.cint).getAlpha() > 0,
                 "drawRotarySlider left its own area transparent"
        doAssert image.getPixelAt(70.cint, 20.cint).getAlpha() == 0,
                 "drawRotarySlider drew outside the area it was given"

        cdelete slider

    shutdownJuce_GUI()

testLookAndFeelDraws()

# A Nim paint handler, called by JUCE ========================================
#
# The whole round trip in one assertion: JUCE's paintEntireComponent calls the
# generated subclass's paint override, which calls the std::function, which
# calls back into Nim, which draws - and the pixels on the surface are the
# proof it happened. Everything before this checked that a handler was reached;
# this checks that what it did reached the screen.

proc testPaintHandlerDraws() =
    initialiseJuce_GUI()

    block:
        var painted = 0
        var component = newCustomComponent()
        component[].setBounds(makeRectangle(0.cint, 0.cint, 20.cint, 20.cint))
        component[].setPaintHandler(proc(context: ptr Graphics) =
            painted += 1
            context[].setColour(makeColour(0'u8, 0'u8, 255'u8, 255'u8))
            context[].fillRect(makeRectangle(0.cint, 0.cint, 10.cint, 10.cint)))

        let image = makeImage(ImagePixelFormat_ARGB, 20.cint, 20.cint, true)
        var context = makeGraphics(image)
        component[].paintEntireComponent(context, false)

        doAssert painted == 1, "the paint handler ran " & $painted & " times"
        doAssert image.getPixelAt(5.cint, 5.cint).getBlue() == 255,
                 "what the Nim handler drew did not reach the surface"
        doAssert image.getPixelAt(15.cint, 15.cint).getAlpha() == 0,
                 "the handler painted outside the rectangle it asked for"

        cdelete component

    shutdownJuce_GUI()

testPaintHandlerDraws()

# The last uncalled subclass setter ===========================================
#
# CustomListBoxModel's paint setter had never been called. Its handler takes a
# Graphics pointer, so this draws through it and checks the pixels arrived -
# the same round trip the component paint handler makes.

proc testListBoxPaintHandler() =
    initialiseJuce_GUI()

    block:
        var painted = 0
        var model = newCustomListBoxModel()
        model[].setNumRowsHandler(proc(): cint = 1)
        model[].setPaintListBoxItemHandler(proc(rowNumber: cint, context: ptr Graphics,
                                                width, height: cint, rowIsSelected: bool) =
            painted += 1
            context[].setColour(makeColour(0'u8, 255'u8, 0'u8, 255'u8))
            context[].fillRect(makeRectangle(0.cint, 0.cint, width, height)))

        let image = makeImage(ImagePixelFormat_ARGB, 20.cint, 10.cint, true)
        var context = makeGraphics(image)
        model[].paintListBoxItem(0.cint, context, 20.cint, 10.cint, false)

        doAssert painted == 1, "the paint handler ran " & $painted & " times"
        doAssert image.getPixelAt(10.cint, 5.cint).getGreen() == 255,
                 "what the handler drew did not reach the surface"

        cdelete model

    shutdownJuce_GUI()

testListBoxPaintHandler()

# The command line getters ====================================================
#
# Static in JUCE and now static here. They used to take a JUCEApplicationBase
# receiver they never used, so reaching a function that needs no instance
# required having one.

proc testCommandLineGetters() =
    initialiseJuce_GUI()

    block:
        # No application has been started, so both are empty rather than wrong.
        doAssert $JUCEApplication.getCommandLineParameters() == "",
                 "the command line is " & $JUCEApplication.getCommandLineParameters()
        doAssert JUCEApplication.getCommandLineParameterArray().size() == 0,
                 "the argument array holds " &
                 $JUCEApplication.getCommandLineParameterArray().size()

    shutdownJuce_GUI()

testCommandLineGetters()

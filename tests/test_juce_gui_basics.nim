
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


# AccessibleState =============================================================
#
# A flag set built by chaining. Each with* returns a copy with one more flag
# set, so the test checks a flag it did not ask for is still clear - a builder
# that turned everything on would pass any check of the flag it just set.

proc testAccessibleState() =
    let plain = makeAccessibleState()
    doAssert not plain.isCheckable(), "a fresh state was already checkable"
    doAssert not plain.isFocused(), "a fresh state was already focused"

    let checkable = plain.withCheckable()
    doAssert checkable.isCheckable(), "withCheckable did not set the flag"
    doAssert not checkable.isChecked(), "withCheckable also set checked"
    doAssert not checkable.isFocused(), "withCheckable also set focused"
    doAssert not plain.isCheckable(), "withCheckable changed the state it came from"

    # Chaining accumulates rather than replacing.
    let both = plain.withCheckable().withFocused()
    doAssert both.isCheckable() and both.isFocused(), "chaining lost a flag"
    doAssert not both.isChecked(), "chaining set a flag nobody asked for"

# TabbedComponent =============================================================
#
# The tab strip with content panels behind it. Its depth and orientation are
# plain settings; the tabs themselves own the components they are given.

proc testTabbedComponent() =
    initialiseJuce_GUI()

    block:
        var tabs = makeTabbedComponent(TabbedButtonBarOrientation_TabsAtTop)
        doAssert tabs.getNumTabs() == 0, "a fresh component holds " & $tabs.getNumTabs()

        tabs.setTabBarDepth(24.cint)
        doAssert tabs.getTabBarDepth() == 24, "the depth is " & $tabs.getTabBarDepth()

        let grey = makeColour(128'u8, 128'u8, 128'u8, 255'u8)
        tabs.addTab(makeString("One"), grey, newCustomComponent(), true, -1.cint)
        tabs.addTab(makeString("Two"), grey, newCustomComponent(), true, -1.cint)
        doAssert tabs.getNumTabs() == 2, "the component holds " & $tabs.getNumTabs() & " tabs"
        doAssert tabs.getCurrentTabIndex() == 0,
                 "the current tab is " & $tabs.getCurrentTabIndex()

        # The enums carry a borrowed ==, so they compare directly.
        tabs.setOrientation(TabbedButtonBarOrientation_TabsAtBottom)
        doAssert tabs.getOrientation() == TabbedButtonBarOrientation_TabsAtBottom,
                 "setOrientation did not take"
        doAssert tabs.getOrientation() != TabbedButtonBarOrientation_TabsAtTop,
                 "the orientation is still the one it was built with"

        tabs.clearTabs()
        doAssert tabs.getNumTabs() == 0, "clearTabs left " & $tabs.getNumTabs()

    shutdownJuce_GUI()

testAccessibleState()
testTabbedComponent()

# SidePanel ===================================================================
#
# Built without being shown: the content it is given is data until something
# displays it.
#
# AlertWindow is not here. Constructing one reaches the platform's window
# system - on Linux that is X, and with no display it asserts twice and then
# segfaults inside JUCE. It is a top-level window, so there is no headless way
# to build one.

proc testSidePanel() =
    initialiseJuce_GUI()

    block:
        var panel = makeSidePanel(makeStringRef(makeString("Panel")), 120.cint, true, nil, false)
        doAssert not panel.isPanelShowing(), "a fresh panel was already showing"
        doAssert panel.getContent() == nil, "a fresh panel had content"

        var content = newCustomComponent()
        panel.setContent(content, true)
        doAssert panel.getContent() == cast[ptr Component](content),
                 "the panel is holding different content"

        # The panel takes ownership, so nothing is deleted here.
        panel.setContent(nil, true)

    shutdownJuce_GUI()

testSidePanel()

# Displays ====================================================================
#
# What JUCE knows about the screens. A headless Linux container reports none,
# so the test asserts what holds either way: the list and the conversions agree
# with each other rather than with any particular hardware.

proc testDisplays() =
    initialiseJuce_GUI()

    block:
        let screens = Desktop.getInstance().getDisplays()

        # A logical rectangle converted to physical and back is unchanged,
        # whatever the scale factor is - including when there are no displays
        # at all and the scale is one.
        let logical = makeRectangle(0.cint, 0.cint, 100.cint, 50.cint)
        let physical = screens.logicalToPhysical(logical, nil)
        let roundTripped = screens.physicalToLogical(physical, nil)
        doAssert roundTripped.getWidth() == logical.getWidth(),
                 "the round trip gave width " & $roundTripped.getWidth()
        doAssert roundTripped.getHeight() == logical.getHeight(),
                 "the round trip gave height " & $roundTripped.getHeight()

        # A default-built Display is empty rather than garbage.
        let blank = makeDisplaysDisplay()
        doAssert not blank.isMain(), "a default Display called itself the main one"
        doAssert blank.totalArea().getWidth() == 0,
                 "a default Display has a total area " & $blank.totalArea().getWidth() & " wide"

    shutdownJuce_GUI()

testDisplays()

# LookAndFeel_V3, at the pixels ===============================================
#
# The newer look and feel, checked the same way as V2: give it a surface and
# read back what it drew. drawTreeviewPlusMinusBox is the useful one, because
# it takes the area to draw in as an argument rather than reading it from a
# component, so it can be asked to stay inside a box and checked against it.

proc testLookAndFeelV3Draws() =
    initialiseJuce_GUI()

    block:
        var feel = makeLookAndFeel_V3()
        let image = makeImage(ImagePixelFormat_ARGB, 60.cint, 20.cint, true)
        var context = makeGraphics(image)
        doAssert image.getPixelAt(30.cint, 10.cint).getAlpha() == 0,
                 "a cleared image was not transparent"

        # Draw the box into the left third only.
        feel.drawTreeviewPlusMinusBox(context,
                                      makeRectangle(0.0'f32, 0.0'f32, 20.0'f32, 20.0'f32),
                                      makeColour(0'u8, 0'u8, 0'u8, 255'u8), false, false)

        doAssert image.getPixelAt(10.cint, 10.cint).getAlpha() > 0,
                 "the plus-minus box left its own area transparent"
        doAssert image.getPixelAt(50.cint, 10.cint).getAlpha() == 0,
                 "the plus-minus box drew outside the area it was given"

    block:
        # A table header background fills the header's own bounds.
        var feel = makeLookAndFeel_V3()
        var header = makeTableHeaderComponent()
        header.setBounds(makeRectangle(0.cint, 0.cint, 40.cint, 10.cint))
        header.addColumn(makeString("Name"), 1.cint, 40.cint, 30.cint, -1.cint, 1.cint, -1.cint)

        let image = makeImage(ImagePixelFormat_ARGB, 40.cint, 20.cint, true)
        var context = makeGraphics(image)
        feel.drawTableHeaderBackground(context, header)

        doAssert image.getPixelAt(20.cint, 5.cint).getAlpha() > 0,
                 "the header background did not draw"

    shutdownJuce_GUI()

testLookAndFeelV3Draws()

# MessageBoxOptions and DrawableText ==========================================
#
# A builder and a drawable, both usable without anything on screen. The alert
# box itself cannot be built headless, but the options describing one can.

proc testMessageBoxOptions() =
    let plain = makeMessageBoxOptions()
    doAssert plain.getNumButtons() == 0, "a fresh options object has " & $plain.getNumButtons() & " buttons"

    let described = plain.withTitle(makeString("Title"))
                         .withMessage(makeString("Message"))
                         .withIconType(MessageBoxIconType_WarningIcon)
    doAssert $described.getTitle() == "Title", "the title is " & $described.getTitle()
    doAssert $described.getMessage() == "Message", "the message is " & $described.getMessage()
    doAssert described.getIconType() == MessageBoxIconType_WarningIcon,
             "the icon type did not stick"

    # Each with* returns a copy, so the one it was called on is unchanged.
    doAssert $plain.getTitle() == "", "withTitle changed the options it came from"

    # Buttons accumulate in the order they were added.
    let withButtons = described.withButton(makeString("Yes")).withButton(makeString("No"))
    doAssert withButtons.getNumButtons() == 2,
             "the options hold " & $withButtons.getNumButtons() & " buttons"
    doAssert $withButtons.getButtonText(0.cint) == "Yes", "the first button is wrong"
    doAssert $withButtons.getButtonText(1.cint) == "No", "the second button is wrong"

proc testDrawableText() =
    initialiseJuce_GUI()

    block:
        var text = makeDrawableText()
        text.setText(makeString("hello"))
        doAssert $text.getText() == "hello", "the text is " & $text.getText()

        let red = makeColour(255'u8, 0'u8, 0'u8, 255'u8)
        text.setColour(red)
        doAssert text.getColour().getRed() == 255, "the colour did not stick"
        doAssert text.getColour().getBlue() == 0, "the colour has the wrong blue"

    shutdownJuce_GUI()

testMessageBoxOptions()
testDrawableText()

# DialogWindowLaunchOptions and PropertyPanel =================================
#
# The options a dialog would be launched with, and the panel that holds
# property rows. Neither needs a window: the dialog is only described here, and
# the panel is an ordinary Component.

proc testDialogWindowLaunchOptions() =
    initialiseJuce_GUI()

    block:
        var options = makeDialogWindowLaunchOptions()
        doAssert $options.dialogTitle() == "", "a fresh options object had a title"
        doAssert options.componentToCentreAround() == nil,
                 "a fresh options object had a component to centre around"

        options.dialogTitle = makeString("Settings")
        doAssert $options.dialogTitle() == "Settings",
                 "the title came back as " & $options.dialogTitle()

        options.dialogBackgroundColour = makeColour(10'u8, 20'u8, 30'u8, 255'u8)
        doAssert options.dialogBackgroundColour().getRed() == 10,
                 "the background red is " & $options.dialogBackgroundColour().getRed()
        doAssert options.dialogBackgroundColour().getBlue() == 30,
                 "the background blue is " & $options.dialogBackgroundColour().getBlue()

        # The title survived the later write, so the var getters write into the
        # options rather than into copies of them.
        doAssert $options.dialogTitle() == "Settings", "the colour write clobbered the title"

    shutdownJuce_GUI()

proc testPropertyPanel() =
    initialiseJuce_GUI()

    block:
        var panel = makePropertyPanel(makeString("Options"))
        doAssert panel.isEmpty(), "a fresh panel was not empty"
        doAssert panel.getSectionNames().size() == 0,
                 "a fresh panel has " & $panel.getSectionNames().size() & " sections"
        doAssert panel.getTotalContentHeight() == 0,
                 "an empty panel is " & $panel.getTotalContentHeight() & " tall"

        panel.clear()
        doAssert panel.isEmpty(), "clear left something behind"

    shutdownJuce_GUI()

testDialogWindowLaunchOptions()
testPropertyPanel()

# LookAndFeel_V1 =============================================================
#
# The oldest look and feel, checked at the pixels like the other two.
#
# MultiDocumentPanel would belong here too, but it is abstract and is one of the
# five classes tools/generate_subclasses.py withholds: tryToCloseDocumentAsync
# takes a std::function<void (bool)>, which has no Nim spelling. With no
# CustomMultiDocumentPanel to build, there is nothing a test can construct.

proc testLookAndFeelV1Draws() =
    initialiseJuce_GUI()

    block:
        var feel = makeLookAndFeel_V1()
        var owner = newCustomComponent()
        owner[].setBounds(makeRectangle(0.cint, 0.cint, 60.cint, 20.cint))

        let image = makeImage(ImagePixelFormat_ARGB, 60.cint, 20.cint, true)
        var context = makeGraphics(image)

        # drawTickBox takes its area as four numbers, so it can be given the
        # left third and checked for staying there.
        feel.drawTickBox(context, cast[ptr Component](owner)[],
                         0.0'f32, 0.0'f32, 20.0'f32, 20.0'f32,
                         true, true, false, false)

        doAssert image.getPixelAt(10.cint, 10.cint).getAlpha() > 0,
                 "the tick box left its own area transparent"
        doAssert image.getPixelAt(50.cint, 10.cint).getAlpha() == 0,
                 "the tick box drew outside the area it was given"

        cdelete owner

    shutdownJuce_GUI()

# ComponentBoundsConstrainer ==================================================
#
# checkBounds writes the constrained rectangle back through its first argument.
# That parameter is a Rectangle<int>& in JUCE and was bound as an immutable
# Rectangle[cint], so the signature said the call could not change it while
# JUCE wrote through it anyway. It is a var now, and this is what holds it so.

proc testComponentBoundsConstrainer() =
    initialiseJuce_GUI()

    block:
        var limiter = makeComponentBoundsConstrainer()
        limiter.setSizeLimits(50.cint, 40.cint, 200.cint, 150.cint)

        doAssert limiter.getMinimumWidth() == 50, "the minimum width did not stick"
        doAssert limiter.getMinimumHeight() == 40, "the minimum height did not stick"
        doAssert limiter.getMaximumWidth() == 200, "the maximum width did not stick"
        doAssert limiter.getMaximumHeight() == 150, "the maximum height did not stick"

        let previous = makeRectangle(0.cint, 0.cint, 10.cint, 10.cint)
        let screen = makeRectangle(0.cint, 0.cint, 1000.cint, 1000.cint)

        # Too small in both directions, so both minima have to apply.
        var tooSmall = makeRectangle(0.cint, 0.cint, 10.cint, 10.cint)
        limiter.checkBounds(tooSmall, previous, screen,
                            false, false, true, true)
        doAssert tooSmall.getWidth() == 50,
                 "checkBounds left the width at " & $tooSmall.getWidth()
        doAssert tooSmall.getHeight() == 40,
                 "checkBounds left the height at " & $tooSmall.getHeight()

        # Too large in both directions, so both maxima have to apply.
        var tooLarge = makeRectangle(0.cint, 0.cint, 900.cint, 900.cint)
        limiter.checkBounds(tooLarge, previous, screen,
                            false, false, true, true)
        doAssert tooLarge.getWidth() == 200,
                 "checkBounds left the width at " & $tooLarge.getWidth()
        doAssert tooLarge.getHeight() == 150,
                 "checkBounds left the height at " & $tooLarge.getHeight()

        limiter.setMinimumOnscreenAmounts(1.cint, 2.cint, 3.cint, 4.cint)
        doAssert limiter.getMinimumWhenOffTheTop() == 1, "the top amount did not stick"
        doAssert limiter.getMinimumWhenOffTheLeft() == 2, "the left amount did not stick"
        doAssert limiter.getMinimumWhenOffTheBottom() == 3, "the bottom amount did not stick"
        doAssert limiter.getMinimumWhenOffTheRight() == 4, "the right amount did not stick"

        limiter.setFixedAspectRatio(2.0)
        doAssert limiter.getFixedAspectRatio() == 2.0, "the aspect ratio did not stick"

        # setBoundsForComponent goes through the same limits and moves a real
        # component, which is the path a resizable window takes.
        var target = newCustomComponent()
        limiter.setBoundsForComponent(cast[ptr Component](target),
                                      makeRectangle(0.cint, 0.cint, 5.cint, 5.cint),
                                      false, false, true, true)
        doAssert target[].getWidth() >= 50,
                 "the component kept a width of " & $target[].getWidth()
        cdelete target

    shutdownJuce_GUI()


# ApplicationCommandManager ===================================================
#
# The whole round trip: a target that answers for two commands, a manager that
# collects them from it, and an invocation that has to reach the target's
# perform handler.

const commandCopy = 1001.cint
const commandPaste = 1002.cint

proc testApplicationCommandManager() =
    initialiseJuce_GUI()

    block:
        var performed: seq[cint] = @[]

        var target = newCustomApplicationCommandTarget()
        target[].setGetNextCommandTargetHandler(proc(): ptr ApplicationCommandTarget = nil)
        target[].setGetAllCommandsHandler(proc(commands: ptr Array[cint]) =
            commands[].add(commandCopy)
            commands[].add(commandPaste))
        target[].setGetCommandInfoHandler(proc(commandID: cint, info: ptr ApplicationCommandInfo) =
            case commandID
            of commandCopy:
                info[].setInfo(makeString("Copy"), makeString("Copies the selection"),
                               makeString("Editing"), 0.cint)
            of commandPaste:
                info[].setInfo(makeString("Paste"), makeString("Pastes the clipboard"),
                               makeString("Editing"), 0.cint)
            else: discard)
        target[].setPerformHandler(proc(info: ptr ApplicationCommandTargetInvocationInfo): bool =
            performed.add(info[].commandID())
            true)

        var manager = makeApplicationCommandManager()
        manager.setFirstCommandTarget(cast[ptr ApplicationCommandTarget](target))
        manager.registerAllCommandsForTarget(cast[ptr ApplicationCommandTarget](target))

        doAssert manager.getNumCommands() == 2,
                 "the manager collected " & $manager.getNumCommands() & " commands"
        doAssert $manager.getNameOfCommand(commandCopy) == "Copy",
                 "the copy command is named " & $manager.getNameOfCommand(commandCopy)
        doAssert $manager.getDescriptionOfCommand(commandPaste) == "Pastes the clipboard",
                 "the paste description is " & $manager.getDescriptionOfCommand(commandPaste)

        let categories = manager.getCommandCategories()
        doAssert categories.size() == 1,
                 "the manager reports " & $categories.size() & " categories"
        doAssert $categories[0.cint] == "Editing",
                 "the category is " & $categories[0.cint]

        let inCategory = manager.getCommandsInCategory(makeString("Editing"))
        doAssert inCategory.size() == 2,
                 "the category holds " & $inCategory.size() & " commands"

        # getCommandForID returns a const ApplicationCommandInfo*, so the
        # binding hands back a ConstPtr. Reading through it is allowed;
        # anything taking a var ApplicationCommandInfo is refused, which is
        # what the C++ const says.
        let info = manager.getCommandForID(commandCopy)
        doAssert not info.isNil(), "the manager has no entry for the copy command"
        doAssert info[].commandID() == commandCopy, "the entry is for another command"
        doAssert $info[].shortName() == "Copy",
                 "the entry is named " & $info[].shortName()

        # Synchronously, so the assertion below does not race the message queue.
        doAssert manager.invokeDirectly(commandPaste, false),
                 "invoking the paste command reported failure"
        doAssert performed == @[commandPaste],
                 "the target performed " & $performed

        manager.removeCommand(commandCopy)
        doAssert manager.getNumCommands() == 1,
                 "after removing one the manager holds " & $manager.getNumCommands()

        manager.clearCommands()
        doAssert manager.getNumCommands() == 0,
                 "after clearing the manager holds " & $manager.getNumCommands()

        # setFirstCommandTarget keeps a raw pointer, so drop it before the
        # target goes, not after.
        manager.setFirstCommandTarget(nil)
        cdelete target

    shutdownJuce_GUI()


testLookAndFeelV1Draws()
testComponentBoundsConstrainer()
# The primary display ==========================================================
#
# getPrimaryDisplay returns a const Displays::Display*, one of the pointers the
# ConstPtr change made callable. The two platforms answer differently - macOS
# reports one display, the headless Linux container reports none and a nil
# primary - so the assertions tie the two answers to each other rather than to
# any hardware: no displays means no primary, and a primary means it is one of
# the displays and says so itself. Each platform takes one branch.

proc testPrimaryDisplay() =
    initialiseJuce_GUI()

    block:
        # Inline, not through a local: getInstance returns a var Desktop and
        # Desktop is non-copyable, so binding it to a name copies and does not
        # compile.
        let displays = Desktop.getInstance().getDisplays()
        let all = displays.displays()
        let primary = displays.getPrimaryDisplay()

        if all.size() == 0:
            doAssert primary.isNil(),
                     "there are no displays and yet one of them is primary"
        else:
            doAssert not primary.isNil(),
                     "there are " & $all.size() & " displays and no primary"
            doAssert primary[].isMain(),
                     "the primary display does not report itself as the main one"
            doAssert not primary[].totalArea().isEmpty(),
                     "the primary display has an empty total area"
            doAssert primary[].scale() > 0.0,
                     "the primary display has a scale of " & $primary[].scale()

            # Exactly one display is the main one.
            var mains = 0
            for display in all:
                if display.isMain(): mains += 1
            doAssert mains == 1,
                     $mains & " of " & $all.size() & " displays are main"

            # A point inside the primary display has to resolve back to a
            # display, which is what getDisplayForPoint is for.
            let centre = primary[].totalArea().getCentre()
            let found = displays.getDisplayForPoint(centre)
            doAssert not found.isNil(),
                     "the centre of the primary display belongs to no display"

    shutdownJuce_GUI()


testApplicationCommandManager()
# KeyPressMappingSet ==========================================================
#
# The manager owns one, and it is what turns a keystroke into a command. The
# XML round trip is the part worth holding: it is how an application persists
# a user's key bindings.

proc testKeyPressMappingSet() =
    initialiseJuce_GUI()

    block:
        var target = newCustomApplicationCommandTarget()
        target[].setGetNextCommandTargetHandler(proc(): ptr ApplicationCommandTarget = nil)
        target[].setGetAllCommandsHandler(proc(commands: ptr Array[cint]) =
            commands[].add(commandCopy))
        target[].setGetCommandInfoHandler(proc(commandID: cint, info: ptr ApplicationCommandInfo) =
            info[].setInfo(makeString("Copy"), makeString("Copies the selection"),
                           makeString("Editing"), 0.cint))
        target[].setPerformHandler(proc(info: ptr ApplicationCommandTargetInvocationInfo): bool = true)

        var manager = makeApplicationCommandManager()
        manager.setFirstCommandTarget(cast[ptr ApplicationCommandTarget](target))
        manager.registerAllCommandsForTarget(cast[ptr ApplicationCommandTarget](target))

        let mappings = manager.getKeyMappings()
        doAssert mappings != nil, "the manager has no key mappings"

        let keyC = makeKeyPress(ord('c').cint, makeModifierKeys(cint(ModifierKeysFlags_commandModifier)),
                                WChar(ord('c')))
        doAssert not mappings[].containsMapping(commandCopy, keyC),
                 "the command already had the mapping before it was added"

        mappings[].addKeyPress(commandCopy, keyC)
        doAssert mappings[].containsMapping(commandCopy, keyC),
                 "the mapping did not stick"
        doAssert mappings[].findCommandForKeyPress(keyC) == commandCopy,
                 "the keystroke resolves to command " &
                 $mappings[].findCommandForKeyPress(keyC)
        doAssert mappings[].getKeyPressesAssignedToCommand(commandCopy).size() == 1,
                 "the command has " &
                 $mappings[].getKeyPressesAssignedToCommand(commandCopy).size() &
                 " keystrokes"

        # Persist and restore. Clearing in between is what makes the restore
        # the thing being tested rather than the state that was already there.
        let saved = mappings[].createXml(true)
        doAssert not saved.isNil(), "createXml produced nothing"

        mappings[].clearAllKeyPresses()
        doAssert not mappings[].containsMapping(commandCopy, keyC),
                 "clearing left the mapping in place"

        # get(), not []: UniquePtr exposes the pointer rather than a deref.
        doAssert mappings[].restoreFromXml(saved.get()[]),
                 "restoreFromXml reported failure"
        doAssert mappings[].containsMapping(commandCopy, keyC),
                 "the mapping did not come back from the XML"

        mappings[].removeKeyPress(keyC)
        doAssert not mappings[].containsMapping(commandCopy, keyC),
                 "removing the keystroke left it in place"

        manager.setFirstCommandTarget(nil)
        cdelete target

    shutdownJuce_GUI()


testPrimaryDisplay()
# DirectoryContentsList =======================================================
#
# JUCE scans the directory on a background thread, so the test has to wait for
# the scan rather than read the count straight away. getFilter is one of the
# procs the ConstPtr change made callable.

proc testDirectoryContentsList() =
    initialiseJuce_GUI()

    block:
        # june.File, not File: Nim's system module has a File of its own.
        let root = june.File.getSpecialLocation(FileSpecialLocationType_tempDirectory)
                       .getNonexistentChildFile(makeString("june-dcl"), makeString(""))
        doAssert root.createDirectory().wasOk(), "could not make the temp directory"

        doAssert root.getChildFile(makeStringRef("one.txt"))
                     .replaceWithText(makeString("first")), "could not write one.txt"
        doAssert root.getChildFile(makeStringRef("two.txt"))
                     .replaceWithText(makeString("second")), "could not write two.txt"
        doAssert root.getChildFile(makeStringRef("three.dat"))
                     .replaceWithText(makeString("third")), "could not write three.dat"

        var filter = newCustomFileFilter(makeString("text files"))
        filter[].setIsFileSuitableHandler(proc(file: ptr june.File): bool =
            $file[].getFileName() != "three.dat")

        var scanner = makeTimeSliceThread(makeString("june-dcl-scan"))
        doAssert scanner.startThread(), "the scanning thread did not start"

        var listing = makeDirectoryContentsList(cast[ptr FileFilter](filter), scanner)
        listing.setDirectory(root, true, true)
        doAssert listing.getDirectory() == root, "the listing is for another directory"
        doAssert listing.isFindingFiles(), "the listing was told to find files and does not"
        doAssert listing.isFindingDirectories(),
                 "the listing was told to find directories and does not"

        listing.refresh()

        # Bounded, so a scan that never finishes fails the test rather than
        # hanging the suite.
        var waited = 0
        while listing.isStillLoading() and waited < 5000:
            Thread.sleep(10.cint)
            waited += 10
        doAssert not listing.isStillLoading(),
                 "the scan was still running after " & $waited & "ms"

        doAssert listing.getNumFiles() == 2,
                 "the listing holds " & $listing.getNumFiles() & " files"
        doAssert listing.contains(root.getChildFile(makeStringRef("one.txt"))),
                 "one.txt is not in the listing"
        doAssert not listing.contains(root.getChildFile(makeStringRef("three.dat"))),
                 "three.dat passed a filter that rejects it"

        var info = makeDirectoryContentsListFileInfo()
        doAssert listing.getFileInfo(0.cint, info), "there is no info for the first entry"
        doAssert $info.filename() in ["one.txt", "two.txt"],
                 "the first entry is named " & $info.filename()

        # getFilter returns a const FileFilter*, so it comes back as a ConstPtr.
        doAssert not listing.getFilter().isNil(), "the listing reports no filter"

        listing.clear()
        doAssert listing.getNumFiles() == 0,
                 "after clearing the listing holds " & $listing.getNumFiles()

        doAssert scanner.stopThread(2000.cint), "the scanning thread did not stop"
        cdelete filter
        doAssert root.deleteRecursively(), "could not remove the temp directory"

    shutdownJuce_GUI()


testKeyPressMappingSet()
# Aggregates with an implicit default constructor =============================
#
# Plain structs JUCE declares with no constructor of their own. libclang
# reports none, so the generator emitted none, and the type was declared with
# readable and writable fields and no way to build one.

proc testGuiAggregates() =
    block:
        var wheel = makeMouseWheelDetails()
        wheel.deltaX = 0.5'f32
        wheel.deltaY = -0.25'f32
        doAssert wheel.deltaX() == 0.5'f32, "the wheel holds " & $wheel.deltaX()
        doAssert wheel.deltaY() == -0.25'f32, "the wheel holds " & $wheel.deltaY()

        var pen = makePenDetails()
        pen.rotation = 1.5'f32
        doAssert pen.rotation() == 1.5'f32, "the pen holds " & $pen.rotation()

        var diagnostics = makeComponentPaintDiagnostics()
        diagnostics.wroteToCache = true
        doAssert diagnostics.wroteToCache(), "the diagnostics did not keep the flag"

        var span = makeAccessibilityTableInterfaceSpan()
        span.begin = 3.cint
        doAssert span.begin() == 3, "the span begins at " & $span.begin()

        var range = makeAccessibilityValueInterfaceAccessibleValueRangeMinAndMax()
        range.min = -1.0
        doAssert range.min() == -1.0, "the range starts at " & $range.min()

        var rotary = makeSliderRotaryParameters()
        rotary.startAngleRadians = 0.25'f32
        doAssert rotary.startAngleRadians() == 0.25'f32,
                 "the parameters hold " & $rotary.startAngleRadians()

        var drag = makeComponentPeerDragInfo()
        drag.text = makeString("dropped")
        doAssert $drag.text() == "dropped", "the drag holds " & $drag.text()

        # These two carry only fields whose types are not simple enough to
        # write here, so building them is the check.
        discard makeSliderSliderLayout()
        discard makeGridItemStartAndEndProperty()


testDirectoryContentsList()
# Toolbar =====================================================================
#
# A toolbar takes its items from a factory, which is abstract, so this needs
# the generated CustomToolbarItemFactory and CustomToolbarItemComponent
# together. The string round trip is the part worth holding: it is how an
# application saves a toolbar the user has arranged.

const toolbarCut = 2001.cint
const toolbarCopy = 2002.cint

proc testToolbar() =
    initialiseJuce_GUI()

    block:
        var factory = newCustomToolbarItemFactory()
        factory[].setGetAllToolbarItemIdsHandler(proc(ids: ptr Array[cint]) =
            ids[].add(toolbarCut)
            ids[].add(toolbarCopy))
        factory[].setGetDefaultItemSetHandler(proc(ids: ptr Array[cint]) =
            ids[].add(toolbarCut))
        factory[].setCreateItemHandler(proc(itemId: cint): ptr ToolbarItemComponent =
            let label = if itemId == toolbarCut: "Cut" else: "Copy"
            var item = newCustomToolbarItemComponent(itemId, makeString(label), true)
            item[].setGetToolbarItemSizesHandler(proc(toolbarThickness: cint,
                                                      isToolbarVertical: bool,
                                                      preferredSize: ptr cint,
                                                      minSize: ptr cint,
                                                      maxSize: ptr cint): bool =
                preferredSize[] = 40.cint
                minSize[] = 20.cint
                maxSize[] = 80.cint
                true)
            item[].setPaintButtonAreaHandler(proc(g: ptr Graphics, width: cint,
                                                  height: cint, isMouseOver: bool,
                                                  isMouseDown: bool) = discard)
            cast[ptr ToolbarItemComponent](item))

        var bar = makeToolbar()
        doAssert bar.getNumItems() == 0, "a fresh toolbar holds items"

        bar.addDefaultItems(cast[ptr CustomToolbarItemFactory](factory)[])
        doAssert bar.getNumItems() == 1,
                 "the default set gave " & $bar.getNumItems() & " items"
        doAssert bar.getItemId(0.cint) == toolbarCut,
                 "the first item is " & $bar.getItemId(0.cint)
        doAssert bar.getItemComponent(0.cint) != nil, "the first item has no component"

        bar.addItem(cast[ptr CustomToolbarItemFactory](factory)[], toolbarCopy)
        doAssert bar.getNumItems() == 2,
                 "after adding one the toolbar holds " & $bar.getNumItems()
        doAssert bar.getItemId(1.cint) == toolbarCopy,
                 "the second item is " & $bar.getItemId(1.cint)

        bar.setVertical(true)
        doAssert bar.isVertical(), "the toolbar did not go vertical"
        bar.setVertical(false)
        doAssert not bar.isVertical(), "the toolbar did not go back to horizontal"

        # Save, empty, restore. Clearing in between is what makes the restore
        # the thing under test.
        let saved = bar.toString()
        doAssert $saved != "", "the toolbar saved as an empty string"

        bar.clear()
        doAssert bar.getNumItems() == 0,
                 "after clearing the toolbar holds " & $bar.getNumItems()

        doAssert bar.restoreFromString(cast[ptr CustomToolbarItemFactory](factory)[], saved),
                 "restoreFromString reported failure"
        doAssert bar.getNumItems() == 2,
                 "the restored toolbar holds " & $bar.getNumItems() & " items"
        doAssert bar.getItemId(1.cint) == toolbarCopy,
                 "the restored second item is " & $bar.getItemId(1.cint)

        cdelete factory

    shutdownJuce_GUI()


testGuiAggregates()
# TableListBox ================================================================
#
# The model is abstract, so this needs CustomTableListBoxModel. Painting the
# table into an image is the part that says the wiring works: JUCE calls back
# into the Nim closures to draw every cell, and the counts have to match the
# rows and columns the table was told about.

proc testTableListBox() =
    initialiseJuce_GUI()

    block:
        var cellsPainted = 0
        var rowsPainted = 0

        var model = newCustomTableListBoxModel()
        model[].setGetNumRowsHandler(proc(): cint = 4.cint)
        model[].setPaintRowBackgroundHandler(proc(g: ptr Graphics, rowNumber: cint,
                                                  width: cint, height: cint,
                                                  rowIsSelected: bool) =
            rowsPainted += 1)
        model[].setPaintCellHandler(proc(g: ptr Graphics, rowNumber: cint,
                                         columnId: cint, width: cint,
                                         height: cint, rowIsSelected: bool) =
            cellsPainted += 1)

        var table = makeTableListBox(makeString("table"),
                                     cast[ptr TableListBoxModel](model))
        doAssert table.getTableListBoxModel() == cast[ptr TableListBoxModel](model),
                 "the table reports another model"

        let visible = cint(TableHeaderComponentColumnPropertyFlags_visible)
        table.getHeader().addColumn(makeString("Name"), 1.cint, 60.cint,
                                    30.cint, -1.cint, visible)
        table.getHeader().addColumn(makeString("Size"), 2.cint, 40.cint,
                                    30.cint, -1.cint, visible)
        doAssert table.getHeader().getNumColumns(true) == 2,
                 "the header holds " & $table.getHeader().getNumColumns(true) & " columns"
        doAssert $table.getHeader().getColumnName(1.cint) == "Name",
                 "column 1 is called " & $table.getHeader().getColumnName(1.cint)
        doAssert table.getHeader().getTotalWidth() == 100,
                 "the columns total " & $table.getHeader().getTotalWidth()

        table.setHeaderHeight(20.cint)
        doAssert table.getHeaderHeight() == 20,
                 "the header is " & $table.getHeaderHeight() & " high"

        table.setBounds(makeRectangle(0.cint, 0.cint, 100.cint, 100.cint))
        table.updateContent()

        let image = makeImage(ImagePixelFormat_ARGB, 100.cint, 100.cint, true)
        var context = makeGraphics(image)
        table.paintEntireComponent(context, false)

        doAssert rowsPainted == 4,
                 "JUCE painted " & $rowsPainted & " row backgrounds for 4 rows"
        doAssert cellsPainted == 8,
                 "JUCE painted " & $cellsPainted & " cells for 4 rows of 2 columns"

        # A cell's position has to sit inside the table and line up with the
        # column widths it was given.
        let firstCell = table.getCellPosition(1.cint, 0.cint, true)
        doAssert firstCell.getWidth() == 60,
                 "the first cell is " & $firstCell.getWidth() & " wide"

        cdelete model

    shutdownJuce_GUI()


testToolbar()
# MenuBarModel ================================================================
#
# The model is abstract, so this goes through CustomMenuBarModel. Calling the
# virtuals back through the base class is the check that the override reached
# C++: getMenuBarNames on a MenuBarModel& has to land in the Nim closure.

proc testMenuBarModel() =
    initialiseJuce_GUI()

    block:
        var selected: seq[tuple[item: cint, menu: cint]] = @[]

        var model = newCustomMenuBarModel()
        model[].setGetMenuBarNamesHandler(proc(): StringArray =
            result = makeStringArray()
            result.add(makeString("File"))
            result.add(makeString("Edit")))
        model[].setGetMenuForIndexHandler(proc(topLevelMenuIndex: cint,
                                               menuName: ptr String): PopupMenu =
            result = makePopupMenu()
            if topLevelMenuIndex == 0:
                result.addItem(1.cint, makeString("Open"))
                result.addItem(2.cint, makeString("Save"))
            else:
                result.addItem(3.cint, makeString("Undo")))
        model[].setMenuItemSelectedHandler(proc(menuItemID: cint,
                                                topLevelMenuIndex: cint) =
            selected.add((menuItemID, topLevelMenuIndex)))

        # Through the base class, which is how JUCE itself reaches these.
        var base = cast[ptr MenuBarModel](model)
        let names = base[].getMenuBarNames()
        doAssert names.size() == 2, "the model named " & $names.size() & " menus"
        doAssert $names[0.cint] == "File", "the first menu is " & $names[0.cint]
        doAssert $names[1.cint] == "Edit", "the second menu is " & $names[1.cint]

        let fileMenu = base[].getMenuForIndex(0.cint, makeString("File"))
        doAssert fileMenu.getNumItems() == 2,
                 "the File menu holds " & $fileMenu.getNumItems() & " items"
        let editMenu = base[].getMenuForIndex(1.cint, makeString("Edit"))
        doAssert editMenu.getNumItems() == 1,
                 "the Edit menu holds " & $editMenu.getNumItems() & " items"

        base[].menuItemSelected(2.cint, 0.cint)
        doAssert selected == @[(2.cint, 0.cint)],
                 "the model was told about " & $selected

        # A MenuBarComponent takes the model and asks it for the same names.
        var menuBar = makeMenuBarComponent(base)
        menuBar.setBounds(makeRectangle(0.cint, 0.cint, 200.cint, 24.cint))

        let image = makeImage(ImagePixelFormat_ARGB, 200.cint, 24.cint, true)
        var context = makeGraphics(image)
        menuBar.paintEntireComponent(context, false)

        var painted = 0
        for x in 0 ..< 200:
            for y in 0 ..< 24:
                if image.getPixelAt(x.cint, y.cint).getAlpha() > 0:
                    painted += 1
        doAssert painted > 0, "drawing the menu bar left the image empty"

        menuBar.setModel(nil)
        cdelete model

    shutdownJuce_GUI()


testTableListBox()
# The remaining generated subclasses ==========================================
#
# A subclass whose constructor nothing calls is never compiled: the C++ class
# is written into a header that the Nim type carries, and Nim includes that
# header only where the type itself is used. Discarding the returned pointer
# does not do it, which is how these went unnoticed.
#
# CustomThreadWithProgressWindow is not here. It is a top-level window, and
# building one on the headless Linux container segfaults, the same as
# AlertWindow.

proc testRemainingGuiSubclasses() =
    initialiseJuce_GUI()

    block:
        var buttonProperty = newCustomButtonPropertyComponent(makeString("prop"), true)
        doAssert not buttonProperty.isNil(), "the button property was not built"
        buttonProperty[].setButtonClickedHandler(proc() = discard)
        buttonProperty[].setGetButtonTextHandler(proc(): String = makeString("text"))
        cdelete buttonProperty

        var property = newCustomPropertyComponent(makeString("prop"), 20.cint)
        doAssert not property.isNil(), "the property was not built"
        property[].setRefreshHandler(proc() = discard)
        cdelete property

        var watched = newCustomComponent()
        var watcher = newCustomComponentMovementWatcher(cast[ptr Component](watched))
        doAssert not watcher.isNil(), "the movement watcher was not built"
        # Three pure virtuals. The generator used to emit only one of them, and
        # the subclass stayed abstract.
        watcher[].setComponentMovedOrResizedHandler(proc(wasMoved: bool,
                                                         wasResized: bool) = discard)
        watcher[].setComponentPeerChangedHandler(proc() = discard)
        watcher[].setComponentVisibilityChangedHandler(proc() = discard)
        cdelete watcher

        var positioner = newCustomRelativeCoordinatePositionerBase(
            cast[ptr Component](watched)[])
        doAssert not positioner.isNil(), "the positioner was not built"
        positioner[].setApplyNewBoundsHandler(proc(newBounds: ptr Rectangle[cint]) = discard)
        positioner[].setRegisterCoordinatesHandler(proc(): bool = true)
        positioner[].setApplyToComponentBoundsHandler(proc() = discard)
        cdelete positioner
        cdelete watched

        var scanner = makeTimeSliceThread(makeString("subclass-scan"))
        var listing = makeDirectoryContentsList(nil, scanner)
        var display = newCustomDirectoryContentsDisplayComponent(listing)
        doAssert not display.isNil(), "the contents display was not built"
        display[].setGetNumSelectedFilesHandler(proc(): cint = 0.cint)
        display[].setGetSelectedFileHandler(proc(index: cint): june.File =
            makeFile(makeString("")))
        display[].setDeselectAllFilesHandler(proc() = discard)
        display[].setScrollToTopHandler(proc() = discard)
        display[].setSetSelectedFileHandler(proc(arg0: ptr june.File) = discard)
        cdelete display

    shutdownJuce_GUI()


testMenuBarModel()
# The accessibility, traversal and text-input subclasses ======================
#
# All abstract, and none of their handlers had ever been set. A setter nothing
# calls is neither type-checked in its body nor generated, and the C++ field it
# assigns to is never written. getAllComponents returns a std::vector, which
# had no constructor until now.

proc testAccessibilityAndInputSubclasses() =
    initialiseJuce_GUI()

    block:
        var text = newCustomAccessibilityTextInterface()
        doAssert not text.isNil(), "the text interface was not built"
        text[].setIsDisplayingProtectedTextHandler(proc(): bool = false)
        text[].setIsReadOnlyHandler(proc(): bool = true)
        text[].setGetTotalNumCharactersHandler(proc(): cint = 5.cint)
        text[].setGetSelectionHandler(proc(): Range[cint] = makeRange(0.cint, 2.cint))
        text[].setSetSelectionHandler(proc(newRange: Range[cint]) = discard)
        text[].setGetTextInsertionOffsetHandler(proc(): cint = 0.cint)
        text[].setGetTextHandler(proc(range: Range[cint]): String = makeString("text"))
        text[].setSetTextHandler(proc(newText: ptr String) = discard)
        text[].setGetTextBoundsHandler(proc(textRange: Range[cint]): RectangleList[cint] =
            makeRectangleList[cint]())
        text[].setGetOffsetAtPointHandler(proc(point: Point[cint]): cint = 0.cint)
        cdelete text

        var value = newCustomAccessibilityValueInterface()
        doAssert not value.isNil(), "the value interface was not built"
        value[].setIsReadOnlyHandler(proc(): bool = false)
        value[].setGetCurrentValueHandler(proc(): cdouble = 0.5)
        value[].setGetCurrentValueAsStringHandler(proc(): String = makeString("0.5"))
        value[].setSetValueHandler(proc(newValue: cdouble) = discard)
        value[].setSetValueAsStringHandler(proc(newValue: ptr String) = discard)
        value[].setGetRangeHandler(proc(): AccessibilityValueInterfaceAccessibleValueRange =
            makeAccessibilityValueInterfaceAccessibleValueRange())
        cdelete value

        var traverser = newCustomComponentTraverser()
        doAssert not traverser.isNil(), "the traverser was not built"
        traverser[].setGetDefaultComponentHandler(
            proc(parentComponent: ptr Component): ptr Component = nil)
        traverser[].setGetNextComponentHandler(
            proc(current: ptr Component): ptr Component = nil)
        traverser[].setGetPreviousComponentHandler(
            proc(current: ptr Component): ptr Component = nil)
        traverser[].setGetAllComponentsHandler(
            proc(parentComponent: ptr Component): CppVector[ptr Component] =
                makeCppVector[ptr Component]())
        cdelete traverser

        var target = newCustomTextInputTarget()
        doAssert not target.isNil(), "the text input target was not built"
        target[].setIsTextInputActiveHandler(proc(): bool = true)
        target[].setGetHighlightedRegionHandler(proc(): Range[cint] =
            makeRange(0.cint, 0.cint))
        target[].setSetHighlightedRegionHandler(proc(newRange: ptr Range[cint]) = discard)
        target[].setSetTemporaryUnderliningHandler(
            proc(underlinedRegions: ptr Array[Range[cint]]) = discard)
        target[].setGetTextInRangeHandler(proc(range: ptr Range[cint]): String =
            makeString(""))
        target[].setInsertTextAtCaretHandler(proc(textToInsert: ptr String) = discard)
        target[].setGetCaretPositionHandler(proc(): cint = 0.cint)
        target[].setGetCaretRectangleForCharIndexHandler(
            proc(characterIndex: cint): Rectangle[cint] =
                makeRectangle(0.cint, 0.cint, 1.cint, 1.cint))
        target[].setGetTotalNumCharsHandler(proc(): cint = 0.cint)
        target[].setGetCharIndexForPointHandler(proc(point: Point[cint]): cint = 0.cint)
        target[].setGetTextBoundsHandler(proc(textRange: Range[cint]): RectangleList[cint] =
            makeRectangleList[cint]())
        cdelete target

        var browserListener = newCustomFileBrowserListener()
        doAssert not browserListener.isNil(), "the browser listener was not built"
        browserListener[].setSelectionChangedHandler(proc() = discard)
        browserListener[].setFileClickedHandler(proc(file: ptr june.File,
                                                     e: ptr MouseEvent) = discard)
        browserListener[].setFileDoubleClickedHandler(proc(file: ptr june.File) = discard)
        browserListener[].setBrowserRootChangedHandler(proc(newRoot: ptr june.File) = discard)
        cdelete browserListener

    shutdownJuce_GUI()


testRemainingGuiSubclasses()
# The last of the gui subclass handlers =======================================
#
# A setter nothing calls is neither type-checked in its body nor generated, and
# the C++ field it assigns to is never written. What is left after this block
# is CustomJUCEApplicationBase, which no test can build.

proc testRemainingGuiHandlers() =
    initialiseJuce_GUI()

    block:
        var cached = newCustomCachedComponentImage()
        cached[].setInvalidateAllHandler(proc(): bool = true)
        cached[].setInvalidateHandler(proc(area: ptr Rectangle[cint]): bool = true)
        cached[].setReleaseResourcesHandler(proc() = discard)
        cdelete cached

        var textDrag = newCustomTextDragAndDropTarget()
        textDrag[].setIsInterestedInTextDragHandler(proc(text: ptr String): bool = false)
        textDrag[].setTextDroppedHandler(proc(text: ptr String, x: cint, y: cint) = discard)
        cdelete textDrag

        var fileDrag = newCustomFileDragAndDropTarget()
        fileDrag[].setIsInterestedInFileDragHandler(proc(files: ptr StringArray): bool = false)
        fileDrag[].setFilesDroppedHandler(proc(files: ptr StringArray, x: cint,
                                               y: cint) = discard)
        cdelete fileDrag

        var drag = newCustomDragAndDropTarget()
        drag[].setIsInterestedInDragSourceHandler(
            proc(dragSourceDetails: ptr DragAndDropTargetSourceDetails): bool = false)
        drag[].setItemDroppedHandler(
            proc(dragSourceDetails: ptr DragAndDropTargetSourceDetails) = discard)
        cdelete drag

        var bubble = newCustomBubbleComponent()
        bubble[].setGetContentSizeHandler(proc(width: ptr cint, height: ptr cint) =
            width[] = 10.cint
            height[] = 10.cint)
        bubble[].setPaintContentHandler(proc(g: ptr Graphics, width: cint,
                                             height: cint) = discard)
        cdelete bubble

        var bordered = newCustomBorderedComponentBoundsConstrainer()
        bordered[].setGetWrappedConstrainerHandler(
            proc(): ptr ComponentBoundsConstrainer = nil)
        bordered[].setGetAdditionalBorderHandler(proc(): BorderSize[cint] =
            makeBorderSize(0.cint))
        cdelete bordered

        var commandListener = newCustomApplicationCommandManagerListener()
        commandListener[].setApplicationCommandInvokedHandler(
            proc(arg0: ptr ApplicationCommandTargetInvocationInfo) = discard)
        commandListener[].setApplicationCommandListChangedHandler(proc() = discard)
        cdelete commandListener

        var cell = newCustomAccessibilityCellInterface()
        cell[].setGetDisclosureLevelHandler(proc(): cint = 0.cint)
        cell[].setGetTableHandlerHandler(proc(): ptr AccessibilityHandler = nil)
        cdelete cell

        var tooltip = newCustomTooltipClient()
        tooltip[].setGetTooltipHandler(proc(): String = makeString("tip"))
        cdelete tooltip

        var keys = newCustomKeyListener()
        keys[].setKeyPressedHandler(proc(key: ptr KeyPress,
                                         originatingComponent: ptr Component): bool = false)
        cdelete keys

        var focus = newCustomFocusChangeListener()
        focus[].setGlobalFocusChangedHandler(
            proc(focusedComponent: ptr Component) = discard)
        cdelete focus

        var filenameListener = newCustomFilenameComponentListener()
        filenameListener[].setFilenameComponentChangedHandler(
            proc(fileComponentThatHasChanged: ptr FilenameComponent) = discard)
        cdelete filenameListener

        var preview = newCustomFilePreviewComponent()
        preview[].setSelectedFileChangedHandler(
            proc(newSelectedFile: ptr june.File) = discard)
        cdelete preview

        var darkMode = newCustomDarkModeSettingListener()
        darkMode[].setDarkModeSettingChangedHandler(proc() = discard)
        cdelete darkMode

        var item = newCustomToolbarItemComponent(1.cint, makeString("item"), true)
        item[].setContentAreaChangedHandler(
            proc(newBounds: ptr Rectangle[cint]) = discard)
        cdelete item

    shutdownJuce_GUI()


testAccessibilityAndInputSubclasses()
# The relative coordinate types ===============================================
#
# JUCE's layout expressions. A coordinate built from a plain number is not
# dynamic and resolves to itself with no scope at all, which makes the whole
# family checkable without a component tree.

proc testRelativeGeometry() =
    block:
        let fixed = makeRelativeCoordinate(12.5)
        doAssert not fixed.isDynamic(), "a plain number called itself dynamic"
        doAssert fixed.resolve(nil) == 12.5,
                 "the coordinate resolved to " & $fixed.resolve(nil)
        doAssert fixed == makeRelativeCoordinate(12.5),
                 "two coordinates of the same number are not equal"
        doAssert fixed != makeRelativeCoordinate(13.0),
                 "coordinates of different numbers are equal"

        # A coordinate written as an expression that names another coordinate is
        # dynamic, because it cannot be resolved without a scope.
        let named = makeRelativeCoordinate(makeString("parent.width / 2"))
        doAssert named.isDynamic(), "an expression naming a coordinate is not dynamic"
        # references() is withheld by the generator: JUCE 8.0.15 declares
        # RelativeCoordinate::references in the header and defines it nowhere,
        # so the binding compiled and the call failed to link. toString is the
        # reachable way to see what the expression names.
        doAssert "parent.width" in $named.toString(),
                 "the expression reads " & $named.toString()

    block:
        let point = makeRelativePoint(3.0'f32, 4.0'f32)
        doAssert not point.isDynamic(), "an absolute point called itself dynamic"
        let resolved = point.resolve(nil)
        doAssert resolved.getX() == 3.0'f32, "the point resolved x to " & $resolved.getX()
        doAssert resolved.getY() == 4.0'f32, "the point resolved y to " & $resolved.getY()

        # A point survives the round trip through its own string form, which is
        # what a stored layout is.
        let restored = makeRelativePoint(point.toString())
        doAssert restored.resolve(nil).getX() == 3.0'f32,
                 "the restored point has x " & $restored.resolve(nil).getX()
        doAssert restored.resolve(nil).getY() == 4.0'f32,
                 "the restored point has y " & $restored.resolve(nil).getY()

    block:
        let area = makeRectangle(1.0'f32, 2.0'f32, 30.0'f32, 40.0'f32)
        let relative = makeRelativeRectangle(area)
        doAssert not relative.isDynamic(), "an absolute rectangle called itself dynamic"

        let back = relative.resolve(nil)
        doAssert back.getX() == 1.0'f32, "the rectangle resolved x to " & $back.getX()
        doAssert back.getY() == 2.0'f32, "the rectangle resolved y to " & $back.getY()
        doAssert back.getWidth() == 30.0'f32,
                 "the rectangle resolved width to " & $back.getWidth()
        doAssert back.getHeight() == 40.0'f32,
                 "the rectangle resolved height to " & $back.getHeight()

        # left/right/top/bottom are the coordinates it is made of. JUCE stores
        # the far edges as expressions over the near ones - right is
        # `left + width` - so left resolves on its own and right does not; it
        # names left, and only resolve() on the whole rectangle builds the
        # scope that gives it a value.
        doAssert relative.left().resolve(nil) == 1.0,
                 "the left edge is at " & $relative.left().resolve(nil)
        doAssert "left" in $relative.right().toString(),
                 "the right edge reads " & $relative.right().toString()
        doAssert relative.right().isDynamic(),
                 "the right edge does not need a scope"

        let restored = makeRelativeRectangle(relative.toString())
        doAssert restored.resolve(nil).getWidth() == 30.0'f32,
                 "the restored rectangle is " & $restored.resolve(nil).getWidth() & " wide"

    block:
        let shape = makeRelativeParallelogram(
            makeRectangle(0.0'f32, 0.0'f32, 10.0'f32, 5.0'f32))
        doAssert not shape.isDynamic(), "an absolute parallelogram called itself dynamic"
        doAssert shape.topLeft().resolve(nil).getX() == 0.0'f32,
                 "the top left is at x " & $shape.topLeft().resolve(nil).getX()
        doAssert shape.topRight().resolve(nil).getX() == 10.0'f32,
                 "the top right is at x " & $shape.topRight().resolve(nil).getX()
        doAssert shape.bottomLeft().resolve(nil).getY() == 5.0'f32,
                 "the bottom left is at y " & $shape.bottomLeft().resolve(nil).getY()


testRemainingGuiHandlers()
# DrawableImage and DrawableRectangle =========================================
#
# Drawables paint themselves into a Graphics, so the surface says what they did
# rather than a getter repeating what it was told.

proc testDrawables() =
    initialiseJuce_GUI()

    block:
        # A source image that is solid red, so any pixel it paints is
        # recognisable in the destination.
        let source = makeImage(ImagePixelFormat_ARGB, 4.cint, 4.cint, true)
        block:
            var sourceContext = makeGraphics(source)
            sourceContext.setColour(makeColour(255'u8, 0'u8, 0'u8, 255'u8))
            sourceContext.fillAll()
        doAssert source.getPixelAt(0.cint, 0.cint).getRed() == 255'u8,
                 "the source image is not red"

        var drawable = makeDrawableImage(source)
        doAssert drawable.getOpacity() == 1.0'f32,
                 "a fresh drawable has opacity " & $drawable.getOpacity()
        doAssert drawable.getImage().getWidth() == 4,
                 "the drawable holds a " & $drawable.getImage().getWidth() & "px image"

        let target = makeImage(ImagePixelFormat_ARGB, 8.cint, 8.cint, true)
        var context = makeGraphics(target)
        drawable.drawAt(context, 0.0'f32, 0.0'f32, 1.0'f32)

        doAssert target.getPixelAt(1.cint, 1.cint).getRed() == 255'u8,
                 "the drawable painted red " & $target.getPixelAt(1.cint, 1.cint).getRed()
        doAssert target.getPixelAt(6.cint, 6.cint).getAlpha() == 0'u8,
                 "the drawable painted outside its 4x4 image"

        # Half opacity has to halve what reaches the surface, which is a
        # different answer rather than merely a non-empty one.
        let faded = makeImage(ImagePixelFormat_ARGB, 8.cint, 8.cint, true)
        var fadedContext = makeGraphics(faded)
        drawable.drawAt(fadedContext, 0.0'f32, 0.0'f32, 0.5'f32)
        let fadedAlpha = faded.getPixelAt(1.cint, 1.cint).getAlpha()
        doAssert fadedAlpha > 0'u8 and fadedAlpha < 255'u8,
                 "half opacity gave an alpha of " & $fadedAlpha

    block:
        # All three forms, because the coverage check matches a name and one
        # call would satisfy it for every overload.
        let empty = makeParallelogram[cfloat]()
        doAssert empty.topLeft().getX() == 0.0'f32,
                 "a default parallelogram starts at " & $empty.topLeft().getX()

        let fromRect = makeParallelogram(makeRectangle(1.0'f32, 2.0'f32,
                                                       10.0'f32, 4.0'f32))
        doAssert fromRect.topRight().getX() == 11.0'f32,
                 "the top right is at " & $fromRect.topRight().getX()
        doAssert fromRect.bottomLeft().getY() == 6.0'f32,
                 "the bottom left is at " & $fromRect.bottomLeft().getY()

        let fromPoints = makeParallelogram(makePoint(0.0'f32, 0.0'f32),
                                           makePoint(4.0'f32, 0.0'f32),
                                           makePoint(1.0'f32, 3.0'f32))
        doAssert fromPoints.getWidth() == 4.0'f32,
                 "the sheared parallelogram is " & $fromPoints.getWidth() & " wide"
        # The fourth corner is derived rather than stored: topRight plus the
        # vector from topLeft to bottomLeft.
        doAssert fromPoints.getBottomRight().getX() == 5.0'f32,
                 "the bottom right is at x " & $fromPoints.getBottomRight().getX()
        doAssert fromPoints.getBottomRight().getY() == 3.0'f32,
                 "the bottom right is at y " & $fromPoints.getBottomRight().getY()
        doAssert not fromPoints.isEmpty(), "a real parallelogram called itself empty"
        doAssert empty.isEmpty(), "a default parallelogram is not empty"
        doAssert fromRect.getHeight() == 4.0'f32,
                 "the rectangle form is " & $fromRect.getHeight() & " high"

    block:
        var rectangle = makeDrawableRectangle()
        rectangle.setRectangle(makeParallelogram(
            makeRectangle(0.0'f32, 0.0'f32, 6.0'f32, 6.0'f32)))
        rectangle.setFill(makeFillType(makeColour(0'u8, 0'u8, 255'u8, 255'u8)))

        let target = makeImage(ImagePixelFormat_ARGB, 10.cint, 10.cint, true)
        var context = makeGraphics(target)
        rectangle.drawAt(context, 0.0'f32, 0.0'f32, 1.0'f32)

        doAssert target.getPixelAt(2.cint, 2.cint).getBlue() == 255'u8,
                 "the rectangle painted blue " & $target.getPixelAt(2.cint, 2.cint).getBlue()
        doAssert target.getPixelAt(9.cint, 9.cint).getAlpha() == 0'u8,
                 "the rectangle painted outside its own bounds"

    shutdownJuce_GUI()


testRelativeGeometry()
# Span, WeakReference and OptionalScopedPointer ===============================
#
# Three types that were declared and could not be built, each of which a
# binding takes as a parameter, so each of those bindings was unreachable.

proc testUnbuildableParameterTypes() =
    initialiseJuce_GUI()

    block:
        var values = [1'u16, 2'u16, 3'u16]
        let span = makeSpan(addr values[0], 3.csize_t)
        doAssert span.size() == 3.csize_t, "the span holds " & $span.size().int
        doAssert makeSpan[uint16]().size() == 0.csize_t,
                 "an empty span is not empty"

    block:
        # A WeakReference goes nil when its target dies, which is the whole
        # reason JUCE has the type.
        var owner = newCustomComponent()
        let weak = makeWeakReference(cast[ptr Component](owner))
        doAssert not weak.isNil(), "the reference is nil while its target lives"
        doAssert weak.get() == cast[ptr Component](owner),
                 "the reference points somewhere else"

        var details = makeDragAndDropTargetSourceDetails(
            makejuce_var(1.cint), nil, makePoint(0.cint, 0.cint))
        details.sourceComponent = weak
        doAssert not details.sourceComponent().isNil(),
                 "the details dropped the source component"

        cdelete owner
        doAssert weak.isNil(), "the reference outlived its target"

    block:
        # A move-only field. The setter moves rather than copies, so the
        # UniquePtr handed in is empty afterwards, exactly as in C++.
        var item = makePopupMenuItem(makeString("parent"))
        var submenu = makeUniquePtr[PopupMenu](cnew(makePopupMenu()))
        doAssert not submenu.isNil(), "the submenu was not built"
        item.subMenu = submenu
        doAssert submenu.isNil(), "the setter copied instead of moving"

    block:
        # takeOwnership false, so the component is deleted here rather than by
        # the wrapper.
        var content = newCustomComponent()
        var options = makeDialogWindowLaunchOptions()
        options.content = makeOptionalScopedPointer(
            cast[ptr Component](content), false)
        doAssert not options.content().isNil(),
                 "the launch options dropped the content"
        cdelete content

    shutdownJuce_GUI()


testDrawables()
testUnbuildableParameterTypes()

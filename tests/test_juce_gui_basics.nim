
import june

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

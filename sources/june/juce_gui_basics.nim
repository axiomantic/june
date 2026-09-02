# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

import june_common

const juce_gui_basics = "<juce_gui_basics/juce_gui_basics.h>"

type
  MouseCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor", inheritable, pure.} = object
  MouseListener* {.header: juce_gui_basics, importcpp: "juce::MouseListener", inheritable, pure.} = object
  ModifierKeys* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys", inheritable, pure.} = object
  MouseInputSource* {.header: juce_gui_basics, importcpp: "juce::MouseInputSource", inheritable, pure.} = object
  MouseEvent* {.header: juce_gui_basics, importcpp: "juce::MouseEvent", inheritable, pure.} = object
  MouseWheelDetails* {.header: juce_gui_basics, importcpp: "juce::MouseWheelDetails", inheritable, pure.} = object
  PenDetails* {.header: juce_gui_basics, importcpp: "juce::PenDetails", inheritable, pure.} = object
  KeyPress* {.header: juce_gui_basics, importcpp: "juce::KeyPress", inheritable, pure.} = object
  KeyListener* {.header: juce_gui_basics, importcpp: "juce::KeyListener", inheritable, pure.} = object
  ComponentTraverser* {.header: juce_gui_basics, importcpp: "juce::ComponentTraverser", inheritable, pure.} = object
  FocusTraverser* {.header: juce_gui_basics, importcpp: "juce::FocusTraverser", inheritable, pure.} = object of ComponentTraverser
  ModalComponentManager* {.header: juce_gui_basics, importcpp: "juce::ModalComponentManager", inheritable, pure.} = object of AsyncUpdater
  ModalComponentManagerCallback* {.header: juce_gui_basics, importcpp: "juce::ModalComponentManager::Callback", inheritable, pure.} = object
  ModalComponentManagerKey* {.header: juce_gui_basics, importcpp: "juce::ModalComponentManager::Key", inheritable, pure.} = object
  ModalCallbackFunction* {.header: juce_gui_basics, importcpp: "juce::ModalCallbackFunction", inheritable, pure.} = object
  ComponentPaintDiagnostics* {.header: juce_gui_basics, importcpp: "juce::ComponentPaintDiagnostics", inheritable, pure.} = object
  ComponentListener* {.header: juce_gui_basics, importcpp: "juce::ComponentListener", inheritable, pure.} = object
  CachedComponentImage* {.header: juce_gui_basics, importcpp: "juce::CachedComponentImage", inheritable, pure.} = object
  Component* {.header: juce_gui_basics, importcpp: "juce::Component", inheritable, pure.} = object of MouseListener
  ComponentBailOutChecker* {.header: juce_gui_basics, importcpp: "juce::Component::BailOutChecker", inheritable, pure.} = object
  ComponentPositioner* {.header: juce_gui_basics, importcpp: "juce::Component::Positioner", inheritable, pure.} = object
  ComponentAnimator* {.header: juce_gui_basics, importcpp: "juce::ComponentAnimator", inheritable, pure.} = object of ChangeBroadcaster
  FocusChangeListener* {.header: juce_gui_basics, importcpp: "juce::FocusChangeListener", inheritable, pure.} = object
  DarkModeSettingListener* {.header: juce_gui_basics, importcpp: "juce::DarkModeSettingListener", inheritable, pure.} = object
  Desktop* {.header: juce_gui_basics, importcpp: "juce::Desktop", inheritable, pure.} = object of DeletedAtShutdown
  Displays* {.header: juce_gui_basics, importcpp: "juce::Displays", inheritable, pure.} = object
  DisplaysDisplay* {.header: juce_gui_basics, importcpp: "juce::Displays::Display", inheritable, pure.} = object
  ComponentBoundsConstrainer* {.header: juce_gui_basics, importcpp: "juce::ComponentBoundsConstrainer", inheritable, pure.} = object
  BorderedComponentBoundsConstrainer* {.header: juce_gui_basics, importcpp: "juce::BorderedComponentBoundsConstrainer", inheritable, pure.} = object of ComponentBoundsConstrainer
  ComponentDragger* {.header: juce_gui_basics, importcpp: "juce::ComponentDragger", inheritable, pure.} = object
  DragAndDropTarget* {.header: juce_gui_basics, importcpp: "juce::DragAndDropTarget", inheritable, pure.} = object
  DragAndDropTargetSourceDetails* {.header: juce_gui_basics, importcpp: "juce::DragAndDropTarget::SourceDetails", inheritable, pure.} = object
  DragAndDropContainer* {.header: juce_gui_basics, importcpp: "juce::DragAndDropContainer", inheritable, pure.} = object
  FileDragAndDropTarget* {.header: juce_gui_basics, importcpp: "juce::FileDragAndDropTarget", inheritable, pure.} = object
  MouseInactivityDetector* {.header: juce_gui_basics, importcpp: "juce::MouseInactivityDetector", inheritable, pure.} = object of Timer
  MouseInactivityDetectorListener* {.header: juce_gui_basics, importcpp: "juce::MouseInactivityDetector::Listener", inheritable, pure.} = object
  TextDragAndDropTarget* {.header: juce_gui_basics, importcpp: "juce::TextDragAndDropTarget", inheritable, pure.} = object
  TooltipClient* {.header: juce_gui_basics, importcpp: "juce::TooltipClient", inheritable, pure.} = object
  SettableTooltipClient* {.header: juce_gui_basics, importcpp: "juce::SettableTooltipClient", inheritable, pure.} = object of TooltipClient
  CaretComponent* {.header: juce_gui_basics, importcpp: "juce::CaretComponent", inheritable, pure.} = object of Component
  KeyboardFocusTraverser* {.header: juce_gui_basics, importcpp: "juce::KeyboardFocusTraverser", inheritable, pure.} = object of ComponentTraverser
  SystemClipboard* {.header: juce_gui_basics, importcpp: "juce::SystemClipboard", inheritable, pure.} = object
  TextInputTarget* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget", inheritable, pure.} = object
  ApplicationCommandInfo* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo", inheritable, pure.} = object
  ApplicationCommandTarget* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandTarget", inheritable, pure.} = object
  ApplicationCommandTargetInvocationInfo* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandTarget::InvocationInfo", inheritable, pure.} = object
  ApplicationCommandManager* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandManager", inheritable, pure.} = object of AsyncUpdater
  ApplicationCommandManagerListener* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandManagerListener", inheritable, pure.} = object
  KeyPressMappingSet* {.header: juce_gui_basics, importcpp: "juce::KeyPressMappingSet", inheritable, pure.} = object of KeyListener
  Button* {.header: juce_gui_basics, importcpp: "juce::Button", inheritable, pure.} = object of Component
  ButtonListener* {.header: juce_gui_basics, importcpp: "juce::Button::Listener", inheritable, pure.} = object
  ButtonLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::Button::LookAndFeelMethods", inheritable, pure.} = object
  ArrowButton* {.header: juce_gui_basics, importcpp: "juce::ArrowButton", inheritable, pure.} = object of Button
  DrawableButton* {.header: juce_gui_basics, importcpp: "juce::DrawableButton", inheritable, pure.} = object of Button
  HyperlinkButton* {.header: juce_gui_basics, importcpp: "juce::HyperlinkButton", inheritable, pure.} = object of Button
  ImageButton* {.header: juce_gui_basics, importcpp: "juce::ImageButton", inheritable, pure.} = object of Button
  ImageButtonLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::ImageButton::LookAndFeelMethods", inheritable, pure.} = object
  ShapeButton* {.header: juce_gui_basics, importcpp: "juce::ShapeButton", inheritable, pure.} = object of Button
  TextButton* {.header: juce_gui_basics, importcpp: "juce::TextButton", inheritable, pure.} = object of Button
  ToggleButton* {.header: juce_gui_basics, importcpp: "juce::ToggleButton", inheritable, pure.} = object of Button
  ComponentBuilder* {.header: juce_gui_basics, importcpp: "juce::ComponentBuilder", inheritable, pure.} = object
  ComponentBuilderTypeHandler* {.header: juce_gui_basics, importcpp: "juce::ComponentBuilder::TypeHandler", inheritable, pure.} = object
  ComponentBuilderImageProvider* {.header: juce_gui_basics, importcpp: "juce::ComponentBuilder::ImageProvider", inheritable, pure.} = object
  ComponentMovementWatcher* {.header: juce_gui_basics, importcpp: "juce::ComponentMovementWatcher", inheritable, pure.} = object of ComponentListener
  ConcertinaPanel* {.header: juce_gui_basics, importcpp: "juce::ConcertinaPanel", inheritable, pure.} = object of Component
  ConcertinaPanelLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::ConcertinaPanel::LookAndFeelMethods", inheritable, pure.} = object
  GroupComponent* {.header: juce_gui_basics, importcpp: "juce::GroupComponent", inheritable, pure.} = object of Component
  GroupComponentLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::GroupComponent::LookAndFeelMethods", inheritable, pure.} = object
  ResizableBorderComponent* {.header: juce_gui_basics, importcpp: "juce::ResizableBorderComponent", inheritable, pure.} = object of Component
  ResizableBorderComponentZone* {.header: juce_gui_basics, importcpp: "juce::ResizableBorderComponent::Zone", inheritable, pure.} = object
  ResizableCornerComponent* {.header: juce_gui_basics, importcpp: "juce::ResizableCornerComponent", inheritable, pure.} = object of Component
  ResizableEdgeComponent* {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent", inheritable, pure.} = object of Component
  ScrollBar* {.header: juce_gui_basics, importcpp: "juce::ScrollBar", inheritable, pure.} = object of Component
  ScrollBarListener* {.header: juce_gui_basics, importcpp: "juce::ScrollBar::Listener", inheritable, pure.} = object
  ScrollBarLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::ScrollBar::LookAndFeelMethods", inheritable, pure.} = object
  StretchableLayoutManager* {.header: juce_gui_basics, importcpp: "juce::StretchableLayoutManager", inheritable, pure.} = object
  StretchableLayoutResizerBar* {.header: juce_gui_basics, importcpp: "juce::StretchableLayoutResizerBar", inheritable, pure.} = object of Component
  StretchableLayoutResizerBarLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::StretchableLayoutResizerBar::LookAndFeelMethods", inheritable, pure.} = object
  StretchableObjectResizer* {.header: juce_gui_basics, importcpp: "juce::StretchableObjectResizer", inheritable, pure.} = object
  TabBarButton* {.header: juce_gui_basics, importcpp: "juce::TabBarButton", inheritable, pure.} = object of Button
  TabbedButtonBar* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar", inheritable, pure.} = object of Component
  TabbedButtonBarLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::LookAndFeelMethods", inheritable, pure.} = object
  TabbedComponent* {.header: juce_gui_basics, importcpp: "juce::TabbedComponent", inheritable, pure.} = object of Component
  AccessibilityCellInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityCellInterface", inheritable, pure.} = object
  AccessibilityTableInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityTableInterface", inheritable, pure.} = object
  AccessibilityTableInterfaceSpan* {.header: juce_gui_basics, importcpp: "juce::AccessibilityTableInterface::Span", inheritable, pure.} = object
  AccessibilityTextInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityTextInterface", inheritable, pure.} = object
  AccessibilityValueInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityValueInterface", inheritable, pure.} = object
  AccessibilityValueInterfaceAccessibleValueRange* {.header: juce_gui_basics, importcpp: "juce::AccessibilityValueInterface::AccessibleValueRange", inheritable, pure.} = object
  AccessibilityTextValueInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityTextValueInterface", inheritable, pure.} = object of AccessibilityValueInterface
  AccessibilityNumericValueInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityNumericValueInterface", inheritable, pure.} = object of AccessibilityValueInterface
  AccessibilityRangedNumericValueInterface* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRangedNumericValueInterface", inheritable, pure.} = object of AccessibilityValueInterface
  AccessibilityActions* {.header: juce_gui_basics, importcpp: "juce::AccessibilityActions", inheritable, pure.} = object
  AccessibleState* {.header: juce_gui_basics, importcpp: "juce::AccessibleState", inheritable, pure.} = object
  AccessibilityHandler* {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler", inheritable, pure.} = object
  AccessibilityHandlerInterfaces* {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler::Interfaces", inheritable, pure.} = object
  Drawable* {.header: juce_gui_basics, importcpp: "juce::Drawable", inheritable, pure.} = object of Component
  Viewport* {.header: juce_gui_basics, importcpp: "juce::Viewport", inheritable, pure.} = object of Component
  PopupMenu* {.header: juce_gui_basics, importcpp: "juce::PopupMenu", inheritable, pure.} = object
  PopupMenuCustomComponent* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::CustomComponent", inheritable, pure.} = object
  PopupMenuCustomCallback* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::CustomCallback", inheritable, pure.} = object
  PopupMenuItem* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::Item", inheritable, pure.} = object
  PopupMenuOptions* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::Options", inheritable, pure.} = object
  PopupMenuMenuItemIterator* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::MenuItemIterator", inheritable, pure.} = object
  PopupMenuLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::LookAndFeelMethods", inheritable, pure.} = object
  MenuBarModel* {.header: juce_gui_basics, importcpp: "juce::MenuBarModel", inheritable, pure.} = object of AsyncUpdater
  MenuBarModelListener* {.header: juce_gui_basics, importcpp: "juce::MenuBarModel::Listener", inheritable, pure.} = object
  MenuBarComponent* {.header: juce_gui_basics, importcpp: "juce::MenuBarComponent", inheritable, pure.} = object of Component
  RelativeCoordinate* {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate", inheritable, pure.} = object
  RelativeCoordinateStrings* {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate::Strings", inheritable, pure.} = object
  RelativeCoordinateStandardStrings* {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate::StandardStrings", inheritable, pure.} = object
  MarkerList* {.header: juce_gui_basics, importcpp: "juce::MarkerList", inheritable, pure.} = object
  MarkerListMarker* {.header: juce_gui_basics, importcpp: "juce::MarkerList::Marker", inheritable, pure.} = object
  MarkerListListener* {.header: juce_gui_basics, importcpp: "juce::MarkerList::Listener", inheritable, pure.} = object
  MarkerListMarkerListHolder* {.header: juce_gui_basics, importcpp: "juce::MarkerList::MarkerListHolder", inheritable, pure.} = object
  MarkerListValueTreeWrapper* {.header: juce_gui_basics, importcpp: "juce::MarkerList::ValueTreeWrapper", inheritable, pure.} = object
  RelativePoint* {.header: juce_gui_basics, importcpp: "juce::RelativePoint", inheritable, pure.} = object
  RelativeRectangle* {.header: juce_gui_basics, importcpp: "juce::RelativeRectangle", inheritable, pure.} = object
  RelativeCoordinatePositionerBase* {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinatePositionerBase", inheritable, pure.} = object of ComponentListener
  RelativeCoordinatePositionerBaseComponentScope* {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinatePositionerBase::ComponentScope", inheritable, pure.} = object
  RelativeParallelogram* {.header: juce_gui_basics, importcpp: "juce::RelativeParallelogram", inheritable, pure.} = object
  RelativePointPath* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath", inheritable, pure.} = object
  RelativePointPathElementBase* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::ElementBase", inheritable, pure.} = object
  RelativePointPathStartSubPath* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::StartSubPath", inheritable, pure.} = object
  RelativePointPathCloseSubPath* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::CloseSubPath", inheritable, pure.} = object
  RelativePointPathLineTo* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::LineTo", inheritable, pure.} = object
  RelativePointPathQuadraticTo* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::QuadraticTo", inheritable, pure.} = object
  RelativePointPathCubicTo* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::CubicTo", inheritable, pure.} = object
  DrawableShape* {.header: juce_gui_basics, importcpp: "juce::DrawableShape", inheritable, pure.} = object of Drawable
  DrawableComposite* {.header: juce_gui_basics, importcpp: "juce::DrawableComposite", inheritable, pure.} = object of Drawable
  DrawableImage* {.header: juce_gui_basics, importcpp: "juce::DrawableImage", inheritable, pure.} = object of Drawable
  DrawablePath* {.header: juce_gui_basics, importcpp: "juce::DrawablePath", inheritable, pure.} = object of DrawableShape
  DrawableRectangle* {.header: juce_gui_basics, importcpp: "juce::DrawableRectangle", inheritable, pure.} = object of DrawableShape
  DrawableText* {.header: juce_gui_basics, importcpp: "juce::DrawableText", inheritable, pure.} = object of Drawable
  TextEditor* {.header: juce_gui_basics, importcpp: "juce::TextEditor", inheritable, pure.} = object of TextInputTarget
  TextEditorListener* {.header: juce_gui_basics, importcpp: "juce::TextEditor::Listener", inheritable, pure.} = object
  TextEditorInputFilter* {.header: juce_gui_basics, importcpp: "juce::TextEditor::InputFilter", inheritable, pure.} = object
  TextEditorLengthAndCharacterRestriction* {.header: juce_gui_basics, importcpp: "juce::TextEditor::LengthAndCharacterRestriction", inheritable, pure.} = object
  TextEditorLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::TextEditor::LookAndFeelMethods", inheritable, pure.} = object
  Label* {.header: juce_gui_basics, importcpp: "juce::Label", inheritable, pure.} = object of Component
  LabelListener* {.header: juce_gui_basics, importcpp: "juce::Label::Listener", inheritable, pure.} = object
  LabelLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::Label::LookAndFeelMethods", inheritable, pure.} = object
  ComboBox* {.header: juce_gui_basics, importcpp: "juce::ComboBox", inheritable, pure.} = object of Component
  ComboBoxListener* {.header: juce_gui_basics, importcpp: "juce::ComboBox::Listener", inheritable, pure.} = object
  ComboBoxLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::ComboBox::LookAndFeelMethods", inheritable, pure.} = object
  ImageComponent* {.header: juce_gui_basics, importcpp: "juce::ImageComponent", inheritable, pure.} = object of Component
  ListBoxModel* {.header: juce_gui_basics, importcpp: "juce::ListBoxModel", inheritable, pure.} = object
  ListBox* {.header: juce_gui_basics, importcpp: "juce::ListBox", inheritable, pure.} = object of Component
  ProgressBar* {.header: juce_gui_basics, importcpp: "juce::ProgressBar", inheritable, pure.} = object of Component
  ProgressBarLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::LookAndFeelMethods", inheritable, pure.} = object
  Slider* {.header: juce_gui_basics, importcpp: "juce::Slider", inheritable, pure.} = object of Component
  SliderRotaryParameters* {.header: juce_gui_basics, importcpp: "juce::Slider::RotaryParameters", inheritable, pure.} = object
  SliderSliderLayout* {.header: juce_gui_basics, importcpp: "juce::Slider::SliderLayout", inheritable, pure.} = object
  SliderScopedDragNotification* {.header: juce_gui_basics, importcpp: "juce::Slider::ScopedDragNotification", inheritable, pure.} = object
  SliderLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::Slider::LookAndFeelMethods", inheritable, pure.} = object
  TableHeaderComponent* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent", inheritable, pure.} = object of Component
  TableHeaderComponentListener* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::Listener", inheritable, pure.} = object
  TableHeaderComponentLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::LookAndFeelMethods", inheritable, pure.} = object
  TableListBoxModel* {.header: juce_gui_basics, importcpp: "juce::TableListBoxModel", inheritable, pure.} = object
  TableListBox* {.header: juce_gui_basics, importcpp: "juce::TableListBox", inheritable, pure.} = object of ListBox
  Toolbar* {.header: juce_gui_basics, importcpp: "juce::Toolbar", inheritable, pure.} = object of Component
  ToolbarLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::Toolbar::LookAndFeelMethods", inheritable, pure.} = object
  ToolbarItemComponent* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemComponent", inheritable, pure.} = object of Button
  ToolbarItemFactory* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemFactory", inheritable, pure.} = object
  ToolbarItemPalette* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemPalette", inheritable, pure.} = object of Component
  BurgerMenuComponent* {.header: juce_gui_basics, importcpp: "juce::BurgerMenuComponent", inheritable, pure.} = object of Component
  ToolbarButton* {.header: juce_gui_basics, importcpp: "juce::ToolbarButton", inheritable, pure.} = object of ToolbarItemComponent
  DropShadower* {.header: juce_gui_basics, importcpp: "juce::DropShadower", inheritable, pure.} = object of ComponentListener
  FocusOutline* {.header: juce_gui_basics, importcpp: "juce::FocusOutline", inheritable, pure.} = object of ComponentListener
  FocusOutlineOutlineWindowProperties* {.header: juce_gui_basics, importcpp: "juce::FocusOutline::OutlineWindowProperties", inheritable, pure.} = object
  TreeViewItem* {.header: juce_gui_basics, importcpp: "juce::TreeViewItem", inheritable, pure.} = object
  TreeViewItemOpennessRestorer* {.header: juce_gui_basics, importcpp: "juce::TreeViewItem::OpennessRestorer", inheritable, pure.} = object
  TreeView* {.header: juce_gui_basics, importcpp: "juce::TreeView", inheritable, pure.} = object of Component
  TreeViewLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::TreeView::LookAndFeelMethods", inheritable, pure.} = object
  TopLevelWindow* {.header: juce_gui_basics, importcpp: "juce::TopLevelWindow", inheritable, pure.} = object of Component
  MessageBoxOptions* {.header: juce_gui_basics, importcpp: "juce::MessageBoxOptions", inheritable, pure.} = object
  ScopedMessageBox* {.header: juce_gui_basics, importcpp: "juce::ScopedMessageBox", inheritable, pure.} = object
  AlertWindow* {.header: juce_gui_basics, importcpp: "juce::AlertWindow", inheritable, pure.} = object of TopLevelWindow
  AlertWindowLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::AlertWindow::LookAndFeelMethods", inheritable, pure.} = object
  CallOutBox* {.header: juce_gui_basics, importcpp: "juce::CallOutBox", inheritable, pure.} = object of Component
  CallOutBoxLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::CallOutBox::LookAndFeelMethods", inheritable, pure.} = object
  ComponentPeer* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer", inheritable, pure.} = object of FocusChangeListener
  ComponentPeerOptionalBorderSize* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::OptionalBorderSize", inheritable, pure.} = object
  ComponentPeerDragInfo* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::DragInfo", inheritable, pure.} = object
  ComponentPeerScaleFactorListener* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::ScaleFactorListener", inheritable, pure.} = object
  ComponentPeerVBlankListener* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::VBlankListener", inheritable, pure.} = object
  ResizableWindow* {.header: juce_gui_basics, importcpp: "juce::ResizableWindow", inheritable, pure.} = object of TopLevelWindow
  ResizableWindowLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::ResizableWindow::LookAndFeelMethods", inheritable, pure.} = object
  DocumentWindowImpl {.header: juce_gui_basics, importcpp: "juce::DocumentWindow", inheritable, pure.} = object of ResizableWindow
  DocumentWindowLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::LookAndFeelMethods", inheritable, pure.} = object
  DialogWindow* {.header: juce_gui_basics, importcpp: "juce::DialogWindow", inheritable, pure.} = object of DocumentWindowImpl
  DialogWindowLaunchOptions* {.header: juce_gui_basics, importcpp: "juce::DialogWindow::LaunchOptions", inheritable, pure.} = object
  NativeMessageBox* {.header: juce_gui_basics, importcpp: "juce::NativeMessageBox", inheritable, pure.} = object
  ThreadWithProgressWindow* {.header: juce_gui_basics, importcpp: "juce::ThreadWithProgressWindow", inheritable, pure.} = object of Thread
  TooltipWindow* {.header: juce_gui_basics, importcpp: "juce::TooltipWindow", inheritable, pure.} = object of Component
  TooltipWindowLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::TooltipWindow::LookAndFeelMethods", inheritable, pure.} = object
  VBlankAttachment* {.header: juce_gui_basics, importcpp: "juce::VBlankAttachment", inheritable, pure.} = object of ComponentListener
  WindowUtils* {.header: juce_gui_basics, importcpp: "juce::WindowUtils", inheritable, pure.} = object
  NativeScaleFactorNotifier* {.header: juce_gui_basics, importcpp: "juce::NativeScaleFactorNotifier", inheritable, pure.} = object of ComponentMovementWatcher
  MultiDocumentPanelWindow* {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanelWindow", inheritable, pure.} = object of DocumentWindowImpl
  MultiDocumentPanel* {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanel", inheritable, pure.} = object of Component
  SidePanel* {.header: juce_gui_basics, importcpp: "juce::SidePanel", inheritable, pure.} = object of Component
  SidePanelLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::SidePanel::LookAndFeelMethods", inheritable, pure.} = object
  FileBrowserListener* {.header: juce_gui_basics, importcpp: "juce::FileBrowserListener", inheritable, pure.} = object
  DirectoryContentsList* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsList", inheritable, pure.} = object of ChangeBroadcaster
  DirectoryContentsListFileInfo* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsList::FileInfo", inheritable, pure.} = object
  DirectoryContentsDisplayComponent* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsDisplayComponent", inheritable, pure.} = object
  FileBrowserComponent* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent", inheritable, pure.} = object of Component
  FileBrowserComponentLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::LookAndFeelMethods", inheritable, pure.} = object
  FileChooser* {.header: juce_gui_basics, importcpp: "juce::FileChooser", inheritable, pure.} = object
  FileChooserNative* {.header: juce_gui_basics, importcpp: "juce::FileChooser::Native", inheritable, pure.} = object
  FileChooserDialogBox* {.header: juce_gui_basics, importcpp: "juce::FileChooserDialogBox", inheritable, pure.} = object of ResizableWindow
  FileListComponent* {.header: juce_gui_basics, importcpp: "juce::FileListComponent", inheritable, pure.} = object of ListBoxModel
  FilenameComponentListener* {.header: juce_gui_basics, importcpp: "juce::FilenameComponentListener", inheritable, pure.} = object
  FilenameComponent* {.header: juce_gui_basics, importcpp: "juce::FilenameComponent", inheritable, pure.} = object of Component
  FilenameComponentLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::FilenameComponent::LookAndFeelMethods", inheritable, pure.} = object
  FilePreviewComponent* {.header: juce_gui_basics, importcpp: "juce::FilePreviewComponent", inheritable, pure.} = object of Component
  FileSearchPathListComponent* {.header: juce_gui_basics, importcpp: "juce::FileSearchPathListComponent", inheritable, pure.} = object of Component
  FileTreeComponent* {.header: juce_gui_basics, importcpp: "juce::FileTreeComponent", inheritable, pure.} = object of TreeView
  ImagePreviewComponent* {.header: juce_gui_basics, importcpp: "juce::ImagePreviewComponent", inheritable, pure.} = object of FilePreviewComponent
  ContentSharer* {.header: juce_gui_basics, importcpp: "juce::ContentSharer", inheritable, pure.} = object
  PropertyComponent* {.header: juce_gui_basics, importcpp: "juce::PropertyComponent", inheritable, pure.} = object of Component
  PropertyComponentLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::PropertyComponent::LookAndFeelMethods", inheritable, pure.} = object
  BooleanPropertyComponent* {.header: juce_gui_basics, importcpp: "juce::BooleanPropertyComponent", inheritable, pure.} = object of PropertyComponent
  ButtonPropertyComponent* {.header: juce_gui_basics, importcpp: "juce::ButtonPropertyComponent", inheritable, pure.} = object of PropertyComponent
  ChoicePropertyComponent* {.header: juce_gui_basics, importcpp: "juce::ChoicePropertyComponent", inheritable, pure.} = object of PropertyComponent
  PropertyPanel* {.header: juce_gui_basics, importcpp: "juce::PropertyPanel", inheritable, pure.} = object of Component
  SliderPropertyComponent* {.header: juce_gui_basics, importcpp: "juce::SliderPropertyComponent", inheritable, pure.} = object of PropertyComponent
  TextPropertyComponent* {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent", inheritable, pure.} = object of PropertyComponent
  TextPropertyComponentListener* {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent::Listener", inheritable, pure.} = object
  MultiChoicePropertyComponent* {.header: juce_gui_basics, importcpp: "juce::MultiChoicePropertyComponent", inheritable, pure.} = object of PropertyComponent
  JUCEApplicationImpl {.header: juce_gui_basics, importcpp: "juce::JUCEApplication", inheritable, pure.} = object of JUCEApplicationBase
  BubbleComponent* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent", inheritable, pure.} = object of Component
  BubbleComponentLookAndFeelMethods* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::LookAndFeelMethods", inheritable, pure.} = object
  ExtraLookAndFeelBaseClasses* {.header: juce_gui_basics, importcpp: "juce::ExtraLookAndFeelBaseClasses", inheritable, pure.} = object
  ExtraLookAndFeelBaseClassesLassoComponentMethods* {.header: juce_gui_basics, importcpp: "juce::ExtraLookAndFeelBaseClasses::LassoComponentMethods", inheritable, pure.} = object
  ExtraLookAndFeelBaseClassesKeyMappingEditorComponentMethods* {.header: juce_gui_basics, importcpp: "juce::ExtraLookAndFeelBaseClasses::KeyMappingEditorComponentMethods", inheritable, pure.} = object
  ExtraLookAndFeelBaseClassesAudioDeviceSelectorComponentMethods* {.header: juce_gui_basics, importcpp: "juce::ExtraLookAndFeelBaseClasses::AudioDeviceSelectorComponentMethods", inheritable, pure.} = object
  LookAndFeel* {.header: juce_gui_basics, importcpp: "juce::LookAndFeel", inheritable, pure.} = object
  LookAndFeel_V2* {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V2", inheritable, pure.} = object of LookAndFeel
  LookAndFeel_V1* {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V1", inheritable, pure.} = object of LookAndFeel_V2
  LookAndFeel_V3* {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V3", inheritable, pure.} = object of LookAndFeel_V2
  LookAndFeel_V4* {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V4", inheritable, pure.} = object of LookAndFeel_V3
  LookAndFeel_V4ColourScheme* {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V4::ColourScheme", inheritable, pure.} = object
  FlexItem* {.header: juce_gui_basics, importcpp: "juce::FlexItem", inheritable, pure.} = object
  FlexItemMargin* {.header: juce_gui_basics, importcpp: "juce::FlexItem::Margin", inheritable, pure.} = object
  FlexBox* {.header: juce_gui_basics, importcpp: "juce::FlexBox", inheritable, pure.} = object
  GridItem* {.header: juce_gui_basics, importcpp: "juce::GridItem", inheritable, pure.} = object
  GridItemSpan* {.header: juce_gui_basics, importcpp: "juce::GridItem::Span", inheritable, pure.} = object
  GridItemProperty* {.header: juce_gui_basics, importcpp: "juce::GridItem::Property", inheritable, pure.} = object
  GridItemStartAndEndProperty* {.header: juce_gui_basics, importcpp: "juce::GridItem::StartAndEndProperty", inheritable, pure.} = object
  GridItemMargin* {.header: juce_gui_basics, importcpp: "juce::GridItem::Margin", inheritable, pure.} = object
  Grid* {.header: juce_gui_basics, importcpp: "juce::Grid", inheritable, pure.} = object
  GridPx* {.header: juce_gui_basics, importcpp: "juce::Grid::Px", inheritable, pure.} = object
  GridFr* {.header: juce_gui_basics, importcpp: "juce::Grid::Fr", inheritable, pure.} = object
  GridTrackInfo* {.header: juce_gui_basics, importcpp: "juce::Grid::TrackInfo", inheritable, pure.} = object
  ScopedDPIAwarenessDisabler* {.header: juce_gui_basics, importcpp: "juce::ScopedDPIAwarenessDisabler", inheritable, pure.} = object
  AccessibilityNativeHandle* {.header: juce_gui_basics, importcpp: "juce::AccessibilityNativeHandle", inheritable, pure.} = object
  AccessibilityActionType* {.header: juce_gui_basics, importcpp: "juce::AccessibilityActionType".} = distinct cint
  AccessibilityEvent* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent".} = distinct cint
  AccessibilityRole* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole".} = distinct cint
  MessageBoxIconType* {.header: juce_gui_basics, importcpp: "juce::MessageBoxIconType".} = distinct cint
  MouseCursorStandardCursorType* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::StandardCursorType".} = distinct cint
  ModifierKeysFlags* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::Flags".} = distinct cint
  MouseInputSourceInputSourceType* {.header: juce_gui_basics, importcpp: "juce::MouseInputSource::InputSourceType".} = distinct cint
  FocusTraverserSkipDisabledComponents* {.header: juce_gui_basics, importcpp: "juce::FocusTraverser::SkipDisabledComponents".} = distinct cint
  ComponentWindowControlKind* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind".} = distinct cint
  ComponentFocusContainerType* {.header: juce_gui_basics, importcpp: "juce::Component::FocusContainerType".} = distinct cint
  ComponentFocusChangeType* {.header: juce_gui_basics, importcpp: "juce::Component::FocusChangeType".} = distinct cint
  ComponentFocusChangeDirection* {.header: juce_gui_basics, importcpp: "juce::Component::FocusChangeDirection".} = distinct cint
  DesktopDisplayOrientation* {.header: juce_gui_basics, importcpp: "juce::Desktop::DisplayOrientation".} = distinct cint
  CaretComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::CaretComponent::ColourIds".} = distinct cint
  TextInputTargetVirtualKeyboardType* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::VirtualKeyboardType".} = distinct cint
  ApplicationCommandInfoCommandFlags* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::CommandFlags".} = distinct cint
  ButtonConnectedEdgeFlags* {.header: juce_gui_basics, importcpp: "juce::Button::ConnectedEdgeFlags".} = distinct cint
  ButtonButtonState* {.header: juce_gui_basics, importcpp: "juce::Button::ButtonState".} = distinct cint
  DrawableButtonButtonStyle* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ButtonStyle".} = distinct cint
  DrawableButtonColourIds* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ColourIds".} = distinct cint
  HyperlinkButtonColourIds* {.header: juce_gui_basics, importcpp: "juce::HyperlinkButton::ColourIds".} = distinct cint
  TextButtonColourIds* {.header: juce_gui_basics, importcpp: "juce::TextButton::ColourIds".} = distinct cint
  ToggleButtonColourIds* {.header: juce_gui_basics, importcpp: "juce::ToggleButton::ColourIds".} = distinct cint
  GroupComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::GroupComponent::ColourIds".} = distinct cint
  ResizableEdgeComponentEdge* {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent::Edge".} = distinct cint
  ScrollBarColourIds* {.header: juce_gui_basics, importcpp: "juce::ScrollBar::ColourIds".} = distinct cint
  TabBarButtonExtraComponentPlacement* {.header: juce_gui_basics, importcpp: "juce::TabBarButton::ExtraComponentPlacement".} = distinct cint
  TabbedButtonBarOrientation* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::Orientation".} = distinct cint
  TabbedButtonBarColourIds* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::ColourIds".} = distinct cint
  TabbedComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::TabbedComponent::ColourIds".} = distinct cint
  AccessibilityHandlerAnnouncementPriority* {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler::AnnouncementPriority".} = distinct cint
  ViewportScrollOnDragMode* {.header: juce_gui_basics, importcpp: "juce::Viewport::ScrollOnDragMode".} = distinct cint
  PopupMenuColourIds* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::ColourIds".} = distinct cint
  RelativePointPathElementType* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::ElementType".} = distinct cint
  TextEditorColourIds* {.header: juce_gui_basics, importcpp: "juce::TextEditor::ColourIds".} = distinct cint
  LabelColourIds* {.header: juce_gui_basics, importcpp: "juce::Label::ColourIds".} = distinct cint
  ComboBoxColourIds* {.header: juce_gui_basics, importcpp: "juce::ComboBox::ColourIds".} = distinct cint
  ListBoxColourIds* {.header: juce_gui_basics, importcpp: "juce::ListBox::ColourIds".} = distinct cint
  ProgressBarStyle* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::Style".} = distinct cint
  ProgressBarColourIds* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::ColourIds".} = distinct cint
  SliderSliderStyle* {.header: juce_gui_basics, importcpp: "juce::Slider::SliderStyle".} = distinct cint
  SliderTextEntryBoxPosition* {.header: juce_gui_basics, importcpp: "juce::Slider::TextEntryBoxPosition".} = distinct cint
  SliderDragMode* {.header: juce_gui_basics, importcpp: "juce::Slider::DragMode".} = distinct cint
  SliderIncDecButtonMode* {.header: juce_gui_basics, importcpp: "juce::Slider::IncDecButtonMode".} = distinct cint
  SliderColourIds* {.header: juce_gui_basics, importcpp: "juce::Slider::ColourIds".} = distinct cint
  TableHeaderComponentColumnPropertyFlags* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::ColumnPropertyFlags".} = distinct cint
  TableHeaderComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::ColourIds".} = distinct cint
  ToolbarToolbarItemStyle* {.header: juce_gui_basics, importcpp: "juce::Toolbar::ToolbarItemStyle".} = distinct cint
  ToolbarCustomisationFlags* {.header: juce_gui_basics, importcpp: "juce::Toolbar::CustomisationFlags".} = distinct cint
  ToolbarColourIds* {.header: juce_gui_basics, importcpp: "juce::Toolbar::ColourIds".} = distinct cint
  ToolbarItemComponentToolbarEditingMode* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemComponent::ToolbarEditingMode".} = distinct cint
  ToolbarItemFactorySpecialItemIds* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemFactory::SpecialItemIds".} = distinct cint
  TreeViewItemOpenness* {.header: juce_gui_basics, importcpp: "juce::TreeViewItem::Openness".} = distinct cint
  TreeViewColourIds* {.header: juce_gui_basics, importcpp: "juce::TreeView::ColourIds".} = distinct cint
  AlertWindowColourIds* {.header: juce_gui_basics, importcpp: "juce::AlertWindow::ColourIds".} = distinct cint
  ComponentPeerStyleFlags* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::StyleFlags".} = distinct cint
  ComponentPeerStyle* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::Style".} = distinct cint
  ResizableWindowColourIds* {.header: juce_gui_basics, importcpp: "juce::ResizableWindow::ColourIds".} = distinct cint
  DocumentWindowTitleBarButtons* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::TitleBarButtons".} = distinct cint
  DocumentWindowColourIds* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::ColourIds".} = distinct cint
  TooltipWindowColourIds* {.header: juce_gui_basics, importcpp: "juce::TooltipWindow::ColourIds".} = distinct cint
  MultiDocumentPanelLayoutMode* {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanel::LayoutMode".} = distinct cint
  SidePanelColourIds* {.header: juce_gui_basics, importcpp: "juce::SidePanel::ColourIds".} = distinct cint
  DirectoryContentsDisplayComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsDisplayComponent::ColourIds".} = distinct cint
  FileBrowserComponentFileChooserFlags* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::FileChooserFlags".} = distinct cint
  FileBrowserComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::ColourIds".} = distinct cint
  FileChooserDialogBoxColourIds* {.header: juce_gui_basics, importcpp: "juce::FileChooserDialogBox::ColourIds".} = distinct cint
  FileSearchPathListComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::FileSearchPathListComponent::ColourIds".} = distinct cint
  PropertyComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::PropertyComponent::ColourIds".} = distinct cint
  BooleanPropertyComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::BooleanPropertyComponent::ColourIds".} = distinct cint
  TextPropertyComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent::ColourIds".} = distinct cint
  BubbleComponentBubblePlacement* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::BubblePlacement".} = distinct cint
  BubbleComponentColourIds* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::ColourIds".} = distinct cint
  FlexItemAlignSelf* {.header: juce_gui_basics, importcpp: "juce::FlexItem::AlignSelf".} = distinct cint
  FlexBoxDirection* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Direction".} = distinct cint
  FlexBoxWrap* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Wrap".} = distinct cint
  FlexBoxAlignContent* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent".} = distinct cint
  FlexBoxAlignItems* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignItems".} = distinct cint
  FlexBoxJustifyContent* {.header: juce_gui_basics, importcpp: "juce::FlexBox::JustifyContent".} = distinct cint
  GridItemKeyword* {.header: juce_gui_basics, importcpp: "juce::GridItem::Keyword".} = distinct cint
  GridItemJustifySelf* {.header: juce_gui_basics, importcpp: "juce::GridItem::JustifySelf".} = distinct cint
  GridItemAlignSelf* {.header: juce_gui_basics, importcpp: "juce::GridItem::AlignSelf".} = distinct cint
  GridJustifyItems* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyItems".} = distinct cint
  GridAlignItems* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignItems".} = distinct cint
  GridJustifyContent* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent".} = distinct cint
  GridAlignContent* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent".} = distinct cint
  GridAutoFlow* {.header: juce_gui_basics, importcpp: "juce::Grid::AutoFlow".} = distinct cint

let AccessibilityActionType_press* {.header: juce_gui_basics, importcpp: "juce::AccessibilityActionType::press".}: AccessibilityActionType
let AccessibilityActionType_toggle* {.header: juce_gui_basics, importcpp: "juce::AccessibilityActionType::toggle".}: AccessibilityActionType
let AccessibilityActionType_focus* {.header: juce_gui_basics, importcpp: "juce::AccessibilityActionType::focus".}: AccessibilityActionType
let AccessibilityActionType_showMenu* {.header: juce_gui_basics, importcpp: "juce::AccessibilityActionType::showMenu".}: AccessibilityActionType

let AccessibilityEvent_valueChanged* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent::valueChanged".}: AccessibilityEvent
let AccessibilityEvent_titleChanged* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent::titleChanged".}: AccessibilityEvent
let AccessibilityEvent_structureChanged* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent::structureChanged".}: AccessibilityEvent
let AccessibilityEvent_textSelectionChanged* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent::textSelectionChanged".}: AccessibilityEvent
let AccessibilityEvent_textChanged* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent::textChanged".}: AccessibilityEvent
let AccessibilityEvent_rowSelectionChanged* {.header: juce_gui_basics, importcpp: "juce::AccessibilityEvent::rowSelectionChanged".}: AccessibilityEvent

let AccessibilityRole_button* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::button".}: AccessibilityRole
let AccessibilityRole_toggleButton* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::toggleButton".}: AccessibilityRole
let AccessibilityRole_radioButton* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::radioButton".}: AccessibilityRole
let AccessibilityRole_comboBox* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::comboBox".}: AccessibilityRole
let AccessibilityRole_image* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::image".}: AccessibilityRole
let AccessibilityRole_slider* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::slider".}: AccessibilityRole
let AccessibilityRole_label* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::label".}: AccessibilityRole
let AccessibilityRole_staticText* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::staticText".}: AccessibilityRole
let AccessibilityRole_editableText* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::editableText".}: AccessibilityRole
let AccessibilityRole_menuItem* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::menuItem".}: AccessibilityRole
let AccessibilityRole_menuBar* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::menuBar".}: AccessibilityRole
let AccessibilityRole_popupMenu* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::popupMenu".}: AccessibilityRole
let AccessibilityRole_table* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::table".}: AccessibilityRole
let AccessibilityRole_tableHeader* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::tableHeader".}: AccessibilityRole
let AccessibilityRole_column* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::column".}: AccessibilityRole
let AccessibilityRole_row* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::row".}: AccessibilityRole
let AccessibilityRole_cell* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::cell".}: AccessibilityRole
let AccessibilityRole_hyperlink* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::hyperlink".}: AccessibilityRole
let AccessibilityRole_list* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::list".}: AccessibilityRole
let AccessibilityRole_listItem* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::listItem".}: AccessibilityRole
let AccessibilityRole_tree* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::tree".}: AccessibilityRole
let AccessibilityRole_treeItem* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::treeItem".}: AccessibilityRole
let AccessibilityRole_progressBar* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::progressBar".}: AccessibilityRole
let AccessibilityRole_group* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::group".}: AccessibilityRole
let AccessibilityRole_dialogWindow* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::dialogWindow".}: AccessibilityRole
let AccessibilityRole_window* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::window".}: AccessibilityRole
let AccessibilityRole_scrollBar* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::scrollBar".}: AccessibilityRole
let AccessibilityRole_tooltip* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::tooltip".}: AccessibilityRole
let AccessibilityRole_splashScreen* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::splashScreen".}: AccessibilityRole
let AccessibilityRole_ignored* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::ignored".}: AccessibilityRole
let AccessibilityRole_unspecified* {.header: juce_gui_basics, importcpp: "juce::AccessibilityRole::unspecified".}: AccessibilityRole

let MessageBoxIconType_NoIcon* {.header: juce_gui_basics, importcpp: "juce::MessageBoxIconType::NoIcon".}: MessageBoxIconType
let MessageBoxIconType_QuestionIcon* {.header: juce_gui_basics, importcpp: "juce::MessageBoxIconType::QuestionIcon".}: MessageBoxIconType
let MessageBoxIconType_WarningIcon* {.header: juce_gui_basics, importcpp: "juce::MessageBoxIconType::WarningIcon".}: MessageBoxIconType
let MessageBoxIconType_InfoIcon* {.header: juce_gui_basics, importcpp: "juce::MessageBoxIconType::InfoIcon".}: MessageBoxIconType

let MouseCursorStandardCursorType_ParentCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::ParentCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_NoCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::NoCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_NormalCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::NormalCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_WaitCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::WaitCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_IBeamCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::IBeamCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_CrosshairCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::CrosshairCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_CopyingCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::CopyingCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_PointingHandCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::PointingHandCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_DraggingHandCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::DraggingHandCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_LeftRightResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::LeftRightResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_UpDownResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::UpDownResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_UpDownLeftRightResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::UpDownLeftRightResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_TopEdgeResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::TopEdgeResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_BottomEdgeResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::BottomEdgeResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_LeftEdgeResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::LeftEdgeResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_RightEdgeResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::RightEdgeResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_TopLeftCornerResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::TopLeftCornerResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_TopRightCornerResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::TopRightCornerResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_BottomLeftCornerResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::BottomLeftCornerResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_BottomRightCornerResizeCursor* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::BottomRightCornerResizeCursor".}: MouseCursorStandardCursorType
let MouseCursorStandardCursorType_NumStandardCursorTypes* {.header: juce_gui_basics, importcpp: "juce::MouseCursor::NumStandardCursorTypes".}: MouseCursorStandardCursorType

let ModifierKeysFlags_noModifiers* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::noModifiers".}: ModifierKeysFlags
let ModifierKeysFlags_shiftModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::shiftModifier".}: ModifierKeysFlags
let ModifierKeysFlags_ctrlModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::ctrlModifier".}: ModifierKeysFlags
let ModifierKeysFlags_altModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::altModifier".}: ModifierKeysFlags
let ModifierKeysFlags_leftButtonModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::leftButtonModifier".}: ModifierKeysFlags
let ModifierKeysFlags_rightButtonModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::rightButtonModifier".}: ModifierKeysFlags
let ModifierKeysFlags_middleButtonModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::middleButtonModifier".}: ModifierKeysFlags
let ModifierKeysFlags_backButtonModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::backButtonModifier".}: ModifierKeysFlags
let ModifierKeysFlags_forwardButtonModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::forwardButtonModifier".}: ModifierKeysFlags
let ModifierKeysFlags_commandModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::commandModifier".}: ModifierKeysFlags
let ModifierKeysFlags_popupMenuClickModifier* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::popupMenuClickModifier".}: ModifierKeysFlags
let ModifierKeysFlags_allKeyboardModifiers* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::allKeyboardModifiers".}: ModifierKeysFlags
let ModifierKeysFlags_allMouseButtonModifiers* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::allMouseButtonModifiers".}: ModifierKeysFlags
let ModifierKeysFlags_ctrlAltCommandModifiers* {.header: juce_gui_basics, importcpp: "juce::ModifierKeys::ctrlAltCommandModifiers".}: ModifierKeysFlags

let MouseInputSourceInputSourceType_mouse* {.header: juce_gui_basics, importcpp: "juce::MouseInputSource::mouse".}: MouseInputSourceInputSourceType
let MouseInputSourceInputSourceType_touch* {.header: juce_gui_basics, importcpp: "juce::MouseInputSource::touch".}: MouseInputSourceInputSourceType
let MouseInputSourceInputSourceType_pen* {.header: juce_gui_basics, importcpp: "juce::MouseInputSource::pen".}: MouseInputSourceInputSourceType

let FocusTraverserSkipDisabledComponents_no* {.header: juce_gui_basics, importcpp: "juce::FocusTraverser::SkipDisabledComponents::no".}: FocusTraverserSkipDisabledComponents
let FocusTraverserSkipDisabledComponents_yes* {.header: juce_gui_basics, importcpp: "juce::FocusTraverser::SkipDisabledComponents::yes".}: FocusTraverserSkipDisabledComponents

let ComponentWindowControlKind_client* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::client".}: ComponentWindowControlKind
let ComponentWindowControlKind_caption* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::caption".}: ComponentWindowControlKind
let ComponentWindowControlKind_minimise* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::minimise".}: ComponentWindowControlKind
let ComponentWindowControlKind_maximise* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::maximise".}: ComponentWindowControlKind
let ComponentWindowControlKind_close* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::close".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeTop* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeTop".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeLeft* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeLeft".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeRight* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeRight".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeBottom* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeBottom".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeTopLeft* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeTopLeft".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeTopRight* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeTopRight".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeBottomLeft* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeBottomLeft".}: ComponentWindowControlKind
let ComponentWindowControlKind_sizeBottomRight* {.header: juce_gui_basics, importcpp: "juce::Component::WindowControlKind::sizeBottomRight".}: ComponentWindowControlKind

let ComponentFocusContainerType_none* {.header: juce_gui_basics, importcpp: "juce::Component::FocusContainerType::none".}: ComponentFocusContainerType
let ComponentFocusContainerType_focusContainer* {.header: juce_gui_basics, importcpp: "juce::Component::FocusContainerType::focusContainer".}: ComponentFocusContainerType
let ComponentFocusContainerType_keyboardFocusContainer* {.header: juce_gui_basics, importcpp: "juce::Component::FocusContainerType::keyboardFocusContainer".}: ComponentFocusContainerType

let ComponentFocusChangeType_focusChangedByMouseClick* {.header: juce_gui_basics, importcpp: "juce::Component::focusChangedByMouseClick".}: ComponentFocusChangeType
let ComponentFocusChangeType_focusChangedByTabKey* {.header: juce_gui_basics, importcpp: "juce::Component::focusChangedByTabKey".}: ComponentFocusChangeType
let ComponentFocusChangeType_focusChangedDirectly* {.header: juce_gui_basics, importcpp: "juce::Component::focusChangedDirectly".}: ComponentFocusChangeType

let ComponentFocusChangeDirection_unknown* {.header: juce_gui_basics, importcpp: "juce::Component::FocusChangeDirection::unknown".}: ComponentFocusChangeDirection
let ComponentFocusChangeDirection_forward* {.header: juce_gui_basics, importcpp: "juce::Component::FocusChangeDirection::forward".}: ComponentFocusChangeDirection
let ComponentFocusChangeDirection_backward* {.header: juce_gui_basics, importcpp: "juce::Component::FocusChangeDirection::backward".}: ComponentFocusChangeDirection

let DesktopDisplayOrientation_upright* {.header: juce_gui_basics, importcpp: "juce::Desktop::upright".}: DesktopDisplayOrientation
let DesktopDisplayOrientation_upsideDown* {.header: juce_gui_basics, importcpp: "juce::Desktop::upsideDown".}: DesktopDisplayOrientation
let DesktopDisplayOrientation_rotatedClockwise* {.header: juce_gui_basics, importcpp: "juce::Desktop::rotatedClockwise".}: DesktopDisplayOrientation
let DesktopDisplayOrientation_rotatedAntiClockwise* {.header: juce_gui_basics, importcpp: "juce::Desktop::rotatedAntiClockwise".}: DesktopDisplayOrientation
let DesktopDisplayOrientation_allOrientations* {.header: juce_gui_basics, importcpp: "juce::Desktop::allOrientations".}: DesktopDisplayOrientation

let CaretComponentColourIds_caretColourId* {.header: juce_gui_basics, importcpp: "juce::CaretComponent::caretColourId".}: CaretComponentColourIds

let TextInputTargetVirtualKeyboardType_textKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::textKeyboard".}: TextInputTargetVirtualKeyboardType
let TextInputTargetVirtualKeyboardType_numericKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::numericKeyboard".}: TextInputTargetVirtualKeyboardType
let TextInputTargetVirtualKeyboardType_decimalKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::decimalKeyboard".}: TextInputTargetVirtualKeyboardType
let TextInputTargetVirtualKeyboardType_urlKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::urlKeyboard".}: TextInputTargetVirtualKeyboardType
let TextInputTargetVirtualKeyboardType_emailAddressKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::emailAddressKeyboard".}: TextInputTargetVirtualKeyboardType
let TextInputTargetVirtualKeyboardType_phoneNumberKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::phoneNumberKeyboard".}: TextInputTargetVirtualKeyboardType
let TextInputTargetVirtualKeyboardType_passwordKeyboard* {.header: juce_gui_basics, importcpp: "juce::TextInputTarget::passwordKeyboard".}: TextInputTargetVirtualKeyboardType

let ApplicationCommandInfoCommandFlags_isDisabled* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::isDisabled".}: ApplicationCommandInfoCommandFlags
let ApplicationCommandInfoCommandFlags_isTicked* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::isTicked".}: ApplicationCommandInfoCommandFlags
let ApplicationCommandInfoCommandFlags_wantsKeyUpDownCallbacks* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::wantsKeyUpDownCallbacks".}: ApplicationCommandInfoCommandFlags
let ApplicationCommandInfoCommandFlags_hiddenFromKeyEditor* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::hiddenFromKeyEditor".}: ApplicationCommandInfoCommandFlags
let ApplicationCommandInfoCommandFlags_readOnlyInKeyEditor* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::readOnlyInKeyEditor".}: ApplicationCommandInfoCommandFlags
let ApplicationCommandInfoCommandFlags_dontTriggerVisualFeedback* {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo::dontTriggerVisualFeedback".}: ApplicationCommandInfoCommandFlags

let ButtonConnectedEdgeFlags_ConnectedOnLeft* {.header: juce_gui_basics, importcpp: "juce::Button::ConnectedOnLeft".}: ButtonConnectedEdgeFlags
let ButtonConnectedEdgeFlags_ConnectedOnRight* {.header: juce_gui_basics, importcpp: "juce::Button::ConnectedOnRight".}: ButtonConnectedEdgeFlags
let ButtonConnectedEdgeFlags_ConnectedOnTop* {.header: juce_gui_basics, importcpp: "juce::Button::ConnectedOnTop".}: ButtonConnectedEdgeFlags
let ButtonConnectedEdgeFlags_ConnectedOnBottom* {.header: juce_gui_basics, importcpp: "juce::Button::ConnectedOnBottom".}: ButtonConnectedEdgeFlags

let ButtonButtonState_buttonNormal* {.header: juce_gui_basics, importcpp: "juce::Button::buttonNormal".}: ButtonButtonState
let ButtonButtonState_buttonOver* {.header: juce_gui_basics, importcpp: "juce::Button::buttonOver".}: ButtonButtonState
let ButtonButtonState_buttonDown* {.header: juce_gui_basics, importcpp: "juce::Button::buttonDown".}: ButtonButtonState

let DrawableButtonButtonStyle_ImageFitted* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ImageFitted".}: DrawableButtonButtonStyle
let DrawableButtonButtonStyle_ImageRaw* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ImageRaw".}: DrawableButtonButtonStyle
let DrawableButtonButtonStyle_ImageAboveTextLabel* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ImageAboveTextLabel".}: DrawableButtonButtonStyle
let DrawableButtonButtonStyle_ImageOnButtonBackground* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ImageOnButtonBackground".}: DrawableButtonButtonStyle
let DrawableButtonButtonStyle_ImageOnButtonBackgroundOriginalSize* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ImageOnButtonBackgroundOriginalSize".}: DrawableButtonButtonStyle
let DrawableButtonButtonStyle_ImageStretched* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::ImageStretched".}: DrawableButtonButtonStyle

let DrawableButtonColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::textColourId".}: DrawableButtonColourIds
let DrawableButtonColourIds_textColourOnId* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::textColourOnId".}: DrawableButtonColourIds
let DrawableButtonColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::backgroundColourId".}: DrawableButtonColourIds
let DrawableButtonColourIds_backgroundOnColourId* {.header: juce_gui_basics, importcpp: "juce::DrawableButton::backgroundOnColourId".}: DrawableButtonColourIds

let HyperlinkButtonColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::HyperlinkButton::textColourId".}: HyperlinkButtonColourIds

let TextButtonColourIds_buttonColourId* {.header: juce_gui_basics, importcpp: "juce::TextButton::buttonColourId".}: TextButtonColourIds
let TextButtonColourIds_buttonOnColourId* {.header: juce_gui_basics, importcpp: "juce::TextButton::buttonOnColourId".}: TextButtonColourIds
let TextButtonColourIds_textColourOffId* {.header: juce_gui_basics, importcpp: "juce::TextButton::textColourOffId".}: TextButtonColourIds
let TextButtonColourIds_textColourOnId* {.header: juce_gui_basics, importcpp: "juce::TextButton::textColourOnId".}: TextButtonColourIds

let ToggleButtonColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::ToggleButton::textColourId".}: ToggleButtonColourIds
let ToggleButtonColourIds_tickColourId* {.header: juce_gui_basics, importcpp: "juce::ToggleButton::tickColourId".}: ToggleButtonColourIds
let ToggleButtonColourIds_tickDisabledColourId* {.header: juce_gui_basics, importcpp: "juce::ToggleButton::tickDisabledColourId".}: ToggleButtonColourIds

let GroupComponentColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::GroupComponent::outlineColourId".}: GroupComponentColourIds
let GroupComponentColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::GroupComponent::textColourId".}: GroupComponentColourIds

let ResizableEdgeComponentEdge_leftEdge* {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent::leftEdge".}: ResizableEdgeComponentEdge
let ResizableEdgeComponentEdge_rightEdge* {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent::rightEdge".}: ResizableEdgeComponentEdge
let ResizableEdgeComponentEdge_topEdge* {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent::topEdge".}: ResizableEdgeComponentEdge
let ResizableEdgeComponentEdge_bottomEdge* {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent::bottomEdge".}: ResizableEdgeComponentEdge

let ScrollBarColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::ScrollBar::backgroundColourId".}: ScrollBarColourIds
let ScrollBarColourIds_thumbColourId* {.header: juce_gui_basics, importcpp: "juce::ScrollBar::thumbColourId".}: ScrollBarColourIds
let ScrollBarColourIds_trackColourId* {.header: juce_gui_basics, importcpp: "juce::ScrollBar::trackColourId".}: ScrollBarColourIds

let TabBarButtonExtraComponentPlacement_beforeText* {.header: juce_gui_basics, importcpp: "juce::TabBarButton::beforeText".}: TabBarButtonExtraComponentPlacement
let TabBarButtonExtraComponentPlacement_afterText* {.header: juce_gui_basics, importcpp: "juce::TabBarButton::afterText".}: TabBarButtonExtraComponentPlacement

let TabbedButtonBarOrientation_TabsAtTop* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::TabsAtTop".}: TabbedButtonBarOrientation
let TabbedButtonBarOrientation_TabsAtBottom* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::TabsAtBottom".}: TabbedButtonBarOrientation
let TabbedButtonBarOrientation_TabsAtLeft* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::TabsAtLeft".}: TabbedButtonBarOrientation
let TabbedButtonBarOrientation_TabsAtRight* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::TabsAtRight".}: TabbedButtonBarOrientation

let TabbedButtonBarColourIds_tabOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::tabOutlineColourId".}: TabbedButtonBarColourIds
let TabbedButtonBarColourIds_tabTextColourId* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::tabTextColourId".}: TabbedButtonBarColourIds
let TabbedButtonBarColourIds_frontOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::frontOutlineColourId".}: TabbedButtonBarColourIds
let TabbedButtonBarColourIds_frontTextColourId* {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar::frontTextColourId".}: TabbedButtonBarColourIds

let TabbedComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TabbedComponent::backgroundColourId".}: TabbedComponentColourIds
let TabbedComponentColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::TabbedComponent::outlineColourId".}: TabbedComponentColourIds

let AccessibilityHandlerAnnouncementPriority_low* {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler::AnnouncementPriority::low".}: AccessibilityHandlerAnnouncementPriority
let AccessibilityHandlerAnnouncementPriority_medium* {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler::AnnouncementPriority::medium".}: AccessibilityHandlerAnnouncementPriority
let AccessibilityHandlerAnnouncementPriority_high* {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler::AnnouncementPriority::high".}: AccessibilityHandlerAnnouncementPriority

let ViewportScrollOnDragMode_never* {.header: juce_gui_basics, importcpp: "juce::Viewport::ScrollOnDragMode::never".}: ViewportScrollOnDragMode
let ViewportScrollOnDragMode_nonHover* {.header: juce_gui_basics, importcpp: "juce::Viewport::ScrollOnDragMode::nonHover".}: ViewportScrollOnDragMode
let ViewportScrollOnDragMode_all* {.header: juce_gui_basics, importcpp: "juce::Viewport::ScrollOnDragMode::all".}: ViewportScrollOnDragMode

let PopupMenuColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::backgroundColourId".}: PopupMenuColourIds
let PopupMenuColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::textColourId".}: PopupMenuColourIds
let PopupMenuColourIds_headerTextColourId* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::headerTextColourId".}: PopupMenuColourIds
let PopupMenuColourIds_highlightedBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::highlightedBackgroundColourId".}: PopupMenuColourIds
let PopupMenuColourIds_highlightedTextColourId* {.header: juce_gui_basics, importcpp: "juce::PopupMenu::highlightedTextColourId".}: PopupMenuColourIds

let RelativePointPathElementType_nullElement* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::nullElement".}: RelativePointPathElementType
let RelativePointPathElementType_startSubPathElement* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::startSubPathElement".}: RelativePointPathElementType
let RelativePointPathElementType_closeSubPathElement* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::closeSubPathElement".}: RelativePointPathElementType
let RelativePointPathElementType_lineToElement* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::lineToElement".}: RelativePointPathElementType
let RelativePointPathElementType_quadraticToElement* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::quadraticToElement".}: RelativePointPathElementType
let RelativePointPathElementType_cubicToElement* {.header: juce_gui_basics, importcpp: "juce::RelativePointPath::cubicToElement".}: RelativePointPathElementType

let TextEditorColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::backgroundColourId".}: TextEditorColourIds
let TextEditorColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::textColourId".}: TextEditorColourIds
let TextEditorColourIds_highlightColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::highlightColourId".}: TextEditorColourIds
let TextEditorColourIds_highlightedTextColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::highlightedTextColourId".}: TextEditorColourIds
let TextEditorColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::outlineColourId".}: TextEditorColourIds
let TextEditorColourIds_focusedOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::focusedOutlineColourId".}: TextEditorColourIds
let TextEditorColourIds_shadowColourId* {.header: juce_gui_basics, importcpp: "juce::TextEditor::shadowColourId".}: TextEditorColourIds

let LabelColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Label::backgroundColourId".}: LabelColourIds
let LabelColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::Label::textColourId".}: LabelColourIds
let LabelColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::Label::outlineColourId".}: LabelColourIds
let LabelColourIds_backgroundWhenEditingColourId* {.header: juce_gui_basics, importcpp: "juce::Label::backgroundWhenEditingColourId".}: LabelColourIds
let LabelColourIds_textWhenEditingColourId* {.header: juce_gui_basics, importcpp: "juce::Label::textWhenEditingColourId".}: LabelColourIds
let LabelColourIds_outlineWhenEditingColourId* {.header: juce_gui_basics, importcpp: "juce::Label::outlineWhenEditingColourId".}: LabelColourIds

let ComboBoxColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::ComboBox::backgroundColourId".}: ComboBoxColourIds
let ComboBoxColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::ComboBox::textColourId".}: ComboBoxColourIds
let ComboBoxColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::ComboBox::outlineColourId".}: ComboBoxColourIds
let ComboBoxColourIds_buttonColourId* {.header: juce_gui_basics, importcpp: "juce::ComboBox::buttonColourId".}: ComboBoxColourIds
let ComboBoxColourIds_arrowColourId* {.header: juce_gui_basics, importcpp: "juce::ComboBox::arrowColourId".}: ComboBoxColourIds
let ComboBoxColourIds_focusedOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::ComboBox::focusedOutlineColourId".}: ComboBoxColourIds

let ListBoxColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::ListBox::backgroundColourId".}: ListBoxColourIds
let ListBoxColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::ListBox::outlineColourId".}: ListBoxColourIds
let ListBoxColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::ListBox::textColourId".}: ListBoxColourIds

let ProgressBarStyle_linear* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::Style::linear".}: ProgressBarStyle
let ProgressBarStyle_circular* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::Style::circular".}: ProgressBarStyle

let ProgressBarColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::backgroundColourId".}: ProgressBarColourIds
let ProgressBarColourIds_foregroundColourId* {.header: juce_gui_basics, importcpp: "juce::ProgressBar::foregroundColourId".}: ProgressBarColourIds

let SliderSliderStyle_LinearHorizontal* {.header: juce_gui_basics, importcpp: "juce::Slider::LinearHorizontal".}: SliderSliderStyle
let SliderSliderStyle_LinearVertical* {.header: juce_gui_basics, importcpp: "juce::Slider::LinearVertical".}: SliderSliderStyle
let SliderSliderStyle_LinearBar* {.header: juce_gui_basics, importcpp: "juce::Slider::LinearBar".}: SliderSliderStyle
let SliderSliderStyle_LinearBarVertical* {.header: juce_gui_basics, importcpp: "juce::Slider::LinearBarVertical".}: SliderSliderStyle
let SliderSliderStyle_Rotary* {.header: juce_gui_basics, importcpp: "juce::Slider::Rotary".}: SliderSliderStyle
let SliderSliderStyle_RotaryHorizontalDrag* {.header: juce_gui_basics, importcpp: "juce::Slider::RotaryHorizontalDrag".}: SliderSliderStyle
let SliderSliderStyle_RotaryVerticalDrag* {.header: juce_gui_basics, importcpp: "juce::Slider::RotaryVerticalDrag".}: SliderSliderStyle
let SliderSliderStyle_RotaryHorizontalVerticalDrag* {.header: juce_gui_basics, importcpp: "juce::Slider::RotaryHorizontalVerticalDrag".}: SliderSliderStyle
let SliderSliderStyle_IncDecButtons* {.header: juce_gui_basics, importcpp: "juce::Slider::IncDecButtons".}: SliderSliderStyle
let SliderSliderStyle_TwoValueHorizontal* {.header: juce_gui_basics, importcpp: "juce::Slider::TwoValueHorizontal".}: SliderSliderStyle
let SliderSliderStyle_TwoValueVertical* {.header: juce_gui_basics, importcpp: "juce::Slider::TwoValueVertical".}: SliderSliderStyle
let SliderSliderStyle_ThreeValueHorizontal* {.header: juce_gui_basics, importcpp: "juce::Slider::ThreeValueHorizontal".}: SliderSliderStyle
let SliderSliderStyle_ThreeValueVertical* {.header: juce_gui_basics, importcpp: "juce::Slider::ThreeValueVertical".}: SliderSliderStyle

let SliderTextEntryBoxPosition_NoTextBox* {.header: juce_gui_basics, importcpp: "juce::Slider::NoTextBox".}: SliderTextEntryBoxPosition
let SliderTextEntryBoxPosition_TextBoxLeft* {.header: juce_gui_basics, importcpp: "juce::Slider::TextBoxLeft".}: SliderTextEntryBoxPosition
let SliderTextEntryBoxPosition_TextBoxRight* {.header: juce_gui_basics, importcpp: "juce::Slider::TextBoxRight".}: SliderTextEntryBoxPosition
let SliderTextEntryBoxPosition_TextBoxAbove* {.header: juce_gui_basics, importcpp: "juce::Slider::TextBoxAbove".}: SliderTextEntryBoxPosition
let SliderTextEntryBoxPosition_TextBoxBelow* {.header: juce_gui_basics, importcpp: "juce::Slider::TextBoxBelow".}: SliderTextEntryBoxPosition

let SliderDragMode_notDragging* {.header: juce_gui_basics, importcpp: "juce::Slider::notDragging".}: SliderDragMode
let SliderDragMode_absoluteDrag* {.header: juce_gui_basics, importcpp: "juce::Slider::absoluteDrag".}: SliderDragMode
let SliderDragMode_velocityDrag* {.header: juce_gui_basics, importcpp: "juce::Slider::velocityDrag".}: SliderDragMode

let SliderIncDecButtonMode_incDecButtonsNotDraggable* {.header: juce_gui_basics, importcpp: "juce::Slider::incDecButtonsNotDraggable".}: SliderIncDecButtonMode
let SliderIncDecButtonMode_incDecButtonsDraggable_AutoDirection* {.header: juce_gui_basics, importcpp: "juce::Slider::incDecButtonsDraggable_AutoDirection".}: SliderIncDecButtonMode
let SliderIncDecButtonMode_incDecButtonsDraggable_Horizontal* {.header: juce_gui_basics, importcpp: "juce::Slider::incDecButtonsDraggable_Horizontal".}: SliderIncDecButtonMode
let SliderIncDecButtonMode_incDecButtonsDraggable_Vertical* {.header: juce_gui_basics, importcpp: "juce::Slider::incDecButtonsDraggable_Vertical".}: SliderIncDecButtonMode

let SliderColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::backgroundColourId".}: SliderColourIds
let SliderColourIds_thumbColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::thumbColourId".}: SliderColourIds
let SliderColourIds_trackColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::trackColourId".}: SliderColourIds
let SliderColourIds_rotarySliderFillColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::rotarySliderFillColourId".}: SliderColourIds
let SliderColourIds_rotarySliderOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::rotarySliderOutlineColourId".}: SliderColourIds
let SliderColourIds_textBoxTextColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::textBoxTextColourId".}: SliderColourIds
let SliderColourIds_textBoxBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::textBoxBackgroundColourId".}: SliderColourIds
let SliderColourIds_textBoxHighlightColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::textBoxHighlightColourId".}: SliderColourIds
let SliderColourIds_textBoxOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::Slider::textBoxOutlineColourId".}: SliderColourIds

let TableHeaderComponentColumnPropertyFlags_visible* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::visible".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_resizable* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::resizable".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_draggable* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::draggable".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_appearsOnColumnMenu* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::appearsOnColumnMenu".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_sortable* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::sortable".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_sortedForwards* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::sortedForwards".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_sortedBackwards* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::sortedBackwards".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_defaultFlags* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::defaultFlags".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_notResizable* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::notResizable".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_notResizableOrSortable* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::notResizableOrSortable".}: TableHeaderComponentColumnPropertyFlags
let TableHeaderComponentColumnPropertyFlags_notSortable* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::notSortable".}: TableHeaderComponentColumnPropertyFlags

let TableHeaderComponentColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::textColourId".}: TableHeaderComponentColourIds
let TableHeaderComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::backgroundColourId".}: TableHeaderComponentColourIds
let TableHeaderComponentColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::outlineColourId".}: TableHeaderComponentColourIds
let TableHeaderComponentColourIds_highlightColourId* {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent::highlightColourId".}: TableHeaderComponentColourIds

let ToolbarToolbarItemStyle_iconsOnly* {.header: juce_gui_basics, importcpp: "juce::Toolbar::iconsOnly".}: ToolbarToolbarItemStyle
let ToolbarToolbarItemStyle_iconsWithText* {.header: juce_gui_basics, importcpp: "juce::Toolbar::iconsWithText".}: ToolbarToolbarItemStyle
let ToolbarToolbarItemStyle_textOnly* {.header: juce_gui_basics, importcpp: "juce::Toolbar::textOnly".}: ToolbarToolbarItemStyle

let ToolbarCustomisationFlags_allowIconsOnlyChoice* {.header: juce_gui_basics, importcpp: "juce::Toolbar::allowIconsOnlyChoice".}: ToolbarCustomisationFlags
let ToolbarCustomisationFlags_allowIconsWithTextChoice* {.header: juce_gui_basics, importcpp: "juce::Toolbar::allowIconsWithTextChoice".}: ToolbarCustomisationFlags
let ToolbarCustomisationFlags_allowTextOnlyChoice* {.header: juce_gui_basics, importcpp: "juce::Toolbar::allowTextOnlyChoice".}: ToolbarCustomisationFlags
let ToolbarCustomisationFlags_showResetToDefaultsButton* {.header: juce_gui_basics, importcpp: "juce::Toolbar::showResetToDefaultsButton".}: ToolbarCustomisationFlags
let ToolbarCustomisationFlags_allCustomisationOptionsEnabled* {.header: juce_gui_basics, importcpp: "juce::Toolbar::allCustomisationOptionsEnabled".}: ToolbarCustomisationFlags

let ToolbarColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::backgroundColourId".}: ToolbarColourIds
let ToolbarColourIds_separatorColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::separatorColourId".}: ToolbarColourIds
let ToolbarColourIds_buttonMouseOverBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::buttonMouseOverBackgroundColourId".}: ToolbarColourIds
let ToolbarColourIds_buttonMouseDownBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::buttonMouseDownBackgroundColourId".}: ToolbarColourIds
let ToolbarColourIds_labelTextColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::labelTextColourId".}: ToolbarColourIds
let ToolbarColourIds_editingModeOutlineColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::editingModeOutlineColourId".}: ToolbarColourIds
let ToolbarColourIds_customisationDialogBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::Toolbar::customisationDialogBackgroundColourId".}: ToolbarColourIds

let ToolbarItemComponentToolbarEditingMode_normalMode* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemComponent::normalMode".}: ToolbarItemComponentToolbarEditingMode
let ToolbarItemComponentToolbarEditingMode_editableOnToolbar* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemComponent::editableOnToolbar".}: ToolbarItemComponentToolbarEditingMode
let ToolbarItemComponentToolbarEditingMode_editableOnPalette* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemComponent::editableOnPalette".}: ToolbarItemComponentToolbarEditingMode

let ToolbarItemFactorySpecialItemIds_separatorBarId* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemFactory::separatorBarId".}: ToolbarItemFactorySpecialItemIds
let ToolbarItemFactorySpecialItemIds_spacerId* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemFactory::spacerId".}: ToolbarItemFactorySpecialItemIds
let ToolbarItemFactorySpecialItemIds_flexibleSpacerId* {.header: juce_gui_basics, importcpp: "juce::ToolbarItemFactory::flexibleSpacerId".}: ToolbarItemFactorySpecialItemIds

let TreeViewItemOpenness_opennessDefault* {.header: juce_gui_basics, importcpp: "juce::TreeViewItem::Openness::opennessDefault".}: TreeViewItemOpenness
let TreeViewItemOpenness_opennessClosed* {.header: juce_gui_basics, importcpp: "juce::TreeViewItem::Openness::opennessClosed".}: TreeViewItemOpenness
let TreeViewItemOpenness_opennessOpen* {.header: juce_gui_basics, importcpp: "juce::TreeViewItem::Openness::opennessOpen".}: TreeViewItemOpenness

let TreeViewColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TreeView::backgroundColourId".}: TreeViewColourIds
let TreeViewColourIds_linesColourId* {.header: juce_gui_basics, importcpp: "juce::TreeView::linesColourId".}: TreeViewColourIds
let TreeViewColourIds_dragAndDropIndicatorColourId* {.header: juce_gui_basics, importcpp: "juce::TreeView::dragAndDropIndicatorColourId".}: TreeViewColourIds
let TreeViewColourIds_selectedItemBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TreeView::selectedItemBackgroundColourId".}: TreeViewColourIds
let TreeViewColourIds_oddItemsColourId* {.header: juce_gui_basics, importcpp: "juce::TreeView::oddItemsColourId".}: TreeViewColourIds
let TreeViewColourIds_evenItemsColourId* {.header: juce_gui_basics, importcpp: "juce::TreeView::evenItemsColourId".}: TreeViewColourIds

let AlertWindowColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::AlertWindow::backgroundColourId".}: AlertWindowColourIds
let AlertWindowColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::AlertWindow::textColourId".}: AlertWindowColourIds
let AlertWindowColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::AlertWindow::outlineColourId".}: AlertWindowColourIds

let ComponentPeerStyleFlags_windowAppearsOnTaskbar* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowAppearsOnTaskbar".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowIsTemporary* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowIsTemporary".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowIgnoresMouseClicks* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowIgnoresMouseClicks".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowHasTitleBar* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowHasTitleBar".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowIsResizable* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowIsResizable".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowHasMinimiseButton* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowHasMinimiseButton".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowHasMaximiseButton* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowHasMaximiseButton".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowHasCloseButton* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowHasCloseButton".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowHasDropShadow* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowHasDropShadow".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowRepaintedExplicitly* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowRepaintedExplicitly".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowIgnoresKeyPresses* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowIgnoresKeyPresses".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowRequiresSynchronousCoreGraphicsRendering* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowRequiresSynchronousCoreGraphicsRendering".}: ComponentPeerStyleFlags
let ComponentPeerStyleFlags_windowIsSemiTransparent* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::windowIsSemiTransparent".}: ComponentPeerStyleFlags

let ComponentPeerStyle_automatic* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::Style::automatic".}: ComponentPeerStyle
let ComponentPeerStyle_light* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::Style::light".}: ComponentPeerStyle
let ComponentPeerStyle_dark* {.header: juce_gui_basics, importcpp: "juce::ComponentPeer::Style::dark".}: ComponentPeerStyle

let ResizableWindowColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::ResizableWindow::backgroundColourId".}: ResizableWindowColourIds

let DocumentWindowTitleBarButtons_minimiseButton* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::minimiseButton".}: DocumentWindowTitleBarButtons
let DocumentWindowTitleBarButtons_maximiseButton* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::maximiseButton".}: DocumentWindowTitleBarButtons
let DocumentWindowTitleBarButtons_closeButton* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::closeButton".}: DocumentWindowTitleBarButtons
let DocumentWindowTitleBarButtons_allButtons* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::allButtons".}: DocumentWindowTitleBarButtons

let DocumentWindowColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::DocumentWindow::textColourId".}: DocumentWindowColourIds

let TooltipWindowColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TooltipWindow::backgroundColourId".}: TooltipWindowColourIds
let TooltipWindowColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::TooltipWindow::textColourId".}: TooltipWindowColourIds
let TooltipWindowColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::TooltipWindow::outlineColourId".}: TooltipWindowColourIds

let MultiDocumentPanelLayoutMode_FloatingWindows* {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanel::FloatingWindows".}: MultiDocumentPanelLayoutMode
let MultiDocumentPanelLayoutMode_MaximisedWindowsWithTabs* {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanel::MaximisedWindowsWithTabs".}: MultiDocumentPanelLayoutMode

let SidePanelColourIds_backgroundColour* {.header: juce_gui_basics, importcpp: "juce::SidePanel::backgroundColour".}: SidePanelColourIds
let SidePanelColourIds_titleTextColour* {.header: juce_gui_basics, importcpp: "juce::SidePanel::titleTextColour".}: SidePanelColourIds
let SidePanelColourIds_shadowBaseColour* {.header: juce_gui_basics, importcpp: "juce::SidePanel::shadowBaseColour".}: SidePanelColourIds
let SidePanelColourIds_dismissButtonNormalColour* {.header: juce_gui_basics, importcpp: "juce::SidePanel::dismissButtonNormalColour".}: SidePanelColourIds
let SidePanelColourIds_dismissButtonOverColour* {.header: juce_gui_basics, importcpp: "juce::SidePanel::dismissButtonOverColour".}: SidePanelColourIds
let SidePanelColourIds_dismissButtonDownColour* {.header: juce_gui_basics, importcpp: "juce::SidePanel::dismissButtonDownColour".}: SidePanelColourIds

let DirectoryContentsDisplayComponentColourIds_highlightColourId* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsDisplayComponent::highlightColourId".}: DirectoryContentsDisplayComponentColourIds
let DirectoryContentsDisplayComponentColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsDisplayComponent::textColourId".}: DirectoryContentsDisplayComponentColourIds
let DirectoryContentsDisplayComponentColourIds_highlightedTextColourId* {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsDisplayComponent::highlightedTextColourId".}: DirectoryContentsDisplayComponentColourIds

let FileBrowserComponentFileChooserFlags_openMode* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::openMode".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_saveMode* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::saveMode".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_canSelectFiles* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::canSelectFiles".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_canSelectDirectories* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::canSelectDirectories".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_canSelectMultipleItems* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::canSelectMultipleItems".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_useTreeView* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::useTreeView".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_filenameBoxIsReadOnly* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::filenameBoxIsReadOnly".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_warnAboutOverwriting* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::warnAboutOverwriting".}: FileBrowserComponentFileChooserFlags
let FileBrowserComponentFileChooserFlags_doNotClearFileNameOnRootChange* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::doNotClearFileNameOnRootChange".}: FileBrowserComponentFileChooserFlags

let FileBrowserComponentColourIds_currentPathBoxBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::currentPathBoxBackgroundColourId".}: FileBrowserComponentColourIds
let FileBrowserComponentColourIds_currentPathBoxTextColourId* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::currentPathBoxTextColourId".}: FileBrowserComponentColourIds
let FileBrowserComponentColourIds_currentPathBoxArrowColourId* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::currentPathBoxArrowColourId".}: FileBrowserComponentColourIds
let FileBrowserComponentColourIds_filenameBoxBackgroundColourId* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::filenameBoxBackgroundColourId".}: FileBrowserComponentColourIds
let FileBrowserComponentColourIds_filenameBoxTextColourId* {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent::filenameBoxTextColourId".}: FileBrowserComponentColourIds

let FileChooserDialogBoxColourIds_titleTextColourId* {.header: juce_gui_basics, importcpp: "juce::FileChooserDialogBox::titleTextColourId".}: FileChooserDialogBoxColourIds

let FileSearchPathListComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::FileSearchPathListComponent::backgroundColourId".}: FileSearchPathListComponentColourIds

let PropertyComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::PropertyComponent::backgroundColourId".}: PropertyComponentColourIds
let PropertyComponentColourIds_labelTextColourId* {.header: juce_gui_basics, importcpp: "juce::PropertyComponent::labelTextColourId".}: PropertyComponentColourIds

let BooleanPropertyComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::BooleanPropertyComponent::backgroundColourId".}: BooleanPropertyComponentColourIds
let BooleanPropertyComponentColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::BooleanPropertyComponent::outlineColourId".}: BooleanPropertyComponentColourIds

let TextPropertyComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent::backgroundColourId".}: TextPropertyComponentColourIds
let TextPropertyComponentColourIds_textColourId* {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent::textColourId".}: TextPropertyComponentColourIds
let TextPropertyComponentColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent::outlineColourId".}: TextPropertyComponentColourIds

let BubbleComponentBubblePlacement_above* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::above".}: BubbleComponentBubblePlacement
let BubbleComponentBubblePlacement_below* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::below".}: BubbleComponentBubblePlacement
let BubbleComponentBubblePlacement_left* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::left".}: BubbleComponentBubblePlacement
let BubbleComponentBubblePlacement_right* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::right".}: BubbleComponentBubblePlacement

let BubbleComponentColourIds_backgroundColourId* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::backgroundColourId".}: BubbleComponentColourIds
let BubbleComponentColourIds_outlineColourId* {.header: juce_gui_basics, importcpp: "juce::BubbleComponent::outlineColourId".}: BubbleComponentColourIds

let FlexItemAlignSelf_autoAlign* {.header: juce_gui_basics, importcpp: "juce::FlexItem::AlignSelf::autoAlign".}: FlexItemAlignSelf
let FlexItemAlignSelf_flexStart* {.header: juce_gui_basics, importcpp: "juce::FlexItem::AlignSelf::flexStart".}: FlexItemAlignSelf
let FlexItemAlignSelf_flexEnd* {.header: juce_gui_basics, importcpp: "juce::FlexItem::AlignSelf::flexEnd".}: FlexItemAlignSelf
let FlexItemAlignSelf_center* {.header: juce_gui_basics, importcpp: "juce::FlexItem::AlignSelf::center".}: FlexItemAlignSelf
let FlexItemAlignSelf_stretch* {.header: juce_gui_basics, importcpp: "juce::FlexItem::AlignSelf::stretch".}: FlexItemAlignSelf

let FlexBoxDirection_row* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Direction::row".}: FlexBoxDirection
let FlexBoxDirection_rowReverse* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Direction::rowReverse".}: FlexBoxDirection
let FlexBoxDirection_column* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Direction::column".}: FlexBoxDirection
let FlexBoxDirection_columnReverse* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Direction::columnReverse".}: FlexBoxDirection

let FlexBoxWrap_noWrap* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Wrap::noWrap".}: FlexBoxWrap
let FlexBoxWrap_wrap* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Wrap::wrap".}: FlexBoxWrap
let FlexBoxWrap_wrapReverse* {.header: juce_gui_basics, importcpp: "juce::FlexBox::Wrap::wrapReverse".}: FlexBoxWrap

let FlexBoxAlignContent_stretch* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent::stretch".}: FlexBoxAlignContent
let FlexBoxAlignContent_flexStart* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent::flexStart".}: FlexBoxAlignContent
let FlexBoxAlignContent_flexEnd* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent::flexEnd".}: FlexBoxAlignContent
let FlexBoxAlignContent_center* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent::center".}: FlexBoxAlignContent
let FlexBoxAlignContent_spaceBetween* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent::spaceBetween".}: FlexBoxAlignContent
let FlexBoxAlignContent_spaceAround* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignContent::spaceAround".}: FlexBoxAlignContent

let FlexBoxAlignItems_stretch* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignItems::stretch".}: FlexBoxAlignItems
let FlexBoxAlignItems_flexStart* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignItems::flexStart".}: FlexBoxAlignItems
let FlexBoxAlignItems_flexEnd* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignItems::flexEnd".}: FlexBoxAlignItems
let FlexBoxAlignItems_center* {.header: juce_gui_basics, importcpp: "juce::FlexBox::AlignItems::center".}: FlexBoxAlignItems

let FlexBoxJustifyContent_flexStart* {.header: juce_gui_basics, importcpp: "juce::FlexBox::JustifyContent::flexStart".}: FlexBoxJustifyContent
let FlexBoxJustifyContent_flexEnd* {.header: juce_gui_basics, importcpp: "juce::FlexBox::JustifyContent::flexEnd".}: FlexBoxJustifyContent
let FlexBoxJustifyContent_center* {.header: juce_gui_basics, importcpp: "juce::FlexBox::JustifyContent::center".}: FlexBoxJustifyContent
let FlexBoxJustifyContent_spaceBetween* {.header: juce_gui_basics, importcpp: "juce::FlexBox::JustifyContent::spaceBetween".}: FlexBoxJustifyContent
let FlexBoxJustifyContent_spaceAround* {.header: juce_gui_basics, importcpp: "juce::FlexBox::JustifyContent::spaceAround".}: FlexBoxJustifyContent

let GridItemKeyword_autoValue* {.header: juce_gui_basics, importcpp: "juce::GridItem::Keyword::autoValue".}: GridItemKeyword

let GridItemJustifySelf_start* {.header: juce_gui_basics, importcpp: "juce::GridItem::JustifySelf::start".}: GridItemJustifySelf
let GridItemJustifySelf_end* {.header: juce_gui_basics, importcpp: "juce::GridItem::JustifySelf::end".}: GridItemJustifySelf
let GridItemJustifySelf_center* {.header: juce_gui_basics, importcpp: "juce::GridItem::JustifySelf::center".}: GridItemJustifySelf
let GridItemJustifySelf_stretch* {.header: juce_gui_basics, importcpp: "juce::GridItem::JustifySelf::stretch".}: GridItemJustifySelf
let GridItemJustifySelf_autoValue* {.header: juce_gui_basics, importcpp: "juce::GridItem::JustifySelf::autoValue".}: GridItemJustifySelf

let GridItemAlignSelf_start* {.header: juce_gui_basics, importcpp: "juce::GridItem::AlignSelf::start".}: GridItemAlignSelf
let GridItemAlignSelf_end* {.header: juce_gui_basics, importcpp: "juce::GridItem::AlignSelf::end".}: GridItemAlignSelf
let GridItemAlignSelf_center* {.header: juce_gui_basics, importcpp: "juce::GridItem::AlignSelf::center".}: GridItemAlignSelf
let GridItemAlignSelf_stretch* {.header: juce_gui_basics, importcpp: "juce::GridItem::AlignSelf::stretch".}: GridItemAlignSelf
let GridItemAlignSelf_autoValue* {.header: juce_gui_basics, importcpp: "juce::GridItem::AlignSelf::autoValue".}: GridItemAlignSelf

let GridJustifyItems_start* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyItems::start".}: GridJustifyItems
let GridJustifyItems_end* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyItems::end".}: GridJustifyItems
let GridJustifyItems_center* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyItems::center".}: GridJustifyItems
let GridJustifyItems_stretch* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyItems::stretch".}: GridJustifyItems

let GridAlignItems_start* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignItems::start".}: GridAlignItems
let GridAlignItems_end* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignItems::end".}: GridAlignItems
let GridAlignItems_center* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignItems::center".}: GridAlignItems
let GridAlignItems_stretch* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignItems::stretch".}: GridAlignItems

let GridJustifyContent_start* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::start".}: GridJustifyContent
let GridJustifyContent_end* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::end".}: GridJustifyContent
let GridJustifyContent_center* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::center".}: GridJustifyContent
let GridJustifyContent_stretch* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::stretch".}: GridJustifyContent
let GridJustifyContent_spaceAround* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::spaceAround".}: GridJustifyContent
let GridJustifyContent_spaceBetween* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::spaceBetween".}: GridJustifyContent
let GridJustifyContent_spaceEvenly* {.header: juce_gui_basics, importcpp: "juce::Grid::JustifyContent::spaceEvenly".}: GridJustifyContent

let GridAlignContent_start* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::start".}: GridAlignContent
let GridAlignContent_end* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::end".}: GridAlignContent
let GridAlignContent_center* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::center".}: GridAlignContent
let GridAlignContent_stretch* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::stretch".}: GridAlignContent
let GridAlignContent_spaceAround* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::spaceAround".}: GridAlignContent
let GridAlignContent_spaceBetween* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::spaceBetween".}: GridAlignContent
let GridAlignContent_spaceEvenly* {.header: juce_gui_basics, importcpp: "juce::Grid::AlignContent::spaceEvenly".}: GridAlignContent

let GridAutoFlow_row* {.header: juce_gui_basics, importcpp: "juce::Grid::AutoFlow::row".}: GridAutoFlow
let GridAutoFlow_column* {.header: juce_gui_basics, importcpp: "juce::Grid::AutoFlow::column".}: GridAutoFlow
let GridAutoFlow_rowDense* {.header: juce_gui_basics, importcpp: "juce::Grid::AutoFlow::rowDense".}: GridAutoFlow
let GridAutoFlow_columnDense* {.header: juce_gui_basics, importcpp: "juce::Grid::AutoFlow::columnDense".}: GridAutoFlow

const
  GridItem_useDefaultValue*: cint = -2
  GridItem_notAssigned*: cint = -1

proc makeMouseCursor*(): MouseCursor {.header: juce_gui_basics, importcpp: "juce::MouseCursor(@)".}
proc makeMouseCursor*(arg1: MouseCursorStandardCursorType): MouseCursor {.header: juce_gui_basics, importcpp: "juce::MouseCursor(@)".}
proc makeMouseCursor*(image: Image, hotSpotX: cint, hotSpotY: cint): MouseCursor {.header: juce_gui_basics, importcpp: "juce::MouseCursor(@)".}
proc makeMouseCursor*(image: Image, hotSpotX: cint, hotSpotY: cint, scaleFactor: cfloat): MouseCursor {.header: juce_gui_basics, importcpp: "juce::MouseCursor(@)".}
proc makeMouseCursor*(image: ScaledImage, hotSpot: Point[cint]): MouseCursor {.header: juce_gui_basics, importcpp: "juce::MouseCursor(@)".}
proc `MouseCursor=`*(this: var MouseCursor, arg1: MouseCursor): var MouseCursor {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc `==`*(this: MouseCursor, arg1: MouseCursor): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: MouseCursor, arg1: MouseCursor): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc `==`*(this: MouseCursor, `type`: MouseCursorStandardCursorType): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: MouseCursor, `type`: MouseCursorStandardCursorType): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==

proc mouseMove*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseMove(@)".}
proc mouseEnter*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseEnter(@)".}
proc mouseExit*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseExit(@)".}
proc mouseDown*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc mouseDoubleClick*(this: var MouseListener, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDoubleClick(@)".}
proc mouseWheelMove*(this: var MouseListener, event: MouseEvent, wheel: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc mouseMagnify*(this: var MouseListener, event: MouseEvent, scaleFactor: cfloat) {.header: juce_gui_basics, importcpp: "#.mouseMagnify(@)".}
proc `==`*(this: MouseListener, other: MouseListener): bool {.error: "juce::MouseListener defines no operator==; compare a property instead".}

proc makeModifierKeys*(): ModifierKeys {.header: juce_gui_basics, importcpp: "juce::ModifierKeys(@)".}
proc makeModifierKeys*(flags: cint): ModifierKeys {.header: juce_gui_basics, importcpp: "juce::ModifierKeys(@)".}
proc `ModifierKeys=`*(this: var ModifierKeys, arg1: ModifierKeys): var ModifierKeys {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc isCommandDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isCommandDown()".}
proc isPopupMenu*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isPopupMenu()".}
proc isLeftButtonDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isLeftButtonDown()".}
proc isRightButtonDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isRightButtonDown()".}
proc isMiddleButtonDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isMiddleButtonDown()".}
proc isBackButtonDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isBackButtonDown()".}
proc isForwardButtonDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isForwardButtonDown()".}
proc isAnyMouseButtonDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isAnyMouseButtonDown()".}
proc isAnyModifierKeyDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isAnyModifierKeyDown()".}
proc isShiftDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isShiftDown()".}
proc isCtrlDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isCtrlDown()".}
proc isAltDown*(this: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.isAltDown()".}
proc withOnlyMouseButtons*(this: ModifierKeys): ModifierKeys {.header: juce_gui_basics, importcpp: "#.withOnlyMouseButtons()".}
proc withoutMouseButtons*(this: ModifierKeys): ModifierKeys {.header: juce_gui_basics, importcpp: "#.withoutMouseButtons()".}
proc `==`*(this: ModifierKeys, other: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: ModifierKeys, other: ModifierKeys): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc getRawFlags*(this: ModifierKeys): cint {.header: juce_gui_basics, importcpp: "#.getRawFlags()".}
proc withoutFlags*(this: ModifierKeys, rawFlagsToClear: cint): ModifierKeys {.header: juce_gui_basics, importcpp: "#.withoutFlags(@)".}
proc withFlags*(this: ModifierKeys, rawFlagsToSet: cint): ModifierKeys {.header: juce_gui_basics, importcpp: "#.withFlags(@)".}
proc testFlags*(this: ModifierKeys, flagsToTest: cint): bool {.header: juce_gui_basics, importcpp: "#.testFlags(@)".}
proc getNumMouseButtonsDown*(this: ModifierKeys): cint {.header: juce_gui_basics, importcpp: "#.getNumMouseButtonsDown()".}

proc `MouseInputSource=`*(this: var MouseInputSource, arg1: MouseInputSource): var MouseInputSource {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc `==`*(this: MouseInputSource, other: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: MouseInputSource, other: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc getType*(this: MouseInputSource): MouseInputSourceInputSourceType {.header: juce_gui_basics, importcpp: "#.getType()".}
proc isMouse*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isMouse()".}
proc isTouch*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isTouch()".}
proc isPen*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isPen()".}
proc canHover*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.canHover()".}
proc hasMouseWheel*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.hasMouseWheel()".}
proc getIndex*(this: MouseInputSource): cint {.header: juce_gui_basics, importcpp: "#.getIndex()".}
proc isDragging*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isDragging()".}
proc getScreenPosition*(this: MouseInputSource): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.getScreenPosition()".}
proc getRawScreenPosition*(this: MouseInputSource): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.getRawScreenPosition()".}
proc getCurrentModifiers*(this: MouseInputSource): ModifierKeys {.header: juce_gui_basics, importcpp: "#.getCurrentModifiers()".}
proc getCurrentPressure*(this: MouseInputSource): cfloat {.header: juce_gui_basics, importcpp: "#.getCurrentPressure()".}
proc getCurrentOrientation*(this: MouseInputSource): cfloat {.header: juce_gui_basics, importcpp: "#.getCurrentOrientation()".}
proc getCurrentRotation*(this: MouseInputSource): cfloat {.header: juce_gui_basics, importcpp: "#.getCurrentRotation()".}
proc getCurrentTilt*(this: MouseInputSource, tiltX: bool): cfloat {.header: juce_gui_basics, importcpp: "#.getCurrentTilt(@)".}
proc isPressureValid*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isPressureValid()".}
proc isOrientationValid*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isOrientationValid()".}
proc isRotationValid*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isRotationValid()".}
proc isTiltValid*(this: MouseInputSource, tiltX: bool): bool {.header: juce_gui_basics, importcpp: "#.isTiltValid(@)".}
proc getComponentUnderMouse*(this: MouseInputSource): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponentUnderMouse()".}
proc triggerFakeMove*(this: MouseInputSource) {.header: juce_gui_basics, importcpp: "#.triggerFakeMove()".}
proc getNumberOfMultipleClicks*(this: MouseInputSource): cint {.header: juce_gui_basics, importcpp: "#.getNumberOfMultipleClicks()".}
proc getLastMouseDownTime*(this: MouseInputSource): Time {.header: juce_gui_basics, importcpp: "#.getLastMouseDownTime()".}
proc getLastMouseDownPosition*(this: MouseInputSource): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.getLastMouseDownPosition()".}
proc isLongPressOrDrag*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isLongPressOrDrag()".}
proc hasMovedSignificantlySincePressed*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.hasMovedSignificantlySincePressed()".}
proc hasMouseCursor*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.hasMouseCursor()".}
proc showMouseCursor*(this: var MouseInputSource, cursor: MouseCursor) {.header: juce_gui_basics, importcpp: "#.showMouseCursor(@)".}
proc hideCursor*(this: var MouseInputSource) {.header: juce_gui_basics, importcpp: "#.hideCursor()".}
proc revealCursor*(this: var MouseInputSource) {.header: juce_gui_basics, importcpp: "#.revealCursor()".}
proc forceMouseCursorUpdate*(this: var MouseInputSource) {.header: juce_gui_basics, importcpp: "#.forceMouseCursorUpdate()".}
proc canDoUnboundedMovement*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.canDoUnboundedMovement()".}
proc enableUnboundedMouseMovement*(this: MouseInputSource, isEnabled: bool, keepCursorVisibleUntilOffscreen: bool = false) {.header: juce_gui_basics, importcpp: "#.enableUnboundedMouseMovement(@)".}
proc isUnboundedMouseMovementEnabled*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.isUnboundedMouseMovementEnabled()".}
proc setScreenPosition*(this: var MouseInputSource, newPosition: Point[cfloat]) {.header: juce_gui_basics, importcpp: "#.setScreenPosition(@)".}
proc hasMouseMovedSignificantlySincePressed*(this: MouseInputSource): bool {.header: juce_gui_basics, importcpp: "#.hasMouseMovedSignificantlySincePressed()".}

proc makeMouseEvent*(source: MouseInputSource, position: Point[cfloat], modifiers: ModifierKeys, pressure: cfloat, orientation: cfloat, rotation: cfloat, tiltX: cfloat, tiltY: cfloat, eventComponent: ptr Component, originator: ptr Component, eventTime: Time, mouseDownPos: Point[cfloat], mouseDownTime: Time, numberOfClicks: cint, mouseWasDragged: bool): MouseEvent {.header: juce_gui_basics, importcpp: "juce::MouseEvent(@)".}
proc `MouseEvent=`*(this: var MouseEvent, arg1: MouseEvent): var MouseEvent {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc getMouseDownX*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getMouseDownX()".}
proc getMouseDownY*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getMouseDownY()".}
proc getMouseDownPosition*(this: MouseEvent): Point[cint] {.header: juce_gui_basics, importcpp: "#.getMouseDownPosition()".}
proc getDistanceFromDragStart*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getDistanceFromDragStart()".}
proc getDistanceFromDragStartX*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getDistanceFromDragStartX()".}
proc getDistanceFromDragStartY*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getDistanceFromDragStartY()".}
proc getOffsetFromDragStart*(this: MouseEvent): Point[cint] {.header: juce_gui_basics, importcpp: "#.getOffsetFromDragStart()".}
proc mouseWasDraggedSinceMouseDown*(this: MouseEvent): bool {.header: juce_gui_basics, importcpp: "#.mouseWasDraggedSinceMouseDown()".}
proc mouseWasClicked*(this: MouseEvent): bool {.header: juce_gui_basics, importcpp: "#.mouseWasClicked()".}
proc getNumberOfClicks*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getNumberOfClicks()".}
proc getLengthOfMousePress*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getLengthOfMousePress()".}
proc isPressureValid*(this: MouseEvent): bool {.header: juce_gui_basics, importcpp: "#.isPressureValid()".}
proc isOrientationValid*(this: MouseEvent): bool {.header: juce_gui_basics, importcpp: "#.isOrientationValid()".}
proc isRotationValid*(this: MouseEvent): bool {.header: juce_gui_basics, importcpp: "#.isRotationValid()".}
proc isTiltValid*(this: MouseEvent, tiltX: bool): bool {.header: juce_gui_basics, importcpp: "#.isTiltValid(@)".}
proc getPosition*(this: MouseEvent): Point[cint] {.header: juce_gui_basics, importcpp: "#.getPosition()".}
proc getScreenX*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getScreenX()".}
proc getScreenY*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getScreenY()".}
proc getScreenPosition*(this: MouseEvent): Point[cint] {.header: juce_gui_basics, importcpp: "#.getScreenPosition()".}
proc getMouseDownScreenX*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getMouseDownScreenX()".}
proc getMouseDownScreenY*(this: MouseEvent): cint {.header: juce_gui_basics, importcpp: "#.getMouseDownScreenY()".}
proc getMouseDownScreenPosition*(this: MouseEvent): Point[cint] {.header: juce_gui_basics, importcpp: "#.getMouseDownScreenPosition()".}
proc getEventRelativeTo*(this: MouseEvent, newComponent: ptr Component): MouseEvent {.header: juce_gui_basics, importcpp: "#.getEventRelativeTo(@)".}
proc withNewPosition*(this: MouseEvent, newPosition: Point[cfloat]): MouseEvent {.header: juce_gui_basics, importcpp: "#.withNewPosition(@)".}
proc withNewPosition*(this: MouseEvent, newPosition: Point[cint]): MouseEvent {.header: juce_gui_basics, importcpp: "#.withNewPosition(@)".}
proc `==`*(this: MouseEvent, other: MouseEvent): bool {.error: "juce::MouseEvent defines no operator==; compare a property instead".}

proc `==`*(this: MouseWheelDetails, other: MouseWheelDetails): bool {.error: "juce::MouseWheelDetails defines no operator==; compare a property instead".}

proc `==`*(this: PenDetails, other: PenDetails): bool {.error: "juce::PenDetails defines no operator==; compare a property instead".}

proc makeKeyPress*(): KeyPress {.header: juce_gui_basics, importcpp: "juce::KeyPress(@)".}
proc makeKeyPress*(keyCode: cint, modifiers: ModifierKeys, textCharacter: uint16): KeyPress {.header: juce_gui_basics, importcpp: "juce::KeyPress(@)".}
proc makeKeyPress*(keyCode: cint): KeyPress {.header: juce_gui_basics, importcpp: "juce::KeyPress(@)".}
proc `KeyPress=`*(this: var KeyPress, arg1: KeyPress): var KeyPress {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc `==`*(this: KeyPress, other: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: KeyPress, other: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc `==`*(this: KeyPress, keyCode: cint): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: KeyPress, keyCode: cint): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc isValid*(this: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.isValid()".}
proc getKeyCode*(this: KeyPress): cint {.header: juce_gui_basics, importcpp: "#.getKeyCode()".}
proc getModifiers*(this: KeyPress): ModifierKeys {.header: juce_gui_basics, importcpp: "#.getModifiers()".}
proc getTextCharacter*(this: KeyPress): uint16 {.header: juce_gui_basics, importcpp: "#.getTextCharacter()".}
proc isKeyCode*(this: KeyPress, keyCodeToCompare: cint): bool {.header: juce_gui_basics, importcpp: "#.isKeyCode(@)".}
proc getTextDescription*(this: KeyPress): String {.header: juce_gui_basics, importcpp: "#.getTextDescription()".}
proc getTextDescriptionWithIcons*(this: KeyPress): String {.header: juce_gui_basics, importcpp: "#.getTextDescriptionWithIcons()".}
proc isCurrentlyDown*(this: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.isCurrentlyDown()".}

proc keyPressed*(this: var KeyListener, key: KeyPress, originatingComponent: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc keyStateChanged*(this: var KeyListener, isKeyDown: bool, originatingComponent: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.keyStateChanged(@)".}
proc `==`*(this: KeyListener, other: KeyListener): bool {.error: "juce::KeyListener defines no operator==; compare a property instead".}

proc getDefaultComponent*(this: var ComponentTraverser, parentComponent: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getDefaultComponent(@)".}
proc getNextComponent*(this: var ComponentTraverser, current: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getNextComponent(@)".}
proc getPreviousComponent*(this: var ComponentTraverser, current: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getPreviousComponent(@)".}
proc getAllComponents*(this: var ComponentTraverser, parentComponent: ptr Component): CppVector[Component] {.header: juce_gui_basics, importcpp: "#.getAllComponents(@)".}
proc `==`*(this: ComponentTraverser, other: ComponentTraverser): bool {.error: "juce::ComponentTraverser defines no operator==; compare a property instead".}

proc makeFocusTraverser*(): FocusTraverser {.header: juce_gui_basics, importcpp: "juce::FocusTraverser(@)".}
proc makeFocusTraverser*(skipDisabledComponents: FocusTraverserSkipDisabledComponents): FocusTraverser {.header: juce_gui_basics, importcpp: "juce::FocusTraverser(@)".}
proc getDefaultComponent*(this: var FocusTraverser, parentComponent: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getDefaultComponent(@)".}
proc getNextComponent*(this: var FocusTraverser, current: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getNextComponent(@)".}
proc getPreviousComponent*(this: var FocusTraverser, current: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getPreviousComponent(@)".}
proc getAllComponents*(this: var FocusTraverser, parentComponent: ptr Component): CppVector[Component] {.header: juce_gui_basics, importcpp: "#.getAllComponents(@)".}
proc `==`*(this: FocusTraverser, other: FocusTraverser): bool {.error: "juce::FocusTraverser defines no operator==; compare a property instead".}

proc clearSingletonInstance*(this: var ModalComponentManager) {.header: juce_gui_basics, importcpp: "#.clearSingletonInstance()".}
proc getNumModalComponents*(this: ModalComponentManager): cint {.header: juce_gui_basics, importcpp: "#.getNumModalComponents()".}
proc getModalComponent*(this: ModalComponentManager, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getModalComponent(@)".}
proc isModal*(this: ModalComponentManager, component: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.isModal(@)".}
proc isFrontModalComponent*(this: ModalComponentManager, component: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.isFrontModalComponent(@)".}
proc attachCallback*(this: var ModalComponentManager, component: ptr Component, callback: ptr ModalComponentManagerCallback) {.header: juce_gui_basics, importcpp: "#.attachCallback(@)".}
proc bringModalComponentsToFront*(this: var ModalComponentManager, topOneShouldGrabFocus: bool = true) {.header: juce_gui_basics, importcpp: "#.bringModalComponentsToFront(@)".}
proc cancelAllModalComponents*(this: var ModalComponentManager): bool {.header: juce_gui_basics, importcpp: "#.cancelAllModalComponents()".}
proc startModal*(this: var ModalComponentManager, arg1: ModalComponentManagerKey, arg2: ptr Component, autoDelete: bool) {.header: juce_gui_basics, importcpp: "#.startModal(@)".}
proc endModal*(this: var ModalComponentManager, arg1: ModalComponentManagerKey, arg2: ptr Component, returnValue: cint) {.header: juce_gui_basics, importcpp: "#.endModal(@)".}
proc `==`*(this: ModalComponentManager, other: ModalComponentManager): bool {.error: "juce::ModalComponentManager defines no operator==; compare a property instead".}

proc `==`*(this: ModalCallbackFunction, other: ModalCallbackFunction): bool {.error: "juce::ModalCallbackFunction defines no operator==; compare a property instead".}

proc `==`*(this: ComponentPaintDiagnostics, other: ComponentPaintDiagnostics): bool {.error: "juce::ComponentPaintDiagnostics defines no operator==; compare a property instead".}

proc componentMovedOrResized*(this: var ComponentListener, component: var Component, wasMoved: bool, wasResized: bool) {.header: juce_gui_basics, importcpp: "#.componentMovedOrResized(@)".}
proc componentBroughtToFront*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentBroughtToFront(@)".}
proc componentVisibilityChanged*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentVisibilityChanged(@)".}
proc componentChildrenChanged*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentChildrenChanged(@)".}
proc componentParentHierarchyChanged*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentParentHierarchyChanged(@)".}
proc componentNameChanged*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentNameChanged(@)".}
proc componentBeingDeleted*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentBeingDeleted(@)".}
proc componentEnablementChanged*(this: var ComponentListener, component: var Component) {.header: juce_gui_basics, importcpp: "#.componentEnablementChanged(@)".}
proc componentPainted*(this: var ComponentListener, component: var Component, diagnostics: ComponentPaintDiagnostics) {.header: juce_gui_basics, importcpp: "#.componentPainted(@)".}
proc `==`*(this: ComponentListener, other: ComponentListener): bool {.error: "juce::ComponentListener defines no operator==; compare a property instead".}

proc makeCachedComponentImage*(): CachedComponentImage {.header: juce_gui_basics, importcpp: "juce::CachedComponentImage(@)".}
proc paint*(this: var CachedComponentImage, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc invalidateAll*(this: var CachedComponentImage): bool {.header: juce_gui_basics, importcpp: "#.invalidateAll()".}
proc invalidate*(this: var CachedComponentImage, area: Rectangle[cint]): bool {.header: juce_gui_basics, importcpp: "#.invalidate(@)".}
proc releaseResources*(this: var CachedComponentImage) {.header: juce_gui_basics, importcpp: "#.releaseResources()".}
proc `==`*(this: CachedComponentImage, other: CachedComponentImage): bool {.error: "juce::CachedComponentImage defines no operator==; compare a property instead".}

proc makeComponent*(): Component {.header: juce_gui_basics, importcpp: "juce::Component(@)".}
proc makeComponent*(componentName: String): Component {.header: juce_gui_basics, importcpp: "juce::Component(@)".}
proc getName*(this: Component): String {.header: juce_gui_basics, importcpp: "#.getName()".}
proc setName*(this: var Component, newName: String) {.header: juce_gui_basics, importcpp: "#.setName(@)".}
proc getComponentID*(this: Component): String {.header: juce_gui_basics, importcpp: "#.getComponentID()".}
proc setComponentID*(this: var Component, newID: String) {.header: juce_gui_basics, importcpp: "#.setComponentID(@)".}
proc setVisible*(this: var Component, shouldBeVisible: bool) {.header: juce_gui_basics, importcpp: "#.setVisible(@)".}
proc isVisible*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isVisible()".}
proc visibilityChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.visibilityChanged()".}
proc isShowing*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isShowing()".}
proc addToDesktop*(this: var Component, windowStyleFlags: cint, nativeWindowToAttachTo: pointer = nil) {.header: juce_gui_basics, importcpp: "#.addToDesktop(@)".}
proc removeFromDesktop*(this: var Component) {.header: juce_gui_basics, importcpp: "#.removeFromDesktop()".}
proc isOnDesktop*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isOnDesktop()".}
proc getPeer*(this: Component): ptr ComponentPeer {.header: juce_gui_basics, importcpp: "#.getPeer()".}
proc userTriedToCloseWindow*(this: var Component) {.header: juce_gui_basics, importcpp: "#.userTriedToCloseWindow()".}
proc minimisationStateChanged*(this: var Component, isNowMinimised: bool) {.header: juce_gui_basics, importcpp: "#.minimisationStateChanged(@)".}
proc getDesktopScaleFactor*(this: Component): cfloat {.header: juce_gui_basics, importcpp: "#.getDesktopScaleFactor()".}
proc toFront*(this: var Component, shouldAlsoGainKeyboardFocus: bool) {.header: juce_gui_basics, importcpp: "#.toFront(@)".}
proc toBack*(this: var Component) {.header: juce_gui_basics, importcpp: "#.toBack()".}
proc toBehind*(this: var Component, other: ptr Component) {.header: juce_gui_basics, importcpp: "#.toBehind(@)".}
proc setAlwaysOnTop*(this: var Component, shouldStayOnTop: bool) {.header: juce_gui_basics, importcpp: "#.setAlwaysOnTop(@)".}
proc isAlwaysOnTop*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isAlwaysOnTop()".}
proc getX*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getX()".}
proc getY*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getY()".}
proc getWidth*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getWidth()".}
proc getHeight*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getHeight()".}
proc getRight*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getRight()".}
proc getPosition*(this: Component): Point[cint] {.header: juce_gui_basics, importcpp: "#.getPosition()".}
proc getBottom*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getBottom()".}
proc getBounds*(this: Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getBounds()".}
proc getLocalBounds*(this: Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getLocalBounds()".}
proc getBoundsInParent*(this: Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getBoundsInParent()".}
proc getScreenX*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getScreenX()".}
proc getScreenY*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getScreenY()".}
proc getScreenPosition*(this: Component): Point[cint] {.header: juce_gui_basics, importcpp: "#.getScreenPosition()".}
proc getScreenBounds*(this: Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getScreenBounds()".}
proc getLocalPoint*(this: Component, sourceComponent: ptr Component, pointRelativeToSourceComponent: Point[cint]): Point[cint] {.header: juce_gui_basics, importcpp: "#.getLocalPoint(@)".}
proc getLocalPoint*(this: Component, sourceComponent: ptr Component, pointRelativeToSourceComponent: Point[cfloat]): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.getLocalPoint(@)".}
proc getLocalArea*(this: Component, sourceComponent: ptr Component, areaRelativeToSourceComponent: Rectangle[cint]): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getLocalArea(@)".}
proc getLocalArea*(this: Component, sourceComponent: ptr Component, areaRelativeToSourceComponent: Rectangle[cfloat]): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getLocalArea(@)".}
proc localPointToGlobal*(this: Component, localPoint: Point[cint]): Point[cint] {.header: juce_gui_basics, importcpp: "#.localPointToGlobal(@)".}
proc localPointToGlobal*(this: Component, localPoint: Point[cfloat]): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.localPointToGlobal(@)".}
proc localAreaToGlobal*(this: Component, localArea: Rectangle[cint]): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.localAreaToGlobal(@)".}
proc localAreaToGlobal*(this: Component, localArea: Rectangle[cfloat]): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.localAreaToGlobal(@)".}
proc setTopLeftPosition*(this: var Component, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.setTopLeftPosition(@)".}
proc setTopLeftPosition*(this: var Component, newTopLeftPosition: Point[cint]) {.header: juce_gui_basics, importcpp: "#.setTopLeftPosition(@)".}
proc setTopRightPosition*(this: var Component, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.setTopRightPosition(@)".}
proc setTopRightPosition*(this: var Component, arg1: Point[cint]) {.header: juce_gui_basics, importcpp: "#.setTopRightPosition(@)".}
proc setSize*(this: var Component, newWidth: cint, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setSize(@)".}
proc setBounds*(this: var Component, x: cint, y: cint, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.setBounds(@)".}
proc setBounds*(this: var Component, newBounds: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.setBounds(@)".}
proc setBoundsRelative*(this: var Component, proportionalX: cfloat, proportionalY: cfloat, proportionalWidth: cfloat, proportionalHeight: cfloat) {.header: juce_gui_basics, importcpp: "#.setBoundsRelative(@)".}
proc setBoundsRelative*(this: var Component, proportionalArea: Rectangle[cfloat]) {.header: juce_gui_basics, importcpp: "#.setBoundsRelative(@)".}
proc setBoundsInset*(this: var Component, borders: BorderSize[cint]) {.header: juce_gui_basics, importcpp: "#.setBoundsInset(@)".}
proc setBoundsToFit*(this: var Component, targetArea: Rectangle[cint], justification: Justification, onlyReduceInSize: bool) {.header: juce_gui_basics, importcpp: "#.setBoundsToFit(@)".}
proc setCentrePosition*(this: var Component, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.setCentrePosition(@)".}
proc setCentrePosition*(this: var Component, newCentrePosition: Point[cint]) {.header: juce_gui_basics, importcpp: "#.setCentrePosition(@)".}
proc setCentreRelative*(this: var Component, x: cfloat, y: cfloat) {.header: juce_gui_basics, importcpp: "#.setCentreRelative(@)".}
proc centreWithSize*(this: var Component, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.centreWithSize(@)".}
proc setTransform*(this: var Component, transform: AffineTransform) {.header: juce_gui_basics, importcpp: "#.setTransform(@)".}
proc getTransform*(this: Component): AffineTransform {.header: juce_gui_basics, importcpp: "#.getTransform()".}
proc isTransformed*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isTransformed()".}
proc proportionOfWidth*(this: Component, proportion: cfloat): cint {.header: juce_gui_basics, importcpp: "#.proportionOfWidth(@)".}
proc proportionOfHeight*(this: Component, proportion: cfloat): cint {.header: juce_gui_basics, importcpp: "#.proportionOfHeight(@)".}
proc getParentWidth*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getParentWidth()".}
proc getParentHeight*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getParentHeight()".}
proc getParentMonitorArea*(this: Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getParentMonitorArea()".}
proc getNumChildComponents*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getNumChildComponents()".}
proc getChildComponent*(this: Component, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getChildComponent(@)".}
proc getIndexOfChildComponent*(this: Component, child: ptr Component): cint {.header: juce_gui_basics, importcpp: "#.getIndexOfChildComponent(@)".}
proc getChildren*(this: Component): Array[Component] {.header: juce_gui_basics, importcpp: "#.getChildren()".}
proc findChildWithID*(this: Component, componentID: StringRef): ptr Component {.header: juce_gui_basics, importcpp: "#.findChildWithID(@)".}
proc addChildComponent*(this: var Component, child: ptr Component, zOrder: cint = -1) {.header: juce_gui_basics, importcpp: "#.addChildComponent(@)".}
proc addChildComponent*(this: var Component, child: var Component, zOrder: cint = -1) {.header: juce_gui_basics, importcpp: "#.addChildComponent(@)".}
proc addAndMakeVisible*(this: var Component, child: ptr Component, zOrder: cint = -1) {.header: juce_gui_basics, importcpp: "#.addAndMakeVisible(@)".}
proc addAndMakeVisible*(this: var Component, child: var Component, zOrder: cint = -1) {.header: juce_gui_basics, importcpp: "#.addAndMakeVisible(@)".}
proc addChildAndSetID*(this: var Component, child: ptr Component, componentID: String) {.header: juce_gui_basics, importcpp: "#.addChildAndSetID(@)".}
proc removeChildComponent*(this: var Component, childToRemove: ptr Component) {.header: juce_gui_basics, importcpp: "#.removeChildComponent(@)".}
proc removeChildComponent*(this: var Component, childIndexToRemove: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.removeChildComponent(@)".}
proc removeAllChildren*(this: var Component) {.header: juce_gui_basics, importcpp: "#.removeAllChildren()".}
proc deleteAllChildren*(this: var Component) {.header: juce_gui_basics, importcpp: "#.deleteAllChildren()".}
proc getParentComponent*(this: Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getParentComponent()".}
proc getTopLevelComponent*(this: Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getTopLevelComponent()".}
proc isParentOf*(this: Component, possibleChild: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.isParentOf(@)".}
proc parentHierarchyChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc childrenChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.childrenChanged()".}
proc hitTest*(this: var Component, x: cint, y: cint): bool {.header: juce_gui_basics, importcpp: "#.hitTest(@)".}
proc findControlAtPoint*(this: Component, arg1: Point[cfloat]): ComponentWindowControlKind {.header: juce_gui_basics, importcpp: "#.findControlAtPoint(@)".}
proc windowControlClickedClose*(this: var Component) {.header: juce_gui_basics, importcpp: "#.windowControlClickedClose()".}
proc windowControlClickedMinimise*(this: var Component) {.header: juce_gui_basics, importcpp: "#.windowControlClickedMinimise()".}
proc windowControlClickedMaximise*(this: var Component) {.header: juce_gui_basics, importcpp: "#.windowControlClickedMaximise()".}
proc setInterceptsMouseClicks*(this: var Component, allowClicksOnThisComponent: bool, allowClicksOnChildComponents: bool) {.header: juce_gui_basics, importcpp: "#.setInterceptsMouseClicks(@)".}
proc getInterceptsMouseClicks*(this: Component, allowsClicksOnThisComponent: var bool, allowsClicksOnChildComponents: var bool) {.header: juce_gui_basics, importcpp: "#.getInterceptsMouseClicks(@)".}
proc contains*(this: var Component, localPoint: Point[cint]): bool {.header: juce_gui_basics, importcpp: "#.contains(@)".}
proc contains*(this: var Component, localPoint: Point[cfloat]): bool {.header: juce_gui_basics, importcpp: "#.contains(@)".}
proc reallyContains*(this: var Component, localPoint: Point[cint], returnTrueIfWithinAChild: bool): bool {.header: juce_gui_basics, importcpp: "#.reallyContains(@)".}
proc reallyContains*(this: var Component, localPoint: Point[cfloat], returnTrueIfWithinAChild: bool): bool {.header: juce_gui_basics, importcpp: "#.reallyContains(@)".}
proc getComponentAt*(this: var Component, x: cint, y: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponentAt(@)".}
proc getComponentAt*(this: var Component, position: Point[cint]): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponentAt(@)".}
proc getComponentAt*(this: var Component, position: Point[cfloat]): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponentAt(@)".}
proc repaint*(this: var Component) {.header: juce_gui_basics, importcpp: "#.repaint()".}
proc repaint*(this: var Component, x: cint, y: cint, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.repaint(@)".}
proc repaint*(this: var Component, area: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.repaint(@)".}
proc setBufferedToImage*(this: var Component, shouldBeBuffered: bool) {.header: juce_gui_basics, importcpp: "#.setBufferedToImage(@)".}
proc createComponentSnapshot*(this: var Component, areaToGrab: Rectangle[cint], clipImageToComponentBounds: bool = true, scaleFactor: cfloat = 1.0f, imageType: ImageType): Image {.header: juce_gui_basics, importcpp: "#.createComponentSnapshot(@)".}
proc paintEntireComponent*(this: var Component, context: var Graphics, ignoreAlphaLevel: bool) {.header: juce_gui_basics, importcpp: "#.paintEntireComponent(@)".}
proc setPaintingIsUnclipped*(this: var Component, shouldPaintWithoutClipping: bool) {.header: juce_gui_basics, importcpp: "#.setPaintingIsUnclipped(@)".}
proc isPaintingUnclipped*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isPaintingUnclipped()".}
proc setComponentEffect*(this: var Component, newEffect: ptr ImageEffectFilter) {.header: juce_gui_basics, importcpp: "#.setComponentEffect(@)".}
proc getComponentEffect*(this: Component): ptr ImageEffectFilter {.header: juce_gui_basics, importcpp: "#.getComponentEffect()".}
proc getLookAndFeel*(this: Component): var LookAndFeel {.header: juce_gui_basics, importcpp: "#.getLookAndFeel()".}
proc setLookAndFeel*(this: var Component, newLookAndFeel: ptr LookAndFeel) {.header: juce_gui_basics, importcpp: "#.setLookAndFeel(@)".}
proc withDefaultMetrics*(this: Component, opt: FontOptions): FontOptions {.header: juce_gui_basics, importcpp: "#.withDefaultMetrics(@)".}
proc lookAndFeelChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc sendLookAndFeelChange*(this: var Component) {.header: juce_gui_basics, importcpp: "#.sendLookAndFeelChange()".}
proc setOpaque*(this: var Component, shouldBeOpaque: bool) {.header: juce_gui_basics, importcpp: "#.setOpaque(@)".}
proc isOpaque*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isOpaque()".}
proc setBroughtToFrontOnMouseClick*(this: var Component, shouldBeBroughtToFront: bool) {.header: juce_gui_basics, importcpp: "#.setBroughtToFrontOnMouseClick(@)".}
proc isBroughtToFrontOnMouseClick*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isBroughtToFrontOnMouseClick()".}
proc setExplicitFocusOrder*(this: var Component, newFocusOrderIndex: cint) {.header: juce_gui_basics, importcpp: "#.setExplicitFocusOrder(@)".}
proc getExplicitFocusOrder*(this: Component): cint {.header: juce_gui_basics, importcpp: "#.getExplicitFocusOrder()".}
proc setFocusContainerType*(this: var Component, containerType: ComponentFocusContainerType) {.header: juce_gui_basics, importcpp: "#.setFocusContainerType(@)".}
proc isFocusContainer*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isFocusContainer()".}
proc isKeyboardFocusContainer*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isKeyboardFocusContainer()".}
proc findFocusContainer*(this: Component): ptr Component {.header: juce_gui_basics, importcpp: "#.findFocusContainer()".}
proc findKeyboardFocusContainer*(this: Component): ptr Component {.header: juce_gui_basics, importcpp: "#.findKeyboardFocusContainer()".}
proc setWantsKeyboardFocus*(this: var Component, wantsFocus: bool) {.header: juce_gui_basics, importcpp: "#.setWantsKeyboardFocus(@)".}
proc getWantsKeyboardFocus*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.getWantsKeyboardFocus()".}
proc setMouseClickGrabsKeyboardFocus*(this: var Component, shouldGrabFocus: bool) {.header: juce_gui_basics, importcpp: "#.setMouseClickGrabsKeyboardFocus(@)".}
proc getMouseClickGrabsKeyboardFocus*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.getMouseClickGrabsKeyboardFocus()".}
proc grabKeyboardFocus*(this: var Component) {.header: juce_gui_basics, importcpp: "#.grabKeyboardFocus()".}
proc giveAwayKeyboardFocus*(this: var Component) {.header: juce_gui_basics, importcpp: "#.giveAwayKeyboardFocus()".}
proc hasKeyboardFocus*(this: Component, trueIfChildIsFocused: bool): bool {.header: juce_gui_basics, importcpp: "#.hasKeyboardFocus(@)".}
proc moveKeyboardFocusToSibling*(this: var Component, moveToNext: bool) {.header: juce_gui_basics, importcpp: "#.moveKeyboardFocusToSibling(@)".}
proc createFocusTraverser*(this: var Component): UniquePtr[ComponentTraverser] {.header: juce_gui_basics, importcpp: "#.createFocusTraverser()".}
proc createKeyboardFocusTraverser*(this: var Component): UniquePtr[ComponentTraverser] {.header: juce_gui_basics, importcpp: "#.createKeyboardFocusTraverser()".}
proc setHasFocusOutline*(this: var Component, hasFocusOutline: bool) {.header: juce_gui_basics, importcpp: "#.setHasFocusOutline(@)".}
proc hasFocusOutline*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.hasFocusOutline()".}
proc isEnabled*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isEnabled()".}
proc setEnabled*(this: var Component, shouldBeEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setEnabled(@)".}
proc enablementChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc getAlpha*(this: Component): cfloat {.header: juce_gui_basics, importcpp: "#.getAlpha()".}
proc setAlpha*(this: var Component, newAlpha: cfloat) {.header: juce_gui_basics, importcpp: "#.setAlpha(@)".}
proc alphaChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.alphaChanged()".}
proc setMouseCursor*(this: var Component, cursorType: MouseCursor) {.header: juce_gui_basics, importcpp: "#.setMouseCursor(@)".}
proc getMouseCursor*(this: var Component): MouseCursor {.header: juce_gui_basics, importcpp: "#.getMouseCursor()".}
proc updateMouseCursor*(this: Component) {.header: juce_gui_basics, importcpp: "#.updateMouseCursor()".}
proc paint*(this: var Component, g: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc paintOverChildren*(this: var Component, g: var Graphics) {.header: juce_gui_basics, importcpp: "#.paintOverChildren(@)".}
proc mouseMove*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseMove(@)".}
proc mouseEnter*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseEnter(@)".}
proc mouseExit*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseExit(@)".}
proc mouseDown*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc mouseDoubleClick*(this: var Component, event: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDoubleClick(@)".}
proc mouseWheelMove*(this: var Component, event: MouseEvent, wheel: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc mouseMagnify*(this: var Component, event: MouseEvent, scaleFactor: cfloat) {.header: juce_gui_basics, importcpp: "#.mouseMagnify(@)".}
proc setRepaintsOnMouseActivity*(this: var Component, shouldRepaint: bool) {.header: juce_gui_basics, importcpp: "#.setRepaintsOnMouseActivity(@)".}
proc addMouseListener*(this: var Component, newListener: ptr MouseListener, wantsEventsForAllNestedChildComponents: bool) {.header: juce_gui_basics, importcpp: "#.addMouseListener(@)".}
proc removeMouseListener*(this: var Component, listenerToRemove: ptr MouseListener) {.header: juce_gui_basics, importcpp: "#.removeMouseListener(@)".}
proc addKeyListener*(this: var Component, newListener: ptr KeyListener) {.header: juce_gui_basics, importcpp: "#.addKeyListener(@)".}
proc removeKeyListener*(this: var Component, listenerToRemove: ptr KeyListener) {.header: juce_gui_basics, importcpp: "#.removeKeyListener(@)".}
proc keyPressed*(this: var Component, key: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc keyStateChanged*(this: var Component, isKeyDown: bool): bool {.header: juce_gui_basics, importcpp: "#.keyStateChanged(@)".}
proc modifierKeysChanged*(this: var Component, modifiers: ModifierKeys) {.header: juce_gui_basics, importcpp: "#.modifierKeysChanged(@)".}
proc focusGained*(this: var Component, cause: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusGained(@)".}
proc focusGainedWithDirection*(this: var Component, cause: ComponentFocusChangeType, direction: ComponentFocusChangeDirection) {.header: juce_gui_basics, importcpp: "#.focusGainedWithDirection(@)".}
proc focusLost*(this: var Component, cause: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusLost(@)".}
proc focusOfChildComponentChanged*(this: var Component, cause: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusOfChildComponentChanged(@)".}
proc isMouseOver*(this: Component, includeChildren: bool = false): bool {.header: juce_gui_basics, importcpp: "#.isMouseOver(@)".}
proc isMouseButtonDown*(this: Component, includeChildren: bool = false): bool {.header: juce_gui_basics, importcpp: "#.isMouseButtonDown(@)".}
proc isMouseOverOrDragging*(this: Component, includeChildren: bool = false): bool {.header: juce_gui_basics, importcpp: "#.isMouseOverOrDragging(@)".}
proc getMouseXYRelative*(this: Component): Point[cint] {.header: juce_gui_basics, importcpp: "#.getMouseXYRelative()".}
proc resized*(this: var Component) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc moved*(this: var Component) {.header: juce_gui_basics, importcpp: "#.moved()".}
proc childBoundsChanged*(this: var Component, child: ptr Component) {.header: juce_gui_basics, importcpp: "#.childBoundsChanged(@)".}
proc parentSizeChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.parentSizeChanged()".}
proc broughtToFront*(this: var Component) {.header: juce_gui_basics, importcpp: "#.broughtToFront()".}
proc addComponentListener*(this: var Component, newListener: ptr ComponentListener) {.header: juce_gui_basics, importcpp: "#.addComponentListener(@)".}
proc removeComponentListener*(this: var Component, listenerToRemove: ptr ComponentListener) {.header: juce_gui_basics, importcpp: "#.removeComponentListener(@)".}
proc postCommandMessage*(this: var Component, commandId: cint) {.header: juce_gui_basics, importcpp: "#.postCommandMessage(@)".}
proc handleCommandMessage*(this: var Component, commandId: cint) {.header: juce_gui_basics, importcpp: "#.handleCommandMessage(@)".}
proc enterModalState*(this: var Component, takeKeyboardFocus: bool = true, callback: ptr ModalComponentManagerCallback = nil, deleteWhenDismissed: bool = false) {.header: juce_gui_basics, importcpp: "#.enterModalState(@)".}
proc exitModalState*(this: var Component, returnValue: cint = 0) {.header: juce_gui_basics, importcpp: "#.exitModalState(@)".}
proc isCurrentlyModal*(this: Component, onlyConsiderForemostModalComponent: bool = true): bool {.header: juce_gui_basics, importcpp: "#.isCurrentlyModal(@)".}
proc isCurrentlyBlockedByAnotherModalComponent*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isCurrentlyBlockedByAnotherModalComponent()".}
proc canModalEventBeSentToComponent*(this: var Component, targetComponent: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.canModalEventBeSentToComponent(@)".}
proc inputAttemptWhenModal*(this: var Component) {.header: juce_gui_basics, importcpp: "#.inputAttemptWhenModal()".}
proc getProperties*(this: var Component): var NamedValueSet {.header: juce_gui_basics, importcpp: "#.getProperties()".}
proc getProperties*(this: Component): NamedValueSet {.header: juce_gui_basics, importcpp: "#.getProperties()".}
proc findColour*(this: Component, colourID: cint, inheritFromParent: bool = false): Colour {.header: juce_gui_basics, importcpp: "#.findColour(@)".}
proc setColour*(this: var Component, colourID: cint, newColour: Colour) {.header: juce_gui_basics, importcpp: "#.setColour(@)".}
proc removeColour*(this: var Component, colourID: cint) {.header: juce_gui_basics, importcpp: "#.removeColour(@)".}
proc isColourSpecified*(this: Component, colourID: cint): bool {.header: juce_gui_basics, importcpp: "#.isColourSpecified(@)".}
proc copyAllExplicitColoursTo*(this: Component, target: var Component) {.header: juce_gui_basics, importcpp: "#.copyAllExplicitColoursTo(@)".}
proc colourChanged*(this: var Component) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc getWindowHandle*(this: Component): pointer {.header: juce_gui_basics, importcpp: "#.getWindowHandle()".}
proc getPositioner*(this: Component): ptr ComponentPositioner {.header: juce_gui_basics, importcpp: "#.getPositioner()".}
proc setPositioner*(this: var Component, newPositioner: ptr ComponentPositioner) {.header: juce_gui_basics, importcpp: "#.setPositioner(@)".}
proc setCachedComponentImage*(this: var Component, newCachedImage: ptr CachedComponentImage) {.header: juce_gui_basics, importcpp: "#.setCachedComponentImage(@)".}
proc getCachedComponentImage*(this: Component): ptr CachedComponentImage {.header: juce_gui_basics, importcpp: "#.getCachedComponentImage()".}
proc invalidateCachedImageResources*(this: var Component) {.header: juce_gui_basics, importcpp: "#.invalidateCachedImageResources()".}
proc setViewportIgnoreDragFlag*(this: var Component, ignoreDrag: bool) {.header: juce_gui_basics, importcpp: "#.setViewportIgnoreDragFlag(@)".}
proc getViewportIgnoreDragFlag*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.getViewportIgnoreDragFlag()".}
proc getTitle*(this: Component): String {.header: juce_gui_basics, importcpp: "#.getTitle()".}
proc setTitle*(this: var Component, newTitle: String) {.header: juce_gui_basics, importcpp: "#.setTitle(@)".}
proc getDescription*(this: Component): String {.header: juce_gui_basics, importcpp: "#.getDescription()".}
proc setDescription*(this: var Component, newDescription: String) {.header: juce_gui_basics, importcpp: "#.setDescription(@)".}
proc getHelpText*(this: Component): String {.header: juce_gui_basics, importcpp: "#.getHelpText()".}
proc setHelpText*(this: var Component, newHelpText: String) {.header: juce_gui_basics, importcpp: "#.setHelpText(@)".}
proc setAccessible*(this: var Component, shouldBeAccessible: bool) {.header: juce_gui_basics, importcpp: "#.setAccessible(@)".}
proc isAccessible*(this: Component): bool {.header: juce_gui_basics, importcpp: "#.isAccessible()".}
proc getAccessibilityHandler*(this: var Component): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getAccessibilityHandler()".}
proc invalidateAccessibilityHandler*(this: var Component) {.header: juce_gui_basics, importcpp: "#.invalidateAccessibilityHandler()".}
proc createAccessibilityHandler*(this: var Component): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc setFocusContainer*(this: var Component, shouldBeFocusContainer: bool) {.header: juce_gui_basics, importcpp: "#.setFocusContainer(@)".}
proc contains*(this: var Component, arg1: cint, arg2: cint) {.header: juce_gui_basics, importcpp: "#.contains(@)".}
proc `==`*(this: Component, other: Component): bool {.error: "juce::Component defines no operator==; compare a property instead".}

proc makeComponentAnimator*(): ComponentAnimator {.header: juce_gui_basics, importcpp: "juce::ComponentAnimator(@)".}
proc animateComponent*(this: var ComponentAnimator, component: ptr Component, finalBounds: Rectangle[cint], finalAlpha: cfloat, animationDurationMilliseconds: cint, useProxyComponent: bool, startSpeed: float64, endSpeed: float64) {.header: juce_gui_basics, importcpp: "#.animateComponent(@)".}
proc fadeOut*(this: var ComponentAnimator, component: ptr Component, millisecondsToTake: cint) {.header: juce_gui_basics, importcpp: "#.fadeOut(@)".}
proc fadeIn*(this: var ComponentAnimator, component: ptr Component, millisecondsToTake: cint) {.header: juce_gui_basics, importcpp: "#.fadeIn(@)".}
proc cancelAnimation*(this: var ComponentAnimator, component: ptr Component, moveComponentToItsFinalPosition: bool) {.header: juce_gui_basics, importcpp: "#.cancelAnimation(@)".}
proc cancelAllAnimations*(this: var ComponentAnimator, moveComponentsToTheirFinalPositions: bool) {.header: juce_gui_basics, importcpp: "#.cancelAllAnimations(@)".}
proc getComponentDestination*(this: var ComponentAnimator, component: ptr Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getComponentDestination(@)".}
proc isAnimating*(this: ComponentAnimator, component: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.isAnimating(@)".}
proc isAnimating*(this: ComponentAnimator): bool {.header: juce_gui_basics, importcpp: "#.isAnimating()".}
proc `==`*(this: ComponentAnimator, other: ComponentAnimator): bool {.error: "juce::ComponentAnimator defines no operator==; compare a property instead".}

proc globalFocusChanged*(this: var FocusChangeListener, focusedComponent: ptr Component) {.header: juce_gui_basics, importcpp: "#.globalFocusChanged(@)".}
proc `==`*(this: FocusChangeListener, other: FocusChangeListener): bool {.error: "juce::FocusChangeListener defines no operator==; compare a property instead".}

proc darkModeSettingChanged*(this: var DarkModeSettingListener) {.header: juce_gui_basics, importcpp: "#.darkModeSettingChanged()".}
proc `==`*(this: DarkModeSettingListener, other: DarkModeSettingListener): bool {.error: "juce::DarkModeSettingListener defines no operator==; compare a property instead".}

proc getMouseButtonClickCounter*(this: Desktop): cint {.header: juce_gui_basics, importcpp: "#.getMouseButtonClickCounter()".}
proc getMouseWheelMoveCounter*(this: Desktop): cint {.header: juce_gui_basics, importcpp: "#.getMouseWheelMoveCounter()".}
proc addGlobalMouseListener*(this: var Desktop, listener: ptr MouseListener) {.header: juce_gui_basics, importcpp: "#.addGlobalMouseListener(@)".}
proc removeGlobalMouseListener*(this: var Desktop, listener: ptr MouseListener) {.header: juce_gui_basics, importcpp: "#.removeGlobalMouseListener(@)".}
proc addFocusChangeListener*(this: var Desktop, listener: ptr FocusChangeListener) {.header: juce_gui_basics, importcpp: "#.addFocusChangeListener(@)".}
proc removeFocusChangeListener*(this: var Desktop, listener: ptr FocusChangeListener) {.header: juce_gui_basics, importcpp: "#.removeFocusChangeListener(@)".}
proc addDarkModeSettingListener*(this: var Desktop, listener: ptr DarkModeSettingListener) {.header: juce_gui_basics, importcpp: "#.addDarkModeSettingListener(@)".}
proc removeDarkModeSettingListener*(this: var Desktop, listener: ptr DarkModeSettingListener) {.header: juce_gui_basics, importcpp: "#.removeDarkModeSettingListener(@)".}
proc isDarkModeActive*(this: Desktop): bool {.header: juce_gui_basics, importcpp: "#.isDarkModeActive()".}
proc setKioskModeComponent*(this: var Desktop, componentToUse: ptr Component, allowMenusAndBars: bool = true) {.header: juce_gui_basics, importcpp: "#.setKioskModeComponent(@)".}
proc getKioskModeComponent*(this: Desktop): ptr Component {.header: juce_gui_basics, importcpp: "#.getKioskModeComponent()".}
proc getNumComponents*(this: Desktop): cint {.header: juce_gui_basics, importcpp: "#.getNumComponents()".}
proc getComponent*(this: Desktop, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponent(@)".}
proc findComponentAt*(this: Desktop, screenPosition: Point[cint]): ptr Component {.header: juce_gui_basics, importcpp: "#.findComponentAt(@)".}
proc getAnimator*(this: var Desktop): var ComponentAnimator {.header: juce_gui_basics, importcpp: "#.getAnimator()".}
proc getDefaultLookAndFeel*(this: var Desktop): var LookAndFeel {.header: juce_gui_basics, importcpp: "#.getDefaultLookAndFeel()".}
proc setDefaultLookAndFeel*(this: var Desktop, newDefaultLookAndFeel: ptr LookAndFeel) {.header: juce_gui_basics, importcpp: "#.setDefaultLookAndFeel(@)".}
proc getMouseSources*(this: Desktop): Array[MouseInputSource] {.header: juce_gui_basics, importcpp: "#.getMouseSources()".}
proc getNumMouseSources*(this: Desktop): cint {.header: juce_gui_basics, importcpp: "#.getNumMouseSources()".}
proc getMouseSource*(this: Desktop, index: cint): ptr MouseInputSource {.header: juce_gui_basics, importcpp: "#.getMouseSource(@)".}
proc getMainMouseSource*(this: Desktop): MouseInputSource {.header: juce_gui_basics, importcpp: "#.getMainMouseSource()".}
proc getNumDraggingMouseSources*(this: Desktop): cint {.header: juce_gui_basics, importcpp: "#.getNumDraggingMouseSources()".}
proc getDraggingMouseSource*(this: Desktop, index: cint): ptr MouseInputSource {.header: juce_gui_basics, importcpp: "#.getDraggingMouseSource(@)".}
proc beginDragAutoRepeat*(this: var Desktop, millisecondsBetweenCallbacks: cint) {.header: juce_gui_basics, importcpp: "#.beginDragAutoRepeat(@)".}
proc getCurrentOrientation*(this: Desktop): DesktopDisplayOrientation {.header: juce_gui_basics, importcpp: "#.getCurrentOrientation()".}
proc setOrientationsEnabled*(this: var Desktop, allowedOrientations: cint) {.header: juce_gui_basics, importcpp: "#.setOrientationsEnabled(@)".}
proc getOrientationsEnabled*(this: Desktop): cint {.header: juce_gui_basics, importcpp: "#.getOrientationsEnabled()".}
proc isOrientationEnabled*(this: Desktop, orientation: DesktopDisplayOrientation): bool {.header: juce_gui_basics, importcpp: "#.isOrientationEnabled(@)".}
proc getDisplays*(this: Desktop): Displays {.header: juce_gui_basics, importcpp: "#.getDisplays()".}
proc setGlobalScaleFactor*(this: var Desktop, newScaleFactor: cfloat) {.header: juce_gui_basics, importcpp: "#.setGlobalScaleFactor(@)".}
proc getGlobalScaleFactor*(this: Desktop): cfloat {.header: juce_gui_basics, importcpp: "#.getGlobalScaleFactor()".}
proc supportsBorderlessNonClientResize*(this: Desktop): bool {.header: juce_gui_basics, importcpp: "#.supportsBorderlessNonClientResize()".}
proc isHeadless*(this: Desktop): bool {.header: juce_gui_basics, importcpp: "#.isHeadless()".}
proc `==`*(this: Desktop, other: Desktop): bool {.error: "juce::Desktop defines no operator==; compare a property instead".}

proc physicalToLogical*(this: Displays, physicalRect: Rectangle[cint], useScaleFactorOfDisplay: ptr DisplaysDisplay = nil): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.physicalToLogical(@)".}
proc physicalToLogical*(this: Displays, physicalRect: Rectangle[cfloat], useScaleFactorOfDisplay: ptr DisplaysDisplay = nil): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.physicalToLogical(@)".}
proc logicalToPhysical*(this: Displays, logicalRect: Rectangle[cint], useScaleFactorOfDisplay: ptr DisplaysDisplay = nil): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.logicalToPhysical(@)".}
proc logicalToPhysical*(this: Displays, logicalRect: Rectangle[cfloat], useScaleFactorOfDisplay: ptr DisplaysDisplay = nil): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.logicalToPhysical(@)".}
proc physicalToLogical*(this: Displays, physicalPoint: Point[cfloat], useScaleFactorOfDisplay: ptr DisplaysDisplay = nil): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.physicalToLogical(@)".}
proc physicalToLogical*(this: Displays, physicalPoint: Point[cint], display: ptr DisplaysDisplay = nil): Point[cint] {.header: juce_gui_basics, importcpp: "#.physicalToLogical(@)".}
proc logicalToPhysical*(this: Displays, logicalPoint: Point[cfloat], useScaleFactorOfDisplay: ptr DisplaysDisplay = nil): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.logicalToPhysical(@)".}
proc logicalToPhysical*(this: Displays, physicalPoint: Point[cint], display: ptr DisplaysDisplay = nil): Point[cint] {.header: juce_gui_basics, importcpp: "#.logicalToPhysical(@)".}
proc getDisplayForRect*(this: Displays, rect: Rectangle[cint], isPhysical: bool = false): ptr DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.getDisplayForRect(@)".}
proc getDisplayForPoint*(this: Displays, point: Point[cint], isPhysical: bool = false): ptr DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.getDisplayForPoint(@)".}
proc getDisplayForPoint*(this: Displays, point: Point[cfloat], isPhysical: bool = false): ptr DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.getDisplayForPoint(@)".}
proc getPrimaryDisplay*(this: Displays): ptr DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.getPrimaryDisplay()".}
proc getRectangleList*(this: Displays, userAreasOnly: bool): RectangleList[cint] {.header: juce_gui_basics, importcpp: "#.getRectangleList(@)".}
proc getTotalBounds*(this: Displays, userAreasOnly: bool): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getTotalBounds(@)".}
proc refresh*(this: var Displays) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc getDisplayContaining*(this: Displays, position: Point[cint]): DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.getDisplayContaining(@)".}
proc findDisplayForRect*(this: Displays, arg1: Rectangle[cint], isPhysical: bool = false): DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.findDisplayForRect(@)".}
proc findDisplayForPoint*(this: Displays, arg1: Point[cint], isPhysical: bool = false): DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.findDisplayForPoint(@)".}
proc getMainDisplay*(this: Displays): DisplaysDisplay {.header: juce_gui_basics, importcpp: "#.getMainDisplay()".}
proc `==`*(this: Displays, other: Displays): bool {.error: "juce::Displays defines no operator==; compare a property instead".}

proc makeComponentBoundsConstrainer*(): ComponentBoundsConstrainer {.header: juce_gui_basics, importcpp: "juce::ComponentBoundsConstrainer(@)".}
proc setMinimumWidth*(this: var ComponentBoundsConstrainer, minimumWidth: cint) {.header: juce_gui_basics, importcpp: "#.setMinimumWidth(@)".}
proc getMinimumWidth*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMinimumWidth()".}
proc setMaximumWidth*(this: var ComponentBoundsConstrainer, maximumWidth: cint) {.header: juce_gui_basics, importcpp: "#.setMaximumWidth(@)".}
proc getMaximumWidth*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMaximumWidth()".}
proc setMinimumHeight*(this: var ComponentBoundsConstrainer, minimumHeight: cint) {.header: juce_gui_basics, importcpp: "#.setMinimumHeight(@)".}
proc getMinimumHeight*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMinimumHeight()".}
proc setMaximumHeight*(this: var ComponentBoundsConstrainer, maximumHeight: cint) {.header: juce_gui_basics, importcpp: "#.setMaximumHeight(@)".}
proc getMaximumHeight*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMaximumHeight()".}
proc setMinimumSize*(this: var ComponentBoundsConstrainer, minimumWidth: cint, minimumHeight: cint) {.header: juce_gui_basics, importcpp: "#.setMinimumSize(@)".}
proc setMaximumSize*(this: var ComponentBoundsConstrainer, maximumWidth: cint, maximumHeight: cint) {.header: juce_gui_basics, importcpp: "#.setMaximumSize(@)".}
proc setSizeLimits*(this: var ComponentBoundsConstrainer, minimumWidth: cint, minimumHeight: cint, maximumWidth: cint, maximumHeight: cint) {.header: juce_gui_basics, importcpp: "#.setSizeLimits(@)".}
proc setMinimumOnscreenAmounts*(this: var ComponentBoundsConstrainer, minimumWhenOffTheTop: cint, minimumWhenOffTheLeft: cint, minimumWhenOffTheBottom: cint, minimumWhenOffTheRight: cint) {.header: juce_gui_basics, importcpp: "#.setMinimumOnscreenAmounts(@)".}
proc getMinimumWhenOffTheTop*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMinimumWhenOffTheTop()".}
proc getMinimumWhenOffTheLeft*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMinimumWhenOffTheLeft()".}
proc getMinimumWhenOffTheBottom*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMinimumWhenOffTheBottom()".}
proc getMinimumWhenOffTheRight*(this: ComponentBoundsConstrainer): cint {.header: juce_gui_basics, importcpp: "#.getMinimumWhenOffTheRight()".}
proc setFixedAspectRatio*(this: var ComponentBoundsConstrainer, widthOverHeight: float64) {.header: juce_gui_basics, importcpp: "#.setFixedAspectRatio(@)".}
proc getFixedAspectRatio*(this: ComponentBoundsConstrainer): float64 {.header: juce_gui_basics, importcpp: "#.getFixedAspectRatio()".}
proc checkBounds*(this: var ComponentBoundsConstrainer, bounds: Rectangle[cint], previousBounds: Rectangle[cint], limits: Rectangle[cint], isStretchingTop: bool, isStretchingLeft: bool, isStretchingBottom: bool, isStretchingRight: bool) {.header: juce_gui_basics, importcpp: "#.checkBounds(@)".}
proc resizeStart*(this: var ComponentBoundsConstrainer) {.header: juce_gui_basics, importcpp: "#.resizeStart()".}
proc resizeEnd*(this: var ComponentBoundsConstrainer) {.header: juce_gui_basics, importcpp: "#.resizeEnd()".}
proc setBoundsForComponent*(this: var ComponentBoundsConstrainer, component: ptr Component, bounds: Rectangle[cint], isStretchingTop: bool, isStretchingLeft: bool, isStretchingBottom: bool, isStretchingRight: bool) {.header: juce_gui_basics, importcpp: "#.setBoundsForComponent(@)".}
proc checkComponentBounds*(this: var ComponentBoundsConstrainer, component: ptr Component) {.header: juce_gui_basics, importcpp: "#.checkComponentBounds(@)".}
proc applyBoundsToComponent*(this: var ComponentBoundsConstrainer, arg1: var Component, bounds: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.applyBoundsToComponent(@)".}
proc `==`*(this: ComponentBoundsConstrainer, other: ComponentBoundsConstrainer): bool {.error: "juce::ComponentBoundsConstrainer defines no operator==; compare a property instead".}

proc makeBorderedComponentBoundsConstrainer*(): BorderedComponentBoundsConstrainer {.header: juce_gui_basics, importcpp: "juce::BorderedComponentBoundsConstrainer(@)".}
proc getWrappedConstrainer*(this: BorderedComponentBoundsConstrainer): ptr ComponentBoundsConstrainer {.header: juce_gui_basics, importcpp: "#.getWrappedConstrainer()".}
proc getAdditionalBorder*(this: BorderedComponentBoundsConstrainer): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getAdditionalBorder()".}
proc checkBounds*(this: var BorderedComponentBoundsConstrainer, bounds: Rectangle[cint], previousBounds: Rectangle[cint], limits: Rectangle[cint], isStretchingTop: bool, isStretchingLeft: bool, isStretchingBottom: bool, isStretchingRight: bool) {.header: juce_gui_basics, importcpp: "#.checkBounds(@)".}
proc `BorderedComponentBoundsConstrainer=`*(this: var BorderedComponentBoundsConstrainer, arg1: BorderedComponentBoundsConstrainer): var BorderedComponentBoundsConstrainer {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc `==`*(this: BorderedComponentBoundsConstrainer, other: BorderedComponentBoundsConstrainer): bool {.error: "juce::BorderedComponentBoundsConstrainer defines no operator==; compare a property instead".}

proc makeComponentDragger*(): ComponentDragger {.header: juce_gui_basics, importcpp: "juce::ComponentDragger(@)".}
proc startDraggingComponent*(this: var ComponentDragger, componentToDrag: ptr Component, e: MouseEvent) {.header: juce_gui_basics, importcpp: "#.startDraggingComponent(@)".}
proc dragComponent*(this: var ComponentDragger, componentToDrag: ptr Component, e: MouseEvent, constrainer: ptr ComponentBoundsConstrainer) {.header: juce_gui_basics, importcpp: "#.dragComponent(@)".}
proc `==`*(this: ComponentDragger, other: ComponentDragger): bool {.error: "juce::ComponentDragger defines no operator==; compare a property instead".}

proc isInterestedInDragSource*(this: var DragAndDropTarget, dragSourceDetails: DragAndDropTargetSourceDetails): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInDragSource(@)".}
proc itemDragEnter*(this: var DragAndDropTarget, dragSourceDetails: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragEnter(@)".}
proc itemDragMove*(this: var DragAndDropTarget, dragSourceDetails: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragMove(@)".}
proc itemDragExit*(this: var DragAndDropTarget, dragSourceDetails: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragExit(@)".}
proc itemDropped*(this: var DragAndDropTarget, dragSourceDetails: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDropped(@)".}
proc shouldDrawDragImageWhenOver*(this: var DragAndDropTarget): bool {.header: juce_gui_basics, importcpp: "#.shouldDrawDragImageWhenOver()".}
proc `==`*(this: DragAndDropTarget, other: DragAndDropTarget): bool {.error: "juce::DragAndDropTarget defines no operator==; compare a property instead".}

proc makeDragAndDropContainer*(): DragAndDropContainer {.header: juce_gui_basics, importcpp: "juce::DragAndDropContainer(@)".}
proc startDragging*(this: var DragAndDropContainer, sourceDescription: juce_var, sourceComponent: ptr Component, dragImage: ScaledImage, allowDraggingToOtherJuceWindows: bool = false, imageOffsetFromMouse: ptr Point[cint] = nil, inputSourceCausingDrag: ptr MouseInputSource = nil) {.header: juce_gui_basics, importcpp: "#.startDragging(@)".}
proc startDragging*(this: var DragAndDropContainer, sourceDescription: juce_var, sourceComponent: ptr Component, dragImage: Image, allowDraggingToOtherJuceWindows: bool = false, imageOffsetFromMouse: ptr Point[cint] = nil, inputSourceCausingDrag: ptr MouseInputSource = nil) {.header: juce_gui_basics, importcpp: "#.startDragging(@)".}
proc isDragAndDropActive*(this: DragAndDropContainer): bool {.header: juce_gui_basics, importcpp: "#.isDragAndDropActive()".}
proc getNumCurrentDrags*(this: DragAndDropContainer): cint {.header: juce_gui_basics, importcpp: "#.getNumCurrentDrags()".}
proc getCurrentDragDescription*(this: DragAndDropContainer): juce_var {.header: juce_gui_basics, importcpp: "#.getCurrentDragDescription()".}
proc getDragDescriptionForIndex*(this: DragAndDropContainer, index: cint): juce_var {.header: juce_gui_basics, importcpp: "#.getDragDescriptionForIndex(@)".}
proc setCurrentDragImage*(this: var DragAndDropContainer, newImage: ScaledImage) {.header: juce_gui_basics, importcpp: "#.setCurrentDragImage(@)".}
proc setCurrentDragImage*(this: var DragAndDropContainer, newImage: Image) {.header: juce_gui_basics, importcpp: "#.setCurrentDragImage(@)".}
proc setDragImageForIndex*(this: var DragAndDropContainer, index: cint, newImage: ScaledImage) {.header: juce_gui_basics, importcpp: "#.setDragImageForIndex(@)".}
proc setDragImageForIndex*(this: var DragAndDropContainer, index: cint, newImage: Image) {.header: juce_gui_basics, importcpp: "#.setDragImageForIndex(@)".}
proc `==`*(this: DragAndDropContainer, other: DragAndDropContainer): bool {.error: "juce::DragAndDropContainer defines no operator==; compare a property instead".}

proc isInterestedInFileDrag*(this: var FileDragAndDropTarget, files: StringArray): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInFileDrag(@)".}
proc fileDragEnter*(this: var FileDragAndDropTarget, files: StringArray, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.fileDragEnter(@)".}
proc fileDragMove*(this: var FileDragAndDropTarget, files: StringArray, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.fileDragMove(@)".}
proc fileDragExit*(this: var FileDragAndDropTarget, files: StringArray) {.header: juce_gui_basics, importcpp: "#.fileDragExit(@)".}
proc filesDropped*(this: var FileDragAndDropTarget, files: StringArray, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.filesDropped(@)".}
proc `==`*(this: FileDragAndDropTarget, other: FileDragAndDropTarget): bool {.error: "juce::FileDragAndDropTarget defines no operator==; compare a property instead".}

proc makeMouseInactivityDetector*(target: var Component): MouseInactivityDetector {.header: juce_gui_basics, importcpp: "juce::MouseInactivityDetector(@)".}
proc setDelay*(this: var MouseInactivityDetector, newDelayMilliseconds: cint) {.header: juce_gui_basics, importcpp: "#.setDelay(@)".}
proc setMouseMoveTolerance*(this: var MouseInactivityDetector, pixelsNeededToTrigger: cint) {.header: juce_gui_basics, importcpp: "#.setMouseMoveTolerance(@)".}
proc addListener*(this: var MouseInactivityDetector, listener: ptr MouseInactivityDetectorListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var MouseInactivityDetector, listener: ptr MouseInactivityDetectorListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc `==`*(this: MouseInactivityDetector, other: MouseInactivityDetector): bool {.error: "juce::MouseInactivityDetector defines no operator==; compare a property instead".}

proc isInterestedInTextDrag*(this: var TextDragAndDropTarget, text: String): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInTextDrag(@)".}
proc textDragEnter*(this: var TextDragAndDropTarget, text: String, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.textDragEnter(@)".}
proc textDragMove*(this: var TextDragAndDropTarget, text: String, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.textDragMove(@)".}
proc textDragExit*(this: var TextDragAndDropTarget, text: String) {.header: juce_gui_basics, importcpp: "#.textDragExit(@)".}
proc textDropped*(this: var TextDragAndDropTarget, text: String, x: cint, y: cint) {.header: juce_gui_basics, importcpp: "#.textDropped(@)".}
proc `==`*(this: TextDragAndDropTarget, other: TextDragAndDropTarget): bool {.error: "juce::TextDragAndDropTarget defines no operator==; compare a property instead".}

proc getTooltip*(this: var TooltipClient): String {.header: juce_gui_basics, importcpp: "#.getTooltip()".}
proc `==`*(this: TooltipClient, other: TooltipClient): bool {.error: "juce::TooltipClient defines no operator==; compare a property instead".}

proc setTooltip*(this: var SettableTooltipClient, newTooltip: String) {.header: juce_gui_basics, importcpp: "#.setTooltip(@)".}
proc getTooltip*(this: var SettableTooltipClient): String {.header: juce_gui_basics, importcpp: "#.getTooltip()".}
proc `==`*(this: SettableTooltipClient, other: SettableTooltipClient): bool {.error: "juce::SettableTooltipClient defines no operator==; compare a property instead".}

proc makeCaretComponent*(keyFocusOwner: ptr Component): CaretComponent {.header: juce_gui_basics, importcpp: "juce::CaretComponent(@)".}
proc setCaretPosition*(this: var CaretComponent, characterArea: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.setCaretPosition(@)".}
proc paint*(this: var CaretComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc `==`*(this: CaretComponent, other: CaretComponent): bool {.error: "juce::CaretComponent defines no operator==; compare a property instead".}

proc getDefaultComponent*(this: var KeyboardFocusTraverser, parentComponent: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getDefaultComponent(@)".}
proc getNextComponent*(this: var KeyboardFocusTraverser, current: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getNextComponent(@)".}
proc getPreviousComponent*(this: var KeyboardFocusTraverser, current: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.getPreviousComponent(@)".}
proc getAllComponents*(this: var KeyboardFocusTraverser, parentComponent: ptr Component): CppVector[Component] {.header: juce_gui_basics, importcpp: "#.getAllComponents(@)".}
proc `==`*(this: KeyboardFocusTraverser, other: KeyboardFocusTraverser): bool {.error: "juce::KeyboardFocusTraverser defines no operator==; compare a property instead".}

proc `==`*(this: SystemClipboard, other: SystemClipboard): bool {.error: "juce::SystemClipboard defines no operator==; compare a property instead".}

proc makeTextInputTarget*(): TextInputTarget {.header: juce_gui_basics, importcpp: "juce::TextInputTarget(@)".}
proc isTextInputActive*(this: TextInputTarget): bool {.header: juce_gui_basics, importcpp: "#.isTextInputActive()".}
proc getHighlightedRegion*(this: TextInputTarget): Range[cint] {.header: juce_gui_basics, importcpp: "#.getHighlightedRegion()".}
proc setHighlightedRegion*(this: var TextInputTarget, newRange: Range[cint]) {.header: juce_gui_basics, importcpp: "#.setHighlightedRegion(@)".}
proc setTemporaryUnderlining*(this: var TextInputTarget, underlinedRegions: Array[Range[cint]]) {.header: juce_gui_basics, importcpp: "#.setTemporaryUnderlining(@)".}
proc getTextInRange*(this: TextInputTarget, range: Range[cint]): String {.header: juce_gui_basics, importcpp: "#.getTextInRange(@)".}
proc insertTextAtCaret*(this: var TextInputTarget, textToInsert: String) {.header: juce_gui_basics, importcpp: "#.insertTextAtCaret(@)".}
proc getCaretPosition*(this: TextInputTarget): cint {.header: juce_gui_basics, importcpp: "#.getCaretPosition()".}
proc getCaretRectangle*(this: TextInputTarget): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getCaretRectangle()".}
proc getCaretRectangleForCharIndex*(this: TextInputTarget, characterIndex: cint): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getCaretRectangleForCharIndex(@)".}
proc getTotalNumChars*(this: TextInputTarget): cint {.header: juce_gui_basics, importcpp: "#.getTotalNumChars()".}
proc getCharIndexForPoint*(this: TextInputTarget, point: Point[cint]): cint {.header: juce_gui_basics, importcpp: "#.getCharIndexForPoint(@)".}
proc getTextBounds*(this: TextInputTarget, textRange: Range[cint]): RectangleList[cint] {.header: juce_gui_basics, importcpp: "#.getTextBounds(@)".}
proc getKeyboardType*(this: var TextInputTarget): TextInputTargetVirtualKeyboardType {.header: juce_gui_basics, importcpp: "#.getKeyboardType()".}
proc `==`*(this: TextInputTarget, other: TextInputTarget): bool {.error: "juce::TextInputTarget defines no operator==; compare a property instead".}

proc makeApplicationCommandInfo*(commandID: cint): ApplicationCommandInfo {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandInfo(@)".}
proc setInfo*(this: var ApplicationCommandInfo, shortName: String, description: String, categoryName: String, flags: cint) {.header: juce_gui_basics, importcpp: "#.setInfo(@)".}
proc setActive*(this: var ApplicationCommandInfo, isActive: bool) {.header: juce_gui_basics, importcpp: "#.setActive(@)".}
proc setTicked*(this: var ApplicationCommandInfo, isTicked: bool) {.header: juce_gui_basics, importcpp: "#.setTicked(@)".}
proc addDefaultKeypress*(this: var ApplicationCommandInfo, keyCode: cint, modifiers: ModifierKeys) {.header: juce_gui_basics, importcpp: "#.addDefaultKeypress(@)".}
proc `==`*(this: ApplicationCommandInfo, other: ApplicationCommandInfo): bool {.error: "juce::ApplicationCommandInfo defines no operator==; compare a property instead".}

proc makeApplicationCommandTarget*(): ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandTarget(@)".}
proc getNextCommandTarget*(this: var ApplicationCommandTarget): ptr ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "#.getNextCommandTarget()".}
proc getAllCommands*(this: var ApplicationCommandTarget, commands: Array[cint]) {.header: juce_gui_basics, importcpp: "#.getAllCommands(@)".}
proc getCommandInfo*(this: var ApplicationCommandTarget, commandID: cint, result: var ApplicationCommandInfo) {.header: juce_gui_basics, importcpp: "#.getCommandInfo(@)".}
proc perform*(this: var ApplicationCommandTarget, info: ApplicationCommandTargetInvocationInfo): bool {.header: juce_gui_basics, importcpp: "#.perform(@)".}
proc invoke*(this: var ApplicationCommandTarget, invocationInfo: ApplicationCommandTargetInvocationInfo, asynchronously: bool): bool {.header: juce_gui_basics, importcpp: "#.invoke(@)".}
proc invokeDirectly*(this: var ApplicationCommandTarget, commandID: cint, asynchronously: bool): bool {.header: juce_gui_basics, importcpp: "#.invokeDirectly(@)".}
proc getTargetForCommand*(this: var ApplicationCommandTarget, commandID: cint): ptr ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "#.getTargetForCommand(@)".}
proc isCommandActive*(this: var ApplicationCommandTarget, commandID: cint): bool {.header: juce_gui_basics, importcpp: "#.isCommandActive(@)".}
proc findFirstTargetParentComponent*(this: var ApplicationCommandTarget): ptr ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "#.findFirstTargetParentComponent()".}
proc `==`*(this: ApplicationCommandTarget, other: ApplicationCommandTarget): bool {.error: "juce::ApplicationCommandTarget defines no operator==; compare a property instead".}

proc makeApplicationCommandManager*(): ApplicationCommandManager {.header: juce_gui_basics, importcpp: "juce::ApplicationCommandManager(@)".}
proc clearCommands*(this: var ApplicationCommandManager) {.header: juce_gui_basics, importcpp: "#.clearCommands()".}
proc registerCommand*(this: var ApplicationCommandManager, newCommand: ApplicationCommandInfo) {.header: juce_gui_basics, importcpp: "#.registerCommand(@)".}
proc registerAllCommandsForTarget*(this: var ApplicationCommandManager, target: ptr ApplicationCommandTarget) {.header: juce_gui_basics, importcpp: "#.registerAllCommandsForTarget(@)".}
proc removeCommand*(this: var ApplicationCommandManager, commandID: cint) {.header: juce_gui_basics, importcpp: "#.removeCommand(@)".}
proc commandStatusChanged*(this: var ApplicationCommandManager) {.header: juce_gui_basics, importcpp: "#.commandStatusChanged()".}
proc getNumCommands*(this: ApplicationCommandManager): cint {.header: juce_gui_basics, importcpp: "#.getNumCommands()".}
proc getCommandForIndex*(this: ApplicationCommandManager, index: cint): ptr ApplicationCommandInfo {.header: juce_gui_basics, importcpp: "#.getCommandForIndex(@)".}
proc getCommandForID*(this: ApplicationCommandManager, commandID: cint): ptr ApplicationCommandInfo {.header: juce_gui_basics, importcpp: "#.getCommandForID(@)".}
proc getNameOfCommand*(this: ApplicationCommandManager, commandID: cint): String {.header: juce_gui_basics, importcpp: "#.getNameOfCommand(@)".}
proc getDescriptionOfCommand*(this: ApplicationCommandManager, commandID: cint): String {.header: juce_gui_basics, importcpp: "#.getDescriptionOfCommand(@)".}
proc getCommandCategories*(this: ApplicationCommandManager): StringArray {.header: juce_gui_basics, importcpp: "#.getCommandCategories()".}
proc getCommandsInCategory*(this: ApplicationCommandManager, categoryName: String): Array[cint] {.header: juce_gui_basics, importcpp: "#.getCommandsInCategory(@)".}
proc getKeyMappings*(this: ApplicationCommandManager): ptr KeyPressMappingSet {.header: juce_gui_basics, importcpp: "#.getKeyMappings()".}
proc invokeDirectly*(this: var ApplicationCommandManager, commandID: cint, asynchronously: bool): bool {.header: juce_gui_basics, importcpp: "#.invokeDirectly(@)".}
proc invoke*(this: var ApplicationCommandManager, invocationInfo: ApplicationCommandTargetInvocationInfo, asynchronously: bool): bool {.header: juce_gui_basics, importcpp: "#.invoke(@)".}
proc getFirstCommandTarget*(this: var ApplicationCommandManager, commandID: cint): ptr ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "#.getFirstCommandTarget(@)".}
proc setFirstCommandTarget*(this: var ApplicationCommandManager, newTarget: ptr ApplicationCommandTarget) {.header: juce_gui_basics, importcpp: "#.setFirstCommandTarget(@)".}
proc getTargetForCommand*(this: var ApplicationCommandManager, commandID: cint, upToDateInfo: var ApplicationCommandInfo): ptr ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "#.getTargetForCommand(@)".}
proc addListener*(this: var ApplicationCommandManager, listener: ptr ApplicationCommandManagerListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var ApplicationCommandManager, listener: ptr ApplicationCommandManagerListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc `==`*(this: ApplicationCommandManager, other: ApplicationCommandManager): bool {.error: "juce::ApplicationCommandManager defines no operator==; compare a property instead".}

proc applicationCommandInvoked*(this: var ApplicationCommandManagerListener, arg1: ApplicationCommandTargetInvocationInfo) {.header: juce_gui_basics, importcpp: "#.applicationCommandInvoked(@)".}
proc applicationCommandListChanged*(this: var ApplicationCommandManagerListener) {.header: juce_gui_basics, importcpp: "#.applicationCommandListChanged()".}
proc `==`*(this: ApplicationCommandManagerListener, other: ApplicationCommandManagerListener): bool {.error: "juce::ApplicationCommandManagerListener defines no operator==; compare a property instead".}

proc makeKeyPressMappingSet*(arg1: var ApplicationCommandManager): KeyPressMappingSet {.header: juce_gui_basics, importcpp: "juce::KeyPressMappingSet(@)".}
proc getCommandManager*(this: KeyPressMappingSet): var ApplicationCommandManager {.header: juce_gui_basics, importcpp: "#.getCommandManager()".}
proc getKeyPressesAssignedToCommand*(this: KeyPressMappingSet, commandID: cint): Array[KeyPress] {.header: juce_gui_basics, importcpp: "#.getKeyPressesAssignedToCommand(@)".}
proc addKeyPress*(this: var KeyPressMappingSet, commandID: cint, newKeyPress: KeyPress, insertIndex: cint = -1) {.header: juce_gui_basics, importcpp: "#.addKeyPress(@)".}
proc resetToDefaultMappings*(this: var KeyPressMappingSet) {.header: juce_gui_basics, importcpp: "#.resetToDefaultMappings()".}
proc resetToDefaultMapping*(this: var KeyPressMappingSet, commandID: cint) {.header: juce_gui_basics, importcpp: "#.resetToDefaultMapping(@)".}
proc clearAllKeyPresses*(this: var KeyPressMappingSet) {.header: juce_gui_basics, importcpp: "#.clearAllKeyPresses()".}
proc clearAllKeyPresses*(this: var KeyPressMappingSet, commandID: cint) {.header: juce_gui_basics, importcpp: "#.clearAllKeyPresses(@)".}
proc removeKeyPress*(this: var KeyPressMappingSet, commandID: cint, keyPressIndex: cint) {.header: juce_gui_basics, importcpp: "#.removeKeyPress(@)".}
proc removeKeyPress*(this: var KeyPressMappingSet, keypress: KeyPress) {.header: juce_gui_basics, importcpp: "#.removeKeyPress(@)".}
proc containsMapping*(this: KeyPressMappingSet, commandID: cint, keyPress: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.containsMapping(@)".}
proc findCommandForKeyPress*(this: KeyPressMappingSet, keyPress: KeyPress): cint {.header: juce_gui_basics, importcpp: "#.findCommandForKeyPress(@)".}
proc restoreFromXml*(this: var KeyPressMappingSet, xmlVersion: XmlElement): bool {.header: juce_gui_basics, importcpp: "#.restoreFromXml(@)".}
proc createXml*(this: KeyPressMappingSet, saveDifferencesFromDefaultSet: bool): UniquePtr[XmlElement] {.header: juce_gui_basics, importcpp: "#.createXml(@)".}
proc keyPressed*(this: var KeyPressMappingSet, arg1: KeyPress, arg2: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc keyStateChanged*(this: var KeyPressMappingSet, isKeyDown: bool, arg2: ptr Component): bool {.header: juce_gui_basics, importcpp: "#.keyStateChanged(@)".}
proc globalFocusChanged*(this: var KeyPressMappingSet, arg1: ptr Component) {.header: juce_gui_basics, importcpp: "#.globalFocusChanged(@)".}
proc `==`*(this: KeyPressMappingSet, other: KeyPressMappingSet): bool {.error: "juce::KeyPressMappingSet defines no operator==; compare a property instead".}

proc setButtonText*(this: var Button, newText: String) {.header: juce_gui_basics, importcpp: "#.setButtonText(@)".}
proc getButtonText*(this: Button): String {.header: juce_gui_basics, importcpp: "#.getButtonText()".}
proc isDown*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isDown()".}
proc isOver*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isOver()".}
proc setToggleable*(this: var Button, shouldBeToggleable: bool) {.header: juce_gui_basics, importcpp: "#.setToggleable(@)".}
proc isToggleable*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isToggleable()".}
proc setToggleState*(this: var Button, shouldBeOn: bool, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setToggleState(@)".}
proc getToggleState*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.getToggleState()".}
proc getToggleStateValue*(this: var Button): var Value {.header: juce_gui_basics, importcpp: "#.getToggleStateValue()".}
proc setClickingTogglesState*(this: var Button, shouldAutoToggleOnClick: bool) {.header: juce_gui_basics, importcpp: "#.setClickingTogglesState(@)".}
proc getClickingTogglesState*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.getClickingTogglesState()".}
proc setRadioGroupId*(this: var Button, newGroupId: cint, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setRadioGroupId(@)".}
proc getRadioGroupId*(this: Button): cint {.header: juce_gui_basics, importcpp: "#.getRadioGroupId()".}
proc addListener*(this: var Button, newListener: ptr ButtonListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var Button, listener: ptr ButtonListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc triggerClick*(this: var Button) {.header: juce_gui_basics, importcpp: "#.triggerClick()".}
proc setCommandToTrigger*(this: var Button, commandManagerToUse: ptr ApplicationCommandManager, commandID: cint, generateTooltip: bool) {.header: juce_gui_basics, importcpp: "#.setCommandToTrigger(@)".}
proc getCommandID*(this: Button): cint {.header: juce_gui_basics, importcpp: "#.getCommandID()".}
proc addShortcut*(this: var Button, arg1: KeyPress) {.header: juce_gui_basics, importcpp: "#.addShortcut(@)".}
proc clearShortcuts*(this: var Button) {.header: juce_gui_basics, importcpp: "#.clearShortcuts()".}
proc isRegisteredForShortcut*(this: Button, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.isRegisteredForShortcut(@)".}
proc setRepeatSpeed*(this: var Button, initialDelayInMillisecs: cint, repeatDelayInMillisecs: cint, minimumDelayInMillisecs: cint = -1) {.header: juce_gui_basics, importcpp: "#.setRepeatSpeed(@)".}
proc setTriggeredOnMouseDown*(this: var Button, isTriggeredOnMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.setTriggeredOnMouseDown(@)".}
proc getTriggeredOnMouseDown*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.getTriggeredOnMouseDown()".}
proc getMillisecondsSinceButtonDown*(this: Button): uint32 {.header: juce_gui_basics, importcpp: "#.getMillisecondsSinceButtonDown()".}
proc setTooltip*(this: var Button, newTooltip: String) {.header: juce_gui_basics, importcpp: "#.setTooltip(@)".}
proc setConnectedEdges*(this: var Button, connectedEdgeFlags: cint) {.header: juce_gui_basics, importcpp: "#.setConnectedEdges(@)".}
proc getConnectedEdgeFlags*(this: Button): cint {.header: juce_gui_basics, importcpp: "#.getConnectedEdgeFlags()".}
proc isConnectedOnLeft*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isConnectedOnLeft()".}
proc isConnectedOnRight*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isConnectedOnRight()".}
proc isConnectedOnTop*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isConnectedOnTop()".}
proc isConnectedOnBottom*(this: Button): bool {.header: juce_gui_basics, importcpp: "#.isConnectedOnBottom()".}
proc setState*(this: var Button, newState: ButtonButtonState) {.header: juce_gui_basics, importcpp: "#.setState(@)".}
proc getState*(this: Button): ButtonButtonState {.header: juce_gui_basics, importcpp: "#.getState()".}
proc setToggleState*(this: var Button, arg1: bool, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setToggleState(@)".}
proc `==`*(this: Button, other: Button): bool {.error: "juce::Button defines no operator==; compare a property instead".}

proc makeArrowButton*(buttonName: String, arrowDirection: cfloat, arrowColour: Colour): ArrowButton {.header: juce_gui_basics, importcpp: "juce::ArrowButton(@)".}
proc paintButton*(this: var ArrowButton, arg1: var Graphics, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.paintButton(@)".}
proc `==`*(this: ArrowButton, other: ArrowButton): bool {.error: "juce::ArrowButton defines no operator==; compare a property instead".}

proc makeDrawableButton*(buttonName: String, buttonStyle: DrawableButtonButtonStyle): DrawableButton {.header: juce_gui_basics, importcpp: "juce::DrawableButton(@)".}
proc setImages*(this: var DrawableButton, normalImage: ptr Drawable, overImage: ptr Drawable = nil, downImage: ptr Drawable = nil, disabledImage: ptr Drawable = nil, normalImageOn: ptr Drawable = nil, overImageOn: ptr Drawable = nil, downImageOn: ptr Drawable = nil, disabledImageOn: ptr Drawable = nil) {.header: juce_gui_basics, importcpp: "#.setImages(@)".}
proc setButtonStyle*(this: var DrawableButton, newStyle: DrawableButtonButtonStyle) {.header: juce_gui_basics, importcpp: "#.setButtonStyle(@)".}
proc getStyle*(this: DrawableButton): DrawableButtonButtonStyle {.header: juce_gui_basics, importcpp: "#.getStyle()".}
proc setEdgeIndent*(this: var DrawableButton, numPixelsIndent: cint) {.header: juce_gui_basics, importcpp: "#.setEdgeIndent(@)".}
proc getEdgeIndent*(this: DrawableButton): cint {.header: juce_gui_basics, importcpp: "#.getEdgeIndent()".}
proc getCurrentImage*(this: DrawableButton): ptr Drawable {.header: juce_gui_basics, importcpp: "#.getCurrentImage()".}
proc getNormalImage*(this: DrawableButton): ptr Drawable {.header: juce_gui_basics, importcpp: "#.getNormalImage()".}
proc getOverImage*(this: DrawableButton): ptr Drawable {.header: juce_gui_basics, importcpp: "#.getOverImage()".}
proc getDownImage*(this: DrawableButton): ptr Drawable {.header: juce_gui_basics, importcpp: "#.getDownImage()".}
proc getImageBounds*(this: DrawableButton): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getImageBounds()".}
proc paintButton*(this: var DrawableButton, arg1: var Graphics, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.paintButton(@)".}
proc buttonStateChanged*(this: var DrawableButton) {.header: juce_gui_basics, importcpp: "#.buttonStateChanged()".}
proc resized*(this: var DrawableButton) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc enablementChanged*(this: var DrawableButton) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc colourChanged*(this: var DrawableButton) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc `==`*(this: DrawableButton, other: DrawableButton): bool {.error: "juce::DrawableButton defines no operator==; compare a property instead".}

proc makeHyperlinkButton*(linkText: String, linkURL: URL): HyperlinkButton {.header: juce_gui_basics, importcpp: "juce::HyperlinkButton(@)".}
proc makeHyperlinkButton*(): HyperlinkButton {.header: juce_gui_basics, importcpp: "juce::HyperlinkButton(@)".}
proc setFont*(this: var HyperlinkButton, newFont: Font, resizeToMatchComponentHeight: bool, justificationType: Justification) {.header: juce_gui_basics, importcpp: "#.setFont(@)".}
proc setURL*(this: var HyperlinkButton, newURL: URL) {.header: juce_gui_basics, importcpp: "#.setURL(@)".}
proc getURL*(this: HyperlinkButton): URL {.header: juce_gui_basics, importcpp: "#.getURL()".}
proc changeWidthToFitText*(this: var HyperlinkButton) {.header: juce_gui_basics, importcpp: "#.changeWidthToFitText()".}
proc setJustificationType*(this: var HyperlinkButton, justification: Justification) {.header: juce_gui_basics, importcpp: "#.setJustificationType(@)".}
proc getJustificationType*(this: HyperlinkButton): Justification {.header: juce_gui_basics, importcpp: "#.getJustificationType()".}
proc createAccessibilityHandler*(this: var HyperlinkButton): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: HyperlinkButton, other: HyperlinkButton): bool {.error: "juce::HyperlinkButton defines no operator==; compare a property instead".}

proc makeImageButton*(name: String): ImageButton {.header: juce_gui_basics, importcpp: "juce::ImageButton(@)".}
proc setImages*(this: var ImageButton, resizeButtonNowToFitThisImage: bool, rescaleImagesWhenButtonSizeChanges: bool, preserveImageProportions: bool, normalImage: Image, imageOpacityWhenNormal: cfloat, overlayColourWhenNormal: Colour, overImage: Image, imageOpacityWhenOver: cfloat, overlayColourWhenOver: Colour, downImage: Image, imageOpacityWhenDown: cfloat, overlayColourWhenDown: Colour, hitTestAlphaThreshold: cfloat = 0.0f) {.header: juce_gui_basics, importcpp: "#.setImages(@)".}
proc getNormalImage*(this: ImageButton): Image {.header: juce_gui_basics, importcpp: "#.getNormalImage()".}
proc getOverImage*(this: ImageButton): Image {.header: juce_gui_basics, importcpp: "#.getOverImage()".}
proc getDownImage*(this: ImageButton): Image {.header: juce_gui_basics, importcpp: "#.getDownImage()".}
proc setImageResamplingQuality*(this: var ImageButton, newQuality: GraphicsResamplingQuality) {.header: juce_gui_basics, importcpp: "#.setImageResamplingQuality(@)".}
proc `==`*(this: ImageButton, other: ImageButton): bool {.error: "juce::ImageButton defines no operator==; compare a property instead".}

proc makeShapeButton*(name: String, normalColour: Colour, overColour: Colour, downColour: Colour): ShapeButton {.header: juce_gui_basics, importcpp: "juce::ShapeButton(@)".}
proc setShape*(this: var ShapeButton, newShape: Path, resizeNowToFitThisShape: bool, maintainShapeProportions: bool, hasDropShadow: bool) {.header: juce_gui_basics, importcpp: "#.setShape(@)".}
proc setColours*(this: var ShapeButton, normalColour: Colour, overColour: Colour, downColour: Colour) {.header: juce_gui_basics, importcpp: "#.setColours(@)".}
proc setOnColours*(this: var ShapeButton, normalColourOn: Colour, overColourOn: Colour, downColourOn: Colour) {.header: juce_gui_basics, importcpp: "#.setOnColours(@)".}
proc shouldUseOnColours*(this: var ShapeButton, shouldUse: bool) {.header: juce_gui_basics, importcpp: "#.shouldUseOnColours(@)".}
proc setOutline*(this: var ShapeButton, outlineColour: Colour, outlineStrokeWidth: cfloat) {.header: juce_gui_basics, importcpp: "#.setOutline(@)".}
proc setBorderSize*(this: var ShapeButton, border: BorderSize[cint]) {.header: juce_gui_basics, importcpp: "#.setBorderSize(@)".}
proc paintButton*(this: var ShapeButton, arg1: var Graphics, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.paintButton(@)".}
proc `==`*(this: ShapeButton, other: ShapeButton): bool {.error: "juce::ShapeButton defines no operator==; compare a property instead".}

proc makeTextButton*(): TextButton {.header: juce_gui_basics, importcpp: "juce::TextButton(@)".}
proc makeTextButton*(buttonName: String): TextButton {.header: juce_gui_basics, importcpp: "juce::TextButton(@)".}
proc makeTextButton*(buttonName: String, toolTip: String): TextButton {.header: juce_gui_basics, importcpp: "juce::TextButton(@)".}
proc changeWidthToFitText*(this: var TextButton) {.header: juce_gui_basics, importcpp: "#.changeWidthToFitText()".}
proc changeWidthToFitText*(this: var TextButton, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.changeWidthToFitText(@)".}
proc getBestWidthForHeight*(this: var TextButton, buttonHeight: cint): cint {.header: juce_gui_basics, importcpp: "#.getBestWidthForHeight(@)".}
proc paintButton*(this: var TextButton, arg1: var Graphics, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.paintButton(@)".}
proc colourChanged*(this: var TextButton) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc `TextButton=`*(this: var TextButton, arg1: TextButton): var TextButton {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc `==`*(this: TextButton, other: TextButton): bool {.error: "juce::TextButton defines no operator==; compare a property instead".}

proc makeToggleButton*(): ToggleButton {.header: juce_gui_basics, importcpp: "juce::ToggleButton(@)".}
proc makeToggleButton*(buttonText: String): ToggleButton {.header: juce_gui_basics, importcpp: "juce::ToggleButton(@)".}
proc changeWidthToFitText*(this: var ToggleButton) {.header: juce_gui_basics, importcpp: "#.changeWidthToFitText()".}
proc createAccessibilityHandler*(this: var ToggleButton): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ToggleButton, other: ToggleButton): bool {.error: "juce::ToggleButton defines no operator==; compare a property instead".}

proc makeComponentBuilder*(state: ValueTree): ComponentBuilder {.header: juce_gui_basics, importcpp: "juce::ComponentBuilder(@)".}
proc makeComponentBuilder*(): ComponentBuilder {.header: juce_gui_basics, importcpp: "juce::ComponentBuilder(@)".}
proc getManagedComponent*(this: var ComponentBuilder): ptr Component {.header: juce_gui_basics, importcpp: "#.getManagedComponent()".}
proc createComponent*(this: var ComponentBuilder): ptr Component {.header: juce_gui_basics, importcpp: "#.createComponent()".}
proc registerTypeHandler*(this: var ComponentBuilder, `type`: ptr ComponentBuilderTypeHandler) {.header: juce_gui_basics, importcpp: "#.registerTypeHandler(@)".}
proc getHandlerForState*(this: ComponentBuilder, state: ValueTree): ptr ComponentBuilderTypeHandler {.header: juce_gui_basics, importcpp: "#.getHandlerForState(@)".}
proc getNumHandlers*(this: ComponentBuilder): cint {.header: juce_gui_basics, importcpp: "#.getNumHandlers()".}
proc getHandler*(this: ComponentBuilder, index: cint): ptr ComponentBuilderTypeHandler {.header: juce_gui_basics, importcpp: "#.getHandler(@)".}
proc registerStandardComponentTypes*(this: var ComponentBuilder) {.header: juce_gui_basics, importcpp: "#.registerStandardComponentTypes()".}
proc setImageProvider*(this: var ComponentBuilder, newImageProvider: ptr ComponentBuilderImageProvider) {.header: juce_gui_basics, importcpp: "#.setImageProvider(@)".}
proc getImageProvider*(this: ComponentBuilder): ptr ComponentBuilderImageProvider {.header: juce_gui_basics, importcpp: "#.getImageProvider()".}
proc updateChildComponents*(this: var ComponentBuilder, parent: var Component, children: ValueTree) {.header: juce_gui_basics, importcpp: "#.updateChildComponents(@)".}
proc `==`*(this: ComponentBuilder, other: ComponentBuilder): bool {.error: "juce::ComponentBuilder defines no operator==; compare a property instead".}

proc makeComponentMovementWatcher*(componentToWatch: ptr Component): ComponentMovementWatcher {.header: juce_gui_basics, importcpp: "juce::ComponentMovementWatcher(@)".}
proc componentMovedOrResized*(this: var ComponentMovementWatcher, wasMoved: bool, wasResized: bool) {.header: juce_gui_basics, importcpp: "#.componentMovedOrResized(@)".}
proc componentPeerChanged*(this: var ComponentMovementWatcher) {.header: juce_gui_basics, importcpp: "#.componentPeerChanged()".}
proc componentVisibilityChanged*(this: var ComponentMovementWatcher) {.header: juce_gui_basics, importcpp: "#.componentVisibilityChanged()".}
proc getComponent*(this: ComponentMovementWatcher): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponent()".}
proc componentParentHierarchyChanged*(this: var ComponentMovementWatcher, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentParentHierarchyChanged(@)".}
proc componentMovedOrResized*(this: var ComponentMovementWatcher, arg1: var Component, wasMoved: bool, wasResized: bool) {.header: juce_gui_basics, importcpp: "#.componentMovedOrResized(@)".}
proc componentBeingDeleted*(this: var ComponentMovementWatcher, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentBeingDeleted(@)".}
proc componentVisibilityChanged*(this: var ComponentMovementWatcher, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentVisibilityChanged(@)".}
proc `==`*(this: ComponentMovementWatcher, other: ComponentMovementWatcher): bool {.error: "juce::ComponentMovementWatcher defines no operator==; compare a property instead".}

proc makeConcertinaPanel*(): ConcertinaPanel {.header: juce_gui_basics, importcpp: "juce::ConcertinaPanel(@)".}
proc addPanel*(this: var ConcertinaPanel, insertIndex: cint, component: ptr Component, takeOwnership: bool) {.header: juce_gui_basics, importcpp: "#.addPanel(@)".}
proc removePanel*(this: var ConcertinaPanel, panelComponent: ptr Component) {.header: juce_gui_basics, importcpp: "#.removePanel(@)".}
proc getNumPanels*(this: ConcertinaPanel): cint {.header: juce_gui_basics, importcpp: "#.getNumPanels()".}
proc getPanel*(this: ConcertinaPanel, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getPanel(@)".}
proc setPanelSize*(this: var ConcertinaPanel, panelComponent: ptr Component, newHeight: cint, animate: bool): bool {.header: juce_gui_basics, importcpp: "#.setPanelSize(@)".}
proc expandPanelFully*(this: var ConcertinaPanel, panelComponent: ptr Component, animate: bool): bool {.header: juce_gui_basics, importcpp: "#.expandPanelFully(@)".}
proc setMaximumPanelSize*(this: var ConcertinaPanel, panelComponent: ptr Component, maximumSize: cint) {.header: juce_gui_basics, importcpp: "#.setMaximumPanelSize(@)".}
proc setPanelHeaderSize*(this: var ConcertinaPanel, panelComponent: ptr Component, headerSize: cint) {.header: juce_gui_basics, importcpp: "#.setPanelHeaderSize(@)".}
proc setCustomPanelHeader*(this: var ConcertinaPanel, panelComponent: ptr Component, customHeaderComponent: ptr Component, takeOwnership: bool) {.header: juce_gui_basics, importcpp: "#.setCustomPanelHeader(@)".}
proc createAccessibilityHandler*(this: var ConcertinaPanel): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ConcertinaPanel, other: ConcertinaPanel): bool {.error: "juce::ConcertinaPanel defines no operator==; compare a property instead".}

proc makeGroupComponent*(componentName: String, labelText: String): GroupComponent {.header: juce_gui_basics, importcpp: "juce::GroupComponent(@)".}
proc setText*(this: var GroupComponent, newText: String) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc getText*(this: GroupComponent): String {.header: juce_gui_basics, importcpp: "#.getText()".}
proc setTextLabelPosition*(this: var GroupComponent, justification: Justification) {.header: juce_gui_basics, importcpp: "#.setTextLabelPosition(@)".}
proc getTextLabelPosition*(this: GroupComponent): Justification {.header: juce_gui_basics, importcpp: "#.getTextLabelPosition()".}
proc paint*(this: var GroupComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc enablementChanged*(this: var GroupComponent) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc colourChanged*(this: var GroupComponent) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc createAccessibilityHandler*(this: var GroupComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: GroupComponent, other: GroupComponent): bool {.error: "juce::GroupComponent defines no operator==; compare a property instead".}

proc makeResizableBorderComponent*(componentToResize: ptr Component, constrainer: ptr ComponentBoundsConstrainer): ResizableBorderComponent {.header: juce_gui_basics, importcpp: "juce::ResizableBorderComponent(@)".}
proc setBorderThickness*(this: var ResizableBorderComponent, newBorderSize: BorderSize[cint]) {.header: juce_gui_basics, importcpp: "#.setBorderThickness(@)".}
proc getBorderThickness*(this: ResizableBorderComponent): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getBorderThickness()".}
proc getCurrentZone*(this: ResizableBorderComponent): ResizableBorderComponentZone {.header: juce_gui_basics, importcpp: "#.getCurrentZone()".}
proc `==`*(this: ResizableBorderComponent, other: ResizableBorderComponent): bool {.error: "juce::ResizableBorderComponent defines no operator==; compare a property instead".}

proc makeResizableCornerComponent*(componentToResize: ptr Component, constrainer: ptr ComponentBoundsConstrainer): ResizableCornerComponent {.header: juce_gui_basics, importcpp: "juce::ResizableCornerComponent(@)".}
proc `==`*(this: ResizableCornerComponent, other: ResizableCornerComponent): bool {.error: "juce::ResizableCornerComponent defines no operator==; compare a property instead".}

proc makeResizableEdgeComponent*(componentToResize: ptr Component, constrainer: ptr ComponentBoundsConstrainer, edgeToResize: ResizableEdgeComponentEdge): ResizableEdgeComponent {.header: juce_gui_basics, importcpp: "juce::ResizableEdgeComponent(@)".}
proc isVertical*(this: ResizableEdgeComponent): bool {.header: juce_gui_basics, importcpp: "#.isVertical()".}
proc `==`*(this: ResizableEdgeComponent, other: ResizableEdgeComponent): bool {.error: "juce::ResizableEdgeComponent defines no operator==; compare a property instead".}

proc makeScrollBar*(isVertical: bool): ScrollBar {.header: juce_gui_basics, importcpp: "juce::ScrollBar(@)".}
proc isVertical*(this: ScrollBar): bool {.header: juce_gui_basics, importcpp: "#.isVertical()".}
proc setOrientation*(this: var ScrollBar, shouldBeVertical: bool) {.header: juce_gui_basics, importcpp: "#.setOrientation(@)".}
proc setAutoHide*(this: var ScrollBar, shouldHideWhenFullRange: bool) {.header: juce_gui_basics, importcpp: "#.setAutoHide(@)".}
proc autoHides*(this: ScrollBar): bool {.header: juce_gui_basics, importcpp: "#.autoHides()".}
proc setRangeLimits*(this: var ScrollBar, newRangeLimit: Range[cdouble], notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setRangeLimits(@)".}
proc setRangeLimits*(this: var ScrollBar, minimum: float64, maximum: float64, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setRangeLimits(@)".}
proc getRangeLimit*(this: ScrollBar): Range[cdouble] {.header: juce_gui_basics, importcpp: "#.getRangeLimit()".}
proc getMinimumRangeLimit*(this: ScrollBar): float64 {.header: juce_gui_basics, importcpp: "#.getMinimumRangeLimit()".}
proc getMaximumRangeLimit*(this: ScrollBar): float64 {.header: juce_gui_basics, importcpp: "#.getMaximumRangeLimit()".}
proc setCurrentRange*(this: var ScrollBar, newRange: Range[cdouble], notification: NotificationType): bool {.header: juce_gui_basics, importcpp: "#.setCurrentRange(@)".}
proc setCurrentRange*(this: var ScrollBar, newStart: float64, newSize: float64, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setCurrentRange(@)".}
proc setCurrentRangeStart*(this: var ScrollBar, newStart: float64, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setCurrentRangeStart(@)".}
proc getCurrentRange*(this: ScrollBar): Range[cdouble] {.header: juce_gui_basics, importcpp: "#.getCurrentRange()".}
proc getCurrentRangeStart*(this: ScrollBar): float64 {.header: juce_gui_basics, importcpp: "#.getCurrentRangeStart()".}
proc getCurrentRangeSize*(this: ScrollBar): float64 {.header: juce_gui_basics, importcpp: "#.getCurrentRangeSize()".}
proc setSingleStepSize*(this: var ScrollBar, newSingleStepSize: float64) {.header: juce_gui_basics, importcpp: "#.setSingleStepSize(@)".}
proc getSingleStepSize*(this: ScrollBar): float64 {.header: juce_gui_basics, importcpp: "#.getSingleStepSize()".}
proc moveScrollbarInSteps*(this: var ScrollBar, howManySteps: cint, notification: NotificationType): bool {.header: juce_gui_basics, importcpp: "#.moveScrollbarInSteps(@)".}
proc moveScrollbarInPages*(this: var ScrollBar, howManyPages: cint, notification: NotificationType): bool {.header: juce_gui_basics, importcpp: "#.moveScrollbarInPages(@)".}
proc scrollToTop*(this: var ScrollBar, notification: NotificationType): bool {.header: juce_gui_basics, importcpp: "#.scrollToTop(@)".}
proc scrollToBottom*(this: var ScrollBar, notification: NotificationType): bool {.header: juce_gui_basics, importcpp: "#.scrollToBottom(@)".}
proc setButtonRepeatSpeed*(this: var ScrollBar, initialDelayInMillisecs: cint, repeatDelayInMillisecs: cint, minimumDelayInMillisecs: cint = -1) {.header: juce_gui_basics, importcpp: "#.setButtonRepeatSpeed(@)".}
proc addListener*(this: var ScrollBar, listener: ptr ScrollBarListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var ScrollBar, listener: ptr ScrollBarListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc keyPressed*(this: var ScrollBar, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc mouseWheelMove*(this: var ScrollBar, arg1: MouseEvent, arg2: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc lookAndFeelChanged*(this: var ScrollBar) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc mouseDown*(this: var ScrollBar, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var ScrollBar, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var ScrollBar, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc paint*(this: var ScrollBar, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var ScrollBar) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc parentHierarchyChanged*(this: var ScrollBar) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc setVisible*(this: var ScrollBar, arg1: bool) {.header: juce_gui_basics, importcpp: "#.setVisible(@)".}
proc createAccessibilityHandler*(this: var ScrollBar): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ScrollBar, other: ScrollBar): bool {.error: "juce::ScrollBar defines no operator==; compare a property instead".}

proc makeStretchableLayoutManager*(): StretchableLayoutManager {.header: juce_gui_basics, importcpp: "juce::StretchableLayoutManager(@)".}
proc setItemLayout*(this: var StretchableLayoutManager, itemIndex: cint, minimumSize: float64, maximumSize: float64, preferredSize: float64) {.header: juce_gui_basics, importcpp: "#.setItemLayout(@)".}
proc getItemLayout*(this: StretchableLayoutManager, itemIndex: cint, minimumSize: var float64, maximumSize: var float64, preferredSize: var float64): bool {.header: juce_gui_basics, importcpp: "#.getItemLayout(@)".}
proc clearAllItems*(this: var StretchableLayoutManager) {.header: juce_gui_basics, importcpp: "#.clearAllItems()".}
proc layOutComponents*(this: var StretchableLayoutManager, components: Component, numComponents: cint, x: cint, y: cint, width: cint, height: cint, vertically: bool, resizeOtherDimension: bool) {.header: juce_gui_basics, importcpp: "#.layOutComponents(@)".}
proc getItemCurrentPosition*(this: StretchableLayoutManager, itemIndex: cint): cint {.header: juce_gui_basics, importcpp: "#.getItemCurrentPosition(@)".}
proc getItemCurrentAbsoluteSize*(this: StretchableLayoutManager, itemIndex: cint): cint {.header: juce_gui_basics, importcpp: "#.getItemCurrentAbsoluteSize(@)".}
proc getItemCurrentRelativeSize*(this: StretchableLayoutManager, itemIndex: cint): float64 {.header: juce_gui_basics, importcpp: "#.getItemCurrentRelativeSize(@)".}
proc setItemPosition*(this: var StretchableLayoutManager, itemIndex: cint, newPosition: cint) {.header: juce_gui_basics, importcpp: "#.setItemPosition(@)".}
proc `==`*(this: StretchableLayoutManager, other: StretchableLayoutManager): bool {.error: "juce::StretchableLayoutManager defines no operator==; compare a property instead".}

proc makeStretchableLayoutResizerBar*(layoutToUse: ptr StretchableLayoutManager, itemIndexInLayout: cint, isBarVertical: bool): StretchableLayoutResizerBar {.header: juce_gui_basics, importcpp: "juce::StretchableLayoutResizerBar(@)".}
proc hasBeenMoved*(this: var StretchableLayoutResizerBar) {.header: juce_gui_basics, importcpp: "#.hasBeenMoved()".}
proc paint*(this: var StretchableLayoutResizerBar, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc mouseDown*(this: var StretchableLayoutResizerBar, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var StretchableLayoutResizerBar, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc `==`*(this: StretchableLayoutResizerBar, other: StretchableLayoutResizerBar): bool {.error: "juce::StretchableLayoutResizerBar defines no operator==; compare a property instead".}

proc makeStretchableObjectResizer*(): StretchableObjectResizer {.header: juce_gui_basics, importcpp: "juce::StretchableObjectResizer(@)".}
proc addItem*(this: var StretchableObjectResizer, currentSize: float64, minSize: float64, maxSize: float64, order: cint = 0) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc resizeToFit*(this: var StretchableObjectResizer, targetSize: float64) {.header: juce_gui_basics, importcpp: "#.resizeToFit(@)".}
proc getNumItems*(this: StretchableObjectResizer): cint {.header: juce_gui_basics, importcpp: "#.getNumItems()".}
proc getItemSize*(this: StretchableObjectResizer, index: cint): float64 {.header: juce_gui_basics, importcpp: "#.getItemSize(@)".}
proc `==`*(this: StretchableObjectResizer, other: StretchableObjectResizer): bool {.error: "juce::StretchableObjectResizer defines no operator==; compare a property instead".}

proc makeTabBarButton*(name: String, ownerBar: var TabbedButtonBar): TabBarButton {.header: juce_gui_basics, importcpp: "juce::TabBarButton(@)".}
proc getTabbedButtonBar*(this: TabBarButton): var TabbedButtonBar {.header: juce_gui_basics, importcpp: "#.getTabbedButtonBar()".}
proc setExtraComponent*(this: var TabBarButton, extraTabComponent: ptr Component, extraComponentPlacement: TabBarButtonExtraComponentPlacement) {.header: juce_gui_basics, importcpp: "#.setExtraComponent(@)".}
proc getExtraComponent*(this: TabBarButton): ptr Component {.header: juce_gui_basics, importcpp: "#.getExtraComponent()".}
proc getExtraComponentPlacement*(this: TabBarButton): TabBarButtonExtraComponentPlacement {.header: juce_gui_basics, importcpp: "#.getExtraComponentPlacement()".}
proc getActiveArea*(this: TabBarButton): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getActiveArea()".}
proc getTextArea*(this: TabBarButton): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getTextArea()".}
proc getIndex*(this: TabBarButton): cint {.header: juce_gui_basics, importcpp: "#.getIndex()".}
proc getTabBackgroundColour*(this: TabBarButton): Colour {.header: juce_gui_basics, importcpp: "#.getTabBackgroundColour()".}
proc isFrontTab*(this: TabBarButton): bool {.header: juce_gui_basics, importcpp: "#.isFrontTab()".}
proc getBestTabLength*(this: var TabBarButton, depth: cint): cint {.header: juce_gui_basics, importcpp: "#.getBestTabLength(@)".}
proc paintButton*(this: var TabBarButton, arg1: var Graphics, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.paintButton(@)".}
proc clicked*(this: var TabBarButton, arg1: ModifierKeys) {.header: juce_gui_basics, importcpp: "#.clicked(@)".}
proc hitTest*(this: var TabBarButton, x: cint, y: cint): bool {.header: juce_gui_basics, importcpp: "#.hitTest(@)".}
proc resized*(this: var TabBarButton) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc childBoundsChanged*(this: var TabBarButton, arg1: ptr Component) {.header: juce_gui_basics, importcpp: "#.childBoundsChanged(@)".}
proc `==`*(this: TabBarButton, other: TabBarButton): bool {.error: "juce::TabBarButton defines no operator==; compare a property instead".}

proc makeTabbedButtonBar*(orientation: TabbedButtonBarOrientation): TabbedButtonBar {.header: juce_gui_basics, importcpp: "juce::TabbedButtonBar(@)".}
proc setOrientation*(this: var TabbedButtonBar, orientation: TabbedButtonBarOrientation) {.header: juce_gui_basics, importcpp: "#.setOrientation(@)".}
proc getOrientation*(this: TabbedButtonBar): TabbedButtonBarOrientation {.header: juce_gui_basics, importcpp: "#.getOrientation()".}
proc isVertical*(this: TabbedButtonBar): bool {.header: juce_gui_basics, importcpp: "#.isVertical()".}
proc getThickness*(this: TabbedButtonBar): cint {.header: juce_gui_basics, importcpp: "#.getThickness()".}
proc setMinimumTabScaleFactor*(this: var TabbedButtonBar, newMinimumScale: float64) {.header: juce_gui_basics, importcpp: "#.setMinimumTabScaleFactor(@)".}
proc clearTabs*(this: var TabbedButtonBar) {.header: juce_gui_basics, importcpp: "#.clearTabs()".}
proc addTab*(this: var TabbedButtonBar, tabName: String, tabBackgroundColour: Colour, insertIndex: cint) {.header: juce_gui_basics, importcpp: "#.addTab(@)".}
proc setTabName*(this: var TabbedButtonBar, tabIndex: cint, newName: String) {.header: juce_gui_basics, importcpp: "#.setTabName(@)".}
proc removeTab*(this: var TabbedButtonBar, tabIndex: cint, animate: bool = false) {.header: juce_gui_basics, importcpp: "#.removeTab(@)".}
proc moveTab*(this: var TabbedButtonBar, currentIndex: cint, newIndex: cint, animate: bool = false) {.header: juce_gui_basics, importcpp: "#.moveTab(@)".}
proc getNumTabs*(this: TabbedButtonBar): cint {.header: juce_gui_basics, importcpp: "#.getNumTabs()".}
proc getTabNames*(this: TabbedButtonBar): StringArray {.header: juce_gui_basics, importcpp: "#.getTabNames()".}
proc setCurrentTabIndex*(this: var TabbedButtonBar, newTabIndex: cint, sendChangeMessage: bool = true) {.header: juce_gui_basics, importcpp: "#.setCurrentTabIndex(@)".}
proc getCurrentTabName*(this: TabbedButtonBar): String {.header: juce_gui_basics, importcpp: "#.getCurrentTabName()".}
proc getCurrentTabIndex*(this: TabbedButtonBar): cint {.header: juce_gui_basics, importcpp: "#.getCurrentTabIndex()".}
proc getTabButton*(this: TabbedButtonBar, index: cint): ptr TabBarButton {.header: juce_gui_basics, importcpp: "#.getTabButton(@)".}
proc indexOfTabButton*(this: TabbedButtonBar, button: ptr TabBarButton): cint {.header: juce_gui_basics, importcpp: "#.indexOfTabButton(@)".}
proc getTargetBounds*(this: TabbedButtonBar, button: ptr TabBarButton): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getTargetBounds(@)".}
proc currentTabChanged*(this: var TabbedButtonBar, newCurrentTabIndex: cint, newCurrentTabName: String) {.header: juce_gui_basics, importcpp: "#.currentTabChanged(@)".}
proc popupMenuClickOnTab*(this: var TabbedButtonBar, tabIndex: cint, tabName: String) {.header: juce_gui_basics, importcpp: "#.popupMenuClickOnTab(@)".}
proc getTabBackgroundColour*(this: var TabbedButtonBar, tabIndex: cint): Colour {.header: juce_gui_basics, importcpp: "#.getTabBackgroundColour(@)".}
proc setTabBackgroundColour*(this: var TabbedButtonBar, tabIndex: cint, newColour: Colour) {.header: juce_gui_basics, importcpp: "#.setTabBackgroundColour(@)".}
proc paint*(this: var TabbedButtonBar, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var TabbedButtonBar) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc lookAndFeelChanged*(this: var TabbedButtonBar) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc createAccessibilityHandler*(this: var TabbedButtonBar): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: TabbedButtonBar, other: TabbedButtonBar): bool {.error: "juce::TabbedButtonBar defines no operator==; compare a property instead".}

proc makeTabbedComponent*(orientation: TabbedButtonBarOrientation): TabbedComponent {.header: juce_gui_basics, importcpp: "juce::TabbedComponent(@)".}
proc setOrientation*(this: var TabbedComponent, orientation: TabbedButtonBarOrientation) {.header: juce_gui_basics, importcpp: "#.setOrientation(@)".}
proc getOrientation*(this: TabbedComponent): TabbedButtonBarOrientation {.header: juce_gui_basics, importcpp: "#.getOrientation()".}
proc setTabBarDepth*(this: var TabbedComponent, newDepth: cint) {.header: juce_gui_basics, importcpp: "#.setTabBarDepth(@)".}
proc getTabBarDepth*(this: TabbedComponent): cint {.header: juce_gui_basics, importcpp: "#.getTabBarDepth()".}
proc setOutline*(this: var TabbedComponent, newThickness: cint) {.header: juce_gui_basics, importcpp: "#.setOutline(@)".}
proc setIndent*(this: var TabbedComponent, indentThickness: cint) {.header: juce_gui_basics, importcpp: "#.setIndent(@)".}
proc clearTabs*(this: var TabbedComponent) {.header: juce_gui_basics, importcpp: "#.clearTabs()".}
proc addTab*(this: var TabbedComponent, tabName: String, tabBackgroundColour: Colour, contentComponent: ptr Component, deleteComponentWhenNotNeeded: bool, insertIndex: cint = -1) {.header: juce_gui_basics, importcpp: "#.addTab(@)".}
proc setTabName*(this: var TabbedComponent, tabIndex: cint, newName: String) {.header: juce_gui_basics, importcpp: "#.setTabName(@)".}
proc removeTab*(this: var TabbedComponent, tabIndex: cint) {.header: juce_gui_basics, importcpp: "#.removeTab(@)".}
proc moveTab*(this: var TabbedComponent, currentIndex: cint, newIndex: cint, animate: bool = false) {.header: juce_gui_basics, importcpp: "#.moveTab(@)".}
proc getNumTabs*(this: TabbedComponent): cint {.header: juce_gui_basics, importcpp: "#.getNumTabs()".}
proc getTabNames*(this: TabbedComponent): StringArray {.header: juce_gui_basics, importcpp: "#.getTabNames()".}
proc getTabContentComponent*(this: TabbedComponent, tabIndex: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getTabContentComponent(@)".}
proc getTabBackgroundColour*(this: TabbedComponent, tabIndex: cint): Colour {.header: juce_gui_basics, importcpp: "#.getTabBackgroundColour(@)".}
proc setTabBackgroundColour*(this: var TabbedComponent, tabIndex: cint, newColour: Colour) {.header: juce_gui_basics, importcpp: "#.setTabBackgroundColour(@)".}
proc setCurrentTabIndex*(this: var TabbedComponent, newTabIndex: cint, sendChangeMessage: bool = true) {.header: juce_gui_basics, importcpp: "#.setCurrentTabIndex(@)".}
proc getCurrentTabIndex*(this: TabbedComponent): cint {.header: juce_gui_basics, importcpp: "#.getCurrentTabIndex()".}
proc getCurrentTabName*(this: TabbedComponent): String {.header: juce_gui_basics, importcpp: "#.getCurrentTabName()".}
proc getCurrentContentComponent*(this: TabbedComponent): ptr Component {.header: juce_gui_basics, importcpp: "#.getCurrentContentComponent()".}
proc currentTabChanged*(this: var TabbedComponent, newCurrentTabIndex: cint, newCurrentTabName: String) {.header: juce_gui_basics, importcpp: "#.currentTabChanged(@)".}
proc popupMenuClickOnTab*(this: var TabbedComponent, tabIndex: cint, tabName: String) {.header: juce_gui_basics, importcpp: "#.popupMenuClickOnTab(@)".}
proc getTabbedButtonBar*(this: TabbedComponent): var TabbedButtonBar {.header: juce_gui_basics, importcpp: "#.getTabbedButtonBar()".}
proc paint*(this: var TabbedComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var TabbedComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc lookAndFeelChanged*(this: var TabbedComponent) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc createAccessibilityHandler*(this: var TabbedComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: TabbedComponent, other: TabbedComponent): bool {.error: "juce::TabbedComponent defines no operator==; compare a property instead".}

proc getDisclosureLevel*(this: AccessibilityCellInterface): cint {.header: juce_gui_basics, importcpp: "#.getDisclosureLevel()".}
proc getTableHandler*(this: AccessibilityCellInterface): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getTableHandler()".}
proc getDisclosedRows*(this: AccessibilityCellInterface): CppVector[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.getDisclosedRows()".}
proc `==`*(this: AccessibilityCellInterface, other: AccessibilityCellInterface): bool {.error: "juce::AccessibilityCellInterface defines no operator==; compare a property instead".}

proc getNumRows*(this: AccessibilityTableInterface): cint {.header: juce_gui_basics, importcpp: "#.getNumRows()".}
proc getNumColumns*(this: AccessibilityTableInterface): cint {.header: juce_gui_basics, importcpp: "#.getNumColumns()".}
proc getCellHandler*(this: AccessibilityTableInterface, row: cint, column: cint): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getCellHandler(@)".}
proc getRowHandler*(this: AccessibilityTableInterface, row: cint): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getRowHandler(@)".}
proc getHeaderHandler*(this: AccessibilityTableInterface): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getHeaderHandler()".}
proc getRowSpan*(this: AccessibilityTableInterface, arg1: AccessibilityHandler): Optional[AccessibilityTableInterfaceSpan] {.header: juce_gui_basics, importcpp: "#.getRowSpan(@)".}
proc getColumnSpan*(this: AccessibilityTableInterface, arg1: AccessibilityHandler): Optional[AccessibilityTableInterfaceSpan] {.header: juce_gui_basics, importcpp: "#.getColumnSpan(@)".}
proc showCell*(this: AccessibilityTableInterface, arg1: AccessibilityHandler) {.header: juce_gui_basics, importcpp: "#.showCell(@)".}
proc `==`*(this: AccessibilityTableInterface, other: AccessibilityTableInterface): bool {.error: "juce::AccessibilityTableInterface defines no operator==; compare a property instead".}

proc isDisplayingProtectedText*(this: AccessibilityTextInterface): bool {.header: juce_gui_basics, importcpp: "#.isDisplayingProtectedText()".}
proc isReadOnly*(this: AccessibilityTextInterface): bool {.header: juce_gui_basics, importcpp: "#.isReadOnly()".}
proc getTotalNumCharacters*(this: AccessibilityTextInterface): cint {.header: juce_gui_basics, importcpp: "#.getTotalNumCharacters()".}
proc getSelection*(this: AccessibilityTextInterface): Range[cint] {.header: juce_gui_basics, importcpp: "#.getSelection()".}
proc setSelection*(this: var AccessibilityTextInterface, newRange: Range[cint]) {.header: juce_gui_basics, importcpp: "#.setSelection(@)".}
proc getTextInsertionOffset*(this: AccessibilityTextInterface): cint {.header: juce_gui_basics, importcpp: "#.getTextInsertionOffset()".}
proc getText*(this: AccessibilityTextInterface, range: Range[cint]): String {.header: juce_gui_basics, importcpp: "#.getText(@)".}
proc getAllText*(this: AccessibilityTextInterface): String {.header: juce_gui_basics, importcpp: "#.getAllText()".}
proc setText*(this: var AccessibilityTextInterface, newText: String) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc getTextBounds*(this: AccessibilityTextInterface, textRange: Range[cint]): RectangleList[cint] {.header: juce_gui_basics, importcpp: "#.getTextBounds(@)".}
proc getOffsetAtPoint*(this: AccessibilityTextInterface, point: Point[cint]): cint {.header: juce_gui_basics, importcpp: "#.getOffsetAtPoint(@)".}
proc `==`*(this: AccessibilityTextInterface, other: AccessibilityTextInterface): bool {.error: "juce::AccessibilityTextInterface defines no operator==; compare a property instead".}

proc isReadOnly*(this: AccessibilityValueInterface): bool {.header: juce_gui_basics, importcpp: "#.isReadOnly()".}
proc getCurrentValue*(this: AccessibilityValueInterface): float64 {.header: juce_gui_basics, importcpp: "#.getCurrentValue()".}
proc getCurrentValueAsString*(this: AccessibilityValueInterface): String {.header: juce_gui_basics, importcpp: "#.getCurrentValueAsString()".}
proc setValue*(this: var AccessibilityValueInterface, newValue: float64) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc setValueAsString*(this: var AccessibilityValueInterface, newValue: String) {.header: juce_gui_basics, importcpp: "#.setValueAsString(@)".}
proc getRange*(this: AccessibilityValueInterface): AccessibilityValueInterfaceAccessibleValueRange {.header: juce_gui_basics, importcpp: "#.getRange()".}
proc `==`*(this: AccessibilityValueInterface, other: AccessibilityValueInterface): bool {.error: "juce::AccessibilityValueInterface defines no operator==; compare a property instead".}

proc isReadOnly*(this: AccessibilityTextValueInterface): bool {.header: juce_gui_basics, importcpp: "#.isReadOnly()".}
proc getCurrentValueAsString*(this: AccessibilityTextValueInterface): String {.header: juce_gui_basics, importcpp: "#.getCurrentValueAsString()".}
proc setValueAsString*(this: var AccessibilityTextValueInterface, newValue: String) {.header: juce_gui_basics, importcpp: "#.setValueAsString(@)".}
proc getCurrentValue*(this: AccessibilityTextValueInterface): float64 {.header: juce_gui_basics, importcpp: "#.getCurrentValue()".}
proc setValue*(this: var AccessibilityTextValueInterface, newValue: float64) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc getRange*(this: AccessibilityTextValueInterface): AccessibilityValueInterfaceAccessibleValueRange {.header: juce_gui_basics, importcpp: "#.getRange()".}
proc `==`*(this: AccessibilityTextValueInterface, other: AccessibilityTextValueInterface): bool {.error: "juce::AccessibilityTextValueInterface defines no operator==; compare a property instead".}

proc isReadOnly*(this: AccessibilityNumericValueInterface): bool {.header: juce_gui_basics, importcpp: "#.isReadOnly()".}
proc getCurrentValue*(this: AccessibilityNumericValueInterface): float64 {.header: juce_gui_basics, importcpp: "#.getCurrentValue()".}
proc setValue*(this: var AccessibilityNumericValueInterface, newValue: float64) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc getCurrentValueAsString*(this: AccessibilityNumericValueInterface): String {.header: juce_gui_basics, importcpp: "#.getCurrentValueAsString()".}
proc setValueAsString*(this: var AccessibilityNumericValueInterface, newValue: String) {.header: juce_gui_basics, importcpp: "#.setValueAsString(@)".}
proc getRange*(this: AccessibilityNumericValueInterface): AccessibilityValueInterfaceAccessibleValueRange {.header: juce_gui_basics, importcpp: "#.getRange()".}
proc `==`*(this: AccessibilityNumericValueInterface, other: AccessibilityNumericValueInterface): bool {.error: "juce::AccessibilityNumericValueInterface defines no operator==; compare a property instead".}

proc isReadOnly*(this: AccessibilityRangedNumericValueInterface): bool {.header: juce_gui_basics, importcpp: "#.isReadOnly()".}
proc getCurrentValue*(this: AccessibilityRangedNumericValueInterface): float64 {.header: juce_gui_basics, importcpp: "#.getCurrentValue()".}
proc setValue*(this: var AccessibilityRangedNumericValueInterface, newValue: float64) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc getRange*(this: AccessibilityRangedNumericValueInterface): AccessibilityValueInterfaceAccessibleValueRange {.header: juce_gui_basics, importcpp: "#.getRange()".}
proc getCurrentValueAsString*(this: AccessibilityRangedNumericValueInterface): String {.header: juce_gui_basics, importcpp: "#.getCurrentValueAsString()".}
proc setValueAsString*(this: var AccessibilityRangedNumericValueInterface, newValue: String) {.header: juce_gui_basics, importcpp: "#.setValueAsString(@)".}
proc `==`*(this: AccessibilityRangedNumericValueInterface, other: AccessibilityRangedNumericValueInterface): bool {.error: "juce::AccessibilityRangedNumericValueInterface defines no operator==; compare a property instead".}

proc makeAccessibilityActions*(): AccessibilityActions {.header: juce_gui_basics, importcpp: "juce::AccessibilityActions(@)".}
proc addAction*(this: var AccessibilityActions, `type`: AccessibilityActionType, actionCallback: CppFunctionObjectN0): var AccessibilityActions {.header: juce_gui_basics, importcpp: "#.addAction(@)".}
proc contains*(this: AccessibilityActions, `type`: AccessibilityActionType): bool {.header: juce_gui_basics, importcpp: "#.contains(@)".}
proc invoke*(this: AccessibilityActions, `type`: AccessibilityActionType): bool {.header: juce_gui_basics, importcpp: "#.invoke(@)".}
proc `==`*(this: AccessibilityActions, other: AccessibilityActions): bool {.error: "juce::AccessibilityActions defines no operator==; compare a property instead".}

proc makeAccessibleState*(): AccessibleState {.header: juce_gui_basics, importcpp: "juce::AccessibleState(@)".}
proc withCheckable*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withCheckable()".}
proc withChecked*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withChecked()".}
proc withCollapsed*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withCollapsed()".}
proc withExpandable*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withExpandable()".}
proc withExpanded*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withExpanded()".}
proc withFocusable*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withFocusable()".}
proc withFocused*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withFocused()".}
proc withIgnored*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withIgnored()".}
proc withSelectable*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withSelectable()".}
proc withMultiSelectable*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withMultiSelectable()".}
proc withSelected*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withSelected()".}
proc withAccessibleOffscreen*(this: AccessibleState): AccessibleState {.header: juce_gui_basics, importcpp: "#.withAccessibleOffscreen()".}
proc isCheckable*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isCheckable()".}
proc isChecked*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isChecked()".}
proc isCollapsed*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isCollapsed()".}
proc isExpandable*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isExpandable()".}
proc isExpanded*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isExpanded()".}
proc isFocusable*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isFocusable()".}
proc isFocused*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isFocused()".}
proc isIgnored*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isIgnored()".}
proc isMultiSelectable*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isMultiSelectable()".}
proc isSelectable*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isSelectable()".}
proc isSelected*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isSelected()".}
proc isAccessibleOffscreen*(this: AccessibleState): bool {.header: juce_gui_basics, importcpp: "#.isAccessibleOffscreen()".}
proc `==`*(this: AccessibleState, other: AccessibleState): bool {.error: "juce::AccessibleState defines no operator==; compare a property instead".}

proc makeAccessibilityHandler*(componentToWrap: var Component, accessibilityRole: AccessibilityRole, actions: AccessibilityActions, interfaces: AccessibilityHandlerInterfaces): AccessibilityHandler {.header: juce_gui_basics, importcpp: "juce::AccessibilityHandler(@)".}
proc getComponent*(this: AccessibilityHandler): Component {.header: juce_gui_basics, importcpp: "#.getComponent()".}
proc getComponent*(this: var AccessibilityHandler): var Component {.header: juce_gui_basics, importcpp: "#.getComponent()".}
proc getRole*(this: AccessibilityHandler): AccessibilityRole {.header: juce_gui_basics, importcpp: "#.getRole()".}
proc getTitle*(this: AccessibilityHandler): String {.header: juce_gui_basics, importcpp: "#.getTitle()".}
proc getDescription*(this: AccessibilityHandler): String {.header: juce_gui_basics, importcpp: "#.getDescription()".}
proc getHelp*(this: AccessibilityHandler): String {.header: juce_gui_basics, importcpp: "#.getHelp()".}
proc getCurrentState*(this: AccessibilityHandler): AccessibleState {.header: juce_gui_basics, importcpp: "#.getCurrentState()".}
proc isIgnored*(this: AccessibilityHandler): bool {.header: juce_gui_basics, importcpp: "#.isIgnored()".}
proc isVisibleWithinParent*(this: AccessibilityHandler): bool {.header: juce_gui_basics, importcpp: "#.isVisibleWithinParent()".}
proc getActions*(this: AccessibilityHandler): AccessibilityActions {.header: juce_gui_basics, importcpp: "#.getActions()".}
proc getValueInterface*(this: AccessibilityHandler): ptr AccessibilityValueInterface {.header: juce_gui_basics, importcpp: "#.getValueInterface()".}
proc getTableInterface*(this: AccessibilityHandler): ptr AccessibilityTableInterface {.header: juce_gui_basics, importcpp: "#.getTableInterface()".}
proc getCellInterface*(this: AccessibilityHandler): ptr AccessibilityCellInterface {.header: juce_gui_basics, importcpp: "#.getCellInterface()".}
proc getTextInterface*(this: AccessibilityHandler): ptr AccessibilityTextInterface {.header: juce_gui_basics, importcpp: "#.getTextInterface()".}
proc getParent*(this: AccessibilityHandler): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getParent()".}
proc getChildren*(this: AccessibilityHandler): CppVector[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.getChildren()".}
proc isParentOf*(this: AccessibilityHandler, possibleChild: ptr AccessibilityHandler): bool {.header: juce_gui_basics, importcpp: "#.isParentOf(@)".}
proc getChildAt*(this: var AccessibilityHandler, screenPoint: Point[cint]): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getChildAt(@)".}
proc getChildFocus*(this: var AccessibilityHandler): ptr AccessibilityHandler {.header: juce_gui_basics, importcpp: "#.getChildFocus()".}
proc hasFocus*(this: AccessibilityHandler, trueIfChildFocused: bool): bool {.header: juce_gui_basics, importcpp: "#.hasFocus(@)".}
proc grabFocus*(this: var AccessibilityHandler) {.header: juce_gui_basics, importcpp: "#.grabFocus()".}
proc giveAwayFocus*(this: AccessibilityHandler) {.header: juce_gui_basics, importcpp: "#.giveAwayFocus()".}
proc notifyAccessibilityEvent*(this: AccessibilityHandler, event: AccessibilityEvent) {.header: juce_gui_basics, importcpp: "#.notifyAccessibilityEvent(@)".}
proc getNativeImplementation*(this: AccessibilityHandler): ptr AccessibilityNativeHandle {.header: juce_gui_basics, importcpp: "#.getNativeImplementation()".}
proc getTypeIndex*(this: AccessibilityHandler): CppTypeIndex {.header: juce_gui_basics, importcpp: "#.getTypeIndex()".}
proc `==`*(this: AccessibilityHandler, other: AccessibilityHandler): bool {.error: "juce::AccessibilityHandler defines no operator==; compare a property instead".}

proc createCopy*(this: Drawable): UniquePtr[Drawable] {.header: juce_gui_basics, importcpp: "#.createCopy()".}
proc getOutlineAsPath*(this: Drawable): Path {.header: juce_gui_basics, importcpp: "#.getOutlineAsPath()".}
proc draw*(this: Drawable, g: var Graphics, opacity: cfloat, transform: AffineTransform) {.header: juce_gui_basics, importcpp: "#.draw(@)".}
proc drawAt*(this: Drawable, g: var Graphics, x: cfloat, y: cfloat, opacity: cfloat) {.header: juce_gui_basics, importcpp: "#.drawAt(@)".}
proc drawWithin*(this: Drawable, g: var Graphics, destArea: Rectangle[cfloat], placement: RectanglePlacement, opacity: cfloat) {.header: juce_gui_basics, importcpp: "#.drawWithin(@)".}
proc setOriginWithOriginalSize*(this: var Drawable, originWithinParent: Point[cfloat]) {.header: juce_gui_basics, importcpp: "#.setOriginWithOriginalSize(@)".}
proc setTransformToFit*(this: var Drawable, areaInParent: Rectangle[cfloat], placement: RectanglePlacement) {.header: juce_gui_basics, importcpp: "#.setTransformToFit(@)".}
proc getParent*(this: Drawable): ptr DrawableComposite {.header: juce_gui_basics, importcpp: "#.getParent()".}
proc setClipPath*(this: var Drawable, drawableClipPath: UniquePtr[Drawable]) {.header: juce_gui_basics, importcpp: "#.setClipPath(@)".}
proc getDrawableBounds*(this: Drawable): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getDrawableBounds()".}
proc replaceColour*(this: var Drawable, originalColour: Colour, replacementColour: Colour): bool {.header: juce_gui_basics, importcpp: "#.replaceColour(@)".}
proc setDrawableTransform*(this: var Drawable, transform: AffineTransform) {.header: juce_gui_basics, importcpp: "#.setDrawableTransform(@)".}
proc `==`*(this: Drawable, other: Drawable): bool {.error: "juce::Drawable defines no operator==; compare a property instead".}

proc makeViewport*(componentName: String): Viewport {.header: juce_gui_basics, importcpp: "juce::Viewport(@)".}
proc setViewedComponent*(this: var Viewport, newViewedComponent: ptr Component, deleteComponentWhenNoLongerNeeded: bool = true) {.header: juce_gui_basics, importcpp: "#.setViewedComponent(@)".}
proc getViewedComponent*(this: Viewport): ptr Component {.header: juce_gui_basics, importcpp: "#.getViewedComponent()".}
proc setViewPosition*(this: var Viewport, xPixelsOffset: cint, yPixelsOffset: cint) {.header: juce_gui_basics, importcpp: "#.setViewPosition(@)".}
proc setViewPosition*(this: var Viewport, newPosition: Point[cint]) {.header: juce_gui_basics, importcpp: "#.setViewPosition(@)".}
proc setViewPositionProportionately*(this: var Viewport, proportionX: float64, proportionY: float64) {.header: juce_gui_basics, importcpp: "#.setViewPositionProportionately(@)".}
proc autoScroll*(this: var Viewport, mouseX: cint, mouseY: cint, distanceFromEdge: cint, maximumSpeed: cint): bool {.header: juce_gui_basics, importcpp: "#.autoScroll(@)".}
proc getViewPosition*(this: Viewport): Point[cint] {.header: juce_gui_basics, importcpp: "#.getViewPosition()".}
proc getViewArea*(this: Viewport): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getViewArea()".}
proc getViewPositionX*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getViewPositionX()".}
proc getViewPositionY*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getViewPositionY()".}
proc getViewWidth*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getViewWidth()".}
proc getViewHeight*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getViewHeight()".}
proc getMaximumVisibleWidth*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getMaximumVisibleWidth()".}
proc getMaximumVisibleHeight*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getMaximumVisibleHeight()".}
proc visibleAreaChanged*(this: var Viewport, newVisibleArea: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.visibleAreaChanged(@)".}
proc viewedComponentChanged*(this: var Viewport, newComponent: ptr Component) {.header: juce_gui_basics, importcpp: "#.viewedComponentChanged(@)".}
proc setScrollBarsShown*(this: var Viewport, showVerticalScrollbarIfNeeded: bool, showHorizontalScrollbarIfNeeded: bool, allowVerticalScrollingWithoutScrollbar: bool = false, allowHorizontalScrollingWithoutScrollbar: bool = false) {.header: juce_gui_basics, importcpp: "#.setScrollBarsShown(@)".}
proc setScrollBarPosition*(this: var Viewport, verticalScrollbarOnRight: bool, horizontalScrollbarAtBottom: bool) {.header: juce_gui_basics, importcpp: "#.setScrollBarPosition(@)".}
proc isVerticalScrollbarOnTheRight*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.isVerticalScrollbarOnTheRight()".}
proc isHorizontalScrollbarAtBottom*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.isHorizontalScrollbarAtBottom()".}
proc isVerticalScrollBarShown*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.isVerticalScrollBarShown()".}
proc isHorizontalScrollBarShown*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.isHorizontalScrollBarShown()".}
proc setScrollBarThickness*(this: var Viewport, thickness: cint) {.header: juce_gui_basics, importcpp: "#.setScrollBarThickness(@)".}
proc getScrollBarThickness*(this: Viewport): cint {.header: juce_gui_basics, importcpp: "#.getScrollBarThickness()".}
proc setSingleStepSizes*(this: var Viewport, stepX: cint, stepY: cint) {.header: juce_gui_basics, importcpp: "#.setSingleStepSizes(@)".}
proc getVerticalScrollBar*(this: var Viewport): var ScrollBar {.header: juce_gui_basics, importcpp: "#.getVerticalScrollBar()".}
proc getHorizontalScrollBar*(this: var Viewport): var ScrollBar {.header: juce_gui_basics, importcpp: "#.getHorizontalScrollBar()".}
proc recreateScrollbars*(this: var Viewport) {.header: juce_gui_basics, importcpp: "#.recreateScrollbars()".}
proc canScrollVertically*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.canScrollVertically()".}
proc canScrollHorizontally*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.canScrollHorizontally()".}
proc setScrollOnDragEnabled*(this: var Viewport, shouldScrollOnDrag: bool) {.header: juce_gui_basics, importcpp: "#.setScrollOnDragEnabled(@)".}
proc isScrollOnDragEnabled*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.isScrollOnDragEnabled()".}
proc setScrollOnDragMode*(this: var Viewport, scrollOnDragMode: ViewportScrollOnDragMode) {.header: juce_gui_basics, importcpp: "#.setScrollOnDragMode(@)".}
proc getScrollOnDragMode*(this: Viewport): ViewportScrollOnDragMode {.header: juce_gui_basics, importcpp: "#.getScrollOnDragMode()".}
proc isCurrentlyScrollingOnDrag*(this: Viewport): bool {.header: juce_gui_basics, importcpp: "#.isCurrentlyScrollingOnDrag()".}
proc resized*(this: var Viewport) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc scrollBarMoved*(this: var Viewport, arg1: ptr ScrollBar, newRangeStart: float64) {.header: juce_gui_basics, importcpp: "#.scrollBarMoved(@)".}
proc mouseWheelMove*(this: var Viewport, arg1: MouseEvent, arg2: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc mouseDown*(this: var Viewport, e: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc keyPressed*(this: var Viewport, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc componentMovedOrResized*(this: var Viewport, arg1: var Component, wasMoved: bool, wasResized: bool) {.header: juce_gui_basics, importcpp: "#.componentMovedOrResized(@)".}
proc lookAndFeelChanged*(this: var Viewport) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc useMouseWheelMoveIfNeeded*(this: var Viewport, arg1: MouseEvent, arg2: MouseWheelDetails): bool {.header: juce_gui_basics, importcpp: "#.useMouseWheelMoveIfNeeded(@)".}
proc `==`*(this: Viewport, other: Viewport): bool {.error: "juce::Viewport defines no operator==; compare a property instead".}

proc makePopupMenu*(): PopupMenu {.header: juce_gui_basics, importcpp: "juce::PopupMenu(@)".}
proc `PopupMenu=`*(this: var PopupMenu, arg1: PopupMenu): var PopupMenu {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc clear*(this: var PopupMenu) {.header: juce_gui_basics, importcpp: "#.clear()".}
proc addItem*(this: var PopupMenu, newItem: PopupMenuItem) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addItem*(this: var PopupMenu, itemText: String, action: CppFunctionObjectN0) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addItem*(this: var PopupMenu, itemText: String, isEnabled: bool, isTicked: bool, action: CppFunctionObjectN0) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addItem*(this: var PopupMenu, itemResultID: cint, itemText: String, isEnabled: bool = true, isTicked: bool = false) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addItem*(this: var PopupMenu, itemResultID: cint, itemText: String, isEnabled: bool, isTicked: bool, iconToUse: Image) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addItem*(this: var PopupMenu, itemResultID: cint, itemText: String, isEnabled: bool, isTicked: bool, iconToUse: UniquePtr[Drawable]) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addCommandItem*(this: var PopupMenu, commandManager: ptr ApplicationCommandManager, commandID: cint, displayName: String, iconToUse: UniquePtr[Drawable]) {.header: juce_gui_basics, importcpp: "#.addCommandItem(@)".}
proc addColouredItem*(this: var PopupMenu, itemResultID: cint, itemText: String, itemTextColour: Colour, isEnabled: bool = true, isTicked: bool = false, iconToUse: Image) {.header: juce_gui_basics, importcpp: "#.addColouredItem(@)".}
proc addColouredItem*(this: var PopupMenu, itemResultID: cint, itemText: String, itemTextColour: Colour, isEnabled: bool, isTicked: bool, iconToUse: UniquePtr[Drawable]) {.header: juce_gui_basics, importcpp: "#.addColouredItem(@)".}
proc addCustomItem*(this: var PopupMenu, itemResultID: cint, customComponent: UniquePtr[PopupMenuCustomComponent], optionalSubMenu: UniquePtr[PopupMenu], itemTitle: String) {.header: juce_gui_basics, importcpp: "#.addCustomItem(@)".}
proc addCustomItem*(this: var PopupMenu, itemResultID: cint, customComponent: var Component, idealWidth: cint, idealHeight: cint, triggerMenuItemAutomaticallyWhenClicked: bool, optionalSubMenu: UniquePtr[PopupMenu], itemTitle: String) {.header: juce_gui_basics, importcpp: "#.addCustomItem(@)".}
proc addSubMenu*(this: var PopupMenu, subMenuName: String, subMenu: PopupMenu, isEnabled: bool = true) {.header: juce_gui_basics, importcpp: "#.addSubMenu(@)".}
proc addSubMenu*(this: var PopupMenu, subMenuName: String, subMenu: PopupMenu, isEnabled: bool, iconToUse: Image, isTicked: bool = false, itemResultID: cint = 0) {.header: juce_gui_basics, importcpp: "#.addSubMenu(@)".}
proc addSubMenu*(this: var PopupMenu, subMenuName: String, subMenu: PopupMenu, isEnabled: bool, iconToUse: UniquePtr[Drawable], isTicked: bool = false, itemResultID: cint = 0) {.header: juce_gui_basics, importcpp: "#.addSubMenu(@)".}
proc addSeparator*(this: var PopupMenu) {.header: juce_gui_basics, importcpp: "#.addSeparator()".}
proc addSectionHeader*(this: var PopupMenu, title: String) {.header: juce_gui_basics, importcpp: "#.addSectionHeader(@)".}
proc addColumnBreak*(this: var PopupMenu) {.header: juce_gui_basics, importcpp: "#.addColumnBreak()".}
proc getNumItems*(this: PopupMenu): cint {.header: juce_gui_basics, importcpp: "#.getNumItems()".}
proc containsCommandItem*(this: PopupMenu, commandID: cint): bool {.header: juce_gui_basics, importcpp: "#.containsCommandItem(@)".}
proc containsAnyActiveItems*(this: PopupMenu): bool {.header: juce_gui_basics, importcpp: "#.containsAnyActiveItems()".}
proc showMenuAsync*(this: var PopupMenu, options: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.showMenuAsync(@)".}
proc showMenuAsync*(this: var PopupMenu, options: PopupMenuOptions, callback: ptr ModalComponentManagerCallback) {.header: juce_gui_basics, importcpp: "#.showMenuAsync(@)".}
proc showMenuAsync*(this: var PopupMenu, options: PopupMenuOptions, callback: CppFunctionObjectN1[cint]) {.header: juce_gui_basics, importcpp: "#.showMenuAsync(@)".}
proc setLookAndFeel*(this: var PopupMenu, newLookAndFeel: ptr LookAndFeel) {.header: juce_gui_basics, importcpp: "#.setLookAndFeel(@)".}
proc drawPopupMenuItem*(this: var PopupMenu, arg1: var Graphics, arg2: cint, arg3: cint, arg4: bool, arg5: bool, arg6: bool, arg7: bool, arg8: bool, arg9: String, arg10: String, arg11: ptr Image, arg12: ptr Colour): cint {.header: juce_gui_basics, importcpp: "#.drawPopupMenuItem(@)".}
proc `==`*(this: PopupMenu, other: PopupMenu): bool {.error: "juce::PopupMenu defines no operator==; compare a property instead".}

proc makeMenuBarModel*(): MenuBarModel {.header: juce_gui_basics, importcpp: "juce::MenuBarModel(@)".}
proc menuItemsChanged*(this: var MenuBarModel) {.header: juce_gui_basics, importcpp: "#.menuItemsChanged()".}
proc setApplicationCommandManagerToWatch*(this: var MenuBarModel, manager: ptr ApplicationCommandManager) {.header: juce_gui_basics, importcpp: "#.setApplicationCommandManagerToWatch(@)".}
proc addListener*(this: var MenuBarModel, listenerToAdd: ptr MenuBarModelListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var MenuBarModel, listenerToRemove: ptr MenuBarModelListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc getMenuBarNames*(this: var MenuBarModel): StringArray {.header: juce_gui_basics, importcpp: "#.getMenuBarNames()".}
proc getMenuForIndex*(this: var MenuBarModel, topLevelMenuIndex: cint, menuName: String): PopupMenu {.header: juce_gui_basics, importcpp: "#.getMenuForIndex(@)".}
proc menuItemSelected*(this: var MenuBarModel, menuItemID: cint, topLevelMenuIndex: cint) {.header: juce_gui_basics, importcpp: "#.menuItemSelected(@)".}
proc menuBarActivated*(this: var MenuBarModel, isActive: bool) {.header: juce_gui_basics, importcpp: "#.menuBarActivated(@)".}
proc applicationCommandInvoked*(this: var MenuBarModel, arg1: ApplicationCommandTargetInvocationInfo) {.header: juce_gui_basics, importcpp: "#.applicationCommandInvoked(@)".}
proc applicationCommandListChanged*(this: var MenuBarModel) {.header: juce_gui_basics, importcpp: "#.applicationCommandListChanged()".}
proc handleAsyncUpdate*(this: var MenuBarModel) {.header: juce_gui_basics, importcpp: "#.handleAsyncUpdate()".}
proc handleMenuBarActivate*(this: var MenuBarModel, isActive: bool) {.header: juce_gui_basics, importcpp: "#.handleMenuBarActivate(@)".}
proc `==`*(this: MenuBarModel, other: MenuBarModel): bool {.error: "juce::MenuBarModel defines no operator==; compare a property instead".}

proc makeMenuBarComponent*(model: ptr MenuBarModel): MenuBarComponent {.header: juce_gui_basics, importcpp: "juce::MenuBarComponent(@)".}
proc setModel*(this: var MenuBarComponent, newModel: ptr MenuBarModel) {.header: juce_gui_basics, importcpp: "#.setModel(@)".}
proc getModel*(this: MenuBarComponent): ptr MenuBarModel {.header: juce_gui_basics, importcpp: "#.getModel()".}
proc showMenu*(this: var MenuBarComponent, menuIndex: cint) {.header: juce_gui_basics, importcpp: "#.showMenu(@)".}
proc paint*(this: var MenuBarComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc mouseEnter*(this: var MenuBarComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseEnter(@)".}
proc mouseExit*(this: var MenuBarComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseExit(@)".}
proc mouseDown*(this: var MenuBarComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var MenuBarComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var MenuBarComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc mouseMove*(this: var MenuBarComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseMove(@)".}
proc handleCommandMessage*(this: var MenuBarComponent, commandId: cint) {.header: juce_gui_basics, importcpp: "#.handleCommandMessage(@)".}
proc keyPressed*(this: var MenuBarComponent, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc menuBarItemsChanged*(this: var MenuBarComponent, arg1: ptr MenuBarModel) {.header: juce_gui_basics, importcpp: "#.menuBarItemsChanged(@)".}
proc menuCommandInvoked*(this: var MenuBarComponent, arg1: ptr MenuBarModel, arg2: ApplicationCommandTargetInvocationInfo) {.header: juce_gui_basics, importcpp: "#.menuCommandInvoked(@)".}
proc createAccessibilityHandler*(this: var MenuBarComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: MenuBarComponent, other: MenuBarComponent): bool {.error: "juce::MenuBarComponent defines no operator==; compare a property instead".}

proc makeRelativeCoordinate*(): RelativeCoordinate {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate(@)".}
proc makeRelativeCoordinate*(expression: Expression): RelativeCoordinate {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate(@)".}
proc makeRelativeCoordinate*(absoluteDistanceFromOrigin: float64): RelativeCoordinate {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate(@)".}
proc makeRelativeCoordinate*(stringVersion: String): RelativeCoordinate {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinate(@)".}
proc `RelativeCoordinate=`*(this: var RelativeCoordinate, arg1: RelativeCoordinate): var RelativeCoordinate {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc `==`*(this: RelativeCoordinate, arg1: RelativeCoordinate): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RelativeCoordinate, arg1: RelativeCoordinate): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc resolve*(this: RelativeCoordinate, evaluationScope: ptr ExpressionScope): float64 {.header: juce_gui_basics, importcpp: "#.resolve(@)".}
proc references*(this: RelativeCoordinate, coordName: String, evaluationScope: ptr ExpressionScope): bool {.header: juce_gui_basics, importcpp: "#.references(@)".}
proc isRecursive*(this: RelativeCoordinate, evaluationScope: ptr ExpressionScope): bool {.header: juce_gui_basics, importcpp: "#.isRecursive(@)".}
proc isDynamic*(this: RelativeCoordinate): bool {.header: juce_gui_basics, importcpp: "#.isDynamic()".}
proc moveToAbsolute*(this: var RelativeCoordinate, absoluteTargetPosition: float64, evaluationScope: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.moveToAbsolute(@)".}
proc getExpression*(this: RelativeCoordinate): Expression {.header: juce_gui_basics, importcpp: "#.getExpression()".}
proc toString*(this: RelativeCoordinate): String {.header: juce_gui_basics, importcpp: "#.toString()".}

proc makeMarkerList*(): MarkerList {.header: juce_gui_basics, importcpp: "juce::MarkerList(@)".}
proc `MarkerList=`*(this: var MarkerList, arg1: MarkerList): var MarkerList {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc getNumMarkers*(this: MarkerList): cint {.header: juce_gui_basics, importcpp: "#.getNumMarkers()".}
proc getMarker*(this: MarkerList, index: cint): ptr MarkerListMarker {.header: juce_gui_basics, importcpp: "#.getMarker(@)".}
proc getMarker*(this: MarkerList, name: String): ptr MarkerListMarker {.header: juce_gui_basics, importcpp: "#.getMarker(@)".}
proc getMarkerPosition*(this: MarkerList, marker: MarkerListMarker, parentComponent: ptr Component): float64 {.header: juce_gui_basics, importcpp: "#.getMarkerPosition(@)".}
proc setMarker*(this: var MarkerList, name: String, position: RelativeCoordinate) {.header: juce_gui_basics, importcpp: "#.setMarker(@)".}
proc removeMarker*(this: var MarkerList, index: cint) {.header: juce_gui_basics, importcpp: "#.removeMarker(@)".}
proc removeMarker*(this: var MarkerList, name: String) {.header: juce_gui_basics, importcpp: "#.removeMarker(@)".}
proc `==`*(this: MarkerList, arg1: MarkerList): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: MarkerList, arg1: MarkerList): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc addListener*(this: var MarkerList, listener: ptr MarkerListListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var MarkerList, listener: ptr MarkerListListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc markersHaveChanged*(this: var MarkerList) {.header: juce_gui_basics, importcpp: "#.markersHaveChanged()".}

proc makeRelativePoint*(): RelativePoint {.header: juce_gui_basics, importcpp: "juce::RelativePoint(@)".}
proc makeRelativePoint*(absolutePoint: Point[cfloat]): RelativePoint {.header: juce_gui_basics, importcpp: "juce::RelativePoint(@)".}
proc makeRelativePoint*(absoluteX: cfloat, absoluteY: cfloat): RelativePoint {.header: juce_gui_basics, importcpp: "juce::RelativePoint(@)".}
proc makeRelativePoint*(x: RelativeCoordinate, y: RelativeCoordinate): RelativePoint {.header: juce_gui_basics, importcpp: "juce::RelativePoint(@)".}
proc makeRelativePoint*(stringVersion: String): RelativePoint {.header: juce_gui_basics, importcpp: "juce::RelativePoint(@)".}
proc `==`*(this: RelativePoint, arg1: RelativePoint): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RelativePoint, arg1: RelativePoint): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc resolve*(this: RelativePoint, evaluationContext: ptr ExpressionScope): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.resolve(@)".}
proc moveToAbsolute*(this: var RelativePoint, newPos: Point[cfloat], evaluationContext: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.moveToAbsolute(@)".}
proc toString*(this: RelativePoint): String {.header: juce_gui_basics, importcpp: "#.toString()".}
proc isDynamic*(this: RelativePoint): bool {.header: juce_gui_basics, importcpp: "#.isDynamic()".}

proc makeRelativeRectangle*(): RelativeRectangle {.header: juce_gui_basics, importcpp: "juce::RelativeRectangle(@)".}
proc makeRelativeRectangle*(rect: Rectangle[cfloat]): RelativeRectangle {.header: juce_gui_basics, importcpp: "juce::RelativeRectangle(@)".}
proc makeRelativeRectangle*(left: RelativeCoordinate, right: RelativeCoordinate, top: RelativeCoordinate, bottom: RelativeCoordinate): RelativeRectangle {.header: juce_gui_basics, importcpp: "juce::RelativeRectangle(@)".}
proc makeRelativeRectangle*(stringVersion: String): RelativeRectangle {.header: juce_gui_basics, importcpp: "juce::RelativeRectangle(@)".}
proc `==`*(this: RelativeRectangle, arg1: RelativeRectangle): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RelativeRectangle, arg1: RelativeRectangle): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc resolve*(this: RelativeRectangle, scope: ptr ExpressionScope): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.resolve(@)".}
proc moveToAbsolute*(this: var RelativeRectangle, newPos: Rectangle[cfloat], scope: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.moveToAbsolute(@)".}
proc isDynamic*(this: RelativeRectangle): bool {.header: juce_gui_basics, importcpp: "#.isDynamic()".}
proc toString*(this: RelativeRectangle): String {.header: juce_gui_basics, importcpp: "#.toString()".}
proc renameSymbol*(this: var RelativeRectangle, oldSymbol: ExpressionSymbol, newName: String, scope: ExpressionScope) {.header: juce_gui_basics, importcpp: "#.renameSymbol(@)".}
proc applyToComponent*(this: RelativeRectangle, component: var Component) {.header: juce_gui_basics, importcpp: "#.applyToComponent(@)".}

proc makeRelativeCoordinatePositionerBase*(arg1: var Component): RelativeCoordinatePositionerBase {.header: juce_gui_basics, importcpp: "juce::RelativeCoordinatePositionerBase(@)".}
proc componentMovedOrResized*(this: var RelativeCoordinatePositionerBase, arg1: var Component, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.componentMovedOrResized(@)".}
proc componentParentHierarchyChanged*(this: var RelativeCoordinatePositionerBase, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentParentHierarchyChanged(@)".}
proc componentChildrenChanged*(this: var RelativeCoordinatePositionerBase, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentChildrenChanged(@)".}
proc componentBeingDeleted*(this: var RelativeCoordinatePositionerBase, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentBeingDeleted(@)".}
proc markersChanged*(this: var RelativeCoordinatePositionerBase, arg1: ptr MarkerList) {.header: juce_gui_basics, importcpp: "#.markersChanged(@)".}
proc markerListBeingDeleted*(this: var RelativeCoordinatePositionerBase, arg1: ptr MarkerList) {.header: juce_gui_basics, importcpp: "#.markerListBeingDeleted(@)".}
proc apply*(this: var RelativeCoordinatePositionerBase) {.header: juce_gui_basics, importcpp: "#.apply()".}
proc addCoordinate*(this: var RelativeCoordinatePositionerBase, arg1: RelativeCoordinate): bool {.header: juce_gui_basics, importcpp: "#.addCoordinate(@)".}
proc addPoint*(this: var RelativeCoordinatePositionerBase, arg1: RelativePoint): bool {.header: juce_gui_basics, importcpp: "#.addPoint(@)".}
proc `==`*(this: RelativeCoordinatePositionerBase, other: RelativeCoordinatePositionerBase): bool {.error: "juce::RelativeCoordinatePositionerBase defines no operator==; compare a property instead".}

proc makeRelativeParallelogram*(): RelativeParallelogram {.header: juce_gui_basics, importcpp: "juce::RelativeParallelogram(@)".}
proc makeRelativeParallelogram*(simpleRectangle: Rectangle[cfloat]): RelativeParallelogram {.header: juce_gui_basics, importcpp: "juce::RelativeParallelogram(@)".}
proc makeRelativeParallelogram*(topLeft: RelativePoint, topRight: RelativePoint, bottomLeft: RelativePoint): RelativeParallelogram {.header: juce_gui_basics, importcpp: "juce::RelativeParallelogram(@)".}
proc makeRelativeParallelogram*(topLeft: String, topRight: String, bottomLeft: String): RelativeParallelogram {.header: juce_gui_basics, importcpp: "juce::RelativeParallelogram(@)".}
proc resolveThreePoints*(this: RelativeParallelogram, points: ptr Point[cfloat], scope: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.resolveThreePoints(@)".}
proc resolveFourCorners*(this: RelativeParallelogram, points: ptr Point[cfloat], scope: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.resolveFourCorners(@)".}
proc getBounds*(this: RelativeParallelogram, scope: ptr ExpressionScope): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getBounds(@)".}
proc getPath*(this: RelativeParallelogram, path: var Path, scope: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.getPath(@)".}
proc resetToPerpendicular*(this: var RelativeParallelogram, scope: ptr ExpressionScope): AffineTransform {.header: juce_gui_basics, importcpp: "#.resetToPerpendicular(@)".}
proc isDynamic*(this: RelativeParallelogram): bool {.header: juce_gui_basics, importcpp: "#.isDynamic()".}
proc `==`*(this: RelativeParallelogram, arg1: RelativeParallelogram): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RelativeParallelogram, arg1: RelativeParallelogram): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==

proc makeRelativePointPath*(): RelativePointPath {.header: juce_gui_basics, importcpp: "juce::RelativePointPath(@)".}
proc makeRelativePointPath*(path: Path): RelativePointPath {.header: juce_gui_basics, importcpp: "juce::RelativePointPath(@)".}
proc `==`*(this: RelativePointPath, arg1: RelativePointPath): bool {.header: juce_gui_basics, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RelativePointPath, arg1: RelativePointPath): bool {.header: juce_gui_basics, importcpp: "#.operator!=(@)".}  # Nim derives != from ==
proc createPath*(this: RelativePointPath, path: var Path, scope: ptr ExpressionScope) {.header: juce_gui_basics, importcpp: "#.createPath(@)".}
proc containsAnyDynamicPoints*(this: RelativePointPath): bool {.header: juce_gui_basics, importcpp: "#.containsAnyDynamicPoints()".}
proc swapWith*(this: var RelativePointPath, arg1: var RelativePointPath) {.header: juce_gui_basics, importcpp: "#.swapWith(@)".}
proc addElement*(this: var RelativePointPath, newElement: ptr RelativePointPathElementBase) {.header: juce_gui_basics, importcpp: "#.addElement(@)".}

proc setFill*(this: var DrawableShape, newFill: FillType) {.header: juce_gui_basics, importcpp: "#.setFill(@)".}
proc getFill*(this: DrawableShape): FillType {.header: juce_gui_basics, importcpp: "#.getFill()".}
proc setStrokeFill*(this: var DrawableShape, newStrokeFill: FillType) {.header: juce_gui_basics, importcpp: "#.setStrokeFill(@)".}
proc getStrokeFill*(this: DrawableShape): FillType {.header: juce_gui_basics, importcpp: "#.getStrokeFill()".}
proc setStrokeType*(this: var DrawableShape, newStrokeType: PathStrokeType) {.header: juce_gui_basics, importcpp: "#.setStrokeType(@)".}
proc setStrokeThickness*(this: var DrawableShape, newThickness: cfloat) {.header: juce_gui_basics, importcpp: "#.setStrokeThickness(@)".}
proc getStrokeType*(this: DrawableShape): PathStrokeType {.header: juce_gui_basics, importcpp: "#.getStrokeType()".}
proc setDashLengths*(this: var DrawableShape, newDashLengths: Array[cfloat]) {.header: juce_gui_basics, importcpp: "#.setDashLengths(@)".}
proc getDashLengths*(this: DrawableShape): Array[cfloat] {.header: juce_gui_basics, importcpp: "#.getDashLengths()".}
proc getDrawableBounds*(this: DrawableShape): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getDrawableBounds()".}
proc paint*(this: var DrawableShape, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc hitTest*(this: var DrawableShape, x: cint, y: cint): bool {.header: juce_gui_basics, importcpp: "#.hitTest(@)".}
proc replaceColour*(this: var DrawableShape, originalColour: Colour, replacementColour: Colour): bool {.header: juce_gui_basics, importcpp: "#.replaceColour(@)".}
proc getOutlineAsPath*(this: DrawableShape): Path {.header: juce_gui_basics, importcpp: "#.getOutlineAsPath()".}
proc `==`*(this: DrawableShape, other: DrawableShape): bool {.error: "juce::DrawableShape defines no operator==; compare a property instead".}

proc makeDrawableComposite*(): DrawableComposite {.header: juce_gui_basics, importcpp: "juce::DrawableComposite(@)".}
proc setBoundingBox*(this: var DrawableComposite, newBoundingBox: Parallelogram[cfloat]) {.header: juce_gui_basics, importcpp: "#.setBoundingBox(@)".}
proc setBoundingBox*(this: var DrawableComposite, newBoundingBox: Rectangle[cfloat]) {.header: juce_gui_basics, importcpp: "#.setBoundingBox(@)".}
proc getBoundingBox*(this: DrawableComposite): Parallelogram[cfloat] {.header: juce_gui_basics, importcpp: "#.getBoundingBox()".}
proc resetBoundingBoxToContentArea*(this: var DrawableComposite) {.header: juce_gui_basics, importcpp: "#.resetBoundingBoxToContentArea()".}
proc getContentArea*(this: DrawableComposite): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getContentArea()".}
proc setContentArea*(this: var DrawableComposite, newArea: Rectangle[cfloat]) {.header: juce_gui_basics, importcpp: "#.setContentArea(@)".}
proc resetContentAreaAndBoundingBoxToFitChildren*(this: var DrawableComposite) {.header: juce_gui_basics, importcpp: "#.resetContentAreaAndBoundingBoxToFitChildren()".}
proc createCopy*(this: DrawableComposite): UniquePtr[Drawable] {.header: juce_gui_basics, importcpp: "#.createCopy()".}
proc getDrawableBounds*(this: DrawableComposite): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getDrawableBounds()".}
proc childBoundsChanged*(this: var DrawableComposite, arg1: ptr Component) {.header: juce_gui_basics, importcpp: "#.childBoundsChanged(@)".}
proc childrenChanged*(this: var DrawableComposite) {.header: juce_gui_basics, importcpp: "#.childrenChanged()".}
proc parentHierarchyChanged*(this: var DrawableComposite) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc getOutlineAsPath*(this: DrawableComposite): Path {.header: juce_gui_basics, importcpp: "#.getOutlineAsPath()".}
proc `==`*(this: DrawableComposite, other: DrawableComposite): bool {.error: "juce::DrawableComposite defines no operator==; compare a property instead".}

proc makeDrawableImage*(): DrawableImage {.header: juce_gui_basics, importcpp: "juce::DrawableImage(@)".}
proc makeDrawableImage*(imageToUse: Image): DrawableImage {.header: juce_gui_basics, importcpp: "juce::DrawableImage(@)".}
proc setImage*(this: var DrawableImage, imageToUse: Image) {.header: juce_gui_basics, importcpp: "#.setImage(@)".}
proc getImage*(this: DrawableImage): Image {.header: juce_gui_basics, importcpp: "#.getImage()".}
proc setOpacity*(this: var DrawableImage, newOpacity: cfloat) {.header: juce_gui_basics, importcpp: "#.setOpacity(@)".}
proc getOpacity*(this: DrawableImage): cfloat {.header: juce_gui_basics, importcpp: "#.getOpacity()".}
proc setOverlayColour*(this: var DrawableImage, newOverlayColour: Colour) {.header: juce_gui_basics, importcpp: "#.setOverlayColour(@)".}
proc getOverlayColour*(this: DrawableImage): Colour {.header: juce_gui_basics, importcpp: "#.getOverlayColour()".}
proc setBoundingBox*(this: var DrawableImage, newBounds: Parallelogram[cfloat]) {.header: juce_gui_basics, importcpp: "#.setBoundingBox(@)".}
proc setBoundingBox*(this: var DrawableImage, newBounds: Rectangle[cfloat]) {.header: juce_gui_basics, importcpp: "#.setBoundingBox(@)".}
proc getBoundingBox*(this: DrawableImage): Parallelogram[cfloat] {.header: juce_gui_basics, importcpp: "#.getBoundingBox()".}
proc setImageResamplingQuality*(this: var DrawableImage, newQuality: GraphicsResamplingQuality) {.header: juce_gui_basics, importcpp: "#.setImageResamplingQuality(@)".}
proc paint*(this: var DrawableImage, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc hitTest*(this: var DrawableImage, x: cint, y: cint): bool {.header: juce_gui_basics, importcpp: "#.hitTest(@)".}
proc createCopy*(this: DrawableImage): UniquePtr[Drawable] {.header: juce_gui_basics, importcpp: "#.createCopy()".}
proc getDrawableBounds*(this: DrawableImage): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getDrawableBounds()".}
proc getOutlineAsPath*(this: DrawableImage): Path {.header: juce_gui_basics, importcpp: "#.getOutlineAsPath()".}
proc createAccessibilityHandler*(this: var DrawableImage): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: DrawableImage, other: DrawableImage): bool {.error: "juce::DrawableImage defines no operator==; compare a property instead".}

proc makeDrawablePath*(): DrawablePath {.header: juce_gui_basics, importcpp: "juce::DrawablePath(@)".}
proc setPath*(this: var DrawablePath, newPath: Path) {.header: juce_gui_basics, importcpp: "#.setPath(@)".}
proc getPath*(this: DrawablePath): Path {.header: juce_gui_basics, importcpp: "#.getPath()".}
proc getStrokePath*(this: DrawablePath): Path {.header: juce_gui_basics, importcpp: "#.getStrokePath()".}
proc createCopy*(this: DrawablePath): UniquePtr[Drawable] {.header: juce_gui_basics, importcpp: "#.createCopy()".}
proc `==`*(this: DrawablePath, other: DrawablePath): bool {.error: "juce::DrawablePath defines no operator==; compare a property instead".}

proc makeDrawableRectangle*(): DrawableRectangle {.header: juce_gui_basics, importcpp: "juce::DrawableRectangle(@)".}
proc setRectangle*(this: var DrawableRectangle, newBounds: Parallelogram[cfloat]) {.header: juce_gui_basics, importcpp: "#.setRectangle(@)".}
proc getRectangle*(this: DrawableRectangle): Parallelogram[cfloat] {.header: juce_gui_basics, importcpp: "#.getRectangle()".}
proc getCornerSize*(this: DrawableRectangle): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.getCornerSize()".}
proc setCornerSize*(this: var DrawableRectangle, newSize: Point[cfloat]) {.header: juce_gui_basics, importcpp: "#.setCornerSize(@)".}
proc createCopy*(this: DrawableRectangle): UniquePtr[Drawable] {.header: juce_gui_basics, importcpp: "#.createCopy()".}
proc `==`*(this: DrawableRectangle, other: DrawableRectangle): bool {.error: "juce::DrawableRectangle defines no operator==; compare a property instead".}

proc makeDrawableText*(): DrawableText {.header: juce_gui_basics, importcpp: "juce::DrawableText(@)".}
proc setText*(this: var DrawableText, newText: String) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc setPreserveWhitespace*(this: var DrawableText, shouldPreserveWhitespace: bool) {.header: juce_gui_basics, importcpp: "#.setPreserveWhitespace(@)".}
proc getText*(this: DrawableText): String {.header: juce_gui_basics, importcpp: "#.getText()".}
proc setColour*(this: var DrawableText, newColour: Colour) {.header: juce_gui_basics, importcpp: "#.setColour(@)".}
proc getColour*(this: DrawableText): Colour {.header: juce_gui_basics, importcpp: "#.getColour()".}
proc setFont*(this: var DrawableText, newFont: Font, applySizeAndScale: bool) {.header: juce_gui_basics, importcpp: "#.setFont(@)".}
proc getFont*(this: DrawableText): Font {.header: juce_gui_basics, importcpp: "#.getFont()".}
proc setJustification*(this: var DrawableText, newJustification: Justification) {.header: juce_gui_basics, importcpp: "#.setJustification(@)".}
proc getJustification*(this: DrawableText): Justification {.header: juce_gui_basics, importcpp: "#.getJustification()".}
proc getBoundingBox*(this: DrawableText): Parallelogram[cfloat] {.header: juce_gui_basics, importcpp: "#.getBoundingBox()".}
proc setBoundingBox*(this: var DrawableText, newBounds: Parallelogram[cfloat]) {.header: juce_gui_basics, importcpp: "#.setBoundingBox(@)".}
proc getFontHeight*(this: DrawableText): cfloat {.header: juce_gui_basics, importcpp: "#.getFontHeight()".}
proc setFontHeight*(this: var DrawableText, newHeight: cfloat) {.header: juce_gui_basics, importcpp: "#.setFontHeight(@)".}
proc getFontHorizontalScale*(this: DrawableText): cfloat {.header: juce_gui_basics, importcpp: "#.getFontHorizontalScale()".}
proc setFontHorizontalScale*(this: var DrawableText, newScale: cfloat) {.header: juce_gui_basics, importcpp: "#.setFontHorizontalScale(@)".}
proc paint*(this: var DrawableText, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc createCopy*(this: DrawableText): UniquePtr[Drawable] {.header: juce_gui_basics, importcpp: "#.createCopy()".}
proc getDrawableBounds*(this: DrawableText): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.getDrawableBounds()".}
proc getOutlineAsPath*(this: DrawableText): Path {.header: juce_gui_basics, importcpp: "#.getOutlineAsPath()".}
proc replaceColour*(this: var DrawableText, originalColour: Colour, replacementColour: Colour): bool {.header: juce_gui_basics, importcpp: "#.replaceColour(@)".}
proc createAccessibilityHandler*(this: var DrawableText): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: DrawableText, other: DrawableText): bool {.error: "juce::DrawableText defines no operator==; compare a property instead".}

proc makeTextEditor*(componentName: String, passwordCharacter: uint16): TextEditor {.header: juce_gui_basics, importcpp: "juce::TextEditor(@)".}
proc setMultiLine*(this: var TextEditor, shouldBeMultiLine: bool, shouldWordWrap: bool = true) {.header: juce_gui_basics, importcpp: "#.setMultiLine(@)".}
proc isMultiLine*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isMultiLine()".}
proc setReturnKeyStartsNewLine*(this: var TextEditor, shouldStartNewLine: bool) {.header: juce_gui_basics, importcpp: "#.setReturnKeyStartsNewLine(@)".}
proc getReturnKeyStartsNewLine*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.getReturnKeyStartsNewLine()".}
proc setTabKeyUsedAsCharacter*(this: var TextEditor, shouldTabKeyBeUsed: bool) {.header: juce_gui_basics, importcpp: "#.setTabKeyUsedAsCharacter(@)".}
proc isTabKeyUsedAsCharacter*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isTabKeyUsedAsCharacter()".}
proc setEscapeAndReturnKeysConsumed*(this: var TextEditor, shouldBeConsumed: bool) {.header: juce_gui_basics, importcpp: "#.setEscapeAndReturnKeysConsumed(@)".}
proc setReadOnly*(this: var TextEditor, shouldBeReadOnly: bool) {.header: juce_gui_basics, importcpp: "#.setReadOnly(@)".}
proc isReadOnly*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isReadOnly()".}
proc setCaretVisible*(this: var TextEditor, shouldBeVisible: bool) {.header: juce_gui_basics, importcpp: "#.setCaretVisible(@)".}
proc isCaretVisible*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isCaretVisible()".}
proc setScrollbarsShown*(this: var TextEditor, shouldBeEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setScrollbarsShown(@)".}
proc areScrollbarsShown*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.areScrollbarsShown()".}
proc setPasswordCharacter*(this: var TextEditor, passwordCharacter: uint16) {.header: juce_gui_basics, importcpp: "#.setPasswordCharacter(@)".}
proc getPasswordCharacter*(this: TextEditor): uint16 {.header: juce_gui_basics, importcpp: "#.getPasswordCharacter()".}
proc setPopupMenuEnabled*(this: var TextEditor, menuEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setPopupMenuEnabled(@)".}
proc isPopupMenuEnabled*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isPopupMenuEnabled()".}
proc isPopupMenuCurrentlyActive*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isPopupMenuCurrentlyActive()".}
proc setFont*(this: var TextEditor, newFont: Font) {.header: juce_gui_basics, importcpp: "#.setFont(@)".}
proc applyFontToAllText*(this: var TextEditor, newFont: Font, changeCurrentFont: bool = true) {.header: juce_gui_basics, importcpp: "#.applyFontToAllText(@)".}
proc getFont*(this: TextEditor): Font {.header: juce_gui_basics, importcpp: "#.getFont()".}
proc applyColourToAllText*(this: var TextEditor, newColour: Colour, changeCurrentTextColour: bool = true) {.header: juce_gui_basics, importcpp: "#.applyColourToAllText(@)".}
proc setWhitespaceUnderlined*(this: var TextEditor, shouldUnderlineWhitespace: bool) {.header: juce_gui_basics, importcpp: "#.setWhitespaceUnderlined(@)".}
proc isWhitespaceUnderlined*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isWhitespaceUnderlined()".}
proc setSelectAllWhenFocused*(this: var TextEditor, shouldSelectAll: bool) {.header: juce_gui_basics, importcpp: "#.setSelectAllWhenFocused(@)".}
proc setTextToShowWhenEmpty*(this: var TextEditor, text: String, colourToUse: Colour) {.header: juce_gui_basics, importcpp: "#.setTextToShowWhenEmpty(@)".}
proc getTextToShowWhenEmpty*(this: TextEditor): String {.header: juce_gui_basics, importcpp: "#.getTextToShowWhenEmpty()".}
proc setScrollBarThickness*(this: var TextEditor, newThicknessPixels: cint) {.header: juce_gui_basics, importcpp: "#.setScrollBarThickness(@)".}
proc addListener*(this: var TextEditor, newListener: ptr TextEditorListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var TextEditor, listenerToRemove: ptr TextEditorListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc getText*(this: TextEditor): String {.header: juce_gui_basics, importcpp: "#.getText()".}
proc getTextInRange*(this: TextEditor, textRange: Range[cint]): String {.header: juce_gui_basics, importcpp: "#.getTextInRange(@)".}
proc isEmpty*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isEmpty()".}
proc setText*(this: var TextEditor, newText: String, sendTextChangeMessage: bool = true) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc getTextValue*(this: var TextEditor): var Value {.header: juce_gui_basics, importcpp: "#.getTextValue()".}
proc insertTextAtCaret*(this: var TextEditor, textToInsert: String) {.header: juce_gui_basics, importcpp: "#.insertTextAtCaret(@)".}
proc clear*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.clear()".}
proc cut*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.cut()".}
proc copy*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.copy()".}
proc paste*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.paste()".}
proc getCaretPosition*(this: TextEditor): cint {.header: juce_gui_basics, importcpp: "#.getCaretPosition()".}
proc setCaretPosition*(this: var TextEditor, newIndex: cint) {.header: juce_gui_basics, importcpp: "#.setCaretPosition(@)".}
proc scrollEditorToPositionCaret*(this: var TextEditor, desiredCaretX: cint, desiredCaretY: cint) {.header: juce_gui_basics, importcpp: "#.scrollEditorToPositionCaret(@)".}
proc getCaretRectangleForCharIndex*(this: TextEditor, index: cint): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getCaretRectangleForCharIndex(@)".}
proc setHighlightedRegion*(this: var TextEditor, newSelection: Range[cint]) {.header: juce_gui_basics, importcpp: "#.setHighlightedRegion(@)".}
proc getHighlightedRegion*(this: TextEditor): Range[cint] {.header: juce_gui_basics, importcpp: "#.getHighlightedRegion()".}
proc getHighlightedText*(this: TextEditor): String {.header: juce_gui_basics, importcpp: "#.getHighlightedText()".}
proc getTextIndexAt*(this: TextEditor, x: cint, y: cint): cint {.header: juce_gui_basics, importcpp: "#.getTextIndexAt(@)".}
proc getTextIndexAt*(this: TextEditor, arg1: Point[cint]): cint {.header: juce_gui_basics, importcpp: "#.getTextIndexAt(@)".}
proc getCharIndexForPoint*(this: TextEditor, point: Point[cint]): cint {.header: juce_gui_basics, importcpp: "#.getCharIndexForPoint(@)".}
proc getTotalNumChars*(this: TextEditor): cint {.header: juce_gui_basics, importcpp: "#.getTotalNumChars()".}
proc getTextWidth*(this: TextEditor): cint {.header: juce_gui_basics, importcpp: "#.getTextWidth()".}
proc getTextHeight*(this: TextEditor): cint {.header: juce_gui_basics, importcpp: "#.getTextHeight()".}
proc setIndents*(this: var TextEditor, newLeftIndent: cint, newTopIndent: cint) {.header: juce_gui_basics, importcpp: "#.setIndents(@)".}
proc getTopIndent*(this: TextEditor): cint {.header: juce_gui_basics, importcpp: "#.getTopIndent()".}
proc getLeftIndent*(this: TextEditor): cint {.header: juce_gui_basics, importcpp: "#.getLeftIndent()".}
proc setBorder*(this: var TextEditor, border: BorderSize[cint]) {.header: juce_gui_basics, importcpp: "#.setBorder(@)".}
proc getBorder*(this: TextEditor): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getBorder()".}
proc setScrollToShowCursor*(this: var TextEditor, shouldScrollToShowCaret: bool) {.header: juce_gui_basics, importcpp: "#.setScrollToShowCursor(@)".}
proc setJustification*(this: var TextEditor, newJustification: Justification) {.header: juce_gui_basics, importcpp: "#.setJustification(@)".}
proc getJustificationType*(this: TextEditor): Justification {.header: juce_gui_basics, importcpp: "#.getJustificationType()".}
proc setLineSpacing*(this: var TextEditor, newLineSpacing: cfloat) {.header: juce_gui_basics, importcpp: "#.setLineSpacing(@)".}
proc getLineSpacing*(this: TextEditor): cfloat {.header: juce_gui_basics, importcpp: "#.getLineSpacing()".}
proc getTextBounds*(this: TextEditor, textRange: Range[cint]): RectangleList[cint] {.header: juce_gui_basics, importcpp: "#.getTextBounds(@)".}
proc moveCaretToEnd*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.moveCaretToEnd()".}
proc moveCaretLeft*(this: var TextEditor, moveInWholeWordSteps: bool, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretLeft(@)".}
proc moveCaretRight*(this: var TextEditor, moveInWholeWordSteps: bool, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretRight(@)".}
proc moveCaretUp*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretUp(@)".}
proc moveCaretDown*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretDown(@)".}
proc pageUp*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.pageUp(@)".}
proc pageDown*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.pageDown(@)".}
proc scrollDown*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.scrollDown()".}
proc scrollUp*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.scrollUp()".}
proc moveCaretToTop*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretToTop(@)".}
proc moveCaretToStartOfLine*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretToStartOfLine(@)".}
proc moveCaretToEnd*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretToEnd(@)".}
proc moveCaretToEndOfLine*(this: var TextEditor, selecting: bool): bool {.header: juce_gui_basics, importcpp: "#.moveCaretToEndOfLine(@)".}
proc deleteBackwards*(this: var TextEditor, moveInWholeWordSteps: bool): bool {.header: juce_gui_basics, importcpp: "#.deleteBackwards(@)".}
proc deleteForwards*(this: var TextEditor, moveInWholeWordSteps: bool): bool {.header: juce_gui_basics, importcpp: "#.deleteForwards(@)".}
proc copyToClipboard*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.copyToClipboard()".}
proc cutToClipboard*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.cutToClipboard()".}
proc pasteFromClipboard*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.pasteFromClipboard()".}
proc selectAll*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.selectAll()".}
proc undo*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.undo()".}
proc redo*(this: var TextEditor): bool {.header: juce_gui_basics, importcpp: "#.redo()".}
proc addPopupMenuItems*(this: var TextEditor, menuToAddTo: var PopupMenu, mouseClickEvent: ptr MouseEvent) {.header: juce_gui_basics, importcpp: "#.addPopupMenuItems(@)".}
proc performPopupMenuAction*(this: var TextEditor, menuItemID: cint) {.header: juce_gui_basics, importcpp: "#.performPopupMenuAction(@)".}
proc setInputFilter*(this: var TextEditor, newFilter: ptr TextEditorInputFilter, takeOwnership: bool) {.header: juce_gui_basics, importcpp: "#.setInputFilter(@)".}
proc getInputFilter*(this: TextEditor): ptr TextEditorInputFilter {.header: juce_gui_basics, importcpp: "#.getInputFilter()".}
proc setInputRestrictions*(this: var TextEditor, maxTextLength: cint, allowedCharacters: String) {.header: juce_gui_basics, importcpp: "#.setInputRestrictions(@)".}
proc setKeyboardType*(this: var TextEditor, `type`: TextInputTargetVirtualKeyboardType) {.header: juce_gui_basics, importcpp: "#.setKeyboardType(@)".}
proc setClicksOutsideDismissVirtualKeyboard*(this: var TextEditor, arg1: bool) {.header: juce_gui_basics, importcpp: "#.setClicksOutsideDismissVirtualKeyboard(@)".}
proc getClicksOutsideDismissVirtualKeyboard*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.getClicksOutsideDismissVirtualKeyboard()".}
proc paint*(this: var TextEditor, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc paintOverChildren*(this: var TextEditor, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paintOverChildren(@)".}
proc mouseDown*(this: var TextEditor, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseUp*(this: var TextEditor, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc mouseDrag*(this: var TextEditor, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseDoubleClick*(this: var TextEditor, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDoubleClick(@)".}
proc mouseWheelMove*(this: var TextEditor, arg1: MouseEvent, arg2: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc keyPressed*(this: var TextEditor, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc keyStateChanged*(this: var TextEditor, arg1: bool): bool {.header: juce_gui_basics, importcpp: "#.keyStateChanged(@)".}
proc focusGained*(this: var TextEditor, arg1: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusGained(@)".}
proc focusLost*(this: var TextEditor, arg1: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusLost(@)".}
proc resized*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc enablementChanged*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc lookAndFeelChanged*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc parentHierarchyChanged*(this: var TextEditor) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc isTextInputActive*(this: TextEditor): bool {.header: juce_gui_basics, importcpp: "#.isTextInputActive()".}
proc setTemporaryUnderlining*(this: var TextEditor, arg1: Array[Range[cint]]) {.header: juce_gui_basics, importcpp: "#.setTemporaryUnderlining(@)".}
proc getKeyboardType*(this: var TextEditor): TextInputTargetVirtualKeyboardType {.header: juce_gui_basics, importcpp: "#.getKeyboardType()".}
proc createAccessibilityHandler*(this: var TextEditor): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: TextEditor, other: TextEditor): bool {.error: "juce::TextEditor defines no operator==; compare a property instead".}

proc makeLabel*(componentName: String, labelText: String): Label {.header: juce_gui_basics, importcpp: "juce::Label(@)".}
proc setText*(this: var Label, newText: String, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc getText*(this: Label, returnActiveEditorContents: bool = false): String {.header: juce_gui_basics, importcpp: "#.getText(@)".}
proc getTextValue*(this: var Label): var Value {.header: juce_gui_basics, importcpp: "#.getTextValue()".}
proc setFont*(this: var Label, newFont: Font) {.header: juce_gui_basics, importcpp: "#.setFont(@)".}
proc getFont*(this: Label): Font {.header: juce_gui_basics, importcpp: "#.getFont()".}
proc setJustificationType*(this: var Label, justification: Justification) {.header: juce_gui_basics, importcpp: "#.setJustificationType(@)".}
proc getJustificationType*(this: Label): Justification {.header: juce_gui_basics, importcpp: "#.getJustificationType()".}
proc setBorderSize*(this: var Label, newBorderSize: BorderSize[cint]) {.header: juce_gui_basics, importcpp: "#.setBorderSize(@)".}
proc getBorderSize*(this: Label): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getBorderSize()".}
proc attachToComponent*(this: var Label, owner: ptr Component, onLeft: bool) {.header: juce_gui_basics, importcpp: "#.attachToComponent(@)".}
proc getAttachedComponent*(this: Label): ptr Component {.header: juce_gui_basics, importcpp: "#.getAttachedComponent()".}
proc isAttachedOnLeft*(this: Label): bool {.header: juce_gui_basics, importcpp: "#.isAttachedOnLeft()".}
proc setMinimumHorizontalScale*(this: var Label, newScale: cfloat) {.header: juce_gui_basics, importcpp: "#.setMinimumHorizontalScale(@)".}
proc getMinimumHorizontalScale*(this: Label): cfloat {.header: juce_gui_basics, importcpp: "#.getMinimumHorizontalScale()".}
proc setKeyboardType*(this: var Label, `type`: TextInputTargetVirtualKeyboardType) {.header: juce_gui_basics, importcpp: "#.setKeyboardType(@)".}
proc addListener*(this: var Label, listener: ptr LabelListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var Label, listener: ptr LabelListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc setEditable*(this: var Label, editOnSingleClick: bool, editOnDoubleClick: bool = false, lossOfFocusDiscardsChanges: bool = false) {.header: juce_gui_basics, importcpp: "#.setEditable(@)".}
proc isEditableOnSingleClick*(this: Label): bool {.header: juce_gui_basics, importcpp: "#.isEditableOnSingleClick()".}
proc isEditableOnDoubleClick*(this: Label): bool {.header: juce_gui_basics, importcpp: "#.isEditableOnDoubleClick()".}
proc doesLossOfFocusDiscardChanges*(this: Label): bool {.header: juce_gui_basics, importcpp: "#.doesLossOfFocusDiscardChanges()".}
proc isEditable*(this: Label): bool {.header: juce_gui_basics, importcpp: "#.isEditable()".}
proc showEditor*(this: var Label) {.header: juce_gui_basics, importcpp: "#.showEditor()".}
proc hideEditor*(this: var Label, discardCurrentEditorContents: bool) {.header: juce_gui_basics, importcpp: "#.hideEditor(@)".}
proc isBeingEdited*(this: Label): bool {.header: juce_gui_basics, importcpp: "#.isBeingEdited()".}
proc getCurrentTextEditor*(this: Label): ptr TextEditor {.header: juce_gui_basics, importcpp: "#.getCurrentTextEditor()".}
proc createAccessibilityHandler*(this: var Label): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: Label, other: Label): bool {.error: "juce::Label defines no operator==; compare a property instead".}

proc makeComboBox*(componentName: String): ComboBox {.header: juce_gui_basics, importcpp: "juce::ComboBox(@)".}
proc setEditableText*(this: var ComboBox, isEditable: bool) {.header: juce_gui_basics, importcpp: "#.setEditableText(@)".}
proc isTextEditable*(this: ComboBox): bool {.header: juce_gui_basics, importcpp: "#.isTextEditable()".}
proc setJustificationType*(this: var ComboBox, justification: Justification) {.header: juce_gui_basics, importcpp: "#.setJustificationType(@)".}
proc getJustificationType*(this: ComboBox): Justification {.header: juce_gui_basics, importcpp: "#.getJustificationType()".}
proc addItem*(this: var ComboBox, newItemText: String, newItemId: cint) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc addItemList*(this: var ComboBox, items: StringArray, firstItemIdOffset: cint) {.header: juce_gui_basics, importcpp: "#.addItemList(@)".}
proc addSeparator*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.addSeparator()".}
proc addSectionHeading*(this: var ComboBox, headingName: String) {.header: juce_gui_basics, importcpp: "#.addSectionHeading(@)".}
proc setItemEnabled*(this: var ComboBox, itemId: cint, shouldBeEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setItemEnabled(@)".}
proc isItemEnabled*(this: ComboBox, itemId: cint): bool {.header: juce_gui_basics, importcpp: "#.isItemEnabled(@)".}
proc changeItemText*(this: var ComboBox, itemId: cint, newText: String) {.header: juce_gui_basics, importcpp: "#.changeItemText(@)".}
proc clear*(this: var ComboBox, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.clear(@)".}
proc getNumItems*(this: ComboBox): cint {.header: juce_gui_basics, importcpp: "#.getNumItems()".}
proc getItemText*(this: ComboBox, index: cint): String {.header: juce_gui_basics, importcpp: "#.getItemText(@)".}
proc getItemId*(this: ComboBox, index: cint): cint {.header: juce_gui_basics, importcpp: "#.getItemId(@)".}
proc indexOfItemId*(this: ComboBox, itemId: cint): cint {.header: juce_gui_basics, importcpp: "#.indexOfItemId(@)".}
proc getSelectedId*(this: ComboBox): cint {.header: juce_gui_basics, importcpp: "#.getSelectedId()".}
proc getSelectedIdAsValue*(this: var ComboBox): var Value {.header: juce_gui_basics, importcpp: "#.getSelectedIdAsValue()".}
proc setSelectedId*(this: var ComboBox, newItemId: cint, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setSelectedId(@)".}
proc getSelectedItemIndex*(this: ComboBox): cint {.header: juce_gui_basics, importcpp: "#.getSelectedItemIndex()".}
proc setSelectedItemIndex*(this: var ComboBox, newItemIndex: cint, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setSelectedItemIndex(@)".}
proc getText*(this: ComboBox): String {.header: juce_gui_basics, importcpp: "#.getText()".}
proc setText*(this: var ComboBox, newText: String, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc showEditor*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.showEditor()".}
proc showPopup*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.showPopup()".}
proc hidePopup*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.hidePopup()".}
proc isPopupActive*(this: ComboBox): bool {.header: juce_gui_basics, importcpp: "#.isPopupActive()".}
proc getRootMenu*(this: var ComboBox): ptr PopupMenu {.header: juce_gui_basics, importcpp: "#.getRootMenu()".}
proc getRootMenu*(this: ComboBox): ptr PopupMenu {.header: juce_gui_basics, importcpp: "#.getRootMenu()".}
proc addListener*(this: var ComboBox, listener: ptr ComboBoxListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var ComboBox, listener: ptr ComboBoxListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc setTextWhenNothingSelected*(this: var ComboBox, newMessage: String) {.header: juce_gui_basics, importcpp: "#.setTextWhenNothingSelected(@)".}
proc getTextWhenNothingSelected*(this: ComboBox): String {.header: juce_gui_basics, importcpp: "#.getTextWhenNothingSelected()".}
proc setTextWhenNoChoicesAvailable*(this: var ComboBox, newMessage: String) {.header: juce_gui_basics, importcpp: "#.setTextWhenNoChoicesAvailable(@)".}
proc getTextWhenNoChoicesAvailable*(this: ComboBox): String {.header: juce_gui_basics, importcpp: "#.getTextWhenNoChoicesAvailable()".}
proc setTooltip*(this: var ComboBox, newTooltip: String) {.header: juce_gui_basics, importcpp: "#.setTooltip(@)".}
proc setScrollWheelEnabled*(this: var ComboBox, enabled: bool) {.header: juce_gui_basics, importcpp: "#.setScrollWheelEnabled(@)".}
proc enablementChanged*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc colourChanged*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc focusGained*(this: var ComboBox, arg1: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusGained(@)".}
proc focusLost*(this: var ComboBox, arg1: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusLost(@)".}
proc handleAsyncUpdate*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.handleAsyncUpdate()".}
proc getTooltip*(this: var ComboBox): String {.header: juce_gui_basics, importcpp: "#.getTooltip()".}
proc mouseDown*(this: var ComboBox, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var ComboBox, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var ComboBox, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc mouseWheelMove*(this: var ComboBox, arg1: MouseEvent, arg2: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc lookAndFeelChanged*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc paint*(this: var ComboBox, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc keyStateChanged*(this: var ComboBox, arg1: bool): bool {.header: juce_gui_basics, importcpp: "#.keyStateChanged(@)".}
proc keyPressed*(this: var ComboBox, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc valueChanged*(this: var ComboBox, arg1: var Value) {.header: juce_gui_basics, importcpp: "#.valueChanged(@)".}
proc parentHierarchyChanged*(this: var ComboBox) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc createAccessibilityHandler*(this: var ComboBox): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc clear*(this: var ComboBox, arg1: bool) {.header: juce_gui_basics, importcpp: "#.clear(@)".}
proc setSelectedId*(this: var ComboBox, arg1: cint, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setSelectedId(@)".}
proc setSelectedItemIndex*(this: var ComboBox, arg1: cint, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setSelectedItemIndex(@)".}
proc setText*(this: var ComboBox, arg1: String, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc `==`*(this: ComboBox, other: ComboBox): bool {.error: "juce::ComboBox defines no operator==; compare a property instead".}

proc makeImageComponent*(componentName: String): ImageComponent {.header: juce_gui_basics, importcpp: "juce::ImageComponent(@)".}
proc setImage*(this: var ImageComponent, newImage: Image) {.header: juce_gui_basics, importcpp: "#.setImage(@)".}
proc setImage*(this: var ImageComponent, newImage: Image, placementToUse: RectanglePlacement) {.header: juce_gui_basics, importcpp: "#.setImage(@)".}
proc getImage*(this: ImageComponent): Image {.header: juce_gui_basics, importcpp: "#.getImage()".}
proc setImagePlacement*(this: var ImageComponent, newPlacement: RectanglePlacement) {.header: juce_gui_basics, importcpp: "#.setImagePlacement(@)".}
proc getImagePlacement*(this: ImageComponent): RectanglePlacement {.header: juce_gui_basics, importcpp: "#.getImagePlacement()".}
proc paint*(this: var ImageComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc createAccessibilityHandler*(this: var ImageComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ImageComponent, other: ImageComponent): bool {.error: "juce::ImageComponent defines no operator==; compare a property instead".}

proc getNumRows*(this: var ListBoxModel): cint {.header: juce_gui_basics, importcpp: "#.getNumRows()".}
proc paintListBoxItem*(this: var ListBoxModel, rowNumber: cint, g: var Graphics, width: cint, height: cint, rowIsSelected: bool) {.header: juce_gui_basics, importcpp: "#.paintListBoxItem(@)".}
proc refreshComponentForRow*(this: var ListBoxModel, rowNumber: cint, isRowSelected: bool, existingComponentToUpdate: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.refreshComponentForRow(@)".}
proc getNameForRow*(this: var ListBoxModel, rowNumber: cint): String {.header: juce_gui_basics, importcpp: "#.getNameForRow(@)".}
proc listBoxItemClicked*(this: var ListBoxModel, row: cint, arg2: MouseEvent) {.header: juce_gui_basics, importcpp: "#.listBoxItemClicked(@)".}
proc listBoxItemDoubleClicked*(this: var ListBoxModel, row: cint, arg2: MouseEvent) {.header: juce_gui_basics, importcpp: "#.listBoxItemDoubleClicked(@)".}
proc backgroundClicked*(this: var ListBoxModel, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.backgroundClicked(@)".}
proc selectedRowsChanged*(this: var ListBoxModel, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.selectedRowsChanged(@)".}
proc deleteKeyPressed*(this: var ListBoxModel, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.deleteKeyPressed(@)".}
proc returnKeyPressed*(this: var ListBoxModel, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.returnKeyPressed(@)".}
proc listWasScrolled*(this: var ListBoxModel) {.header: juce_gui_basics, importcpp: "#.listWasScrolled()".}
proc getDragSourceDescription*(this: var ListBoxModel, rowsToDescribe: SparseSet[cint]): juce_var {.header: juce_gui_basics, importcpp: "#.getDragSourceDescription(@)".}
proc mayDragToExternalWindows*(this: ListBoxModel): bool {.header: juce_gui_basics, importcpp: "#.mayDragToExternalWindows()".}
proc getTooltipForRow*(this: var ListBoxModel, row: cint): String {.header: juce_gui_basics, importcpp: "#.getTooltipForRow(@)".}
proc getMouseCursorForRow*(this: var ListBoxModel, row: cint): MouseCursor {.header: juce_gui_basics, importcpp: "#.getMouseCursorForRow(@)".}
proc `==`*(this: ListBoxModel, other: ListBoxModel): bool {.error: "juce::ListBoxModel defines no operator==; compare a property instead".}

proc makeListBox*(componentName: String, model: ptr ListBoxModel): ListBox {.header: juce_gui_basics, importcpp: "juce::ListBox(@)".}
proc setModel*(this: var ListBox, newModel: ptr ListBoxModel) {.header: juce_gui_basics, importcpp: "#.setModel(@)".}
proc getListBoxModel*(this: ListBox): ptr ListBoxModel {.header: juce_gui_basics, importcpp: "#.getListBoxModel()".}
proc updateContent*(this: var ListBox) {.header: juce_gui_basics, importcpp: "#.updateContent()".}
proc setMultipleSelectionEnabled*(this: var ListBox, shouldBeEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setMultipleSelectionEnabled(@)".}
proc setClickingTogglesRowSelection*(this: var ListBox, flipRowSelection: bool) {.header: juce_gui_basics, importcpp: "#.setClickingTogglesRowSelection(@)".}
proc setRowSelectedOnMouseDown*(this: var ListBox, isSelectedOnMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.setRowSelectedOnMouseDown(@)".}
proc getRowSelectedOnMouseDown*(this: ListBox): bool {.header: juce_gui_basics, importcpp: "#.getRowSelectedOnMouseDown()".}
proc setMouseMoveSelectsRows*(this: var ListBox, shouldSelect: bool) {.header: juce_gui_basics, importcpp: "#.setMouseMoveSelectsRows(@)".}
proc selectRow*(this: var ListBox, rowNumber: cint, dontScrollToShowThisRow: bool = false, deselectOthersFirst: bool = true) {.header: juce_gui_basics, importcpp: "#.selectRow(@)".}
proc selectRangeOfRows*(this: var ListBox, firstRow: cint, lastRow: cint, dontScrollToShowThisRange: bool = false) {.header: juce_gui_basics, importcpp: "#.selectRangeOfRows(@)".}
proc deselectRow*(this: var ListBox, rowNumber: cint) {.header: juce_gui_basics, importcpp: "#.deselectRow(@)".}
proc deselectAllRows*(this: var ListBox) {.header: juce_gui_basics, importcpp: "#.deselectAllRows()".}
proc flipRowSelection*(this: var ListBox, rowNumber: cint) {.header: juce_gui_basics, importcpp: "#.flipRowSelection(@)".}
proc getSelectedRows*(this: ListBox): SparseSet[cint] {.header: juce_gui_basics, importcpp: "#.getSelectedRows()".}
proc setSelectedRows*(this: var ListBox, setOfRowsToBeSelected: SparseSet[cint], sendNotificationEventToModel: NotificationType) {.header: juce_gui_basics, importcpp: "#.setSelectedRows(@)".}
proc isRowSelected*(this: ListBox, rowNumber: cint): bool {.header: juce_gui_basics, importcpp: "#.isRowSelected(@)".}
proc getNumSelectedRows*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getNumSelectedRows()".}
proc getSelectedRow*(this: ListBox, index: cint = 0): cint {.header: juce_gui_basics, importcpp: "#.getSelectedRow(@)".}
proc getLastRowSelected*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getLastRowSelected()".}
proc selectRowsBasedOnModifierKeys*(this: var ListBox, rowThatWasClickedOn: cint, modifiers: ModifierKeys, isMouseUpEvent: bool) {.header: juce_gui_basics, importcpp: "#.selectRowsBasedOnModifierKeys(@)".}
proc setVerticalPosition*(this: var ListBox, newProportion: float64) {.header: juce_gui_basics, importcpp: "#.setVerticalPosition(@)".}
proc getVerticalPosition*(this: ListBox): float64 {.header: juce_gui_basics, importcpp: "#.getVerticalPosition()".}
proc scrollToEnsureRowIsOnscreen*(this: var ListBox, row: cint) {.header: juce_gui_basics, importcpp: "#.scrollToEnsureRowIsOnscreen(@)".}
proc getVerticalScrollBar*(this: ListBox): var ScrollBar {.header: juce_gui_basics, importcpp: "#.getVerticalScrollBar()".}
proc getHorizontalScrollBar*(this: ListBox): var ScrollBar {.header: juce_gui_basics, importcpp: "#.getHorizontalScrollBar()".}
proc getRowContainingPosition*(this: ListBox, x: cint, y: cint): cint {.header: juce_gui_basics, importcpp: "#.getRowContainingPosition(@)".}
proc getInsertionIndexForPosition*(this: ListBox, x: cint, y: cint): cint {.header: juce_gui_basics, importcpp: "#.getInsertionIndexForPosition(@)".}
proc getRowPosition*(this: ListBox, rowNumber: cint, relativeToComponentTopLeft: bool): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getRowPosition(@)".}
proc getComponentForRowNumber*(this: ListBox, rowNumber: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getComponentForRowNumber(@)".}
proc getRowNumberOfComponent*(this: ListBox, rowComponent: ptr Component): cint {.header: juce_gui_basics, importcpp: "#.getRowNumberOfComponent(@)".}
proc getVisibleRowWidth*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getVisibleRowWidth()".}
proc setRowHeight*(this: var ListBox, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setRowHeight(@)".}
proc getRowHeight*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getRowHeight()".}
proc getNumRowsOnScreen*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getNumRowsOnScreen()".}
proc setOutlineThickness*(this: var ListBox, outlineThickness: cint) {.header: juce_gui_basics, importcpp: "#.setOutlineThickness(@)".}
proc getOutlineThickness*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getOutlineThickness()".}
proc setHeaderComponent*(this: var ListBox, newHeaderComponent: UniquePtr[Component]) {.header: juce_gui_basics, importcpp: "#.setHeaderComponent(@)".}
proc getHeaderComponent*(this: ListBox): ptr Component {.header: juce_gui_basics, importcpp: "#.getHeaderComponent()".}
proc setMinimumContentWidth*(this: var ListBox, newMinimumWidth: cint) {.header: juce_gui_basics, importcpp: "#.setMinimumContentWidth(@)".}
proc getVisibleContentWidth*(this: ListBox): cint {.header: juce_gui_basics, importcpp: "#.getVisibleContentWidth()".}
proc repaintRow*(this: var ListBox, rowNumber: cint) {.header: juce_gui_basics, importcpp: "#.repaintRow(@)".}
proc createSnapshotOfRows*(this: var ListBox, rows: SparseSet[cint], x: var cint, y: var cint): ScaledImage {.header: juce_gui_basics, importcpp: "#.createSnapshotOfRows(@)".}
proc getViewport*(this: ListBox): ptr Viewport {.header: juce_gui_basics, importcpp: "#.getViewport()".}
proc keyPressed*(this: var ListBox, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc keyStateChanged*(this: var ListBox, isKeyDown: bool): bool {.header: juce_gui_basics, importcpp: "#.keyStateChanged(@)".}
proc paint*(this: var ListBox, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc paintOverChildren*(this: var ListBox, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paintOverChildren(@)".}
proc resized*(this: var ListBox) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc visibilityChanged*(this: var ListBox) {.header: juce_gui_basics, importcpp: "#.visibilityChanged()".}
proc mouseWheelMove*(this: var ListBox, arg1: MouseEvent, arg2: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc mouseUp*(this: var ListBox, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc colourChanged*(this: var ListBox) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc parentHierarchyChanged*(this: var ListBox) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc startDragAndDrop*(this: var ListBox, arg1: MouseEvent, rowsToDrag: SparseSet[cint], dragDescription: juce_var, allowDraggingToOtherWindows: bool) {.header: juce_gui_basics, importcpp: "#.startDragAndDrop(@)".}
proc createAccessibilityHandler*(this: var ListBox): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc setSelectedRows*(this: var ListBox, arg1: SparseSet[cint], arg2: bool) {.header: juce_gui_basics, importcpp: "#.setSelectedRows(@)".}
proc getModel*(this: ListBox): ptr ListBoxModel {.header: juce_gui_basics, importcpp: "#.getModel()".}
proc `==`*(this: ListBox, other: ListBox): bool {.error: "juce::ListBox defines no operator==; compare a property instead".}

proc makeProgressBar*(progress: var float64): ProgressBar {.header: juce_gui_basics, importcpp: "juce::ProgressBar(@)".}
proc makeProgressBar*(progress: var float64, style: CppOptional[ProgressBarStyle]): ProgressBar {.header: juce_gui_basics, importcpp: "juce::ProgressBar(@)".}
proc setPercentageDisplay*(this: var ProgressBar, shouldDisplayPercentage: bool) {.header: juce_gui_basics, importcpp: "#.setPercentageDisplay(@)".}
proc setTextToDisplay*(this: var ProgressBar, text: String) {.header: juce_gui_basics, importcpp: "#.setTextToDisplay(@)".}
proc setStyle*(this: var ProgressBar, newStyle: CppOptional[ProgressBarStyle]) {.header: juce_gui_basics, importcpp: "#.setStyle(@)".}
proc getStyle*(this: ProgressBar): CppOptional[ProgressBarStyle] {.header: juce_gui_basics, importcpp: "#.getStyle()".}
proc getResolvedStyle*(this: ProgressBar): ProgressBarStyle {.header: juce_gui_basics, importcpp: "#.getResolvedStyle()".}
proc createAccessibilityHandler*(this: var ProgressBar): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ProgressBar, other: ProgressBar): bool {.error: "juce::ProgressBar defines no operator==; compare a property instead".}

proc makeSlider*(): Slider {.header: juce_gui_basics, importcpp: "juce::Slider(@)".}
proc makeSlider*(componentName: String): Slider {.header: juce_gui_basics, importcpp: "juce::Slider(@)".}
proc makeSlider*(style: SliderSliderStyle, textBoxPosition: SliderTextEntryBoxPosition): Slider {.header: juce_gui_basics, importcpp: "juce::Slider(@)".}
proc setSliderStyle*(this: var Slider, newStyle: SliderSliderStyle) {.header: juce_gui_basics, importcpp: "#.setSliderStyle(@)".}
proc getSliderStyle*(this: Slider): SliderSliderStyle {.header: juce_gui_basics, importcpp: "#.getSliderStyle()".}
proc setRotaryParameters*(this: var Slider, newParameters: SliderRotaryParameters) {.header: juce_gui_basics, importcpp: "#.setRotaryParameters(@)".}
proc setRotaryParameters*(this: var Slider, startAngleRadians: cfloat, endAngleRadians: cfloat, stopAtEnd: bool) {.header: juce_gui_basics, importcpp: "#.setRotaryParameters(@)".}
proc getRotaryParameters*(this: Slider): SliderRotaryParameters {.header: juce_gui_basics, importcpp: "#.getRotaryParameters()".}
proc setMouseDragSensitivity*(this: var Slider, distanceForFullScaleDrag: cint) {.header: juce_gui_basics, importcpp: "#.setMouseDragSensitivity(@)".}
proc getMouseDragSensitivity*(this: Slider): cint {.header: juce_gui_basics, importcpp: "#.getMouseDragSensitivity()".}
proc setVelocityBasedMode*(this: var Slider, isVelocityBased: bool) {.header: juce_gui_basics, importcpp: "#.setVelocityBasedMode(@)".}
proc getVelocityBasedMode*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.getVelocityBasedMode()".}
proc setVelocityModeParameters*(this: var Slider, sensitivity: float64 = 1.0, threshold: cint = 1, offset: float64 = 0.0, userCanPressKeyToSwapMode: bool = true, modifiersToSwapModes: ModifierKeysFlags) {.header: juce_gui_basics, importcpp: "#.setVelocityModeParameters(@)".}
proc getVelocitySensitivity*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getVelocitySensitivity()".}
proc getVelocityThreshold*(this: Slider): cint {.header: juce_gui_basics, importcpp: "#.getVelocityThreshold()".}
proc getVelocityOffset*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getVelocityOffset()".}
proc getVelocityModeIsSwappable*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.getVelocityModeIsSwappable()".}
proc setSkewFactor*(this: var Slider, factor: float64, symmetricSkew: bool = false) {.header: juce_gui_basics, importcpp: "#.setSkewFactor(@)".}
proc setSkewFactorFromMidPoint*(this: var Slider, sliderValueToShowAtMidPoint: float64) {.header: juce_gui_basics, importcpp: "#.setSkewFactorFromMidPoint(@)".}
proc getSkewFactor*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getSkewFactor()".}
proc isSymmetricSkew*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isSymmetricSkew()".}
proc setIncDecButtonsMode*(this: var Slider, mode: SliderIncDecButtonMode) {.header: juce_gui_basics, importcpp: "#.setIncDecButtonsMode(@)".}
proc setTextBoxStyle*(this: var Slider, newPosition: SliderTextEntryBoxPosition, isReadOnly: bool, textEntryBoxWidth: cint, textEntryBoxHeight: cint) {.header: juce_gui_basics, importcpp: "#.setTextBoxStyle(@)".}
proc getTextBoxPosition*(this: Slider): SliderTextEntryBoxPosition {.header: juce_gui_basics, importcpp: "#.getTextBoxPosition()".}
proc getTextBoxWidth*(this: Slider): cint {.header: juce_gui_basics, importcpp: "#.getTextBoxWidth()".}
proc getTextBoxHeight*(this: Slider): cint {.header: juce_gui_basics, importcpp: "#.getTextBoxHeight()".}
proc setTextBoxIsEditable*(this: var Slider, shouldBeEditable: bool) {.header: juce_gui_basics, importcpp: "#.setTextBoxIsEditable(@)".}
proc isTextBoxEditable*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isTextBoxEditable()".}
proc showTextBox*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.showTextBox()".}
proc hideTextBox*(this: var Slider, discardCurrentEditorContents: bool) {.header: juce_gui_basics, importcpp: "#.hideTextBox(@)".}
proc setValue*(this: var Slider, newValue: float64, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc getValue*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getValue()".}
proc getValueObject*(this: var Slider): var Value {.header: juce_gui_basics, importcpp: "#.getValueObject()".}
proc setRange*(this: var Slider, newMinimum: float64, newMaximum: float64, newInterval: float64 = 0) {.header: juce_gui_basics, importcpp: "#.setRange(@)".}
proc setRange*(this: var Slider, newRange: Range[cdouble], newInterval: float64) {.header: juce_gui_basics, importcpp: "#.setRange(@)".}
proc setNormalisableRange*(this: var Slider, newNormalisableRange: NormalisableRange[cdouble]) {.header: juce_gui_basics, importcpp: "#.setNormalisableRange(@)".}
proc getNormalisableRange*(this: Slider): NormalisableRange[cdouble] {.header: juce_gui_basics, importcpp: "#.getNormalisableRange()".}
proc getRange*(this: Slider): Range[cdouble] {.header: juce_gui_basics, importcpp: "#.getRange()".}
proc getMaximum*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getMaximum()".}
proc getMinimum*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getMinimum()".}
proc getInterval*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getInterval()".}
proc getMinValue*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getMinValue()".}
proc getMinValueObject*(this: var Slider): var Value {.header: juce_gui_basics, importcpp: "#.getMinValueObject()".}
proc setMinValue*(this: var Slider, newValue: float64, notification: NotificationType, allowNudgingOfOtherValues: bool = false) {.header: juce_gui_basics, importcpp: "#.setMinValue(@)".}
proc getMaxValue*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getMaxValue()".}
proc getMaxValueObject*(this: var Slider): var Value {.header: juce_gui_basics, importcpp: "#.getMaxValueObject()".}
proc setMaxValue*(this: var Slider, newValue: float64, notification: NotificationType, allowNudgingOfOtherValues: bool = false) {.header: juce_gui_basics, importcpp: "#.setMaxValue(@)".}
proc setMinAndMaxValues*(this: var Slider, newMinValue: float64, newMaxValue: float64, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setMinAndMaxValues(@)".}
# proc addListener*(this: var Slider, listener: ptr Listener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}  # a type that cannot be spelled in Nim
# proc removeListener*(this: var Slider, listener: ptr Listener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}  # a type that cannot be spelled in Nim
proc setDoubleClickReturnValue*(this: var Slider, shouldDoubleClickBeEnabled: bool, valueToSetOnDoubleClick: float64, singleClickModifiers: ModifierKeys) {.header: juce_gui_basics, importcpp: "#.setDoubleClickReturnValue(@)".}
proc getDoubleClickReturnValue*(this: Slider): float64 {.header: juce_gui_basics, importcpp: "#.getDoubleClickReturnValue()".}
proc isDoubleClickReturnEnabled*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isDoubleClickReturnEnabled()".}
proc setChangeNotificationOnlyOnRelease*(this: var Slider, onlyNotifyOnRelease: bool) {.header: juce_gui_basics, importcpp: "#.setChangeNotificationOnlyOnRelease(@)".}
proc setSliderSnapsToMousePosition*(this: var Slider, shouldSnapToMouse: bool) {.header: juce_gui_basics, importcpp: "#.setSliderSnapsToMousePosition(@)".}
proc getSliderSnapsToMousePosition*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.getSliderSnapsToMousePosition()".}
proc setPopupDisplayEnabled*(this: var Slider, shouldShowOnMouseDrag: bool, shouldShowOnMouseHover: bool, parentComponentToUse: ptr Component, hoverTimeout: cint = 2000) {.header: juce_gui_basics, importcpp: "#.setPopupDisplayEnabled(@)".}
proc getCurrentPopupDisplay*(this: Slider): ptr Component {.header: juce_gui_basics, importcpp: "#.getCurrentPopupDisplay()".}
proc setPopupMenuEnabled*(this: var Slider, menuEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setPopupMenuEnabled(@)".}
proc setScrollWheelEnabled*(this: var Slider, enabled: bool) {.header: juce_gui_basics, importcpp: "#.setScrollWheelEnabled(@)".}
proc isScrollWheelEnabled*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isScrollWheelEnabled()".}
proc getThumbBeingDragged*(this: Slider): cint {.header: juce_gui_basics, importcpp: "#.getThumbBeingDragged()".}
proc startedDragging*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.startedDragging()".}
proc stoppedDragging*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.stoppedDragging()".}
proc valueChanged*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.valueChanged()".}
proc getValueFromText*(this: var Slider, text: String): float64 {.header: juce_gui_basics, importcpp: "#.getValueFromText(@)".}
proc getTextFromValue*(this: var Slider, value: float64): String {.header: juce_gui_basics, importcpp: "#.getTextFromValue(@)".}
proc setTextValueSuffix*(this: var Slider, suffix: String) {.header: juce_gui_basics, importcpp: "#.setTextValueSuffix(@)".}
proc getTextValueSuffix*(this: Slider): String {.header: juce_gui_basics, importcpp: "#.getTextValueSuffix()".}
proc getNumDecimalPlacesToDisplay*(this: Slider): cint {.header: juce_gui_basics, importcpp: "#.getNumDecimalPlacesToDisplay()".}
proc setNumDecimalPlacesToDisplay*(this: var Slider, decimalPlacesToDisplay: cint) {.header: juce_gui_basics, importcpp: "#.setNumDecimalPlacesToDisplay(@)".}
proc proportionOfLengthToValue*(this: var Slider, proportion: float64): float64 {.header: juce_gui_basics, importcpp: "#.proportionOfLengthToValue(@)".}
proc valueToProportionOfLength*(this: var Slider, value: float64): float64 {.header: juce_gui_basics, importcpp: "#.valueToProportionOfLength(@)".}
proc getPositionOfValue*(this: Slider, value: float64): cfloat {.header: juce_gui_basics, importcpp: "#.getPositionOfValue(@)".}
proc snapValue*(this: var Slider, attemptedValue: float64, dragMode: SliderDragMode): float64 {.header: juce_gui_basics, importcpp: "#.snapValue(@)".}
proc updateText*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.updateText()".}
proc isHorizontal*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isHorizontal()".}
proc isVertical*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isVertical()".}
proc isRotary*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isRotary()".}
proc isBar*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isBar()".}
proc isTwoValue*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isTwoValue()".}
proc isThreeValue*(this: Slider): bool {.header: juce_gui_basics, importcpp: "#.isThreeValue()".}
proc paint*(this: var Slider, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc mouseDown*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseUp*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc mouseDrag*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseDoubleClick*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDoubleClick(@)".}
proc mouseWheelMove*(this: var Slider, arg1: MouseEvent, arg2: MouseWheelDetails) {.header: juce_gui_basics, importcpp: "#.mouseWheelMove(@)".}
proc modifierKeysChanged*(this: var Slider, arg1: ModifierKeys) {.header: juce_gui_basics, importcpp: "#.modifierKeysChanged(@)".}
proc lookAndFeelChanged*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc enablementChanged*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc focusOfChildComponentChanged*(this: var Slider, arg1: ComponentFocusChangeType) {.header: juce_gui_basics, importcpp: "#.focusOfChildComponentChanged(@)".}
proc colourChanged*(this: var Slider) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc mouseMove*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseMove(@)".}
proc mouseExit*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseExit(@)".}
proc mouseEnter*(this: var Slider, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseEnter(@)".}
proc keyPressed*(this: var Slider, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc createAccessibilityHandler*(this: var Slider): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc setValue*(this: var Slider, arg1: float64, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc setValue*(this: var Slider, arg1: float64, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc setMinValue*(this: var Slider, arg1: float64, arg2: bool, arg3: bool, arg4: bool) {.header: juce_gui_basics, importcpp: "#.setMinValue(@)".}
proc setMinValue*(this: var Slider, arg1: float64, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.setMinValue(@)".}
proc setMinValue*(this: var Slider, arg1: float64, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setMinValue(@)".}
proc setMaxValue*(this: var Slider, arg1: float64, arg2: bool, arg3: bool, arg4: bool) {.header: juce_gui_basics, importcpp: "#.setMaxValue(@)".}
proc setMaxValue*(this: var Slider, arg1: float64, arg2: bool, arg3: bool) {.header: juce_gui_basics, importcpp: "#.setMaxValue(@)".}
proc setMaxValue*(this: var Slider, arg1: float64, arg2: bool) {.header: juce_gui_basics, importcpp: "#.setMaxValue(@)".}
proc setMinAndMaxValues*(this: var Slider, arg1: float64, arg2: float64, arg3: bool, arg4: bool) {.header: juce_gui_basics, importcpp: "#.setMinAndMaxValues(@)".}
proc setMinAndMaxValues*(this: var Slider, arg1: float64, arg2: float64, arg3: bool) {.header: juce_gui_basics, importcpp: "#.setMinAndMaxValues(@)".}
proc `==`*(this: Slider, other: Slider): bool {.error: "juce::Slider defines no operator==; compare a property instead".}

proc makeTableHeaderComponent*(): TableHeaderComponent {.header: juce_gui_basics, importcpp: "juce::TableHeaderComponent(@)".}
proc addColumn*(this: var TableHeaderComponent, columnName: String, columnId: cint, width: cint, minimumWidth: cint = 30, maximumWidth: cint = -1, propertyFlags: cint, insertIndex: cint = -1) {.header: juce_gui_basics, importcpp: "#.addColumn(@)".}
proc removeColumn*(this: var TableHeaderComponent, columnIdToRemove: cint) {.header: juce_gui_basics, importcpp: "#.removeColumn(@)".}
proc removeAllColumns*(this: var TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.removeAllColumns()".}
proc getNumColumns*(this: TableHeaderComponent, onlyCountVisibleColumns: bool): cint {.header: juce_gui_basics, importcpp: "#.getNumColumns(@)".}
proc getColumnName*(this: TableHeaderComponent, columnId: cint): String {.header: juce_gui_basics, importcpp: "#.getColumnName(@)".}
proc setColumnName*(this: var TableHeaderComponent, columnId: cint, newName: String) {.header: juce_gui_basics, importcpp: "#.setColumnName(@)".}
proc moveColumn*(this: var TableHeaderComponent, columnId: cint, newVisibleIndex: cint) {.header: juce_gui_basics, importcpp: "#.moveColumn(@)".}
proc getColumnWidth*(this: TableHeaderComponent, columnId: cint): cint {.header: juce_gui_basics, importcpp: "#.getColumnWidth(@)".}
proc setColumnWidth*(this: var TableHeaderComponent, columnId: cint, newWidth: cint) {.header: juce_gui_basics, importcpp: "#.setColumnWidth(@)".}
proc setColumnVisible*(this: var TableHeaderComponent, columnId: cint, shouldBeVisible: bool) {.header: juce_gui_basics, importcpp: "#.setColumnVisible(@)".}
proc isColumnVisible*(this: TableHeaderComponent, columnId: cint): bool {.header: juce_gui_basics, importcpp: "#.isColumnVisible(@)".}
proc setSortColumnId*(this: var TableHeaderComponent, columnId: cint, sortForwards: bool) {.header: juce_gui_basics, importcpp: "#.setSortColumnId(@)".}
proc getSortColumnId*(this: TableHeaderComponent): cint {.header: juce_gui_basics, importcpp: "#.getSortColumnId()".}
proc isSortedForwards*(this: TableHeaderComponent): bool {.header: juce_gui_basics, importcpp: "#.isSortedForwards()".}
proc reSortTable*(this: var TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.reSortTable()".}
proc getTotalWidth*(this: TableHeaderComponent): cint {.header: juce_gui_basics, importcpp: "#.getTotalWidth()".}
proc getIndexOfColumnId*(this: TableHeaderComponent, columnId: cint, onlyCountVisibleColumns: bool): cint {.header: juce_gui_basics, importcpp: "#.getIndexOfColumnId(@)".}
proc getColumnIdOfIndex*(this: TableHeaderComponent, index: cint, onlyCountVisibleColumns: bool): cint {.header: juce_gui_basics, importcpp: "#.getColumnIdOfIndex(@)".}
proc getColumnPosition*(this: TableHeaderComponent, index: cint): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getColumnPosition(@)".}
proc getColumnIdAtX*(this: TableHeaderComponent, xToFind: cint): cint {.header: juce_gui_basics, importcpp: "#.getColumnIdAtX(@)".}
proc setStretchToFitActive*(this: var TableHeaderComponent, shouldStretchToFit: bool) {.header: juce_gui_basics, importcpp: "#.setStretchToFitActive(@)".}
proc isStretchToFitActive*(this: TableHeaderComponent): bool {.header: juce_gui_basics, importcpp: "#.isStretchToFitActive()".}
proc resizeAllColumnsToFit*(this: var TableHeaderComponent, targetTotalWidth: cint) {.header: juce_gui_basics, importcpp: "#.resizeAllColumnsToFit(@)".}
proc setPopupMenuActive*(this: var TableHeaderComponent, hasMenu: bool) {.header: juce_gui_basics, importcpp: "#.setPopupMenuActive(@)".}
proc isPopupMenuActive*(this: TableHeaderComponent): bool {.header: juce_gui_basics, importcpp: "#.isPopupMenuActive()".}
proc toString*(this: TableHeaderComponent): String {.header: juce_gui_basics, importcpp: "#.toString()".}
proc restoreFromString*(this: var TableHeaderComponent, storedVersion: String) {.header: juce_gui_basics, importcpp: "#.restoreFromString(@)".}
proc addListener*(this: var TableHeaderComponent, newListener: ptr TableHeaderComponentListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var TableHeaderComponent, listenerToRemove: ptr TableHeaderComponentListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc columnClicked*(this: var TableHeaderComponent, columnId: cint, mods: ModifierKeys) {.header: juce_gui_basics, importcpp: "#.columnClicked(@)".}
proc addMenuItems*(this: var TableHeaderComponent, menu: var PopupMenu, columnIdClicked: cint) {.header: juce_gui_basics, importcpp: "#.addMenuItems(@)".}
proc reactToMenuItem*(this: var TableHeaderComponent, menuReturnId: cint, columnIdClicked: cint) {.header: juce_gui_basics, importcpp: "#.reactToMenuItem(@)".}
proc paint*(this: var TableHeaderComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc mouseMove*(this: var TableHeaderComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseMove(@)".}
proc mouseEnter*(this: var TableHeaderComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseEnter(@)".}
proc mouseExit*(this: var TableHeaderComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseExit(@)".}
proc mouseDown*(this: var TableHeaderComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc mouseDrag*(this: var TableHeaderComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var TableHeaderComponent, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc getMouseCursor*(this: var TableHeaderComponent): MouseCursor {.header: juce_gui_basics, importcpp: "#.getMouseCursor()".}
proc createAccessibilityHandler*(this: var TableHeaderComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc showColumnChooserMenu*(this: var TableHeaderComponent, columnIdClicked: cint) {.header: juce_gui_basics, importcpp: "#.showColumnChooserMenu(@)".}
proc `==`*(this: TableHeaderComponent, other: TableHeaderComponent): bool {.error: "juce::TableHeaderComponent defines no operator==; compare a property instead".}

proc makeTableListBoxModel*(): TableListBoxModel {.header: juce_gui_basics, importcpp: "juce::TableListBoxModel(@)".}
proc getNumRows*(this: var TableListBoxModel): cint {.header: juce_gui_basics, importcpp: "#.getNumRows()".}
proc paintRowBackground*(this: var TableListBoxModel, arg1: var Graphics, rowNumber: cint, width: cint, height: cint, rowIsSelected: bool) {.header: juce_gui_basics, importcpp: "#.paintRowBackground(@)".}
proc paintCell*(this: var TableListBoxModel, arg1: var Graphics, rowNumber: cint, columnId: cint, width: cint, height: cint, rowIsSelected: bool) {.header: juce_gui_basics, importcpp: "#.paintCell(@)".}
proc refreshComponentForCell*(this: var TableListBoxModel, rowNumber: cint, columnId: cint, isRowSelected: bool, existingComponentToUpdate: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.refreshComponentForCell(@)".}
proc cellClicked*(this: var TableListBoxModel, rowNumber: cint, columnId: cint, arg3: MouseEvent) {.header: juce_gui_basics, importcpp: "#.cellClicked(@)".}
proc cellDoubleClicked*(this: var TableListBoxModel, rowNumber: cint, columnId: cint, arg3: MouseEvent) {.header: juce_gui_basics, importcpp: "#.cellDoubleClicked(@)".}
proc backgroundClicked*(this: var TableListBoxModel, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.backgroundClicked(@)".}
proc sortOrderChanged*(this: var TableListBoxModel, newSortColumnId: cint, isForwards: bool) {.header: juce_gui_basics, importcpp: "#.sortOrderChanged(@)".}
proc getColumnAutoSizeWidth*(this: var TableListBoxModel, columnId: cint): cint {.header: juce_gui_basics, importcpp: "#.getColumnAutoSizeWidth(@)".}
proc getCellTooltip*(this: var TableListBoxModel, rowNumber: cint, columnId: cint): String {.header: juce_gui_basics, importcpp: "#.getCellTooltip(@)".}
proc selectedRowsChanged*(this: var TableListBoxModel, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.selectedRowsChanged(@)".}
proc deleteKeyPressed*(this: var TableListBoxModel, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.deleteKeyPressed(@)".}
proc returnKeyPressed*(this: var TableListBoxModel, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.returnKeyPressed(@)".}
proc listWasScrolled*(this: var TableListBoxModel) {.header: juce_gui_basics, importcpp: "#.listWasScrolled()".}
proc getDragSourceDescription*(this: var TableListBoxModel, currentlySelectedRows: SparseSet[cint]): juce_var {.header: juce_gui_basics, importcpp: "#.getDragSourceDescription(@)".}
proc mayDragToExternalWindows*(this: TableListBoxModel): bool {.header: juce_gui_basics, importcpp: "#.mayDragToExternalWindows()".}
proc `==`*(this: TableListBoxModel, other: TableListBoxModel): bool {.error: "juce::TableListBoxModel defines no operator==; compare a property instead".}

proc makeTableListBox*(componentName: String, model: ptr TableListBoxModel): TableListBox {.header: juce_gui_basics, importcpp: "juce::TableListBox(@)".}
proc setModel*(this: var TableListBox, newModel: ptr TableListBoxModel) {.header: juce_gui_basics, importcpp: "#.setModel(@)".}
proc getTableListBoxModel*(this: TableListBox): ptr TableListBoxModel {.header: juce_gui_basics, importcpp: "#.getTableListBoxModel()".}
proc getHeader*(this: TableListBox): var TableHeaderComponent {.header: juce_gui_basics, importcpp: "#.getHeader()".}
proc setHeader*(this: var TableListBox, newHeader: UniquePtr[TableHeaderComponent]) {.header: juce_gui_basics, importcpp: "#.setHeader(@)".}
proc setHeaderHeight*(this: var TableListBox, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setHeaderHeight(@)".}
proc getHeaderHeight*(this: TableListBox): cint {.header: juce_gui_basics, importcpp: "#.getHeaderHeight()".}
proc autoSizeColumn*(this: var TableListBox, columnId: cint) {.header: juce_gui_basics, importcpp: "#.autoSizeColumn(@)".}
proc autoSizeAllColumns*(this: var TableListBox) {.header: juce_gui_basics, importcpp: "#.autoSizeAllColumns()".}
proc setAutoSizeMenuOptionShown*(this: var TableListBox, shouldBeShown: bool) {.header: juce_gui_basics, importcpp: "#.setAutoSizeMenuOptionShown(@)".}
proc isAutoSizeMenuOptionShown*(this: TableListBox): bool {.header: juce_gui_basics, importcpp: "#.isAutoSizeMenuOptionShown()".}
proc getCellPosition*(this: TableListBox, columnId: cint, rowNumber: cint, relativeToComponentTopLeft: bool): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getCellPosition(@)".}
proc getCellComponent*(this: TableListBox, columnId: cint, rowNumber: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getCellComponent(@)".}
proc scrollToEnsureColumnIsOnscreen*(this: var TableListBox, columnId: cint) {.header: juce_gui_basics, importcpp: "#.scrollToEnsureColumnIsOnscreen(@)".}
proc getNumRows*(this: var TableListBox): cint {.header: juce_gui_basics, importcpp: "#.getNumRows()".}
proc paintListBoxItem*(this: var TableListBox, arg1: cint, arg2: var Graphics, arg3: cint, arg4: cint, arg5: bool) {.header: juce_gui_basics, importcpp: "#.paintListBoxItem(@)".}
proc refreshComponentForRow*(this: var TableListBox, rowNumber: cint, isRowSelected: bool, existingComponentToUpdate: ptr Component): ptr Component {.header: juce_gui_basics, importcpp: "#.refreshComponentForRow(@)".}
proc selectedRowsChanged*(this: var TableListBox, row: cint) {.header: juce_gui_basics, importcpp: "#.selectedRowsChanged(@)".}
proc deleteKeyPressed*(this: var TableListBox, currentSelectedRow: cint) {.header: juce_gui_basics, importcpp: "#.deleteKeyPressed(@)".}
proc returnKeyPressed*(this: var TableListBox, currentSelectedRow: cint) {.header: juce_gui_basics, importcpp: "#.returnKeyPressed(@)".}
proc backgroundClicked*(this: var TableListBox, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.backgroundClicked(@)".}
proc listWasScrolled*(this: var TableListBox) {.header: juce_gui_basics, importcpp: "#.listWasScrolled()".}
proc tableColumnsChanged*(this: var TableListBox, arg1: ptr TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.tableColumnsChanged(@)".}
proc tableColumnsResized*(this: var TableListBox, arg1: ptr TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.tableColumnsResized(@)".}
proc tableSortOrderChanged*(this: var TableListBox, arg1: ptr TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.tableSortOrderChanged(@)".}
proc tableColumnDraggingChanged*(this: var TableListBox, arg1: ptr TableHeaderComponent, arg2: cint) {.header: juce_gui_basics, importcpp: "#.tableColumnDraggingChanged(@)".}
proc resized*(this: var TableListBox) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc createAccessibilityHandler*(this: var TableListBox): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc getModel*(this: TableListBox): ptr TableListBoxModel {.header: juce_gui_basics, importcpp: "#.getModel()".}
proc `==`*(this: TableListBox, other: TableListBox): bool {.error: "juce::TableListBox defines no operator==; compare a property instead".}

proc makeToolbar*(): Toolbar {.header: juce_gui_basics, importcpp: "juce::Toolbar(@)".}
proc setVertical*(this: var Toolbar, shouldBeVertical: bool) {.header: juce_gui_basics, importcpp: "#.setVertical(@)".}
proc isVertical*(this: Toolbar): bool {.header: juce_gui_basics, importcpp: "#.isVertical()".}
proc getThickness*(this: Toolbar): cint {.header: juce_gui_basics, importcpp: "#.getThickness()".}
proc getLength*(this: Toolbar): cint {.header: juce_gui_basics, importcpp: "#.getLength()".}
proc clear*(this: var Toolbar) {.header: juce_gui_basics, importcpp: "#.clear()".}
proc addItem*(this: var Toolbar, factory: var ToolbarItemFactory, itemId: cint, insertIndex: cint = -1) {.header: juce_gui_basics, importcpp: "#.addItem(@)".}
proc removeToolbarItem*(this: var Toolbar, itemIndex: cint) {.header: juce_gui_basics, importcpp: "#.removeToolbarItem(@)".}
proc removeAndReturnItem*(this: var Toolbar, itemIndex: cint): ptr ToolbarItemComponent {.header: juce_gui_basics, importcpp: "#.removeAndReturnItem(@)".}
proc getNumItems*(this: Toolbar): cint {.header: juce_gui_basics, importcpp: "#.getNumItems()".}
proc getItemId*(this: Toolbar, itemIndex: cint): cint {.header: juce_gui_basics, importcpp: "#.getItemId(@)".}
proc getItemComponent*(this: Toolbar, itemIndex: cint): ptr ToolbarItemComponent {.header: juce_gui_basics, importcpp: "#.getItemComponent(@)".}
proc addDefaultItems*(this: var Toolbar, factoryToUse: var ToolbarItemFactory) {.header: juce_gui_basics, importcpp: "#.addDefaultItems(@)".}
proc getStyle*(this: Toolbar): ToolbarToolbarItemStyle {.header: juce_gui_basics, importcpp: "#.getStyle()".}
proc setStyle*(this: var Toolbar, newStyle: ToolbarToolbarItemStyle) {.header: juce_gui_basics, importcpp: "#.setStyle(@)".}
proc showCustomisationDialog*(this: var Toolbar, factory: var ToolbarItemFactory, optionFlags: cint) {.header: juce_gui_basics, importcpp: "#.showCustomisationDialog(@)".}
proc setEditingActive*(this: var Toolbar, editingEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setEditingActive(@)".}
proc toString*(this: Toolbar): String {.header: juce_gui_basics, importcpp: "#.toString()".}
proc restoreFromString*(this: var Toolbar, factoryToUse: var ToolbarItemFactory, savedVersion: String): bool {.header: juce_gui_basics, importcpp: "#.restoreFromString(@)".}
proc paint*(this: var Toolbar, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var Toolbar) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc mouseDown*(this: var Toolbar, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDown(@)".}
proc isInterestedInDragSource*(this: var Toolbar, arg1: DragAndDropTargetSourceDetails): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInDragSource(@)".}
proc itemDragMove*(this: var Toolbar, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragMove(@)".}
proc itemDragExit*(this: var Toolbar, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragExit(@)".}
proc itemDropped*(this: var Toolbar, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDropped(@)".}
proc lookAndFeelChanged*(this: var Toolbar) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc updateAllItemPositions*(this: var Toolbar, animate: bool) {.header: juce_gui_basics, importcpp: "#.updateAllItemPositions(@)".}
proc createAccessibilityHandler*(this: var Toolbar): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: Toolbar, other: Toolbar): bool {.error: "juce::Toolbar defines no operator==; compare a property instead".}

proc makeToolbarItemComponent*(itemId: cint, labelText: String, isBeingUsedAsAButton: bool): ToolbarItemComponent {.header: juce_gui_basics, importcpp: "juce::ToolbarItemComponent(@)".}
proc getItemId*(this: ToolbarItemComponent): cint {.header: juce_gui_basics, importcpp: "#.getItemId()".}
proc getToolbar*(this: ToolbarItemComponent): ptr Toolbar {.header: juce_gui_basics, importcpp: "#.getToolbar()".}
proc isToolbarVertical*(this: ToolbarItemComponent): bool {.header: juce_gui_basics, importcpp: "#.isToolbarVertical()".}
proc getStyle*(this: ToolbarItemComponent): ToolbarToolbarItemStyle {.header: juce_gui_basics, importcpp: "#.getStyle()".}
proc setStyle*(this: var ToolbarItemComponent, newStyle: ToolbarToolbarItemStyle) {.header: juce_gui_basics, importcpp: "#.setStyle(@)".}
proc getContentArea*(this: ToolbarItemComponent): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getContentArea()".}
proc getToolbarItemSizes*(this: var ToolbarItemComponent, toolbarThickness: cint, isToolbarVertical: bool, preferredSize: var cint, minSize: var cint, maxSize: var cint): bool {.header: juce_gui_basics, importcpp: "#.getToolbarItemSizes(@)".}
proc paintButtonArea*(this: var ToolbarItemComponent, g: var Graphics, width: cint, height: cint, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.paintButtonArea(@)".}
proc contentAreaChanged*(this: var ToolbarItemComponent, newBounds: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.contentAreaChanged(@)".}
proc setEditingMode*(this: var ToolbarItemComponent, newMode: ToolbarItemComponentToolbarEditingMode) {.header: juce_gui_basics, importcpp: "#.setEditingMode(@)".}
proc getEditingMode*(this: ToolbarItemComponent): ToolbarItemComponentToolbarEditingMode {.header: juce_gui_basics, importcpp: "#.getEditingMode()".}
proc paintButton*(this: var ToolbarItemComponent, arg1: var Graphics, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.paintButton(@)".}
proc resized*(this: var ToolbarItemComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc createAccessibilityHandler*(this: var ToolbarItemComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ToolbarItemComponent, other: ToolbarItemComponent): bool {.error: "juce::ToolbarItemComponent defines no operator==; compare a property instead".}

proc makeToolbarItemFactory*(): ToolbarItemFactory {.header: juce_gui_basics, importcpp: "juce::ToolbarItemFactory(@)".}
proc getAllToolbarItemIds*(this: var ToolbarItemFactory, ids: Array[cint]) {.header: juce_gui_basics, importcpp: "#.getAllToolbarItemIds(@)".}
proc getDefaultItemSet*(this: var ToolbarItemFactory, ids: Array[cint]) {.header: juce_gui_basics, importcpp: "#.getDefaultItemSet(@)".}
proc createItem*(this: var ToolbarItemFactory, itemId: cint): ptr ToolbarItemComponent {.header: juce_gui_basics, importcpp: "#.createItem(@)".}
proc `==`*(this: ToolbarItemFactory, other: ToolbarItemFactory): bool {.error: "juce::ToolbarItemFactory defines no operator==; compare a property instead".}

proc makeToolbarItemPalette*(factory: var ToolbarItemFactory, toolbar: var Toolbar): ToolbarItemPalette {.header: juce_gui_basics, importcpp: "juce::ToolbarItemPalette(@)".}
proc resized*(this: var ToolbarItemPalette) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc createAccessibilityHandler*(this: var ToolbarItemPalette): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ToolbarItemPalette, other: ToolbarItemPalette): bool {.error: "juce::ToolbarItemPalette defines no operator==; compare a property instead".}

proc makeBurgerMenuComponent*(model: ptr MenuBarModel): BurgerMenuComponent {.header: juce_gui_basics, importcpp: "juce::BurgerMenuComponent(@)".}
proc setModel*(this: var BurgerMenuComponent, newModel: ptr MenuBarModel) {.header: juce_gui_basics, importcpp: "#.setModel(@)".}
proc getModel*(this: BurgerMenuComponent): ptr MenuBarModel {.header: juce_gui_basics, importcpp: "#.getModel()".}
proc lookAndFeelChanged*(this: var BurgerMenuComponent) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc createAccessibilityHandler*(this: var BurgerMenuComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: BurgerMenuComponent, other: BurgerMenuComponent): bool {.error: "juce::BurgerMenuComponent defines no operator==; compare a property instead".}

proc makeToolbarButton*(itemId: cint, labelText: String, normalImage: UniquePtr[Drawable], toggledOnImage: UniquePtr[Drawable]): ToolbarButton {.header: juce_gui_basics, importcpp: "juce::ToolbarButton(@)".}
proc getToolbarItemSizes*(this: var ToolbarButton, toolbarDepth: cint, isToolbarVertical: bool, preferredSize: var cint, minSize: var cint, maxSize: var cint): bool {.header: juce_gui_basics, importcpp: "#.getToolbarItemSizes(@)".}
proc paintButtonArea*(this: var ToolbarButton, arg1: var Graphics, width: cint, height: cint, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.paintButtonArea(@)".}
proc contentAreaChanged*(this: var ToolbarButton, arg1: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.contentAreaChanged(@)".}
proc buttonStateChanged*(this: var ToolbarButton) {.header: juce_gui_basics, importcpp: "#.buttonStateChanged()".}
proc resized*(this: var ToolbarButton) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc enablementChanged*(this: var ToolbarButton) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc `==`*(this: ToolbarButton, other: ToolbarButton): bool {.error: "juce::ToolbarButton defines no operator==; compare a property instead".}

proc makeDropShadower*(shadowType: DropShadow): DropShadower {.header: juce_gui_basics, importcpp: "juce::DropShadower(@)".}
proc setOwner*(this: var DropShadower, componentToFollow: ptr Component) {.header: juce_gui_basics, importcpp: "#.setOwner(@)".}
proc `==`*(this: DropShadower, other: DropShadower): bool {.error: "juce::DropShadower defines no operator==; compare a property instead".}

proc makeFocusOutline*(props: UniquePtr[FocusOutlineOutlineWindowProperties]): FocusOutline {.header: juce_gui_basics, importcpp: "juce::FocusOutline(@)".}
proc setOwner*(this: var FocusOutline, componentToFollow: ptr Component) {.header: juce_gui_basics, importcpp: "#.setOwner(@)".}
proc `==`*(this: FocusOutline, other: FocusOutline): bool {.error: "juce::FocusOutline defines no operator==; compare a property instead".}

proc makeTreeViewItem*(): TreeViewItem {.header: juce_gui_basics, importcpp: "juce::TreeViewItem(@)".}
proc getNumSubItems*(this: TreeViewItem): cint {.header: juce_gui_basics, importcpp: "#.getNumSubItems()".}
proc getSubItem*(this: TreeViewItem, index: cint): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.getSubItem(@)".}
proc clearSubItems*(this: var TreeViewItem) {.header: juce_gui_basics, importcpp: "#.clearSubItems()".}
proc addSubItem*(this: var TreeViewItem, newItem: ptr TreeViewItem, insertPosition: cint = -1) {.header: juce_gui_basics, importcpp: "#.addSubItem(@)".}
proc removeSubItem*(this: var TreeViewItem, index: cint, deleteItem: bool = true) {.header: juce_gui_basics, importcpp: "#.removeSubItem(@)".}
proc getOwnerView*(this: TreeViewItem): ptr TreeView {.header: juce_gui_basics, importcpp: "#.getOwnerView()".}
proc getParentItem*(this: TreeViewItem): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.getParentItem()".}
proc isOpen*(this: TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.isOpen()".}
proc setOpen*(this: var TreeViewItem, shouldBeOpen: bool) {.header: juce_gui_basics, importcpp: "#.setOpen(@)".}
proc getOpenness*(this: TreeViewItem): TreeViewItemOpenness {.header: juce_gui_basics, importcpp: "#.getOpenness()".}
proc setOpenness*(this: var TreeViewItem, newOpenness: TreeViewItemOpenness) {.header: juce_gui_basics, importcpp: "#.setOpenness(@)".}
proc isSelected*(this: TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.isSelected()".}
proc setSelected*(this: var TreeViewItem, shouldBeSelected: bool, deselectOtherItemsFirst: bool, shouldNotify: NotificationType) {.header: juce_gui_basics, importcpp: "#.setSelected(@)".}
proc getItemPosition*(this: TreeViewItem, relativeToTreeViewTopLeft: bool): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getItemPosition(@)".}
proc treeHasChanged*(this: TreeViewItem) {.header: juce_gui_basics, importcpp: "#.treeHasChanged()".}
proc repaintItem*(this: TreeViewItem) {.header: juce_gui_basics, importcpp: "#.repaintItem()".}
proc getRowNumberInTree*(this: TreeViewItem): cint {.header: juce_gui_basics, importcpp: "#.getRowNumberInTree()".}
proc areAllParentsOpen*(this: TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.areAllParentsOpen()".}
proc setLinesDrawnForSubItems*(this: var TreeViewItem, shouldDrawLines: bool) {.header: juce_gui_basics, importcpp: "#.setLinesDrawnForSubItems(@)".}
proc mightContainSubItems*(this: var TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.mightContainSubItems()".}
proc getUniqueName*(this: TreeViewItem): String {.header: juce_gui_basics, importcpp: "#.getUniqueName()".}
proc itemOpennessChanged*(this: var TreeViewItem, isNowOpen: bool) {.header: juce_gui_basics, importcpp: "#.itemOpennessChanged(@)".}
proc getItemWidth*(this: TreeViewItem): cint {.header: juce_gui_basics, importcpp: "#.getItemWidth()".}
proc getItemHeight*(this: TreeViewItem): cint {.header: juce_gui_basics, importcpp: "#.getItemHeight()".}
proc canBeSelected*(this: TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.canBeSelected()".}
proc createItemComponent*(this: var TreeViewItem): UniquePtr[Component] {.header: juce_gui_basics, importcpp: "#.createItemComponent()".}
proc paintItem*(this: var TreeViewItem, g: var Graphics, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.paintItem(@)".}
proc paintOpenCloseButton*(this: var TreeViewItem, arg1: var Graphics, area: Rectangle[cfloat], backgroundColour: Colour, isMouseOver: bool) {.header: juce_gui_basics, importcpp: "#.paintOpenCloseButton(@)".}
proc paintHorizontalConnectingLine*(this: var TreeViewItem, arg1: var Graphics, line: Line[cfloat]) {.header: juce_gui_basics, importcpp: "#.paintHorizontalConnectingLine(@)".}
proc paintVerticalConnectingLine*(this: var TreeViewItem, arg1: var Graphics, line: Line[cfloat]) {.header: juce_gui_basics, importcpp: "#.paintVerticalConnectingLine(@)".}
proc customComponentUsesTreeViewMouseHandler*(this: TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.customComponentUsesTreeViewMouseHandler()".}
proc itemClicked*(this: var TreeViewItem, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.itemClicked(@)".}
proc itemDoubleClicked*(this: var TreeViewItem, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.itemDoubleClicked(@)".}
proc itemSelectionChanged*(this: var TreeViewItem, isNowSelected: bool) {.header: juce_gui_basics, importcpp: "#.itemSelectionChanged(@)".}
proc ownerViewChanged*(this: var TreeViewItem, newOwner: ptr TreeView) {.header: juce_gui_basics, importcpp: "#.ownerViewChanged(@)".}
proc getTooltip*(this: var TreeViewItem): String {.header: juce_gui_basics, importcpp: "#.getTooltip()".}
proc getAccessibilityName*(this: var TreeViewItem): String {.header: juce_gui_basics, importcpp: "#.getAccessibilityName()".}
proc getDragSourceDescription*(this: var TreeViewItem): juce_var {.header: juce_gui_basics, importcpp: "#.getDragSourceDescription()".}
proc isInterestedInFileDrag*(this: var TreeViewItem, files: StringArray): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInFileDrag(@)".}
proc filesDropped*(this: var TreeViewItem, files: StringArray, insertIndex: cint) {.header: juce_gui_basics, importcpp: "#.filesDropped(@)".}
proc isInterestedInDragSource*(this: var TreeViewItem, dragSourceDetails: DragAndDropTargetSourceDetails): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInDragSource(@)".}
proc itemDropped*(this: var TreeViewItem, dragSourceDetails: DragAndDropTargetSourceDetails, insertIndex: cint) {.header: juce_gui_basics, importcpp: "#.itemDropped(@)".}
proc setDrawsInLeftMargin*(this: var TreeViewItem, canDrawInLeftMargin: bool) {.header: juce_gui_basics, importcpp: "#.setDrawsInLeftMargin(@)".}
proc setDrawsInRightMargin*(this: var TreeViewItem, canDrawInRightMargin: bool) {.header: juce_gui_basics, importcpp: "#.setDrawsInRightMargin(@)".}
proc getOpennessState*(this: TreeViewItem): UniquePtr[XmlElement] {.header: juce_gui_basics, importcpp: "#.getOpennessState()".}
proc restoreOpennessState*(this: var TreeViewItem, xml: XmlElement) {.header: juce_gui_basics, importcpp: "#.restoreOpennessState(@)".}
proc getIndexInParent*(this: TreeViewItem): cint {.header: juce_gui_basics, importcpp: "#.getIndexInParent()".}
proc isLastOfSiblings*(this: TreeViewItem): bool {.header: juce_gui_basics, importcpp: "#.isLastOfSiblings()".}
proc getItemIdentifierString*(this: TreeViewItem): String {.header: juce_gui_basics, importcpp: "#.getItemIdentifierString()".}
proc `==`*(this: TreeViewItem, other: TreeViewItem): bool {.error: "juce::TreeViewItem defines no operator==; compare a property instead".}

proc makeTreeView*(componentName: String): TreeView {.header: juce_gui_basics, importcpp: "juce::TreeView(@)".}
proc setRootItem*(this: var TreeView, newRootItem: ptr TreeViewItem) {.header: juce_gui_basics, importcpp: "#.setRootItem(@)".}
proc getRootItem*(this: TreeView): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.getRootItem()".}
proc deleteRootItem*(this: var TreeView) {.header: juce_gui_basics, importcpp: "#.deleteRootItem()".}
proc setRootItemVisible*(this: var TreeView, shouldBeVisible: bool) {.header: juce_gui_basics, importcpp: "#.setRootItemVisible(@)".}
proc isRootItemVisible*(this: TreeView): bool {.header: juce_gui_basics, importcpp: "#.isRootItemVisible()".}
proc setDefaultOpenness*(this: var TreeView, isOpenByDefault: bool) {.header: juce_gui_basics, importcpp: "#.setDefaultOpenness(@)".}
proc areItemsOpenByDefault*(this: TreeView): bool {.header: juce_gui_basics, importcpp: "#.areItemsOpenByDefault()".}
proc setMultiSelectEnabled*(this: var TreeView, canMultiSelect: bool) {.header: juce_gui_basics, importcpp: "#.setMultiSelectEnabled(@)".}
proc isMultiSelectEnabled*(this: TreeView): bool {.header: juce_gui_basics, importcpp: "#.isMultiSelectEnabled()".}
proc setOpenCloseButtonsVisible*(this: var TreeView, shouldBeVisible: bool) {.header: juce_gui_basics, importcpp: "#.setOpenCloseButtonsVisible(@)".}
proc areOpenCloseButtonsVisible*(this: TreeView): bool {.header: juce_gui_basics, importcpp: "#.areOpenCloseButtonsVisible()".}
proc clearSelectedItems*(this: var TreeView) {.header: juce_gui_basics, importcpp: "#.clearSelectedItems()".}
proc getNumSelectedItems*(this: TreeView, maximumDepthToSearchTo: cint = -1): cint {.header: juce_gui_basics, importcpp: "#.getNumSelectedItems(@)".}
proc getSelectedItem*(this: TreeView, index: cint): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.getSelectedItem(@)".}
proc moveSelectedRow*(this: var TreeView, deltaRows: cint) {.header: juce_gui_basics, importcpp: "#.moveSelectedRow(@)".}
proc getNumRowsInTree*(this: TreeView): cint {.header: juce_gui_basics, importcpp: "#.getNumRowsInTree()".}
proc getItemOnRow*(this: TreeView, index: cint): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.getItemOnRow(@)".}
proc getItemAt*(this: TreeView, yPosition: cint): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.getItemAt(@)".}
proc scrollToKeepItemVisible*(this: var TreeView, item: ptr TreeViewItem) {.header: juce_gui_basics, importcpp: "#.scrollToKeepItemVisible(@)".}
proc getViewport*(this: TreeView): ptr Viewport {.header: juce_gui_basics, importcpp: "#.getViewport()".}
proc getIndentSize*(this: var TreeView): cint {.header: juce_gui_basics, importcpp: "#.getIndentSize()".}
proc setIndentSize*(this: var TreeView, newIndentSize: cint) {.header: juce_gui_basics, importcpp: "#.setIndentSize(@)".}
proc findItemFromIdentifierString*(this: TreeView, identifierString: String): ptr TreeViewItem {.header: juce_gui_basics, importcpp: "#.findItemFromIdentifierString(@)".}
proc getItemComponent*(this: TreeView, item: ptr TreeViewItem): ptr Component {.header: juce_gui_basics, importcpp: "#.getItemComponent(@)".}
proc getOpennessState*(this: TreeView, alsoIncludeScrollPosition: bool): UniquePtr[XmlElement] {.header: juce_gui_basics, importcpp: "#.getOpennessState(@)".}
proc restoreOpennessState*(this: var TreeView, newState: XmlElement, restoreStoredSelection: bool) {.header: juce_gui_basics, importcpp: "#.restoreOpennessState(@)".}
proc paint*(this: var TreeView, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var TreeView) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc keyPressed*(this: var TreeView, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc colourChanged*(this: var TreeView) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc enablementChanged*(this: var TreeView) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc isInterestedInFileDrag*(this: var TreeView, arg1: StringArray): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInFileDrag(@)".}
proc fileDragEnter*(this: var TreeView, arg1: StringArray, arg2: cint, arg3: cint) {.header: juce_gui_basics, importcpp: "#.fileDragEnter(@)".}
proc fileDragMove*(this: var TreeView, arg1: StringArray, arg2: cint, arg3: cint) {.header: juce_gui_basics, importcpp: "#.fileDragMove(@)".}
proc fileDragExit*(this: var TreeView, arg1: StringArray) {.header: juce_gui_basics, importcpp: "#.fileDragExit(@)".}
proc filesDropped*(this: var TreeView, arg1: StringArray, arg2: cint, arg3: cint) {.header: juce_gui_basics, importcpp: "#.filesDropped(@)".}
proc isInterestedInDragSource*(this: var TreeView, arg1: DragAndDropTargetSourceDetails): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInDragSource(@)".}
proc itemDragEnter*(this: var TreeView, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragEnter(@)".}
proc itemDragMove*(this: var TreeView, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragMove(@)".}
proc itemDragExit*(this: var TreeView, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDragExit(@)".}
proc itemDropped*(this: var TreeView, arg1: DragAndDropTargetSourceDetails) {.header: juce_gui_basics, importcpp: "#.itemDropped(@)".}
proc createAccessibilityHandler*(this: var TreeView): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: TreeView, other: TreeView): bool {.error: "juce::TreeView defines no operator==; compare a property instead".}

proc makeTopLevelWindow*(name: String, addToDesktop: bool): TopLevelWindow {.header: juce_gui_basics, importcpp: "juce::TopLevelWindow(@)".}
proc isActiveWindow*(this: TopLevelWindow): bool {.header: juce_gui_basics, importcpp: "#.isActiveWindow()".}
proc centreAroundComponent*(this: var TopLevelWindow, componentToCentreAround: ptr Component, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.centreAroundComponent(@)".}
proc setDropShadowEnabled*(this: var TopLevelWindow, useShadow: bool) {.header: juce_gui_basics, importcpp: "#.setDropShadowEnabled(@)".}
proc isDropShadowEnabled*(this: TopLevelWindow): bool {.header: juce_gui_basics, importcpp: "#.isDropShadowEnabled()".}
proc setUsingNativeTitleBar*(this: var TopLevelWindow, useNativeTitleBar: bool) {.header: juce_gui_basics, importcpp: "#.setUsingNativeTitleBar(@)".}
proc isUsingNativeTitleBar*(this: TopLevelWindow): bool {.header: juce_gui_basics, importcpp: "#.isUsingNativeTitleBar()".}
proc addToDesktop*(this: var TopLevelWindow) {.header: juce_gui_basics, importcpp: "#.addToDesktop()".}
proc addToDesktop*(this: var TopLevelWindow, windowStyleFlags: cint, nativeWindowToAttachTo: pointer = nil) {.header: juce_gui_basics, importcpp: "#.addToDesktop(@)".}
proc createAccessibilityHandler*(this: var TopLevelWindow): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: TopLevelWindow, other: TopLevelWindow): bool {.error: "juce::TopLevelWindow defines no operator==; compare a property instead".}

proc makeMessageBoxOptions*(): MessageBoxOptions {.header: juce_gui_basics, importcpp: "juce::MessageBoxOptions(@)".}
proc `MessageBoxOptions=`*(this: var MessageBoxOptions, arg1: MessageBoxOptions): var MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc withIconType*(this: MessageBoxOptions, `type`: MessageBoxIconType): MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.withIconType(@)".}
proc withTitle*(this: MessageBoxOptions, boxTitle: String): MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.withTitle(@)".}
proc withMessage*(this: MessageBoxOptions, boxMessage: String): MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.withMessage(@)".}
proc withButton*(this: MessageBoxOptions, text: String): MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.withButton(@)".}
proc withAssociatedComponent*(this: MessageBoxOptions, component: ptr Component): MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.withAssociatedComponent(@)".}
proc withParentComponent*(this: MessageBoxOptions, component: ptr Component): MessageBoxOptions {.header: juce_gui_basics, importcpp: "#.withParentComponent(@)".}
proc getIconType*(this: MessageBoxOptions): MessageBoxIconType {.header: juce_gui_basics, importcpp: "#.getIconType()".}
proc getTitle*(this: MessageBoxOptions): String {.header: juce_gui_basics, importcpp: "#.getTitle()".}
proc getMessage*(this: MessageBoxOptions): String {.header: juce_gui_basics, importcpp: "#.getMessage()".}
proc getNumButtons*(this: MessageBoxOptions): cint {.header: juce_gui_basics, importcpp: "#.getNumButtons()".}
proc getButtonText*(this: MessageBoxOptions, buttonIndex: cint): String {.header: juce_gui_basics, importcpp: "#.getButtonText(@)".}
proc getAssociatedComponent*(this: MessageBoxOptions): ptr Component {.header: juce_gui_basics, importcpp: "#.getAssociatedComponent()".}
proc getParentComponent*(this: MessageBoxOptions): ptr Component {.header: juce_gui_basics, importcpp: "#.getParentComponent()".}
proc `==`*(this: MessageBoxOptions, other: MessageBoxOptions): bool {.error: "juce::MessageBoxOptions defines no operator==; compare a property instead".}

# proc makeScopedMessageBox*(arg1: std::shared_ptr<detail::ScopedMessageBoxImpl>): ScopedMessageBox {.header: juce_gui_basics, importcpp: "juce::ScopedMessageBox(@)".}  # a type that cannot be spelled in Nim
proc makeScopedMessageBox*(): ScopedMessageBox {.header: juce_gui_basics, importcpp: "juce::ScopedMessageBox(@)".}
proc `ScopedMessageBox=`*(this: var ScopedMessageBox, arg1: ScopedMessageBox): var ScopedMessageBox {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc close*(this: var ScopedMessageBox) {.header: juce_gui_basics, importcpp: "#.close()".}
proc `==`*(this: ScopedMessageBox, other: ScopedMessageBox): bool {.error: "juce::ScopedMessageBox defines no operator==; compare a property instead".}

proc makeAlertWindow*(title: String, message: String, iconType: MessageBoxIconType, associatedComponent: ptr Component): AlertWindow {.header: juce_gui_basics, importcpp: "juce::AlertWindow(@)".}
proc getAlertType*(this: AlertWindow): MessageBoxIconType {.header: juce_gui_basics, importcpp: "#.getAlertType()".}
proc setMessage*(this: var AlertWindow, message: String) {.header: juce_gui_basics, importcpp: "#.setMessage(@)".}
proc addButton*(this: var AlertWindow, name: String, returnValue: cint, shortcutKey1: KeyPress, shortcutKey2: KeyPress) {.header: juce_gui_basics, importcpp: "#.addButton(@)".}
proc getNumButtons*(this: AlertWindow): cint {.header: juce_gui_basics, importcpp: "#.getNumButtons()".}
proc getButton*(this: AlertWindow, index: cint): ptr Button {.header: juce_gui_basics, importcpp: "#.getButton(@)".}
proc getButton*(this: AlertWindow, buttonName: String): ptr Button {.header: juce_gui_basics, importcpp: "#.getButton(@)".}
proc triggerButtonClick*(this: var AlertWindow, buttonName: String) {.header: juce_gui_basics, importcpp: "#.triggerButtonClick(@)".}
proc setEscapeKeyCancels*(this: var AlertWindow, shouldEscapeKeyCancel: bool) {.header: juce_gui_basics, importcpp: "#.setEscapeKeyCancels(@)".}
proc addTextEditor*(this: var AlertWindow, name: String, initialContents: String, onScreenLabel: String, isPasswordBox: bool = false) {.header: juce_gui_basics, importcpp: "#.addTextEditor(@)".}
proc getTextEditorContents*(this: AlertWindow, nameOfTextEditor: String): String {.header: juce_gui_basics, importcpp: "#.getTextEditorContents(@)".}
proc getTextEditor*(this: AlertWindow, nameOfTextEditor: String): ptr TextEditor {.header: juce_gui_basics, importcpp: "#.getTextEditor(@)".}
proc addComboBox*(this: var AlertWindow, name: String, items: StringArray, onScreenLabel: String) {.header: juce_gui_basics, importcpp: "#.addComboBox(@)".}
proc getComboBoxComponent*(this: AlertWindow, nameOfList: String): ptr ComboBox {.header: juce_gui_basics, importcpp: "#.getComboBoxComponent(@)".}
proc addTextBlock*(this: var AlertWindow, text: String) {.header: juce_gui_basics, importcpp: "#.addTextBlock(@)".}
proc addProgressBarComponent*(this: var AlertWindow, progressValue: var float64, style: CppOptional[ProgressBarStyle]) {.header: juce_gui_basics, importcpp: "#.addProgressBarComponent(@)".}
proc addCustomComponent*(this: var AlertWindow, component: ptr Component) {.header: juce_gui_basics, importcpp: "#.addCustomComponent(@)".}
proc getNumCustomComponents*(this: AlertWindow): cint {.header: juce_gui_basics, importcpp: "#.getNumCustomComponents()".}
proc getCustomComponent*(this: AlertWindow, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getCustomComponent(@)".}
proc removeCustomComponent*(this: var AlertWindow, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.removeCustomComponent(@)".}
proc containsAnyExtraComponents*(this: AlertWindow): bool {.header: juce_gui_basics, importcpp: "#.containsAnyExtraComponents()".}
proc createAccessibilityHandler*(this: var AlertWindow): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: AlertWindow, other: AlertWindow): bool {.error: "juce::AlertWindow defines no operator==; compare a property instead".}

proc makeCallOutBox*(contentComponent: var Component, areaToPointTo: Rectangle[cint], parentComponent: ptr Component): CallOutBox {.header: juce_gui_basics, importcpp: "juce::CallOutBox(@)".}
proc setArrowSize*(this: var CallOutBox, newSize: cfloat) {.header: juce_gui_basics, importcpp: "#.setArrowSize(@)".}
proc updatePosition*(this: var CallOutBox, newAreaToPointTo: Rectangle[cint], newAreaToFitIn: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.updatePosition(@)".}
proc dismiss*(this: var CallOutBox) {.header: juce_gui_basics, importcpp: "#.dismiss()".}
proc setDismissalMouseClicksAreAlwaysConsumed*(this: var CallOutBox, shouldAlwaysBeConsumed: bool) {.header: juce_gui_basics, importcpp: "#.setDismissalMouseClicksAreAlwaysConsumed(@)".}
proc paint*(this: var CallOutBox, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var CallOutBox) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc moved*(this: var CallOutBox) {.header: juce_gui_basics, importcpp: "#.moved()".}
proc childBoundsChanged*(this: var CallOutBox, arg1: ptr Component) {.header: juce_gui_basics, importcpp: "#.childBoundsChanged(@)".}
proc hitTest*(this: var CallOutBox, x: cint, y: cint): bool {.header: juce_gui_basics, importcpp: "#.hitTest(@)".}
proc inputAttemptWhenModal*(this: var CallOutBox) {.header: juce_gui_basics, importcpp: "#.inputAttemptWhenModal()".}
proc keyPressed*(this: var CallOutBox, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc handleCommandMessage*(this: var CallOutBox, arg1: cint) {.header: juce_gui_basics, importcpp: "#.handleCommandMessage(@)".}
proc getBorderSize*(this: CallOutBox): cint {.header: juce_gui_basics, importcpp: "#.getBorderSize()".}
proc lookAndFeelChanged*(this: var CallOutBox) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc createAccessibilityHandler*(this: var CallOutBox): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: CallOutBox, other: CallOutBox): bool {.error: "juce::CallOutBox defines no operator==; compare a property instead".}

proc makeComponentPeer*(component: var Component, styleFlags: cint): ComponentPeer {.header: juce_gui_basics, importcpp: "juce::ComponentPeer(@)".}
proc getComponent*(this: var ComponentPeer): var Component {.header: juce_gui_basics, importcpp: "#.getComponent()".}
proc getStyleFlags*(this: ComponentPeer): cint {.header: juce_gui_basics, importcpp: "#.getStyleFlags()".}
proc getUniqueID*(this: ComponentPeer): uint32 {.header: juce_gui_basics, importcpp: "#.getUniqueID()".}
proc getNativeHandle*(this: ComponentPeer): pointer {.header: juce_gui_basics, importcpp: "#.getNativeHandle()".}
proc setVisible*(this: var ComponentPeer, shouldBeVisible: bool) {.header: juce_gui_basics, importcpp: "#.setVisible(@)".}
proc setTitle*(this: var ComponentPeer, title: String) {.header: juce_gui_basics, importcpp: "#.setTitle(@)".}
proc setDocumentEditedStatus*(this: var ComponentPeer, edited: bool): bool {.header: juce_gui_basics, importcpp: "#.setDocumentEditedStatus(@)".}
proc setRepresentedFile*(this: var ComponentPeer, arg1: File) {.header: juce_gui_basics, importcpp: "#.setRepresentedFile(@)".}
proc setBounds*(this: var ComponentPeer, newBounds: Rectangle[cint], isNowFullScreen: bool) {.header: juce_gui_basics, importcpp: "#.setBounds(@)".}
proc updateBounds*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.updateBounds()".}
proc getBounds*(this: ComponentPeer): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getBounds()".}
proc localToGlobal*(this: var ComponentPeer, relativePosition: Point[cfloat]): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.localToGlobal(@)".}
proc globalToLocal*(this: var ComponentPeer, screenPosition: Point[cfloat]): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.globalToLocal(@)".}
proc localToGlobal*(this: var ComponentPeer, relativePosition: Point[cint]): Point[cint] {.header: juce_gui_basics, importcpp: "#.localToGlobal(@)".}
proc globalToLocal*(this: var ComponentPeer, screenPosition: Point[cint]): Point[cint] {.header: juce_gui_basics, importcpp: "#.globalToLocal(@)".}
proc localToGlobal*(this: var ComponentPeer, relativePosition: Rectangle[cint]): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.localToGlobal(@)".}
proc globalToLocal*(this: var ComponentPeer, screenPosition: Rectangle[cint]): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.globalToLocal(@)".}
proc localToGlobal*(this: var ComponentPeer, relativePosition: Rectangle[cfloat]): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.localToGlobal(@)".}
proc globalToLocal*(this: var ComponentPeer, screenPosition: Rectangle[cfloat]): Rectangle[cfloat] {.header: juce_gui_basics, importcpp: "#.globalToLocal(@)".}
proc localToMultimonitor*(this: var ComponentPeer, x: Point[cfloat]): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.localToMultimonitor(@)".}
proc multimonitorToLocal*(this: var ComponentPeer, x: Point[cfloat]): Point[cfloat] {.header: juce_gui_basics, importcpp: "#.multimonitorToLocal(@)".}
proc getAreaCoveredBy*(this: ComponentPeer, subComponent: Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getAreaCoveredBy(@)".}
proc setMinimised*(this: var ComponentPeer, shouldBeMinimised: bool) {.header: juce_gui_basics, importcpp: "#.setMinimised(@)".}
proc isMinimised*(this: ComponentPeer): bool {.header: juce_gui_basics, importcpp: "#.isMinimised()".}
proc isShowing*(this: ComponentPeer): bool {.header: juce_gui_basics, importcpp: "#.isShowing()".}
proc setFullScreen*(this: var ComponentPeer, shouldBeFullScreen: bool) {.header: juce_gui_basics, importcpp: "#.setFullScreen(@)".}
proc isFullScreen*(this: ComponentPeer): bool {.header: juce_gui_basics, importcpp: "#.isFullScreen()".}
proc isKioskMode*(this: ComponentPeer): bool {.header: juce_gui_basics, importcpp: "#.isKioskMode()".}
proc setNonFullScreenBounds*(this: var ComponentPeer, newBounds: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.setNonFullScreenBounds(@)".}
proc getNonFullScreenBounds*(this: ComponentPeer): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getNonFullScreenBounds()".}
proc setIcon*(this: var ComponentPeer, newIcon: Image) {.header: juce_gui_basics, importcpp: "#.setIcon(@)".}
proc setConstrainer*(this: var ComponentPeer, newConstrainer: ptr ComponentBoundsConstrainer) {.header: juce_gui_basics, importcpp: "#.setConstrainer(@)".}
proc startHostManagedResize*(this: var ComponentPeer, mouseDownPosition: Point[cint], zone: ResizableBorderComponentZone) {.header: juce_gui_basics, importcpp: "#.startHostManagedResize(@)".}
proc getConstrainer*(this: ComponentPeer): ptr ComponentBoundsConstrainer {.header: juce_gui_basics, importcpp: "#.getConstrainer()".}
proc contains*(this: ComponentPeer, localPos: Point[cint], trueIfInAChildWindow: bool): bool {.header: juce_gui_basics, importcpp: "#.contains(@)".}
proc getFrameSizeIfPresent*(this: ComponentPeer): ComponentPeerOptionalBorderSize {.header: juce_gui_basics, importcpp: "#.getFrameSizeIfPresent()".}
proc getFrameSize*(this: ComponentPeer): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getFrameSize()".}
proc handleMovedOrResized*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleMovedOrResized()".}
proc handleScreenSizeChange*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleScreenSizeChange()".}
proc handlePaint*(this: var ComponentPeer, contextToPaintTo: var LowLevelGraphicsContext) {.header: juce_gui_basics, importcpp: "#.handlePaint(@)".}
proc setAlwaysOnTop*(this: var ComponentPeer, alwaysOnTop: bool): bool {.header: juce_gui_basics, importcpp: "#.setAlwaysOnTop(@)".}
proc toFront*(this: var ComponentPeer, takeKeyboardFocus: bool) {.header: juce_gui_basics, importcpp: "#.toFront(@)".}
proc toBehind*(this: var ComponentPeer, other: ptr ComponentPeer) {.header: juce_gui_basics, importcpp: "#.toBehind(@)".}
proc handleBroughtToFront*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleBroughtToFront()".}
proc isFocused*(this: ComponentPeer): bool {.header: juce_gui_basics, importcpp: "#.isFocused()".}
proc grabFocus*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.grabFocus()".}
proc handleFocusGain*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleFocusGain()".}
proc handleFocusLoss*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleFocusLoss()".}
proc getLastFocusedSubcomponent*(this: ComponentPeer): ptr Component {.header: juce_gui_basics, importcpp: "#.getLastFocusedSubcomponent()".}
proc handleKeyPress*(this: var ComponentPeer, keyCode: cint, textCharacter: uint16): bool {.header: juce_gui_basics, importcpp: "#.handleKeyPress(@)".}
proc handleKeyPress*(this: var ComponentPeer, key: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.handleKeyPress(@)".}
proc handleKeyUpOrDown*(this: var ComponentPeer, isKeyDown: bool): bool {.header: juce_gui_basics, importcpp: "#.handleKeyUpOrDown(@)".}
proc handleModifierKeysChange*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleModifierKeysChange()".}
proc closeInputMethodContext*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.closeInputMethodContext()".}
proc refreshTextInputTarget*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.refreshTextInputTarget()".}
proc findCurrentTextInputTarget*(this: var ComponentPeer): ptr TextInputTarget {.header: juce_gui_basics, importcpp: "#.findCurrentTextInputTarget()".}
proc repaint*(this: var ComponentPeer, area: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.repaint(@)".}
proc performAnyPendingRepaintsNow*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.performAnyPendingRepaintsNow()".}
proc setAlpha*(this: var ComponentPeer, newAlpha: cfloat) {.header: juce_gui_basics, importcpp: "#.setAlpha(@)".}
proc handleMouseEvent*(this: var ComponentPeer, `type`: MouseInputSourceInputSourceType, positionWithinPeer: Point[cfloat], newMods: ModifierKeys, pressure: cfloat, orientation: cfloat, time: int64, pen: PenDetails, touchIndex: cint = 0) {.header: juce_gui_basics, importcpp: "#.handleMouseEvent(@)".}
proc handleMouseWheel*(this: var ComponentPeer, `type`: MouseInputSourceInputSourceType, positionWithinPeer: Point[cfloat], time: int64, arg4: MouseWheelDetails, touchIndex: cint = 0) {.header: juce_gui_basics, importcpp: "#.handleMouseWheel(@)".}
proc handleMagnifyGesture*(this: var ComponentPeer, `type`: MouseInputSourceInputSourceType, positionWithinPeer: Point[cfloat], time: int64, scaleFactor: cfloat, touchIndex: cint = 0) {.header: juce_gui_basics, importcpp: "#.handleMagnifyGesture(@)".}
proc handleUserClosingWindow*(this: var ComponentPeer) {.header: juce_gui_basics, importcpp: "#.handleUserClosingWindow()".}
proc handleDragMove*(this: var ComponentPeer, arg1: ComponentPeerDragInfo): bool {.header: juce_gui_basics, importcpp: "#.handleDragMove(@)".}
proc handleDragExit*(this: var ComponentPeer, arg1: ComponentPeerDragInfo): bool {.header: juce_gui_basics, importcpp: "#.handleDragExit(@)".}
proc handleDragDrop*(this: var ComponentPeer, arg1: ComponentPeerDragInfo): bool {.header: juce_gui_basics, importcpp: "#.handleDragDrop(@)".}
proc getAvailableRenderingEngines*(this: var ComponentPeer): StringArray {.header: juce_gui_basics, importcpp: "#.getAvailableRenderingEngines()".}
proc getCurrentRenderingEngine*(this: ComponentPeer): cint {.header: juce_gui_basics, importcpp: "#.getCurrentRenderingEngine()".}
proc setCurrentRenderingEngine*(this: var ComponentPeer, index: cint) {.header: juce_gui_basics, importcpp: "#.setCurrentRenderingEngine(@)".}
proc addScaleFactorListener*(this: var ComponentPeer, listenerToAdd: ptr ComponentPeerScaleFactorListener) {.header: juce_gui_basics, importcpp: "#.addScaleFactorListener(@)".}
proc removeScaleFactorListener*(this: var ComponentPeer, listenerToRemove: ptr ComponentPeerScaleFactorListener) {.header: juce_gui_basics, importcpp: "#.removeScaleFactorListener(@)".}
proc addVBlankListener*(this: var ComponentPeer, listenerToAdd: ptr ComponentPeerVBlankListener) {.header: juce_gui_basics, importcpp: "#.addVBlankListener(@)".}
proc removeVBlankListener*(this: var ComponentPeer, listenerToRemove: ptr ComponentPeerVBlankListener) {.header: juce_gui_basics, importcpp: "#.removeVBlankListener(@)".}
proc getPlatformScaleFactor*(this: ComponentPeer): float64 {.header: juce_gui_basics, importcpp: "#.getPlatformScaleFactor()".}
proc setCustomPlatformScaleFactor*(this: var ComponentPeer, arg1: CppOptional[cdouble]) {.header: juce_gui_basics, importcpp: "#.setCustomPlatformScaleFactor(@)".}
proc getCustomPlatformScaleFactor*(this: ComponentPeer): CppOptional[cdouble] {.header: juce_gui_basics, importcpp: "#.getCustomPlatformScaleFactor()".}
proc setHasChangedSinceSaved*(this: var ComponentPeer, arg1: bool) {.header: juce_gui_basics, importcpp: "#.setHasChangedSinceSaved(@)".}
proc setAppStyle*(this: var ComponentPeer, s: ComponentPeerStyle) {.header: juce_gui_basics, importcpp: "#.setAppStyle(@)".}
proc getAppStyle*(this: ComponentPeer): ComponentPeerStyle {.header: juce_gui_basics, importcpp: "#.getAppStyle()".}
proc getNumFramesPainted*(this: ComponentPeer): uint64 {.header: juce_gui_basics, importcpp: "#.getNumFramesPainted()".}
# proc setMultimonitorPositionOverride*(this: var ComponentPeer, pendingPosition: Point[cint]): Disabler {.header: juce_gui_basics, importcpp: "#.setMultimonitorPositionOverride(@)".}  # a type that cannot be spelled in Nim
proc getMultimonitorPositionOverride*(this: ComponentPeer): CppOptional[Point[cint]] {.header: juce_gui_basics, importcpp: "#.getMultimonitorPositionOverride()".}
proc `==`*(this: ComponentPeer, other: ComponentPeer): bool {.error: "juce::ComponentPeer defines no operator==; compare a property instead".}

proc makeResizableWindow*(name: String, addToDesktop: bool): ResizableWindow {.header: juce_gui_basics, importcpp: "juce::ResizableWindow(@)".}
proc makeResizableWindow*(name: String, backgroundColour: Colour, addToDesktop: bool): ResizableWindow {.header: juce_gui_basics, importcpp: "juce::ResizableWindow(@)".}
proc getBackgroundColour*(this: ResizableWindow): Colour {.header: juce_gui_basics, importcpp: "#.getBackgroundColour()".}
proc setBackgroundColour*(this: var ResizableWindow, newColour: Colour) {.header: juce_gui_basics, importcpp: "#.setBackgroundColour(@)".}
proc setResizable*(this: var ResizableWindow, shouldBeResizable: bool, useBottomRightCornerResizer: bool) {.header: juce_gui_basics, importcpp: "#.setResizable(@)".}
proc isResizable*(this: ResizableWindow): bool {.header: juce_gui_basics, importcpp: "#.isResizable()".}
proc setResizeLimits*(this: var ResizableWindow, newMinimumWidth: cint, newMinimumHeight: cint, newMaximumWidth: cint, newMaximumHeight: cint) {.header: juce_gui_basics, importcpp: "#.setResizeLimits(@)".}
proc setDraggable*(this: var ResizableWindow, shouldBeDraggable: bool) {.header: juce_gui_basics, importcpp: "#.setDraggable(@)".}
proc isDraggable*(this: ResizableWindow): bool {.header: juce_gui_basics, importcpp: "#.isDraggable()".}
proc getConstrainer*(this: var ResizableWindow): ptr ComponentBoundsConstrainer {.header: juce_gui_basics, importcpp: "#.getConstrainer()".}
proc setConstrainer*(this: var ResizableWindow, newConstrainer: ptr ComponentBoundsConstrainer) {.header: juce_gui_basics, importcpp: "#.setConstrainer(@)".}
proc setBoundsConstrained*(this: var ResizableWindow, newBounds: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.setBoundsConstrained(@)".}
proc isFullScreen*(this: ResizableWindow): bool {.header: juce_gui_basics, importcpp: "#.isFullScreen()".}
proc setFullScreen*(this: var ResizableWindow, shouldBeFullScreen: bool) {.header: juce_gui_basics, importcpp: "#.setFullScreen(@)".}
proc isMinimised*(this: ResizableWindow): bool {.header: juce_gui_basics, importcpp: "#.isMinimised()".}
proc setMinimised*(this: var ResizableWindow, shouldMinimise: bool) {.header: juce_gui_basics, importcpp: "#.setMinimised(@)".}
proc isKioskMode*(this: ResizableWindow): bool {.header: juce_gui_basics, importcpp: "#.isKioskMode()".}
proc getWindowStateAsString*(this: var ResizableWindow): String {.header: juce_gui_basics, importcpp: "#.getWindowStateAsString()".}
proc restoreWindowStateFromString*(this: var ResizableWindow, previousState: String): bool {.header: juce_gui_basics, importcpp: "#.restoreWindowStateFromString(@)".}
proc getContentComponent*(this: ResizableWindow): ptr Component {.header: juce_gui_basics, importcpp: "#.getContentComponent()".}
proc setContentOwned*(this: var ResizableWindow, newContentComponent: ptr Component, resizeToFitWhenContentChangesSize: bool) {.header: juce_gui_basics, importcpp: "#.setContentOwned(@)".}
proc setContentNonOwned*(this: var ResizableWindow, newContentComponent: ptr Component, resizeToFitWhenContentChangesSize: bool) {.header: juce_gui_basics, importcpp: "#.setContentNonOwned(@)".}
proc clearContentComponent*(this: var ResizableWindow) {.header: juce_gui_basics, importcpp: "#.clearContentComponent()".}
proc setContentComponentSize*(this: var ResizableWindow, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.setContentComponentSize(@)".}
proc getBorderThickness*(this: ResizableWindow): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getBorderThickness()".}
proc getContentComponentBorder*(this: ResizableWindow): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getContentComponentBorder()".}
proc setContentComponent*(this: var ResizableWindow, newContentComponent: ptr Component, deleteOldOne: bool = true, resizeToFit: bool = false) {.header: juce_gui_basics, importcpp: "#.setContentComponent(@)".}
proc `==`*(this: ResizableWindow, other: ResizableWindow): bool {.error: "juce::ResizableWindow defines no operator==; compare a property instead".}

proc makeDocumentWindowImpl*(name: String, backgroundColour: Colour, requiredButtons: cint, addToDesktop: bool): DocumentWindowImpl {.header: juce_gui_basics, importcpp: "juce::DocumentWindow(@)".}
proc setName*(this: var DocumentWindowImpl, newName: String) {.header: juce_gui_basics, importcpp: "#.setName(@)".}
proc setIcon*(this: var DocumentWindowImpl, imageToUse: Image) {.header: juce_gui_basics, importcpp: "#.setIcon(@)".}
proc setTitleBarHeight*(this: var DocumentWindowImpl, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setTitleBarHeight(@)".}
proc getTitleBarHeight*(this: DocumentWindowImpl): cint {.header: juce_gui_basics, importcpp: "#.getTitleBarHeight()".}
proc setTitleBarButtonsRequired*(this: var DocumentWindowImpl, requiredButtons: cint, positionTitleBarButtonsOnLeft: bool) {.header: juce_gui_basics, importcpp: "#.setTitleBarButtonsRequired(@)".}
proc setTitleBarTextCentred*(this: var DocumentWindowImpl, textShouldBeCentred: bool) {.header: juce_gui_basics, importcpp: "#.setTitleBarTextCentred(@)".}
proc setMenuBar*(this: var DocumentWindowImpl, menuBarModel: ptr MenuBarModel, menuBarHeight: cint = 0) {.header: juce_gui_basics, importcpp: "#.setMenuBar(@)".}
proc getMenuBarComponent*(this: DocumentWindowImpl): ptr Component {.header: juce_gui_basics, importcpp: "#.getMenuBarComponent()".}
proc setMenuBarComponent*(this: var DocumentWindowImpl, newMenuBarComponent: ptr Component) {.header: juce_gui_basics, importcpp: "#.setMenuBarComponent(@)".}
proc closeButtonPressed*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.closeButtonPressed()".}
proc minimiseButtonPressed*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.minimiseButtonPressed()".}
proc maximiseButtonPressed*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.maximiseButtonPressed()".}
proc getCloseButton*(this: DocumentWindowImpl): ptr Button {.header: juce_gui_basics, importcpp: "#.getCloseButton()".}
proc getMinimiseButton*(this: DocumentWindowImpl): ptr Button {.header: juce_gui_basics, importcpp: "#.getMinimiseButton()".}
proc getMaximiseButton*(this: DocumentWindowImpl): ptr Button {.header: juce_gui_basics, importcpp: "#.getMaximiseButton()".}
proc paint*(this: var DocumentWindowImpl, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc lookAndFeelChanged*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc getContentComponentBorder*(this: DocumentWindowImpl): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getContentComponentBorder()".}
proc mouseDoubleClick*(this: var DocumentWindowImpl, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDoubleClick(@)".}
proc userTriedToCloseWindow*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.userTriedToCloseWindow()".}
proc activeWindowStatusChanged*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.activeWindowStatusChanged()".}
proc getDesktopWindowStyleFlags*(this: DocumentWindowImpl): cint {.header: juce_gui_basics, importcpp: "#.getDesktopWindowStyleFlags()".}
proc parentHierarchyChanged*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc getTitleBarArea*(this: DocumentWindowImpl): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getTitleBarArea()".}
proc findControlAtPoint*(this: DocumentWindowImpl, arg1: Point[cfloat]): ComponentWindowControlKind {.header: juce_gui_basics, importcpp: "#.findControlAtPoint(@)".}
proc windowControlClickedClose*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.windowControlClickedClose()".}
proc windowControlClickedMinimise*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.windowControlClickedMinimise()".}
proc windowControlClickedMaximise*(this: var DocumentWindowImpl) {.header: juce_gui_basics, importcpp: "#.windowControlClickedMaximise()".}
proc `==`*(this: DocumentWindowImpl, other: DocumentWindowImpl): bool {.error: "juce::DocumentWindow defines no operator==; compare a property instead".}

proc makeDialogWindow*(name: String, backgroundColour: Colour, escapeKeyTriggersCloseButton: bool, addToDesktop: bool, desktopScale: cfloat): DialogWindow {.header: juce_gui_basics, importcpp: "juce::DialogWindow(@)".}
proc escapeKeyPressed*(this: var DialogWindow): bool {.header: juce_gui_basics, importcpp: "#.escapeKeyPressed()".}
proc createAccessibilityHandler*(this: var DialogWindow): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: DialogWindow, other: DialogWindow): bool {.error: "juce::DialogWindow defines no operator==; compare a property instead".}

proc `==`*(this: NativeMessageBox, other: NativeMessageBox): bool {.error: "juce::NativeMessageBox defines no operator==; compare a property instead".}

proc makeThreadWithProgressWindow*(windowTitle: String, hasProgressBar: bool, hasCancelButton: bool, timeOutMsWhenCancelling: cint, cancelButtonText: String, componentToCentreAround: ptr Component): ThreadWithProgressWindow {.header: juce_gui_basics, importcpp: "juce::ThreadWithProgressWindow(@)".}
proc launchThread*(this: var ThreadWithProgressWindow, priority: ThreadPriority) {.header: juce_gui_basics, importcpp: "#.launchThread(@)".}
proc setProgress*(this: var ThreadWithProgressWindow, newProgress: float64) {.header: juce_gui_basics, importcpp: "#.setProgress(@)".}
proc setStatusMessage*(this: var ThreadWithProgressWindow, newStatusMessage: String) {.header: juce_gui_basics, importcpp: "#.setStatusMessage(@)".}
proc getAlertWindow*(this: ThreadWithProgressWindow): ptr AlertWindow {.header: juce_gui_basics, importcpp: "#.getAlertWindow()".}
proc threadComplete*(this: var ThreadWithProgressWindow, userPressedCancel: bool) {.header: juce_gui_basics, importcpp: "#.threadComplete(@)".}
proc `==`*(this: ThreadWithProgressWindow, other: ThreadWithProgressWindow): bool {.error: "juce::ThreadWithProgressWindow defines no operator==; compare a property instead".}

proc makeTooltipWindow*(parentComponent: ptr Component, millisecondsBeforeTipAppears: cint): TooltipWindow {.header: juce_gui_basics, importcpp: "juce::TooltipWindow(@)".}
proc setMillisecondsBeforeTipAppears*(this: var TooltipWindow, newTimeMs: cint = 700) {.header: juce_gui_basics, importcpp: "#.setMillisecondsBeforeTipAppears(@)".}
proc displayTip*(this: var TooltipWindow, screenPosition: Point[cint], text: String) {.header: juce_gui_basics, importcpp: "#.displayTip(@)".}
proc hideTip*(this: var TooltipWindow) {.header: juce_gui_basics, importcpp: "#.hideTip()".}
proc getTipFor*(this: var TooltipWindow, arg1: var Component): String {.header: juce_gui_basics, importcpp: "#.getTipFor(@)".}
proc getDesktopScaleFactor*(this: TooltipWindow): cfloat {.header: juce_gui_basics, importcpp: "#.getDesktopScaleFactor()".}
proc createAccessibilityHandler*(this: var TooltipWindow): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: TooltipWindow, other: TooltipWindow): bool {.error: "juce::TooltipWindow defines no operator==; compare a property instead".}

proc makeVBlankAttachment*(): VBlankAttachment {.header: juce_gui_basics, importcpp: "juce::VBlankAttachment(@)".}
proc makeVBlankAttachment*(c: ptr Component, callbackIn: CppFunctionObjectN0): VBlankAttachment {.header: juce_gui_basics, importcpp: "juce::VBlankAttachment(@)".}
proc makeVBlankAttachment*(c: ptr Component, callbackIn: CppFunctionObjectN1[cdouble]): VBlankAttachment {.header: juce_gui_basics, importcpp: "juce::VBlankAttachment(@)".}
proc `VBlankAttachment=`*(this: var VBlankAttachment, other: VBlankAttachment): var VBlankAttachment {.header: juce_gui_basics, importcpp: "#.operator=(@)".}
proc isEmpty*(this: VBlankAttachment): bool {.header: juce_gui_basics, importcpp: "#.isEmpty()".}
proc `==`*(this: VBlankAttachment, other: VBlankAttachment): bool {.error: "juce::VBlankAttachment defines no operator==; compare a property instead".}

proc makeWindowUtils*(): WindowUtils {.header: juce_gui_basics, importcpp: "juce::WindowUtils(@)".}
proc `==`*(this: WindowUtils, other: WindowUtils): bool {.error: "juce::WindowUtils defines no operator==; compare a property instead".}

proc makeNativeScaleFactorNotifier*(comp: ptr Component, onScaleChanged: CppFunctionObjectN1[cfloat]): NativeScaleFactorNotifier {.header: juce_gui_basics, importcpp: "juce::NativeScaleFactorNotifier(@)".}
proc `==`*(this: NativeScaleFactorNotifier, other: NativeScaleFactorNotifier): bool {.error: "juce::NativeScaleFactorNotifier defines no operator==; compare a property instead".}

proc makeMultiDocumentPanelWindow*(backgroundColour: Colour): MultiDocumentPanelWindow {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanelWindow(@)".}
proc maximiseButtonPressed*(this: var MultiDocumentPanelWindow) {.header: juce_gui_basics, importcpp: "#.maximiseButtonPressed()".}
proc closeButtonPressed*(this: var MultiDocumentPanelWindow) {.header: juce_gui_basics, importcpp: "#.closeButtonPressed()".}
proc activeWindowStatusChanged*(this: var MultiDocumentPanelWindow) {.header: juce_gui_basics, importcpp: "#.activeWindowStatusChanged()".}
proc broughtToFront*(this: var MultiDocumentPanelWindow) {.header: juce_gui_basics, importcpp: "#.broughtToFront()".}
proc `==`*(this: MultiDocumentPanelWindow, other: MultiDocumentPanelWindow): bool {.error: "juce::MultiDocumentPanelWindow defines no operator==; compare a property instead".}

proc makeMultiDocumentPanel*(): MultiDocumentPanel {.header: juce_gui_basics, importcpp: "juce::MultiDocumentPanel(@)".}
proc closeAllDocumentsAsync*(this: var MultiDocumentPanel, checkItsOkToCloseFirst: bool, callback: CppFunctionObjectN1[bool]) {.header: juce_gui_basics, importcpp: "#.closeAllDocumentsAsync(@)".}
proc addDocument*(this: var MultiDocumentPanel, component: ptr Component, backgroundColour: Colour, deleteWhenRemoved: bool): bool {.header: juce_gui_basics, importcpp: "#.addDocument(@)".}
proc closeDocumentAsync*(this: var MultiDocumentPanel, component: ptr Component, checkItsOkToCloseFirst: bool, callback: CppFunctionObjectN1[bool]) {.header: juce_gui_basics, importcpp: "#.closeDocumentAsync(@)".}
proc getNumDocuments*(this: MultiDocumentPanel): cint {.header: juce_gui_basics, importcpp: "#.getNumDocuments()".}
proc getDocument*(this: MultiDocumentPanel, index: cint): ptr Component {.header: juce_gui_basics, importcpp: "#.getDocument(@)".}
proc getActiveDocument*(this: MultiDocumentPanel): ptr Component {.header: juce_gui_basics, importcpp: "#.getActiveDocument()".}
proc setActiveDocument*(this: var MultiDocumentPanel, component: ptr Component) {.header: juce_gui_basics, importcpp: "#.setActiveDocument(@)".}
proc activeDocumentChanged*(this: var MultiDocumentPanel) {.header: juce_gui_basics, importcpp: "#.activeDocumentChanged()".}
proc setMaximumNumDocuments*(this: var MultiDocumentPanel, maximumNumDocuments: cint) {.header: juce_gui_basics, importcpp: "#.setMaximumNumDocuments(@)".}
proc useFullscreenWhenOneDocument*(this: var MultiDocumentPanel, shouldUseTabs: bool) {.header: juce_gui_basics, importcpp: "#.useFullscreenWhenOneDocument(@)".}
proc isFullscreenWhenOneDocument*(this: MultiDocumentPanel): bool {.header: juce_gui_basics, importcpp: "#.isFullscreenWhenOneDocument()".}
proc setLayoutMode*(this: var MultiDocumentPanel, newLayoutMode: MultiDocumentPanelLayoutMode) {.header: juce_gui_basics, importcpp: "#.setLayoutMode(@)".}
proc getLayoutMode*(this: MultiDocumentPanel): MultiDocumentPanelLayoutMode {.header: juce_gui_basics, importcpp: "#.getLayoutMode()".}
proc setBackgroundColour*(this: var MultiDocumentPanel, newBackgroundColour: Colour) {.header: juce_gui_basics, importcpp: "#.setBackgroundColour(@)".}
proc getBackgroundColour*(this: MultiDocumentPanel): Colour {.header: juce_gui_basics, importcpp: "#.getBackgroundColour()".}
proc getCurrentTabbedComponent*(this: MultiDocumentPanel): ptr TabbedComponent {.header: juce_gui_basics, importcpp: "#.getCurrentTabbedComponent()".}
proc tryToCloseDocumentAsync*(this: var MultiDocumentPanel, component: ptr Component, callback: CppFunctionObjectN1[bool]) {.header: juce_gui_basics, importcpp: "#.tryToCloseDocumentAsync(@)".}
proc createNewDocumentWindow*(this: var MultiDocumentPanel): ptr MultiDocumentPanelWindow {.header: juce_gui_basics, importcpp: "#.createNewDocumentWindow()".}
proc paint*(this: var MultiDocumentPanel, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var MultiDocumentPanel) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc componentNameChanged*(this: var MultiDocumentPanel, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.componentNameChanged(@)".}
proc `==`*(this: MultiDocumentPanel, other: MultiDocumentPanel): bool {.error: "juce::MultiDocumentPanel defines no operator==; compare a property instead".}

proc makeSidePanel*(title: StringRef, width: cint, positionOnLeft: bool, contentComponent: ptr Component, deleteComponentWhenNoLongerNeeded: bool): SidePanel {.header: juce_gui_basics, importcpp: "juce::SidePanel(@)".}
proc setContent*(this: var SidePanel, newContentComponent: ptr Component, deleteComponentWhenNoLongerNeeded: bool = true) {.header: juce_gui_basics, importcpp: "#.setContent(@)".}
proc getContent*(this: SidePanel): ptr Component {.header: juce_gui_basics, importcpp: "#.getContent()".}
proc setTitleBarComponent*(this: var SidePanel, titleBarComponentToUse: ptr Component, keepDismissButton: bool, deleteComponentWhenNoLongerNeeded: bool = true) {.header: juce_gui_basics, importcpp: "#.setTitleBarComponent(@)".}
proc getTitleBarComponent*(this: SidePanel): ptr Component {.header: juce_gui_basics, importcpp: "#.getTitleBarComponent()".}
proc showOrHide*(this: var SidePanel, show: bool) {.header: juce_gui_basics, importcpp: "#.showOrHide(@)".}
proc isPanelShowing*(this: SidePanel): bool {.header: juce_gui_basics, importcpp: "#.isPanelShowing()".}
proc isPanelOnLeft*(this: SidePanel): bool {.header: juce_gui_basics, importcpp: "#.isPanelOnLeft()".}
proc setShadowWidth*(this: var SidePanel, newWidth: cint) {.header: juce_gui_basics, importcpp: "#.setShadowWidth(@)".}
proc getShadowWidth*(this: SidePanel): cint {.header: juce_gui_basics, importcpp: "#.getShadowWidth()".}
proc setTitleBarHeight*(this: var SidePanel, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setTitleBarHeight(@)".}
proc getTitleBarHeight*(this: SidePanel): cint {.header: juce_gui_basics, importcpp: "#.getTitleBarHeight()".}
proc getTitleText*(this: SidePanel): String {.header: juce_gui_basics, importcpp: "#.getTitleText()".}
proc setContentRestrictedToSafeArea*(this: var SidePanel, x: bool) {.header: juce_gui_basics, importcpp: "#.setContentRestrictedToSafeArea(@)".}
proc isContentRestrictedToSafeArea*(this: SidePanel): bool {.header: juce_gui_basics, importcpp: "#.isContentRestrictedToSafeArea()".}
proc moved*(this: var SidePanel) {.header: juce_gui_basics, importcpp: "#.moved()".}
proc resized*(this: var SidePanel) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc paint*(this: var SidePanel, g: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc parentHierarchyChanged*(this: var SidePanel) {.header: juce_gui_basics, importcpp: "#.parentHierarchyChanged()".}
proc mouseDrag*(this: var SidePanel, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseDrag(@)".}
proc mouseUp*(this: var SidePanel, arg1: MouseEvent) {.header: juce_gui_basics, importcpp: "#.mouseUp(@)".}
proc createAccessibilityHandler*(this: var SidePanel): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: SidePanel, other: SidePanel): bool {.error: "juce::SidePanel defines no operator==; compare a property instead".}

proc selectionChanged*(this: var FileBrowserListener) {.header: juce_gui_basics, importcpp: "#.selectionChanged()".}
proc fileClicked*(this: var FileBrowserListener, file: File, e: MouseEvent) {.header: juce_gui_basics, importcpp: "#.fileClicked(@)".}
proc fileDoubleClicked*(this: var FileBrowserListener, file: File) {.header: juce_gui_basics, importcpp: "#.fileDoubleClicked(@)".}
proc browserRootChanged*(this: var FileBrowserListener, newRoot: File) {.header: juce_gui_basics, importcpp: "#.browserRootChanged(@)".}
proc `==`*(this: FileBrowserListener, other: FileBrowserListener): bool {.error: "juce::FileBrowserListener defines no operator==; compare a property instead".}

proc makeDirectoryContentsList*(fileFilter: ptr FileFilter, threadToUse: var TimeSliceThread): DirectoryContentsList {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsList(@)".}
proc getDirectory*(this: DirectoryContentsList): File {.header: juce_gui_basics, importcpp: "#.getDirectory()".}
proc setDirectory*(this: var DirectoryContentsList, directory: File, includeDirectories: bool, includeFiles: bool) {.header: juce_gui_basics, importcpp: "#.setDirectory(@)".}
proc isFindingDirectories*(this: DirectoryContentsList): bool {.header: juce_gui_basics, importcpp: "#.isFindingDirectories()".}
proc isFindingFiles*(this: DirectoryContentsList): bool {.header: juce_gui_basics, importcpp: "#.isFindingFiles()".}
proc clear*(this: var DirectoryContentsList) {.header: juce_gui_basics, importcpp: "#.clear()".}
proc refresh*(this: var DirectoryContentsList) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc isStillLoading*(this: DirectoryContentsList): bool {.header: juce_gui_basics, importcpp: "#.isStillLoading()".}
proc setIgnoresHiddenFiles*(this: var DirectoryContentsList, shouldIgnoreHiddenFiles: bool) {.header: juce_gui_basics, importcpp: "#.setIgnoresHiddenFiles(@)".}
proc ignoresHiddenFiles*(this: DirectoryContentsList): bool {.header: juce_gui_basics, importcpp: "#.ignoresHiddenFiles()".}
proc setFileFilter*(this: var DirectoryContentsList, newFileFilter: ptr FileFilter) {.header: juce_gui_basics, importcpp: "#.setFileFilter(@)".}
proc getNumFiles*(this: DirectoryContentsList): cint {.header: juce_gui_basics, importcpp: "#.getNumFiles()".}
proc getFileInfo*(this: DirectoryContentsList, index: cint, resultInfo: var DirectoryContentsListFileInfo): bool {.header: juce_gui_basics, importcpp: "#.getFileInfo(@)".}
proc getFile*(this: DirectoryContentsList, index: cint): File {.header: juce_gui_basics, importcpp: "#.getFile(@)".}
proc getFilter*(this: DirectoryContentsList): ptr FileFilter {.header: juce_gui_basics, importcpp: "#.getFilter()".}
proc contains*(this: DirectoryContentsList, arg1: File): bool {.header: juce_gui_basics, importcpp: "#.contains(@)".}
proc getTimeSliceThread*(this: DirectoryContentsList): var TimeSliceThread {.header: juce_gui_basics, importcpp: "#.getTimeSliceThread()".}
proc `==`*(this: DirectoryContentsList, other: DirectoryContentsList): bool {.error: "juce::DirectoryContentsList defines no operator==; compare a property instead".}

proc makeDirectoryContentsDisplayComponent*(listToShow: var DirectoryContentsList): DirectoryContentsDisplayComponent {.header: juce_gui_basics, importcpp: "juce::DirectoryContentsDisplayComponent(@)".}
proc getNumSelectedFiles*(this: DirectoryContentsDisplayComponent): cint {.header: juce_gui_basics, importcpp: "#.getNumSelectedFiles()".}
proc getSelectedFile*(this: DirectoryContentsDisplayComponent, index: cint): File {.header: juce_gui_basics, importcpp: "#.getSelectedFile(@)".}
proc deselectAllFiles*(this: var DirectoryContentsDisplayComponent) {.header: juce_gui_basics, importcpp: "#.deselectAllFiles()".}
proc scrollToTop*(this: var DirectoryContentsDisplayComponent) {.header: juce_gui_basics, importcpp: "#.scrollToTop()".}
proc setSelectedFile*(this: var DirectoryContentsDisplayComponent, arg1: File) {.header: juce_gui_basics, importcpp: "#.setSelectedFile(@)".}
proc addListener*(this: var DirectoryContentsDisplayComponent, listener: ptr FileBrowserListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var DirectoryContentsDisplayComponent, listener: ptr FileBrowserListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc sendSelectionChangeMessage*(this: var DirectoryContentsDisplayComponent) {.header: juce_gui_basics, importcpp: "#.sendSelectionChangeMessage()".}
proc sendDoubleClickMessage*(this: var DirectoryContentsDisplayComponent, arg1: File) {.header: juce_gui_basics, importcpp: "#.sendDoubleClickMessage(@)".}
proc sendMouseClickMessage*(this: var DirectoryContentsDisplayComponent, arg1: File, arg2: MouseEvent) {.header: juce_gui_basics, importcpp: "#.sendMouseClickMessage(@)".}
proc `==`*(this: DirectoryContentsDisplayComponent, other: DirectoryContentsDisplayComponent): bool {.error: "juce::DirectoryContentsDisplayComponent defines no operator==; compare a property instead".}

proc makeFileBrowserComponent*(flags: cint, initialFileOrDirectory: File, fileFilter: ptr FileFilter, previewComp: ptr FilePreviewComponent): FileBrowserComponent {.header: juce_gui_basics, importcpp: "juce::FileBrowserComponent(@)".}
proc getNumSelectedFiles*(this: FileBrowserComponent): cint {.header: juce_gui_basics, importcpp: "#.getNumSelectedFiles()".}
proc getSelectedFile*(this: FileBrowserComponent, index: cint): File {.header: juce_gui_basics, importcpp: "#.getSelectedFile(@)".}
proc deselectAllFiles*(this: var FileBrowserComponent) {.header: juce_gui_basics, importcpp: "#.deselectAllFiles()".}
proc currentFileIsValid*(this: FileBrowserComponent): bool {.header: juce_gui_basics, importcpp: "#.currentFileIsValid()".}
proc getHighlightedFile*(this: FileBrowserComponent): File {.header: juce_gui_basics, importcpp: "#.getHighlightedFile()".}
proc getRoot*(this: FileBrowserComponent): File {.header: juce_gui_basics, importcpp: "#.getRoot()".}
proc setRoot*(this: var FileBrowserComponent, newRootDirectory: File) {.header: juce_gui_basics, importcpp: "#.setRoot(@)".}
proc setFileName*(this: var FileBrowserComponent, newName: String) {.header: juce_gui_basics, importcpp: "#.setFileName(@)".}
proc goUp*(this: var FileBrowserComponent) {.header: juce_gui_basics, importcpp: "#.goUp()".}
proc refresh*(this: var FileBrowserComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc setFileFilter*(this: var FileBrowserComponent, newFileFilter: ptr FileFilter) {.header: juce_gui_basics, importcpp: "#.setFileFilter(@)".}
proc getActionVerb*(this: FileBrowserComponent): String {.header: juce_gui_basics, importcpp: "#.getActionVerb()".}
proc isSaveMode*(this: FileBrowserComponent): bool {.header: juce_gui_basics, importcpp: "#.isSaveMode()".}
proc setFilenameBoxLabel*(this: var FileBrowserComponent, name: String) {.header: juce_gui_basics, importcpp: "#.setFilenameBoxLabel(@)".}
proc addListener*(this: var FileBrowserComponent, listener: ptr FileBrowserListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var FileBrowserComponent, listener: ptr FileBrowserListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc resized*(this: var FileBrowserComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc lookAndFeelChanged*(this: var FileBrowserComponent) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc keyPressed*(this: var FileBrowserComponent, arg1: KeyPress): bool {.header: juce_gui_basics, importcpp: "#.keyPressed(@)".}
proc selectionChanged*(this: var FileBrowserComponent) {.header: juce_gui_basics, importcpp: "#.selectionChanged()".}
proc fileClicked*(this: var FileBrowserComponent, arg1: File, arg2: MouseEvent) {.header: juce_gui_basics, importcpp: "#.fileClicked(@)".}
proc fileDoubleClicked*(this: var FileBrowserComponent, arg1: File) {.header: juce_gui_basics, importcpp: "#.fileDoubleClicked(@)".}
proc browserRootChanged*(this: var FileBrowserComponent, arg1: File) {.header: juce_gui_basics, importcpp: "#.browserRootChanged(@)".}
proc isFileSuitable*(this: FileBrowserComponent, arg1: File): bool {.header: juce_gui_basics, importcpp: "#.isFileSuitable(@)".}
proc isDirectorySuitable*(this: FileBrowserComponent, arg1: File): bool {.header: juce_gui_basics, importcpp: "#.isDirectorySuitable(@)".}
proc getPreviewComponent*(this: FileBrowserComponent): ptr FilePreviewComponent {.header: juce_gui_basics, importcpp: "#.getPreviewComponent()".}
proc getDisplayComponent*(this: FileBrowserComponent): ptr DirectoryContentsDisplayComponent {.header: juce_gui_basics, importcpp: "#.getDisplayComponent()".}
proc createAccessibilityHandler*(this: var FileBrowserComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: FileBrowserComponent, other: FileBrowserComponent): bool {.error: "juce::FileBrowserComponent defines no operator==; compare a property instead".}

proc makeFileChooser*(dialogBoxTitle: String, initialFileOrDirectory: File, filePatternsAllowed: String, useOSNativeDialogBox: bool, treatFilePackagesAsDirectories: bool, parentComponent: ptr Component): FileChooser {.header: juce_gui_basics, importcpp: "juce::FileChooser(@)".}
proc launchAsync*(this: var FileChooser, flags: cint, arg2: CppFunctionObjectN1[FileChooser], previewComponent: ptr FilePreviewComponent = nil) {.header: juce_gui_basics, importcpp: "#.launchAsync(@)".}
proc getResult*(this: FileChooser): File {.header: juce_gui_basics, importcpp: "#.getResult()".}
proc getResults*(this: FileChooser): Array[File] {.header: juce_gui_basics, importcpp: "#.getResults()".}
proc getURLResult*(this: FileChooser): URL {.header: juce_gui_basics, importcpp: "#.getURLResult()".}
proc getURLResults*(this: FileChooser): Array[URL] {.header: juce_gui_basics, importcpp: "#.getURLResults()".}
proc `==`*(this: FileChooser, other: FileChooser): bool {.error: "juce::FileChooser defines no operator==; compare a property instead".}

proc makeFileChooserDialogBox*(title: String, instructions: String, browserComponent: var FileBrowserComponent, warnAboutOverwritingExistingFiles: bool, backgroundColour: Colour, parentComponent: ptr Component): FileChooserDialogBox {.header: juce_gui_basics, importcpp: "juce::FileChooserDialogBox(@)".}
proc centreWithDefaultSize*(this: var FileChooserDialogBox, componentToCentreAround: ptr Component = nil) {.header: juce_gui_basics, importcpp: "#.centreWithDefaultSize(@)".}
proc `==`*(this: FileChooserDialogBox, other: FileChooserDialogBox): bool {.error: "juce::FileChooserDialogBox defines no operator==; compare a property instead".}

proc makeFileListComponent*(listToShow: var DirectoryContentsList): FileListComponent {.header: juce_gui_basics, importcpp: "juce::FileListComponent(@)".}
proc getNumSelectedFiles*(this: FileListComponent): cint {.header: juce_gui_basics, importcpp: "#.getNumSelectedFiles()".}
proc getSelectedFile*(this: FileListComponent, index: cint = 0): File {.header: juce_gui_basics, importcpp: "#.getSelectedFile(@)".}
proc deselectAllFiles*(this: var FileListComponent) {.header: juce_gui_basics, importcpp: "#.deselectAllFiles()".}
proc scrollToTop*(this: var FileListComponent) {.header: juce_gui_basics, importcpp: "#.scrollToTop()".}
proc setSelectedFile*(this: var FileListComponent, arg1: File) {.header: juce_gui_basics, importcpp: "#.setSelectedFile(@)".}
proc `==`*(this: FileListComponent, other: FileListComponent): bool {.error: "juce::FileListComponent defines no operator==; compare a property instead".}

proc filenameComponentChanged*(this: var FilenameComponentListener, fileComponentThatHasChanged: ptr FilenameComponent) {.header: juce_gui_basics, importcpp: "#.filenameComponentChanged(@)".}
proc `==`*(this: FilenameComponentListener, other: FilenameComponentListener): bool {.error: "juce::FilenameComponentListener defines no operator==; compare a property instead".}

proc makeFilenameComponent*(name: String, currentFile: File, canEditFilename: bool, isDirectory: bool, isForSaving: bool, fileBrowserWildcard: String, enforcedSuffix: String, textWhenNothingSelected: String): FilenameComponent {.header: juce_gui_basics, importcpp: "juce::FilenameComponent(@)".}
proc getCurrentFile*(this: FilenameComponent): File {.header: juce_gui_basics, importcpp: "#.getCurrentFile()".}
proc getCurrentFileText*(this: FilenameComponent): String {.header: juce_gui_basics, importcpp: "#.getCurrentFileText()".}
proc setCurrentFile*(this: var FilenameComponent, newFile: File, addToRecentlyUsedList: bool, notification: NotificationType) {.header: juce_gui_basics, importcpp: "#.setCurrentFile(@)".}
proc setFilenameIsEditable*(this: var FilenameComponent, shouldBeEditable: bool) {.header: juce_gui_basics, importcpp: "#.setFilenameIsEditable(@)".}
proc setDefaultBrowseTarget*(this: var FilenameComponent, newDefaultDirectory: File) {.header: juce_gui_basics, importcpp: "#.setDefaultBrowseTarget(@)".}
proc getLocationToBrowse*(this: var FilenameComponent): File {.header: juce_gui_basics, importcpp: "#.getLocationToBrowse()".}
proc getRecentlyUsedFilenames*(this: FilenameComponent): StringArray {.header: juce_gui_basics, importcpp: "#.getRecentlyUsedFilenames()".}
proc setRecentlyUsedFilenames*(this: var FilenameComponent, filenames: StringArray) {.header: juce_gui_basics, importcpp: "#.setRecentlyUsedFilenames(@)".}
proc addRecentlyUsedFile*(this: var FilenameComponent, file: File) {.header: juce_gui_basics, importcpp: "#.addRecentlyUsedFile(@)".}
proc setMaxNumberOfRecentFiles*(this: var FilenameComponent, newMaximum: cint) {.header: juce_gui_basics, importcpp: "#.setMaxNumberOfRecentFiles(@)".}
proc setBrowseButtonText*(this: var FilenameComponent, browseButtonText: String) {.header: juce_gui_basics, importcpp: "#.setBrowseButtonText(@)".}
proc addListener*(this: var FilenameComponent, listener: ptr FilenameComponentListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var FilenameComponent, listener: ptr FilenameComponentListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc setTooltip*(this: var FilenameComponent, newTooltip: String) {.header: juce_gui_basics, importcpp: "#.setTooltip(@)".}
proc paintOverChildren*(this: var FilenameComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paintOverChildren(@)".}
proc resized*(this: var FilenameComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc lookAndFeelChanged*(this: var FilenameComponent) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc isInterestedInFileDrag*(this: var FilenameComponent, arg1: StringArray): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInFileDrag(@)".}
proc filesDropped*(this: var FilenameComponent, arg1: StringArray, arg2: cint, arg3: cint) {.header: juce_gui_basics, importcpp: "#.filesDropped(@)".}
proc fileDragEnter*(this: var FilenameComponent, arg1: StringArray, arg2: cint, arg3: cint) {.header: juce_gui_basics, importcpp: "#.fileDragEnter(@)".}
proc fileDragExit*(this: var FilenameComponent, arg1: StringArray) {.header: juce_gui_basics, importcpp: "#.fileDragExit(@)".}
proc createKeyboardFocusTraverser*(this: var FilenameComponent): UniquePtr[ComponentTraverser] {.header: juce_gui_basics, importcpp: "#.createKeyboardFocusTraverser()".}
proc `==`*(this: FilenameComponent, other: FilenameComponent): bool {.error: "juce::FilenameComponent defines no operator==; compare a property instead".}

proc makeFilePreviewComponent*(): FilePreviewComponent {.header: juce_gui_basics, importcpp: "juce::FilePreviewComponent(@)".}
proc selectedFileChanged*(this: var FilePreviewComponent, newSelectedFile: File) {.header: juce_gui_basics, importcpp: "#.selectedFileChanged(@)".}
proc `==`*(this: FilePreviewComponent, other: FilePreviewComponent): bool {.error: "juce::FilePreviewComponent defines no operator==; compare a property instead".}

proc makeFileSearchPathListComponent*(): FileSearchPathListComponent {.header: juce_gui_basics, importcpp: "juce::FileSearchPathListComponent(@)".}
proc getPath*(this: FileSearchPathListComponent): FileSearchPath {.header: juce_gui_basics, importcpp: "#.getPath()".}
proc setPath*(this: var FileSearchPathListComponent, newPath: FileSearchPath) {.header: juce_gui_basics, importcpp: "#.setPath(@)".}
proc setDefaultBrowseTarget*(this: var FileSearchPathListComponent, newDefaultDirectory: File) {.header: juce_gui_basics, importcpp: "#.setDefaultBrowseTarget(@)".}
proc getNumRows*(this: var FileSearchPathListComponent): cint {.header: juce_gui_basics, importcpp: "#.getNumRows()".}
proc paintListBoxItem*(this: var FileSearchPathListComponent, rowNumber: cint, g: var Graphics, width: cint, height: cint, rowIsSelected: bool) {.header: juce_gui_basics, importcpp: "#.paintListBoxItem(@)".}
proc deleteKeyPressed*(this: var FileSearchPathListComponent, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.deleteKeyPressed(@)".}
proc returnKeyPressed*(this: var FileSearchPathListComponent, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.returnKeyPressed(@)".}
proc listBoxItemDoubleClicked*(this: var FileSearchPathListComponent, row: cint, arg2: MouseEvent) {.header: juce_gui_basics, importcpp: "#.listBoxItemDoubleClicked(@)".}
proc selectedRowsChanged*(this: var FileSearchPathListComponent, lastRowSelected: cint) {.header: juce_gui_basics, importcpp: "#.selectedRowsChanged(@)".}
proc resized*(this: var FileSearchPathListComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc paint*(this: var FileSearchPathListComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc isInterestedInFileDrag*(this: var FileSearchPathListComponent, arg1: StringArray): bool {.header: juce_gui_basics, importcpp: "#.isInterestedInFileDrag(@)".}
proc filesDropped*(this: var FileSearchPathListComponent, files: StringArray, arg2: cint, arg3: cint) {.header: juce_gui_basics, importcpp: "#.filesDropped(@)".}
proc `==`*(this: FileSearchPathListComponent, other: FileSearchPathListComponent): bool {.error: "juce::FileSearchPathListComponent defines no operator==; compare a property instead".}

proc makeFileTreeComponent*(listToShow: var DirectoryContentsList): FileTreeComponent {.header: juce_gui_basics, importcpp: "juce::FileTreeComponent(@)".}
proc getNumSelectedFiles*(this: FileTreeComponent): cint {.header: juce_gui_basics, importcpp: "#.getNumSelectedFiles()".}
proc getSelectedFile*(this: FileTreeComponent, index: cint = 0): File {.header: juce_gui_basics, importcpp: "#.getSelectedFile(@)".}
proc deselectAllFiles*(this: var FileTreeComponent) {.header: juce_gui_basics, importcpp: "#.deselectAllFiles()".}
proc scrollToTop*(this: var FileTreeComponent) {.header: juce_gui_basics, importcpp: "#.scrollToTop()".}
proc setSelectedFile*(this: var FileTreeComponent, arg1: File) {.header: juce_gui_basics, importcpp: "#.setSelectedFile(@)".}
proc refresh*(this: var FileTreeComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc setDragAndDropDescription*(this: var FileTreeComponent, description: String) {.header: juce_gui_basics, importcpp: "#.setDragAndDropDescription(@)".}
proc getDragAndDropDescription*(this: FileTreeComponent): String {.header: juce_gui_basics, importcpp: "#.getDragAndDropDescription()".}
proc setItemHeight*(this: var FileTreeComponent, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setItemHeight(@)".}
proc getItemHeight*(this: FileTreeComponent): cint {.header: juce_gui_basics, importcpp: "#.getItemHeight()".}
proc `==`*(this: FileTreeComponent, other: FileTreeComponent): bool {.error: "juce::FileTreeComponent defines no operator==; compare a property instead".}

proc makeImagePreviewComponent*(): ImagePreviewComponent {.header: juce_gui_basics, importcpp: "juce::ImagePreviewComponent(@)".}
proc selectedFileChanged*(this: var ImagePreviewComponent, newSelectedFile: File) {.header: juce_gui_basics, importcpp: "#.selectedFileChanged(@)".}
proc paint*(this: var ImagePreviewComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc timerCallback*(this: var ImagePreviewComponent) {.header: juce_gui_basics, importcpp: "#.timerCallback()".}
proc createAccessibilityHandler*(this: var ImagePreviewComponent): UniquePtr[AccessibilityHandler] {.header: juce_gui_basics, importcpp: "#.createAccessibilityHandler()".}
proc `==`*(this: ImagePreviewComponent, other: ImagePreviewComponent): bool {.error: "juce::ImagePreviewComponent defines no operator==; compare a property instead".}

proc makeContentSharer*(): ContentSharer {.header: juce_gui_basics, importcpp: "juce::ContentSharer(@)".}
proc `==`*(this: ContentSharer, other: ContentSharer): bool {.error: "juce::ContentSharer defines no operator==; compare a property instead".}

proc makePropertyComponent*(propertyName: String, preferredHeight: cint): PropertyComponent {.header: juce_gui_basics, importcpp: "juce::PropertyComponent(@)".}
proc getPreferredHeight*(this: PropertyComponent): cint {.header: juce_gui_basics, importcpp: "#.getPreferredHeight()".}
proc setPreferredHeight*(this: var PropertyComponent, newHeight: cint) {.header: juce_gui_basics, importcpp: "#.setPreferredHeight(@)".}
proc refresh*(this: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc paint*(this: var PropertyComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc enablementChanged*(this: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.enablementChanged()".}
proc `==`*(this: PropertyComponent, other: PropertyComponent): bool {.error: "juce::PropertyComponent defines no operator==; compare a property instead".}

proc makeBooleanPropertyComponent*(valueToControl: Value, propertyName: String, buttonText: String): BooleanPropertyComponent {.header: juce_gui_basics, importcpp: "juce::BooleanPropertyComponent(@)".}
proc setState*(this: var BooleanPropertyComponent, newState: bool) {.header: juce_gui_basics, importcpp: "#.setState(@)".}
proc getState*(this: BooleanPropertyComponent): bool {.header: juce_gui_basics, importcpp: "#.getState()".}
proc paint*(this: var BooleanPropertyComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc refresh*(this: var BooleanPropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc `==`*(this: BooleanPropertyComponent, other: BooleanPropertyComponent): bool {.error: "juce::BooleanPropertyComponent defines no operator==; compare a property instead".}

proc makeButtonPropertyComponent*(propertyName: String, triggerOnMouseDown: bool): ButtonPropertyComponent {.header: juce_gui_basics, importcpp: "juce::ButtonPropertyComponent(@)".}
proc buttonClicked*(this: var ButtonPropertyComponent) {.header: juce_gui_basics, importcpp: "#.buttonClicked()".}
proc getButtonText*(this: ButtonPropertyComponent): String {.header: juce_gui_basics, importcpp: "#.getButtonText()".}
proc refresh*(this: var ButtonPropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc `==`*(this: ButtonPropertyComponent, other: ButtonPropertyComponent): bool {.error: "juce::ButtonPropertyComponent defines no operator==; compare a property instead".}

proc makeChoicePropertyComponent*(valueToControl: Value, propertyName: String, choices: StringArray, correspondingValues: Array[juce_var]): ChoicePropertyComponent {.header: juce_gui_basics, importcpp: "juce::ChoicePropertyComponent(@)".}
proc makeChoicePropertyComponent*(valueToControl: ValueTreePropertyWithDefault, propertyName: String, choices: StringArray, correspondingValues: Array[juce_var]): ChoicePropertyComponent {.header: juce_gui_basics, importcpp: "juce::ChoicePropertyComponent(@)".}
proc makeChoicePropertyComponent*(valueToControl: ValueTreePropertyWithDefault, propertyName: String): ChoicePropertyComponent {.header: juce_gui_basics, importcpp: "juce::ChoicePropertyComponent(@)".}
proc setIndex*(this: var ChoicePropertyComponent, newIndex: cint) {.header: juce_gui_basics, importcpp: "#.setIndex(@)".}
proc getIndex*(this: ChoicePropertyComponent): cint {.header: juce_gui_basics, importcpp: "#.getIndex()".}
proc getChoices*(this: ChoicePropertyComponent): StringArray {.header: juce_gui_basics, importcpp: "#.getChoices()".}
proc refresh*(this: var ChoicePropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc `==`*(this: ChoicePropertyComponent, other: ChoicePropertyComponent): bool {.error: "juce::ChoicePropertyComponent defines no operator==; compare a property instead".}

proc makePropertyPanel*(): PropertyPanel {.header: juce_gui_basics, importcpp: "juce::PropertyPanel(@)".}
proc makePropertyPanel*(name: String): PropertyPanel {.header: juce_gui_basics, importcpp: "juce::PropertyPanel(@)".}
proc clear*(this: var PropertyPanel) {.header: juce_gui_basics, importcpp: "#.clear()".}
proc addProperties*(this: var PropertyPanel, newPropertyComponents: Array[PropertyComponent], extraPaddingBetweenComponents: cint = 0) {.header: juce_gui_basics, importcpp: "#.addProperties(@)".}
proc addSection*(this: var PropertyPanel, sectionTitle: String, newPropertyComponents: Array[PropertyComponent], shouldSectionInitiallyBeOpen: bool = true, indexToInsertAt: cint = -1, extraPaddingBetweenComponents: cint = 0) {.header: juce_gui_basics, importcpp: "#.addSection(@)".}
proc refreshAll*(this: PropertyPanel) {.header: juce_gui_basics, importcpp: "#.refreshAll()".}
proc isEmpty*(this: PropertyPanel): bool {.header: juce_gui_basics, importcpp: "#.isEmpty()".}
proc getTotalContentHeight*(this: PropertyPanel): cint {.header: juce_gui_basics, importcpp: "#.getTotalContentHeight()".}
proc getSectionNames*(this: PropertyPanel): StringArray {.header: juce_gui_basics, importcpp: "#.getSectionNames()".}
proc isSectionOpen*(this: PropertyPanel, sectionIndex: cint): bool {.header: juce_gui_basics, importcpp: "#.isSectionOpen(@)".}
proc setSectionOpen*(this: var PropertyPanel, sectionIndex: cint, shouldBeOpen: bool) {.header: juce_gui_basics, importcpp: "#.setSectionOpen(@)".}
proc setSectionEnabled*(this: var PropertyPanel, sectionIndex: cint, shouldBeEnabled: bool) {.header: juce_gui_basics, importcpp: "#.setSectionEnabled(@)".}
proc removeSection*(this: var PropertyPanel, sectionIndex: cint) {.header: juce_gui_basics, importcpp: "#.removeSection(@)".}
proc getOpennessState*(this: PropertyPanel): UniquePtr[XmlElement] {.header: juce_gui_basics, importcpp: "#.getOpennessState()".}
proc restoreOpennessState*(this: var PropertyPanel, newState: XmlElement) {.header: juce_gui_basics, importcpp: "#.restoreOpennessState(@)".}
proc setMessageWhenEmpty*(this: var PropertyPanel, newMessage: String) {.header: juce_gui_basics, importcpp: "#.setMessageWhenEmpty(@)".}
proc getMessageWhenEmpty*(this: PropertyPanel): String {.header: juce_gui_basics, importcpp: "#.getMessageWhenEmpty()".}
proc getViewport*(this: var PropertyPanel): var Viewport {.header: juce_gui_basics, importcpp: "#.getViewport()".}
proc paint*(this: var PropertyPanel, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var PropertyPanel) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc `==`*(this: PropertyPanel, other: PropertyPanel): bool {.error: "juce::PropertyPanel defines no operator==; compare a property instead".}

proc makeSliderPropertyComponent*(valueToControl: Value, propertyName: String, rangeMin: float64, rangeMax: float64, interval: float64, skewFactor: float64, symmetricSkew: bool): SliderPropertyComponent {.header: juce_gui_basics, importcpp: "juce::SliderPropertyComponent(@)".}
proc setValue*(this: var SliderPropertyComponent, newValue: float64) {.header: juce_gui_basics, importcpp: "#.setValue(@)".}
proc getValue*(this: SliderPropertyComponent): float64 {.header: juce_gui_basics, importcpp: "#.getValue()".}
proc refresh*(this: var SliderPropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc `==`*(this: SliderPropertyComponent, other: SliderPropertyComponent): bool {.error: "juce::SliderPropertyComponent defines no operator==; compare a property instead".}

proc makeTextPropertyComponent*(valueToControl: Value, propertyName: String, maxNumChars: cint, isMultiLine: bool, isEditable: bool): TextPropertyComponent {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent(@)".}
proc makeTextPropertyComponent*(valueToControl: ValueTreePropertyWithDefault, propertyName: String, maxNumChars: cint, isMultiLine: bool, isEditable: bool): TextPropertyComponent {.header: juce_gui_basics, importcpp: "juce::TextPropertyComponent(@)".}
proc setText*(this: var TextPropertyComponent, newText: String) {.header: juce_gui_basics, importcpp: "#.setText(@)".}
proc getText*(this: TextPropertyComponent): String {.header: juce_gui_basics, importcpp: "#.getText()".}
proc getValue*(this: TextPropertyComponent): var Value {.header: juce_gui_basics, importcpp: "#.getValue()".}
proc isTextEditorMultiLine*(this: TextPropertyComponent): bool {.header: juce_gui_basics, importcpp: "#.isTextEditorMultiLine()".}
proc colourChanged*(this: var TextPropertyComponent) {.header: juce_gui_basics, importcpp: "#.colourChanged()".}
proc addListener*(this: var TextPropertyComponent, newListener: ptr TextPropertyComponentListener) {.header: juce_gui_basics, importcpp: "#.addListener(@)".}
proc removeListener*(this: var TextPropertyComponent, listener: ptr TextPropertyComponentListener) {.header: juce_gui_basics, importcpp: "#.removeListener(@)".}
proc setInterestedInFileDrag*(this: var TextPropertyComponent, isInterested: bool) {.header: juce_gui_basics, importcpp: "#.setInterestedInFileDrag(@)".}
proc setEditable*(this: var TextPropertyComponent, isEditable: bool) {.header: juce_gui_basics, importcpp: "#.setEditable(@)".}
proc refresh*(this: var TextPropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc textWasEdited*(this: var TextPropertyComponent) {.header: juce_gui_basics, importcpp: "#.textWasEdited()".}
proc `==`*(this: TextPropertyComponent, other: TextPropertyComponent): bool {.error: "juce::TextPropertyComponent defines no operator==; compare a property instead".}

proc makeMultiChoicePropertyComponent*(valueToControl: Value, propertyName: String, choices: StringArray, correspondingValues: Array[juce_var], maxChoices: cint): MultiChoicePropertyComponent {.header: juce_gui_basics, importcpp: "juce::MultiChoicePropertyComponent(@)".}
proc makeMultiChoicePropertyComponent*(valueToControl: ValueTreePropertyWithDefault, propertyName: String, choices: StringArray, correspondingValues: Array[juce_var], maxChoices: cint): MultiChoicePropertyComponent {.header: juce_gui_basics, importcpp: "juce::MultiChoicePropertyComponent(@)".}
proc isExpanded*(this: MultiChoicePropertyComponent): bool {.header: juce_gui_basics, importcpp: "#.isExpanded()".}
proc isExpandable*(this: MultiChoicePropertyComponent): bool {.header: juce_gui_basics, importcpp: "#.isExpandable()".}
proc setExpanded*(this: var MultiChoicePropertyComponent, expanded: bool) {.header: juce_gui_basics, importcpp: "#.setExpanded(@)".}
proc paint*(this: var MultiChoicePropertyComponent, g: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc resized*(this: var MultiChoicePropertyComponent) {.header: juce_gui_basics, importcpp: "#.resized()".}
proc refresh*(this: var MultiChoicePropertyComponent) {.header: juce_gui_basics, importcpp: "#.refresh()".}
proc `==`*(this: MultiChoicePropertyComponent, other: MultiChoicePropertyComponent): bool {.error: "juce::MultiChoicePropertyComponent defines no operator==; compare a property instead".}

proc makeJUCEApplicationImpl*(): JUCEApplicationImpl {.header: juce_gui_basics, importcpp: "juce::JUCEApplication(@)".}
proc moreThanOneInstanceAllowed*(this: var JUCEApplicationImpl): bool {.header: juce_gui_basics, importcpp: "#.moreThanOneInstanceAllowed()".}
proc anotherInstanceStarted*(this: var JUCEApplicationImpl, commandLine: String) {.header: juce_gui_basics, importcpp: "#.anotherInstanceStarted(@)".}
proc systemRequestedQuit*(this: var JUCEApplicationImpl) {.header: juce_gui_basics, importcpp: "#.systemRequestedQuit()".}
proc suspended*(this: var JUCEApplicationImpl) {.header: juce_gui_basics, importcpp: "#.suspended()".}
proc resumed*(this: var JUCEApplicationImpl) {.header: juce_gui_basics, importcpp: "#.resumed()".}
proc unhandledException*(this: var JUCEApplicationImpl, e: ptr CppException, sourceFilename: String, lineNumber: cint) {.header: juce_gui_basics, importcpp: "#.unhandledException(@)".}
proc getNextCommandTarget*(this: var JUCEApplicationImpl): ptr ApplicationCommandTarget {.header: juce_gui_basics, importcpp: "#.getNextCommandTarget()".}
proc getCommandInfo*(this: var JUCEApplicationImpl, arg1: cint, arg2: var ApplicationCommandInfo) {.header: juce_gui_basics, importcpp: "#.getCommandInfo(@)".}
proc getAllCommands*(this: var JUCEApplicationImpl, arg1: Array[cint]) {.header: juce_gui_basics, importcpp: "#.getAllCommands(@)".}
proc perform*(this: var JUCEApplicationImpl, arg1: ApplicationCommandTargetInvocationInfo): bool {.header: juce_gui_basics, importcpp: "#.perform(@)".}
proc `==`*(this: JUCEApplicationImpl, other: JUCEApplicationImpl): bool {.error: "juce::JUCEApplication defines no operator==; compare a property instead".}

proc setAllowedPlacement*(this: var BubbleComponent, newPlacement: cint) {.header: juce_gui_basics, importcpp: "#.setAllowedPlacement(@)".}
proc setPosition*(this: var BubbleComponent, componentToPointTo: ptr Component, distanceFromTarget: cint = 15, arrowLength: cint = 10) {.header: juce_gui_basics, importcpp: "#.setPosition(@)".}
proc setPosition*(this: var BubbleComponent, arrowTipPosition: Point[cint], arrowLength: cint = 10) {.header: juce_gui_basics, importcpp: "#.setPosition(@)".}
proc setPosition*(this: var BubbleComponent, rectangleToPointTo: Rectangle[cint], distanceFromTarget: cint = 15, arrowLength: cint = 10) {.header: juce_gui_basics, importcpp: "#.setPosition(@)".}
proc paint*(this: var BubbleComponent, arg1: var Graphics) {.header: juce_gui_basics, importcpp: "#.paint(@)".}
proc lookAndFeelChanged*(this: var BubbleComponent) {.header: juce_gui_basics, importcpp: "#.lookAndFeelChanged()".}
proc `==`*(this: BubbleComponent, other: BubbleComponent): bool {.error: "juce::BubbleComponent defines no operator==; compare a property instead".}

proc `==`*(this: ExtraLookAndFeelBaseClasses, other: ExtraLookAndFeelBaseClasses): bool {.error: "juce::ExtraLookAndFeelBaseClasses defines no operator==; compare a property instead".}

proc makeLookAndFeel*(): LookAndFeel {.header: juce_gui_basics, importcpp: "juce::LookAndFeel(@)".}
proc findColour*(this: LookAndFeel, colourId: cint): Colour {.header: juce_gui_basics, importcpp: "#.findColour(@)".}
proc setColour*(this: var LookAndFeel, colourId: cint, colour: Colour) {.header: juce_gui_basics, importcpp: "#.setColour(@)".}
proc isColourSpecified*(this: LookAndFeel, colourId: cint): bool {.header: juce_gui_basics, importcpp: "#.isColourSpecified(@)".}
proc getTypefaceForFont*(this: var LookAndFeel, arg1: Font): ReferenceCountedObjectPtr[Typeface] {.header: juce_gui_basics, importcpp: "#.getTypefaceForFont(@)".}
proc getDefaultMetricsKind*(this: LookAndFeel): TypefaceMetricsKind {.header: juce_gui_basics, importcpp: "#.getDefaultMetricsKind()".}
proc withDefaultMetrics*(this: LookAndFeel, opt: FontOptions): FontOptions {.header: juce_gui_basics, importcpp: "#.withDefaultMetrics(@)".}
proc setDefaultSansSerifTypeface*(this: var LookAndFeel, newDefaultTypeface: ReferenceCountedObjectPtr[Typeface]) {.header: juce_gui_basics, importcpp: "#.setDefaultSansSerifTypeface(@)".}
proc setDefaultSansSerifTypefaceName*(this: var LookAndFeel, newName: String) {.header: juce_gui_basics, importcpp: "#.setDefaultSansSerifTypefaceName(@)".}
proc setUsingNativeAlertWindows*(this: var LookAndFeel, shouldUseNativeAlerts: bool) {.header: juce_gui_basics, importcpp: "#.setUsingNativeAlertWindows(@)".}
proc isUsingNativeAlertWindows*(this: var LookAndFeel): bool {.header: juce_gui_basics, importcpp: "#.isUsingNativeAlertWindows()".}
proc drawSpinningWaitAnimation*(this: var LookAndFeel, arg1: var Graphics, colour: Colour, x: cint, y: cint, w: cint, h: cint) {.header: juce_gui_basics, importcpp: "#.drawSpinningWaitAnimation(@)".}
proc getTickShape*(this: var LookAndFeel, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getTickShape(@)".}
proc getCrossShape*(this: var LookAndFeel, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getCrossShape(@)".}
proc createDropShadowerForComponent*(this: var LookAndFeel, arg1: var Component): UniquePtr[DropShadower] {.header: juce_gui_basics, importcpp: "#.createDropShadowerForComponent(@)".}
proc createFocusOutlineForComponent*(this: var LookAndFeel, arg1: var Component): UniquePtr[FocusOutline] {.header: juce_gui_basics, importcpp: "#.createFocusOutlineForComponent(@)".}
proc getMouseCursorFor*(this: var LookAndFeel, arg1: var Component): MouseCursor {.header: juce_gui_basics, importcpp: "#.getMouseCursorFor(@)".}
proc createGraphicsContext*(this: var LookAndFeel, imageToRenderOn: Image, origin: Point[cint], initialClip: RectangleList[cint]): UniquePtr[LowLevelGraphicsContext] {.header: juce_gui_basics, importcpp: "#.createGraphicsContext(@)".}
proc playAlertSound*(this: var LookAndFeel) {.header: juce_gui_basics, importcpp: "#.playAlertSound()".}
proc `==`*(this: LookAndFeel, other: LookAndFeel): bool {.error: "juce::LookAndFeel defines no operator==; compare a property instead".}

proc makeLookAndFeel_V2*(): LookAndFeel_V2 {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V2(@)".}
proc drawButtonBackground*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var Button, backgroundColour: Colour, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawButtonBackground(@)".}
proc getTextButtonFont*(this: var LookAndFeel_V2, arg1: var TextButton, buttonHeight: cint): Font {.header: juce_gui_basics, importcpp: "#.getTextButtonFont(@)".}
proc drawButtonText*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var TextButton, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawButtonText(@)".}
proc getTextButtonWidthToFitText*(this: var LookAndFeel_V2, arg1: var TextButton, buttonHeight: cint): cint {.header: juce_gui_basics, importcpp: "#.getTextButtonWidthToFitText(@)".}
proc drawToggleButton*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var ToggleButton, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawToggleButton(@)".}
proc changeToggleButtonWidthToFitText*(this: var LookAndFeel_V2, arg1: var ToggleButton) {.header: juce_gui_basics, importcpp: "#.changeToggleButtonWidthToFitText(@)".}
proc drawTickBox*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var Component, x: cfloat, y: cfloat, w: cfloat, h: cfloat, ticked: bool, isEnabled: bool, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawTickBox(@)".}
proc drawDrawableButton*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var DrawableButton, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawDrawableButton(@)".}
proc createAlertWindow*(this: var LookAndFeel_V2, title: String, message: String, button1: String, button2: String, button3: String, iconType: MessageBoxIconType, numButtons: cint, associatedComponent: ptr Component): ptr AlertWindow {.header: juce_gui_basics, importcpp: "#.createAlertWindow(@)".}
proc drawAlertBox*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var AlertWindow, textArea: Rectangle[cint], arg4: var TextLayout) {.header: juce_gui_basics, importcpp: "#.drawAlertBox(@)".}
proc getAlertBoxWindowFlags*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getAlertBoxWindowFlags()".}
proc getWidthsForTextButtons*(this: var LookAndFeel_V2, arg1: var AlertWindow, arg2: Array[TextButton]): Array[cint] {.header: juce_gui_basics, importcpp: "#.getWidthsForTextButtons(@)".}
proc getAlertWindowButtonHeight*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getAlertWindowButtonHeight()".}
proc getAlertWindowTitleFont*(this: var LookAndFeel_V2): Font {.header: juce_gui_basics, importcpp: "#.getAlertWindowTitleFont()".}
proc getAlertWindowMessageFont*(this: var LookAndFeel_V2): Font {.header: juce_gui_basics, importcpp: "#.getAlertWindowMessageFont()".}
proc getAlertWindowFont*(this: var LookAndFeel_V2): Font {.header: juce_gui_basics, importcpp: "#.getAlertWindowFont()".}
proc drawProgressBar*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var ProgressBar, width: cint, height: cint, progress: float64, textToShow: String) {.header: juce_gui_basics, importcpp: "#.drawProgressBar(@)".}
proc drawSpinningWaitAnimation*(this: var LookAndFeel_V2, arg1: var Graphics, colour: Colour, x: cint, y: cint, w: cint, h: cint) {.header: juce_gui_basics, importcpp: "#.drawSpinningWaitAnimation(@)".}
proc isProgressBarOpaque*(this: var LookAndFeel_V2, arg1: var ProgressBar): bool {.header: juce_gui_basics, importcpp: "#.isProgressBarOpaque(@)".}
proc getDefaultProgressBarStyle*(this: var LookAndFeel_V2, arg1: ProgressBar): ProgressBarStyle {.header: juce_gui_basics, importcpp: "#.getDefaultProgressBarStyle(@)".}
proc areScrollbarButtonsVisible*(this: var LookAndFeel_V2): bool {.header: juce_gui_basics, importcpp: "#.areScrollbarButtonsVisible()".}
proc drawScrollbarButton*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var ScrollBar, width: cint, height: cint, buttonDirection: cint, isScrollbarVertical: bool, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawScrollbarButton(@)".}
proc drawScrollbar*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var ScrollBar, x: cint, y: cint, width: cint, height: cint, isScrollbarVertical: bool, thumbStartPosition: cint, thumbSize: cint, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawScrollbar(@)".}
proc getScrollbarEffect*(this: var LookAndFeel_V2): ptr ImageEffectFilter {.header: juce_gui_basics, importcpp: "#.getScrollbarEffect()".}
proc getMinimumScrollbarThumbSize*(this: var LookAndFeel_V2, arg1: var ScrollBar): cint {.header: juce_gui_basics, importcpp: "#.getMinimumScrollbarThumbSize(@)".}
proc getDefaultScrollbarWidth*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getDefaultScrollbarWidth()".}
proc getScrollbarButtonSize*(this: var LookAndFeel_V2, arg1: var ScrollBar): cint {.header: juce_gui_basics, importcpp: "#.getScrollbarButtonSize(@)".}
proc getTickShape*(this: var LookAndFeel_V2, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getTickShape(@)".}
proc getCrossShape*(this: var LookAndFeel_V2, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getCrossShape(@)".}
proc drawTreeviewPlusMinusBox*(this: var LookAndFeel_V2, arg1: var Graphics, area: Rectangle[cfloat], backgroundColour: Colour, isOpen: bool, isMouseOver: bool) {.header: juce_gui_basics, importcpp: "#.drawTreeviewPlusMinusBox(@)".}
proc areLinesDrawnForTreeView*(this: var LookAndFeel_V2, arg1: var TreeView): bool {.header: juce_gui_basics, importcpp: "#.areLinesDrawnForTreeView(@)".}
proc getTreeViewIndentSize*(this: var LookAndFeel_V2, arg1: var TreeView): cint {.header: juce_gui_basics, importcpp: "#.getTreeViewIndentSize(@)".}
proc fillTextEditorBackground*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: var TextEditor) {.header: juce_gui_basics, importcpp: "#.fillTextEditorBackground(@)".}
proc drawTextEditorOutline*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: var TextEditor) {.header: juce_gui_basics, importcpp: "#.drawTextEditorOutline(@)".}
proc createCaretComponent*(this: var LookAndFeel_V2, keyFocusOwner: ptr Component): ptr CaretComponent {.header: juce_gui_basics, importcpp: "#.createCaretComponent(@)".}
proc getDefaultFolderImage*(this: var LookAndFeel_V2): ptr Drawable {.header: juce_gui_basics, importcpp: "#.getDefaultFolderImage()".}
proc getDefaultDocumentFileImage*(this: var LookAndFeel_V2): ptr Drawable {.header: juce_gui_basics, importcpp: "#.getDefaultDocumentFileImage()".}
proc createFileChooserHeaderText*(this: var LookAndFeel_V2, title: String, instructions: String): AttributedString {.header: juce_gui_basics, importcpp: "#.createFileChooserHeaderText(@)".}
proc drawFileBrowserRow*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, file: File, filename: String, icon: ptr Image, fileSizeDescription: String, fileTimeDescription: String, isDirectory: bool, isItemSelected: bool, itemIndex: cint, arg12: var DirectoryContentsDisplayComponent) {.header: juce_gui_basics, importcpp: "#.drawFileBrowserRow(@)".}
proc createFileBrowserGoUpButton*(this: var LookAndFeel_V2): ptr Button {.header: juce_gui_basics, importcpp: "#.createFileBrowserGoUpButton()".}
proc layoutFileBrowserComponent*(this: var LookAndFeel_V2, arg1: var FileBrowserComponent, arg2: ptr DirectoryContentsDisplayComponent, arg3: ptr FilePreviewComponent, currentPathBox: ptr ComboBox, filenameBox: ptr TextEditor, goUpButton: ptr Button) {.header: juce_gui_basics, importcpp: "#.layoutFileBrowserComponent(@)".}
proc drawBubble*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var BubbleComponent, tip: Point[cfloat], body: Rectangle[cfloat]) {.header: juce_gui_basics, importcpp: "#.drawBubble(@)".}
proc setComponentEffectForBubbleComponent*(this: var LookAndFeel_V2, bubbleComponent: var BubbleComponent) {.header: juce_gui_basics, importcpp: "#.setComponentEffectForBubbleComponent(@)".}
proc drawLasso*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var Component) {.header: juce_gui_basics, importcpp: "#.drawLasso(@)".}
proc drawPopupMenuBackground*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuBackground(@)".}
proc drawPopupMenuBackgroundWithOptions*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuBackgroundWithOptions(@)".}
proc drawPopupMenuItem*(this: var LookAndFeel_V2, arg1: var Graphics, area: Rectangle[cint], isSeparator: bool, isActive: bool, isHighlighted: bool, isTicked: bool, hasSubMenu: bool, text: String, shortcutKeyText: String, icon: ptr Drawable, textColour: ptr Colour) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuItem(@)".}
proc drawPopupMenuItemWithOptions*(this: var LookAndFeel_V2, arg1: var Graphics, area: Rectangle[cint], isHighlighted: bool, item: PopupMenuItem, arg5: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuItemWithOptions(@)".}
proc drawPopupMenuSectionHeader*(this: var LookAndFeel_V2, arg1: var Graphics, area: Rectangle[cint], sectionName: String) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuSectionHeader(@)".}
proc drawPopupMenuSectionHeaderWithOptions*(this: var LookAndFeel_V2, arg1: var Graphics, area: Rectangle[cint], sectionName: String, arg4: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuSectionHeaderWithOptions(@)".}
proc getPopupMenuFont*(this: var LookAndFeel_V2): Font {.header: juce_gui_basics, importcpp: "#.getPopupMenuFont()".}
proc drawPopupMenuUpDownArrow*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, isScrollUpArrow: bool) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuUpDownArrow(@)".}
proc drawPopupMenuUpDownArrowWithOptions*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, isScrollUpArrow: bool, arg5: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuUpDownArrowWithOptions(@)".}
proc getIdealPopupMenuItemSize*(this: var LookAndFeel_V2, text: String, isSeparator: bool, standardMenuItemHeight: cint, idealWidth: var cint, idealHeight: var cint) {.header: juce_gui_basics, importcpp: "#.getIdealPopupMenuItemSize(@)".}
proc getIdealPopupMenuItemSizeWithOptions*(this: var LookAndFeel_V2, text: String, isSeparator: bool, standardMenuItemHeight: cint, idealWidth: var cint, idealHeight: var cint, arg6: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.getIdealPopupMenuItemSizeWithOptions(@)".}
proc getIdealPopupMenuSectionHeaderSizeWithOptions*(this: var LookAndFeel_V2, text: String, standardMenuItemHeight: cint, idealWidth: var cint, idealHeight: var cint, arg5: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.getIdealPopupMenuSectionHeaderSizeWithOptions(@)".}
proc getMenuWindowFlags*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getMenuWindowFlags()".}
proc preparePopupMenuWindow*(this: var LookAndFeel_V2, arg1: var Component) {.header: juce_gui_basics, importcpp: "#.preparePopupMenuWindow(@)".}
proc drawMenuBarBackground*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, isMouseOverBar: bool, arg5: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.drawMenuBarBackground(@)".}
proc getMenuBarItemWidth*(this: var LookAndFeel_V2, arg1: var MenuBarComponent, itemIndex: cint, itemText: String): cint {.header: juce_gui_basics, importcpp: "#.getMenuBarItemWidth(@)".}
proc getMenuBarFont*(this: var LookAndFeel_V2, arg1: var MenuBarComponent, itemIndex: cint, itemText: String): Font {.header: juce_gui_basics, importcpp: "#.getMenuBarFont(@)".}
proc getDefaultMenuBarHeight*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getDefaultMenuBarHeight()".}
proc drawMenuBarItem*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, itemIndex: cint, itemText: String, isMouseOverItem: bool, isMenuOpen: bool, isMouseOverBar: bool, arg9: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.drawMenuBarItem(@)".}
proc getParentComponentForMenuOptions*(this: var LookAndFeel_V2, options: PopupMenuOptions): ptr Component {.header: juce_gui_basics, importcpp: "#.getParentComponentForMenuOptions(@)".}
proc shouldPopupMenuScaleWithTargetComponent*(this: var LookAndFeel_V2, options: PopupMenuOptions): bool {.header: juce_gui_basics, importcpp: "#.shouldPopupMenuScaleWithTargetComponent(@)".}
proc getPopupMenuBorderSize*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getPopupMenuBorderSize()".}
proc getPopupMenuBorderSizeWithOptions*(this: var LookAndFeel_V2, arg1: PopupMenuOptions): cint {.header: juce_gui_basics, importcpp: "#.getPopupMenuBorderSizeWithOptions(@)".}
proc drawPopupMenuColumnSeparatorWithOptions*(this: var LookAndFeel_V2, g: var Graphics, bounds: Rectangle[cint], arg3: PopupMenuOptions) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuColumnSeparatorWithOptions(@)".}
proc getPopupMenuColumnSeparatorWidthWithOptions*(this: var LookAndFeel_V2, arg1: PopupMenuOptions): cint {.header: juce_gui_basics, importcpp: "#.getPopupMenuColumnSeparatorWidthWithOptions(@)".}
proc drawComboBox*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, isMouseButtonDown: bool, buttonX: cint, buttonY: cint, buttonW: cint, buttonH: cint, arg9: var ComboBox) {.header: juce_gui_basics, importcpp: "#.drawComboBox(@)".}
proc getComboBoxFont*(this: var LookAndFeel_V2, arg1: var ComboBox): Font {.header: juce_gui_basics, importcpp: "#.getComboBoxFont(@)".}
proc createComboBoxTextBox*(this: var LookAndFeel_V2, arg1: var ComboBox): ptr Label {.header: juce_gui_basics, importcpp: "#.createComboBoxTextBox(@)".}
proc positionComboBoxText*(this: var LookAndFeel_V2, arg1: var ComboBox, arg2: var Label) {.header: juce_gui_basics, importcpp: "#.positionComboBoxText(@)".}
proc getOptionsForComboBoxPopupMenu*(this: var LookAndFeel_V2, arg1: var ComboBox, arg2: var Label): PopupMenuOptions {.header: juce_gui_basics, importcpp: "#.getOptionsForComboBoxPopupMenu(@)".}
proc drawComboBoxTextWhenNothingSelected*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var ComboBox, arg3: var Label) {.header: juce_gui_basics, importcpp: "#.drawComboBoxTextWhenNothingSelected(@)".}
proc drawLabel*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var Label) {.header: juce_gui_basics, importcpp: "#.drawLabel(@)".}
proc getLabelFont*(this: var LookAndFeel_V2, arg1: var Label): Font {.header: juce_gui_basics, importcpp: "#.getLabelFont(@)".}
proc getLabelBorderSize*(this: var LookAndFeel_V2, arg1: var Label): BorderSize[cint] {.header: juce_gui_basics, importcpp: "#.getLabelBorderSize(@)".}
proc drawLinearSlider*(this: var LookAndFeel_V2, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSlider(@)".}
proc drawLinearSliderBackground*(this: var LookAndFeel_V2, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSliderBackground(@)".}
proc drawLinearSliderOutline*(this: var LookAndFeel_V2, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, arg6: SliderSliderStyle, arg7: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSliderOutline(@)".}
proc drawLinearSliderThumb*(this: var LookAndFeel_V2, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSliderThumb(@)".}
proc drawRotarySlider*(this: var LookAndFeel_V2, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPosProportional: cfloat, rotaryStartAngle: cfloat, rotaryEndAngle: cfloat, arg9: var Slider) {.header: juce_gui_basics, importcpp: "#.drawRotarySlider(@)".}
proc getSliderThumbRadius*(this: var LookAndFeel_V2, arg1: var Slider): cint {.header: juce_gui_basics, importcpp: "#.getSliderThumbRadius(@)".}
proc createSliderButton*(this: var LookAndFeel_V2, arg1: var Slider, isIncrement: bool): ptr Button {.header: juce_gui_basics, importcpp: "#.createSliderButton(@)".}
proc createSliderTextBox*(this: var LookAndFeel_V2, arg1: var Slider): ptr Label {.header: juce_gui_basics, importcpp: "#.createSliderTextBox(@)".}
proc getSliderEffect*(this: var LookAndFeel_V2, arg1: var Slider): ptr ImageEffectFilter {.header: juce_gui_basics, importcpp: "#.getSliderEffect(@)".}
proc getSliderPopupFont*(this: var LookAndFeel_V2, arg1: var Slider): Font {.header: juce_gui_basics, importcpp: "#.getSliderPopupFont(@)".}
proc getSliderPopupPlacement*(this: var LookAndFeel_V2, arg1: var Slider): cint {.header: juce_gui_basics, importcpp: "#.getSliderPopupPlacement(@)".}
proc getSliderLayout*(this: var LookAndFeel_V2, arg1: var Slider): SliderSliderLayout {.header: juce_gui_basics, importcpp: "#.getSliderLayout(@)".}
proc getTooltipBounds*(this: var LookAndFeel_V2, tipText: String, screenPos: Point[cint], parentArea: Rectangle[cint]): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getTooltipBounds(@)".}
proc drawTooltip*(this: var LookAndFeel_V2, arg1: var Graphics, text: String, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawTooltip(@)".}
proc createFilenameComponentBrowseButton*(this: var LookAndFeel_V2, text: String): ptr Button {.header: juce_gui_basics, importcpp: "#.createFilenameComponentBrowseButton(@)".}
proc layoutFilenameComponent*(this: var LookAndFeel_V2, arg1: var FilenameComponent, filenameBox: ptr ComboBox, browseButton: ptr Button) {.header: juce_gui_basics, importcpp: "#.layoutFilenameComponent(@)".}
proc drawConcertinaPanelHeader*(this: var LookAndFeel_V2, arg1: var Graphics, area: Rectangle[cint], isMouseOver: bool, isMouseDown: bool, arg5: var ConcertinaPanel, panel: var Component) {.header: juce_gui_basics, importcpp: "#.drawConcertinaPanelHeader(@)".}
proc drawCornerResizer*(this: var LookAndFeel_V2, arg1: var Graphics, w: cint, h: cint, isMouseOver: bool, isMouseDragging: bool) {.header: juce_gui_basics, importcpp: "#.drawCornerResizer(@)".}
proc drawResizableFrame*(this: var LookAndFeel_V2, arg1: var Graphics, w: cint, h: cint, arg4: BorderSize[cint]) {.header: juce_gui_basics, importcpp: "#.drawResizableFrame(@)".}
proc fillResizableWindowBackground*(this: var LookAndFeel_V2, arg1: var Graphics, w: cint, h: cint, arg4: BorderSize[cint], arg5: var ResizableWindow) {.header: juce_gui_basics, importcpp: "#.fillResizableWindowBackground(@)".}
proc drawResizableWindowBorder*(this: var LookAndFeel_V2, arg1: var Graphics, w: cint, h: cint, border: BorderSize[cint], arg5: var ResizableWindow) {.header: juce_gui_basics, importcpp: "#.drawResizableWindowBorder(@)".}
proc drawDocumentWindowTitleBar*(this: var LookAndFeel_V2, arg1: var DocumentWindowImpl, arg2: var Graphics, w: cint, h: cint, titleSpaceX: cint, titleSpaceW: cint, icon: ptr Image, drawTitleTextOnLeft: bool) {.header: juce_gui_basics, importcpp: "#.drawDocumentWindowTitleBar(@)".}
proc createDocumentWindowButton*(this: var LookAndFeel_V2, buttonType: cint): ptr Button {.header: juce_gui_basics, importcpp: "#.createDocumentWindowButton(@)".}
proc positionDocumentWindowButtons*(this: var LookAndFeel_V2, arg1: var DocumentWindowImpl, titleBarX: cint, titleBarY: cint, titleBarW: cint, titleBarH: cint, minimiseButton: ptr Button, maximiseButton: ptr Button, closeButton: ptr Button, positionTitleBarButtonsOnLeft: bool) {.header: juce_gui_basics, importcpp: "#.positionDocumentWindowButtons(@)".}
proc createDropShadowerForComponent*(this: var LookAndFeel_V2, arg1: var Component): UniquePtr[DropShadower] {.header: juce_gui_basics, importcpp: "#.createDropShadowerForComponent(@)".}
proc createFocusOutlineForComponent*(this: var LookAndFeel_V2, arg1: var Component): UniquePtr[FocusOutline] {.header: juce_gui_basics, importcpp: "#.createFocusOutlineForComponent(@)".}
proc drawStretchableLayoutResizerBar*(this: var LookAndFeel_V2, arg1: var Graphics, w: cint, h: cint, isVerticalBar: bool, isMouseOver: bool, isMouseDragging: bool) {.header: juce_gui_basics, importcpp: "#.drawStretchableLayoutResizerBar(@)".}
proc drawGroupComponentOutline*(this: var LookAndFeel_V2, arg1: var Graphics, w: cint, h: cint, text: String, arg5: Justification, arg6: var GroupComponent) {.header: juce_gui_basics, importcpp: "#.drawGroupComponentOutline(@)".}
proc getTabButtonSpaceAroundImage*(this: var LookAndFeel_V2): cint {.header: juce_gui_basics, importcpp: "#.getTabButtonSpaceAroundImage()".}
proc getTabButtonOverlap*(this: var LookAndFeel_V2, tabDepth: cint): cint {.header: juce_gui_basics, importcpp: "#.getTabButtonOverlap(@)".}
proc getTabButtonBestWidth*(this: var LookAndFeel_V2, arg1: var TabBarButton, tabDepth: cint): cint {.header: juce_gui_basics, importcpp: "#.getTabButtonBestWidth(@)".}
proc getTabButtonExtraComponentBounds*(this: var LookAndFeel_V2, arg1: TabBarButton, textArea: Rectangle[cint], extraComp: var Component): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getTabButtonExtraComponentBounds(@)".}
proc drawTabButton*(this: var LookAndFeel_V2, arg1: var TabBarButton, arg2: var Graphics, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawTabButton(@)".}
proc getTabButtonFont*(this: var LookAndFeel_V2, arg1: var TabBarButton, height: cfloat): Font {.header: juce_gui_basics, importcpp: "#.getTabButtonFont(@)".}
proc drawTabButtonText*(this: var LookAndFeel_V2, arg1: var TabBarButton, arg2: var Graphics, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawTabButtonText(@)".}
proc drawTabbedButtonBarBackground*(this: var LookAndFeel_V2, arg1: var TabbedButtonBar, arg2: var Graphics) {.header: juce_gui_basics, importcpp: "#.drawTabbedButtonBarBackground(@)".}
proc drawTabAreaBehindFrontButton*(this: var LookAndFeel_V2, arg1: var TabbedButtonBar, arg2: var Graphics, w: cint, h: cint) {.header: juce_gui_basics, importcpp: "#.drawTabAreaBehindFrontButton(@)".}
proc createTabButtonShape*(this: var LookAndFeel_V2, arg1: var TabBarButton, arg2: var Path, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.createTabButtonShape(@)".}
proc fillTabButtonShape*(this: var LookAndFeel_V2, arg1: var TabBarButton, arg2: var Graphics, arg3: Path, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.fillTabButtonShape(@)".}
proc createTabBarExtrasButton*(this: var LookAndFeel_V2): ptr Button {.header: juce_gui_basics, importcpp: "#.createTabBarExtrasButton()".}
proc drawImageButton*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: ptr Image, imageX: cint, imageY: cint, imageW: cint, imageH: cint, overlayColour: Colour, imageOpacity: cfloat, arg9: var ImageButton) {.header: juce_gui_basics, importcpp: "#.drawImageButton(@)".}
proc drawTableHeaderBackground*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.drawTableHeaderBackground(@)".}
proc drawTableHeaderColumn*(this: var LookAndFeel_V2, arg1: var Graphics, arg2: var TableHeaderComponent, columnName: String, columnId: cint, width: cint, height: cint, isMouseOver: bool, isMouseDown: bool, columnFlags: cint) {.header: juce_gui_basics, importcpp: "#.drawTableHeaderColumn(@)".}
proc paintToolbarBackground*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: var Toolbar) {.header: juce_gui_basics, importcpp: "#.paintToolbarBackground(@)".}
proc createToolbarMissingItemsButton*(this: var LookAndFeel_V2, arg1: var Toolbar): ptr Button {.header: juce_gui_basics, importcpp: "#.createToolbarMissingItemsButton(@)".}
proc paintToolbarButtonBackground*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, isMouseOver: bool, isMouseDown: bool, arg6: var ToolbarItemComponent) {.header: juce_gui_basics, importcpp: "#.paintToolbarButtonBackground(@)".}
proc paintToolbarButtonLabel*(this: var LookAndFeel_V2, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, text: String, arg7: var ToolbarItemComponent) {.header: juce_gui_basics, importcpp: "#.paintToolbarButtonLabel(@)".}
proc drawPropertyPanelSectionHeader*(this: var LookAndFeel_V2, arg1: var Graphics, name: String, isOpen: bool, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawPropertyPanelSectionHeader(@)".}
proc drawPropertyComponentBackground*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.drawPropertyComponentBackground(@)".}
proc drawPropertyComponentLabel*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.drawPropertyComponentLabel(@)".}
proc getPropertyComponentContentPosition*(this: var LookAndFeel_V2, arg1: var PropertyComponent): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getPropertyComponentContentPosition(@)".}
proc getPropertyPanelSectionHeaderHeight*(this: var LookAndFeel_V2, sectionTitle: String): cint {.header: juce_gui_basics, importcpp: "#.getPropertyPanelSectionHeaderHeight(@)".}
proc drawCallOutBoxBackground*(this: var LookAndFeel_V2, arg1: var CallOutBox, arg2: var Graphics, path: Path, cachedImage: var Image) {.header: juce_gui_basics, importcpp: "#.drawCallOutBoxBackground(@)".}
proc getCallOutBoxBorderSize*(this: var LookAndFeel_V2, arg1: CallOutBox): cint {.header: juce_gui_basics, importcpp: "#.getCallOutBoxBorderSize(@)".}
proc getCallOutBoxCornerSize*(this: var LookAndFeel_V2, arg1: CallOutBox): cfloat {.header: juce_gui_basics, importcpp: "#.getCallOutBoxCornerSize(@)".}
proc drawLevelMeter*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, level: cfloat) {.header: juce_gui_basics, importcpp: "#.drawLevelMeter(@)".}
proc drawKeymapChangeButton*(this: var LookAndFeel_V2, arg1: var Graphics, width: cint, height: cint, arg4: var Button, keyDescription: String) {.header: juce_gui_basics, importcpp: "#.drawKeymapChangeButton(@)".}
proc getSidePanelTitleFont*(this: var LookAndFeel_V2, arg1: var SidePanel): Font {.header: juce_gui_basics, importcpp: "#.getSidePanelTitleFont(@)".}
proc getSidePanelTitleJustification*(this: var LookAndFeel_V2, arg1: var SidePanel): Justification {.header: juce_gui_basics, importcpp: "#.getSidePanelTitleJustification(@)".}
proc getSidePanelDismissButtonShape*(this: var LookAndFeel_V2, arg1: var SidePanel): Path {.header: juce_gui_basics, importcpp: "#.getSidePanelDismissButtonShape(@)".}
proc `==`*(this: LookAndFeel_V2, other: LookAndFeel_V2): bool {.error: "juce::LookAndFeel_V2 defines no operator==; compare a property instead".}

proc makeLookAndFeel_V1*(): LookAndFeel_V1 {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V1(@)".}
proc drawButtonBackground*(this: var LookAndFeel_V1, arg1: var Graphics, arg2: var Button, backgroundColour: Colour, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawButtonBackground(@)".}
proc drawToggleButton*(this: var LookAndFeel_V1, arg1: var Graphics, arg2: var ToggleButton, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawToggleButton(@)".}
proc drawTickBox*(this: var LookAndFeel_V1, arg1: var Graphics, arg2: var Component, x: cfloat, y: cfloat, w: cfloat, h: cfloat, ticked: bool, isEnabled: bool, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawTickBox(@)".}
proc drawProgressBar*(this: var LookAndFeel_V1, arg1: var Graphics, arg2: var ProgressBar, width: cint, height: cint, progress: float64, textToShow: String) {.header: juce_gui_basics, importcpp: "#.drawProgressBar(@)".}
proc drawScrollbarButton*(this: var LookAndFeel_V1, arg1: var Graphics, arg2: var ScrollBar, width: cint, height: cint, buttonDirection: cint, isScrollbarVertical: bool, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawScrollbarButton(@)".}
proc drawScrollbar*(this: var LookAndFeel_V1, arg1: var Graphics, arg2: var ScrollBar, x: cint, y: cint, width: cint, height: cint, isScrollbarVertical: bool, thumbStartPosition: cint, thumbSize: cint, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawScrollbar(@)".}
proc getScrollbarEffect*(this: var LookAndFeel_V1): ptr ImageEffectFilter {.header: juce_gui_basics, importcpp: "#.getScrollbarEffect()".}
proc drawTextEditorOutline*(this: var LookAndFeel_V1, arg1: var Graphics, width: cint, height: cint, arg4: var TextEditor) {.header: juce_gui_basics, importcpp: "#.drawTextEditorOutline(@)".}
proc drawPopupMenuBackground*(this: var LookAndFeel_V1, arg1: var Graphics, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuBackground(@)".}
proc drawMenuBarBackground*(this: var LookAndFeel_V1, arg1: var Graphics, width: cint, height: cint, isMouseOverBar: bool, arg5: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.drawMenuBarBackground(@)".}
proc drawComboBox*(this: var LookAndFeel_V1, arg1: var Graphics, width: cint, height: cint, isButtonDown: bool, buttonX: cint, buttonY: cint, buttonW: cint, buttonH: cint, arg9: var ComboBox) {.header: juce_gui_basics, importcpp: "#.drawComboBox(@)".}
proc getComboBoxFont*(this: var LookAndFeel_V1, arg1: var ComboBox): Font {.header: juce_gui_basics, importcpp: "#.getComboBoxFont(@)".}
proc drawLinearSlider*(this: var LookAndFeel_V1, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSlider(@)".}
proc getSliderThumbRadius*(this: var LookAndFeel_V1, arg1: var Slider): cint {.header: juce_gui_basics, importcpp: "#.getSliderThumbRadius(@)".}
proc createSliderButton*(this: var LookAndFeel_V1, arg1: var Slider, isIncrement: bool): ptr Button {.header: juce_gui_basics, importcpp: "#.createSliderButton(@)".}
proc getSliderEffect*(this: var LookAndFeel_V1, arg1: var Slider): ptr ImageEffectFilter {.header: juce_gui_basics, importcpp: "#.getSliderEffect(@)".}
proc drawCornerResizer*(this: var LookAndFeel_V1, arg1: var Graphics, w: cint, h: cint, isMouseOver: bool, isMouseDragging: bool) {.header: juce_gui_basics, importcpp: "#.drawCornerResizer(@)".}
proc createDocumentWindowButton*(this: var LookAndFeel_V1, buttonType: cint): ptr Button {.header: juce_gui_basics, importcpp: "#.createDocumentWindowButton(@)".}
proc positionDocumentWindowButtons*(this: var LookAndFeel_V1, arg1: var DocumentWindowImpl, titleBarX: cint, titleBarY: cint, titleBarW: cint, titleBarH: cint, minimiseButton: ptr Button, maximiseButton: ptr Button, closeButton: ptr Button, positionTitleBarButtonsOnLeft: bool) {.header: juce_gui_basics, importcpp: "#.positionDocumentWindowButtons(@)".}
proc `==`*(this: LookAndFeel_V1, other: LookAndFeel_V1): bool {.error: "juce::LookAndFeel_V1 defines no operator==; compare a property instead".}

proc makeLookAndFeel_V3*(): LookAndFeel_V3 {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V3(@)".}
proc drawButtonBackground*(this: var LookAndFeel_V3, arg1: var Graphics, arg2: var Button, backgroundColour: Colour, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawButtonBackground(@)".}
proc drawTableHeaderBackground*(this: var LookAndFeel_V3, arg1: var Graphics, arg2: var TableHeaderComponent) {.header: juce_gui_basics, importcpp: "#.drawTableHeaderBackground(@)".}
proc drawTreeviewPlusMinusBox*(this: var LookAndFeel_V3, arg1: var Graphics, area: Rectangle[cfloat], backgroundColour: Colour, isOpen: bool, isMouseOver: bool) {.header: juce_gui_basics, importcpp: "#.drawTreeviewPlusMinusBox(@)".}
proc areLinesDrawnForTreeView*(this: var LookAndFeel_V3, arg1: var TreeView): bool {.header: juce_gui_basics, importcpp: "#.areLinesDrawnForTreeView(@)".}
proc getTreeViewIndentSize*(this: var LookAndFeel_V3, arg1: var TreeView): cint {.header: juce_gui_basics, importcpp: "#.getTreeViewIndentSize(@)".}
proc createDocumentWindowButton*(this: var LookAndFeel_V3, buttonType: cint): ptr Button {.header: juce_gui_basics, importcpp: "#.createDocumentWindowButton(@)".}
proc drawComboBox*(this: var LookAndFeel_V3, arg1: var Graphics, width: cint, height: cint, isButtonDown: bool, buttonX: cint, buttonY: cint, buttonW: cint, buttonH: cint, box: var ComboBox) {.header: juce_gui_basics, importcpp: "#.drawComboBox(@)".}
proc drawKeymapChangeButton*(this: var LookAndFeel_V3, arg1: var Graphics, width: cint, height: cint, button: var Button, keyDescription: String) {.header: juce_gui_basics, importcpp: "#.drawKeymapChangeButton(@)".}
proc drawPopupMenuBackground*(this: var LookAndFeel_V3, arg1: var Graphics, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuBackground(@)".}
proc drawMenuBarBackground*(this: var LookAndFeel_V3, arg1: var Graphics, width: cint, height: cint, arg4: bool, arg5: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.drawMenuBarBackground(@)".}
proc getTabButtonOverlap*(this: var LookAndFeel_V3, tabDepth: cint): cint {.header: juce_gui_basics, importcpp: "#.getTabButtonOverlap(@)".}
proc getTabButtonSpaceAroundImage*(this: var LookAndFeel_V3): cint {.header: juce_gui_basics, importcpp: "#.getTabButtonSpaceAroundImage()".}
proc drawTabButton*(this: var LookAndFeel_V3, arg1: var TabBarButton, arg2: var Graphics, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawTabButton(@)".}
proc drawTabAreaBehindFrontButton*(this: var LookAndFeel_V3, bar: var TabbedButtonBar, g: var Graphics, w: cint, h: cint) {.header: juce_gui_basics, importcpp: "#.drawTabAreaBehindFrontButton(@)".}
proc drawTextEditorOutline*(this: var LookAndFeel_V3, arg1: var Graphics, width: cint, height: cint, arg4: var TextEditor) {.header: juce_gui_basics, importcpp: "#.drawTextEditorOutline(@)".}
proc drawStretchableLayoutResizerBar*(this: var LookAndFeel_V3, arg1: var Graphics, w: cint, h: cint, isVerticalBar: bool, isMouseOver: bool, isMouseDragging: bool) {.header: juce_gui_basics, importcpp: "#.drawStretchableLayoutResizerBar(@)".}
proc areScrollbarButtonsVisible*(this: var LookAndFeel_V3): bool {.header: juce_gui_basics, importcpp: "#.areScrollbarButtonsVisible()".}
proc drawScrollbar*(this: var LookAndFeel_V3, arg1: var Graphics, arg2: var ScrollBar, x: cint, y: cint, width: cint, height: cint, isScrollbarVertical: bool, thumbStartPosition: cint, thumbSize: cint, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawScrollbar(@)".}
proc drawLinearSlider*(this: var LookAndFeel_V3, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSlider(@)".}
proc drawLinearSliderBackground*(this: var LookAndFeel_V3, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSliderBackground(@)".}
proc drawConcertinaPanelHeader*(this: var LookAndFeel_V3, arg1: var Graphics, area: Rectangle[cint], isMouseOver: bool, isMouseDown: bool, arg5: var ConcertinaPanel, arg6: var Component) {.header: juce_gui_basics, importcpp: "#.drawConcertinaPanelHeader(@)".}
proc getTickShape*(this: var LookAndFeel_V3, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getTickShape(@)".}
proc getCrossShape*(this: var LookAndFeel_V3, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getCrossShape(@)".}
proc `==`*(this: LookAndFeel_V3, other: LookAndFeel_V3): bool {.error: "juce::LookAndFeel_V3 defines no operator==; compare a property instead".}

proc makeLookAndFeel_V4*(): LookAndFeel_V4 {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V4(@)".}
proc makeLookAndFeel_V4*(arg1: LookAndFeel_V4ColourScheme): LookAndFeel_V4 {.header: juce_gui_basics, importcpp: "juce::LookAndFeel_V4(@)".}
proc setColourScheme*(this: var LookAndFeel_V4, arg1: LookAndFeel_V4ColourScheme) {.header: juce_gui_basics, importcpp: "#.setColourScheme(@)".}
proc getCurrentColourScheme*(this: var LookAndFeel_V4): var LookAndFeel_V4ColourScheme {.header: juce_gui_basics, importcpp: "#.getCurrentColourScheme()".}
proc createDocumentWindowButton*(this: var LookAndFeel_V4, arg1: cint): ptr Button {.header: juce_gui_basics, importcpp: "#.createDocumentWindowButton(@)".}
proc positionDocumentWindowButtons*(this: var LookAndFeel_V4, arg1: var DocumentWindowImpl, arg2: cint, arg3: cint, arg4: cint, arg5: cint, arg6: ptr Button, arg7: ptr Button, arg8: ptr Button, arg9: bool) {.header: juce_gui_basics, importcpp: "#.positionDocumentWindowButtons(@)".}
proc drawDocumentWindowTitleBar*(this: var LookAndFeel_V4, arg1: var DocumentWindowImpl, arg2: var Graphics, arg3: cint, arg4: cint, arg5: cint, arg6: cint, arg7: ptr Image, arg8: bool) {.header: juce_gui_basics, importcpp: "#.drawDocumentWindowTitleBar(@)".}
proc getTextButtonFont*(this: var LookAndFeel_V4, arg1: var TextButton, buttonHeight: cint): Font {.header: juce_gui_basics, importcpp: "#.getTextButtonFont(@)".}
proc drawButtonBackground*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: var Button, backgroundColour: Colour, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawButtonBackground(@)".}
proc drawToggleButton*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: var ToggleButton, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawToggleButton(@)".}
proc drawTickBox*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: var Component, x: cfloat, y: cfloat, w: cfloat, h: cfloat, ticked: bool, isEnabled: bool, shouldDrawButtonAsHighlighted: bool, shouldDrawButtonAsDown: bool) {.header: juce_gui_basics, importcpp: "#.drawTickBox(@)".}
proc changeToggleButtonWidthToFitText*(this: var LookAndFeel_V4, arg1: var ToggleButton) {.header: juce_gui_basics, importcpp: "#.changeToggleButtonWidthToFitText(@)".}
proc createAlertWindow*(this: var LookAndFeel_V4, title: String, message: String, button1: String, button2: String, button3: String, iconType: MessageBoxIconType, numButtons: cint, associatedComponent: ptr Component): ptr AlertWindow {.header: juce_gui_basics, importcpp: "#.createAlertWindow(@)".}
proc drawAlertBox*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: var AlertWindow, textArea: Rectangle[cint], arg4: var TextLayout) {.header: juce_gui_basics, importcpp: "#.drawAlertBox(@)".}
proc getAlertWindowButtonHeight*(this: var LookAndFeel_V4): cint {.header: juce_gui_basics, importcpp: "#.getAlertWindowButtonHeight()".}
proc getAlertWindowTitleFont*(this: var LookAndFeel_V4): Font {.header: juce_gui_basics, importcpp: "#.getAlertWindowTitleFont()".}
proc getAlertWindowMessageFont*(this: var LookAndFeel_V4): Font {.header: juce_gui_basics, importcpp: "#.getAlertWindowMessageFont()".}
proc getAlertWindowFont*(this: var LookAndFeel_V4): Font {.header: juce_gui_basics, importcpp: "#.getAlertWindowFont()".}
proc drawProgressBar*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: var ProgressBar, width: cint, height: cint, progress: float64, arg6: String) {.header: juce_gui_basics, importcpp: "#.drawProgressBar(@)".}
proc isProgressBarOpaque*(this: var LookAndFeel_V4, arg1: var ProgressBar): bool {.header: juce_gui_basics, importcpp: "#.isProgressBarOpaque(@)".}
proc getDefaultProgressBarStyle*(this: var LookAndFeel_V4, arg1: ProgressBar): ProgressBarStyle {.header: juce_gui_basics, importcpp: "#.getDefaultProgressBarStyle(@)".}
proc getDefaultScrollbarWidth*(this: var LookAndFeel_V4): cint {.header: juce_gui_basics, importcpp: "#.getDefaultScrollbarWidth()".}
proc drawScrollbar*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: var ScrollBar, x: cint, y: cint, width: cint, height: cint, isScrollbarVertical: bool, thumbStartPosition: cint, thumbSize: cint, isMouseOver: bool, isMouseDown: bool) {.header: juce_gui_basics, importcpp: "#.drawScrollbar(@)".}
proc getTickShape*(this: var LookAndFeel_V4, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getTickShape(@)".}
proc getCrossShape*(this: var LookAndFeel_V4, height: cfloat): Path {.header: juce_gui_basics, importcpp: "#.getCrossShape(@)".}
proc fillTextEditorBackground*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, arg4: var TextEditor) {.header: juce_gui_basics, importcpp: "#.fillTextEditorBackground(@)".}
proc drawTextEditorOutline*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, arg4: var TextEditor) {.header: juce_gui_basics, importcpp: "#.drawTextEditorOutline(@)".}
proc createFileBrowserGoUpButton*(this: var LookAndFeel_V4): ptr Button {.header: juce_gui_basics, importcpp: "#.createFileBrowserGoUpButton()".}
proc layoutFileBrowserComponent*(this: var LookAndFeel_V4, arg1: var FileBrowserComponent, arg2: ptr DirectoryContentsDisplayComponent, arg3: ptr FilePreviewComponent, currentPathBox: ptr ComboBox, filenameBox: ptr TextEditor, goUpButton: ptr Button) {.header: juce_gui_basics, importcpp: "#.layoutFileBrowserComponent(@)".}
proc drawFileBrowserRow*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, file: File, filename: String, icon: ptr Image, fileSizeDescription: String, fileTimeDescription: String, isDirectory: bool, isItemSelected: bool, itemIndex: cint, arg12: var DirectoryContentsDisplayComponent) {.header: juce_gui_basics, importcpp: "#.drawFileBrowserRow(@)".}
proc drawPopupMenuItem*(this: var LookAndFeel_V4, arg1: var Graphics, area: Rectangle[cint], isSeparator: bool, isActive: bool, isHighlighted: bool, isTicked: bool, hasSubMenu: bool, text: String, shortcutKeyText: String, icon: ptr Drawable, textColour: ptr Colour) {.header: juce_gui_basics, importcpp: "#.drawPopupMenuItem(@)".}
proc getIdealPopupMenuItemSize*(this: var LookAndFeel_V4, text: String, isSeparator: bool, standardMenuItemHeight: cint, idealWidth: var cint, idealHeight: var cint) {.header: juce_gui_basics, importcpp: "#.getIdealPopupMenuItemSize(@)".}
proc drawMenuBarBackground*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, isMouseOverBar: bool, arg5: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.drawMenuBarBackground(@)".}
proc drawMenuBarItem*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, itemIndex: cint, itemText: String, isMouseOverItem: bool, isMenuOpen: bool, isMouseOverBar: bool, arg9: var MenuBarComponent) {.header: juce_gui_basics, importcpp: "#.drawMenuBarItem(@)".}
proc drawComboBox*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, isButtonDown: bool, buttonX: cint, buttonY: cint, buttonW: cint, buttonH: cint, arg9: var ComboBox) {.header: juce_gui_basics, importcpp: "#.drawComboBox(@)".}
proc getComboBoxFont*(this: var LookAndFeel_V4, arg1: var ComboBox): Font {.header: juce_gui_basics, importcpp: "#.getComboBoxFont(@)".}
proc positionComboBoxText*(this: var LookAndFeel_V4, arg1: var ComboBox, arg2: var Label) {.header: juce_gui_basics, importcpp: "#.positionComboBoxText(@)".}
proc getSliderThumbRadius*(this: var LookAndFeel_V4, arg1: var Slider): cint {.header: juce_gui_basics, importcpp: "#.getSliderThumbRadius(@)".}
proc drawLinearSlider*(this: var LookAndFeel_V4, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPos: cfloat, minSliderPos: cfloat, maxSliderPos: cfloat, arg9: SliderSliderStyle, arg10: var Slider) {.header: juce_gui_basics, importcpp: "#.drawLinearSlider(@)".}
proc drawRotarySlider*(this: var LookAndFeel_V4, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, sliderPosProportional: cfloat, rotaryStartAngle: cfloat, rotaryEndAngle: cfloat, arg9: var Slider) {.header: juce_gui_basics, importcpp: "#.drawRotarySlider(@)".}
proc drawPointer*(this: var LookAndFeel_V4, arg1: var Graphics, x: cfloat, y: cfloat, diameter: cfloat, arg5: Colour, direction: cint) {.header: juce_gui_basics, importcpp: "#.drawPointer(@)".}
proc createSliderTextBox*(this: var LookAndFeel_V4, arg1: var Slider): ptr Label {.header: juce_gui_basics, importcpp: "#.createSliderTextBox(@)".}
proc drawTooltip*(this: var LookAndFeel_V4, arg1: var Graphics, text: String, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawTooltip(@)".}
proc drawConcertinaPanelHeader*(this: var LookAndFeel_V4, arg1: var Graphics, area: Rectangle[cint], isMouseOver: bool, isMouseDown: bool, arg5: var ConcertinaPanel, panel: var Component) {.header: juce_gui_basics, importcpp: "#.drawConcertinaPanelHeader(@)".}
proc drawLevelMeter*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: cint, arg3: cint, arg4: cfloat) {.header: juce_gui_basics, importcpp: "#.drawLevelMeter(@)".}
proc paintToolbarBackground*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, arg4: var Toolbar) {.header: juce_gui_basics, importcpp: "#.paintToolbarBackground(@)".}
proc paintToolbarButtonLabel*(this: var LookAndFeel_V4, arg1: var Graphics, x: cint, y: cint, width: cint, height: cint, text: String, arg7: var ToolbarItemComponent) {.header: juce_gui_basics, importcpp: "#.paintToolbarButtonLabel(@)".}
proc drawPropertyPanelSectionHeader*(this: var LookAndFeel_V4, arg1: var Graphics, name: String, isOpen: bool, width: cint, height: cint) {.header: juce_gui_basics, importcpp: "#.drawPropertyPanelSectionHeader(@)".}
proc drawPropertyComponentBackground*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, arg4: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.drawPropertyComponentBackground(@)".}
proc drawPropertyComponentLabel*(this: var LookAndFeel_V4, arg1: var Graphics, width: cint, height: cint, arg4: var PropertyComponent) {.header: juce_gui_basics, importcpp: "#.drawPropertyComponentLabel(@)".}
proc getPropertyComponentContentPosition*(this: var LookAndFeel_V4, arg1: var PropertyComponent): Rectangle[cint] {.header: juce_gui_basics, importcpp: "#.getPropertyComponentContentPosition(@)".}
proc drawCallOutBoxBackground*(this: var LookAndFeel_V4, arg1: var CallOutBox, arg2: var Graphics, arg3: Path, arg4: var Image) {.header: juce_gui_basics, importcpp: "#.drawCallOutBoxBackground(@)".}
proc drawStretchableLayoutResizerBar*(this: var LookAndFeel_V4, arg1: var Graphics, arg2: cint, arg3: cint, arg4: bool, arg5: bool, arg6: bool) {.header: juce_gui_basics, importcpp: "#.drawStretchableLayoutResizerBar(@)".}
proc `==`*(this: LookAndFeel_V4, other: LookAndFeel_V4): bool {.error: "juce::LookAndFeel_V4 defines no operator==; compare a property instead".}

proc makeFlexItem*(): FlexItem {.header: juce_gui_basics, importcpp: "juce::FlexItem(@)".}
proc makeFlexItem*(width: cfloat, height: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "juce::FlexItem(@)".}
proc makeFlexItem*(width: cfloat, height: cfloat, targetComponent: var Component): FlexItem {.header: juce_gui_basics, importcpp: "juce::FlexItem(@)".}
proc makeFlexItem*(width: cfloat, height: cfloat, flexBoxToControl: var FlexBox): FlexItem {.header: juce_gui_basics, importcpp: "juce::FlexItem(@)".}
proc makeFlexItem*(componentToControl: var Component): FlexItem {.header: juce_gui_basics, importcpp: "juce::FlexItem(@)".}
proc makeFlexItem*(flexBoxToControl: var FlexBox): FlexItem {.header: juce_gui_basics, importcpp: "juce::FlexItem(@)".}
proc withFlex*(this: FlexItem, newFlexGrow: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withFlex(@)".}
proc withFlex*(this: FlexItem, newFlexGrow: cfloat, newFlexShrink: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withFlex(@)".}
proc withFlex*(this: FlexItem, newFlexGrow: cfloat, newFlexShrink: cfloat, newFlexBasis: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withFlex(@)".}
proc withWidth*(this: FlexItem, newWidth: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withWidth(@)".}
proc withMinWidth*(this: FlexItem, newMinWidth: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withMinWidth(@)".}
proc withMaxWidth*(this: FlexItem, newMaxWidth: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withMaxWidth(@)".}
proc withHeight*(this: FlexItem, newHeight: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withHeight(@)".}
proc withMinHeight*(this: FlexItem, newMinHeight: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withMinHeight(@)".}
proc withMaxHeight*(this: FlexItem, newMaxHeight: cfloat): FlexItem {.header: juce_gui_basics, importcpp: "#.withMaxHeight(@)".}
proc withMargin*(this: FlexItem, arg1: FlexItemMargin): FlexItem {.header: juce_gui_basics, importcpp: "#.withMargin(@)".}
proc withOrder*(this: FlexItem, newOrder: cint): FlexItem {.header: juce_gui_basics, importcpp: "#.withOrder(@)".}
proc withAlignSelf*(this: FlexItem, newAlignSelf: FlexItemAlignSelf): FlexItem {.header: juce_gui_basics, importcpp: "#.withAlignSelf(@)".}
proc `==`*(this: FlexItem, other: FlexItem): bool {.error: "juce::FlexItem defines no operator==; compare a property instead".}

proc makeFlexBox*(): FlexBox {.header: juce_gui_basics, importcpp: "juce::FlexBox(@)".}
proc makeFlexBox*(arg1: FlexBoxDirection, arg2: FlexBoxWrap, arg3: FlexBoxAlignContent, arg4: FlexBoxAlignItems, arg5: FlexBoxJustifyContent): FlexBox {.header: juce_gui_basics, importcpp: "juce::FlexBox(@)".}
proc makeFlexBox*(arg1: FlexBoxJustifyContent): FlexBox {.header: juce_gui_basics, importcpp: "juce::FlexBox(@)".}
proc performLayout*(this: var FlexBox, targetArea: Rectangle[cfloat]) {.header: juce_gui_basics, importcpp: "#.performLayout(@)".}
proc performLayout*(this: var FlexBox, targetArea: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.performLayout(@)".}
proc `==`*(this: FlexBox, other: FlexBox): bool {.error: "juce::FlexBox defines no operator==; compare a property instead".}

proc makeGridItem*(): GridItem {.header: juce_gui_basics, importcpp: "juce::GridItem(@)".}
proc makeGridItem*(componentToUse: var Component): GridItem {.header: juce_gui_basics, importcpp: "juce::GridItem(@)".}
proc makeGridItem*(componentToUse: ptr Component): GridItem {.header: juce_gui_basics, importcpp: "juce::GridItem(@)".}
proc setArea*(this: var GridItem, rowStart: GridItemProperty, columnStart: GridItemProperty, rowEnd: GridItemProperty, columnEnd: GridItemProperty) {.header: juce_gui_basics, importcpp: "#.setArea(@)".}
proc setArea*(this: var GridItem, rowStart: GridItemProperty, columnStart: GridItemProperty) {.header: juce_gui_basics, importcpp: "#.setArea(@)".}
proc setArea*(this: var GridItem, areaName: String) {.header: juce_gui_basics, importcpp: "#.setArea(@)".}
proc withArea*(this: GridItem, rowStart: GridItemProperty, columnStart: GridItemProperty, rowEnd: GridItemProperty, columnEnd: GridItemProperty): GridItem {.header: juce_gui_basics, importcpp: "#.withArea(@)".}
proc withArea*(this: GridItem, rowStart: GridItemProperty, columnStart: GridItemProperty): GridItem {.header: juce_gui_basics, importcpp: "#.withArea(@)".}
proc withArea*(this: GridItem, areaName: String): GridItem {.header: juce_gui_basics, importcpp: "#.withArea(@)".}
proc withRow*(this: GridItem, row: GridItemStartAndEndProperty): GridItem {.header: juce_gui_basics, importcpp: "#.withRow(@)".}
proc withColumn*(this: GridItem, column: GridItemStartAndEndProperty): GridItem {.header: juce_gui_basics, importcpp: "#.withColumn(@)".}
proc withAlignSelf*(this: GridItem, newAlignSelf: GridItemAlignSelf): GridItem {.header: juce_gui_basics, importcpp: "#.withAlignSelf(@)".}
proc withJustifySelf*(this: GridItem, newJustifySelf: GridItemJustifySelf): GridItem {.header: juce_gui_basics, importcpp: "#.withJustifySelf(@)".}
proc withWidth*(this: GridItem, newWidth: cfloat): GridItem {.header: juce_gui_basics, importcpp: "#.withWidth(@)".}
proc withHeight*(this: GridItem, newHeight: cfloat): GridItem {.header: juce_gui_basics, importcpp: "#.withHeight(@)".}
proc withSize*(this: GridItem, newWidth: cfloat, newHeight: cfloat): GridItem {.header: juce_gui_basics, importcpp: "#.withSize(@)".}
proc withMargin*(this: GridItem, newMargin: GridItemMargin): GridItem {.header: juce_gui_basics, importcpp: "#.withMargin(@)".}
proc withOrder*(this: GridItem, newOrder: cint): GridItem {.header: juce_gui_basics, importcpp: "#.withOrder(@)".}
proc `==`*(this: GridItem, other: GridItem): bool {.error: "juce::GridItem defines no operator==; compare a property instead".}

proc makeGrid*(): Grid {.header: juce_gui_basics, importcpp: "juce::Grid(@)".}
proc setGap*(this: var Grid, sizeInPixels: GridPx) {.header: juce_gui_basics, importcpp: "#.setGap(@)".}
proc performLayout*(this: var Grid, arg1: Rectangle[cint]) {.header: juce_gui_basics, importcpp: "#.performLayout(@)".}
proc getNumberOfColumns*(this: Grid): cint {.header: juce_gui_basics, importcpp: "#.getNumberOfColumns()".}
proc getNumberOfRows*(this: Grid): cint {.header: juce_gui_basics, importcpp: "#.getNumberOfRows()".}
proc `==`*(this: Grid, other: Grid): bool {.error: "juce::Grid defines no operator==; compare a property instead".}

proc makeScopedDPIAwarenessDisabler*(): ScopedDPIAwarenessDisabler {.header: juce_gui_basics, importcpp: "juce::ScopedDPIAwarenessDisabler(@)".}
proc `==`*(this: ScopedDPIAwarenessDisabler, other: ScopedDPIAwarenessDisabler): bool {.error: "juce::ScopedDPIAwarenessDisabler defines no operator==; compare a property instead".}

proc `==`*(this: AccessibilityNativeHandle, other: AccessibilityNativeHandle): bool {.error: "juce::AccessibilityNativeHandle defines no operator==; compare a property instead".}



include juce_gui_basics_lifting

proc `$`*(this: RelativeCoordinate): string = $this.toString()
proc `$`*(this: RelativePoint): string = $this.toString()
proc `$`*(this: RelativeRectangle): string = $this.toString()
proc `$`*(this: TableHeaderComponent): string = $this.toString()
proc `$`*(this: Toolbar): string = $this.toString()

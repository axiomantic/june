# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# A complete application rather than a single widget: a window whose content is
# a custom component holding a rotary slider and a label, themed by a custom
# LookAndFeel and animated by a timer. It exercises the pieces an application
# actually combines - subclassing, handlers, theming and the message loop -
# which is what the per-widget examples do not show.
#
# CI compiles this file, so an API change that breaks it breaks the build.

import std/math

import june

{.emit: """/*INCLUDESECTION*/
#include <june.h>
""".}


defineCppClass RotaryPanelApplication of JUCEApplication:
    window: ptr DocumentWindow
    panel: ptr CustomComponent
    slider: ptr CustomSlider
    readout: ptr CustomLabel
    lookAndFeel: ptr CustomLookAndFeel
    pulse: ptr CustomTimer


proc constructRotaryPanelApplication(): RotaryPanelApplication =
    result = RotaryPanelApplication()


# The theme. Only the rotary is drawn by hand; everything else falls through to
# the LookAndFeel_V4 drawing, which is the point of subclassing rather than
# reimplementing a whole LookAndFeel.
proc makeTheme(): ptr CustomLookAndFeel =
    result = newCustomLookAndFeel()

    result[].setDrawRotarySliderHandler(proc(g: ptr Graphics, x, y, width, height: cint,
                                             sliderPos, startAngle, endAngle: cfloat,
                                             slider: ptr Slider) =
        let centreX = x.float32 + width.float32 * 0.5'f32
        let centreY = y.float32 + height.float32 * 0.5'f32
        let radius = min(width, height).float32 * 0.4'f32
        let angle = startAngle + sliderPos * (endAngle - startAngle)

        g[].setColour(makeColour(38'u8, 46'u8, 52'u8, 255'u8))
        g[].fillEllipse(centreX - radius, centreY - radius, radius * 2.0'f32, radius * 2.0'f32)

        g[].setColour(makeColour(120'u8, 200'u8, 160'u8, 255'u8))
        g[].drawLine(centreX, centreY,
                     centreX + radius * sin(angle), centreY - radius * cos(angle), 2.0'f32)
    )


proc createApplication(): ptr JUCEApplication =
    var application: ptr RotaryPanelApplication = cnew constructRotaryPanelApplication()

    application[].onGetApplicationName = bindClosure(proc(): String = "Rotary Panel")
    application[].onGetApplicationVersion = bindClosure(proc(): String = "0.1")

    application[].onInitialise = bindClosure(proc(commandLine: String) =
        application[].lookAndFeel = makeTheme()

        application[].slider = newCustomSlider()
        application[].slider[].setSliderStyle(SliderSliderStyle_Rotary)
        application[].slider[].setRange(0.0, 100.0, 1.0)
        application[].slider[].setLookAndFeel(application[].lookAndFeel)

        application[].readout = newCustomLabel()
        application[].readout[].setJustificationType(toJustification(JustificationFlags_centred))

        application[].panel = newCustomComponent()
        application[].panel[].addAndMakeVisible(application[].slider)
        application[].panel[].addAndMakeVisible(application[].readout)

        application[].panel[].setPaintHandler(proc(g: ptr Graphics) =
            g[].setColour(makeColour(24'u8, 28'u8, 32'u8, 255'u8))
            g[].fillRect(application[].panel[].getLocalBounds())
        )

        # Laying children out in resized is what makes a JUCE window resizable.
        application[].panel[].onResized = bindClosure(proc() =
            let bounds = application[].panel[].getLocalBounds()
            application[].slider[].setBounds(0.cint, 0.cint,
                                             bounds.getWidth(), bounds.getHeight() - 40)
            application[].readout[].setBounds(0.cint, bounds.getHeight() - 40,
                                              bounds.getWidth(), 40.cint)
        )

        # The slider drives the label directly, without a listener, because
        # CustomSlider overrides valueChanged.
        application[].slider[].onValueChanged = bindClosure(proc() =
            application[].readout[].setText(makeString($application[].slider[].getValue()),
                                            NotificationType_dontSendNotification)
        )

        # A timer sweeps the slider so the window is not static.
        application[].pulse = newCustomTimer()
        application[].pulse[].onTimerCallback = bindClosure(proc() =
            let next = application[].slider[].getValue() + 1.0
            application[].slider[].setValue(if next > 100.0: 0.0 else: next,
                                            NotificationType_sendNotificationSync)
        )
        application[].pulse[].startTimerHz(30.cint)

        application[].window = newDocumentWindow(
            application[].getApplicationName(),
            makeColour(24'u8, 28'u8, 32'u8, 255'u8), DocumentWindow_allButtons, true)
        application[].window[].onCloseButtonPressed = bindClosure(
            proc() = JUCEApplication.getInstance().systemRequestedQuit())
        application[].window[].setContentNonOwned(application[].panel, false)
        application[].window[].setResizable(true, true)
        application[].window[].centreWithSize(360, 340)
        application[].window[].setVisible(true)
    )

    application[].onShutdown = bindClosure(proc() =
        application[].pulse[].stopTimer()

        # The window is torn down before the widgets it shows, and every widget
        # loses the LookAndFeel before that is deleted: a Component must not
        # outlive the LookAndFeel it points at.
        cdelete application[].window
        application[].slider[].setLookAndFeel(nil)
        cdelete application[].pulse
        cdelete application[].readout
        cdelete application[].slider
        cdelete application[].panel
        cdelete application[].lookAndFeel
    )

    application[].onSystemRequestedQuit = bindClosure(proc() = application[].quit())

    result = application


when isMainModule:
    START_JUCE_APPLICATION(createApplication)

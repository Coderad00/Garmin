//
// Copyright 2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

//! This class demonstrate how to use Dc.drawAngledText() API
class TrueTypeFontsAngledTextView extends TrueTypeFontsView {

    private static const ANGLED_TEXT_SCENARIOS = [

        // no rotation, all legal justifications
        {
            :angle => 0,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
        {
            :angle => 0,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 0,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT,
        },
        {
            :angle => 0,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 0,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 0,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        // small rotation, all legal justifications
        {
            :angle => 15,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
        {
            :angle => 15,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 15,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT,
        },
        {
            :angle => 15,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 15,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 15,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        {
            :angle => 270,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
        {
            :angle => 270,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 270,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT,
        },
        {
            :angle => 270,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 270,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 270,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },


        // just two at 90
        {
            :angle => 90,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 90,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        // just two at 180
        {
            :angle => 180,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
        {
            :angle => 180,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        // legal angles outside of 0-360
        {
            :angle => -45,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 405,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },

    ];

    //! Constructor
    //! @param deviceSettingChangedManager the DeviceSettingChangedManager instance
    public function initialize(deviceSettingChangedManager as DeviceSettingChangedManager) {
        TrueTypeFontsView.initialize(ANGLED_TEXT_SCENARIOS.size(), deviceSettingChangedManager);
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var options = ANGLED_TEXT_SCENARIOS[_viewId];
        var degrees = options[:angle] as Number;
        var radians = Math.toRadians(degrees);
        var justification = options[:justification] as Number;
        var radius = dc.getWidth() / 4;

        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;

        // Draw the angled text given the Scenarios array as parameters.
        var font = getFirstAvailableTrueTypeFont(50 * getFontScale());
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawAngledText(cx, cy,
                    font,
                    "Angled Text",
                    justification,
                    degrees);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);


        var tx = radius * Math.cos(radians);
        var ty = radius * -Math.sin(radians);
        dc.drawLine(cx, cy, cx + tx, cy + ty);
        dc.drawCircle(cx, cy, 3);

        var angleText = Lang.format("Angle=$1$", [
            degrees
        ]);

        var justificationText = Lang.format("Justification=$1$", [
            getJustificationDescription(justification)
        ]);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, dc.getHeight() / 8, Graphics.FONT_XTINY, angleText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, dc.getHeight() / 5, Graphics.FONT_XTINY, justificationText, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

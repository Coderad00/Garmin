//
// Copyright 2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

//! This class demonstrates how to use Dc.drawRadialText() API
class TrueTypeFontsRadialTextView extends TrueTypeFontsView {

    const RADIAL_TEXT_SCENARIO = [
        {
            :angle => 0,
            :radius => 60,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
        {
            :angle => 0,
            :radius => 60,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 0,
            :radius => 60,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT,
        },
        {
            :angle => 0,
            :radius => 60,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 0,
            :radius => 60,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 0,
            :radius => 60,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        {
            :angle => 90,
            :radius => 75,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        {
            :angle => 180,
            :radius => 75,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 270,
            :radius => 100,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
        {
            :angle => 270,
            :radius => 100,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 270,
            :radius => 100,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT,
        },
        {
            :angle => 270,
            :radius => 100,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 270,
            :radius => 100,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
        },
        {
            :angle => 270,
            :radius => 100,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
        },

        {
            :angle => -45,
            :radius => 25,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
        },
        {
            :angle => 405,
            :radius => 75,
            :orientation => Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
        },
    ];

    //! Constructor
    //! @param deviceSettingChangedManager the DeviceSettingChangedManager instance
    public function initialize(deviceSettingChangedManager as DeviceSettingChangedManager) {
        TrueTypeFontsView.initialize(RADIAL_TEXT_SCENARIO.size(), deviceSettingChangedManager);
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var options = RADIAL_TEXT_SCENARIO[_viewId];
        var degrees = options[:angle] as Number;
        var radius = options[:radius] as Number;
        var justification = options[:justification] as Number;
        var orientation = options[:orientation] as RadialTextDirection;
        var radians = Math.toRadians(degrees);

        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;

        var text = Lang.format("Radius=$1$ Angle=$2$", [
            radius,
            degrees
        ]);

        var justificationText = Lang.format("Justification=$1$", [
            getJustificationDescription(justification)
        ]);

        var orientationText = Lang.format("Orientation=$1$", [
            getOrientationDescription(orientation)
        ]);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.drawText(cx, dc.getHeight() / 10, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, dc.getHeight() / 5, Graphics.FONT_XTINY, justificationText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, dc.getHeight() * 3 / 10, Graphics.FONT_XTINY, orientationText, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw the radial text given the RadialTextScenarios array as parameters.
        var font = getFirstAvailableTrueTypeFont(30 * getFontScale());
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRadialText(cx, cy, font, "Radial Text",
            justification,
            degrees,
            radius,
            orientation);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

        var tx = cx + radius * Math.cos(radians);
        var ty = cy + radius * -Math.sin(radians);
        dc.drawLine(cx, cy, tx, ty);
        dc.drawCircle(cx, cy, 3);
        dc.drawCircle(tx, ty, 3);
        dc.drawCircle(cx, cy, radius);
    }
}
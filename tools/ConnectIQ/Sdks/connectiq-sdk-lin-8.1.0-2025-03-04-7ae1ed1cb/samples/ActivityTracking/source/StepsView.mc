//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Timer;
import Toybox.WatchUi;

//! Show the steps summary
class StepsView extends WatchUi.View {

    private var _timer as Timer.Timer;

    //! Constructor
    public function initialize() {
        View.initialize();

        // Set up a 1Hz update timer because we aren't registering
        // for any data callbacks that can kick our display update.
        _timer = new Timer.Timer();
    }

    //! Handle view coming on screen
    public function onShow() as Void {
        _timer.start(method(:onTimer), 1000, true);
    }

    //! Handle view being hidden
    public function onHide() as Void{
        _timer.stop();
    }

    //! Handle the update event
    //! @param dc Draw context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var activityInfo = ActivityMonitor.getInfo();

        var stepGoal = activityInfo.stepGoal;
        var steps = activityInfo.steps;

        Utils.drawGoalProgress(dc, steps, stepGoal, "steps");

        // Draw distance...
        var distance = activityInfo.distance;
        Utils.drawDistance(dc, distance);

        // And calories
        var calories = activityInfo.calories;
        if (calories != null) {
            var string = calories.toString() + "kcal";
            if (IS_SCREEN_RECTANGLE) {
                dc.drawText(dc.getWidth() - 5, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_RIGHT);
            } else {
                dc.drawText(dc.getWidth() / 2, dc.getHeight() - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            }
        }

        // Draw Move text
        var moveBarLevel = activityInfo.moveBarLevel;
        if ((moveBarLevel != null) && (moveBarLevel != ActivityMonitor.MOVE_BAR_LEVEL_MIN)) {
            var string = "MOVE";
            for (var i = 0; i < moveBarLevel; i++) {
                string += "!";
            }

            dc.drawText(dc.getWidth() / 2, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_MEDIUM), Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Timer callback to update the screen
    public function onTimer() as Void {
        // Kick the display update
        WatchUi.requestUpdate();
    }
}

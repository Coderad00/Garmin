//
// Copyright 2016-2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Timer;
import Toybox.WatchUi;

//! Show the wheelchair push summary
class WheelchairPushView extends WatchUi.View {

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

        if ((activityInfo has :pushes) && (activityInfo has :pushGoal) && (activityInfo has :pushDistance)) {
            // Draw progress bar
            var pushGoal = activityInfo.pushGoal;
            var pushes = activityInfo.pushes;
            Utils.drawGoalProgress(dc, pushes, pushGoal, "pushes");

            // Draw distance
            var distance = activityInfo.pushDistance;
            Utils.drawDistance(dc, distance);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_SMALL, "Wheelchair pushes\nnot supported", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    //! Timer callback to update the screen
    public function onTimer() as Void {
        // Kick the display update
        WatchUi.requestUpdate();
    }
}
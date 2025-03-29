//
// Copyright 2016-2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

const IS_SCREEN_RECTANGLE = (System.SCREEN_SHAPE_RECTANGLE == System.getDeviceSettings().screenShape);

module Utils {

    //! Draw a progress bar and text
    //! @param dc Draw context
    //! @param current Current amount of progress towards goal
    //! @param goal Value of goal
    //! @param type Type of goal
    function drawGoalProgress(dc as Dc, current as Number?, goal as Number?, type as String) as Void {
        var amtFromGoal = 0;
        var progress = 1;
        var goalProgress = 1;
        var clockTime = System.getClockTime();
        var timeOfDay = ((clockTime.hour * 60) + clockTime.min) * 60 + clockTime.sec;

        // Get wake and sleep time from user profile
        timeOfDay -= (6 * 60 * 60); // Assume 6am Start of day.
        var daySeconds = 57600; // 16 * 60 * 60 assume 16 hour day

        // Prevent divide by 0 if goal is 0
        if ((goal == 0) || (goal == null)) {
            goal = 5000;
        }

        if (current != null) {
            // Compute goal
            var goalPace = goal;
            if (timeOfDay < daySeconds) {
                goalPace = (goal * timeOfDay / daySeconds);
                goalProgress = goalPace * 170 / goal;
            } else {
                goalProgress = 170;
            }
            amtFromGoal = goalPace - current;
            if (goalProgress == 0) {
                goalProgress = 1;
            }

            // Compute progress
            if (current < goal) {
                progress = current * 170 / goal;
            } else {
                progress = 170;
            }
        }

        // Draw progress bar outline
        var progressBarX = IS_SCREEN_RECTANGLE ? 14 : (dc.getWidth() / 2) - (176 / 2);
        var progressBarY = IS_SCREEN_RECTANGLE ? 3 : dc.getWidth() / 6;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(progressBarX, progressBarY, 176, 12);
        dc.drawRectangle(progressBarX + 1, progressBarY + 1, 174, 10);
        dc.drawRectangle(progressBarX + 2, progressBarY + 2, 172, 8);

        // Draw progress
        if (amtFromGoal > 0) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        } else {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        }

        dc.fillRectangle(progressBarX + 1 + goalProgress, progressBarY, 3, 12);
        dc.fillRectangle(progressBarX + 3, progressBarY + 3, progress, 6);

        // Set colors for drawing text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw Goal Progress
        if (current != null) {
            var string = current.toString() + " / " + goal.toString();
            dc.drawText(dc.getWidth() / 2, progressBarY + 15, Graphics.FONT_TINY, string, Graphics.TEXT_JUSTIFY_CENTER);

            string = type + " / goal";
            dc.drawText(dc.getWidth() / 2, progressBarY + 15 + Graphics.getFontAscent(Graphics.FONT_TINY), Graphics.FONT_TINY, string, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw step offset
        amtFromGoal = amtFromGoal * -1;
        dc.drawText(dc.getWidth() / 2, (dc.getHeight() - Graphics.getFontAscent(Graphics.FONT_LARGE)) / 2, Graphics.FONT_LARGE, amtFromGoal.toString(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Draw the distance at the bottom of the screen
    //! @param dc Draw context
    //! @param distance Distance in cm
    function drawDistance(dc as Dc, distance as Number?) as Void {
        if (distance != null) {
            var distMiles = distance.toFloat() / 160934; // convert from cm to miles
            var string = distMiles.format("%.02f");
            string += "mi";
            if (IS_SCREEN_RECTANGLE) {
                dc.drawText(5, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_LEFT);
            } else {
                dc.drawText(dc.getWidth() / 2, dc.getHeight() - 2 * Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
    }
}
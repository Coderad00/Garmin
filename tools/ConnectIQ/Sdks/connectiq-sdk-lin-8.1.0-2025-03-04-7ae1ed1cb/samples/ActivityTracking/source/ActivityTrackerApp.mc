//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This application shows how to use the activity tracking APIs.
//! When running in the simulator use ActivityMonitor > Set Activity Monitor
//! to set the information. The information should update on the views.
//! To set the wheelchair push information, turn on Wheelchair Mode
//! in the simulator settings for supported devices
class ActivityTrackerApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle application startup
    //! @param state Launch parameters
    public function onStart(state as Dictionary?) as Void {
    }

    //! Get the first view for the app
    //! @return Initial view and input delegate
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new $.ActivityTrackerView(), new $.ActivityTrackerDelegate()];
    }

    //! Handle app shutdown
    public function onStop(state as Dictionary?) as Void {
    }
}

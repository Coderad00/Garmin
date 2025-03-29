//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app demonstrates how to use multiple pages within a single application.
//! Next/previous page behaviors will cycle through different primate pictures
//! where each picture shows a different resource type. Tapping a page will
//! push a new view that displays information about the primate species.
class MyApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        // If device has ViewLoop support, use ViewLoop. Otherwise, fallback to the custom page indicator
        if (WatchUi has :ViewLoop) {
            var factory = new PageIndicatorFactory();
            var viewLoop = new WatchUi.ViewLoop(factory, {:page => 0, :wrap => true, :color => Graphics.COLOR_GREEN});
            return [viewLoop, new PageIndicatorDelegate(viewLoop)];
        } else {
            return [new $.PrimatesView(0), new $.PrimatesDelegate(0)];
        }
    }

}
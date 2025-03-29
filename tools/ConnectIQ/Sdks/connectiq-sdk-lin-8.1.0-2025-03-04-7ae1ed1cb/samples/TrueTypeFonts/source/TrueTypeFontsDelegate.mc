//
// Copyright 2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;

//! The Input handler for the derived views
class TrueTypeFontsDelegate extends WatchUi.BehaviorDelegate {

    private var _view as TrueTypeFontsView;

    //! Constructor
    //! @param view the current view
    public function initialize(view as TrueTypeFontsView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Navigate to the next page
    public function onNextPage() as Boolean {
        return changePage(DIRECTION_NEXT);
    }

    //! Navigate to the previous page
    public function onPreviousPage() as Boolean {
        return changePage(DIRECTION_PREVIOUS);
    }

    private function changePage(direction as Direction) as Boolean {
        _view.changePage(direction);
        WatchUi.requestUpdate();
        return true;
    }
}
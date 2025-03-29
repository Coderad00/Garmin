//
// Copyright 2015-2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! ViewLoop Factory which manages the main primate view/delegate paires
class PageIndicatorFactory extends WatchUi.ViewLoopFactory {
    private const NUM_PAGES = 3;

    function initialize() {
        ViewLoopFactory.initialize();
    }

    //! Retrieve a view/delegate pair for the page at the given index
    function getView(page as Number) as [ViewLoopFactory.Views] or [ViewLoopFactory.Views, ViewLoopFactory.Delegates] {
        return [new $.PrimatesViewLoopView(page), new $.PrimatesViewLoopDelegate(page)];
    }

    //! Return the number of view/delegate pairs that are managed by this factory
    function getSize() {
        return NUM_PAGES;
    }
}
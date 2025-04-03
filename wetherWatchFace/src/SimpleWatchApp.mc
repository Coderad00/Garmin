using Toybox.Application;
using Toybox.WatchUi;

class SimpleWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        // App wird gestartet
    }

    function onStop(state) {
        // App wird gestoppt
    }

    function getInitialView() {
        return [ new WetherWatchFace() ];
    }
} 
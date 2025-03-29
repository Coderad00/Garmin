import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app demonstrates how to create a watch face that can be configured by the native watch face editor.
class ConfigurationWatchFaceApp extends Application.AppBase {

    //! Whether the watch face was started by the watch face editor or not
    private var _editMode as Boolean = false;

    //! Constructor
    function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    function onStart(state as Dictionary?) as Void {
        if (state != null) {
            var watchFaceEditorActive = state[:launchedFromWatchFaceSettingsEditor] as Boolean?;
            if (watchFaceEditorActive) {
                _editMode = true;
            }
        }
    }

    //! Return the initial view for the app
    //! @return Array [ConfigurationWatchFaceView, ConfigurationWatchFaceDelegate]
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new ConfigurationWatchFaceView(_editMode);
        if (_editMode) {
            return [ view, new ConfigurationWatchFaceDelegate(view) ];
        } else {
            return [ view ];
        }
    }
}

//! Get the app instance
//! @return the app as a ConfigurationWatchFaceApp
function getApp() as ConfigurationWatchFaceApp {
    return Application.getApp() as ConfigurationWatchFaceApp;
}
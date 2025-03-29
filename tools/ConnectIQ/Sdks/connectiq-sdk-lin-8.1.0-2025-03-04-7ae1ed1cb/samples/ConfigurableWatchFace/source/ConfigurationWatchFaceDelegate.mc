import Toybox.Application.WatchFaceConfig;
import Toybox.Lang;
import Toybox.WatchUi;

//! Delegate to handle watch face input and notifications.
class ConfigurationWatchFaceDelegate extends WatchUi.WatchFaceDelegate {

    //! The view attached to this delegate
    private var _view as ConfigurationWatchFaceView;

    //! Constructor
    function initialize(view as ConfigurationWatchFaceView) {
        WatchFaceDelegate.initialize();
        _view = view;
    }

    //! Handle watch face configuration changes
    //! @param options The edited configuration
    function onWatchFaceConfigEdited(options as {:configId as $.Toybox.Application.WatchFaceConfig.Id, :type as WatchFaceConfigType?, :committed as $.Toybox.Lang.Boolean}) as Void {
        var id = options[:configId] as WatchFaceConfig.Id?;
        var type = options[:type] as WatchFaceConfigType?;

        // if an ID is passed in, get the settings and update the view
        if (id != null) {
            var settings = WatchFaceConfig.getSettings(id);
            if (settings != null) {
                _view.updateConfiguration(settings, type);
            }
        }
    }

    //! Give the requested drawable to the system
    //!
    //! Called when the system requests the drawable to display the currenty selected complication.
    //! @param complication The complication to get the drawable for
    function getComplicationDrawable(complication as ComplicationRef) as Drawable or ComplicationDrawableRef or Null {
        return _view.getComplication(complication);
    }

    //! Handle a tap event by notifying the system if a complication is at the tapped location
    //! @param clickEvent The tap event
    function onTap(clickEvent as ClickEvent) as $.Toybox.Lang.Boolean {
        var coords = clickEvent.getCoordinates();
        var selectedComplication = _view.getTappedComplication(coords[0], coords[1]);

        if (selectedComplication != null) {
            // let the system know that a complication was selected
            setSelectedComplication(selectedComplication);
            return true;
        }

        return false;
    }
}
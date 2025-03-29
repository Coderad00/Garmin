import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

//! This delegate is used to configure the sensor information that is displayed
class SensorConfigurationDelegate extends WatchUi.Menu2InputDelegate {
    //! The view that this delegate is associated with
    private var _view as SensorConfigurationView;

    //! Constructor
    //! @param view The view that this delegate is associated with
    public function initialize(view as SensorConfigurationView) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    //! Handle the done option being selected by storing the configuration
    public function onDone() as Void {
        storeSetting(Constants.Keys.TEMPERATURE);
        storeSetting(Constants.Keys.HUMIDITY);
        storeSetting(Constants.Keys.AIR_QUALITY);
        storeSetting(Constants.Keys.CO2);
        storeSetting(Constants.Keys.PRESSURE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    //! Store the setting for the given key
    //! @param id The id of the CheckboxMenuItem to store the setting for
    public function storeSetting(id as Constants.Keys.Key) as Void {
        var item = _view.getItem(_view.findItemById(id)) as CheckboxMenuItem;
        Storage.setValue(id, item.isChecked());
    }
}

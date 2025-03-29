import Toybox.Lang;

class DeviceSettingChangedManager {

    hidden var _fontScale as Float = 1.0f;

    public function initialize() {
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings has :fontScale) {
            _fontScale = deviceSettings.fontScale;
        }
    }

    //! Respond to device settings change
    //! @param aSymbol symbol for changed setting
    //! @param aValue value for changed setting
    public function onDeviceSettingChanged(aSymbol as Symbol, aValue as Object) as Void {
        if (aSymbol == :fontScale) {
            _fontScale = aValue as Float;
            WatchUi.requestUpdate();
        }
    }

    //! Retrieve the current font scale
    public function getFontScale() as Float {
        return _fontScale;
    }
}
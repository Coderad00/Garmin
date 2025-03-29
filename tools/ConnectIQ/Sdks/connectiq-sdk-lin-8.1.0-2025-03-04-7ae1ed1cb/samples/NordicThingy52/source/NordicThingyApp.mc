//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app uses the Bluetooth Low Energy API to pair with devices.
class NordicThingyApp extends Application.AppBase {
    private var _bleDelegate as ThingyDelegate?;
    private var _profileManager as ProfileManager?;
    private var _modelFactory as DataModelFactory?;
    private var _viewController as ViewController?;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        _profileManager = new $.ProfileManager();
        _bleDelegate = new $.ThingyDelegate(_profileManager as ProfileManager);
        _modelFactory = new $.DataModelFactory(_bleDelegate as ThingyDelegate, _profileManager as ProfileManager);
        _viewController = new $.ViewController(_modelFactory as DataModelFactory);

        BluetoothLowEnergy.setDelegate(_bleDelegate as ThingyDelegate);
        if (_profileManager != null) {
            _profileManager.registerProfiles();
        }
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        _viewController = null;
        _modelFactory = null;
        _profileManager = null;
        _bleDelegate = null;
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {

        var scanResult = Storage.getValue(Constants.Keys.PAIRED_SENSOR) as BluetoothLowEnergy.ScanResult?;
        if ((scanResult != null) && (_viewController != null)) {
            return _viewController.getDeviceView(scanResult);
        }

        if (_viewController != null) {
            return _viewController.getInitialView();
        }
        System.error("ViewController uninitialized.");
    }

    //! Get the configuration view when pairing a sensor
    //! @param sensor The sensor to configure
    //! @return Array Pair [View, InputDelegate] the view and input delegate for the configuration
    public function getSensorConfigurationView(sensor as $.Toybox.Sensor.SensorInfo) as [Views] or [Views, InputDelegates] {
        var view = new SensorConfigurationView();
        return [view, new SensorConfigurationDelegate(view)];
    }

    //! Get the sensor delegate for the app when pairing
    //! @return SensorDelegate The sensor delegate for the ap
    public function getSensorDelegate() as $.Toybox.Sensor.SensorDelegate or Null {
        return new NordicThingySensorDelegate();
    }
}

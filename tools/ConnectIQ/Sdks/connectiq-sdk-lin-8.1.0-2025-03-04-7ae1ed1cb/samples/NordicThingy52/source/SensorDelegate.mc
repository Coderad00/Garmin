//
// Copyright 2025 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.Sensor;

//! This app uses the Bluetooth Low Energy API to pair with devices.
class NordicThingySensorDelegate extends Sensor.SensorDelegate {
    private var _bleDelegate as ThingyDelegate;
    private var _profileManager as ProfileManager;
    private var _sensor as Sensor.SensorInfo?;
    private var _scanResult as BluetoothLowEnergy.ScanResult?;

    //! Constructor
    public function initialize() {
        SensorDelegate.initialize();
        _profileManager = new ProfileManager();
        _bleDelegate = new ThingyDelegate(_profileManager);

        _bleDelegate.notifyScanResult(self);
        _bleDelegate.notifyConnection(self);
        BluetoothLowEnergy.setDelegate(_bleDelegate);
    }

    //! Callback for when a scan result is received
    //! @param scanResult The scan result
    public function procScanResult(scanResult as ScanResult) as Void {
        // Get the device name, giving it a generic one if the name can't be obtained
        var name = scanResult.getDeviceName();
        if (name == null) {
            name = "Unknown Device";
        }

        // Create a new sensor with the scan result
        var sensor = new Sensor.SensorInfo();
        sensor.name = name;
        sensor.technology = Sensor.SENSOR_TECHNOLOGY_BLE;
        sensor.type = Sensor.SENSOR_GENERIC;
        sensor.data = {:bleScanResult => scanResult};
        sensor.partNumber = 0;
        sensor.manufacturerId = 0;

        // Let the system know that the scan is complete
        Sensor.notifyNewSensor(sensor, true);
        Sensor.notifyScanComplete();
        BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_OFF);
    }

    //! Callback for when a connection is established. This will be called after a successful pairing
    //! for the same sensor passed to onPair().
    //! @param device The device that was connected
    function procConnection(device as Device) as Void {
        if (_sensor != null) {
            Sensor.notifyPairComplete(_sensor);
            Storage.setValue(Constants.Keys.PAIRED_SENSOR, _scanResult);
        }
    }

    //! The system will call this from the native pairing flow to determine if this app
    //! can pair natively.
    //! @return true if pairing is required, false otherwise
    public function pairingRequired() as Boolean {
        return true;
    }

    //! The system will call this it is this app's turn to scan for devices.
    //! @return true if the app is scanning, false otherwise
    public function onScan() as Boolean {
        // If a device is already paired, don't scan
        if (Storage.getValue(Constants.Keys.PAIRED_SENSOR) != null) {
            return false;
        }

        BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_SCANNING);
        return true;
    }

    //! The system will call this when a device is ready to pair
    //! @param sensor The sensor to pair
    //! @return true if pairing was started, false otherwise
    public function onPair(sensor as Sensor.SensorInfo) as Boolean {
        var pairing = false;
        var data = sensor.data;
        if (data != null) {
            var scanResult = data[:bleScanResult] as BluetoothLowEnergy.ScanResult?;
            if (scanResult != null) {
                // if pairing was started, save the sensor so it can be used in procConnection()
                if (BluetoothLowEnergy.pairDevice(scanResult) != null) {
                    pairing = true;
                    _sensor = sensor;
                    _scanResult = scanResult;
                }
            }
        }
        return pairing;
    }

    //! The system will call this when a device is ready to unpair
    //! @param sensor The sensor to unpair
    //! @return true if unpairing was successful, false otherwise
    public function onUnpair(sensor as Sensor.SensorInfo) as Boolean {
        var unpaired = false;
        var data = sensor.data;
        if (data != null) {
            var scanResult = data[:bleScanResult] as BluetoothLowEnergy.ScanResult?;
            if (scanResult != null) {
                var pairedDevice = Storage.getValue(Constants.Keys.PAIRED_SENSOR) as BluetoothLowEnergy.ScanResult?;
                if ((pairedDevice != null) && pairedDevice.isSameDevice(scanResult)) {
                    unpaired = true;
                    Sensor.notifyUnpairComplete(sensor);
                    Storage.deleteValue(Constants.Keys.PAIRED_SENSOR);
                    _sensor = null;
                    _scanResult = null;
                }
            }
        }
        return unpaired;
    }
}

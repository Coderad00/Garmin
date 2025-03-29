//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class ViewController {
    private var _modelFactory as DataModelFactory;

    //! Constructor
    //! @param modelFactory Factory to create models
    public function initialize(modelFactory as DataModelFactory) {
        _modelFactory = modelFactory;
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        var scanDataModel = _modelFactory.getScanDataModel();

        return [new $.ScanView(scanDataModel), new $.ScanDelegate(scanDataModel, self)];
    }

    //! Push the scan menu view
    public function pushScanMenu() as Void {
        var menu = new $.Rez.Menus.MainMenu();

        // add the pair to device menu item if the device supports it
        var apiLevel = System.getDeviceSettings().monkeyVersion;
        if ((apiLevel[0] >= 5) && (apiLevel[1] >= 1)) {
            menu.addItem(Rez.Strings.pairToDevice, :pair);
        }

        WatchUi.pushView(menu, new $.ScanMenuDelegate(), WatchUi.SLIDE_UP);
    }

    //! Get the device view and delegate
    //! @param scanResult The scan result to use for the device view
    //! @return Array Pair [View, InputDelegate] the device view and its input delegate
    public function getDeviceView(scanResult as ScanResult) as [Views, InputDelegates] {
        var deviceDataModel = _modelFactory.getDeviceDataModel(scanResult);
        return [new $.DeviceView(deviceDataModel), new $.DeviceDelegate(deviceDataModel)];
    }

    //! Push the device view
    //! @param scanResult The scan result for the device view to push
    public function pushDeviceView(scanResult as ScanResult) as Void {
        var view = getDeviceView(scanResult);

        WatchUi.pushView(view[0], view[1], WatchUi.SLIDE_UP);
    }
}

import Toybox.WatchUi;

//! Configuration view for the Thingy 52 sensor
class SensorConfigurationView extends WatchUi.CheckboxMenu {

    //! Constructor
    public function initialize() {
        CheckboxMenu.initialize({:title => "Thingy 52 Configuration"});

        addItem(new CheckboxMenuItem("Temperature", null, Constants.Keys.TEMPERATURE, true, null));
        addItem(new CheckboxMenuItem("Humidity", null, Constants.Keys.HUMIDITY, true, null));
        addItem(new CheckboxMenuItem("Pressure", null, Constants.Keys.PRESSURE, true, null));
        addItem(new CheckboxMenuItem("CO2", null, Constants.Keys.CO2, true, null));
        addItem(new CheckboxMenuItem("Air Quality", null, Constants.Keys.AIR_QUALITY, true, null));
    }

}

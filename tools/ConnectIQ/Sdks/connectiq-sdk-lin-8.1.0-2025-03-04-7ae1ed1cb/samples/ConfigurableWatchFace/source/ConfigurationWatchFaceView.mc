import Toybox.Application;
import Toybox.Application.WatchFaceConfig;
import Toybox.Complications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Watch face view that handles both normal and configuration modes
class ConfigurationWatchFaceView extends WatchUi.WatchFace {

    // Default values for variables
    private const _DEFAULT_STYLE = Styles.HOUR_MINUTES_SECONDS;
    private const _DEFAULT_ACCENT_COLOR = Graphics.COLOR_GREEN;
    private const _DEFAULT_DATA_COLOR = Graphics.COLOR_WHITE;
    private const _DEFAULT_TOP_COMPLICATION = Complications.COMPLICATION_TYPE_BATTERY;
    private const _DEFAULT_BOTTOM_COMPLICATION = Complications.COMPLICATION_TYPE_STEPS;

    //! If the view is in edit mode or not
    private var _editMode as Boolean = false;
    //! The style to display the time in
    private var _style as Number = _DEFAULT_STYLE;
    //! The format string for the time
    private var _styleString as String = "";
    //! The color for the time
    private var _accentColor as Number = _DEFAULT_ACCENT_COLOR;
    //! The color for the complications
    private var _complicationColor as Number = _DEFAULT_DATA_COLOR;
    //! The top complication
    private var _topComplicationId as Complications.Id = new Complications.Id(_DEFAULT_TOP_COMPLICATION);
    //! The bottom complication
    private var _bottomComplicationId as Complications.Id = new Complications.Id(_DEFAULT_BOTTOM_COMPLICATION);
    //! The selected complication when editing
    private var _selectedComplication as Complications.Id?;
    //! Whether or not a complcation is being edited
    private var _editingComplication as Boolean = false;

    //! Constructor
    //! @param editMode If the view is in edit mode or not
    function initialize(editMode as Boolean) {
        WatchFace.initialize();
        _editMode = editMode;
    }

    //! Load resources for the watch face
    //! @param dc The drawing context
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        var settings = WatchFaceConfig.getSettings(null);

        // settings will only be null when the device doesn't support watch face configuration.
        // If this is run on such a device, it will crash above. A real application should
        // handle this case if it is expected to run on such a device.
        if (settings == null) {
            return;
        }

        updateConfiguration(settings, null);

        // Calculate the text dimensions for the complications
        (findDrawableById("TopComplication") as ComplicationDrawable).calculateTextDimensions(dc);
        (findDrawableById("BottomComplication") as ComplicationDrawable).calculateTextDimensions(dc);

        // If not in edit mode, subscribe to complication updates. When in edit mode,
        // there isn't a need to update complications in real time. The current snapshot
        // when selecting a complication type is sufficient.
        if (!_editMode) {
            Complications.subscribeToUpdates(_topComplicationId);
            Complications.subscribeToUpdates(_bottomComplicationId);
            Complications.registerComplicationChangeCallback(method(:onComplicationChange));
        }
    }

    //! Draw the watch face
    //! @param dc The drawing context
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var clockTime = System.getClockTime();
        var timeString = Lang.format(_styleString, [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);

        // Update the time drawable
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setColor(_accentColor);
        timeLabel.setText(timeString);

        // Update the complication colors
        var topComplication = (View.findDrawableById("TopComplication") as ComplicationDrawable);
        var bottomComplication = (View.findDrawableById("BottomComplication") as ComplicationDrawable);
        topComplication.setColor(_complicationColor);
        bottomComplication.setColor(_complicationColor);

        // If editing a complication, hide the one that is being edited
        if (_editingComplication) {
            if (_selectedComplication == _topComplicationId) {
                topComplication.setVisible(false);
            } else if (_selectedComplication == _bottomComplicationId) {
                bottomComplication.setVisible(false);
            }
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Show the complications again. This will allow them to be drawn when the system
        // asks for the complication for the watch face editor.
        topComplication.setVisible(true);
        bottomComplication.setVisible(true);
    }

    //! Update the configuration of the watch face with the given settings.
    //! @param config The settings to update the watch face with
    //! @param editedType The type of configuration that changed. Will be null if the configuration is being initialized
    function updateConfiguration(config as WatchFaceConfig.Settings, editedType as WatchFaceConfigType?) as Void {
        // It's possible that some values in config are null, so check values and use defaults if necessary
        // Get the style, setting to default if the style is not set
        var styleId = config.styleId;
        if (styleId != null) {
            _style = styleId;
        } else {
            _style = _DEFAULT_STYLE;
        }

        // Determine which style string format to use based on the style
        switch (_style) {
            case Styles.HOUR:
                _styleString = "$1$";
                break;

            case Styles.HOUR_MINUTES:
                _styleString = "$1$:$2$";
                break;

            case Styles.HOUR_MINUTES_SECONDS:
                _styleString = "$1$:$2$:$3$";
                break;
        }

        // Get the accent color, setting to default if the color is not set
        var accentColor = config.accentColor;
        if (accentColor != null) {
            _accentColor = accentColor.color as Number;
        }

        if (_accentColor == null) {
            _accentColor = _DEFAULT_ACCENT_COLOR;
        }

        // Get the complication color, setting to default if the color is not set
        var complicationColor = config.complicationColor as WatchFaceConfig.Color;
        if (complicationColor != null) {
            _complicationColor = complicationColor.color as Number;
        }

        if (_complicationColor == null) {
            _complicationColor = _DEFAULT_DATA_COLOR;
        }

        // Update the complication settings
        var complicationSettings = config.complicationSettings;
        if (complicationSettings != null) {
            var size = complicationSettings.size();
            for (var idx = 0; idx < size; ++idx) {
                // Get the needed values from the complication
                var complication = complicationSettings[idx];
                var uniqueIdentifier = complication.uniqueIdentifier;
                var complicationId = complication.complicationId;

                // A unique identifier is required to update the complication.
                if (uniqueIdentifier == null) {
                    continue;
                }

                // Get the drawable id and determine if the complication is being edited
                // or not based on if the complication type has changed.
                if (uniqueIdentifier == ComplicationLocation.TOP) {
                    if (complicationId == null) {
                        complicationId = new Complications.Id(_DEFAULT_TOP_COMPLICATION);
                    }

                    updateComplicationText("TopComplication", complicationId);

                    if (_topComplicationId.getType() != complicationId.getType()) {
                        _topComplicationId = complicationId;
                    }
                } else if (uniqueIdentifier == ComplicationLocation.BOTTOM) {
                    if (complicationId == null) {
                        complicationId = new Complications.Id(_DEFAULT_BOTTOM_COMPLICATION);
                    }

                    updateComplicationText("BottomComplication", complicationId);

                    if (_bottomComplicationId.getType() != complicationId.getType()) {
                        _bottomComplicationId = complicationId;
                    }
                    break;
                }
            }
        }

        // Determine if a complication is being edited or not
        _editingComplication = (editedType == WatchUi.WATCH_FACE_CONFIG_TYPE_COMPLICATION);

        WatchUi.requestUpdate();
    }

    //! Callback for when a complication changes
    //! @param id The id of the complication that changed
    function onComplicationChange(id as Complications.Id) as Void {
        var drawableId = null;

        // Determine which complication changed
        if (id.equals(_topComplicationId)) {
            drawableId = "TopComplication";
        } else if (id.equals(_bottomComplicationId)) {
            drawableId = "BottomComplication";
        } else {
            System.println("Unknown complication id: " + id.getType());
        }

        // Update the complication
        if (drawableId != null) {
            updateComplicationText(drawableId, id);
        }
    }

    //! Update the text of the complication
    //! @param drawableId The layout id of the drawable to update
    //! @param complicationId The id of the complication to get from the system
    function updateComplicationText(drawableId as String, complicationId as Complications.Id) as Void {
        var complication = Complications.getComplication(complicationId);
        var text = Application.loadResource(Rez.Strings.complication) as String;
        var drawable = findDrawableById(drawableId) as ComplicationDrawable;

        var label = complication.shortLabel;
        if (label == null) {
            label = complication.longLabel;
        }
        if (label == null) {
            label = "";
        }

        var value = complication.value;
        if (value == null) {
            value = "";
        }

        drawable.setText(Lang.format(text, [label, value]));
    }

    //! Get the complication tapped at the given coordinates
    //! @param x The x coordinate of the tap
    //! @param y The y coordinate of the tap
    function getTappedComplication(x as Number, y as Number) as ComplicationLocation.Value? {
        if (complicationTapped("TopComplication", x, y)) {
            return ComplicationLocation.TOP;
        } else if (complicationTapped("BottomComplication", x, y)) {
            return ComplicationLocation.BOTTOM;
        }

        // No complication was tapped
        return null;
    }

    //! Determine if a complication was tapped
    //! @param drawableId The id of the drawable to check
    //! @param x The x coordinate of the tap
    //! @param y The y coordinate of the tap
    function complicationTapped(drawableId as String, x as Number, y as Number) as Boolean {
        var complication = findDrawableById(drawableId) as ComplicationDrawable;
        return complication.containsPoint(x, y);
    }

    //! Get the complication drawable for the given complication reference
    //! @param complication The complication reference to get the drawable for
    function getComplication(complication as ComplicationRef) as ComplicationDrawableRef or Null {
        var topDrawable = findDrawableById("TopComplication") as ComplicationDrawable;
        var bottomDrawable = findDrawableById("BottomComplication") as ComplicationDrawable;
        var drawable = null;

        _editingComplication = true;

        if (complication.uniqueIdentifier == ComplicationLocation.TOP) {
            drawable = topDrawable;
            _selectedComplication = _topComplicationId;
        } else if (complication.uniqueIdentifier == ComplicationLocation.BOTTOM) {
            drawable = bottomDrawable;
            _selectedComplication = _bottomComplicationId;
        }

        WatchUi.requestUpdate();

        if (drawable == null) {
            return null;
        }

        return new WatchUi.ComplicationDrawableRef({
            :drawable => drawable,
            :boundingBox => drawable.getBoundingBox()
        });
    }
}

//
// Copyright 2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

//! Defines the possible TTF face names
const ALL_FACE_NAMES = [
    "BionicBold",
    "ExoSemiBold",
    "KosugiRegular",
    "NanumGothicBold",
    "NanumGothicExtraBold",
    "NanumGothicRegular",
    "NotoNaskhArabicBold",
    "NotoNaskhArabicRegular",
    "NotoSansArmenianBold",
    "NotoSansArmenianRegular",
    "NotoSansHebrewBold",
    "NotoSansHebrewRegular",
    "NotoSansSCMedium",
    "PridiRegular",
    "PridiRegularGarmin",
    "PridiSemiBoldGarmin",
    "RobotoBlack",
    "RobotoCondensedBold",
    "RobotoCondensedRegular",
    "RobotoCondensedRegularItalic",
    "RobotoRegular",
    "SakkalMajallaBold",
    "SakkalMajallaRoman",
    "Swiss721Bold",
    "Swiss721Regular",
    "TomorrowBold",
    "YantramanavRegular"
];

//! Define the direction at which the available pages will be looped through
enum Direction {
    DIRECTION_PREVIOUS,
    DIRECTION_NEXT,
}

//! This app shows how to use TTF(True Type Fonts).
class TrueTypeFontsApp extends Application.AppBase {

    hidden var _deviceSettingChangedManager as DeviceSettingChangedManager;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
        _deviceSettingChangedManager = new DeviceSettingChangedManager();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view for the app
    //! @return Array [View]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        if (Toybox.Graphics has :VectorFont) {
            var mainMenu = new WatchUi.Menu2({:title=>"TrueTypeFonts Menu"});
            mainMenu.addItem(new WatchUi.MenuItem("Font Mapping", null, :font_mapping, null));
            mainMenu.addItem(new WatchUi.MenuItem("Vector Fonts", null, :vector_fonts, null));
            mainMenu.addItem(new WatchUi.MenuItem("Angled Text", null, :angled_text, null));
            mainMenu.addItem(new WatchUi.MenuItem("Radial Text", null, :radial_text, null));
            return [ mainMenu, new TrueTypeFontsMenuDelegate(_deviceSettingChangedManager) ];
        } else {
            var message = "Vector Fonts Not Supported";
            return [ new ExceptionView(message) ];
        }
    }

    //! Respond to device settings change
    //! @param aSymbol symbol for changed setting
    //! @param aValue value for changed setting
    public function onDeviceSettingChanged(aSymbol as Symbol, aValue as Object) as Void {
        _deviceSettingChangedManager.onDeviceSettingChanged(aSymbol, aValue);
    }
}

//! Get all the available TTF face names
public function getAllAvailableTrueTypeFontFaceNames() as Array<String> {
    var names = [] as Array<String>;
    for (var i = 0; i < ALL_FACE_NAMES.size(); i++) {
        var face = ALL_FACE_NAMES[i];
        var font = Graphics.getVectorFont({:face => face, :size => 16});
        if (font != null) {
            names.add(face);
        }
    }
    return names;
}

//! Get the first TTF for the given size
//! @param size The expected TTF size
public function getFirstAvailableTrueTypeFont(size as Number or Float) as VectorFont {
    for (var i = 0; i < ALL_FACE_NAMES.size(); i++) {
        var font = Graphics.getVectorFont({:face => ALL_FACE_NAMES[i], :size => size});
        if (font != null) {
            return font;
        }
    }
    throw new Lang.InvalidValueException("No Vector Font");
}

//! Get the justification description based on the given justification
//! @param justification The given justification
public function getJustificationDescription(justification as Number or TextJustification) as String {
    var result;

    if (justification & Graphics.TEXT_JUSTIFY_LEFT) {
        result = "Left";
    } else if (justification & Graphics.TEXT_JUSTIFY_CENTER) {
        result = "Center";
    } else {
        result = "Right";
    }

    if (justification & Graphics.TEXT_JUSTIFY_VCENTER) {
        result += "|VerticalCenter";
    }

    return result;
}

//! Get the orientation description based on the given orientation
//! @param orientation The given orientation
public function getOrientationDescription(orientation as RadialTextDirection) as String {
    var result;

    if (orientation == Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE) {
        result = "CounterClockwise";
    } else {
        result = "Clockwise";
    }

    return result;
}
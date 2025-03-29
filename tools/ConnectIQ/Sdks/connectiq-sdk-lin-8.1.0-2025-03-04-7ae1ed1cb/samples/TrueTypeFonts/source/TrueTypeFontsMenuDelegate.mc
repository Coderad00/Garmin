//
// Copyright 2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;

//! Input handler to respond to menu selections
class TrueTypeFontsMenuDelegate extends WatchUi.Menu2InputDelegate {

   hidden var _deviceSettingChangedManager as DeviceSettingChangedManager;

   //! Constructor
   //! @param deviceSettingsChangedManager the DeviceSettingChangedManager instance
   public function initialize(deviceSettingsChangedManager as DeviceSettingChangedManager) {
      Menu2InputDelegate.initialize();
      _deviceSettingChangedManager = deviceSettingsChangedManager;
    }

   //! Push the map view corresponding to the selected menu item
   //! @param item Symbol identifier of the menu item that was chosen
   public function onSelect(item) {
      if (item.getId() == :font_mapping ) {
         var view = new TrueTypeFontsFontMappingView(_deviceSettingChangedManager);
         WatchUi.pushView(view, new TrueTypeFontsDelegate(view),  WatchUi.SLIDE_IMMEDIATE);
      }
      else if (item.getId() == :vector_fonts) {
         var view = new TrueTypeFontsVectorFontsView(_deviceSettingChangedManager);
         WatchUi.pushView(view, new TrueTypeFontsDelegate(view),  WatchUi.SLIDE_IMMEDIATE);
      }
      else if (item.getId() == :angled_text) {
         var view = new TrueTypeFontsAngledTextView(_deviceSettingChangedManager);
         WatchUi.pushView(view, new TrueTypeFontsDelegate(view),  WatchUi.SLIDE_IMMEDIATE);
      }
      else if (item.getId() == :radial_text) {
         var view = new TrueTypeFontsRadialTextView(_deviceSettingChangedManager);
         WatchUi.pushView(view, new TrueTypeFontsDelegate(view),  WatchUi.SLIDE_IMMEDIATE);
      }
   }

}
//
// Copyright 2018-2024 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Custom icon used for the divider
class DividerCustomMenuDrawableIcon extends WatchUi.Drawable {
    private var _value as Number;

    //! Constructor
    //! @param value Item height value
    public function initialize(value as Number) {
        _value = value;

        // setup the drawable (icon)
        WatchUi.Drawable.initialize({:identifier=>value, :locX=>0, :locY=>0, :width=>100, :height=>100, :visible=>true});
    }

    //! Draw the item height value in the center of the drawable (icon)
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_XTINY, _value.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

//! Custom menu item that has the height of the item as the label
class DividerCustomMenuItem extends WatchUi.CustomMenuItem {
    private var _itemHeight as Number;

    //! Constructor
    //! @param idx Item index
    //! @param heightFactor Height factor to be multiplied by the index to get the item height
    public function initialize(idx as Number, heightFactor as Number) {
        _itemHeight = idx * heightFactor;
        var icon = null;

        // Alternate between the launcher icon and the custom icon
        if (_itemHeight % (heightFactor * 2)) {
            icon = WatchUi.loadResource($.Rez.Drawables.LauncherIcon) as BitmapResource;
        } else {
            icon = new DividerCustomMenuDrawableIcon(_itemHeight);
        }

        WatchUi.CustomMenuItem.initialize(_itemHeight, {:dividerIcon=>icon});
    }

    //! Draw the menu item with the item height as the label
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        // Draw the rectangle for the menu item
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();

        dc.drawText(0, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Height: " + _itemHeight, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //! Get the height of the menu item
    //! @return The height of the menu item
    public function getHeight() as Number {
        return _itemHeight;
    }
}

//! This is the menu input delegate for the Custom Divider menu
class DividerCustomMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _menu as DividerCustomMenu?;

    //! Constructor
    //! @param menu The menu to be used
    public function initialize(menu as DividerCustomMenu?) {
        _menu = menu;

        WatchUi.Menu2InputDelegate.initialize();
    }

    //! Handle the title being selected
    public function onTitle() as Void {
        if (_menu != null) {
            _menu.changeDividerType();
        }
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var dividerType = null;
        if (_menu != null) {
           dividerType = _menu.getDividerType();
        }
        var menu = new DividerCustomMenu((item as DividerCustomMenuItem).getHeight(), dividerType);
        WatchUi.switchToView(menu, new DividerCustomMenuDelegate(menu), WatchUi.SLIDE_UP);
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! Menu for the Custom Divider menu
class DividerCustomMenu extends WatchUi.CustomMenu {
    const NUM_ITEMS = 8;
    const HEIGHT_FACTOR = 30;

    private var _dividerType as WatchUi.Menu2.DividerType?;

    //! Constructor
    //! @param itemHeight The height of the menu items
    //! @param dividerType The divider type to be used
    public function initialize(itemHeight as Number, dividerType as WatchUi.Menu2.DividerType?) {
        _dividerType = dividerType;

        WatchUi.CustomMenu.initialize(itemHeight, Graphics.COLOR_BLACK, {:dividerType=>dividerType});

        for (var i = 1; i <= NUM_ITEMS; ++i) {
            addItem(new DividerCustomMenuItem(i, HEIGHT_FACTOR));
        }
    }

    //! Handles changing of the divider type
    public function changeDividerType() as Void {
        if (_dividerType == WatchUi.Menu2.DIVIDER_TYPE_DEFAULT) {
            _dividerType = WatchUi.Menu2.DIVIDER_TYPE_ICON;
        } else if (_dividerType == WatchUi.Menu2.DIVIDER_TYPE_ICON) {
            _dividerType = null;
        } else {
            _dividerType = WatchUi.Menu2.DIVIDER_TYPE_DEFAULT;
        }

        setDividerType(_dividerType);
    }

    //! Gets the current divider type
    //! @return The current divider type
    public function getDividerType() as WatchUi.Menu2.DividerType? {
        return _dividerType;
    }

    //! Draw the title with instructions to change the divider type
    //! @param dc Device context
    public function drawTitle(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLUE);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "Tap here to\nchange divider type", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

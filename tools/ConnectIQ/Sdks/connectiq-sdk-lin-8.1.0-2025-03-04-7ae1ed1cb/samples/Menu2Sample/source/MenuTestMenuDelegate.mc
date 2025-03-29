//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This is the menu input delegate for the main menu of the application
class Menu2TestMenu2Delegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        var title = new $.DividerTitle();
        if (id.equals("toggle")) {
            // When the toggle menu item is selected, push a new menu that demonstrates
            // left and right toggles with automatic substring toggles.
            if (!(WatchUi.Menu2 has :setDividerType)) {
                title = "Toggles";
            }
            var toggleMenu = new WatchUi.Menu2({:title=>title});
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Item 1", {:enabled=>"Left Toggle: on", :disabled=>"Left Toggle: off"}, "left", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Item 2", {:enabled=>"Right Toggle: on", :disabled=>"Right Toggle: off"}, "right", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Item 3", {:enabled=>"Toggle: on", :disabled=>"Toggle: off"}, "default", true, null));
            WatchUi.pushView(toggleMenu, new $.Menu2SampleSubMenuDelegate(toggleMenu), WatchUi.SLIDE_UP);
        } else if (id.equals("check")) {
            // When the check menu item is selected, push a new menu that demonstrates
            // left and right checkbox menu items
            if (!(WatchUi.Menu2 has :setDividerType)) {
                title = "Checkboxes";
            }
            var checkMenu = new WatchUi.CheckboxMenu({:title=>title});
            checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 1", "Left Check", "left", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 2", "Right Check", "right", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 3", "Check", "default", true, null));
            WatchUi.pushView(checkMenu, new $.Menu2SampleSubMenuDelegate(checkMenu), WatchUi.SLIDE_UP);
        } else if (id.equals("icon")) {
            // When the icon menu item is selected, push a new menu that demonstrates
            // left and right custom icon menus
            if (!(WatchUi.Menu2 has :setDividerType)) {
                title = "Icons";
            }
            var iconMenu = new WatchUi.Menu2({:title=>title});
            var drawable1 = new $.CustomIcon();
            var drawable2 = new $.CustomIcon();
            var drawable3 = new $.CustomIcon();
            iconMenu.addItem(new WatchUi.IconMenuItem("Icon 1", drawable1.getString(), "left", drawable1, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            iconMenu.addItem(new WatchUi.IconMenuItem("Icon 2", drawable2.getString(), "right", drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            iconMenu.addItem(new WatchUi.IconMenuItem("Icon 3", drawable3.getString(), "default", drawable3, null));
            WatchUi.pushView(iconMenu, new $.Menu2SampleSubMenuDelegate(iconMenu), WatchUi.SLIDE_UP);
        } else if (id.equals("custom")) {
            // When the custom menu item is selected, push a new menu that demonstrates
            // custom menus
            var customMenu = new WatchUi.Menu2({:title=>"Custom Menus"});
            customMenu.addItem(new WatchUi.MenuItem("Basic Drawables", null, :basic, null));
            customMenu.addItem(new WatchUi.MenuItem("Images", null, :images, null));
            customMenu.addItem(new WatchUi.MenuItem("Wrap Out", null, :wrap, null));
            if (Menu2 has :setDividerType) {
                customMenu.addItem(new WatchUi.MenuItem("Divider", null, :divider, null));
            }
            WatchUi.pushView(customMenu, new $.Menu2SampleCustomDelegate(), WatchUi.SLIDE_UP);
        } else {
            WatchUi.requestUpdate();
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _menu as WatchUi.Menu2;
    private var _dividerType as WatchUi.Menu2.DividerType? = WatchUi.Menu2.DIVIDER_TYPE_DEFAULT;
    private var _count as Number = 0;

    //! Constructor
    //! @param menu The menu to be used
    public function initialize(menu as WatchUi.Menu2) {
        _menu = menu;
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        // For IconMenuItems, we will change to the next icon state.
        // This demonstrates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        if (item instanceof WatchUi.IconMenuItem) {
            item.setSubLabel((item.getIcon() as CustomIcon).nextState());
        }
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        if (WatchUi.Menu2 has :setDividerType) {
            if (_count % 2 == 0) {
                _count++;
                if (_dividerType == WatchUi.Menu2.DIVIDER_TYPE_DEFAULT) {
                    _dividerType = WatchUi.Menu2.DIVIDER_TYPE_ICON;
                } else if (_dividerType == WatchUi.Menu2.DIVIDER_TYPE_ICON){
                    _dividerType = WatchUi.Menu2.DIVIDER_TYPE_DEFAULT;
                }
                _menu.setDividerType(_dividerType);
            } else {
                WatchUi.popView(WatchUi.SLIDE_DOWN);
            }
        } else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the menu input delegate for the custom sub-menu
class Menu2SampleCustomDelegate extends WatchUi.Menu2InputDelegate {
    const ITEM_HEIGHT = 30;

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var id = item.getId();

        // Create/push the custom menus
        if (id == :basic) {
            $.pushBasicCustom();
        } else if (id == :images) {
            $.pushImagesCustom();
        } else if (id == :wrap) {
            $.pushWrapCustom();
        } else if (id == :divider) {
            var menu = new $.DividerCustomMenu(ITEM_HEIGHT, WatchUi.Menu2.DIVIDER_TYPE_DEFAULT);
            WatchUi.pushView(menu, new $.DividerCustomMenuDelegate(menu), WatchUi.SLIDE_UP);
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the custom Icon drawable. It fills the icon space with a color
//! to demonstrate its extents. It changes color each time the next state is
//! triggered, which is done when the item is selected in this application.
class CustomIcon extends WatchUi.Drawable {
    // This constant data stores the color state list.
    private const _colors = [Graphics.COLOR_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN,
                             Graphics.COLOR_BLUE, Graphics.COLOR_PURPLE];
    private const _colorStrings = ["Red", "Orange", "Yellow", "Green", "Blue", "Violet"];
    private var _index as Number;

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
        _index = 0;
    }

    //! Advance to the next color state for the drawable
    //! @return The new color state
    public function nextState() as String {
        _index++;
        if (_index >= _colors.size()) {
            _index = 0;
        }

        return _colorStrings[_index];
    }

    //! Return the color string for the menu to use as its sublabel
    //! @return The current color
    public function getString() as String {
        return _colorStrings[_index];
    }

    //! Set the color for the current state and use dc.clear() to fill
    //! the drawable area with that color
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var color = _colors[_index];
        dc.setColor(color, color);
        dc.clear();
    }
}

//! This is the drawable for the Menu2 title with instructions to change the divider type
class DividerTitle extends WatchUi.Drawable {

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
    }

    //! Draw the title with instructions to change the divider type
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLUE);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_XTINY, "Press the back\nbutton to change\ndivider type", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

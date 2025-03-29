//
// Copyright 2015-2023 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the picture and name of a primate
class PrimatesViewLoopView extends WatchUi.View {

    private var _index as Number;
    private var _bitmap as BitmapResource;

    private const COLOR = Graphics.COLOR_BLACK;
    private const IMAGES = [$.Rez.Drawables.id_apes,
                            $.Rez.Drawables.id_monkeys,
                            $.Rez.Drawables.id_prosimians];
    private const PRIMATES = ["Apes", "Monkeys", "Prosimians"];

    //! Constructor
    //! @param index The current page index
    public function initialize(index as Number) {
        View.initialize();
        _index = index;
        _bitmap = WatchUi.loadResource(IMAGES[_index]) as BitmapResource;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        dc.setColor(COLOR, Graphics.COLOR_TRANSPARENT);
        dc.drawText((dc.getWidth() / 2), 5, Graphics.FONT_SMALL, PRIMATES[_index], Graphics.TEXT_JUSTIFY_CENTER);

        var bx = (dc.getWidth() / 2) - (_bitmap.getWidth() / 2);
        var by = (dc.getHeight() / 2) - (_bitmap.getHeight() / 2);

        dc.drawBitmap(bx, by, _bitmap);
    }

}

import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class ExtendedCodeSpaceMemoryView extends WatchUi.View {

    public function initialize() {
        View.initialize();
    }

    // Update the view
    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        extendedCodeSpaceTestFunction();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

        var text = new WatchUi.Text({:text => "Memory Used:\n" + System.getSystemStats().usedMemory + " B",
            :color => Graphics.COLOR_BLACK,
            :backgroundColor => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_SMALL,
            :justification => Graphics.TEXT_JUSTIFY_CENTER,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
        text.draw(dc);
    }

}

// The (:extendedCode) annotation specifically indicates that this code will be put in the extended code space.
// If the (:extendedCode) annotation is not specified, the code will be put in the traditional code space.

// To use the extended code space, comment out line 6 (base.excludeAnnotations = extendedCode)
// and make sure line 9 (base.excludeAnnotations = notExtendedCode) is uncommented in monkey.jungle
(:extendedCode)
function extendedCodeSpaceTestFunction() as Void {
    var arr = new [1000];
    for (var i = 0; i < arr.size(); i++) {
        arr[i] = i;
    }
}

// To not use the extended code space, comment out line 9 (base.excludeAnnotations = notExtendedCode)
// and make sure line 6 (base.excludeAnnotations = extendedCode) is uncommented in monkey.jungle
(:notExtendedCode)
function extendedCodeSpaceTestFunction() as Void {
    var arr = new [1000];
    for (var i = 0; i < arr.size(); i++) {
        arr[i] = i;
    }
}

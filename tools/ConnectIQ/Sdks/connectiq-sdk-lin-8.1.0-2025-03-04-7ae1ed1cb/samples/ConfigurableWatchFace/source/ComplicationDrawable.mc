import Toybox.Application;
import Toybox.Application.WatchFaceConfig;
import Toybox.Complications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Drawable that contains the complication text. This drawable is always drawn centered horizontally
//! on the screen. When the drawable is being configured by the watch face editor, the (x,y) location
//! must be the top left corner of the drawable.
class ComplicationDrawable extends WatchUi.Drawable {

    //! The text to display
    private var _text as String;
    //! The color of the text
    private var _color as Graphics.ColorType;
    //! The font to use for the text
    private var _font as Graphics.FontType;
    //! The y coordinate of the center of the drawable
    private var _centerY as Numeric;

    //! Constructor
    function initialize(options as {
                :text as String or ResourceId,
                :color as Graphics.ColorType,
                :backgroundColor as Graphics.ColorType,
                :font as Graphics.FontType,
                :justification as TextJustification or Number,
                :identifier as Object,
                :locX as Numeric,
                :locY as Numeric,
                :width as Numeric,
                :height as Numeric,
                :visible as Boolean
            }) {
        Drawable.initialize(options);

        _centerY = locY;

        var value = options[:color] as Graphics.ColorType?;
        if (value != null) {
            _color = value;
        } else {
            _color = Graphics.COLOR_WHITE;
        }

        value = options[:font] as Graphics.FontType?;
        if (value != null) {
            _font = value;
        } else {
            _font = Graphics.FONT_SMALL;
        }

        value = options[:text] as String?;
        if (value != null) {
            _text = value;
        } else {
            _text = "";
        }
    }

    //! Get the bounding box that encapsulates the drawable
    //! @return the bounding box for the drawable
    function getBoundingBox() as Graphics.BoundingBox {
        var boundingBox = new Graphics.BoundingBox();
        boundingBox.addRectangle(locX.toNumber(), locY.toNumber(), width.toNumber(), height.toNumber());
        return boundingBox;
    }

    //! Calculate the dimensions of the text
    //! @param dc The drawing context
    function calculateTextDimensions(dc as Dc) as Void {
        var dimensions = dc.getTextDimensions(_text, _font);

        // width is always the screen width
        width = dc.getWidth();
        height = dimensions[1];
        locX = 0;
        locY = _centerY - (height / 2);
    }

    //! Set the text color
    //! @param color The text color
    function setColor(color as Graphics.ColorType) as Void {
        _color = color;
    }

    //! Set the text to display
    //! @param text The complication text
    function setText(text as String) as Void {
        _text = text;
    }

    //! Draw the complication
    //! @param dc The drawing context
    function draw(dc as Dc) as Void {
        // Check to see if the drawable is visible or not. The view will set this
        // as not visible in its onUpdate() for the complication that is currently
        // being configured. This prevents the complication from being drawn on the
        // watch face while it is pulsing.
        if (!isVisible) {
            return;
        }

        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, locY, _font, _text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Check if the drawable contains the given point
    //! @param x The x coordinate
    //! @param y The y coordinate
    function containsPoint(x as Number, y as Number) as Boolean {
        var boundingBox = new Graphics.BoundingBox();
        boundingBox.addRectangle(locX.toNumber(), locY.toNumber(), width.toNumber(), height.toNumber());

        return boundingBox.includesPoint(x, y);
    }
}

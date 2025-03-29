import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! The view for the app
class NotificationsView extends WatchUi.View {

    private var _text as String = Application.loadResource(Rez.Strings.initialPrompt) as String;

    //! Constructor
    function initialize() {
        View.initialize();
    }

    //! Load the layout
    //! @param dc The drawing context
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.mainLayout(dc));
    }

    //! Update the view
    //! @param dc The drawing context
    function onUpdate(dc as Dc) as Void {
        var drawable = findDrawableById("text") as WatchUi.TextArea;
        drawable.setText(_text);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Set the text on the view
    //! @param text The text to display
    //! @param source If the text is from the background or foreground
    function setText(text as String, source as String) as Void {
        _text = Lang.format(Application.loadResource(Rez.Strings.promptFormat) as String, [text, source]);
    }
}

import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

class ToastsView extends WatchUi.View {

    hidden var mTickCounter as Number = 0;
    hidden var mTickCounterToast as Number = 5;
    hidden var mTimer as Timer.Timer or Null;

    hidden var mCenterX as Number = 0;
    hidden var mCenterY as Number = 0;
    hidden var mText as String = "...";
    hidden var mTextHeight as Number = 0;

    hidden var mMessages as Dictionary<Symbol, Symbol> = {} as Dictionary<Symbol, Symbol>;
    hidden var mLines as Array<String> = [];

    hidden const TEXT_FONT = Graphics.FONT_MEDIUM;
    hidden const TEXT_JUSTIFY = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    hidden const MIN_MESSAGE_DELAY_SEC = 3;
    hidden const MAX_MESSAGE_DELAY_SEC = 45;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Graphics.Dc) as Void {
        mTextHeight = Graphics.getFontHeight(TEXT_FONT);
        mCenterX = dc.getWidth() / 2;
        mCenterY = dc.getHeight() / 2;

        if (mMessages.size() == 0) {
            loadMessages([ :MaybeMessage0, :MaybeMessage1, :MaybeMessage2, :MaybeMessage3, :MaybeMessage4 ], :MaybeImage, mMessages);
            loadMessages([ :MaybeMessage5, :MaybeMessage6, :MaybeMessage7, :MaybeMessage8, :MaybeMessage9 ], :MaybeImage, mMessages);
            loadMessages([   :YesMessage0,   :YesMessage1,   :YesMessage2,   :YesMessage3,   :YesMessage4 ],   :YesImage, mMessages);
            loadMessages([   :YesMessage5,   :YesMessage6,   :YesMessage7,   :YesMessage8,   :YesMessage9 ],   :YesImage, mMessages);
            loadMessages([    :NoMessage0,    :NoMessage1,    :NoMessage2,    :NoMessage3,    :NoMessage4 ],    :NoImage, mMessages);
            loadMessages([    :NoMessage5,    :NoMessage6,    :NoMessage7,    :NoMessage8,    :NoMessage9 ],    :NoImage, mMessages);
        }

        if (mLines.size() == 0) {
            loadLines([ :PromptLine0, :PromptLine1, :PromptLine2, :PromptLine3, :PromptLine4 ], mLines);
        }
    }

    function onShow() as Void {
        if (mTimer == null) {
            mTimer = new Timer.Timer();
            mTimer.start(self.method(:onTimer), 1000, true);
        }
    }

    function onHide() as Void {
        if (mTimer != null) {
            mTimer.stop();
            mTimer = null;
        }
    }

    function onTimer() as Void {
        var text = "";
        for (var i = 0; i < mTickCounter %5; ++i) {
            text += ".";
        }

        mText = text;
        mTickCounter = mTickCounter + 1;

        if (mTickCounter == mTickCounterToast) {
            // pick a random message to display
            var index = Math.rand() % mMessages.size();

            var text_symbols = mMessages.keys();

            var text_symbol = text_symbols[index] as Symbol;
            var icon_symbol = mMessages[text_symbol] as Symbol;

            var title = getStringResourceId(text_symbol);
            var icon  = getBitmapResourceId(icon_symbol);

            WatchUi.showToast(title, { :icon => icon });

            mTickCounter = 0;
            mTickCounterToast = MIN_MESSAGE_DELAY_SEC + Math.rand() % (MAX_MESSAGE_DELAY_SEC - MIN_MESSAGE_DELAY_SEC);
        }

        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_RED);
        dc.clear();

        var lines = [] as Array<String>;
        lines.addAll(mLines);
        lines.add(mText);

        var cy = mCenterY - ((lines.size() / 2) * mTextHeight);

        for (var i = 0; i < lines.size(); ++i) {
            dc.drawText(mCenterX, cy, TEXT_FONT, lines[i], TEXT_JUSTIFY);
            cy += mTextHeight;
        }
    }

    (:typecheck(false))
    private function getStringResourceId(symbol as Symbol) as ResourceId {
        return Rez.Strings[symbol] as ResourceId;
    }

    (:typecheck(false))
    private function getBitmapResourceId(symbol as Symbol) as ResourceId {
        return Rez.Drawables[symbol] as ResourceId;
    }

    private function loadMessages(symbols as Array<Symbol>, image as Symbol, dict as Dictionary<Symbol, Symbol>) as Void {
        for (var i = 0; i < symbols.size(); ++i) {
            if (Rez.Strings has symbols[i]) {
                dict.put(symbols[i], image);
            }
        }
    }

    private function loadLines(symbols as Array<Symbol>, array as Array<String>) as Void {
        for (var i = 0; i < symbols.size(); ++i) {
            if (Rez.Strings has symbols[i]) {
                var text_id = getStringResourceId(symbols[i]);
                array.add(WatchUi.loadResource(text_id) as String);
            }
        }
    }
}

//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

class GenericChannelBurstView extends WatchUi.View {

    private var _channelManager as BurstChannelManager;
    private var _rxFailCountLabel as Text?;
    private var _rxSuccessCountLabel as Text?;
    private var _txFailCountLabel as Text?;
    private var _txSuccessCountLabel as Text?;

    //! Constructor.
    //! @param aChannelManager The channel manager in use
    public function initialize(aChannelManager as BurstChannelManager) {
        View.initialize();
        _channelManager = aChannelManager;
    }

    //! Loads resources
    //! @param dc Device Context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.MainLayout(dc));

        _rxFailCountLabel = WatchUi.View.findDrawableById("rxFail") as Text;
        _rxSuccessCountLabel = WatchUi.View.findDrawableById("rxSuccess") as Text;
        _txFailCountLabel = WatchUi.View.findDrawableById("txFail") as Text;
        _txSuccessCountLabel = WatchUi.View.findDrawableById("txSuccess") as Text;

        WatchUi.requestUpdate();
    }

    //! Updates the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // Print the burst statistics
        var burstStatistics = _channelManager.getBurstStatistics();

        if (_rxFailCountLabel != null) {
            _rxFailCountLabel.setText(burstStatistics.getRxFailCount().toString());
        }

        if (_rxSuccessCountLabel != null) {
            _rxSuccessCountLabel.setText(burstStatistics.getRxSuccessCount().toString());
        }

        if (_txFailCountLabel != null) {
            _txFailCountLabel.setText(burstStatistics.getTxFailCount().toString());
        }

        if (_txSuccessCountLabel != null) {
            _txSuccessCountLabel.setText(burstStatistics.getTxSuccessCount().toString());
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

}

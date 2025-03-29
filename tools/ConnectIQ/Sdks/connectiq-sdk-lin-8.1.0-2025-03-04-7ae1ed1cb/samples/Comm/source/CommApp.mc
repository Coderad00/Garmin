//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! This app demonstrates communication between a
//! device and Garmin Connect Mobile (Android and iOS).
//! Note: Communications.setMailboxListener method has been
//! deprecated in ConnectIQ 4.0.0 and replaced by the
//! Communications.registerForPhoneAppMessages method.
class CommExample extends Application.AppBase {
    private var _phoneMethod as Method(msg as PhoneAppMessage) as Void;
    private var _crashOnMessage as Boolean = false;
    private var _view as CommView;

    private const _strings = ["","","","",""];

    //! Constructor
    public function initialize() {
        AppBase.initialize();

        _phoneMethod = method(:onPhone);
        if (Communications has :registerForPhoneAppMessages) {
            Communications.registerForPhoneAppMessages(_phoneMethod);
        }

        _view = new $.CommView();
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
    //! @return Array Pair [View, Delegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return [_view, new $.CommInputDelegate(_view)];
    }

    //! Handle a new phone app message
    //! @param msg The message
    public function onPhone(msg as PhoneAppMessage) as Void {
        var data = msg.data;
        if ((_crashOnMessage == true) && (data != null)) {
            if (data.equals("Hi")) {
                System.error("crash on message");
            }
        }

        if (data != null) {
            for (var i = (_strings.size() - 1); i > 0; i--) {
                _strings[i] = _strings[i-1];
            }
            _strings[0] = data.toString();
        }
        _view.changePage($.PAGE_MESSAGES);

        WatchUi.requestUpdate();
    }

    //! Get the callback method for phone app messages
    //! @return The phone app messages callback method
    public function getPhoneMethod() as Method(msg as PhoneAppMessage) as Void {
        return _phoneMethod;
    }

    //! Get the array of messages
    //! @return The last 5 messages
    public function getStrings() as Array<String> {
        return _strings;
    }

    //! Set the app to crash on the next phone message
    public function crashOnMessage() as Void {
        _crashOnMessage = true;
    }
}
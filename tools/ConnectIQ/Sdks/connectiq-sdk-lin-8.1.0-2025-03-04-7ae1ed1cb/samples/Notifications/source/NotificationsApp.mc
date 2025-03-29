import Constants;
import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Notifications;
import Toybox.Background;
import Toybox.System;

//! This app demonstrates how to use the Notifications API to show notifications to the user.
class NotificationsApp extends Application.AppBase {

    (:initialized) // without this the compiler will throw an error because the variable is not initialized, but it is initialized in the getInitialView function and only used in the foreground
    private var _view as NotificationsView;

    //! Constructor
    function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    function onStart(state as Dictionary?) as Void {
        Background.registerForTemporalEvent(new Toybox.Time.Duration(30000));
    }

    //! Return the service delegate for the app
    //! @return Array [BackgroundDelegate]
    function getServiceDelegate() as [$.Toybox.System.ServiceDelegate] {
        return [new BackgroundDelegate()];
    }

    //! Return the initial view for the app
    //! @return Array [NotificationsView, NotificationDelegate]
    (:typecheck(disableBackgroundCheck)) // this function isn't called in the background so let the compiler know to prevent errors in strict typechcking
    function getInitialView() as [Views] or [Views, InputDelegates] {
        // Since this function is called only when running in the foreground, register for notifications here
        _view = new NotificationsView();
        Notifications.registerForNotificationMessages(method(:onNotification));
        return [ _view, new NotificationsDelegate() ];
    }

    //! Handle notification messages
    //! @param message Notification message to handle after a notification is displayed
    (:typecheck(disableBackgroundCheck)) // this function isn't called in the background so let the compiler know to prevent errors in strict typechcking
    function onNotification(message as Notifications.NotificationMessage) as Void {
        var text = Rez.Strings.notificationError;
        switch(message.type) {
            case Notifications.NOTIFICATION_MESSAGE_TYPE_SELECTED:
                switch(message.action as Number) {
                    case NotificationOptions.OPTION_1:
                        text = Rez.Strings.notificationOption1Selected;
                        break;
                    case NotificationOptions.OPTION_2:
                        text = Rez.Strings.notificationOption2Selected;
                        break;
                    case NotificationOptions.OPTION_3:
                        text = Rez.Strings.notificationOption3Selected;
                        break;
                    case NotificationOptions.OPTION_4:
                        text = Rez.Strings.notificationOption4Selected;
                        break;
                }
                break;

            case Notifications.NOTIFICATION_MESSAGE_TYPE_DISMISSED:
                text = Rez.Strings.notificationOptionDismissed;
                break;
        }

        var source = (message.data as Dictionary)[DataKeys.SOURCE] as String;
        _view.setText(Application.loadResource(text) as String, source);

        WatchUi.requestUpdate();
    }

}

//! Get the app instance
//! @return the app as a NotificationsApp
function getApp() as NotificationsApp {
    return Application.getApp() as NotificationsApp;
}
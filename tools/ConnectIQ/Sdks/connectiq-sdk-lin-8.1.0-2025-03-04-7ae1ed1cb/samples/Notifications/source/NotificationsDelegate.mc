import Constants;
import Toybox.Lang;
import Toybox.Notifications;
import Toybox.WatchUi;

//! The input delegate for the app
class NotificationsDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Display the notification on the select behavior
    //! @return true if the behavior was handled
    function onSelect() as Boolean {
        var options = {
            :icon => Rez.Drawables.foregroundIcon,
            :body => Rez.Strings.foregroundBody,
            :data => { DataKeys.SOURCE => Application.loadResource(Rez.Strings.foregroundSource) } as Dictionary<Number, String>,
            :actions => [
                { :label => Application.loadResource(Rez.Strings.notificationOption1), :data => NotificationOptions.OPTION_1 },
                { :label => Application.loadResource(Rez.Strings.notificationOption2), :data => NotificationOptions.OPTION_2 },
                { :label => Application.loadResource(Rez.Strings.notificationOption3), :data => NotificationOptions.OPTION_3 },
                { :label => Application.loadResource(Rez.Strings.notificationOption4), :data => NotificationOptions.OPTION_4 }
            ] as Array<Notifications.Action>
        };

        Notifications.showNotification(Rez.Strings.foregroundTitle, Rez.Strings.foregroundSubtitle, options);

        return true;
    }

}
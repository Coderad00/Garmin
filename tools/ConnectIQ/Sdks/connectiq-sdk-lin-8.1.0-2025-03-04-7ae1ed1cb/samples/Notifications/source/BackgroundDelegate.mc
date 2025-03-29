import Constants;
import Toybox.Lang;
import Toybox.Notifications;
import Toybox.System;

//! The background delegate to display a notification from the background
(:background)
class BackgroundDelegate extends System.ServiceDelegate {

    //! Constructor
    function initialize() {
        ServiceDelegate.initialize();
    }

    //! Display a notification from the background
    function onTemporalEvent() as Void {
        // by not providing :icon, the app's launcher icon will be used
        var options = {
            :body => Rez.Strings.backgroundBody,
            :data => { DataKeys.SOURCE => Application.loadResource(Rez.Strings.backgroundSource) } as Dictionary<Number, String>,
            :actions => [
                { :label => Application.loadResource(Rez.Strings.notificationOption1), :data => NotificationOptions.OPTION_1 },
                { :label => Application.loadResource(Rez.Strings.notificationOption2), :data => NotificationOptions.OPTION_2 },
                { :label => Application.loadResource(Rez.Strings.notificationOption3), :data => NotificationOptions.OPTION_3 },
                { :label => Application.loadResource(Rez.Strings.notificationOption4), :data => NotificationOptions.OPTION_4 }
            ] as Array<Notifications.Action>
        };

        Notifications.showNotification(Rez.Strings.backgroundTitle, Rez.Strings.backgroundSubtitle, options);
    }
}

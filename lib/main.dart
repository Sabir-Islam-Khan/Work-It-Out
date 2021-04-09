import './Services/Auth.dart';
import './Services/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(WorkItOut());
}

// this part is self explainatory
//
//
class WorkItOut extends StatelessWidget {
  Future<void> oneSignal() async {
    print("ONESIGNAL STARTED");
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("03f3837b-8e0f-4ff8-b7ae-c42723dad8d1", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  @override
  Widget build(BuildContext context) {
    oneSignal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // goes to landing page.. then user token decides which page to show
        body: LandingPage(
          auth: Auth(),
        ),
      ),
    );
  }
}

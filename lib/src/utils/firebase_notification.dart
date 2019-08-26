import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  static final FirebaseMessaging _fcm = FirebaseMessaging();

  static setupNotification() async {
    if (Platform.isIOS) {
      getIosPermission();
    }
    String token = await _fcm.getToken();
    print('Firebase Notification Token :: $token');
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static getIosPermission() {
    _fcm.requestNotificationPermissions(
      IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

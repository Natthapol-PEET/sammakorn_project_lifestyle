import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registerapp_flutter/data/auth.dart';

class FCM {
  Auth auth = Auth();

  initFirebaseMessaging() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // print('User granted permission: ${settings.authorizationStatus}');
    String token = await messaging.getToken();
    print(token);
    auth.updateDeviceToken(token);

    return messaging;
  }
}

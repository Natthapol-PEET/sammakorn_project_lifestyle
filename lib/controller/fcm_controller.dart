import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FcmController extends GetxController {
  String? fcmToken;

  @override
  void onInit() {
    initFirebaseMessaging();
    super.onInit();
  }

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
    fcmToken = await messaging.getToken();
    // print(token);

    return messaging;
  }
}

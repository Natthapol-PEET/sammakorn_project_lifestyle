import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    initFirebaseMessaging();
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

    print('User granted permission: ${settings.authorizationStatus}');

    // use the returned token to send messages to users from your custom server
    String token = await messaging.getToken(
        // vapidKey: "BGpdLRs......",
        );

    print('token: ${token}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      print('title: ${message.notification.title}');
      print('body: ${message.notification.body}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // messaging.subscribeToTopic("NEWS");
    // messaging.unsubscribeFromTopic("NEWS");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

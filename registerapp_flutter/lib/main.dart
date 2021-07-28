import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/add_licente_plate_screen.dart';
import 'package:registerapp_flutter/screens/Demo/noti_local.dart';
import 'package:registerapp_flutter/screens/Demo/websocket.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import 'package:registerapp_flutter/screens/List_Item_All/list_item_screen.dart';
import 'package:registerapp_flutter/screens/Login/login_screen.dart';
import 'package:registerapp_flutter/screens/Logout/logout_screen.dart';
import 'package:registerapp_flutter/screens/Notification/notification_screen.dart';
import 'package:registerapp_flutter/screens/Password/password_screen.dart';
import 'package:registerapp_flutter/screens/Register/register_screen.dart';
import 'package:registerapp_flutter/screens/Select_Home/select_home_screen.dart';
import 'package:registerapp_flutter/screens/ShowDetailScreen/show_detail.dart';
import 'package:registerapp_flutter/screens/Welcome/welcome_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registerapp_flutter/service/fcm.dart';
import 'package:registerapp_flutter/service/push_notification.dart';

import 'data/notification.dart';

NotificationDB notifications = NotificationDB();

PushNotification pushNotification = PushNotification();
FirebaseMessaging messaging;
FCM fcm = FCM();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background title: ${message.notification.title}");
  print("Handling a background body: ${message.notification.body}");
  print('Message data: ${message.data}');

  notifications.insertNotification(
      message.data['Class'],
      message.notification.title,
      message.notification.body,
      message.data['home_id']);
}

// Forgroud
initFirebaseMessaging(message) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      pushNotification.sendNotification(
          message.notification.title, message.notification.body);

      print('Message title: ${message.notification.title}');
      print('Message body: ${message.notification.body}');
      print('Message data: ${message.data}');

      notifications.insertNotification(
          message.data['Class'],
          message.notification.title,
          message.notification.body,
          message.data['home_id']);
    }
  });
}

void main() async {
  // Backgroud
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Forgroud
  messaging = await fcm.initFirebaseMessaging();
  initFirebaseMessaging(messaging);
  pushNotification.initializationNotificationSettings();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: WelcomeScreen(),
      // home: WebSocketScreen(),
      // home: NotificationScreen(),
      // home: NotificationLocal(),

      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/select_home': (context) => SelectHomeScreen(),
        '/home': (context) => HomeScreen(),
        '/show_detail': (context) => ShowDetailScreen(),
        '/notification': (context) => NotificationScreen(),
        '/listItem': (context) => ListItemScreen(),
        '/addLicenseplate': (context) => AddLicensePlateScreen(),
        '/logout': (context) => LogoutScreen(),
        '/changePassword': (context) => PasswordScreen(),
      },
    );
  }
}

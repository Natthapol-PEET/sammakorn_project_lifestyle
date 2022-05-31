import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:registerapp_flutter/controller/fcm_controller.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/add_licente_plate_screen.dart';
import 'package:registerapp_flutter/screens/ForgetPasswordScreen/forget_password_screen.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import 'package:registerapp_flutter/screens/Login/login_screen.dart';
import 'package:registerapp_flutter/screens/Logout/logout_screen.dart';
import 'package:registerapp_flutter/screens/Notification/notification_screen.dart';
import 'package:registerapp_flutter/screens/Password/password_screen.dart';
import 'package:registerapp_flutter/screens/Select_Home/select_home_screen.dart';
import 'package:registerapp_flutter/screens/Welcome/welcome_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registerapp_flutter/service/push_notification.dart';
import 'controller/notification_controller.dart';
import 'data/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

NotificationDB notifications = NotificationDB();
PushNotification pushNotification = PushNotification();
FirebaseMessaging messaging;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background title: ${message.notification.title}");
  // print("Handling a background body: ${message.notification.body}");
  // print('Message data: ${message.data}');

  notifications.insertNotification(
      message.data['Class'],
      message.notification.title,
      message.notification.body,
      message.data['home_id']);
}

// Forgroud
initFirebaseMessaging(message) async {
  final homeController = Get.put(HomeController());
  final notificationController = Get.put(NotificationController());

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      pushNotification.sendNotification(
          message.notification.title, message.notification.body);

      notifications.insertNotification(
          message.data['Class'],
          message.notification.title,
          message.notification.body,
          message.data['home_id']);

      homeController.getCountAlert();
      notificationController.getNotification();
    }
  });
}

void main() async {
  // Backgroud
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Forgroud
  final fcmController = Get.put(FcmController());
  messaging = await fcmController.initFirebaseMessaging();
  initFirebaseMessaging(messaging);
  pushNotification.initializationNotificationSettings();

  // show datetime thai
  Intl.defaultLocale = "th";
  initializeDateFormatting('th_TH');

  // set location time ago
  timeago.setLocaleMessages('th', timeago.ThMessages());

  final fifteenAgo = DateTime.now().subtract(Duration(minutes: 15));
  print(timeago.format(fifteenAgo, locale: 'th'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/forgot_password': (context) => ForgetPasswordScreen(),
        // '/register': (context) => RegisterScreen(),
        '/select_home': (context) => SelectHomeScreen(),
        '/home': (context) => HomeScreen(),
        // '/show_detail': (context) => ShowDetailScreen(),
        '/notification': (context) => NotificationScreen(),
        // '/listItem': (context) => ListItemScreen(),
        '/addLicenseplate': (context) => AddLicensePlateScreen(),
        '/logout': (context) => LogoutScreen(),
        '/changePassword': (context) => PasswordScreen(),

        // Not call
        // '/show_qrcode': (context) => ShowQrcodeScreen(data: "init qr code"),
        // '/show_qrcode': (context) => ShowQrcodeScreen(),
      },
    );
  }
}

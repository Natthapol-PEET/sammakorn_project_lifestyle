import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:registerapp_flutter/controller/fcm_controller.dart';
import 'package:registerapp_flutter/models/notification_model.dart';
import 'package:registerapp_flutter/screens/AddVisitor/add_visitor.dart';
import 'package:registerapp_flutter/screens/ForgetPasswordScreen/forget_password_screen.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import 'package:registerapp_flutter/screens/Login/login_screen.dart';
import 'package:registerapp_flutter/screens/Logout/logout_screen.dart';
import 'package:registerapp_flutter/screens/Notification/notification_screen.dart';
import 'package:registerapp_flutter/screens/Password/password_screen.dart';
import 'package:registerapp_flutter/screens/SelectHome/select_home_screen.dart';
import 'package:registerapp_flutter/screens/Welcome/welcome_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registerapp_flutter/service/push_notification.dart';
import 'controller/notification_controller.dart';

final notificationController = Get.put(NotificationController());
PushNotification pushNotification = PushNotification();
FirebaseMessaging? messaging;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background title: ${message.notification.title}");
  // print("Handling a background body: ${message.notification.body}");
  // print('Message data: ${message.data}');

  notificationController.notification.insertNotification(
    NotificationModel(
      classs: message.data['Class'] as String,
      homeId: int.parse(message.data['home_id']),
      title: message.notification!.title as String,
      description: message.notification!.body as String,
      datetime: DateTime.now().toString(),
      isRead: false,
    ),
  );

  notificationController.getNotification();
}

// Forgroud
initFirebaseMessaging(message) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    if (message!.notification != null) {
      pushNotification.sendNotification(message.notification!.title as String,
          message.notification!.body as String);

      notificationController.notification.insertNotification(
        NotificationModel(
          classs: message.data['Class'] as String,
          homeId: int.parse(message.data['home_id']),
          title: message.notification!.title as String,
          description: message.notification!.body as String,
          datetime: DateTime.now().toString(),
          isRead: false,
        ),
      );

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VMS Resident App',
      builder: EasyLoading.init(),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/forgotPassword': (context) => ForgetPasswordScreen(),
        // '/register': (context) => RegisterScreen(),
        '/selectHome': (context) => SelectHomeScreen(),
        '/home': (context) => HomeScreen(),
        '/notification': (context) => NotificationScreen(),
        // '/listItem': (context) => ListItemScreen(),
        '/addVisitor': (context) => AddVisitorScreen(),
        '/logout': (context) => LogoutScreen(),
        '/changePassword': (context) => PasswordScreen(),

        // Not call
        // '/showQrcode': (context) => ShowQrcodeScreen(data: "init qr code"),
        // '/showQrcode': (context) => ShowQrcodeScreen(),
      },
    );
  }
}

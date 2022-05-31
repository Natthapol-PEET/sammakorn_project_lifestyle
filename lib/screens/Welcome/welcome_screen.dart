import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/account_controller.dart';
import 'package:registerapp_flutter/controller/welcome_controller.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import 'components/body.dart';
import 'is_loading.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final accountController = Get.put(AccountController());
  final welcomeController = Get.put(WelcomeController());

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  initAsync() async {
    await accountController.account.getDatabase();
    await accountController.account.initAccount();
    welcomeController.checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Obx(() => Scaffold(
            body: welcomeController.isLoad.value
                ? IsLoadding(isLogin: true)
                : welcomeController.isLogin.value
                    ? HomeScreen()
                    : Body(), // welcome page
          )),
    );
  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }

    Fluttertoast.showToast(msg: "Close Application");
    SystemNavigator.pop();
    return Future.value(true);
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_dialog.dart';
import 'package:registerapp_flutter/controller/account_controller.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/service/socket_service.dart';
import 'package:registerapp_flutter/models/account_model.dart';
import 'package:registerapp_flutter/screens/Notification/components/button_dialog.dart';
import '../../../constance.dart';
import '../../../service/logout.dart';

// ignore: must_be_immutable
class LogoutButton extends StatelessWidget {
  LogoutButton({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginController());
  final accountController = Get.put(AccountController());
  final selectHomeController = Get.put(SelectHomeController());

  SocketService socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: GestureDetector(
        onTap: () => dialogLogout(
          context,
          "ยืนยันการออกจากระบบ?",
          () => _logout(context),
        ),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.08,
          decoration: BoxDecoration(
            color: backgrounditem,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "ออกจากระบบ",
              style: TextStyle(
                color: goldenSecondary,
                // color: Color(0xFFCA0000),
                fontSize: 18,
                fontFamily: "Prompt",
              ),
            ),
          ),
        ),
      ),
    );
  }

  _logout(context) async {
    showLoadingDialog();

    await logoutApi(loginController.dataLogin!.authToken as String,
        loginController.dataLogin!.residentId.toString());

    accountController.account.updateAccount(AccountModel(
      id: 1,
      username: loginController.username.value.text,
      password: loginController.password.value.text,
      isLogin: 0,
      isRemember: loginController.rememberCheckbox.value ? 1 : 0,
    ));

    // init socket
    socketService.stopSocketClient(selectHomeController.homeId.value);

    EasyLoading.dismiss();
    Get.offAllNamed('/', arguments: "logout");
  }

  Future<dynamic> dialogLogout(
      BuildContext context, String text, Function()? press) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgDialog,
          title: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: dividerColor, fontFamily: 'Prompt'),
            ),
          ),
          actions: [
            ButtonDialoog(
              text: "ยกเลิก",
              setBackgroudColor: false,
              press: () => Get.back(),
            ),
            ButtonDialoog(
              text: "ยืนยัน",
              setBackgroudColor: true,
              press: press,
            ),
          ],
        );
      },
    );
  }
}

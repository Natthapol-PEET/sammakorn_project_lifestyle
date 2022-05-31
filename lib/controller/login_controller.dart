import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/account_controller.dart';
import 'package:registerapp_flutter/controller/fcm_controller.dart';
import 'package:registerapp_flutter/models/account_model.dart';
import 'package:registerapp_flutter/models/login_model.dart';
import 'package:registerapp_flutter/screens/Login/service/login.dart';
import 'package:registerapp_flutter/service/device_id.dart';
import 'dart:convert';

class LoginController extends GetxController {
  final fcmController = Get.put(FcmController());
  final accountController = Get.put(AccountController());

  Device device = Device();

  LoginModel dataLogin;

  var rememberCheckbox = false.obs;
  var hidePassword = true.obs;
  var disLoginBtn = true.obs;
  var isLogin = 0.obs;

  var username = TextEditingController().obs;
  var password = TextEditingController().obs;

  getUsernamePassword() async {
    List<AccountModel> data = await accountController.account.accounts();

    isLogin.value = data[0].isLogin;
    if (data[0].username == '') return;

    username.value = TextEditingController(text: data[0].username);
    password.value = TextEditingController(text: data[0].password);
    rememberCheckbox(true);
    disLoginBtn(false);
  }

  login() async {
    if (username.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "กรุณากรอกชื่อผู้ใช้หรืออีเมล",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (password.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "กรุณากรอกรหัสผ่าน",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    bool status = await callLoginApi(username.value.text, password.value.text);

    if (status) {
      if (rememberCheckbox.value) {
        accountController.account.updateAccount(AccountModel(
            id: 1,
            username: username.value.text,
            password: password.value.text,
            isLogin: 1));
      }
      Get.toNamed('/select_home');
    }
  }

  callLoginApi(String user, String passwd) async {
    // init user and password => textformfield
    username.value = TextEditingController(text: user);
    password.value = TextEditingController(text: passwd);

    String deviceId = await device.getId();
    var response =
        await loginApi(user, passwd, deviceId, fcmController.fcmToken);
    var body = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      dataLogin = LoginModel.formJson(body);

      return true;
    } else {
      Fluttertoast.showToast(
        msg: body["detail"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  @override
  void onClose() {
    username.value.dispose();
    password.value.dispose();

    super.onClose();
  }
}

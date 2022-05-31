import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_text_check_input.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/change_password_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/reset_password.dart';
import '../../../constance.dart';
import 'button_group.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final changeController = Get.put(ChangePasswordController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    changeController.checkOldPassword.value = false;
    changeController.checkPassword.value = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          RoundInputField(title: "รหัสผ่านเดิม"),
          Obx(() => !changeController.checkOldPassword.value
              ? ShowTextCheckInput(text: 'กรุณากรอกรหัสผ่านเดิม')
              : Container()),
          RoundInputField(title: "รหัสผ่านใหม่"),
          RoundInputField(title: "ยืนยันรหัสผ่านใหม่"),
          Obx(() => !changeController.checkPassword.value
              ? ShowTextCheckInput(text: 'รหัสผ่านไม่ตรง')
              : ShowTextCheckInput(
                  text: 'รหัสผ่านตรงกัน', color: Colors.green)),
          SizedBox(height: size.height * 0.35),
          Obx(
            () => ButtonGroup(
              press: changeController.lock.value
                  ? null
                  : () async {
                      Fluttertoast.showToast(
                        msg: "กรุณารอสักครู่ ...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );

                      var response = await changePasswordApi(
                          loginController.dataLogin.authToken,
                          changeController.oldPassword.value,
                          changeController.newPassword.value,
                          loginController.dataLogin.residentId.toString());

                      if (response == true) {
                        success_dialog(context, "เปลี่ยนรหัสผ่านสำเร็จ");
                        Timer(Duration(seconds: 3), () => Get.toNamed('/home'));
                      } else {
                        Fluttertoast.showToast(
                          msg: response,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
            ),
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }
}

class RoundInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final changeController = Get.put(ChangePasswordController());

  RoundInputField({
    Key key,
    @required this.title,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.03),
          Padding(
            // padding: const EdgeInsets.only(top: 5, bottom: 10, left: 30),
            padding: const EdgeInsets.only(left: 40, bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                // color: goldenSecondary,
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Prompt',
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.06,
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: TextField(
                controller: controller,
                onChanged: (v) {
                  if (title == "รหัสผ่านเดิม") {
                    changeController.oldPassword.value = v;
                  } else if (title == "รหัสผ่านใหม่") {
                    changeController.newPassword.value = v;
                  } else if (title == "ยืนยันรหัสผ่านใหม่") {
                    changeController.confirmPassword.value = v;
                  }

                  changeController.onCheck();
                },
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Prompt',
                ),
                cursorColor: goldenSecondary,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 5, right: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_dialog.dart';
import 'package:registerapp_flutter/components/show_text_check_input.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/change_password_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/service/change_and_reset_password.dart';
import '../../../constance.dart';
import 'button_group.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final loginController = Get.put(LoginController());
  final changeController = Get.put(ChangePasswordController());

  @override
  void initState() {
    changeController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          RoundInputField(title: "รหัสผ่านเดิม"),
          Obx(() => changeController.oldPassword.value == ""
              ? ShowTextCheckInput(text: 'กรุณากรอกรหัสผ่านเดิม')
              : Container()),
          RoundInputField(title: "รหัสผ่านใหม่"),
          RoundInputField(title: "ยืนยันรหัสผ่านใหม่"),
          Obx(() => changeController.newPassword.value == ""
              ? Container()
              : changeController.newPassword.value !=
                      changeController.confirmPassword.value
                  ? ShowTextCheckInput(text: 'รหัสผ่านไม่ตรง')
                  : ShowTextCheckInput(
                      text: 'รหัสผ่านตรงกัน', color: Colors.green)),
          SizedBox(height: size.height * 0.3),
          Obx(
            () => ButtonGroup(
              press: changeController.oldPassword.value != "" &&
                      (changeController.newPassword.value ==
                          changeController.confirmPassword.value)
                  ? () async {
                      showLoadingDialog();

                      var response = await changePasswordApi(
                          loginController.dataLogin!.authToken as String,
                          changeController.oldPassword.value,
                          changeController.newPassword.value,
                          loginController.dataLogin!.residentId.toString());

                      if (response == true) {
                        successDialog(context, "เปลี่ยนรหัสผ่านสำเร็จ");
                        Timer(Duration(seconds: 3), () => Get.toNamed('/home'));
                      } else {
                        EasyLoading.showError(response);
                      }
                    }
                  : null,
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
  final TextEditingController? controller;
  final changeController = Get.put(ChangePasswordController());

  RoundInputField({
    Key? key,
    required this.title,
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
            padding: const EdgeInsets.only(left: 40, bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Prompt',
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

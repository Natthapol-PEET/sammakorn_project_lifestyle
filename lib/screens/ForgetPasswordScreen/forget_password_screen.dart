import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/components/rounded_input_field.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/screens/Login/components/backgroud.dart';
import 'package:registerapp_flutter/screens/Login/components/backicon.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/reset_password.dart';
import '../../constance.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final loginController = Get.put(LoginController());

  final email = TextEditingController(text: '@gmail.com');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Backgroud(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              BackIcon(),
              SizedBox(height: size.height * 0.07),
              ForgetTitle(),
              SizedBox(height: size.height * 0.025),
              cardFormInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardFormInput() {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: size.width,
        height: size.height * 0.85,
        decoration: BoxDecoration(
          color: greenPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              DetailText(),
              SizedBox(height: size.height * 0.05),
              RoundedInputField(
                hintText: "อีเมล",
                controller: email,
              ),
              SizedBox(height: size.height * 0.3),
              RoundedButton(
                text: "ส่ง",
                press: () async {
                  // print("Email >> ${email.text}");

                  Fluttertoast.showToast(
                    msg: "กรุณารอสักครู่ ...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );

                  var response = await resetPasswordApi(
                      loginController.dataLogin.authToken, email.text);

                  if (response == true) {
                    success_dialog(context, "ส่งรหัสผ่านใหม่ไปยังอีเมลสำเร็จ");
                    Timer(Duration(seconds: 3), () => Get.toNamed('/'));
                  } else {
                    Fluttertoast.showToast(
                      msg: response,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}

class ForgetTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        'ลืมรหัสผ่าน',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w500,
          fontFamily: "Prompt",
        ),
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        'กรุณากรอกอีเมลของคุณ เราจะทำการตรวจสอบและส่งรหัสผ่านใหม่ไปยังอีเมลของคุณเพื่อยืนยันตัวตน',
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFFB8B7B2),
          // fontWeight: FontWeight.w500,
          fontFamily: "Prompt",
        ),
      ),
    );
  }
}

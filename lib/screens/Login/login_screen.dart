import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/components/rounded_input_field.dart';
import 'package:registerapp_flutter/components/rounded_password_field.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import '../../constance.dart';
import 'components/backgroud.dart';
import 'components/backicon.dart';
import 'components/hello_there.dart';
import 'components/loginTitle.dart';
import 'components/remember_forgot.dart';
import 'components/welcome_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

  void initState() {
    loginController.getUsernamePassword();
    super.initState();
  }

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
              LoginTitle(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            WelcomeText(),
            HelloThere(),
            SizedBox(height: size.height * 0.05),
            Obx(() => RoundedInputField(
                  hintText: "ชื่อผู้ใช้หรืออีเมล",
                  controller: loginController.username.value,
                  onChanged: (v) {
                    if (v != '' && loginController.password.value.text != '') {
                      loginController.disLoginBtn(false);
                    } else {
                      loginController.disLoginBtn(true);
                    }
                  },
                )),
            SizedBox(height: size.height * 0.03),
            Obx(() => RoundedPasswordField(
                  textHiht: "รหัสผ่าน",
                  controller: loginController.password.value,
                  press: () => loginController.hidePassword.value =
                      !loginController.hidePassword.value,
                  hidePassword: loginController.hidePassword.value,
                  onChanged: (v) {
                    if (v != '' && loginController.username.value.text != '') {
                      loginController.disLoginBtn(false);
                    } else {
                      loginController.disLoginBtn(true);
                    }
                  },
                )),
            Obx(() => RememberForgot(
                  rememberCheckbox: loginController.rememberCheckbox.value,
                  rememberPress: (v) => loginController.rememberCheckbox(v),
                )),
            SizedBox(height: size.height * 0.05),
            Obx(() => RoundedButton(
                  text: "เข้าสู่ระบบ",
                  press: loginController.disLoginBtn.value
                      ? null
                      : () => loginController.login(),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'backgroud.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Backgroud(
      isLogin: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            RoundedButton(
              text: "เข้าสู่ระบบ",
              press: () {
                Get.toNamed('/login');

                final loginController = Get.put(LoginController());
                loginController.clear();
              },
              topSize: 30,
            ),
            // RoundedButton(
            //   text: "Register",
            //   press: () {
            //     Get.toNamed('/register');
            //   },
            //   topSize: 15,
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

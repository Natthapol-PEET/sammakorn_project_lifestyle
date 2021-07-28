import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/components/rounded_input_field.dart';
import 'package:registerapp_flutter/components/rounded_password_field.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Login/service/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:registerapp_flutter/service/fcm.dart';
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
  final username = TextEditingController(text: "peet");
  final password = TextEditingController(text: "10042541");

  Auth auth = Auth();
  Home home = Home();
  FCM fcm = FCM();

  Services services = Services();

  void initState() {
    super.initState();

    fcm.initFirebaseMessaging();
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
              CardFormInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget CardFormInput() {
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
            SizedBox(height: size.height * 0.01),
            RoundedInputField(
              hintText: "Username",
              controller: username,
            ),
            RoundedPasswordField(
              textHiht: "Password",
              controller: password,
            ),
            RememberForgot(),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                var token = await services.login(username.text, password.text);

                if (token["statusCode"] == 200) {
                  auth.updateToken(token["token"], token["id"].toString(),
                      token["username"]);

                  Navigator.pushNamed(context, '/select_home');
                } else {
                  Fluttertoast.showToast(
                    msg: token["token"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }
}

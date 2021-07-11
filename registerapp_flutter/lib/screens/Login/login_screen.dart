import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/components/rounded_input_field.dart';
import 'package:registerapp_flutter/components/rounded_password_field.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import 'package:registerapp_flutter/screens/Login/service/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constance.dart';
import 'components/backgroud.dart';
import 'components/backicon.dart';
import 'components/dropdown_item.dart';
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
  List listItem = [
    // "บ้านสิรินธร - 1/1",
    // "บ้านสิรินธร - 1/2",
    // "บ้านสิรินธร - 1/3",
    // "บ้านไลฟ์สไตล์ - 2/1",
    // "บ้านไลฟ์สไตล์ - 2/2",
    // "บ้านไลฟ์สไตล์ - 2/3",
  ];
  // String selectHome = "บ้านสิรินธร - 1/1";
  String selectHome;
  final username = TextEditingController(text: "peet");
  final password = TextEditingController(text: "10042541");

  Auth auth = Auth();
  Home home = Home();
  Services services = Services();

  void initState() {
    super.initState();

    getAllHome();
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
            DropdownItem(
              listItem: listItem,
              chosenValue: selectHome,
              onChanged: (value) {
                setState(() {
                  selectHome = value;
                });
              },
            ),
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
                var token = await services.login(username.text, password.text, selectHome);

                if (token["statusCode"] == 200) {
                  home.updateHome(selectHome);
                  auth.updateToken(token["token"]);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
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

  getAllHome() async {
    var allHome = await services.getAllHome();

    if (allHome == -1) {
      print("services error");
    } else {
      setState(() {
        selectHome = allHome[0];
        listItem = allHome;
      });
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }
}

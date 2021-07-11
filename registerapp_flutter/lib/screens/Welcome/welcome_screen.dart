import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Home/home_screen.dart';
import 'components/body.dart';
import 'is_loading.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLogin = false;
  bool isLoad = true;

  Auth auth = Auth();
  Home home = Home();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    checkDB();

    Future.delayed(const Duration(milliseconds: 2000), () => _checkLogin());
  }

  void checkDB() async {
    var isHaveDB = await home.checkDBHome();
    if (!isHaveDB) {
      home.initHome();
    }

    isHaveDB = await auth.checkDBAuth();
    if (!isHaveDB) {
      auth.initAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? IsLoadding(isLogin: true)
          : isLogin
              ? HomeScreen()
              : Body(),
    );
  }

  _checkLogin() async {
    var token = auth.getToken();

    token.then((token) {
      if (token[0]["TOKEN"] == "-1") {
        setState(() {
          isLogin = false;
          isLoad = false;
        });
      } else {
        setState(() {
          isLogin = true;
          isLoad = false;
        });
      }
    });
  }
}

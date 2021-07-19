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
  bool lock1 = false;
  bool lock2 = false;

  Auth auth = Auth();
  Home home = Home();

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    // home.deleteHome();
    // auth.deleteToken();

    checkDB();
  }

  Future checkDB() async {
    var isHaveDBH = home.checkDBHome();
    var isHaveDBA = auth.checkDBAuth();

    isHaveDBH.then((v) {
      if (!v) {
        setLock(1);
      } else {
        setState(() {
          lock1 = true;
        });
      }
    });

    isHaveDBA.then((v) {
      if (!v) {
        setLock(2);
      } else {
        setState(() {
          lock2 = true;
        });
      }
    });

    // if (!isHaveDBH) {
    //   await home.initHome();
    //   setState(() {
    //     lock1 = true;
    //   });
    // } else {
    //   setLock(1);
    // }

    // if (!isHaveDBA) {
    //   await auth.initAuth();
    //   setState(() {
    //     lock2 = true;
    //   });
    // } else {
    //   setLock(2);
    // }
  }

  setLock(int lockIndex) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        if (lockIndex == 1) {
          lock1 = true;
        } else {
          lock2 = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (lock1 && lock2) {
      _checkLogin();
    }

    return Scaffold(
      body: isLoad
          ? IsLoadding(isLogin: true)
          : isLogin
              ? HomeScreen()
              : Body(),
    );
  }

  _checkLogin() async {
    var token = await auth.getToken();

    setState(() {
      lock1 = false;
      lock2 = false;
    });

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
  }
}

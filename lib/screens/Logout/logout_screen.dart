import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import '../../constance.dart';
import 'components/app_bar_title.dart';
import 'components/list_item.dart';
import 'components/logout.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({Key key}) : super(key: key);

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  String title = "";
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();

    getHome();
    getUser();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: goldenSecondary,
          ),
        ),
        // title: AppBarTitle(title: title),
        title: Center(
          child: Text(
            "ตั้งค่า",
            style: TextStyle(
              color: goldenSecondary,
              fontFamily: 'Prompt',
            ),
          ),
        ),
        backgroundColor: darkgreen,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: greenPrimary,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            ListItem(
              title: "อีเมล",
              // desc: username,
              desc: email,
              // desc: "vms-user@domail.com",
            ),
            SizedBox(height: size.height * 0.02),
            ListItem(
              title: "รหัสผ่าน",
              desc: "********",
              press: () => Get.toNamed('/changePassword'),
              // press: null,
            ),
            SizedBox(height: size.height * 0.02),
            ListItem(title: "เวอร์ชั่น", desc: "1.0"),
            SizedBox(height: size.height * 0.4),
            LogoutButton(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future getHome() async {
    Home home = Home();
    String _home = await home.getHome();

    setState(() {
      title = _home;
    });
  }

  Future getUser() async {
    Auth auth = Auth();
    String user = await auth.getUser();

    setState(() {
      username = user;
    });
  }

  Future getEmail() async {
    Auth auth = Auth();
    String e = await auth.getEmail();

    setState(() {
      email = e;
    });
  }
}

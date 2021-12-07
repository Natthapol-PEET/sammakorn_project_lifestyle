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

  @override
  void initState() {
    super.initState();

    getHome();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        title: AppBarTitle(title: title),
        backgroundColor: darkgreen,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_forward_ios, color: goldenSecondary),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            ListItem(
              title: "Username",
              desc: username,
            ),
            SizedBox(height: size.height * 0.02),
            ListItem(
                title: "Password",
                desc: "********",
                press: () => Get.toNamed('/changePassword')),
            SizedBox(height: size.height * 0.02),
            ListItem(title: "Version", desc: "1.0"),
            SizedBox(height: size.height * 0.46),
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
}

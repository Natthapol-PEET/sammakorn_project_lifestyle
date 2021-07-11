import 'package:flutter/material.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Password/password_screen.dart';
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

  @override
  void initState() {
    super.initState();

    getHome();
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
      body: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          ListItem(
            title: "Email",
            desc: "natthapol593@gmail.com",
          ),
          SizedBox(height: size.height * 0.02),
          ListItem(
              title: "Password",
              desc: "********",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PasswordScreen();
                    },
                  ),
                );
              }),
          SizedBox(height: size.height * 0.02),
          ListItem(title: "Version", desc: "1.0"),
          SizedBox(height: size.height * 0.46),
          LogoutButton()
        ],
      ),
    );
  }

  Future getHome() async {
    Home home = Home();
    String _home = await home.getHome();
    print(_home);

    setState(() {
      title = _home;
    });
  }
}

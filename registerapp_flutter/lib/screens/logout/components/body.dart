import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Password/password_screen.dart';
import 'list_item.dart';
import 'logout.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
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
    );
  }
}

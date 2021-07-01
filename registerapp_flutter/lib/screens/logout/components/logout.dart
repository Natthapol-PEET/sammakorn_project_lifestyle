import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Welcome/welcome_screen.dart';

import '../../../constance.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WelcomeScreen();
              },
            ),
          );
        },
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.08,
          decoration: BoxDecoration(
            color: backgrounditem,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text("Logout",
                style: TextStyle(color: goldenSecondary, fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../constance.dart';
import '../service/logout.dart';

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
          _logout(context);
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

  _logout(context) {
    Services services = Services();
    var res = services.logout();

    res.then((v) {
      Navigator.pushNamed(context, '/');
    });
  }
}

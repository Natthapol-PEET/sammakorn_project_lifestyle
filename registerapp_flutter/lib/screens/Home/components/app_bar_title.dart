import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/logout/logout_screen.dart';
import '../../../constance.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LogoutScreen();
                },
              ),
            );
          },
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/Rectangle 2878.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(color: goldenSecondary),
        )
      ],
    );
  }
}

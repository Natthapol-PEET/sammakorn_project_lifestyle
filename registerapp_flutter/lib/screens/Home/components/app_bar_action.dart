import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Notification/notification_screen.dart';
import '../../../constance.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: goldenSecondary,
            size: 36,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NotificationScreen();
                },
              ),
            );
          },
        ),
        Positioned(
          right: 1,
          top: 5,
          child: Container(
            width: size.width * 0.05,
            height: size.height * 0.03,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              // border: Border.all(
              //   color: goldenSecondary,
              //   width: 1.5,
              // ),
            ),
            child: Center(
                child: Text('3',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}

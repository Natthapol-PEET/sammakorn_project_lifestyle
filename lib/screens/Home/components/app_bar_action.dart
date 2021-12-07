import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Notification/notification_screen.dart';
import '../../../constance.dart';

class AppBarAction extends StatelessWidget {
  final String countAlert;
  final Function pass;

  const AppBarAction({
    Key key,
    @required this.countAlert,
    @required this.pass,
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
          onPressed: pass,
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
                child: Text(countAlert,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}

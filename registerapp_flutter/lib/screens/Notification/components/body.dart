import 'package:flutter/material.dart';
import '../../../constance.dart';
import 'list_notification.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Today",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          child,
          // ListNotifiication(
          //   title: 'There is a blacklist added number 4ฟก 8996 to your project',
          //   descTime: '8 mins ago',
          //   color: Colors.red,
          // ),
          // ListNotifiication(
          //   title:
          //       'Guest with vehicle registration number 7กด 5487 has entered your project',
          //   descTime: '10 mins ago',
          //   color: goldenSecondary,
          // ),
          // ListNotifiication(
          //   title:
          //       'Guest with vehicle registration number 6สว 6523 has entered your project',
          //   descTime: '12 mins ago',
          //   color: goldenSecondary,
          // ),
        ],
      ),
    );
  }
}

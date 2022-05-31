import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:flutter/material.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project A",
            style: TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            text,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Please scan the QR Code to enter the project.",
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

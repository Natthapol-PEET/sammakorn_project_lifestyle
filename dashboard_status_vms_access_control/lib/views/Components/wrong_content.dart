import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';

class WorngContent extends StatelessWidget {
  const WorngContent({
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/wrong_mark.png",
            height: 150,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: size.height * 0.02),
          // TextDetail(text: text, height: size.height * 0.03),
          // TextDetail(
          //   text: "Status No pass",
          //   height: size.height * 0.02,
          //   color: noPassColor,
          // ),
        ],
      ),
    );
  }
}



import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/models/data_screen.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';

class CheckContent extends StatelessWidget {
  const CheckContent({
    Key key,
    @required this.data,
  }) : super(key: key);

  final DataScreen data;

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
            "assets/images/check_mark.png",
            height: 150,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Welcome To The Project A",
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          // TextDetail(
          //     text: "Hello, ${data != null ? data.fullname : ""}",
          //     height: size.height * 0.03),
          // TextDetail(
          //     text: "License Plate : ${data != null ? data.license_plate : ""}",
          //     height: size.height * 0.02),
          // TextDetail(
          //     text: "Home Number : ${data != null ? data.home_number : ""}",
          //     height: size.height * 0.02),
          // TextDetail(
          //   text: "Status Pass",
          //   height: size.height * 0.02,
          //   color: passColor,
          // ),
        ],
      ),
    );
  }
}

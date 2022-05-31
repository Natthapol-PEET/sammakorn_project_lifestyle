
import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';

class StatusContent extends StatelessWidget {
  const StatusContent({Key key}) : super(key: key);

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
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          // TextDetail(
          //     text: "Name: Janny Kim",
          //     height: size.height * 0.03,
          //     fontSize: 50),
          // TextDetail(
          //     text: "License Plate: 12AS2",
          //     height: size.height * 0.03,
          //     fontSize: 50),
          // TextDetail(
          //     text: "Home number: 12/2",
          //     height: size.height * 0.03,
          //     fontSize: 50),
          // TextDetail(
          //     text: "Entry time: 09.00 AM",
          //     height: size.height * 0.03,
          //     fontSize: 50),
          // TextDetail(
          //     text: "Time of departure: 10.00 AM",
          //     height: size.height * 0.03,
          //     fontSize: 50),
          // TextDetail(
          //     text: "Time in projec: 3 days 2.10 hour",
          //     height: size.height * 0.03,
          //     fontSize: 50),
          SizedBox(height: size.height * 0.02),
          Text(
            "Status: PASS",
            style: TextStyle(
              fontSize: 72,
              color: passColor,
            ),
          ),
        ],
      ),
    );
  }
}

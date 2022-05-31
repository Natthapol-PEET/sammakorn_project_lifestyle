import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/models/exit_model.dart';
import 'package:dashboard_status_vms_access_control/views/Components/backgroud.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class NoPassExitScreen extends StatelessWidget {
  NoPassExitScreen({Key key}) : super(key: key);

  ExitModel data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroud(
        child: Stack(
          children: [
            Container(
              color: bgColor,
            ),
            DisplayLogo(),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/wrong_mark.png', scale: 0.6),
                  SizedBox(height: 50),
                  Text(
                    "CAN'T LEAVE THE ARTANI",
                    style: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 800, vertical: 40),
                    child: Divider(color: Colors.white, thickness: 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDetails(text: "ชื่อ : ${data.fullname}"),

                          if (data.licensePlate != '') ...[
                            TextDetails(
                                text: "ทะเบียนรถ : ${data.licensePlate}"),
                          ],

                          TextDetails(text: "บ้านเลขที่ : ${data.homeNumber}"),
                          // TextDetails(text: "ชื่อ : นัฐพล  นนทะศรี"),
                          // TextDetails(text: "ทะเบียนรถ : 123กด"),
                          // TextDetails(text: "บ้านเลขที่ : 10/1"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDetails(
                              text: "วันที่เข้าโครงการ : ${data.getDate()}"),
                          TextDetails(
                              text: "เวลาเข้าโครงการ : ${data.getTime()}"),
                          TextDetails(
                              text:
                                  "สถานะ : ${data.msg == 'resident not stamp' ? 'ยังไม่ได้รับการสแตมป์' : data.msg}"),
                          // TextDetails(text: "วันที่เข้าโครงการ : 10 เมษายน 2541"),
                          // TextDetails(text: "เวลาเข้าโครงการ : 10.10"),
                          // TextDetails(text: "สถานะ : No Stamp"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/models/exit_model.dart';
import 'package:dashboard_status_vms_access_control/views/Components/backgroud.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LeaveScreen extends StatelessWidget {
  LeaveScreen({Key? key}) : super(key: key);

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
            DisplayLogo(disableClick: true),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: greenBgIcon,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset('assets/images/leave.svg',
                        semanticsLabel: 'leave logo'),
                  ),
                  SizedBox(height: 35),
                  Text(
                    "LEAVE THE ARTANI",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 600, vertical: 20),
                    child: Divider(color: Colors.white, thickness: 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.firstname.toString() != "null") ...[
                            TextDetails(
                                text:
                                    "สวัสดี ${data.firstname} ${data.lastname}"),
                          ],
                          if (data.firstname.toString() == "null") ...[
                            TextDetails(text: "รายการ ${data.qrGenId}"),
                          ],
                          if (data.licensePlate != "") ...[
                            TextDetails(
                                text: "ทะเบียนรถ : ${data.licensePlate}"),
                          ],
                          TextDetails(text: "บ้านเลขที่ : ${data.homeNumber}"),

                          // TextDetails(text: "สวัสดี นัฐพล นนทะศรี"),
                          // TextDetails(text: "รายการ : W123456"),
                          // TextDetails(text: "ทะเบียนรถ : 123กด"),
                          // TextDetails(text: "บ้านเลขที่ : 10/1"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDetails(text: "เวลาเข้า : ${data.getTime()}"),
                          TextDetails(text: "เวลาออก : ${data.getTimeout()}"),
                          TextDetails(
                              text:
                                  "สถานะ : ${data.msg == 'Pass' ? 'ผ่าน' : data.msg}"),
                          // TextDetails(text: "เวลาเข้า : 10.10 น."),
                          // TextDetails(text: "เวลาออก : 11.11 น."),
                          // TextDetails(text: "สถานะ : Pass"),
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

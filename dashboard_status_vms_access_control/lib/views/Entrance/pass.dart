import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/backgroud.dart';

// ignore: must_be_immutable
class PassScreen extends StatelessWidget {
  PassScreen({Key? key}) : super(key: key);

  var data = Get.arguments;

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
                  Image.asset('assets/images/check_mark.png', scale: 0.7),
                  SizedBox(height: 20),
                  Text(
                    "WELCOME TO ARTANI",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 550, vertical: 30),
                    child: Divider(color: Colors.white, thickness: 5),
                  ),
                  if (data.firstname != "") ...[
                    TextDetails(
                        text: "สวัสดี ${data.firstname} ${data.lastname}"),
                  ],
                  if (data.firstname == "") ...[
                    TextDetails(text: "รายการ ${data.qrGenId}"),
                  ],
                  if (data.licensePlate != "") ...[
                    TextDetails(text: "ทะเบียนรถ : ${data.licensePlate}"),
                  ],
                  TextDetails(text: "บ้านเลขที่ : ${data.homeNumber}"),

                  // TextDetails(text: "สวัสดี นัฐพล นนทะศรี"),
                  // TextDetails(text: "รายการ : W123546879"),
                  // TextDetails(text: "ทะเบียนรถ : 123กด"),
                  // TextDetails(text: "บ้านเลขที่ : 10/1"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:dashboard_status_vms_access_control/views/Components/text_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/backgroud.dart';

// ignore: must_be_immutable
class PassScreen extends StatelessWidget {
  PassScreen({Key key}) : super(key: key);

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
            DisplayLogo(),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/check_mark.png', scale: 0.6),
                  SizedBox(height: 40),
                  Text(
                    "WELCOME TO ARTANI",
                    style: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 600, vertical: 30),
                    child: Divider(color: Colors.white, thickness: 5),
                  ),
                  TextDetails(text: "สวัสดี ${data.fullname}"),

                  if (data.licensePlate != "") ...[
                    TextDetails(text: "ทะเบียนรถ : ${data.licensePlate}"),
                  ],

                  TextDetails(text: "บ้านเลขที่ : ${data.homeNumber}"),
                  // TextDetails(text: "สวัสดี นัฐพล นนทะศรี"),
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

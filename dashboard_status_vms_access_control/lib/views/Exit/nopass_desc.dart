import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/backgroud.dart';

// ignore: must_be_immutable
class NoPassDesc extends StatelessWidget {
  NoPassDesc({Key? key}) : super(key: key);

  String msg = Get.arguments;

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
                  Image.asset('assets/images/wrong_mark.png', scale: 0.7),
                  SizedBox(height: 35),
                  Text(
                    "คุณไม่มีสิทธิออกจากโครงการ",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 550, vertical: 30),
                    child: Divider(color: Colors.white, thickness: 5),
                  ),
                  Text(
                    // "*เนื่องจากไม่มีข้อมูลในระบบ",
                    msg == 'resident not stamp' ? 'ยังไม่ได้รับการสแตมป์' : msg,
                    style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 48,
                      color: Colors.white,
                    ),
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

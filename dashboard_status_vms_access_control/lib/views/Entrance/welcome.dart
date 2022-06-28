import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/controllers/in_controller.dart';
import 'package:dashboard_status_vms_access_control/views/Components/card_display_time.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/backgroud.dart';

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  final inController = Get.put(InController());
  String? qrId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RawKeyboardListener(
      onKey: (event) {
        qrId = inController.util.manageKey(event);

        if (qrId != "wait") {
          print(qrId);

          // controller
          inController.postCommingIn(qrId as String);
        }
      },
      autofocus: true,
      focusNode: FocusNode(),
      child: Scaffold(
        body: Backgroud(
          child: Row(
            children: [
              // welcome components
              Expanded(
                child: Container(
                  color: bgColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WELCOME",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "TO ARTANI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.12,
                            vertical: size.height * 0.05),
                        child: Divider(color: Colors.white, thickness: 5),
                      ),
                      Text(
                        "*กรุณาสแกน QR Code เพื่อเข้าโครงการ",
                        style: TextStyle(
                          fontFamily: "Prompt",
                          // fontFamily: "NunitoSans",
                          fontSize: size.width * 0.025,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // display the time components
              Expanded(
                child: Stack(
                  children: [
                    DisplayLogo(position: "entrance"),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Text(
                                "${inController.day} ${inController.dayNumber} ${inController.mon} พ.ศ. ${inController.year}",
                                style: TextStyle(
                                  fontFamily: "Prompt",
                                  fontSize: size.width * 0.025,
                                  // fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => CardDisplayTime(
                                    text: inController.hour.value,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      CircularPoint(),
                                      SizedBox(height: 50),
                                      CircularPoint(),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => CardDisplayTime(
                                    text: inController.minute.value,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



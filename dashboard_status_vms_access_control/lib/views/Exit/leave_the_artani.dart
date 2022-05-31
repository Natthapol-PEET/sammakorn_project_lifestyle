import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/controllers/out_controller.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/backgroud.dart';

// ignore: must_be_immutable
class LeaveTheArtaniScreen extends StatelessWidget {
  LeaveTheArtaniScreen({Key key}) : super(key: key);

  final outController = Get.put(OutController());
  String qrId;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      onKey: (event) {
        qrId = outController.util.manageKey(event);

        if (qrId != "wait") {
          print(qrId);

          // controller
          outController.postcheckOut(qrId);
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
                            "LEAVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 120,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "THE ARTANI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 96,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 200, vertical: 60),
                        child: Divider(color: Colors.white, thickness: 5),
                      ),
                      Text(
                        "*กรุณาสแกน QR Code เพื่อออกจากโครงการโครงการ",
                        style: TextStyle(
                          fontFamily: "Prompt",
                          // fontFamily: "NunitoSans",
                          fontSize: 40,
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
                    DisplayLogo(),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Text(
                                "${outController.day} ${outController.dayNumber} ${outController.mon} พ.ศ. ${outController.year}",
                                style: TextStyle(
                                  fontFamily: "Prompt",
                                  fontSize: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => CardDisplayTime(
                                    text: outController.hour.value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                    text: outController.minute.value,
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

class CircularPoint extends StatelessWidget {
  const CircularPoint({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class CardDisplayTime extends StatelessWidget {
  const CardDisplayTime({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 250,
          height: 320,
          // color: Colors.transparent,
        ),
        Positioned(
          top: 20,
          child: Container(
            width: 250,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 160,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.black,
                  width: 10,
                  height: 45,
                ),
                SizedBox(width: 15),
                Container(
                  color: Colors.black,
                  width: 10,
                  height: 45,
                ),
                SizedBox(width: 15),
                Container(
                  color: Colors.black,
                  width: 10,
                  height: 45,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

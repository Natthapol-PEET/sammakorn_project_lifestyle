import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/controllers/entrance_control.dart';
import 'package:dashboard_status_vms_access_control/models/data_screen.dart';
import 'package:dashboard_status_vms_access_control/services/comming_service.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:dashboard_status_vms_access_control/views/Components/card_details.dart';
import 'package:dashboard_status_vms_access_control/views/Components/check_content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/visitor_list_logo.dart';
import 'package:dashboard_status_vms_access_control/views/Components/wait_content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/welcome_content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/wrong_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntrancePage extends StatefulWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  Comming checkin = Comming();
  Utils util = Utils();

  String? rememChar;
  String? qrId;

  EntranceController _controller = Get.put(EntranceController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RawKeyboardListener(
      autofocus: true,
      onKey: (event) {
        qrId = util.manageKey(event);

        if (qrId != "wait") {
          // controller
          _controller.postCommingIn(qrId as String);
        }
      },
      focusNode: FocusNode(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: GetBuilder<EntranceController>(
          builder: (controller) => Row(
            children: [
              // Left Contentd
              if (controller.status == 0) ...[
                Content(
                  boxSize: size.height * 0.5,
                  child: WelcomeContent(text: "Welcome to all"),
                ),
              ],

              // Wait
              if (controller.status == 3) ...[
                Content(
                  boxSize: size.height * 0.5,
                  child: WaitContent(),
                ),
              ],

              // success
              if (controller.status == 1) ...[
                Content(
                  boxSize: size.height * 0.7,
                  child: CheckContent(data: controller.data as DataScreen),
                ),
              ],

              // not success
              if (controller.status == 2) ...[
                Content(
                  boxSize: size.height * 0.5,
                  child: WorngContent(
                      text: "You are not eligible to enter the project."),
                ),
              ],

              // Right Content
              Container(
                height: size.height,
                width: size.width * 0.4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.height * 0.03,
                    vertical: size.width * 0.015,
                  ),
                  child: Column(
                    children: [
                      VisitorListLogo(),
                      SizedBox(height: 20),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.listData.length,
                        itemBuilder: (context, index) {
                          return CardDetails(data: controller.listData[index]);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/controllers/exit_controller.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:dashboard_status_vms_access_control/views/Components/card_details.dart';
import 'package:dashboard_status_vms_access_control/views/Components/content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/status_content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/visitor_list_logo.dart';
import 'package:dashboard_status_vms_access_control/views/Components/wait_content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/welcome_content.dart';
import 'package:dashboard_status_vms_access_control/views/Components/wrong_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExitPage extends StatefulWidget {
  const ExitPage({Key? key}) : super(key: key);

  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  // DataScreen data;

  Utils util = Utils();

  String? qrId;

  // defind getx controller
  ExitController _controller = Get.put(ExitController());

  var subscription;
  // Client client = Client();

  @override
  void initState() {
    super.initState();


    // client.setEndpoint(appWriteURL).setProject(appWriteId);

    // final channels = exitChannel;
    // final realtime = Realtime(client);
    // subscription = realtime.subscribe(channels);

    // DataScreen d;
    // int s;
    // List list = [];
    // String m;

    // subscription.stream.listen((response) {
    //   print("********************");
    //   if (response.payload.containsKey("exit")) {
    //     // subscription.close();

    //     var dataJson = jsonDecode(response.payload['exit']);

    //     print(dataJson);

    //     // map json to model data screen
    //     // d = DataScreen.fromJson(dataJson);
    //     s = dataJson['status'];

    //     m = dataJson['msg'];

    //     // clear data list
    //     list = [];

    //     // map json to model data list
    //     for (var elem in dataJson['data']) {
    //       list.add(
    //         DataList(
    //           elem['fullname'],
    //           elem['license_plate'],
    //           elem['home_number'],
    //           elem['time'],
    //         ),
    //       );
    //     }
    //   }

    //   setState(() {
    //     //   data = d;
    //     status = s;
    //     listData = list;
    //     msg = m;
    //   });
    //   print("********************");
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RawKeyboardListener(
      autofocus: true,
      onKey: (event) {
        qrId = util.manageKey(event);

        if (qrId != "wait") {
          print(qrId);

          // controller
          _controller.postcheckOut(qrId as String);
        }
      },
      focusNode: FocusNode(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: GetBuilder<ExitController>(
          builder: (controller) => Row(
            children: [
              // Left Contentd
              if (controller.status == 0) ...[
                Content(
                  boxSize: size.height * 0.5,
                  child: WelcomeContent(text: "Have a safe trip"),
                ),
              ],

              // Wait
              if (controller.status == 3) ...[
                Content(
                  boxSize: size.height * 0.5,
                  child: WaitContent(),
                ),
              ],

              // Pass
              if (controller.status == 1) ...[
                Content(
                  boxSize: size.height * 0.9,
                  child: StatusContent(),
                ),
              ],

              // No pass
              if (controller.status == 2) ...[
                Content(
                  boxSize: size.height * 0.5,
                  child: WorngContent(text: controller.msg as String),
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
    subscription.close();
  }
}

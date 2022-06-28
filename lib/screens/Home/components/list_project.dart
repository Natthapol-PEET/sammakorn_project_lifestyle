import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_dialog.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/service/socket_service.dart';
import 'package:registerapp_flutter/service/update_home.dart';
import 'package:registerapp_flutter/screens/Notification/components/button_dialog.dart';
import '../../../constance.dart';
import 'card_list_item.dart';

// ignore: must_be_immutable
class ListProject extends StatelessWidget {
  ListProject({
    Key? key,
    required this.title,
    required this.index,
  }) : super(key: key);

  final String title;
  final int index;

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginController());
  final selectHomeController = Get.put(SelectHomeController());

  SocketService socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(width: size.height * 0.03),
        InkWell(
          onTap: () => dialogConfirm(
            context,
            'ไปที่โครงการ $title',
            () async {
              Get.back();

              showLoadingDialog();

              // update select home
              selectHomeController.homeId.value = selectHomeController
                  .homeIds[selectHomeController.listItem.indexOf(title)];
              selectHomeController.selectHome.value = title;

              // update home rest
              await updateHomeRestApi(
                  loginController.dataLogin!.authToken as String,
                  loginController.dataLogin!.residentId as int,
                  selectHomeController.homeId.value);

              // init socket
              socketService
                  .restartSocketClient(selectHomeController.homeId.value);

              Future.delayed(Duration(milliseconds: 100), () async {
                // fetchApi
                await homeController.fetchApi();
                // success dialog
                successDialog(context, 'เสร็จสิ้น');
                // pop dialog
                Future.delayed(Duration(milliseconds: 2000), () => Get.back());
              });
            },
          ),
          child: CardListItem(
            title: title,
            imagePath: projectImages[index],
          ),
        ),
      ],
    );
  }
}

Future<dynamic> dialogConfirm(
    BuildContext context, String text, Function press) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgDialog,
        title: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: dividerColor, fontFamily: 'Prompt'),
          ),
        ),
        actions: [
          if (true) ...[
            ButtonDialoog(
              text: "ยกเลิก",
              setBackgroudColor: false,
              press: () => Get.back(),
            )
          ],
          if (true) ...[
            ButtonDialoog(
              text: "ตกลง",
              setBackgroudColor: true,
              press: press as Function(),
            ),
          ],
        ],
      );
    },
  );
}

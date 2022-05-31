import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/notification_controller.dart';
import '../../../constance.dart';
import 'dialog_delete.dart';

class ListNotifiication extends StatelessWidget {
  final String text;
  final String time;
  final int id;
  final String classNoti;
  // final Color color;
  // final Function pass;

  final bool onclickTrashIcon;
  final controller = Get.put(NotificationController());

  Color avatarColor = Colors.amber;
  Icon avatarIcon = Icon(Icons.check_circle_outline);

  ListNotifiication({
    Key key,
    @required this.onclickTrashIcon,
    @required this.text,
    @required this.time,
    @required this.id,
    @required this.classNoti,
    // @required this.color,
    // @required this.pass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (classNoti == 'comming') {
      avatarColor = Colors.greenAccent;
      avatarIcon = Icon(Icons.emoji_transportation);
    } else if (classNoti == 'stamp') {
      avatarColor = Colors.blueAccent;
      avatarIcon = Icon(Icons.approval);
    } else if (classNoti == 'checkout') {
      avatarColor = Colors.redAccent;
      avatarIcon = Icon(Icons.directions_car);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
      margin: EdgeInsets.symmetric(vertical: size.height * 0.008),
      decoration: BoxDecoration(
        color: listColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: avatarIcon,
          foregroundColor: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Prompt',
                ),
              ),
            ),
            if (onclickTrashIcon) ...[
              InkWell(
                onTap: () => dialogDelete(
                  context,
                  "ยืนยันการลบการแจ้งเตือนนี้?",
                  "ลบ",
                  () {
                    // delete noti
                    controller.delete(id);

                    // update noti screen
                    controller.getNotification();

                    Get.back();
                    Future.delayed(Duration(microseconds: 500),
                        () => success_dialog(context, "ลบสำเร็จ"));
                    Future.delayed(Duration(seconds: 2), () => Get.back());
                  },
                ),
                child: Icon(
                  Icons.close,
                  color: dividerColor,
                ),
              )
            ],
          ],
        ),
        subtitle: Text(
          time,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontFamily: 'Prompt',
          ),
        ),
        onTap: () => Get.offNamed('/home', arguments: 'noti_screen'),
      ),
    );
  }

  // Widget _show_dialod(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: bgDialog,
  //         title: new Text(
  //           "Alert!!",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         content: Text(
  //           "Are you sure you want to delete\nyour notifications ?",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         actions: [
  //           // KeepItButton(),
  //           // DeleteButton(pass: pass),
  //         ],
  //       );
  //     },
  //   );
  // }
}

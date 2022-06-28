import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/notification_controller.dart';
import '../../../constance.dart';
import 'dialog_delete.dart';

// ignore: must_be_immutable
class ListNotifiication extends StatelessWidget {
  ListNotifiication({
    Key? key,
    required this.onclickTrashIcon,
    required this.text,
    required this.time,
    required this.id,
    required this.classNoti,
  }) : super(key: key);

  final String text;
  final String time;
  final int id;
  final String classNoti;

  final bool onclickTrashIcon;

  Color avatarColor = Colors.amber;
  Icon avatarIcon = Icon(Icons.check_circle_outline);

  final notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (classNoti == 'comming') {
      avatarColor = Colors.pinkAccent;
      avatarIcon = Icon(Icons.emoji_transportation);
    } else if (classNoti == 'stamp') {
      avatarColor = Colors.amber.shade300;
      avatarIcon = Icon(Icons.approval);
    } else if (classNoti == 'checkout') {
      avatarColor = Colors.blueAccent;
      avatarIcon = Icon(Icons.directions_car);
    } else if (classNoti == 'whitelist') {
      avatarColor = Colors.greenAccent;
      avatarIcon = Icon(Icons.how_to_reg);
    } else if (classNoti == 'blacklist') {
      avatarColor = Colors.redAccent;
      avatarIcon = Icon(Icons.person_off);
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
                    notificationController.delete(id);

                    // update noti screen
                    notificationController.getNotification();

                    Get.back();
                    Future.delayed(Duration(microseconds: 500),
                        () => successDialog(context, "ลบสำเร็จ"));
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
        // onTap: () => Get.offNamed('/home', arguments: 'noti_screen'),
        onTap: () => Get.back(),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/empty_componenmt.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/notification_controller.dart';
import 'package:registerapp_flutter/models/notification_list_model.dart';
import '../../constance.dart';
import 'components/body.dart';
import 'components/dialog_delete.dart';
import 'components/list_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());

  @override
  void initState() {
    controller.getNotification();

    super.initState();
  }

  // Test State
  bool onclickTrashIcon = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkgreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.pop(context, 'Yep!'),
        ),
        centerTitle: true,
        title: Text(
          "แจ้งเตือน",
          style: TextStyle(
            color: goldenSecondary,
            fontFamily: 'Prompt',
          ),
        ),
        actions: [
          onclickTrashIcon
              ? InkWell(
                  onTap: () => dialogDelete(
                    context,
                    "ยืนยันการลบการแจ้งเตือนทั้งหมด?",
                    "ลบทั้งหมด",
                    () {
                      // delete all notification
                      controller.deleteAll();

                      // update noti screen
                      controller.getNotification();

                      Get.back();
                      Future.delayed(Duration(microseconds: 500),
                          () => successDialog(context, "ลบสำเร็จ"));
                      Future.delayed(Duration(seconds: 2), () => Get.back());
                    },
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: size.width * 0.03),
                    child: Center(
                      child: Text(
                        "ลบทั้งหมด",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 18,
                          color: goldenSecondary,
                        ),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: goldenSecondary,
                  ),
                  onPressed: () => setState(() => onclickTrashIcon = true),
                ),
        ],
      ),
      body: Obx(() => Body(
            child: buildListNotifiication(context, controller.lists),
          )),
      backgroundColor: darkgreen200,
    );
  }

  Widget buildListNotifiication(
      BuildContext context, List<NotificationListModel> lists) {
    final Size size = MediaQuery.of(context).size;

    if (lists.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: size.height * 0.15),
        child: noHaveData(context, "ไม่มีการแจ้งเตือน"),
      );
    }

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListNotifiication(
            onclickTrashIcon: onclickTrashIcon,
            text: lists[index].description as String,
            time: lists[index].timeAgo as String,
            id: lists[index].id as int,
            classNoti: lists[index].classs as String,
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

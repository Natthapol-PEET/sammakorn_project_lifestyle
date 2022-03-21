import 'package:get/get.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/data/notification.dart';

class NotificationController extends GetxController {
  var lists = [].obs;
  var descTime = "".obs;

  NotificationDB notifications = NotificationDB();

  getNotification() async {
    var data = await notifications.getNotification();
    DateTime now = DateTime.now();
    String text;
    Map dataMap = {};
    List dataList = [];

    for (var elem in data) {
      DateTime dt = DateTime.parse(elem['time']);
      int hour = now.hour - dt.hour;
      int minute = now.minute - dt.minute;
      int second = now.second - dt.second;

      if (minute == 0) {
        text = '${second} วินาทีที่แล้ว';
      } else if (minute == 1) {
        text = '${minute} นาทีที่แล้ว';
      } else if (minute > 1) {
        text = '${minute} นาทีที่แล้ว';
      } else if (hour == 1) {
        text = '${hour} ชั่วโมงที่แล้ว';
      } else {
        text = '${hour} ชั่วโมงที่แล้ว';
      }

      dataMap = {
        "id": elem['id'],
        "class": elem['class'],
        "description": elem['description'],
        "time_desc": text
      };

      dataList.add(dataMap);
      dataMap = {};
    }

    lists.value = dataList;
    descTime.value = text;
  }

  delete(int id) {
    notifications.deleteNotification(id);
  }

  deleteAll() async {
    Home home = Home();
    String homeId = await home.getHomeId();
    notifications.deleteAllNotification(homeId);
  }
}

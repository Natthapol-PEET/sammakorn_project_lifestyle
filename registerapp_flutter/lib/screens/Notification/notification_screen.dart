import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registerapp_flutter/data/notification.dart';
import '../../constance.dart';
import 'components/body.dart';
import 'components/list_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationDB notifications = NotificationDB();
  List lists = [];
  String descTime = "";

  @override
  void initState() {
    super.initState();

    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkgreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.pop(context, 'Yep!'),
        ),
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(
            color: goldenSecondary,
          ),
        ),
      ),
      body: Body(
        child: build_ListNotifiication(context, lists),
      ),
      backgroundColor: darkgreen200,
    );
  }

  getNotification() async {
    notifications.updateNotification();

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
      } else if (hour == 0) {
        text = '${minute} นาทีที่แล้ว';
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

    setState(() {
      lists = dataList;
      descTime = text;
    });
  }

  Widget build_ListNotifiication(BuildContext context, lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListNotifiication(
              title: lists[index]['description'],
              // descTime: '8 นาทีที่แล้ว',
              descTime: lists[index]['time_desc'],
              // descTime: lists[index]['time'],
              color: lists[index]['class'] == 'admin'
                  ? Colors.blue
                  : lists[index]['class'] == 'visitor'
                      ? goldenSecondary
                      : lists[index]['class'] == 'whitelist'
                          ? Colors.green
                          : Colors.red,
              pass: () {
                notifications.deleteNotification(lists[index]['id']);
                Timer(Duration(seconds: 1), () => getNotification());
                Navigator.pop(context);
              });
        });
  }
}

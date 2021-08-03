import 'dart:async';
import 'package:flutter/material.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/data/notification.dart';
import '../../constance.dart';
import 'components/body.dart';
import 'components/list_notification.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationDB notifications = NotificationDB();
  Home home = Home();
  Auth auth = Auth();
  List lists = [];
  String descTime = "";

  // socket variable
  IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    getNotification();

    // realtime update data
    socket();
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
        text = '${second} seconds ago';
      } else if (minute == 1) {
        text = '${minute} min ago';
      } else if (minute > 1) {
        text = '${minute} mins ago';
      } else if (hour == 1) {
        text = '${hour} hour ago';
      } else {
        text = '${hour} hours ago';
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

  socket() async {
    var data = await auth.getToken();
    String token = data[0]['TOKEN'];
    String homeId = await home.getHomeId();

    channel = IOWebSocketChannel.connect(
        Uri.parse('${WS}/ws/${token}/app/${homeId}'));

    try {
      channel.stream.listen((msg) {
        if (msg == "ALERT_MESSAGE") {
          // ทุกครั้งที่มีแจ้งเตือนเข้ามา [topic ALERT_MESSAGE] {web -> app}
          Future.delayed(Duration(milliseconds: 500), () => getNotification());
        }
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close(status.goingAway);
  }
}

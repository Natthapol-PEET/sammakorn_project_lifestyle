import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationLocal extends StatefulWidget {
  const NotificationLocal({Key key}) : super(key: key);

  @override
  _NotificationLocalState createState() => _NotificationLocalState();
}

class _NotificationLocalState extends State<NotificationLocal> {
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  @override
  void initState() {
    super.initState();

    initializationNotificationSettings();
  }

  initializationNotificationSettings() async {
    message = "No message.";

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // when user tap on notification.
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      setState(() {
        message = payload;
      });
    });
  }

  sendNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName, channelDescription,
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      111,
      title,
      body,
      platformChannelSpecifics,
      payload: title + body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Local Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendNotification('title', 'body');
        },
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ),
    );
  }
}

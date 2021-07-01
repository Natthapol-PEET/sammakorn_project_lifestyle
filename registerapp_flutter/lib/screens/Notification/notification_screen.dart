import 'package:flutter/material.dart';
import '../../constance.dart';
import 'components/body.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkgreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(
            color: goldenSecondary,
          ),
        ),
      ),
      body: Body(),
      backgroundColor: darkgreen200,
    );
  }
}

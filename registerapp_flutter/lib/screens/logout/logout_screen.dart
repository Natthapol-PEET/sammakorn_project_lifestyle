import 'package:flutter/material.dart';
import '../../constance.dart';
import 'components/app_bar_title.dart';
import 'components/body.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        title: AppBarTitle(),
        backgroundColor: darkgreen,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_forward_ios, color: goldenSecondary),
            ),
          )
        ],
      ),
      body: Body(),
    );
  }
}

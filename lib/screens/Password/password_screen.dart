import 'package:flutter/material.dart';

import '../../constance.dart';
import 'components/body.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            'เปลี่ยนรหัสผ่าน',
            style: TextStyle(
              fontFamily: 'Prompt',
              color: goldenSecondary,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: greenPrimary),
            onPressed: null
          )
        ],
        backgroundColor: darkgreen,
      ),
      body: Body(),
    );
  }
}

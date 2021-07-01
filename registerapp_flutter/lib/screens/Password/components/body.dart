import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/components/rount_input_field.dart';

import 'button_group.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          RoundInputField(title: "Old Password"),
          RoundInputField(title: "New Password"),
          RoundInputField(title: "Confirm New Password"),
          SizedBox(height: size.height * 0.38),
          ButtonGroup(),
        ],
      ),
    );
  }
}

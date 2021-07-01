import 'package:flutter/material.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/components/rount_input_field.dart';

import 'button_group.dart';
import 'date_input.dart';
import 'dropdown_item.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          DropdownItem(),
          DateInput(),
          RoundInputField(title: "First Name"),
          RoundInputField(title: "Last Name"),
          RoundInputField(title: "License plate"),
          SizedBox(height: size.height * 0.1),
          ButtonGroup(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'RegisterTitle.dart';
import 'backgroud.dart';
import 'backicon.dart';
import 'card_form_input.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Backgroud(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.03),
            BackIcon(),
            SizedBox(height: size.height * 0.07),
            RegisterTitle(),
            SizedBox(height: size.height * 0.025),
            CardFormInput(),
          ],
        ),
      ),
    );
  }
}

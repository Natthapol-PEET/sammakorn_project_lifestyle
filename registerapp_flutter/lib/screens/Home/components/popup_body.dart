import 'package:flutter/material.dart';

import '../../../constance.dart';

class PopupBody extends StatelessWidget {
  final String title;
  final String value;

  const PopupBody({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.03),
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(height: size.height * 0.01),
        Text(value, style: TextStyle(color: goldenSecondary)),
        Divider(
          height: 5,
          color: dividerColor,
        ),
      ],
    );
  }
}
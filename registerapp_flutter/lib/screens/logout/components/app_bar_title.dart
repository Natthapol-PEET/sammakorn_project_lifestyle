import 'package:flutter/material.dart';

import '../../../constance.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/Rectangle 2878.png'),
        ),
        SizedBox(width: 10),
        Text(
          "Condo Project 1",
          style: TextStyle(color: goldenSecondary),
        )
      ],
    );
  }
}

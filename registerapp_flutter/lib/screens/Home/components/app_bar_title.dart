import 'package:flutter/material.dart';
import '../../../constance.dart';

class AppBarTitle extends StatelessWidget {
  final Function press;
  final String title;

  const AppBarTitle({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: press,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/Rectangle 2878.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(color: goldenSecondary),
        )
      ],
    );
  }
}

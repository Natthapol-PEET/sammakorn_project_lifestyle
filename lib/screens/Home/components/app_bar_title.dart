import 'package:flutter/material.dart';
import '../../../constance.dart';

class AppBarTitle extends StatelessWidget {
  final Function press;
  final String title;
  final int titleIndex;

  const AppBarTitle({
    Key key,
    @required this.press,
    @required this.title,
    @required this.titleIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: press,
          child: titleIndex != -1
              ? CircleAvatar(
                  backgroundImage: AssetImage(projectImages[titleIndex]),
                )
              : Container(),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: goldenSecondary,
            fontFamily: 'Prompt',
          ),
        ),
      ],
    );
  }
}

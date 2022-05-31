import 'package:flutter/material.dart';

class VisitorListLogo extends StatelessWidget {
  const VisitorListLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Visitor List",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 72,
          ),
        ),
        Image.asset("assets/images/logo.png", height: 120)
      ],
    );
  }
}

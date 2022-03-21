import 'package:flutter/material.dart';

Widget noHaveData(context, String text) {
  final Size size = MediaQuery.of(context).size;

  return Container(
    width: size.width,
    height: size.height / 3,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          color: Color(0xFFE2E1E1),
          size: 36,
        ),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFFE2E1E1),
            fontSize: 16,
            fontFamily: 'Prompt',
          ),
        )
      ],
    ),
  );
}

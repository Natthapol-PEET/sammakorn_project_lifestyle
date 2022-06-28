import 'package:flutter/material.dart';

class ShowTextCheckInput extends StatelessWidget {
  const ShowTextCheckInput({
    Key? key,
    required this.text,
    this.color = Colors.red,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: size.height * 0.01, left: size.width * 0.1),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Prompt',
              color: color,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

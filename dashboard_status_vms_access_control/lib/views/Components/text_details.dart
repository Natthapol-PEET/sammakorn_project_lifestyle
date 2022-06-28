import 'package:flutter/material.dart';

class TextDetails extends StatelessWidget {
  const TextDetails({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Prompt",
          fontSize: 36,
          color: Colors.white,
        ),
      ),
    );
  }
}

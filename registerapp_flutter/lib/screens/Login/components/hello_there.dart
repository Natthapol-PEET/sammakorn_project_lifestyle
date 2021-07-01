import 'package:flutter/material.dart';

class HelloThere extends StatelessWidget {
  const HelloThere({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23, top: 5),
      child: Text(
        'Hello there, Login to continue',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}


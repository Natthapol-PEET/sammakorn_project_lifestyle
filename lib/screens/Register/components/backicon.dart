import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back_ios,
          size: 24.0,
        ),
      ),
    );
  }
}

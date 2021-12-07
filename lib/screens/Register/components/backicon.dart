import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        // onTap: () => Navigator.pop(context),
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 24.0,
        ),
      ),
    );
  }
}

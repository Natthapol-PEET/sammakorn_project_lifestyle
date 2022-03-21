import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constance.dart';

class RememberForgot extends StatelessWidget {
  final bool rememberCheckbox;
  final Function rememberPress;

  const RememberForgot({
    Key key,
    @required this.rememberCheckbox,
    @required this.rememberPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                onChanged: rememberPress,
                value: rememberCheckbox,
              ),
              Text("จดจำฉัน",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Prompt",
                  )),
            ],
          ),
          InkWell(
            onTap: () => Get.toNamed('/forgot_password'),
            child: Text("ลืมรหัสผ่าน?",
                style: TextStyle(
                  fontSize: 16,
                  color: goldenSecondary,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Prompt",
                )),
          ),
        ],
      ),
    );
  }
}

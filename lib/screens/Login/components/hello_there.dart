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
        'สวัสดี, เข้าสู่ระบบเพื่อดำเนินการต่อ',
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFFB8B7B2),
          fontWeight: FontWeight.w500,
          fontFamily: "Prompt",
        ),
      ),
    );
  }
}


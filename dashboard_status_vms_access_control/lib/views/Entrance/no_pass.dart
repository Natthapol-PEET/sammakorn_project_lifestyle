import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:flutter/material.dart';
import '../Components/backgroud.dart';

class NoPassScreen extends StatelessWidget {
  const NoPassScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroud(
        child: Stack(
          children: [
            Container(
              color: bgColor,
            ),
            DisplayLogo(),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/wrong_mark.png', scale: 0.6),
                  SizedBox(height: 50),
                  Text(
                    "คุณไม่มีสิทธิเข้าโครงการ",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 96,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 800, vertical: 40),
                    child: Divider(color: Colors.white, thickness: 5),
                  ),
                  Text(
                    "*กรุณาให้ลูกบ้านลงทะเบียนเพื่อเข้าโครงการ",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 72,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/views/Components/backgroud.dart';
import 'package:dashboard_status_vms_access_control/views/Components/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

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
                  SpinKitPouringHourGlass(
                    size: 400,
                    color: Colors.white,
                  ),
                  SizedBox(height: 60),
                  Text(
                    "ระบบกำลังประมวลผล",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 80,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "กรุณารอสักครู่",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 80,
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

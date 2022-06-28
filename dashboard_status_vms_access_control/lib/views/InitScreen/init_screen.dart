import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:dashboard_status_vms_access_control/controllers/confix_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../Components/backgroud.dart';

class InitScreen extends StatelessWidget {
  final confixController = Get.put(ConfixController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroud(
        child: Stack(
          children: [
            Container(
              color: bgColor,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', scale: 0.4),
                  SizedBox(height: 40),
                  SpinKitThreeBounce(
                    color: Colors.white,
                    size: 60,
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

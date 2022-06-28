import 'package:dashboard_status_vms_access_control/controllers/confix_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DisplayLogo extends StatelessWidget {
  DisplayLogo({
    Key? key,
    this.position,
    this.disableClick = false,
  }) : super(key: key);

  String? position;
  bool disableClick;

  final confixController = Get.put(ConfixController());

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      right: 30,
      child: GestureDetector(
          onLongPress: disableClick
              ? null
              : position == "entrance"
                  ? () => confixController.goToExit()
                  : () => confixController.goToEntrance(),
          child: Image.asset('assets/images/logo.png', scale: 1)),
    );
  }
}

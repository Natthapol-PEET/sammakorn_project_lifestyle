import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:flutter/material.dart';

class Backgroud extends StatelessWidget {
  const Backgroud({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/home2.png"),
          // image: AssetImage("assets/images/home3.jpg"),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(
          //   Colors.black.withOpacity(0.7),
          //   BlendMode.dstATop,
          // ),
        ),
      ),
      child: Container(
        color: bgColor,
        child: child,
      ),
    );
  }
}

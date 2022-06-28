import 'package:dashboard_status_vms_access_control/config/constant.dart';
import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  const Content({
    Key? key,
    required this.child,
    required this.boxSize,
  }) : super(key: key);

  final Widget child;
  final double boxSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width * 0.5,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topRight: Radius.circular(40),
              //   bottomRight: Radius.circular(40),
              // ),
              image: DecorationImage(
                image: AssetImage("assets/images/home2.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                color: bgColor,
                height: boxSize,
                width: size.width,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

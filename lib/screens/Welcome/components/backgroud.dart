import 'package:flutter/material.dart';

import '../../../constance.dart';

class Backgroud extends StatelessWidget {
  final Widget child;
  final isLogin;

  const Backgroud({
    Key key,
    @required this.child,
    @required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/Welcome.png',
              width: size.width, height: size.height, fit: BoxFit.fill),
          Positioned(
            top: 40,
            child: Image.asset('assets/images/Artani Logo Ai B-01.png',
                width: size.width * 0.3),
          ),
          isLogin
              ? child
              : Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: greenPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: child,
                  ),
                ),
        ],
      ),
    );
  }
}

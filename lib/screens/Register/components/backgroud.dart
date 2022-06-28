import 'package:flutter/material.dart';

class Backgroud extends StatelessWidget {
  final Widget child;

  const Backgroud({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset('assets/images/Welcome.png',
              width: size.width, height: size.height, fit: BoxFit.fill),
          child,
        ],
      ),
    );
  }
}

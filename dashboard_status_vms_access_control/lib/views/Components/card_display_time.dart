import 'package:flutter/material.dart';

class CardDisplayTime extends StatelessWidget {
  const CardDisplayTime({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: size.width * 0.15,
          height: size.height * 0.3,
          // color: Colors.transparent,
        ),
        Positioned(
          top: 20,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 120,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DividerBlack(),
                SizedBox(width: 15),
                DividerBlack(),
                SizedBox(width: 15),
                DividerBlack(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DividerBlack extends StatelessWidget {
  const DividerBlack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 8,
      height: 35,
    );
  }
}



class CircularPoint extends StatelessWidget {
  const CircularPoint({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
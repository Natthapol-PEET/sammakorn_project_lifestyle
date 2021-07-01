import 'package:flutter/material.dart';
import '../constance.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double topSize;

  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = greenYellow,
    this.textColor = Colors.white,
    this.topSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: topSize),
        width: size.width * 0.9,
        height: size.height * 0.06,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FlatButton(
            // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            color: color,
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

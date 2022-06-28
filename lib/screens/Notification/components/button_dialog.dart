import 'package:flutter/material.dart';
import '../../../constance.dart';

// ignore: must_be_immutable
class ButtonDialoog extends StatelessWidget {
  const ButtonDialoog({
    Key? key,
    required this.text,
    required this.setBackgroudColor,
    required this.press,
  }) : super(key: key);

  final String text;
  final bool setBackgroudColor;
  final Function()? press;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.08,
        right: size.width * 0.08,
        bottom: size.height * 0.03,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
            width: double.infinity, height: size.height * 0.06),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              setBackgroudColor ? goldenSecondary : bgDialog,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(
                  color: goldenSecondary,
                ),
              ),
            ),
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
              color: setBackgroudColor ? dividerColor : goldenSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../constance.dart';

class ButtonGroup extends StatelessWidget {
  final Function()? press;

  const ButtonGroup({
    Key? key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // button 1
        Center(
          child: ButtonTheme(
            minWidth: size.width * 0.4,
            height: size.height * 0.05,
            child: OutlineButton(
              highlightedBorderColor: goldenSecondary,
              child: Text(
                "ย้อนกลับ",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Prompt',
                  fontSize: 16,
                ),
              ),
              borderSide: BorderSide(
                color: goldenSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        // button 2
        Center(
          child: ButtonTheme(
            minWidth: size.width * 0.4,
            height: size.height * 0.05,
            child: RaisedButton(
              color: goldenSecondary,
              child: Text(
                "บันทึก",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Prompt',
                  fontSize: 16,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: press,
            ),
          ),
        )
      ],
    );
  }
}

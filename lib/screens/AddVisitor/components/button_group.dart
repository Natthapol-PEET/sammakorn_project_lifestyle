import 'package:flutter/material.dart';
import '../../../constance.dart';

class ButtonGroup extends StatelessWidget {
  final Function()? savePress;

  const ButtonGroup({
    Key? key,
   required this.savePress,
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
            height: size.height * 0.06,
            child: OutlineButton(
              highlightedBorderColor: goldenSecondary,
              child: Text(
                "ยกเลิก",
                style: TextStyle(
                  color: goldenSecondary,
                  fontSize: 16,
                  fontFamily: 'Prompt',
                ),
              ),
              borderSide: BorderSide(
                color: goldenSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        // button 2
        Center(
          child: ButtonTheme(
            minWidth: size.width * 0.4,
            height: size.height * 0.06,
            child: RaisedButton(
              color: goldenSecondary,
              child: Text("บันทึก",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Prompt',
                  )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: savePress,
            ),
          ),
        )
      ],
    );
  }
}

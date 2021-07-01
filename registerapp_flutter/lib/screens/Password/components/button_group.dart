import 'package:flutter/material.dart';
import '../../../constance.dart';

class ButtonGroup extends StatelessWidget {
  const ButtonGroup({
    Key key,
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
            child: OutlineButton(
              highlightedBorderColor: goldenSecondary,
              child: Text("Concel", style: TextStyle(color: Colors.white)),
              borderSide: BorderSide(
                color: goldenSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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
            child: RaisedButton(
              color: goldenSecondary,
              child: Text("Save", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}

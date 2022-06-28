import 'package:flutter/material.dart';
import '../../../constance.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: ButtonTheme(
        minWidth: size.width * 0.6,
        child: OutlineButton(
          highlightedBorderColor: goldenSecondary,
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
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
    );
  }
}

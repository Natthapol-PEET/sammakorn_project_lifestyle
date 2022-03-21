import 'package:flutter/material.dart';
import '../../../constance.dart';

class ShowButtonGroup extends StatelessWidget {
  final Function pass;

  const ShowButtonGroup({
    Key key,
    @required this.pass
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // CancelButton(),
        Center(
          child: ButtonTheme(
            minWidth: size.width * 0.3,
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
        ),
        // StampButton(),
        Center(
          child: ButtonTheme(
            minWidth: size.width * 0.3,
            child: RaisedButton(
              color: goldenSecondary,
              child: Text("Delete", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: pass,
            ),
          ),
        )
      ],
    );
  }
}

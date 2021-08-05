import 'package:flutter/material.dart';

class ButtonSelectGroup extends StatelessWidget {
  final List selectColorElem;
  final List selectColorButton;

  final Function press1;
  final Function press2;
  final Function press3;
  final Function press4;
  final Function press5;

  const ButtonSelectGroup({
    Key key,
    @required this.selectColorElem,
    @required this.selectColorButton,
    @required this.press1,
    @required this.press2,
    @required this.press3,
    @required this.press4,
    @required this.press5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bsize = 65.0;
    double horsize = 12.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
          child: ElevatedButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.mobile_friendly, color: selectColorElem[0]),
                SizedBox(height: 5),
                Text(
                  'Invite',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: selectColorElem[0]),
                ),
              ],
            ),
            onPressed: press1,
            style: ElevatedButton.styleFrom(
              primary: selectColorButton[0],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(width: horsize),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
          child: ElevatedButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.airport_shuttle, color: selectColorElem[1]),
                SizedBox(height: 5),
                Text(
                  'Coming in',
                  style: TextStyle(
                    fontSize: 9,
                    color: selectColorElem[1],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onPressed: press2,
            style: ElevatedButton.styleFrom(
              primary: selectColorButton[1],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(width: horsize),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
          child: ElevatedButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.approval, color: selectColorElem[2]),
                SizedBox(height: 5),
                Text('Stamp',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: selectColorElem[2],
                    )),
              ],
            ),
            onPressed: press3,
            style: ElevatedButton.styleFrom(
              primary: selectColorButton[2],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(width: horsize),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
          child: ElevatedButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.fact_check, color: selectColorElem[3]),
                SizedBox(height: 5),
                Text(
                  'List Item',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: selectColorElem[3],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onPressed: press4,
            style: ElevatedButton.styleFrom(
              primary: selectColorButton[3],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(width: horsize),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
          child: ElevatedButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.history, color: selectColorElem[4]),
                SizedBox(height: 5),
                Text('History',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: selectColorElem[4],
                    )),
              ],
            ),
            onPressed: press5,
            style: ElevatedButton.styleFrom(
              primary: selectColorButton[4],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

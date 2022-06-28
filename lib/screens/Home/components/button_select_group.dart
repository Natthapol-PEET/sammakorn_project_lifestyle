import 'package:flutter/material.dart';

class ButtonSelectGroup extends StatelessWidget {
  final List selectColorElem;
  final List selectColorButton;

  final Function()? press1;
  final Function()? press2;
  final Function()? press3;
  final Function()? press4;

  const ButtonSelectGroup({
    Key? key,
    required this.selectColorElem,
    required this.selectColorButton,
    required this.press1,
    required this.press2,
    required this.press3,
    required this.press4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bsize = 65.0;
    double horsize = 12.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: horsize),
        SelectButton(
          bsize,
          "เชิญเข้ามา",
          Icons.mobile_friendly,
          selectColorElem[0],
          press1,
          selectColorButton[0],
          selectColorElem[0],
        ),
        SizedBox(width: horsize),
        SelectButton(
          bsize,
          "เข้ามาแล้ว",
          Icons.airport_shuttle,
          selectColorElem[1],
          press2,
          selectColorButton[1],
          selectColorElem[1],
        ),
        SizedBox(width: horsize),
        SelectButton(
          bsize,
          "แสตมป์",
          Icons.approval,
          selectColorElem[2],
          press3,
          selectColorButton[2],
          selectColorElem[2],
        ),
        SizedBox(width: horsize),
        SelectButton(
          bsize,
          "ประวัติ",
          Icons.history,
          selectColorElem[3],
          press4,
          selectColorButton[3],
          selectColorElem[3],
        ),
        SizedBox(width: horsize),
        // ConstrainedBox(
        //   constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
        //   child: ElevatedButton(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Icon(Icons.airport_shuttle, color: selectColorElem[1]),
        //         SizedBox(height: 5),
        //         Text(
        //           'Coming in',
        //           style: TextStyle(
        //             fontSize: 9,
        //             color: selectColorElem[1],
        //             fontWeight: FontWeight.bold,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ],
        //     ),
        //     onPressed: press2,
        //     style: ElevatedButton.styleFrom(
        //       primary: selectColorButton[1],
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(width: horsize),
        // ConstrainedBox(
        //   constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
        //   child: ElevatedButton(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Icon(Icons.approval, color: selectColorElem[2]),
        //         SizedBox(height: 5),
        //         Text('Stamp',
        //             style: TextStyle(
        //               fontSize: 9,
        //               fontWeight: FontWeight.bold,
        //               color: selectColorElem[2],
        //             )),
        //       ],
        //     ),
        //     onPressed: press3,
        //     style: ElevatedButton.styleFrom(
        //       primary: selectColorButton[2],
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(width: horsize),
        // ConstrainedBox(
        //   constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
        //   child: ElevatedButton(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Icon(Icons.fact_check, color: selectColorElem[3]),
        //         SizedBox(height: 5),
        //         Text(
        //           'List Item',
        //           style: TextStyle(
        //             fontSize: 9,
        //             fontWeight: FontWeight.bold,
        //             color: selectColorElem[3],
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ],
        //     ),
        //     onPressed: press4,
        //     style: ElevatedButton.styleFrom(
        //       primary: selectColorButton[3],
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(width: horsize),
        // ConstrainedBox(
        //   constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
        //   child: ElevatedButton(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Icon(Icons.history, color: selectColorElem[4]),
        //         SizedBox(height: 5),
        //         Text('History',
        //             style: TextStyle(
        //               fontSize: 8,
        //               fontWeight: FontWeight.bold,
        //               color: selectColorElem[4],
        //             )),
        //       ],
        //     ),
        //     onPressed: press5,
        //     style: ElevatedButton.styleFrom(
        //       primary: selectColorButton[4],
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Expanded SelectButton(
    double bsize,
    String title,
    IconData icon,
    Color iconColor,
    Function()? press,
    Color selectColorButton,
    Color selectColorElem,
  ) {
    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: bsize, height: bsize),
        child: ElevatedButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              SizedBox(height: 5),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  // fontWeight: FontWeight.bold,
                  color: selectColorElem,
                  fontFamily: 'Prompt',
                ),
              ),
            ],
          ),
          onPressed: press,
          style: ElevatedButton.styleFrom(
            primary: selectColorButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

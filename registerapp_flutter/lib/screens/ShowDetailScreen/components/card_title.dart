import 'package:flutter/material.dart';

import '../../../constance.dart';

class CardTitle extends StatelessWidget {
  final Map arguments;

  const CardTitle({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 100,
      width: size.width,
      // margin: EdgeInsets.all(10),
      color: goldenSecondary,
      // decoration: BoxDecoration(
      // border: Border(top: BorderSide(width: 4, color: Colors.green)),
      // boxShadow: [
      //   BoxShadow(
      //     blurRadius: 10,
      //     color: Colors.black26,
      //   )
      // ],
      // ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("License Plate\t\t:\t\t${arguments['license_plate']}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 3),
            Text("Name\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t:\t\t${arguments['fullname']}",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            arguments['status'] == null
                ? Container()
                : Text("Type\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t:\t\t${arguments['status']}",
                    style: TextStyle(fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    );
  }
}

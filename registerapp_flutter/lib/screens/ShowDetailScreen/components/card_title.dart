import 'package:flutter/material.dart';

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
      width: size.width * 0.95,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 4, color: Colors.green)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("ทะเบียนรถ ${arguments['license_plate']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 3),
          Text(arguments['fullname'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          arguments['status'] == null
              ? Container()
              : Text("ประเภท ${arguments['status']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

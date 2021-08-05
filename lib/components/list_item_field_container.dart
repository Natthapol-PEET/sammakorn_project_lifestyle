import 'package:flutter/material.dart';

class ListItemField extends StatelessWidget {
  final String date;
  final String license_plate;
  final Color color;
  final Function press;

  const ListItemField(
      {Key key,
      @required this.date,
      @required this.license_plate,
      @required this.color,
      @required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: size.width * 0.9,
      height: size.height * 0.06,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          color: color,
          onPressed: press,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(date, style: TextStyle(color: Colors.white)),
              Text(license_plate, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../constance.dart';

class DateInput extends StatelessWidget {
  const DateInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Text("Date",
                style: TextStyle(
                    color: goldenSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            width: size.width * 0.8,
            height: size.height * 0.06,
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\t\t\t10-04-41",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.calendar_today_outlined,
                      color: goldenSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

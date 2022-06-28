import 'package:flutter/material.dart';
import '../../../constance.dart';

class DateInput extends StatelessWidget {
  final String date;
  final Function()? press;

  const DateInput({
    Key? key,
    required this.date,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.1, top: size.height * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: size.height * 0.03),
            Row(
              children: [
                Text("*",
                    style: TextStyle(
                      // color: goldenSecondary,
                      color: Colors.red,
                      fontFamily: 'Prompt',
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    )),
                Text("วันที่นัดหมาย",
                    style: TextStyle(
                      // color: goldenSecondary,
                      color: Colors.white,
                      fontFamily: 'Prompt',
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Container(
              width: size.width * 0.8,
              height: size.height * 0.06,
              margin: EdgeInsets.only(top: size.height * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\t\t\t${date}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Prompt',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: press,
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: goldenSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

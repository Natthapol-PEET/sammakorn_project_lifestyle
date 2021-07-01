import 'package:flutter/material.dart';
import '../../../constance.dart';

class RoundInputField extends StatelessWidget {
  final String title;

  const RoundInputField({
    Key key,
    @required this.title,
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
            padding: const EdgeInsets.only(top: 5, bottom: 10, left: 30),
            child: Text(title,
                style: TextStyle(
                    color: goldenSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.06,
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: goldenSecondary,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 5, right: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constance.dart';

class DialogStamp extends StatelessWidget {
  final Function press;

  DialogStamp({
    Key key,
    @required this.press,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: bgDialog,
      content: Stack(
        // overflow: Overflow.visible,
        children: [
          // Positioned(
          //   right: -40.0,
          //   top: -40.0,
          //   child: InkResponse(
          //     onTap: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: CircleAvatar(
          //       child: Icon(Icons.close),
          //       backgroundColor: Colors.red,
          //     ),
          //   ),
          // ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Are you sure you want to stamp this item ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: bgDialog,
                        shape: StadiumBorder(),
                        side: BorderSide(
                          width: 0.5,
                          color: goldenSecondary,
                        ),
                      ),
                      child: Text(
                        "Keep it",
                        style: TextStyle(
                          fontSize: 16,
                          color: goldenSecondary,
                        ),
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: goldenSecondary, shape: StadiumBorder()),
                      child: Text(
                        "Stamp",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: press,
                    ),
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextFormField(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

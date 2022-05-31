import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/add_controlller.dart';
import '../../../constance.dart';

class RoundInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final addController = Get.put(AddLicenseController());

  final String fullname;
  final String idcard;
  final String licenseplate;

  RoundInputField({
    Key key,
    @required this.title,
    this.controller,
    @required this.fullname,
    @required this.idcard,
    @required this.licenseplate,
  }) : super(key: key);

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

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
            // padding: const EdgeInsets.only(top: 5, bottom: 10, left: 30),
            padding: EdgeInsets.only(
                left: size.width * 0.1, bottom: size.height * 0.01),
            child: Row(
              children: [
                if (title == 'ชื่อ-นามสกุล') ...[
                  Text(
                    "*",
                    style: TextStyle(
                      // color: goldenSecondary,
                      color: Colors.red,
                      fontSize: 18,
                      fontFamily: 'Prompt',
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                Text(
                  title,
                  style: TextStyle(
                    // color: goldenSecondary,
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Prompt',
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                controller: controller,
                onChanged: (v) {
                  if (title == "ชื่อ-นามสกุล") {
                    addController.fullname.value = v;
                  } else if (title == "เลขประจำตัวประชาชน") {
                    List lchar = v.split('');
                    print("lchar: ${lchar}");

                    if (lchar.isEmpty) {
                      addController.idcard.value = v;
                    } else {
                      if (isNumeric(lchar[lchar.length - 1]) &&
                          lchar.length < 14) {
                        addController.idcard.value = v;
                      }
                    }

                    controller.text = addController.idcard.value;
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length));
                  } else if (title == "เลขทะเบียนรถ") {
                    addController.license.value = v;
                  }

                  addController.onCheck();
                },
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Prompt',
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

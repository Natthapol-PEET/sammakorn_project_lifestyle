import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constance.dart';
import 'button_dialog.dart';

Future<dynamic> dialogDelete(
    BuildContext context, String text, String textDelete, Function()? press) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgDialog,
        title: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: dividerColor, fontFamily: 'Prompt'),
          ),
        ),
        actions: [
          if (true) ...[
            ButtonDialoog(
              text: "ยกเลิก",
              setBackgroudColor: false,
              press: () => Get.back(),
            )
          ],
          if (true) ...[
            ButtonDialoog(
              text: textDelete,
              setBackgroudColor: true,
              press: press,
            ),
          ],
        ],
      );
    },
  );
}

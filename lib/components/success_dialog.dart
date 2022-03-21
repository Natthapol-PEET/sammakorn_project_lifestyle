import 'package:flutter/material.dart';
import '../constance.dart';

Future<dynamic> success_dialog(BuildContext context, String text) {
  final Size size = MediaQuery.of(context).size;

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgDialog,
        content: Container(
          height: size.height * 0.15,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF84BA40),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Prompt',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: InkWell(
              //     onTap: () => Get.back(),
              //     child: Icon(
              //       Icons.close,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    },
  );
}

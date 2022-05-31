/*
  Utils module
    - QR Reader module
 */

import 'package:flutter/services.dart';

class Utils {
  List qrIdList = [];
  String qrId;

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  double timeDiff;

  String manageKey(event) {
    // if (key == '#') {
    //   rememChar = '#';
    // } else if (key == '!') {
    //   rememChar = '!';

    //   qrId = listToString(qrIdList);

    //   // clear list
    //   qrIdList = [];
    // }

    // if (rememChar == '#') {
    //   if (key != '#') {
    //     qrIdList.add(key);
    //   }
    // }

    final key = event.logicalKey.keyLabel.toString();

    if (event.physicalKey != PhysicalKeyboardKey.shiftLeft &&
        event.physicalKey != PhysicalKeyboardKey.controlLeft &&
        event.physicalKey != PhysicalKeyboardKey.enter) {
      int length = qrIdList.length - 1;

      if (length == -1) {
        qrIdList.add(key);
      } else if (qrIdList[length] != key) {
        qrIdList.add(key);
      }
    }

    // update end time
    end = DateTime.now();
    String diff = end.difference(start).toString();
    timeDiff = double.parse(diff.split(':')[2]);

    // print("end: " + end.millisecond.toString());
    // print("start: " + start.millisecond.toString());

    if (event.physicalKey == PhysicalKeyboardKey.enter && timeDiff > 1.8) {
      qrId = listToString(qrIdList);

      // clear qr list
      qrIdList = [];

      // update start time
      start = DateTime.now();

      return qrId;
    } else {
      return "wait";
    }
  }

  String removeSymbol(qrId) {
    List symbol = ["#", "!"];

    for (String sym in symbol) {
      qrId = qrId.replaceAll(sym, "");
    }

    return qrId;
  }

  String listToString(List qrIdList) {
    String qrId = "";

    // list to string
    for (String char in qrIdList) {
      qrId += char;
    }

    return qrId;
  }
}

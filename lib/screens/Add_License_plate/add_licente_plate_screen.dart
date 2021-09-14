import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/service/service.dart';
import 'package:registerapp_flutter/screens/ShowQrcode/showQrCodeScreen.dart';
import 'package:registerapp_flutter/service/socket.dart';
import '../../constance.dart';
import 'components/button_group.dart';
import 'components/date_input.dart';
import 'components/dropdown_item.dart';
import 'components/rount_input_field.dart';
import 'package:intl/intl.dart';
import 'components/rount_input_large.dart';
import 'models/screenArg.dart';

class AddLicensePlateScreen extends StatefulWidget {
  const AddLicensePlateScreen({Key key}) : super(key: key);

  @override
  _AddLicensePlateScreenState createState() => _AddLicensePlateScreenState();
}

class _AddLicensePlateScreenState extends State<AddLicensePlateScreen> {
  String classValue = "visitor";
  DateTime dateTime;
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final licenseplate = TextEditingController();
  final reason = TextEditingController();

  Services services = Services();
  Home home = Home();
  var socket = SocketManager();

  // random number
  var rng = Random();

  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: darkgreen,
        title: Text(
          "Add License plate",
          style: TextStyle(color: goldenSecondary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownItem(
              chosenValue: classValue,
              onChanged: (value) {
                setState(() {
                  classValue = value;
                });
              },
            ),
            classValue == "visitor"
                ? DateInput(
                    date: DateFormat('dd-MM-yyyy').format(dateTime),
                    press: () => chooseDate(),
                  )
                : Container(),
            RoundInputField(
              title: "First Name",
              controller: firstname,
            ),
            RoundInputField(
              title: "Last Name",
              controller: lastname,
            ),
            RoundInputField(
              title: "License plate",
              controller: licenseplate,
            ),
            classValue == "visitor"
                ? Container()
                : RountInputLarge(
                    title: "Reason",
                    controller: reason,
                  ),
            SizedBox(height: size.height * 0.1),
            ButtonGroup(
              save_press: () async {
                if (firstname.text.isNotEmpty &&
                    lastname.text.isNotEmpty &&
                    licenseplate.text.isNotEmpty) {
                  if (classValue == 'visitor') {
                    // random number
                    // String qrGenId = rng.nextInt(9).toString(); // 10 point
                    String qrGenId = getRandomNumber();

                    String res_text = await services.invite_visitor(
                        firstname.text,
                        lastname.text,
                        licenseplate.text,
                        DateFormat('yyyy-MM-dd').format(dateTime),
                        "V${qrGenId}");
                    if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowQrcodeScreen(
                            data: ScreenArguments(
                              "Visitor",
                              licenseplate.text,
                              DateFormat('yyyy-MM-dd').format(dateTime),
                              firstname.text,
                              lastname.text,
                              "V${qrGenId}",
                              false,
                            ),
                          ),
                        ),
                      );

                      // socket update web
                      socket.send_message('INVITE_VISITOR', 'web');
                    } else {
                      _show_error_toast(res_text);
                    }
                  } else if (classValue == 'whitelist' &&
                      reason.text.isNotEmpty) {
                    // random number
                    // String qrGenId = rng.nextInt(9).toString(); // 10 point
                    String qrGenId = getRandomNumber();

                    String res_text = await services.register_whitelist(
                      firstname.text,
                      lastname.text,
                      licenseplate.text,
                      reason.text,
                      "W${qrGenId}",
                    );
                    if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                      Navigator.pushNamed(context, '/home');

                      // socket update web
                      socket.send_message('RESIDENT_REQUEST_WHITELIST', 'web');
                    } else {
                      _show_error_toast(res_text);
                    }
                  } else if (classValue == 'blacklist' &&
                      reason.text.isNotEmpty) {
                    String res_text = await services.register_blacklist(
                        firstname.text,
                        lastname.text,
                        licenseplate.text,
                        reason.text);
                    if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                      Navigator.pushNamed(context, '/home');

                      // socket update web
                      socket.send_message('RESIDENT_REQUEST_BLACKLIST', 'web');
                    } else {
                      _show_error_toast(res_text);
                    }
                  } else {
                    _show_error_toast("กรุณาป้อนข้อมูลให้ครบทุกช่อง");
                  }
                } else {
                  _show_error_toast("กรุณาป้อนข้อมูลให้ครบทุกช่อง");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getRandomNumber() {
    Random random = Random();
    List<int> numberList = [];
    String numberString = "";

    while (numberList.length < 20) {
      int length = numberList.length;
      int random_number = random.nextInt(9);

      if (length == 0) {
        numberList.add(random_number);
      } else {
        if (numberList[length - 1] != random_number) {
          numberList.add(random_number);
        }
      }
    }

    for (int i = 0; i < numberList.length; i++) {
      numberString += numberList[i].toString();
    }

    return numberString;
  }

  Future chooseDate() async {
    DateTime chooseDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: bgDialog),
          ),
          child: child,
        );
      },
    );

    if (chooseDateTime != null) {
      setState(() {
        dateTime = chooseDateTime;
      });
    }
  }

  _show_error_toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    licenseplate.dispose();
    reason.dispose();
    super.dispose();
  }
}

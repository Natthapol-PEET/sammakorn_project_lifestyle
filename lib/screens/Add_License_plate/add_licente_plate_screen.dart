import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/success_dialog.dart';
import 'package:registerapp_flutter/controller/add_controlller.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Add_License_plate/service/service.dart';
import 'package:registerapp_flutter/screens/Home/components/show_button_group.dart';
import 'package:registerapp_flutter/screens/ShowQrcode/showQrCodeScreen.dart';
import '../../constance.dart';
import 'components/button_group.dart';
import 'components/date_input.dart';
import 'components/dropdown_item.dart';
import 'components/rount_input_field.dart';
import 'package:intl/intl.dart';

import 'models/screenArg.dart';

class AddLicensePlateScreen extends StatefulWidget {
  const AddLicensePlateScreen({Key key}) : super(key: key);

  @override
  _AddLicensePlateScreenState createState() => _AddLicensePlateScreenState();
}

class _AddLicensePlateScreenState extends State<AddLicensePlateScreen> {
  DateTime dateTime = DateTime.now();
  final fullname = TextEditingController();
  final licenseplate = TextEditingController();
  final idcard = TextEditingController();

  Services services = Services();
  Home home = Home();
  // var socket = SocketManager();

  // Getx controller
  final controller = Get.put(HomeController());
  final addController = Get.put(AddLicenseController());

  // random number
  var rng = Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkgreen200,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldenSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: darkgreen,
        title: Text(
          "ลงทะเบียนเชิญเข้ามาในโครงการ",
          style: TextStyle(
            color: goldenSecondary,
            fontFamily: 'Prompt',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // DropdownItem(
            //   chosenValue: classValue,
            //   onChanged: (value) {
            //     setState(() {
            //       classValue = value;
            //     });
            //   },
            // ),
            DateInput(
              date: DateFormat('dd-MM-yyyy').format(dateTime),
              press: () => chooseDate(),
            ),
            Obx(
              () => DropdownItem(
                chosenValue: addController.classValue.value,
                onChanged: (value) {
                  // setState(() {
                  addController.classValue.value = value;
                  // });
                },
              ),
            ),
            RoundInputField(
              title: "ชื่อ-นามสกุล",
              controller: fullname,
              fullname: fullname.text,
              idcard: idcard.text,
              licenseplate: licenseplate.text,
            ),
            RoundInputField(
              title: "เลขประจำตัวประชาชน",
              controller: idcard,
              fullname: fullname.text,
              idcard: idcard.text,
              licenseplate: licenseplate.text,
            ),
            // RoundInputField(
            //   title: "Last Name",
            //   controller: lastname,
            // ),
            Obx(
              () => addController.classValue.value == "รถ"
                  ? RoundInputField(
                      title: "เลขทะเบียนรถ",
                      controller: licenseplate,
                      fullname: fullname.text,
                      idcard: idcard.text,
                      licenseplate: licenseplate.text,
                    )
                  : Container(),
            ),
            // classValue == "visitor"
            //     ? Container()
            //     : RountInputLarge(
            //         title: "Reason",
            //         controller: reason,
            //       ),
            SizedBox(height: size.height * 0.1),
            Obx(
              () => ButtonGroup(
                save_press: addController.lock.value
                    ? null
                    : () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: bgDialog,
                              content: Container(
                                height: size.height * 0.07,
                                child: Column(
                                  children: [
                                    Text(
                                      'ยืนยันการลงทะเบียนเชิญคนเข้ามาในโครงการหรือไม่?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'Prompt',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                // Button 1 - ยกเลิก
                                Center(
                                  child: ButtonTheme(
                                    minWidth: size.width * 0.6,
                                    height: size.height * 0.06,
                                    child: OutlineButton(
                                      highlightedBorderColor: goldenSecondary,
                                      child: Text(
                                        "ยกเลิก",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Prompt',
                                        ),
                                      ),
                                      borderSide: BorderSide(
                                        color: goldenSecondary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () => Get.back(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),

                                // Button 2 - ยืนยัน
                                Center(
                                  child: ButtonTheme(
                                    minWidth: size.width * 0.6,
                                    height: size.height * 0.06,
                                    child: RaisedButton(
                                      color: goldenSecondary,
                                      child: Text(
                                        "บันทึก",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Prompt',
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () async {
                                        // random number
                                        // String qrGenId = rng.nextInt(9).toString(); // 10 point
                                        String qrGenId = getRandomNumber();

                                        List full = fullname.text.split(" ");
                                        full.removeWhere((item) => item == "");

                                        String firstname = full[0];
                                        String lastname = full[1];

                                        String res_text =
                                            await services.invite_visitor(
                                                firstname,
                                                lastname,
                                                licenseplate.text,
                                                idcard.text,
                                                DateFormat('yyyy-MM-dd')
                                                    .format(dateTime),
                                                "V${qrGenId}");

                                        print(res_text);

                                        if (res_text ==
                                            "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                                          /* Fhase - 1 */
                                          // Timer(Duration(seconds: 1), () {
                                          //   // Dismiss dialog
                                          //   Get.back();
                                          //   // success dialog
                                          //   success_dialog(
                                          //     context,
                                          //     "บันทึกข้อมูลสำเร็จ",
                                          //   );
                                          //   Timer(Duration(seconds: 2), () {
                                          //     // clear variable
                                          //     addController.clear();
                                          //     // Go to home page
                                          //     Get.offNamed('/home');
                                          //   });
                                          // });

                                          /* Fhase - 2 */
                                          Get.offAll(
                                            () => ShowQrcodeScreen(
                                              data: ScreenArguments(
                                                "V${qrGenId}",
                                                DateFormat('yyyy-MM-dd')
                                                    .format(dateTime),
                                                idcard.text,
                                                fullname.text,
                                                licenseplate.text,
                                                addController.classValue.value,
                                              ),
                                            ),
                                          );

                                          // clear variable
                                          addController.clear();

                                          // publish mqtt
                                          controller.publishMqtt(
                                              "app-to-app", "INVITE_VISITOR");
                                          controller.publishMqtt(
                                              "app-to-web", "INVITE_VISITOR");
                                        } else {
                                          _show_error_toast(res_text);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                              ],
                            );
                          },
                        ),
                // save_press: () async {
                //   if (firstname.text.isNotEmpty &&
                //       lastname.text.isNotEmpty &&
                //       licenseplate.text.isNotEmpty) {
                //     if (classValue == 'visitor') {
                //       // random number
                //       // String qrGenId = rng.nextInt(9).toString(); // 10 point
                //       String qrGenId = getRandomNumber();

                //       String res_text = await services.invite_visitor(
                //           firstname.text,
                //           lastname.text,
                //           licenseplate.text,
                //           DateFormat('yyyy-MM-dd').format(dateTime),
                //           "V${qrGenId}");
                //       if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                //         Get.offAll(
                //           () => ShowQrcodeScreen(
                //             data: ScreenArguments(
                //               "Visitor",
                //               licenseplate.text,
                //               DateFormat('yyyy-MM-dd').format(dateTime),
                //               firstname.text,
                //               lastname.text,
                //               "V${qrGenId}",
                //               false,
                //             ),
                //           ),
                //         );

                //         // socket update web
                //         // socket.send_message('INVITE_VISITOR', 'web');

                //         // publish mqtt
                //         controller.publishMqtt("app-to-web", "INVITE_VISITOR");
                //       } else {
                //         _show_error_toast(res_text);
                //       }
                //     } else if (classValue == 'whitelist' &&
                //         reason.text.isNotEmpty) {
                //       // random number
                //       // String qrGenId = rng.nextInt(9).toString(); // 10 point
                //       String qrGenId = getRandomNumber();

                //       String res_text = await services.register_whitelist(
                //         firstname.text,
                //         lastname.text,
                //         licenseplate.text,
                //         reason.text,
                //         "W${qrGenId}",
                //       );
                //       if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                //         Get.toNamed('/home');

                //         // socket update web
                //         // socket.send_message('RESIDENT_REQUEST_WHITELIST', 'web');

                //         // publish mqtt
                //         controller.publishMqtt(
                //             "app-to-web", "RESIDENT_REQUEST_WHITELIST");
                //       } else {
                //         _show_error_toast(res_text);
                //       }
                //     } else if (classValue == 'blacklist' &&
                //         reason.text.isNotEmpty) {
                //       String res_text = await services.register_blacklist(
                //           firstname.text,
                //           lastname.text,
                //           licenseplate.text,
                //           reason.text);
                //       if (res_text == "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                //         Get.toNamed('/home');

                //         // socket update web
                //         // socket.send_message('RESIDENT_REQUEST_BLACKLIST', 'web');

                //         // publish mqtt
                //         controller.publishMqtt(
                //             "app-to-web", "RESIDENT_REQUEST_BLACKLIST");
                //       } else {
                //         _show_error_toast(res_text);
                //       }
                //     } else {
                //       _show_error_toast("กรุณาป้อนข้อมูลให้ครบทุกช่อง");
                //     }
                //   } else {
                //     _show_error_toast("กรุณาป้อนข้อมูลให้ครบทุกช่อง");
                //   }
                // },
              ),
            ),
            SizedBox(height: size.height * 0.05),
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
      // firstDate: DateTime(DateTime.now().year - 5),
      firstDate: DateTime.now(),
      // lastDate: DateTime(DateTime.now().year + 5),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
      initialDate: dateTime,
      // locale : const Locale("th","TH"),
      confirmText: "ตกลง",
      cancelText: "ยกเลิก",
      fieldHintText: "fieldHintText",
      fieldLabelText: "fieldLabelText",
      helpText: "กรุณาเลือกวันที่",
      errorFormatText: "errorFormatText",
      errorInvalidText: "errorInvalidText",
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
      setState(() => dateTime = chooseDateTime);
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
    fullname.dispose();
    licenseplate.dispose();
    idcard.dispose();
    super.dispose();
  }
}

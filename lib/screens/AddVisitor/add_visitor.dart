import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_dialog.dart';
import 'package:registerapp_flutter/components/show_text_check_input.dart';
import 'package:registerapp_flutter/controller/add_controlller.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/service/invite_visitor.dart';
import 'package:registerapp_flutter/screens/ShowQrcode/showQrCodeScreen.dart';
import '../../constance.dart';
import 'components/button_group.dart';
import 'components/date_input.dart';
import 'components/rount_input_field.dart';
import 'package:intl/intl.dart';
import '../../models/screenArg.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({Key? key}) : super(key: key);

  @override
  _AddVisitorScreenState createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  DateTime dateTime = DateTime.now();
  final fullname = TextEditingController();
  final licenseplate = TextEditingController();
  final idcard = TextEditingController();

  // Getx controller
  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginController());
  final selectHomeController = Get.put(SelectHomeController());
  final addController = Get.put(AddVisitorController());

  // random number
  var rng = Random();

  @override
  void initState() {
    addController.lock(true);
    addController.checkFullname(false);
    addController.checkIdCard(true);

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
            DateInput(
              date: DateFormat('dd-MM-yyyy').format(dateTime),
              press: () => chooseDate(),
            ),
            RoundInputField(
              title: "ชื่อ-นามสกุล",
              controller: fullname,
              fullname: fullname.text,
              idcard: idcard.text,
              licenseplate: licenseplate.text,
            ),
            Obx(() => !addController.checkFullname.value
                ? ShowTextCheckInput(text: 'กรุณากรอกชื่อและนามสกุล')
                : Container()),
            RoundInputField(
              title: "หมายเลขประจำตัวประชาชน",
              controller: idcard,
              fullname: fullname.text,
              idcard: idcard.text,
              licenseplate: licenseplate.text,
            ),
            Obx(() => !addController.checkIdCard.value
                ? ShowTextCheckInput(
                    text: 'กรุณากรอกหมายเลขประจำตัวประชาชนให้ครบถ้วน')
                : Container()),
            RoundInputField(
              title: "เลขทะเบียนรถ",
              controller: licenseplate,
              fullname: fullname.text,
              idcard: idcard.text,
              licenseplate: licenseplate.text,
            ),
            SizedBox(height: size.height * 0.1),
            Obx(
              () => ButtonGroup(
                savePress: addController.lock.value
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
                                        String qrGenId = getRandomNumber();

                                        List full = fullname.text.split(" ");
                                        full.removeWhere((item) => item == "");

                                        String firstname = full[0];
                                        String lastname = full[1];

                                        showLoadingDialog();
                                        String resText = await inviteVisitorApi(
                                          firstname,
                                          lastname,
                                          licenseplate.text,
                                          idcard.text,
                                          DateFormat('yyyy-MM-dd')
                                              .format(dateTime),
                                          "V$qrGenId",
                                          loginController.dataLogin!.authToken
                                              as String,
                                          loginController.dataLogin!.residentId
                                              .toString(),
                                          selectHomeController.homeId
                                              .toString(),
                                        );
                                        EasyLoading.dismiss();

                                        if (resText ==
                                            "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว") {
                                          /* Fhase - 1 */
                                          // Timer(Duration(seconds: 1), () {
                                          //   // Dismiss dialog
                                          //   Get.back();
                                          //   // success dialog
                                          //   successDialog(
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
                                                "V$qrGenId",
                                                dateTime,
                                                idcard.text,
                                                fullname.text,
                                                licenseplate.text,
                                                licenseplate.text.length == 0
                                                    ? 'คน'
                                                    : 'รถ',
                                              ),
                                            ),
                                          );

                                          // clear variable
                                          addController.clear();
                                        } else {
                                          showErrorToast(resText);
                                          Get.back();
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
    DateTime? chooseDateTime = await showDatePicker(
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: bgDialog),
          ),
          child: child as Widget,
        );
      },
    );

    if (chooseDateTime != null) {
      setState(() => dateTime = chooseDateTime);
    }
  }

  showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
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

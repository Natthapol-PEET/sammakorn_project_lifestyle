import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import '../../constance.dart';

class ShowQrcodeScreen extends StatefulWidget {
  const ShowQrcodeScreen({Key key, @required this.data}) : super(key: key);
  final data;

  // const ShowQrcodeScreen({Key key}) : super(key: key);

  @override
  _ShowQrcodeScreenState createState() => _ShowQrcodeScreenState();
}

class _ShowQrcodeScreenState extends State<ShowQrcodeScreen> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  String licensePlate, date, fnmae, lname, type;
  bool isScreenshot = false;

  @override
  void initState() {
    super.initState();

    // licensePlate = widget.data.licensePlate;
    // date = widget.data.date;
    // fnmae = widget.data.firstname;
    // lname = widget.data.lastname;
    // type = widget.data.type;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: darkgreen,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/Artani Logo Ai B-01.png',
                  width: size.width * 0.15,
                ),
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // head box ui
                    Container(
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: goldenSecondary,
                      ),
                    ),
                    // component 1 - title text
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      child: Center(
                        child: Text(
                          "ลงทะเบียนเชิญเข้ามาในโครงการสำเร็จ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Prompt',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // component 2 - qr code
                    Container(
                      color: darkgreen,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: size.height * 0.03),
                      child: QrImage(
                        data: widget.data.qrGenId,
                        size: size.width * 0.6,
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                        // gapless: false,
                      ),
                    ),

                    // component 3 - details
                    SubTitle(
                      subTitle: "วันที่นัดหมาย",
                      desc: widget.data.date,
                    ),
                    SubTitle(
                      subTitle: "เลขประจำตัวประชาชน",
                      desc: widget.data.idcard,
                    ),
                    SubTitle(
                      subTitle: "ชื่อ-นามสกุล",
                      desc: widget.data.fullname,
                    ),
                    SubTitle(
                      subTitle: "เลขทะเบียนรถ",
                      desc: widget.data.licensePlate.isNotEmpty ? widget.data.licensePlate : '-',
                    ),
                    SubTitle(
                      subTitle: "ประเภท",
                      desc: widget.data.type,
                    ),

                    if (!isScreenshot) ...[
                      SizedBox(height: size.height * 0.02),
                      // component 4 - share button
                      RoundButton(
                        text: "แชร์",
                        colorText: backtoHomeBtnColor,
                        colorButton: Colors.white,
                        press: () {
                          setState(() => isScreenshot = true);
                          _takeScreenshot();
                        },
                      ),

                      // component 5 - redirec to home button
                      RoundButton(
                        text: "กลับหน้าหลัก",
                        colorText: Colors.white,
                        colorButton: backtoHomeBtnColor,
                        press: () => Get.toNamed('/home'),
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],

                    if (isScreenshot) ...[SizedBox(height: size.height * 0.03)],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _takeScreenshot() async {
    // capture image
    final image = await screenshotController.capture();
    // get directory
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/image.png').create();
    await imagePath.writeAsBytes(image);

    print(imagePath.path);

    // Share Plugin
    Share.shareFiles([imagePath.path]);

    setState(() => isScreenshot = false);
  }

  Future<bool> onWillPop() {
    // return Future.value(widget.data.isBack);
    return Future.value(false);
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({
    Key key,
    @required this.subTitle,
    @required this.desc,
  }) : super(key: key);

  final String subTitle;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: size.width * 0.7,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Prompt',
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                desc,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Prompt',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key key,
    @required this.text,
    @required this.colorText,
    @required this.colorButton,
    @required this.press,
  }) : super(key: key);

  final String text;
  final Color colorText;
  final Color colorButton;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 50,
        width: size.width * 0.7,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorButton, // bg color
            side: BorderSide(
              width: 1.5,
              color: backtoHomeBtnColor,
            ),
            // elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorText,
              fontFamily: 'Prompt',
            ),
          ),
        ),
      ),
    );
  }
}

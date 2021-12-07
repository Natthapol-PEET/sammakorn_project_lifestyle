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

    licensePlate = widget.data.licensePlate;
    date = widget.data.date;
    fnmae = widget.data.firstname;
    lname = widget.data.lastname;
    type = widget.data.type;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: darkgreen,
        body: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Screenshot(
            controller: screenshotController,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: goldenSecondary,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 80, bottom: 30, left: 30, right: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.23,
                  child: Container(
                    color: darkgreen,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: QrImage(
                        data: widget.data.qrGenId,
                        size: 230,
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                        // gapless: false,
                      ),
                    ),
                  ),
                ),
                if (isScreenshot) ...[
                  Positioned(
                    top: size.height * 0.63,
                    child: Icon(Icons.verified_user,
                        size: 160, color: Colors.grey[100]),
                  ),
                ],
                if (!isScreenshot) ...[
                  Positioned(
                    top: size.height * 0.74,
                    child: Column(
                      children: [
                        RoundButton(
                          text: "Share",
                          colorText: darkgreen200,
                          colorButton: Colors.white,
                          press: () {
                            setState(() => isScreenshot = true);
                            _takeScreenshot();
                          },
                        ),
                        RoundButton(
                          text: "Back to Home",
                          colorText: Colors.white,
                          colorButton: darkgreen200,
                          press: () => Get.toNamed('/home'),
                        ),
                      ],
                    ),
                  ),
                ],
                Positioned(
                  top: size.height * 0.13,
                  child: Column(
                    children: [
                      Text("You invite completed",
                          style: TextStyle(fontSize: 22)),
                      Text("successfully", style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
                Positioned(
                  top: size.height * 0.55,
                  child: Column(
                    children: [
                      Text(licensePlate,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      SubTitle(
                        subTitle: "Type",
                        desc: type,
                      ),
                      SubTitle(
                        subTitle: "Date",
                        desc: date,
                      ),
                      SubTitle(
                        subTitle: "Firstname",
                        desc: fnmae,
                      ),
                      SubTitle(
                        subTitle: "Lastname",
                        desc: lname,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    return Future.value(widget.data.isBack);
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(subTitle, style: TextStyle(fontSize: 16)),
            Text(desc, style: TextStyle(fontSize: 16)),
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
            primary: colorButton,
            side: BorderSide(
              width: 2,
              color: darkgreen200,
            ),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorText,
            ),
          ),
        ),
      ),
    );
  }
}

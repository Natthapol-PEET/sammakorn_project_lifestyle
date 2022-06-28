import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/screens/Login/components/backgroud.dart';
import 'package:registerapp_flutter/service/socket_service.dart';
import 'package:registerapp_flutter/service/update_home.dart';
import '../../constance.dart';

class SelectHomeScreen extends StatefulWidget {
  const SelectHomeScreen({Key? key}) : super(key: key);

  @override
  State<SelectHomeScreen> createState() => _SelectHomeScreenState();
}

class _SelectHomeScreenState extends State<SelectHomeScreen> {
  final selectHomeController = Get.put(SelectHomeController());
  final loginController = Get.put(LoginController());
  final homeController = Get.put(HomeController());
  
  SocketService socketService = SocketService();

  @override
  void initState() {
    selectHomeController.getHome(true, false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Backgroud(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1),
                SelectTitle(),
                SizedBox(height: size.height * 0.025),
                Container(
                  width: size.width,
                  height: size.height * 0.85,
                  decoration: BoxDecoration(
                    color: greenPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.03),
                        DetailText(),
                        GetBuilder<SelectHomeController>(builder: (_) {
                          return selectHomeController.isLoading.value == false
                              ? ListView.builder(
                                  itemCount:
                                      selectHomeController.listItem.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SelectButton(
                                      text:
                                          selectHomeController.listItem[index],
                                      press: () =>
                                          selectHomeController.setIndex(index),
                                      selectIndex: selectHomeController
                                          .selectIndex.value,
                                      index: index,
                                    );
                                  },
                                )
                              : Container();
                        }),
                        SizedBox(height: size.height * 0.05),
                        RoundedButton(
                          text: "เลือกโครงการ",
                          press: () async {
                            // init service
                            homeController.onInit();

                            // update home rest
                            updateHomeRestApi(
                                loginController.dataLogin!.authToken as String,
                                loginController.dataLogin!.residentId as int,
                                selectHomeController.homeId.value);

                            // init socket
                            socketService.startSocketClient(
                                selectHomeController.homeId.value);

                            Get.offNamed('/home');
                          },
                        ),
                        SizedBox(height: size.height * 0.08),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }
}

class SelectTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        'เลือกโครงการ',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w500,
          fontFamily: "Prompt",
        ),
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        'เลือกโครงการที่ต้องการใช้งานระบบ',
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFFB8B7B2),
          // fontWeight: FontWeight.w500,
          fontFamily: "Prompt",
        ),
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  final String? text;
  final Function()? press;
  final Color color, textColor;
  final double topSize;
  final int? selectIndex;
  final int? index;

  const SelectButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = greenYellow,
    this.textColor = Colors.white,
    this.topSize = 20,
    this.index,
    this.selectIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: topSize),
        width: size.width * 0.9,
        height: size.height * 0.06,
        child: FlatButton(
          color: index == selectIndex ? color : greenPrimary,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: goldenSecondary,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: press,
          child: Row(
            children: [
              Text(
                text ?? '',
                style: TextStyle(
                  color: index == selectIndex ? Colors.white : goldenSecondary,
                  fontSize: 18,
                  fontFamily: 'Prompt',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

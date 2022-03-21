import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/rounded_button.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/screens/Login/components/backgroud.dart';
import 'package:registerapp_flutter/screens/Select_Home/service/update_home.dart';
import '../../constance.dart';
import 'components/dropdown_item.dart';

// ignore: must_be_immutable
class SelectHomeScreen extends StatelessWidget {
  SelectHomeScreen({Key key}) : super(key: key);

  final controller = Get.put(SelectHomeController());
  final homeController = Get.put(HomeController());

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
                          return controller.isLoading.value == false
                              ? ListView.builder(
                                  itemCount: controller.listItem.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SelectButton(
                                      text: controller.listItem[index],
                                      press: () {
                                        controller.setIndex(index);
                                      },
                                      selectIndex: controller.selectIndex.value,
                                      index: index,
                                    );
                                  },
                                )
                              : Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    height: 150,
                                    padding:
                                        EdgeInsets.fromLTRB(100, 50, 100, 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black54,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Loading ...',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        }),
                        SizedBox(height: size.height * 0.05),
                        RoundedButton(
                          text: "ตกลง",
                          press: () async {
                            //  updateHome
                            int findId = controller.listItem.indexWhere(
                                (item) => item
                                    .startsWith(controller.selectHome.value));

                            await controller.home.updateHome(
                              controller.selectHome.value,
                              controller.homeIds[findId].toString(),
                            );

                            // init service
                            homeController.onInit();

                            // update home rest
                            update_home_rest();

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
      // child: Scaffold(
      //   backgroundColor: darkgreen,
      //   body: Obx(
      //     () => Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Column(
      //           children: [
      //             controller.isLoading.value == false
      //                 ? DropdownItem(
      //                     listItem: controller.listItem.value,
      //                     chosenValue: controller.selectHome.value,
      //                     onChanged: (value) {
      //                       controller.selectHome.value = value;
      //                     },
      //                   )
      //                 : Dialog(
      //                     backgroundColor: Colors.transparent,
      //                     child: Container(
      //                       height: 150,
      //                       padding: EdgeInsets.fromLTRB(100, 50, 100, 20),
      //                       decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(12),
      //                         color: Colors.black54,
      //                       ),
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         crossAxisAlignment: CrossAxisAlignment.center,
      //                         children: [
      //                           CircularProgressIndicator(
      //                             color: Colors.white,
      //                           ),
      //                           SizedBox(height: 20),
      //                           Text(
      //                             'Loading ...',
      //                             style: TextStyle(color: Colors.white),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //           ],
      //         ),
      //         SizedBox(height: 20),
      //         ElevatedButton(
      //           style: ButtonStyle(
      //               backgroundColor: MaterialStateProperty.all(greenYellow)),
      //           onPressed: () async {
      //             // updateHome
      //             int findId = controller.listItem.indexWhere(
      //                 (item) => item.startsWith(controller.selectHome.value));

      //             await controller.home.updateHome(
      //               controller.selectHome.value,
      //               controller.homeIds[findId].toString(),
      //             );

      //             // init service
      //             homeController.onInit();

      //             Get.offNamed('/home');
      //           },
      //           child: Text(
      //             'ไปที่หน้าแรก',
      //             style: TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.w500,
      //               fontFamily: "Prompt",
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
  final String text;
  final Function press;
  final Color color, textColor;
  final double topSize;
  final int selectIndex;
  final int index;

  const SelectButton({
    Key key,
    @required this.text,
    @required this.press,
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
                text,
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

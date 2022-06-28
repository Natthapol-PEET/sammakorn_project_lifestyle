import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/notification_controller.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/box_show_list.dart';
import 'components/builder_history.dart';
import 'components/button_select_group.dart';
import 'components/floating_button_group.dart';
import 'components/list_project.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());
  final notificaionController = Get.put(NotificationController());

  final arg = Get.arguments;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) => set());
  }

  void set() {
    if (arg == 'noti_screen') {
      controller.selectIndex.value = 1;
      controller.setSelectIndex(1);
    } else {
      controller.selectIndex.value = 0;
      controller.setSelectIndex(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: darkgreen200,
        appBar: AppBar(
          title: Obx(
            () => AppBarTitle(
              title: controller.title,
              titleIndex: controller.allHome
                  .indexWhere((note) => note.startsWith(controller.title)),
              press: () => Get.toNamed('/logout'),
            ),
          ),
          backgroundColor: darkgreen,
          automaticallyImplyLeading: false,
          actions: [
            Obx(
              () => AppBarAction(
                  countAlert: notificaionController.countAlert.value.toString(),
                  pass: () async {
                    final result = await Get.toNamed('/notification');

                    if (result == null || result == "Yep!") {
                      notificaionController.countAlert.value = 0;
                      notificaionController.updateNotification();
                    }
                  }),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (controller.allHome.length == 1) ...[
                  Container(
                    width: size.width,
                    height: size.height * 0.18,
                    child: Image.asset(
                      projectImages[controller.allHome.indexWhere(
                          (note) => note.startsWith(controller.title))],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  )
                ],

                if (controller.allHome.length > 1) ...[
                  SizedBox(height: size.height * 0.03),
                  buildHomeSlide(context, controller.allHome),
                ],

                SizedBox(height: size.height * 0.03),
                ButtonSelectGroup(
                  selectColorElem: controller.selectColorElem,
                  selectColorButton: controller.selectColorButton,
                  press1: () => controller.setSelectIndex(0),
                  press2: () => controller.setSelectIndex(1),
                  press3: () => controller.setSelectIndex(2),
                  press4: () => controller.setSelectIndex(3),
                ),

                // Invite - เชิญเข้ามา
                if (controller.selectIndex.value == 0) ...[
                  Obx(() => BoxShowList(
                        lists: controller.inviteList.value,
                        color: inviteColor,
                      )),
                ],

                // Coming in - เข้ามาแล้ว
                if (controller.selectIndex.value == 1) ...[
                  Obx(() => BoxShowList(
                        lists: controller.commingList.value,
                        color: comingColor,
                      )),
                ],

                // Stamp - แสตมป์
                if (controller.selectIndex.value == 2) ...[
                  Obx(() => BoxShowList(
                        lists: controller.stampList.value,
                        color: stampColor,
                      )),
                ],

                // History - ประวัติ
                if (controller.selectIndex.value == 3) ...[
                  Obx(() => BoxShowListHistory(
                        lists: controller.historyList.value,
                        color: Colors.white,
                      )),
                ],
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingButtonGroup(),
      ),
    );
  }

  Widget buildHomeSlide(BuildContext context, List lists) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.15,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lists.length,
          itemBuilder: (context, index) {
            if (index == lists.length - 1) {
              return Row(
                children: [
                  ListProject(
                    title: lists[index],
                    index: index,
                  ),
                  SizedBox(width: size.height * 0.03),
                ],
              );
            } else {}
            return ListProject(
              title: lists[index],
              index: index,
            );
          }),
    );
  }

  late DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }

    Fluttertoast.showToast(msg: "Close Application");
    SystemNavigator.pop();
    return Future.value(true);
  }
}

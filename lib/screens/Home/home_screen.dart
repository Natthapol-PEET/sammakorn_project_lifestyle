import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/data/notification.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/box_show_list.dart';
import 'components/builder_history.dart';
import 'components/button_select_group.dart';
import 'components/floating_button_group.dart';
import 'components/list_project.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  final arg = Get.arguments;

  @override
  void initState() {
    controller.fetchApi();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => set());
  }

  void set() {
    if (arg == 'noti_screen') {
      controller.selectIndex.value = 1;
      controller.setSelectIndex(1);
    } else {
      // reset button group
      controller.selectIndex.value = 0;
      controller.setSelectIndex(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        children: [
          Scaffold(
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
                // GetBuilder(
                //   builder: (_) => AppBarAction(
                //       countAlert: controller.countAlert.value,
                //       pass: () async {
                //         final result = await Get.toNamed('/notification');

                //         if (result == null || result == "Yep!") {
                //           // refresh
                //           controller.countAlert.value = "0";
                //         }
                //       }),
                // ),
                Obx(
                  () => AppBarAction(
                      countAlert: controller.countAlert.value,
                      pass: () async {
                        final result = await Get.toNamed('/notification');

                        if (result == null || result == "Yep!") {
                          // refresh
                          controller.countAlert.value = "0";

                          NotificationDB notifications = NotificationDB();
                          notifications.updateNotification();
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
                          // height: double.infinity,
                          // width: double.infinity,
                          alignment: Alignment.center,
                        ),
                      )
                    ],

                    if (controller.allHome.length > 1) ...[
                      SizedBox(height: size.height * 0.03),
                      build_HomeSlide(context, controller.allHome),
                    ],

                    SizedBox(height: size.height * 0.03),
                    ButtonSelectGroup(
                      selectColorElem: controller.selectColorElem,
                      selectColorButton: controller.selectColorButton,
                      press1: () => controller.setSelectIndex(0),
                      press2: () => controller.setSelectIndex(1),
                      press3: () => controller.setSelectIndex(2),
                      press4: () => controller.setSelectIndex(3),
                      press5: () => controller.setSelectIndex(4),
                    ),

                    // Invite - เชิญเข้ามา
                    if (controller.selectIndex.value == 0) ...[
                      BoxShowList(
                        lists: controller.licensePlateInvite.value,
                        color: Color(0xffB5C21D),
                        select: "Invite",
                      ),
                    ],

                    // Coming in - เข้ามาแล้ว
                    if (controller.selectIndex.value == 1) ...[
                      BoxShowList(
                        lists: controller.coming_walk.value,
                        color: Color(0xffF4AD43),
                        select: "coming_walk",
                      ),
                    ],

                    // Stamp - แสตมป์
                    if (controller.selectIndex.value == 2) ...[
                      BoxShowList(
                        lists: controller.resident_stamp_list.value,
                        color: Color(0xff12976F),
                        select: "Resident stamp",
                        resident_send_admin:
                            controller.resident_send_admin_stamp.value,
                        selectRSA: "Wait Admin",
                        pms_show: controller.pms_list.value,
                        selectPMS: "Admin done",
                        checkout: controller.checkout_list.value,
                        selectCO: "Leaving",
                      ),
                    ],

                    // List Item
                    // if (controller.selectIndex.value == 3) ...[
                    //   ListItemBlacklistWhitelist(
                    //     lists: controller.white_black_list.value,
                    //     select: "List Item",
                    //   ),
                    // ],

                    // History - ประวัติ
                    if (controller.selectIndex.value == 4) ...[
                      BoxShowListHistory(
                        lists: controller.history_list.value,
                        color: Colors.white,
                        select: "history",
                      ),
                    ],
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingButtonGroup(),
          ),
          Obx(
            () => controller.loading.value
                ? Positioned.fill(
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        height: 150,
                        padding: EdgeInsets.fromLTRB(100, 50, 100, 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black54,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget build_HomeSlide(BuildContext context, List lists) {
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

  Widget build_History(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['datetime_in'].split('T')[0],
            license_plate: lists[index]['license_plate'],
            color: fededWhite,
            press: () {
              lists[index]['select'] = "history";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
          );
        });
  }

  DateTime currentBackPressTime;
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

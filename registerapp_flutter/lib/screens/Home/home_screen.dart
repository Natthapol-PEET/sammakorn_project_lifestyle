import 'dart:async';
import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/data/notification.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/service/fcm.dart';
import 'package:registerapp_flutter/service/push_notification.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/dialog.dart';
import 'components/floating_button_group.dart';
import 'components/list_project.dart';
import 'components/list_tab_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PopupDialog popupDialog = PopupDialog();
  Services services = Services();
  Home home = Home();
  PushNotification pushNotification = PushNotification();
  FCM fcm = FCM();
  FirebaseMessaging messaging;
  NotificationDB notifications = NotificationDB();

  String title = "";
  int countAlert;
  List licensePlateInvite = [];
  List coming_walk = [];
  List resident_stamp_list = [];
  List resident_send_admin_stamp = [];
  List pms_list = [];
  List checkout_list = [];
  List history_list = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    getHomeSlide();

    getCountAlert();
    getHome();

    Future.delayed(Duration(milliseconds: 500), () => getLicenseInvite());
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   getLicenseInvite();
    // });

    coming_and_walk();
    get_resident_stamp();

    Future.delayed(Duration(milliseconds: 500), () => resident_send_admin());

    pms_show();
    checkout();

    getHistory();
  }

  List allHome = [];
  getHomeSlide() async {
    var data = await services.getHome();
    // home_id = data[1];

    if (data[0] == -1) {
      print("services error");
    } else {
      setState(() {
        allHome = data[0];
      });
    }
  }

  Widget build_HomeSlide(BuildContext context, List lists) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.15,
      child: ListView.builder(
          // physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          itemCount: lists.length,
          itemBuilder: (context, index) {
            return ListProject(
              title: lists[index],
              index: index,
            );
            // return ListItemField(
            //   date: lists[index]['datetime_in'].split('T')[0],
            //   license_plate: lists[index]['license_plate'],
            //   color: fededWhite,
            //   press: () {
            //     lists[index]['select'] = "history";
            //     Navigator.pushNamed(context, '/show_detail',
            //         arguments: lists[index]);
            //   },
            // );
          }),
    );
  }

  getCountAlert() async {
    int count = await notifications.getCountNotification();
    setState(() => countAlert = count);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double bsize = 65.0;
    double horsize = 12.0;

    List<Color> selectColorButton = [
      goldenSecondary,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];

    List<Color> selectColorElem = [
      Colors.white,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
    ];

    List icons = [
      Icons.mobile_friendly,
      Icons.airport_shuttle,
      Icons.approval,
      Icons.fact_check,
      Icons.history,
    ];

    List<String> titleButton = [
      'Invite',
      'Coming in',
      'Stamp',
      'List Item',
      'History',
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: darkgreen200,
          appBar: AppBar(
            title: AppBarTitle(title: title),
            backgroundColor: darkgreen,
            automaticallyImplyLeading: false,
            actions: [
              AppBarAction(
                  countAlert: countAlert,
                  pass: () async {
                    final result =
                        await Navigator.pushNamed(context, '/notification');

                    if (result == null || result == "Yep!") {
                      // refresh
                      setState(() => countAlert = 0);
                    }
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.03),
                build_HomeSlide(context, allHome),
                SizedBox(height: size.height * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: bsize, height: bsize),
                      child: ElevatedButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.mobile_friendly,
                                color: selectColorElem[0]),
                            SizedBox(height: 5),
                            Text(
                              'Invite',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: selectColorElem[0]),
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: selectColorButton[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: horsize),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: bsize, height: bsize),
                      child: ElevatedButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.airport_shuttle,
                                color: selectColorElem[1]),
                            SizedBox(height: 5),
                            Text(
                              'Coming in',
                              style: TextStyle(
                                fontSize: 9,
                                color: selectColorElem[1],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: selectColorButton[1],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: horsize),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: bsize, height: bsize),
                      child: ElevatedButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.approval, color: selectColorElem[2]),
                            SizedBox(height: 5),
                            Text('Stamp',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: selectColorElem[2],
                                )),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: selectColorButton[2],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: horsize),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: bsize, height: bsize),
                      child: ElevatedButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.fact_check, color: selectColorElem[3]),
                            SizedBox(height: 5),
                            Text(
                              'List Item',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: selectColorElem[3],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: selectColorButton[3],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: horsize),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: bsize, height: bsize),
                      child: ElevatedButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.history, color: selectColorElem[4]),
                            SizedBox(height: 5),
                            Text('History',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: selectColorElem[4],
                                )),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: selectColorButton[4],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: size.height * 0.68,
                    decoration: BoxDecoration(
                      color: darkgreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: ListTabBar(
                //     build_licensePLateInvite:
                //         build_licensePLateInvite(context, licensePlateInvite),
                //     build_comingAndWalk:
                //         build_comingAndWalk(context, coming_walk),
                //     build_resident_stamp:
                //         build_resident_stamp(context, resident_stamp_list),
                //     build_resident_send_admin: build_resident_send_admin(
                //         context, resident_send_admin_stamp),
                //     build_pms_show: build_pms_show(context, pms_list),
                //     build_checkout: build_checkout(context, checkout_list),
                //     history: build_History(context, history_list),
                //   ),
                // ),
              ],
            ),
          ),
          floatingActionButton: FloatingButtonGroup()),
    );
  }

  getHome() async {
    String _home = await home.getHome();
    setState(() => title = _home);
  }

  getLicenseInvite() async {
    List data = await services.getLicenseInvite();
    setState(() => licensePlateInvite = data);
  }

  Widget build_licensePLateInvite(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['license_plate'],
            license_plate: "Invite",
            color: fededWhite1,
            press: () {
              // popupDialog.invite_dialog(context, licensePlateInvite[index], () {
              //   var state = services.deleteInvite(
              //       licensePlateInvite[index]['visitor_id'].toString());
              //   state.then((v) => getLicenseInvite());
              //   Navigator.pop(context);
              // });

              lists[index]['select'] = "Invite";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
          );
        });
  }

  coming_and_walk() async {
    var data = await services.coming_and_walk();
    setState(() => coming_walk = data);
  }

  Widget build_comingAndWalk(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['license_plate'],
            license_plate: lists[index]['status'],
            color: greenYellow,
            press: () {
              // popupDialog.walkin_comingin_dialog(context, coming_walk[index],
              //     () {
              //   var state = services
              //       .resident_stamp(coming_walk[index]['log_id'].toString());
              //   state.then((v) {
              //     coming_and_walk();
              //     get_resident_stamp();
              //   });
              //   Navigator.pop(context);
              // });

              lists[index]['select'] = "coming_walk";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
          );
        });
  }

  get_resident_stamp() async {
    var data = await services.get_resident_stamp();
    setState(() => resident_stamp_list = data);
  }

  Widget build_resident_stamp(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
              date: lists[index]['license_plate'],
              license_plate: "Resident stamp",
              color: fededWhite,
              press: () {
                // popupDialog.resident_dialod(context, resident_stamp_list[index], () {
                //   var state = services.send_admin_stamp(
                //       resident_stamp_list[index]['log_id'].toString());
                //   state.then((v) {
                //     get_resident_stamp();
                //     // PMS stamp
                //   });
                //   Navigator.pop(context);
                // });

                lists[index]['select'] = "Resident stamp";
                Navigator.pushNamed(context, '/show_detail',
                    arguments: lists[index]);
              });
        });
  }

  resident_send_admin() async {
    var data = await services.get_resident_send_admin();
    setState(() => resident_send_admin_stamp = data);
  }

  Widget build_resident_send_admin(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['license_plate'],
            license_plate: "Wait Admin",
            color: fededWhite,
            press: () {
              lists[index]['select'] = "send to admin";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
          );
        });
  }

  pms_show() async {
    var data = await services.pms_show();
    setState(() => pms_list = data);
  }

  Widget build_pms_show(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['license_plate'],
            license_plate: "Admin done",
            color: fededWhite,
            press: () {
              lists[index]['select'] = "Admin done";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
          );
        });
  }

  checkout() async {
    var data = await services.checkout();
    setState(() => checkout_list = data);
  }

  Widget build_checkout(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
            date: lists[index]['license_plate'],
            license_plate: "Leaving",
            color: fededWhite,
            press: () {
              lists[index]['select'] = "Leaving";
              Navigator.pushNamed(context, '/show_detail',
                  arguments: lists[index]);
            },
          );
        });
  }

  getHistory() async {
    var data = await services.getHistory();
    setState(() => history_list = data);
  }

  Widget build_History(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          // return ListItemField(
          //   date: lists[index]['datetime_in'],
          //   license_plate: lists[index]['license_plate'],
          //   color: fededWhite,
          // );
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

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

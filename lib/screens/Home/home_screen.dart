import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/data/notification.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/service/device_id.dart';
import 'package:registerapp_flutter/service/fcm.dart';
import 'package:registerapp_flutter/service/push_notification.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/box_show_list.dart';
import 'components/builder_history.dart';
import 'components/button_select_group.dart';
import 'components/dialog.dart';
import 'components/floating_button_group.dart';
import 'components/list_project.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'components/timeline_blacklist_whitelist.dart';
import 'function/selectIndex.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Home home = Home();
  Auth auth = Auth();
  PopupDialog popupDialog = PopupDialog();
  Services services = Services();
  PushNotification pushNotification = PushNotification();
  FCM fcm = FCM();
  FirebaseMessaging messaging;
  NotificationDB notifications = NotificationDB();

  String title = "";
  int countAlert = 0;
  List licensePlateInvite = [];
  List coming_walk = [];
  List resident_stamp_list = [];
  List resident_send_admin_stamp = [];
  List pms_list = [];
  List checkout_list = [];
  List white_black_list = [];
  List history_list = [];
  List allHome = [];

  // menu variable
  int selectIndex = 0;

  // loading dialog variable
  BuildContext dialogContext;

  // socket variable
  IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Project of homeId
    getHomeSlide();

    // ทุกครั้งที่มีแจ้งเตือนเข้ามา [topic ALERT_MESSAGE]
    getCountAlert();

    // title screen
    getHome();

    // List Item -> history
    getHistory();

    // ทุกครั้งที่มีรถ coming in (not walk in) [topic COMING_IN]
    Future.delayed(Duration(milliseconds: 2000), () => getLicenseInvite());
    coming_and_walk();

    // resident stamp -> load new screen
    get_resident_stamp();

    // multiclient (application) [RESIDENT_SEND_STAMP] {app -> app}
    // [RESIDENT_SEND_STAMP] {web -> app}
    Future.delayed(Duration(milliseconds: 2000), () => resident_send_admin());

    // admin operation -> all status
    Future.delayed(Duration(milliseconds: 2000), () => pms_show());

    // PMS -> checkout || resident stamp -> checkout
    // [CHECKOUT] {web -> app}
    checkout();

    // whitelist and blacklist -> all status
    get_white_black();

    // loading dialog
    Future.delayed(Duration.zero, () => showLoading());
    Future.delayed(Duration(seconds: 3), () => Navigator.pop(dialogContext));

    // realtime update data
    socket();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Color> selectColorButton = SelectIndexButton(selectIndex);
    List<Color> selectColorElem = SelectIndexElem(selectIndex);

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: darkgreen200,
          appBar: AppBar(
            title: AppBarTitle(
                title: title,
                press: () async {
                  Navigator.pushNamed(context, '/logout');
                }),
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
                ButtonSelectGroup(
                  selectColorElem: selectColorElem,
                  selectColorButton: selectColorButton,
                  press1: () => setState(() => selectIndex = 0),
                  press2: () => setState(() => selectIndex = 1),
                  press3: () => setState(() => selectIndex = 2),
                  press4: () => setState(() => selectIndex = 3),
                  press5: () => setState(() => selectIndex = 4),
                ),

                // Invite
                if (selectIndex == 0) ...[
                  BoxShowList(
                    lists: licensePlateInvite,
                    color: Color(0xffB5C21D),
                    select: "Invite",
                  ),
                ],

                // Coming in
                if (selectIndex == 1) ...[
                  BoxShowList(
                    lists: coming_walk,
                    color: Color(0xffF4AD43),
                    select: "coming_walk",
                  ),
                ],

                // Stamp
                if (selectIndex == 2) ...[
                  BoxShowList(
                    lists: resident_stamp_list,
                    color: Color(0xff12976F),
                    select: "Resident stamp",
                    resident_send_admin: resident_send_admin_stamp,
                    selectRSA: "Wait Admin",
                    pms_show: pms_list,
                    selectPMS: "Admin done",
                    checkout: checkout_list,
                    selectCO: "Leaving",
                  ),
                ],

                // List Item
                if (selectIndex == 3) ...[
                  ListItemBlacklistWhitelist(
                    lists: white_black_list,
                    select: "List Item",
                  ),
                ],

                // History
                if (selectIndex == 4) ...[
                  BoxShowListHistory(
                    lists: history_list,
                    color: Colors.white,
                    select: "history",
                  ),
                ],
              ],
            ),
          ),
          floatingActionButton: FloatingButtonGroup()),
    );
  }

  socket() async {
    var data = await auth.getToken();
    String token = data[0]['TOKEN'];
    String homeId = await home.getHomeId();
    String deviceId = await Device().getId();

    try {
      channel = IOWebSocketChannel.connect(
          Uri.parse('${WS}/ws/${token}/app/${homeId}/${deviceId}'));

      // -------------------- refresh components -----------------------
      channel.stream.listen((msg) {
        print(msg);

        if (msg == "ALERT_MESSAGE") {
          // ทุกครั้งที่มีแจ้งเตือนเข้ามา [topic ALERT_MESSAGE] {web -> app}
          Future.delayed(Duration(milliseconds: 1000), () => getCountAlert());
        } else if (msg == "COMING_WALK_IN") {
          // ทุกครั้งที่มีรถ coming in and walk in [topic COMING_WALK_IN] {web -> app}
          Future.delayed(
              Duration(milliseconds: 1000), () => getLicenseInvite());
          Future.delayed(Duration(milliseconds: 1000), () => coming_and_walk());
        } else if (msg == "RESIDENT_STAMP") {
          // multiclient (application) [topic RESIDENT_STAMP] {app -> app}
          Future.delayed(
              Duration(milliseconds: 1000), () => get_resident_stamp());
        } else if (msg == "RESIDENT_SEND_STAMP") {
          // multiclient (application) [RESIDENT_SEND_STAMP] {app -> app}
          // [RESIDENT_SEND_STAMP] {web -> app}
          Future.delayed(
              Duration(milliseconds: 1000), () => resident_send_admin());
        } else if (msg == "ADMIN_OPERATION") {
          // Admin operation -> all status [topic ADMIN_OPERATION]  {web -> app}
          // Future.delayed(Duration(milliseconds: 2000), () {
          //   resident_send_admin();
          //   pms_show();
          // });
          resident_send_admin();
          pms_show();
        } else if (msg == "CHECKOUT") {
          // PMS -> checkout || resident stamp -> checkout
          // [CHECKOUT] {web -> app}
          Future.delayed(Duration(milliseconds: 1000), () {
            get_resident_stamp();
            pms_show();
            checkout();
          });
        } else if (msg == "ADMIN_OP_BLACKWHITE") {
          // Admin operation whitelist and blacklist (application) [ADMIN_OP_BLACKWHITE]
          Future.delayed(Duration(milliseconds: 1000), () => get_white_black());
        } else if (msg == "RESIDENT_REQUEST_WHITEBLACK") {
          Future.delayed(Duration(milliseconds: 1000), () => get_white_black());
        }
      });
    } catch (e) {}
  }

  getCountAlert() async {
    int count = await notifications.getCountNotification();
    setState(() => countAlert = count);
  }

  getHomeSlide() async {
    var data = await services.getHome();
    if (data[0] == -1) {
      // print("services error");
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
          scrollDirection: Axis.horizontal,
          itemCount: lists.length,
          itemBuilder: (context, index) {
            return ListProject(
              title: lists[index],
              index: index,
            );
          }),
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

  coming_and_walk() async {
    var data = await services.coming_and_walk();
    setState(() => coming_walk = data);
  }

  get_resident_stamp() async {
    var data = await services.get_resident_stamp();
    setState(() => resident_stamp_list = data);
  }

  resident_send_admin() async {
    var data = await services.get_resident_send_admin();
    setState(() => resident_send_admin_stamp = data);
  }

  pms_show() async {
    var data = await services.pms_show();
    setState(() => pms_list = data);
  }

  checkout() async {
    var data = await services.checkout();
    setState(() => checkout_list = data);
  }

  get_white_black() async {
    var data = await services.getListItems();
    setState(() => white_black_list = data);
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

  showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return Dialog(
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
    return Future.value(true);
  }

  @override
  dispose() {
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    channel.sink.close(status.goingAway);
  }
}

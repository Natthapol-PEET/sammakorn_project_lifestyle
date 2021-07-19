import 'dart:async';
import 'package:flutter/material.dart';
import 'package:registerapp_flutter/components/list_item_field_container.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import '../../constance.dart';
import 'components/app_bar_action.dart';
import 'components/app_bar_title.dart';
import 'components/dialog.dart';
import 'components/floating_button_group.dart';
import 'components/list_project.dart';
import 'components/list_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PopupDialog popupDialog = PopupDialog();
  Services services = Services();
  Home home = Home();

  String title = "";
  List history = [];
  List licensePlateInvite = [];
  List coming_walk = [];
  List hsa_stamp_list = [];
  List pms_list = [];
  // Timer time;

  @override
  void initState() {
    super.initState();

    // time = Timer.periodic(Duration(seconds: 1), (timer) {
    //   debugPrint(timer.tick.toString());
    // });

    getHome();
    getHistory();
    getLicenseInvite();
    coming_and_walk();
    hsa_stamp();
    pms_show();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              AppBarAction(),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListProject(),
                ),
                SizedBox(height: size.height * 0.03),
                ListTabBar(
                  build_licensePLateInvite:
                      build_licensePLateInvite(context, licensePlateInvite),
                  build_comingAndWalk:
                      build_comingAndWalk(context, coming_walk),
                  build_hsaStamp: build_hsaStamp(context, hsa_stamp_list),
                  history: history,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingButtonGroup()),
    );
  }

  getHistory() async {
    var data = await services.getHistory();
    setState(() => history = data);
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
            date: licensePlateInvite[index]['license_plate'],
            license_plate: "Invite",
            color: fededWhite1,
            press: () {
              popupDialog.invite_dialog(context, licensePlateInvite[index], () {
                var state = services.deleteInvite(
                    licensePlateInvite[index]['visitor_id'].toString());
                state.then((v) => getLicenseInvite());
                Navigator.pop(context);
              });
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
              popupDialog.walkin_comingin_dialog(context, coming_walk[index],
                  () {
                var state = services
                    .resident_stamp(coming_walk[index]['log_id'].toString());
                state.then((v) {
                  coming_and_walk();
                  hsa_stamp();
                });
                Navigator.pop(context);
              });
            },
          );
        });
  }

  hsa_stamp() async {
    var data = await services.hsa_stamp();
    setState(() => hsa_stamp_list = data);
  }

  Widget build_hsaStamp(BuildContext context, List lists) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListItemField(
              date: hsa_stamp_list[index]['license_plate'],
              license_plate: "HSA stamp",
              color: fededWhite,
              press: () {
                popupDialog.sha_dialod(context, hsa_stamp_list[index], () {
                  var state = services.send_admin_stamp(
                      hsa_stamp_list[index]['log_id'].toString());
                  state.then((v) {
                    hsa_stamp();
                    // PMS stamp
                  });
                  Navigator.pop(context);
                });
              });
        });
  }

  pms_show() async {
    var data = await services.pms_show();
    setState(() => pms_list = data);

    print(pms_list);
  }

  void dispose() {
    super.dispose();
    // time.cancel();
  }
}

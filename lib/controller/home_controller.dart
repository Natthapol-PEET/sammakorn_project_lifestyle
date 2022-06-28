import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:registerapp_flutter/components/show_dialog.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/functions/xscc.dart';
import 'package:registerapp_flutter/models/visitor_model.dart';
import 'package:registerapp_flutter/models/whitelist_models.dart';
import 'package:registerapp_flutter/screens/Home/function/selectIndex.dart';
import 'package:registerapp_flutter/service/get_visitor.dart';
import 'package:registerapp_flutter/service/get_whitelist.dart';
import 'package:registerapp_flutter/service/push_notification.dart';

class HomeController extends GetxController {
  PushNotification pushNotification = PushNotification();
  FirebaseMessaging? messaging;

  final loginController = Get.put(LoginController());
  final selectHomeController = Get.put(SelectHomeController());

  var loading = true.obs;

  get title => selectHomeController.selectHome.value;
  var allHome = [].obs;

  // menu variable
  var selectIndex = 0.obs;
  var selectColorButton = [].obs;
  var selectColorElem = [].obs;

  // loading dialog variable
  BuildContext? dialogContext;

  // Dropdown Month
  var dropdowValue = "".obs;

  // use v2
  var visitorList = [];
  var whitelistList = [];

  var inviteList = [].obs;
  var commingList = [].obs;
  var stampList = [].obs;
  var historyList = [].obs;

  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  @override
  void onReady() {}

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // init Color
    selectColorButton.value = selectIndexButton(0);
    selectColorElem.value = selectIndexElem(0);

    // set select month
    dropdowValue.value = mapMonth[currentMonth] as String;

    fetchApi();

    super.onInit();
  }

  fetchApi() async {
    // Project of homeId
    getHomeSlide();

    showLoadingDialog();

    visitorList = [];
    whitelistList = [];

    // get visitor from api
    var dataVisitor = await getVisitorApi(
        loginController.dataLogin!.authToken as String,
        selectHomeController.homeId.value);

    // get whitelist from api
    var dataWhitelist = await getWhitelistApi(
        loginController.dataLogin!.authToken as String,
        selectHomeController.homeId.value);

    // check visitor from api is null
    if (dataVisitor != null)
      dataVisitor
          .forEach((elem) => visitorList.add(VisitorModel.fromJson(elem)));

    // check whitelist from api is null
    if (dataWhitelist != null)
      dataWhitelist
          .forEach((elem) => whitelistList.add(WhitelistModel.fromJson(elem)));

    // invite
    inviteList.value = visitorList.where((item) => item.logId == null).toList();
    print("inviteList: ${inviteList.length}");

    // comming
    commingList.value = [
      ...whitelistList
          .where(
              (item) => item.datetimeIn != null && item.residentStamp == null)
          .toList(),
      ...visitorList
          .where(
              (item) => item.datetimeIn != null && item.residentStamp == null)
          .toList()
    ];
    print("commingList: ${commingList.length}");

    // stamp
    stampList.value = [
      ...whitelistList.where((item) {
        if (item.residentStamp != null) {
          if (item.datetimeOut == null)
            return true;
          else
            return inToday(item.datetimeOut);
        }
        return false;
      }).toList(),
      ...visitorList.where((item) {
        if (item.residentStamp != null) {
          if (item.datetimeOut == null)
            return true;
          else
            return inToday(item.datetimeOut);
        }
        return false;
      }).toList()
    ];
    print("stampList: ${stampList.length}");

    // histoty
    historyList.value = [
      ...whitelistList.where((item) {
        if (item.datetimeOut == null) return false;
        if (inToday(item.datetimeOut)) return false;
        if (item.datetimeOut != null) if (item.historyCreateDT.month ==
                currentMonth &&
            item.historyCreateDT.year == currentYear) return true;
        return false;
      }).toList(),
      ...visitorList.where((item) {
        if (item.datetimeOut == null) return false;
        if (inToday(item.datetimeOut)) return false;
        if (item.datetimeOut != null) if (item.historyCreateDT.month ==
                currentMonth &&
            item.historyCreateDT.year == currentYear) return true;
        return false;
      }).toList(),
    ];
    print("historyList: ${historyList.length}");

    EasyLoading.dismiss();
  }

  bool inToday(DateTime dt) {
    DateTime now = DateTime.now();
    if ("${dt.day}${dt.month}${dt.year}" == "${now.day}${now.month}${now.year}")
      return true;
    return false;
  }

  setSelectIndex(int index) {
    selectIndex.value = index;
    selectColorButton = selectIndexButton(index);
    selectColorElem = selectIndexElem(index);
    update();
  }

  getHomeSlide() async {
    allHome.value = selectHomeController.listItem;
  }

  void findDataInMonth(monthKey) {
    // clear
    historyList.value = [];

    // histoty
    historyList.value = [
      ...whitelistList.where((item) {
        if (item.datetimeOut == null) return false;
        if (inToday(item.datetimeOut)) return false;
        if (item.datetimeOut != null) if (item.historyCreateDT.month ==
                monthKey &&
            item.historyCreateDT.year == currentYear) return true;
        return false;
      }).toList(),
      ...visitorList.where((item) {
        if (item.datetimeOut == null) return false;
        if (inToday(item.datetimeOut)) return false;
        if (item.datetimeOut != null) if (item.historyCreateDT.month ==
                monthKey &&
            item.historyCreateDT.year == currentYear) return true;
        return false;
      }).toList(),
    ];
    print("historyList: ${historyList.length}");
  }

  updateDropdown(Map<int, String> mapMonth, String v) {
    dropdowValue.value = v;

    int monthKey = mapMonth.keys
        .firstWhere((k) => mapMonth[k] == v, orElse: () => null as int);
    findDataInMonth(monthKey);
  }

  @override
  void onClose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // mqtt close connection
    // closeConnection();
    // client.disconnect();
    super.onClose();
  }
}

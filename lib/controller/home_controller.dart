import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:registerapp_flutter/constance.dart';
import 'package:registerapp_flutter/controller/login_controller.dart';
import 'package:registerapp_flutter/controller/select_home_controller.dart';
import 'package:registerapp_flutter/data/notification.dart';
import 'package:registerapp_flutter/screens/Home/components/dialog.dart';
import 'package:registerapp_flutter/screens/Home/function/selectIndex.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/service/mqtt_manage.dart';
import 'package:registerapp_flutter/service/push_notification.dart';
import 'package:registerapp_flutter/utils/time__to_thai.dart';

class HomeController extends GetxController {
  PopupDialog popupDialog = PopupDialog();
  PushNotification pushNotification = PushNotification();
  FirebaseMessaging messaging;
  NotificationDB notifications = NotificationDB();

  final loginController = Get.put(LoginController());
  final selectHomeController = Get.put(SelectHomeController());

  // MQTT Variable
  var client = MqttServerClient(mqttBroker, '');
  MqttManager mqttManager = MqttManager();

  var loading = true.obs;

  get title => selectHomeController.selectHome.value;
  var countAlert = "0".obs;
  var licensePlateInvite = [].obs;
  var coming_walk = [].obs;
  var resident_stamp_list = [].obs;
  var resident_send_admin_stamp = [].obs;
  var pms_list = [].obs;
  var checkout_list = [].obs;
  var white_black_list = [].obs;
  var history_list = [].obs;
  var allHome = [].obs;

  // menu variable
  var selectIndex = 0.obs;
  var selectColorButton = [].obs;
  var selectColorElem = [].obs;

  // loading dialog variable
  BuildContext dialogContext;

  // Dropdown Month
  var dropdowValue = "".obs;
  List history_data = [];

  @override
  void onReady() {
    print('HomeScreen is ready!');
  }

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // init Color
    selectColorButton.value = SelectIndexButton(0);
    selectColorElem.value = SelectIndexElem(0);

    // realtime update data
    // socket();

    // fetchApi
    // fetchApi();

    // mqtt
    initMqtt();

    super.onInit();
  }

  initMqtt() async {
    await mqttManager.mqttInit(client);
    listenMqtt();
  }

  fetchApi() {
    // Project of homeId
    getHomeSlide();

    // ทุกครั้งที่มีแจ้งเตือนเข้ามา [topic ALERT_MESSAGE]
    getCountAlert();

    // List Item -> history
    getHistory();

    // ทุกครั้งที่มีรถ coming in (not walk in) [topic COMING_IN]
    Future.delayed(Duration(milliseconds: 2000), () => getLicenseInvite());
    commingAndWalk();

    // resident stamp -> load new screen
    get_resident_stamp();

    // PMS -> checkout || resident stamp -> checkout
    // [CHECKOUT] {web -> app}
    checkout();

    // whitelist and blacklist -> all status
    // getWhileBlack();

    // multiclient (application) [RESIDENT_SEND_STAMP] {app -> app}
    // [RESIDENT_SEND_STAMP] {web -> app}
    Future.delayed(Duration(milliseconds: 2000), () => resident_send_admin());

    // admin operation -> all status
    Future.delayed(Duration(milliseconds: 2000), () => pms_show());

    // loading dialog
    // Future.delayed(Duration.zero, () => showLoading(context));
    // Future.delayed(Duration(seconds: 3), () => loading(false));
  }

  setSelectIndex(int index) {
    selectIndex.value = index;
    selectColorButton = SelectIndexButton(index);
    selectColorElem = SelectIndexElem(index);
    update();
  }

  getCountAlert() async {
    String count = await notifications
        .getCountNotification(selectHomeController.homeId.value);
    countAlert.value = count;

    print('count >> ${count}');
  }

  getHomeSlide() async {
    var data = await getHomeApi(loginController.dataLogin.authToken,
        loginController.dataLogin.residentId.toString());
    if (data[0] == -1) {
      // print("services error");
    } else {
      allHome.value = data[0];
    }
  }

  getLicenseInvite() async {
    List data = await getLicenseInviteApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    licensePlateInvite.value = data;
  }

  commingAndWalk() async {
    var data = await commingAndWalkApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    coming_walk.value = data;
  }

  get_resident_stamp() async {
    var data = await getResidentStampApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    resident_stamp_list.value = data;
  }

  resident_send_admin() async {
    var data = await getResidentStampApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    resident_send_admin_stamp.value = data;
  }

  pms_show() async {
    var data = await pmsShowApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    pms_list.value = data;

    loading(false);
  }

  checkout() async {
    var data = await checkoutApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    checkout_list.value = data;
  }

  getWhileBlack() async {
    var data = await getListItemsApi(
        loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString(),
        loginController.dataLogin.residentId.toString());
    white_black_list.value = data;
  }

  getHistory() async {
    var data = await getHistoryApi(loginController.dataLogin.authToken,
        selectHomeController.homeId.value.toString());
    history_list.value = data;
    findDataInMonth(DateTime.now().month, history_list);
  }

  void findDataInMonth(monthKey, lists) {
    // clear
    history_data.clear();

    for (Map data in lists) {
      String month = data['datetime_in'].split('-')[1];
      List date = data['datetime_in'].split('T')[0].split('-');
      int yearIn = christian_buddhist_year(int.parse(date[0]));
      // String monthIn = month_eng_to_thai(int.parse(date[1]));
      int monthIn = int.parse(date[1]);
      int dayIn = int.parse(date[2]);

      if (int.parse(month) == monthKey) {
        history_data.add({
          "date": "${dayIn} ${month_eng_to_thai(monthIn)} ${yearIn}",
          "license":
              data['license_plate'] != null ? data['license_plate'] : '-',
          "id_card": data['id_card'],
          "fullname": data['fullname'],
        });
      }
    }

    update();
  }

  publishMqtt(String topic, String msg) async {
    if (topic == "app-to-app") {
      topic = topic + "/" + selectHomeController.homeId.toString();
    }

    print("publish topic: " + topic);

    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);

    try {
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
    } catch (e) {}
  }

  listenMqtt() {
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print("topic is <-- ${c[0].topic} -->");
      print("payload is <-- $pt -->");

      updateAPI(pt);
    });
  }

  updateAPI(msg) {
    if (msg == "INVITE_VISITOR") {
      Future.delayed(Duration(milliseconds: 1000), () => getLicenseInvite());
    } else if (msg == "ALERT_MESSAGE") {
      // ทุกครั้งที่มีแจ้งเตือนเข้ามา [topic ALERT_MESSAGE] {web -> app}
      Future.delayed(Duration(milliseconds: 1000), () => getCountAlert());
    } else if (msg == "COMING_WALK_IN") {
      // ทุกครั้งที่มีรถ coming in and walk in [topic COMING_WALK_IN] {web -> app}
      Future.delayed(Duration(milliseconds: 1000), () => getLicenseInvite());
      Future.delayed(Duration(milliseconds: 1000), () => commingAndWalk());
    } else if (msg == "RESIDENT_STAMP" || msg == "ADMIN_STAMP") {
      // multiclient (application) [topic RESIDENT_STAMP] {app -> app}
      Future.delayed(Duration(milliseconds: 1000), () => commingAndWalk());
      Future.delayed(Duration(milliseconds: 1000), () => get_resident_stamp());
    }
    // else if (msg == "RESIDENT_SEND_STAMP") {
    //   // multiclient (application) [RESIDENT_SEND_STAMP] {app -> app}
    //   // [RESIDENT_SEND_STAMP] {web -> app}
    //   Future.delayed(Duration(milliseconds: 1000), () => resident_send_admin());
    // }
    else if (msg == "ADMIN_OPERATION") {
      // Admin operation -> all status [topic ADMIN_OPERATION]  {web -> app}
      // Future.delayed(Duration(milliseconds: 2000), () {
      //   resident_send_admin();
      //   pms_show();
      // });
      resident_send_admin();
      pms_show();
    } else if (msg == "CHECKOUT") {
      Future.delayed(Duration(milliseconds: 1000), () => commingAndWalk());
      // PMS -> checkout || resident stamp -> checkout
      // [CHECKOUT] {web -> app}
      Future.delayed(Duration(milliseconds: 1000), () {
        get_resident_stamp();
        pms_show();
        checkout();
        getHistory();
      });
    } else if (msg == "ADMIN_OP_BLACKWHITE") {
      // Admin operation whitelist and blacklist (application) [ADMIN_OP_BLACKWHITE]
      Future.delayed(Duration(milliseconds: 1000), () => getWhileBlack());
    } else if (msg == "RESIDENT_REQUEST_WHITEBLACK") {
      Future.delayed(Duration(milliseconds: 1000), () => getWhileBlack());
    }
  }

  Future closeConnection() async {
    //   for (String topic in subTopic) {
    //     /// Finally, unsubscribe and exit gracefully
    //     client.unsubscribe(topic);

    //     /// Wait for the unsubscribe message from the broker if you wish.
    //     await MqttUtilities.asyncSleep(2);
    //     print('EXAMPLE::Disconnecting');
    client.disconnect();
    //   }
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

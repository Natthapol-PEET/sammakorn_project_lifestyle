import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:registerapp_flutter/constance.dart';
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:registerapp_flutter/data/notification.dart';
import 'package:registerapp_flutter/screens/Home/components/dialog.dart';
import 'package:registerapp_flutter/screens/Home/function/selectIndex.dart';
import 'package:registerapp_flutter/screens/Home/service/service.dart';
import 'package:registerapp_flutter/service/fcm.dart';
import 'package:registerapp_flutter/service/mqtt_manage.dart';
import 'package:registerapp_flutter/service/push_notification.dart';

class HomeController extends GetxController {
  Home home = Home();
  Auth auth = Auth();
  PopupDialog popupDialog = PopupDialog();
  Services services = Services();
  PushNotification pushNotification = PushNotification();
  FCM fcm = FCM();
  FirebaseMessaging messaging;
  NotificationDB notifications = NotificationDB();

  // MQTT Variable
  var client = MqttServerClient(mqttBroker, '');
  MqttManager mqttManager = MqttManager();

  var loading = true.obs;

  var title = "".obs;
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

    // title screen
    getHome();

    // List Item -> history
    getHistory();

    // ทุกครั้งที่มีรถ coming in (not walk in) [topic COMING_IN]
    Future.delayed(Duration(milliseconds: 2000), () => getLicenseInvite());
    coming_and_walk();

    // resident stamp -> load new screen
    get_resident_stamp();

    // PMS -> checkout || resident stamp -> checkout
    // [CHECKOUT] {web -> app}
    checkout();

    // whitelist and blacklist -> all status
    get_white_black();

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
  }

  getCountAlert() async {
    String count = await notifications.getCountNotification();
    countAlert.value = count;
  }

  getHomeSlide() async {
    var data = await services.getHome();
    if (data[0] == -1) {
      // print("services error");
    } else {
      allHome.value = data[0];
    }
  }

  getHome() async {
    String _home = await home.getHome();
    title.value = _home;
  }

  getLicenseInvite() async {
    List data = await services.getLicenseInvite();
    licensePlateInvite.value = data;
  }

  coming_and_walk() async {
    var data = await services.coming_and_walk();
    coming_walk.value = data;
  }

  get_resident_stamp() async {
    var data = await services.get_resident_stamp();
    resident_stamp_list.value = data;
  }

  resident_send_admin() async {
    var data = await services.get_resident_send_admin();
    resident_send_admin_stamp.value = data;
  }

  pms_show() async {
    var data = await services.pms_show();
    pms_list.value = data;

    loading(false);
  }

  checkout() async {
    var data = await services.checkout();
    checkout_list.value = data;
  }

  get_white_black() async {
    var data = await services.getListItems();
    white_black_list.value = data;
  }

  getHistory() async {
    var data = await services.getHistory();
    history_list.value = data;
  }

  publishMqtt(String topic, String msg) async {
    if (topic == "app-to-app") {
      String homeId = await home.getHomeId();
      topic = topic + "/" + homeId;
    }

    print("publish topic: " + topic);

    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
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
      Future.delayed(Duration(milliseconds: 1000), () => coming_and_walk());
    } else if (msg == "RESIDENT_STAMP") {
      // multiclient (application) [topic RESIDENT_STAMP] {app -> app}
      Future.delayed(Duration(milliseconds: 1000), () => get_resident_stamp());
    } else if (msg == "RESIDENT_SEND_STAMP") {
      // multiclient (application) [RESIDENT_SEND_STAMP] {app -> app}
      // [RESIDENT_SEND_STAMP] {web -> app}
      Future.delayed(Duration(milliseconds: 1000), () => resident_send_admin());
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

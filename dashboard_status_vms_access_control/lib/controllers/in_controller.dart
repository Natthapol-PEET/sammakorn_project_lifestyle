import 'dart:async';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:dashboard_status_vms_access_control/models/data_resident_model.dart';
import 'package:dashboard_status_vms_access_control/models/get_datetime.dart';
import 'package:dashboard_status_vms_access_control/services/alert.dart';
import 'package:dashboard_status_vms_access_control/services/comming_service.dart';
import 'package:dashboard_status_vms_access_control/services/gate_barrier_service.dart';
import 'package:dashboard_status_vms_access_control/services/htto_to_mqtt.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InController extends GetxController {
  // time periodic
  Timer timer;

  // API services
  Comming comming = Comming();

  // Services
  Alert alert = Alert();
  // SocketManager s = SocketManager();

  // QrCode Id
  Utils util = Utils();
  // String licensePlate = "";

  // Gate Barrirer Controller
  GateBarirerService gateService = GateBarirerService();

  // date time variable
  var hour = "".obs,
      minute = "".obs,
      apm = "".obs,
      dayNumber = "".obs,
      day = "".obs,
      mon = "".obs,
      year = "".obs;

  // MQTT Class
  // var client = MqttServerClient(mqttBroker, '');
  // MqttManager mqttManager = MqttManager();
  HttpToMqtt httpToMqtt = HttpToMqtt();

  @override
  void onInit() {
    // init relay
    // initRelay(pinIn);

    getTime();

    timer = Timer.periodic(Duration(seconds: 60), (t) {
      // update time in screen
      getTime();

      // Test Function Call API
      // httpToMqtt.postMqttToServer("pi-to-web", "COMING_WALK_IN");
    });

    // Future.delayed(const Duration(seconds: 3), () {
    //   // Test Function Call API
    //   postCommingIn("V84857175752071423783");
    // });

    // Future.delayed(const Duration(seconds: 3), () {
    //   // Test Function Call API
    //   httpToMqtt.postMqttToServer("pi-to-web", "COMING_WALK_IN");
    // });

    super.onInit();
  }

  postCommingIn(String qrId) async {
    Get.offNamed('/loading');

    // post to server
    var dataIn = await comming.checkIn(qrId);

    if (dataIn == "data not found") {
      Get.offNamed('/nopass');
      backToHome();
    } else if (dataIn is ResidentModel) {
      gateService.gateController(gateBarrierOpenUrl);
      Future.delayed(Duration(seconds: 8),
          () => gateService.gateController(gateBarrierCloseUrl));

      Get.offNamed('/pass', arguments: dataIn);
      backToHome();
    } else {
      // send pin to relay process
      // manageRelay(pinIn);
      // httpToMqtt.postMqttToServer("/mqtt_relay_control", "1");
      gateService.gateController(gateBarrierOpenUrl);
      Future.delayed(Duration(seconds: 8),
          () => gateService.gateController(gateBarrierCloseUrl));

      // Future.delayed(const Duration(seconds: 2), () {
      // Test Function Call API
      //   httpToMqtt.postMqttToServer("/mqtt_relay_control", "2");
      // });

      // send notification to app
      alert.sendNotifications(dataIn, 'comming');

      // send socket realtime web app
      // s.send_socket(dataIn.homeId, 'entrance');
      httpToMqtt.postMqttToServer(
          "pi-to-app/${dataIn.homeId}", "COMING_WALK_IN");
      httpToMqtt.postMqttToServer(
          "pi-to-app/${dataIn.homeId}", "ALERT_MESSAGE");
      httpToMqtt.postMqttToServer("pi-to-web", "COMING_WALK_IN");

      Get.offNamed('/pass', arguments: dataIn);
      backToHome();
    }
  }

  getTime() {
    GetDateTime gdt = GetDateTime();

    int h = gdt.getH();
    int m = gdt.getm();
    var now = gdt.getNow();

    hour.value = h < 10 ? "0$h" : "$h";
    minute.value = m < 10 ? "0$m" : "$m";

    day.value = mapDayEngTodayThai(DateFormat('E').format(now));
    dayNumber.value = int.parse(DateFormat('dd').format(now)).toString();
    mon.value = mapMonEndToMonThai(DateFormat('MMM').format(now));
    year.value = mapBCtoBE(DateFormat('y').format(now));
  }

  backToHome() =>
      Future.delayed(const Duration(seconds: 10), () => Get.offNamed('/'));

  mapBCtoBE(String bc) => (int.parse(bc) + 543).toString();

  mapMonEndToMonThai(String m) {
    Map mon = {
      "Jan": "มกราคม",
      "Feb": "กุมภาพันธ์",
      "Mar": "มีนาคม",
      "Apr": "เมษายน",
      "May": "พฤษภาคม",
      "Jun": "มิถุนายน",
      "Jul": "กรกฎาคม",
      "Aug": "สิงหาคม",
      "Sep": "กันยายน",
      "Oct": "ตุลาคม",
      "Nov": "พฤศจิกายน",
      "Dec": "ธันวาคม",
    };

    return mon[m];
  }

  mapDayEngTodayThai(String d) {
    Map day = {
      "Mon": "วันจันทร์",
      "Tue": "วันอังคาร",
      "Wed": "วันพุธ",
      "Thu": "วันพฤหัสบดี",
      "Fri": "วันศุกร์",
      "Sat": "วันเสาร์",
      "San": "วันอาทิตย์",
    };

    return day[d];
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    timer.cancel();

    super.onClose();
  }
}

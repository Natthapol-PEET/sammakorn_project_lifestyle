import 'dart:async';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:dashboard_status_vms_access_control/models/data_resident_model.dart';
import 'package:dashboard_status_vms_access_control/models/get_datetime.dart';
import 'package:dashboard_status_vms_access_control/services/comming_service.dart';
import 'package:dashboard_status_vms_access_control/services/gate_barrier_service.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InController extends GetxController {
  // time periodic
  Timer? timer;

  // API services
  Comming comming = Comming();

  // QrCode Id
  Utils util = Utils();
  // String licensePlate = "";

  // date time variable
  var hour = "".obs,
      minute = "".obs,
      apm = "".obs,
      dayNumber = "".obs,
      day = "".obs,
      mon = "".obs,
      year = "".obs;

  @override
  void onInit() {
    getTime();

    timer = Timer.periodic(Duration(seconds: 60), (t) {
      // update time in screen
      getTime();
    });

    // Timer(Duration(seconds: 5), () {
    //   postCommingIn("V43084150432676517985");
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
    } else if (dataIn == "no network") {
      Get.offNamed('/no_network');
      backToHome();
    } else if (dataIn is ResidentModel) {
      gateController(gateBarrierOpenUrl);
      Future.delayed(
          Duration(seconds: 8), () => gateController(gateBarrierCloseUrl));

      Get.offNamed('/pass', arguments: dataIn);
      backToHome();
    } else {
      gateController(gateBarrierOpenUrl);
      Future.delayed(
          Duration(seconds: 8), () => gateController(gateBarrierCloseUrl));

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
    timer!.cancel();

    super.onClose();
  }
}

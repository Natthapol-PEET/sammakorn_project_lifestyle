import 'dart:async';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:dashboard_status_vms_access_control/models/exit_model.dart';
import 'package:dashboard_status_vms_access_control/models/get_datetime.dart';
import 'package:dashboard_status_vms_access_control/models/resident_model_checkout.dart';
import 'package:dashboard_status_vms_access_control/services/exit_service.dart';
import 'package:dashboard_status_vms_access_control/services/gate_barrier_service.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OutController extends GetxController {
  // time periodic
  Timer? timer;

  // API Services
  Exit exit = Exit();

  // Services
  // SocketManager s = SocketManager();

  // QR Code Manage
  Utils util = Utils();

  // date time variable
  var hour = "".obs,
      minute = "".obs,
      apm = "".obs,
      dayNumber = "".obs,
      day = "".obs,
      mon = "".obs,
      year = "".obs;

  void onInit() {
    // init relay
    // initRelay(pinOut);

    getTime();

    timer = Timer.periodic(Duration(seconds: 60), (t) {
      // update time in screen
      getTime();
    });

    // Timer(Duration(seconds: 5), () {
    //   postcheckOut("V38031894695390287967");
    // });

    super.onInit();
  }

  postcheckOut(String qrId) async {
    Get.offNamed('/loading');

    // post to server
    var data = await exit.checkOut(qrId);

    if (data == "no_network") {
      Get.offNamed('/no_network');
      leaveBackToHomeAndThx();
      return;
    }

    if (data is ResidentModelCheckout) {
      Get.offNamed('/pass_card', arguments: data);
      gateController(gateBarrierOpenUrl);
      Future.delayed(Duration(seconds: 8),
          () => gateController(gateBarrierCloseUrl));

      leaveBackToHomeAndThx();
    } else if (data is String) {
      String msg = data;
      Get.offNamed('/nopass_desc', arguments: msg);
      leaveBackToHome();
    } else if (data is ExitModel) {
      if (data.licensePlate == '') {
        data.msg = "Pass";
      }
      if (data.msg == "resident not stamp") {
        Get.offNamed('/nopass_exit', arguments: data);
        leaveBackToHome();
      } else if (data.msg == "Pass") {
        gateController(gateBarrierOpenUrl);
        Future.delayed(Duration(seconds: 8),
            () => gateController(gateBarrierCloseUrl));

        Get.offNamed('/leave', arguments: data);

        leaveBackToHomeAndThx();
      }
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

  leaveBackToHome() => Future.delayed(
      const Duration(seconds: 10), () => Get.offNamed('/leave_the_artani'));

  leaveBackToHomeAndThx() {
    Future.delayed(const Duration(seconds: 10), () => Get.offNamed('/thanks'));
    Future.delayed(
        const Duration(seconds: 20), () => Get.offNamed('/leave_the_artani'));
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    timer!.cancel();
    super.onClose();
  }
}

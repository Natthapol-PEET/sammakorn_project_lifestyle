import 'dart:async';

import 'package:dashboard_status_vms_access_control/data/confix.dart';
import 'package:dashboard_status_vms_access_control/models/confix_model.dart';
import 'package:get/get.dart';

class ConfixController extends GetxController {
  Confix confix = Confix();

  @override
  void onInit() {
    initDatabase();
    super.onInit();
  }

  initDatabase() async {
    await confix.getDatabase();
    await confix.initConfix();

    Timer(Duration(seconds: 3), () => getConfix());
  }

  getConfix() async {
    var data = await confix.confixs();

    print(data);

    if (data[0].page == 'entrance')
      Get.toNamed('/');
    else
      Get.toNamed('/leave_the_artani');
  }

  goToEntrance() async {
    Get.toNamed('/');

    confix.updateConfix(ConfixModel(
      id: 1,
      page: 'entrance',
    ));
  }

  goToExit() async {
    Get.toNamed('/leave_the_artani');

    confix.updateConfix(ConfixModel(
      id: 1,
      page: 'exit',
    ));
  }
}

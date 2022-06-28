import 'dart:async';
import 'package:dashboard_status_vms_access_control/models/data_screen.dart';
import 'package:dashboard_status_vms_access_control/services/comming_service.dart';
import 'package:get/get.dart';

class EntranceController extends GetxController {
  Comming comming = Comming();

  List qIn = [];
  String licensePlate = "";

  // variables controller
  int status = 0;
  List listData = [];
  DataScreen? data;

  postCommingIn(String qrId) async {
    // wait
    status = 3;
    update();

    // post to server
    var dataIn = await comming.checkIn(qrId);

    if (dataIn == "data not found") {
      // data not found
      status = 2;
      listData = qIn;
      update();

      // back to welcome
      backToWelcome();
    } else {
      // successful
      status = 1;
      // create data screen
      data = DataScreen.fromDataIn(dataIn, qIn);

      // qIn -> qInOld
      if (dataIn.licensePlate != licensePlate) {
        if (qIn.length == 4) {
          qIn.removeAt(3);
        }

        // remember the licensePlate
        licensePlate = dataIn.licensePlate;

        qIn.insert(0, dataIn);
      }
      update();

      backToWelcome();
    }
  }

  backToWelcome() {
    Timer(Duration(seconds: 3), () {
      status = 0;
      listData = qIn;
      update();
    });
  }
}

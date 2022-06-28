import 'dart:async';
import 'package:dashboard_status_vms_access_control/models/data_in.dart';
import 'package:dashboard_status_vms_access_control/models/data_screen.dart';
import 'package:dashboard_status_vms_access_control/services/exit_service.dart';
import 'package:get/get.dart';

class ExitController extends GetxController {
  Exit exit = Exit();

  List qOut = [];
  String licensePlate = "";

  // variables controller
  int status = 0;
  List listData = [];
  String? msg;
  DataScreen? data;

  postcheckOut(String qrId) async {
    // wait
    status = 3;
    update();

    // post to server
    var dataIn = await exit.checkOut(qrId);

    if (dataIn['msg'] == "data not found") {
      msg = "data not found";
      send_data_to_web_error(msg);
    } else if (dataIn['msg'] == "Pass") {
      // success
      DataIn data = DataIn.fromJson(dataIn);
      send_data_to_web_pass(data);
    } else if (dataIn['msg'] == "resident not stamp") {
      msg = "Resident not stamp";
      send_data_to_web_error(msg);
    } else if (dataIn['msg'] == "No information in the system") {
      msg = "No information in the system";
      send_data_to_web_error(msg);
    } else if (dataIn['msg'] == "payment") {
      msg = "payment";
      send_data_to_web_error(msg);
    }
  }

  send_data_to_web_pass(dataIn) {
    status = 1;
    listData = qOut;
    msg = "msg";
    update();

    // qIn -> qInOld
    if (dataIn.licensePlate != licensePlate) {
      if (qOut.length == 4) {
        qOut.removeAt(3);
      }

      // remember the licensePlate
      licensePlate = dataIn.licensePlate;

      qOut.insert(0, dataIn);
    }
    update();

    backToWelcome();
  }

  send_data_to_web_error(msg) {
    // data not found
    status = 2;
    listData = qOut;
    update();

    // back to welcome
    backToWelcome();
  }

  backToWelcome() {
    Timer(Duration(seconds: 3), () {
      status = 0;
      listData = qOut;
      update();
    });
  }
}

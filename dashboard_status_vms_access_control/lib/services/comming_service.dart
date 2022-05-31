/*
  Checkin Service
    - Service Module
*/

import 'dart:convert';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:dashboard_status_vms_access_control/models/data_resident_model.dart';
import 'package:dashboard_status_vms_access_control/models/entrance_model.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:http/http.dart' as http;

class Comming {
  Utils util = Utils();
  var client = http.Client();
  var url = Uri.parse(HTTP_URL + 'qr_api/coming/');

  checkIn(String qrId) async {
    // String qrGenId = util.removeSymbol(qrId);
    String qrGenId = qrId;

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(<String, String>{"qrGenId": qrGenId}),
      );

      if (response.statusCode == 200) {
        // data success
        String body = utf8.decode(response.bodyBytes);
        var dataJson = json.decode(body);

        print(dataJson['isInvite']);

        if (dataJson['isInvite']) {
          // success
          if (dataJson['CLASS'] == 'visitor') {
            EntranceModel data = EntranceModel.fromJson(dataJson);
            return data;
          } else {
            ResidentModel data = ResidentModel.fromJson(dataJson);
            return data;
          }
        } else {
          // data not found
          return "data not found";
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

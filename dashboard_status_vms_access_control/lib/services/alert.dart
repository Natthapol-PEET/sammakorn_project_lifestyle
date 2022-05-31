/*
  Alert
    - FCM Notification API
 */

import 'dart:convert';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:http/http.dart' as http;

class Alert {
  sendNotifications(var data, String Class) async {
    var client = http.Client();
    var url = Uri.parse(URL_NOTIFICATION);

    Object dummy;

    if (data.licensePlate == "") {
      dummy = {
        "title": "แจ้งเตือนจากระบบ",
        "body": "คุณ ${data.fullname} เข้าโครงการ",
        "data": {"Class": Class, "home_id": data.homeId}
      };
    } else {
      dummy = {
        "title": "แจ้งเตือนจากระบบ",
        "body": "ทะเบียนรถหมายเลข ${data.licensePlate} เข้าโครงการ",
        "data": {"Class": Class, "home_id": data.homeId}
      };
    }

    try {
      var response =
          await client.post(url, headers: headers, body: jsonEncode(dummy));

      if (response.statusCode == 200) {
        // data success
        var jsonString = response.body;
        print("sendNotifications: ${jsonString}");
      }
    } catch (e) {
      print(e);
    }
  }
}

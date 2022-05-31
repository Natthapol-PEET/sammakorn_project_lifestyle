import 'dart:convert';
import 'package:dashboard_status_vms_access_control/config/config.dart';
import 'package:dashboard_status_vms_access_control/models/exit_model.dart';
import 'package:dashboard_status_vms_access_control/models/resident_model_checkout.dart';
import 'package:dashboard_status_vms_access_control/utils/utils.dart';
import 'package:http/http.dart' as http;

class Exit {
  Utils util = Utils();
  var client = http.Client();
  var url = Uri.parse(HTTP_URL + 'qr_api/checkout/');

  checkOut(String qrId) async {
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

        if (dataJson["msg"] == "Pass") {
          return ExitModel.fromJson(dataJson);
        }
        else if(dataJson["msg"] == "Card_Pass") {
          return ResidentModelCheckout.fromJson(dataJson);
        } else {
          return dataJson["msg"];
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

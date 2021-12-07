import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import '../../../constance.dart';

class Services {
  login(String username, String password, String deviceId) async {
    Uri url = Uri.parse("${URL}/login_resident/");
    Auth auth = Auth();
    String device_token = await auth.getDeviceToken();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "device_token": device_token,
        "deviceId": deviceId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      return {"statusCode": 401, "token": jsonDecode(response.body)["detail"]};
    } else {
      return {"statusCode": 500, "token": "server not response"};
    }
  }
}

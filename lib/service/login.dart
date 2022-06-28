import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../constance.dart';

loginApi(
    String username, String password, String deviceId, String fcmToken) async {
  String url = "$domain/v2/login_resident/";

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "device_token": fcmToken,
        "deviceId": deviceId,
      }),
    );
    return response;
  } catch (e) {
    showErrorDialog();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../constance.dart';

Future logoutApi(String token, String residentId) async {
  String url = "$domain/v2/logout/";

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{"resident_id": residentId}),
    );

    if (response.statusCode == 200) print("logout successful");
    return response.statusCode;
  } catch (e) {
    showErrorDialog();
  }
}

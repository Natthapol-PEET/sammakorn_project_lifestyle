import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../constance.dart';

Future changePasswordApi(String token, String oldPassword, String newPassword,
    String residentIs) async {
  String url = "$domain/v2/resident_change_password/";

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'resident_id': residentIs,
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      String body = utf8.decode(response.bodyBytes);
      Map valueMap = json.decode(body);
      return valueMap['detail'];
    }
  } catch (e) {
    showErrorDialog();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import '../../../constance.dart';

Future resetPasswordApi(String token, String email) async {
  String url = "$domain/resident_reset_password/$email";

  var response = await http.put(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token'
  });

  if (response.statusCode == 201) {
    return true;
  } else {
    String body = utf8.decode(response.bodyBytes);
    Map valueMap = json.decode(body);
    return valueMap['detail'];
  }
}

Future changePasswordApi(String token, String oldPassword, String newPassword,
    String residentIs) async {
  String url = "$domain/resident_change_password/";

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
}

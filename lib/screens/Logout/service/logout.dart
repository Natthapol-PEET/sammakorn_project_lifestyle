import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

Future logoutApi(String token, String residentId) async {
  String url = "$domain/logout/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer  $token'
    },
    body: jsonEncode(<String, String>{"resident_id": residentId}),
  );

  if (response.statusCode == 200) {
    print("logout successful");
  }
  return response.statusCode;
}

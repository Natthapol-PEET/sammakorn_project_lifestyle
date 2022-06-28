import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../constance.dart';

deleteInviteApi(String token, int visitorId, int homeId) async {
  String url = "$domain/v2/invite/delete/";

  try {
    var response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, int>{
        "visitor_id": visitorId,
        'home_id': homeId,
      }),
    );
    return response.statusCode;
  } catch (e) {
    showErrorDialog();
  }
}

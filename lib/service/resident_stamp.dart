import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/components/show_dialog.dart';
import '../constance.dart';

residentStampApi(String token, int logId, int homeId) async {
  String url = "$domain/v2/resident_stamp/";

  try {
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, int>{
        "log_id": logId,
        'home_id': homeId,
      }),
    );
    return response.statusCode;
  } catch (e) {
    showErrorDialog();
  }
}

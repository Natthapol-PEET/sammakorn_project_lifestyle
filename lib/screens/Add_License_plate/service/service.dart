import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

inviteVisitorApi(
    String firstname,
    String lastname,
    String licensePlate,
    String idcard,
    String inviteDate,
    String qrGenId,
    String token,
    String residentId,
    String homeId) async {
  String url = "$domain/invite/visitor/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{
      "Class": "resident",
      "class_id": residentId,
      "firstname": firstname,
      "lastname": lastname,
      "home_id": homeId,
      "license_plate": licensePlate,
      "id_card": idcard,
      "invite_date": inviteDate,
      "qrGenId": qrGenId,
    }),
  );

  if (response.statusCode == 201) {
    return "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว";
  } else {
    String body = utf8.decode(response.bodyBytes);
    Map detail = json.decode(body);
    return detail['detail'].toString();
  }
}

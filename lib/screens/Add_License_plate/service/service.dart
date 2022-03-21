import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import '../../../constance.dart';

class Services {
  Auth auth = Auth();
  Home home = Home();

  invite_visitor(String firstname, String lastname, String license_plate, String idcard,
      String invite_date, String qrGenId) async {
    Uri url = Uri.parse("${URL}/invite/visitor/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String id = token_var[0]["ID_RES"].toString();
    var Home = await home.getHomeAndId();
    String home_id = Home[0]["home_id"].toString();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "Class": "resident",
        "class_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "home_id": home_id,
        "license_plate": license_plate,
        "id_card": idcard,
        "invite_date": invite_date,
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

  register_whitelist(String firstname, String lastname, String license_plate,
      String reason, String qrGenId) async {
    Uri url = Uri.parse("${URL}/register/whitelist/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String id = token_var[0]["ID_RES"].toString();
    var Home = await home.getHomeAndId();
    String home_id = Home[0]["home_id"].toString();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "Class": "resident",
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "home_id": home_id,
        "license_plate": license_plate,
        "reason_resident": reason,
        "qrGenId": qrGenId,
      }),
    );

    if (response.statusCode == 201) {
      return "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว";
    } else {
      String body = utf8.decode(response.bodyBytes);
      Map detail = json.decode(body);
      return detail['detail'];
    }
  }

  register_blacklist(String firstname, String lastname, String license_plate,
      String reason) async {
    Uri url = Uri.parse("${URL}/register/blacklist/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String id = token_var[0]["ID_RES"].toString();
    var Home = await home.getHomeAndId();
    String home_id = Home[0]["home_id"].toString();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "Class": "resident",
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "home_id": home_id,
        "license_plate": license_plate,
        "reason_resident": reason,
      }),
    );

    if (response.statusCode == 201) {
      return "ระบบได้ทำการเพิ่มข้อมูลเรียบร้อยแล้ว";
    } else {
      String body = utf8.decode(response.bodyBytes);
      Map detail = json.decode(body);
      return detail['detail'];
    }
  }
}

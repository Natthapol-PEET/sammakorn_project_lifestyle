import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registerapp_flutter/data/auth.dart';
import '../../../constance.dart';

class Services {
  Auth auth = Auth();

  invite_visitor(String firstname, String lastname, String home_id,
      String license_plate, String invite_date) async {
    Uri url = Uri.parse("${URL}/invite/visitor/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String id = token_var[0]["ID_RES"].toString();

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
        // "homename": homename,
        "home_id": home_id,
        "license_plate": license_plate,
        "id_card": "",
        "invite_date": invite_date,
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

  register_whitelist(String firstname, String lastname, String home_id,
      String license_plate) async {
    Uri url = Uri.parse("${URL}/register/whitelist/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String id = token_var[0]["ID_RES"].toString();

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
        // "homename": homename,
        "home_id": home_id,
        "license_plate": license_plate,
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

  register_blacklist(String firstname, String lastname, String home_id,
      String license_plate) async {
    Uri url = Uri.parse("${URL}/register/blacklist/");
    var token_var = await auth.getToken();
    String token = 'Bearer ${token_var[0]["TOKEN"]}';
    String id = token_var[0]["ID_RES"].toString();

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
        // "homename": homename,
        "home_id": home_id,
        "license_plate": license_plate,
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

  // getAllHome() async {
  //   Uri url = Uri.parse("${URL}/home/");

  //   var response = await http.get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     String body = utf8.decode(response.bodyBytes);
  //     List allHome_list = json.decode(body);
  //     List allHome = [];

  //     for (var elem in allHome_list) {
  //       allHome.add(elem['home']);
  //     }

  //     return allHome;
  //   } else {
  //     return -1;
  //   }
  // }
}

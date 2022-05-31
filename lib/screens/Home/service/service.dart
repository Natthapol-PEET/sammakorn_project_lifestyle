import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constance.dart';

getHistoryApi(String token, String homeId) async {
  String url = "$domain/history/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{"home_id": homeId}),
  );

  List object = [];
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);
    object = lists.toList();
  }
  return object;
}

getLicenseInviteApi(String token, String homeId) async {
  String url = "$domain/license_plate/invite/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{"home_id": homeId}),
  );

  List object = [];
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);
    object = lists.toList();
  }
  return object;
}

deleteInviteApi(String token, String visitorId) async {
  String url = "$domain/license_plate/invite/delete/";

  var response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{"visitor_id": visitorId}),
  );
  return response.statusCode;
}

commingAndWalkApi(String token, String homeId) async {
  String url = "$domain/license_plate/coming_and_walk/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{"home_id": homeId}),
  );

  List object = [];

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);
    object = lists.toList();
  }
  return object;
}

residentStampApi(String token, String logId) async {
  String url = "$domain/license_plate/resident_stamp/";

  var response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{"log_id": logId}),
  );
  return response.statusCode;
}

getResidentStampApi(String token, String homeId) async {
  Uri url = Uri.parse("$domain/license_plate/get_resident_stamp/");

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{"home_id": homeId}),
  );

  List object = [];
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);
    object = lists.toList();
  }
  return object;
}

sendAdminStampApi(String token, String logId, String reason) async {
  String url = "$domain/license_plate/send_admin_stamp/";

  var response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{
      "log_id": logId,
      "reason": reason,
    }),
  );

  return response.statusCode;
}

pmsShowApi(String token, String homeId) async {
  String url = "$domain/license_plate/pms_show_list/";
  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{"home_id": homeId}),
  );

  List object = [];
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);
    object = lists.toList();
  }
  return object;
}

checkoutApi(String token, String homeId) async {
  String url = "$domain/license_plate/checkout/";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{"home_id": homeId}),
  );

  List object = [];
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    var lists = json.decode(body);
    object = lists.toList();
  }
  return object;
}

getHomeApi(String token, String residentId) async {
  Uri url = Uri.parse("$domain/gethome/");

  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'resident_id': residentId}));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    List allHomeList = json.decode(body);
    List allHome = [];
    List homeId = [];

    for (var elem in allHomeList) {
      allHome.add(elem['home']);
      homeId.add(elem['home_id']);
    }

    return [allHome, homeId];
  } else {
    return [-1];
  }
}

getListItemsApi(String token, String homeId, String residentId) async {
  Uri url = Uri.parse("$domain/listItem_whitelist_blacklist/");

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(
        <String, String>{"home_id": homeId, "resident_id": residentId}),
  );

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return json.decode(body);
  } else {
    return [];
  }
}

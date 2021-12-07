import 'package:http/http.dart' as http;
import '../../../constance.dart';

clearAccount(deviceId) async {
  Uri url = Uri.parse("${URL}/clear_account/${deviceId}");

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    // body: jsonEncode(<String, String>{"deviceId": deviceId}),
  );

  // print("check login API => ${response.statusCode}");

  if (response.statusCode == 200) {
    return response.body;
  }
  
  return false;
}

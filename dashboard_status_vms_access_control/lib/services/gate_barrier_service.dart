import 'package:http/http.dart' as http;

class GateBarirerService {
  var client = http.Client();

  gateController(UrlControl) async {
    var url = Uri.parse(UrlControl);

    try {
      final response = await client.get(url);

      print("gateController: ${response.statusCode}");

      return response.statusCode;
    } catch (e) {
      print(e);
    }
  }
}

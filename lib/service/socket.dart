import 'package:registerapp_flutter/data/auth.dart';
import 'package:registerapp_flutter/data/home.dart';
import 'package:web_socket_channel/io.dart';
import '../constance.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketManager {
  Home home = Home();
  Auth auth = Auth();

  // socket variable
  IOWebSocketChannel channel;

  send_message(topic, to) async {
    var data = await auth.getToken();
    String token = data[0]['TOKEN'];
    String homeId = await home.getHomeId();

    channel = IOWebSocketChannel.connect(
        Uri.parse('${WS}/ws/${token}/app/${homeId}'));

    String msg = '''
        {
            "topic": "${topic}",
            "send_to": "${to}",
            "home_id": ${homeId}
        }
    ''';

    try {
      channel.sink.add(msg);

      Future.delayed(Duration(milliseconds: 1000),
          () => channel.sink.close(status.goingAway));
    } catch (e) {}
  }
}

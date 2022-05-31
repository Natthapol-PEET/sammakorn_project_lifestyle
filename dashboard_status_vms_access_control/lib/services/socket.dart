// import 'dart:convert';

// import 'package:dashboard_status_vms_access_control/config/config.dart';
// // import 'package:web_socket_channel/status.dart' as status;
// import 'package:web_socket_channel/web_socket_channel.dart';

// class SocketManager {
// // socket variable
//   WebSocketChannel channel;

//   send_socket(homeId, postition) async {
//     channel = WebSocketChannel.connect(
//         Uri.parse(SOCKET_REALTIME_WEB_APP + '0' + '/0'));

//     if (postition == 'entrance') {
//       sink_to_server(
//           {"topic": "COMING_WALK_IN", "send_to": "webapp", "home_id": homeId});
//       sink_to_server(
//           {"topic": "ALERT_MESSAGE", "send_to": "webapp", "home_id": homeId});
//     } else if (postition == 'exit') {
//       sink_to_server(
//           {"topic": "CHECKOUT", "send_to": "webapp", "home_id": homeId});
//     }
//   }

//   sink_to_server(msg) {
//     try {
//       channel.sink.add(json.encode(msg));

//       Future.delayed(Duration(milliseconds: 1000), () => channel.sink.close());
//     } catch (e) {}
//   }
// }

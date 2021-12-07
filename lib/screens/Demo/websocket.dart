// import 'package:flutter/material.dart';
// import 'package:registerapp_flutter/data/auth.dart';
// import 'package:registerapp_flutter/data/home.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import '../../constance.dart';

// class WebSocketScreen extends StatefulWidget {
//   const WebSocketScreen({Key key}) : super(key: key);

//   @override
//   _WebSocketScreenState createState() => _WebSocketScreenState();
// }

// class _WebSocketScreenState extends State<WebSocketScreen> {
//   Auth auth = Auth();
//   Home home = Home();

//   var channel;

//   @override
//   void initState() {
//     super.initState();

//     socket();
//   }

//   void socket() async {
//     var data = await auth.getToken();
//     String token = data[0]['TOKEN'];
//     String homeId = await home.getHomeId();

//     channel = IOWebSocketChannel.connect(Uri.parse('${WS}/${token}/app/${homeId}'));

//     try {
//       channel.stream.listen((message) {
//         print(message);
//         channel.sink.add('received!');
//         channel.sink.close(status.goingAway);
//       });
//     } catch (e) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     channel.sink.close(status.goingAway);
//   }
// }

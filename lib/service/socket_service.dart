import 'dart:async';
import 'package:get/get.dart';
import 'package:registerapp_flutter/constance.dart';
import 'package:registerapp_flutter/controller/home_controller.dart';
import 'package:registerapp_flutter/controller/socket_controller.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService extends GetxController {
  final socketController = Get.put(SocketController());
  final homeController = Get.put(HomeController());

  startSocketClient(int homeId) {
    print("startSocketClient");

    // Dart client
    socketController.socket = io(
        socketUrl,
        OptionBuilder().setTransports(['websocket'])
            // .disableAutoConnect()
            .setExtraHeaders({'Authorization': socketAuth}).build());
    socketController.socket!.connect();

    socketController.socket!.onConnect((_) {
      print("Connected");

      // ให้รู้ว่า client เข้ามา connect แล้ว
      socketController.socket!.emit('will-message', 'toApp/$homeId');

      // รอข้อความจาก server
      socketController.socket!.on('toApp/$homeId', (msg) {
        print("socket message: $msg");
        homeController.fetchApi();
      });
    });

    // เมื่อ server ล่มหรือ internet ล่ม หรืออะไรก็ตามแต่ ที่ทำให้หลุด connect
    socketController.socket!.onDisconnect((msg) {
      print('disconnect: $msg');
      socketController.socket!.clearListeners();
      restartSocketClient(homeId);
    });

    socketController.socket!
        .on('fromServer', (fromServer) => print("fromServer: $fromServer"));
  }

  stopSocketClient(int homeId) {
    print("stopSocketClient");
    socketController.socket!.emit('will-message', 'toApp/$homeId close');
    socketController.socket!.clearListeners();
    socketController.socket!.disconnect();
  }

  restartSocketClient(int homeId) {
    stopSocketClient(homeId);
    Timer(Duration(seconds: 1), () {
      startSocketClient(homeId);
    });
  }
}

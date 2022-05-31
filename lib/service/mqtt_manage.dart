import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:registerapp_flutter/constance.dart';
import 'device_id.dart';

class MqttManager {
  Device device = Device();

  Future mqttInit(client) async {
    // constance
    String deviceId = await device.getId();
    String clientId = mqttClientId + deviceId;

    client.keepAlivePeriod = 20;
    // client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    final connMess = MqttConnectMessage()
        .authenticateAs(mqttUsername, mqttPassword)
        .withClientIdentifier(clientId)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    // print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // print('EXAMPLE::client exception - $e');
      // client.disconnect();
    } on SocketException catch (e) {
      // print('EXAMPLE::socket exception - $e');
      // client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      // client.disconnect();
    }

    // print('EXAMPLE::Subscribing to the test/lol topic');
    // const topic = 'test/lol';
    // client.subscribe(topic, MqttQos.atMostOnce);
    // client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final recMess = c[0].payload as MqttPublishMessage;
    //   final pt =
    //       MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    //   print(
    //       'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    //   // print('');
    // });

    client.published.listen((MqttPublishMessage message) {
      print(
          "client.published.listen topic ${message.variableHeader.topicName}");
      print(MqttPublishPayload.bytesToStringAsString(message.payload.message));
      // print(
      //     'EXAMPLE::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });

    // const pubTopic = 'Dart/Mqtt_client/testtopic';
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello from mqtt_client');

    /// Subscribe to it
    // print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');

    // for (String t in subTopic) {
    //   String topic = t + homeId;
    //   // client.subscribe(topic, MqttQos.exactlyOnce);
    //   client.subscribe(topic, MqttQos.atMostOnce);
    // }

    /// Publish it
    // print('EXAMPLE::Publishing our topic');
    // for (String t in pubTopic) {
    //   String topic = t + homeId;
    //   client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
    // }

    // print('EXAMPLE::Sleeping....');
    // await MqttUtilities.asyncSleep(120);

    /// Finally, unsubscribe and exit gracefully
    // print('EXAMPLE::Unsubscribing');
    // client.unsubscribe(topic);

    // /// Wait for the unsubscribe message from the broker if you wish.
    // await MqttUtilities.asyncSleep(2);
    // print('EXAMPLE::Disconnecting');
    // client.disconnect();

    return client;
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  // void onDisconnected() {
  //   print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  //   if (client.connectionStatus.disconnectionOrigin ==
  //       MqttDisconnectionOrigin.solicited) {
  //     print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
  //   }
  // }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    // print('EXAMPLE::Ping response client callback invoked');
  }
}

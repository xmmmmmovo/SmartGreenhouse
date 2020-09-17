import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';
import 'package:smart_green_house_client/common/widgets/toast.dart';

/// 系统相应状态
class AppState with ChangeNotifier {
  bool _isGrayFilter;
  MqttServerClient _client;

  get isGrayFilter => _isGrayFilter;

  AppState({bool isGrayFilter = false}) {
    this._isGrayFilter = isGrayFilter;
  }

  // 切换灰色滤镜
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }

  void _onConnected() {
    toastInfo(msg: '已成功连接！');
    print("zhazha connect");
    _client.subscribe("sensor_data", MqttQos.atMostOnce);
  }

  void _onDisconnect() {
    print("zhazha disconnect");
  }

  connectMqtt(String username) async {
    _client = MqttServerClient.withPort(
        MQTT_BROKER_URL, username.runes.join() + '-android-client', MQTT_PORT);
    _client.useWebSocket = true;
    _client.websocketProtocols = ["mqttv3.11"];
    _client.logging(on: true);
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnect;
    try {
      await _client.connect(MQTT_USER, MQTT_PWD);
    } catch (e) {
      print('Exception: $e');
      _client.disconnect();
    }

    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
    });
  }
}

import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_green_house_client/common/apis/apis.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';
import 'package:smart_green_house_client/common/widgets/toast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 系统相应状态
class AppState with ChangeNotifier {
  bool _isGrayFilter;
  MqttServerClient _client;
  List<HardwareData> hardwareData = [];
  Map<String, HardwareData> uuidHardwareData;
  String nowUUid;
  MqttSensorData nowData;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<SensorData> sensorData = [];

  get isGrayFilter => _isGrayFilter;

  AppState({bool isGrayFilter = false}) {
    this._isGrayFilter = isGrayFilter;
  }

  void resetSensorData() {
    nowData = null;
  }

  void setUUID(String uuid) {
    nowUUid = uuid;
  }

  Future<dynamic> _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future<dynamic> _onSelectNotification(String payload) async {
    print(payload);
  }

  Future<void> initNotificationPlugin() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<dynamic> showNotification(
      int id, String title, String message, String notificationPayload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '114514', 'smart_green_house_client', 'Just a smart greenhouse client',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, message, platformChannelSpecifics,
        payload: notificationPayload);
  }

  // 切换灰色滤镜
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }

  Future<void> fetchData() async {
    hardwareData = (await HardwareAPI.get_hardware(context: null)).list;
    uuidHardwareData =
        Map.fromIterable(hardwareData, key: (v) => v.uuid, value: (v) => v);
    nowUUid = hardwareData.length == 0 ? null : hardwareData[0].uuid;
  }

  Future<void> fetchSensorData() async {
    sensorData =
        (await SensorAPI.getSensorData(context: null, uuid: this.nowUUid));
  }

  void _onConnected() {
    toastInfo(msg: '已成功连接！');
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
      final mqttdata = mqttSensorDataFromJson(payload);
      if (nowUUid != null && nowUUid == mqttdata.uuid) {
        nowData = mqttdata;
      }
      String notificationMessage = '警报！存在';
      if (mqttdata.fire) {
        notificationMessage += ' 火灾 ';
      }

      if (mqttdata.solid) {
        notificationMessage += ' 缺水 ';
      }

      if (mqttdata.illumination) {
        notificationMessage += ' 光照不足 ';
      }

      if (double.parse(mqttdata.temperature) > mqttdata.temperatureLimit) {
        notificationMessage += ' 温度失控 ';
      }

      if (double.parse(mqttdata.humidity) > mqttdata.humidityLimit) {
        notificationMessage += ' 湿度失控 ';
      }

      if (notificationMessage.length == 5) {
        return;
      }

      notificationMessage += '问题！';

      showNotification(
          uuidHardwareData[mqttdata.uuid].id,
          uuidHardwareData[mqttdata.uuid].name + '出现异常！',
          notificationMessage,
          mqttdata.uuid);
    });
  }
}

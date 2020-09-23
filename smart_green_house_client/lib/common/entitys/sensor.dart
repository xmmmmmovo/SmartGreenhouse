import 'dart:convert';

List<SensorData> sensorDataFromJson(String str) =>
    List<SensorData>.from(json.decode(str).map((x) => SensorData.fromJson(x)));

String sensorDataToJson(List<SensorData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SensorData {
  SensorData({
    this.humidity,
    this.recordTime,
    this.temperature,
  });

  double humidity;
  String recordTime;
  double temperature;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        humidity: json["humidity"],
        recordTime: json["record_time"],
        temperature: json["temperature"],
      );

  Map<String, dynamic> toJson() => {
        "humidity": humidity,
        "record_time": recordTime,
        "temperature": temperature,
      };
}

import 'package:flutter/cupertino.dart';
import 'dart:convert';

class HardwareRequest {
  String page;
  String size;

  HardwareRequest({
    this.page,
    this.size,
  });
}

class HardwareResponse {
  HardwareResponse({
    this.list,
    this.page,
    this.size,
    this.total,
  });

  List<HardwareData> list;
  int page;
  int size;
  int total;

  factory HardwareResponse.fromJson(Map<String, dynamic> json) =>
      HardwareResponse(
        list: List<HardwareData>.from(
            json["list"].map((x) => HardwareData.fromJson(x))),
        page: json["page"],
        size: json["size"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "page": page,
        "size": size,
        "total": total,
      };
}

class HardwareData {
  HardwareData({
    this.humidityLimit,
    this.id,
    this.name,
    this.temperatureLimit,
    this.up,
    this.uuid,
  });

  String humidityLimit;
  int id;
  String name;
  String temperatureLimit;
  bool up;
  String uuid;

  factory HardwareData.fromJson(Map<String, dynamic> json) => HardwareData(
        humidityLimit: json["humidity_limit"],
        id: json["id"],
        name: json["name"],
        temperatureLimit: json["temperature_limit"],
        up: json["up"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "humidity_limit": humidityLimit,
        "id": id,
        "name": name,
        "temperature_limit": temperatureLimit,
        "up": up,
        "uuid": uuid,
      };
}

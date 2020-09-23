import 'package:flutter/cupertino.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/http.dart';

class SensorAPI {
  static Future<List<SensorData>> getSensorData(
      {@required BuildContext context, String uuid}) async {
    var response = await HttpUtil().get(
      '/sensor/get_data_hour',
      context: context,
      params: {'uuid': uuid},
    );
    return List<dynamic>.from(response)
        .map((e) => SensorData.fromJson(e))
        .toList();
  }
}

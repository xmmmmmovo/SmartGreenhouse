import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';

/// 用户
class HardwareAPI {
  static Future<HardwareResponse> get_hardware(
      {@required BuildContext context}) async {
    var response = await HttpUtil().get(
      '/hardware/get_hardware',
      context: context,
      params: null,
    );
    return HardwareResponse.fromJson(response);
  }
}

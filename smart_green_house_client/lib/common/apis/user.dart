import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';

/// 用户
class UserAPI {
  /// 登录
  static Future<UserLoginResponseEntity> login({
    @required BuildContext context,
    UserLoginRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/account/token',
      context: context,
      params: params,
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  /// 登录
  static Future<UserLoginResponseEntity> register({
    @required BuildContext context,
    UserRegisterRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/account',
      context: context,
      params: params,
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  /// 更新
  static void update(
    @required BuildContext context,
    UserUpdateEntity params,
  ) async {
    var response = await HttpUtil().patch(
      '/account',
      context: context,
      params: params,
    );
  }
}

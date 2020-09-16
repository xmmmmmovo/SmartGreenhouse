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
      '/user/login',
      context: context,
      data: params,
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  /// 登录
  static Future<UserInfoEntity> info({
    @required BuildContext context,
    UserLoginRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/user/info',
      context: context,
      data: params,
    );
    return UserInfoEntity.fromJson(response);
  }

  /// 登录
  static Future<UserLoginResponseEntity> register({
    @required BuildContext context,
    UserRegisterRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/user/register',
      context: context,
      data: params,
    );
    return UserLoginResponseEntity.fromJson(response);
  }
}

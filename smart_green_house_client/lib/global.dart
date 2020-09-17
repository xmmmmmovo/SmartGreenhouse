import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:smart_green_house_client/common/apis/apis.dart';

import 'common/entitys/entitys.dart';
import 'common/provider/provider.dart';
import 'common/utils/utils.dart';
import 'common/values/values.dart';

/// 全局配置
class Global {
  /// 用户配置
  static UserInfoEntity profile = UserInfoEntity(
    token: null,
  );

  /// 是否 ios
  static bool isIOS = Platform.isIOS;

  /// android 设备信息
  static AndroidDeviceInfo androidDeviceInfo;

  /// ios 设备信息
  static IosDeviceInfo iosDeviceInfo;

  /// 包信息
  static PackageInfo packageInfo;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 应用状态,
  static AppState appState = AppState();

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 读取设备信息
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Global.isIOS) {
      Global.iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    } else {
      Global.androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    }

    // 包信息
    Global.packageInfo = await PackageInfo.fromPlatform();

    // 工具初始
    await StorageUtil.init();
    HttpUtil();

    // 读取离线用户信息
    var _profileJSON = StorageUtil().getJSON(STORAGE_USER_PROFILE_KEY);
    if (_profileJSON != null) {
      profile = UserInfoEntity.fromJson(_profileJSON);
      final token = profile.token;
      profile = await UserAPI.info(context: null, params: null);
      profile.token = token;
      isOfflineLogin = true;
      appState.connectMqtt(profile.username);
    }
  }

  // 持久化 用户信息
  static Future<bool> saveProfile(UserInfoEntity userResponse) {
    profile = userResponse;
    appState.connectMqtt(profile.username);
    return StorageUtil()
        .setJSON(STORAGE_USER_PROFILE_KEY, userResponse.toJson());
  }
}

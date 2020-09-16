import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';

/// 系统相应状态
class AppState with ChangeNotifier {
  bool _isGrayFilter;

  get isGrayFilter => _isGrayFilter;

  AppState({bool isGrayFilter = false}) {
    this._isGrayFilter = isGrayFilter;
  }

  // 切换灰色滤镜
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }
}

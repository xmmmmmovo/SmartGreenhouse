import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';

/// 系统相应状态
class AppState with ChangeNotifier {
  bool _isGrayFilter;
  int _remainWords;
  List<Translate> _items = [];
  int _time;

  get isGrayFilter => _isGrayFilter;

  get remainWords => _remainWords;

  get items => _items;

  get time => _time;

  AppState({bool isGrayFilter = false, remainWords = 0}) {
    this._isGrayFilter = isGrayFilter;
    this._remainWords = StorageUtil().getInt(STORAGE_REMAIN_WORDS_KEY);
    if (_remainWords == null) {
      StorageUtil().setInt(STORAGE_REMAIN_WORDS_KEY, 0);
    }
    this._time = StorageUtil().getInt(STORAGE_TIME_KEY);
    if (_time == null ||
        ((DateTime.now().millisecondsSinceEpoch - _time) / (24 * 3600 * 1000))
                .floor() >
            0) {
      StorageUtil()
          .setInt(STORAGE_TIME_KEY, DateTime.now().millisecondsSinceEpoch);
      _remainWords = 0;
      StorageUtil().setInt(STORAGE_REMAIN_WORDS_KEY, 0);
    }
    _items = TranslateListObject.fromJson(
            StorageUtil().getJSON(STORAGE_TRANSLATION_RES_KEY))
        .translateList;
  }

  // 切换灰色滤镜
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }

  wordPlusOne() {
    if (null == _remainWords) {
      _remainWords = 0;
    }
    _remainWords += 1;
    StorageUtil().setInt(STORAGE_REMAIN_WORDS_KEY, _remainWords);
    notifyListeners();
  }

  removeData(Datum item) {
    for (var i = 0; i < _items.length; i++) {
      if (item.id == _items[i].id) {
        _items[i].isCollection = false;
        notifyListeners();
        return;
      }
    }
  }
}

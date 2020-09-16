import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';

/// 上传收藏
Future<int> uploadTranslateData({
  @required BuildContext context,
  TranslateRequest params,
}) async {
  var response = await HttpUtil().post(
    '/user/likes',
    context: context,
    params: params,
  );

  return response;
}

void deleteTranslateData({
  @required BuildContext context,
  int id,
}) async {
  var response = await HttpUtil().delete(
    '/user/likes/$id',
    context: context,
  );
}

Future<SelfTranslateResponse> starDetailData({
  @required BuildContext context,
  String name,
}) async {
  var response = await HttpUtil().get(
    '/user/likes/detail/$name',
    context: context,
  );

  return SelfTranslateResponse.fromJson(response);
}

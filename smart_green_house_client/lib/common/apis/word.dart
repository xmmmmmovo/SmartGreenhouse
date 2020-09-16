import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/global.dart';

Future<RandomWordResponse> getWordData({@required BuildContext context}) async {
  var response = await HttpUtil().get('/word/random',
      context: context, params: {"limit": Global.profile.todayWords});

  return RandomWordResponse.fromJson(response);
}

Future<int> uploadRemeberedWord(
    {@required BuildContext context, RemeberedWordRequest params}) async {
  var response = await HttpUtil()
      .post('/remebered/word', context: context, params: params);

  return response;
}

Future<RemeberedWordPageResponse> getSelfData(
    {@required BuildContext context, RemeberedWordPageRequest params}) async {
  var response = await HttpUtil()
      .get('/remebered/word/user', context: context, params: params.toJson());

  return RemeberedWordPageResponse.fromJson(response);
}

Future<WordSearchResponse> getSearchData(
    {@required BuildContext context, SearchDataRequest params}) async {
  var response = await HttpUtil()
      .get('/word/word', context: context, params: params.toJson());

  return WordSearchResponse.fromJson(response);
}

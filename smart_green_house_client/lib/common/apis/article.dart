import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/entitys/article.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';

Future<ArticlePageResponse> getArticleData(
    {@required BuildContext context, ArticlePageRequest params}) async {
  var response = await HttpUtil()
      .get('/article', context: context, params: params.toJson());

  return ArticlePageResponse.fromJson(response);
}

Future<ArticlePageResponse> getArticleNameData(
    {@required BuildContext context, ArticlePageNameRequest params}) async {
  var response = await HttpUtil()
      .get('/article/name', context: context, params: params.toJson());

  return ArticlePageResponse.fromJson(response);
}

Future<int> getLikeStatus(
    {@required BuildContext context, LikeStatusRequest params}) async {
  var response = await HttpUtil()
      .get('/like/table/status', context: context, params: params.toJson());

  return response;
}

Future<int> putLikeStatus(
    {@required BuildContext context, LikeStatusRequest params}) async {
  var response =
      await HttpUtil().post('/like/table', context: context, params: params);

  return response;
}

void deleteLikeStatus({@required BuildContext context, int id}) async {
  await HttpUtil().delete('/like/table/$id', context: context);
}

void uploadArticle({@required BuildContext context, UploadArticleRequest params}) async {
  await HttpUtil().post('/article/name', context: context, params: params);
}

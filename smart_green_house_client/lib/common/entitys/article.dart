class ArticlePageRequest {
  ArticlePageRequest({this.page, this.size});

  int page;
  int size;

  factory ArticlePageRequest.fromJson(Map<String, dynamic> json) =>
      ArticlePageRequest(page: json["page"], size: json["size"]);

  Map<String, dynamic> toJson() => {"page": page, "size": size};
}

class ArticlePageNameRequest {
  ArticlePageNameRequest({this.page, this.size, this.userName});

  String userName;
  int page;
  int size;

  factory ArticlePageNameRequest.fromJson(Map<String, dynamic> json) =>
      ArticlePageNameRequest(
          page: json["page"], size: json["size"], userName: json["userName"]);

  Map<String, dynamic> toJson() =>
      {"page": page, "size": size, "userName": userName};
}

class ArticlePageResponse {
  ArticlePageResponse({
    this.endRow,
    this.hasNextPage,
    this.hasPreviousPage,
    this.isFirstPage,
    this.isLastPage,
    this.list,
    this.navigateFirstPage,
    this.navigateLastPage,
    this.navigatePages,
    this.navigatepageNums,
    this.nextPage,
    this.pageNum,
    this.pageSize,
    this.pages,
    this.prePage,
    this.size,
    this.startRow,
    this.total,
  });

  int endRow;
  bool hasNextPage;
  bool hasPreviousPage;
  bool isFirstPage;
  bool isLastPage;
  List<Author> list;
  int navigateFirstPage;
  int navigateLastPage;
  int navigatePages;
  List<int> navigatepageNums;
  int nextPage;
  int pageNum;
  int pageSize;
  int pages;
  int prePage;
  int size;
  int startRow;
  int total;

  factory ArticlePageResponse.fromJson(Map<String, dynamic> json) =>
      ArticlePageResponse(
        endRow: json["endRow"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
        isFirstPage: json["isFirstPage"],
        isLastPage: json["isLastPage"],
        list: List<Author>.from(json["list"].map((x) => Author.fromJson(x))),
        navigateFirstPage: json["navigateFirstPage"],
        navigateLastPage: json["navigateLastPage"],
        navigatePages: json["navigatePages"],
        navigatepageNums:
            List<int>.from(json["navigatepageNums"].map((x) => x)),
        nextPage: json["nextPage"],
        pageNum: json["pageNum"],
        pageSize: json["pageSize"],
        pages: json["pages"],
        prePage: json["prePage"],
        size: json["size"],
        startRow: json["startRow"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "endRow": endRow,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "isFirstPage": isFirstPage,
        "isLastPage": isLastPage,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "navigateFirstPage": navigateFirstPage,
        "navigateLastPage": navigateLastPage,
        "navigatePages": navigatePages,
        "navigatepageNums": List<dynamic>.from(navigatepageNums.map((x) => x)),
        "nextPage": nextPage,
        "pageNum": pageNum,
        "pageSize": pageSize,
        "pages": pages,
        "prePage": prePage,
        "size": size,
        "startRow": startRow,
        "total": total,
      };
}

class Author {
  Author({
    this.id,
    this.avatar,
    this.content,
    this.likeCount,
    this.name,
    this.title,
  });

  int id;
  String avatar;
  String content;
  int likeCount;
  String name;
  String title;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        avatar: json["avatar"],
        content: json["content"],
        likeCount: json["likeCount"],
        name: json["name"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "content": content,
        "likeCount": likeCount,
        "name": name,
        "title": title,
      };
}

class LikeStatusRequest {
  LikeStatusRequest({this.id, this.userName});

  int id;
  String userName;

  factory LikeStatusRequest.fromJson(Map<String, dynamic> json) =>
      LikeStatusRequest(id: json["id"], userName: json["userName"]);

  Map<String, dynamic> toJson() => {"id": id, "userName": userName};
}

class UploadArticleRequest {
  UploadArticleRequest({this.title, this.userName, this.content});

  String title;
  String userName;
  String content;

  factory UploadArticleRequest.fromJson(Map<String, dynamic> json) =>
      UploadArticleRequest(
          title: json["title"],
          userName: json["userName"],
          content: json["content"]);

  Map<String, dynamic> toJson() =>
      {"title": title, "userName": userName, "content": content};
}

class RandomWordResponse {
  RandomWordResponse({
    this.data,
  });

  List<WordData> data;

  factory RandomWordResponse.fromJson(List<dynamic> json) => RandomWordResponse(
        data: List<WordData>.from(json.map((x) => WordData.fromJson(x))),
      );

  List<dynamic> toJson() => List<dynamic>.from(data.map((x) => x.toJson()));
}

class WordData {
  WordData({
    this.translation,
    this.id,
    this.word,
  });

  String translation;
  int id;
  String word;

  factory WordData.fromJson(Map<String, dynamic> json) => WordData(
        translation: json["translation"],
        id: json["id"],
        word: json["word"],
      );

  Map<String, dynamic> toJson() => {
        "translation": translation,
        "id": id,
        "word": word,
      };
}

class RemeberedWordRequest {
  RemeberedWordRequest({
    this.userName,
    this.wordId,
  });

  String userName;
  int wordId;

  factory RemeberedWordRequest.fromJson(Map<String, dynamic> json) =>
      RemeberedWordRequest(
        userName: json["userName"],
        wordId: json["wordId"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "wordId": wordId,
      };
}

class SearchDataRequest {
  SearchDataRequest({this.word, this.page, this.size});

  String word;
  int page;
  int size;

  factory SearchDataRequest.fromJson(Map<String, dynamic> json) =>
      SearchDataRequest(
          word: json["word"], page: json["page"], size: json["size"]);

  Map<String, dynamic> toJson() =>
      {"word": word, "page": page, "size": size};
}

class RemeberedWordPageRequest {
  RemeberedWordPageRequest({this.userName, this.page, this.size});

  String userName;
  int page;
  int size;

  factory RemeberedWordPageRequest.fromJson(Map<String, dynamic> json) =>
      RemeberedWordPageRequest(
          userName: json["userName"], page: json["page"], size: json["size"]);

  Map<String, dynamic> toJson() =>
      {"userName": userName, "page": page, "size": size};
}

class RemeberedWordPageResponse {
  RemeberedWordPageResponse({
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
  List<ListElement> list;
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

  factory RemeberedWordPageResponse.fromJson(Map<String, dynamic> json) =>
      RemeberedWordPageResponse(
        endRow: json["endRow"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
        isFirstPage: json["isFirstPage"],
        isLastPage: json["isLastPage"],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
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

class ListElement {
  ListElement({
    this.times,
    this.translation,
    this.word,
  });

  int times;
  String translation;
  String word;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        times: json["times"],
        translation: json["translation"],
        word: json["word"],
      );

  Map<String, dynamic> toJson() => {
        "times": times,
        "translation": translation,
        "word": word,
      };
}

class WordSearchResponse {
  WordSearchResponse({
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
  List<WordData> list;
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

  factory WordSearchResponse.fromJson(Map<String, dynamic> json) =>
      WordSearchResponse(
        endRow: json["endRow"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
        isFirstPage: json["isFirstPage"],
        isLastPage: json["isLastPage"],
        list: List<WordData>.from(
            json["list"].map((x) => WordData.fromJson(x))),
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

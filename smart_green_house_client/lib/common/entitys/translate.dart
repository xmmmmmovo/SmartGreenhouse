class Translate {
  int id;
  String title;
  String subTitle;
  bool isCollection;

  Translate({this.title, this.subTitle, this.isCollection});

  factory Translate.fromJson(Map<String, dynamic> json) => Translate(
        title: json["title"],
        subTitle: json["subTitle"],
        isCollection: json["isCollection"],
      );

  Map<String, dynamic> toJson() =>
      {"title": title, "subTitle": subTitle, "isCollection": isCollection};
}

class TranslateRequest {
  String username;
  String from;
  String to;

  TranslateRequest({this.username, this.from, this.to});

  factory TranslateRequest.fromJson(Map<String, dynamic> json) =>
      TranslateRequest(
          username: json["username"], from: json["from"], to: json["to"]);

  Map<String, dynamic> toJson() =>
      {"username": username, "from": from, "to": to};
}

class TranslateListObject {
  List<Translate> translateList = [];

  TranslateListObject({
    this.translateList,
  });

  factory TranslateListObject.fromJson(Map<String, dynamic> json) =>
      TranslateListObject(
        translateList: List<Translate>.from(
            json["translateList"].map((x) => Translate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "translateList":
            List<dynamic>.from(translateList.map((x) => x.toJson())),
      };
}

class SelfTranslateResponse {
  SelfTranslateResponse({
    this.data,
  });

  List<Datum> data;

  factory SelfTranslateResponse.fromJson(List<dynamic> json) =>
      SelfTranslateResponse(
        data: List<Datum>.from(json.map((x) => Datum.fromJson(x))),
      );

  List<dynamic> toJson() => List<dynamic>.from(data.map((x) => x.toJson()));
}

class Datum {
  Datum({
    this.fromSentence,
    this.id,
    this.toSentence,
    this.userId,
  });

  String fromSentence;
  int id;
  String toSentence;
  int userId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        fromSentence: json["fromSentence"],
        id: json["id"],
        toSentence: json["toSentence"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "fromSentence": fromSentence,
        "id": id,
        "toSentence": toSentence,
        "userId": userId,
      };
}

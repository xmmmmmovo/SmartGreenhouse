import 'package:flutter/foundation.dart';

// 登录请求
class UserLoginRequestEntity {
  String username;
  String password;

  UserLoginRequestEntity({
    @required this.username,
    @required this.password,
  });

  factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginRequestEntity(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

class UserRegisterRequestEntity {
  String username;
  String password;
  String adminName;

  UserRegisterRequestEntity(
      {@required this.password,
      @required this.username,
      @required this.adminName});

  factory UserRegisterRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserRegisterRequestEntity(
          password: json["password"],
          username: json["username"],
          adminName: json["adminName"]);

  Map<String, dynamic> toJson() =>
      {"password": password, "username": username, "adminName": adminName};
}

// 登录返回
class UserLoginResponseEntity {
  String token;

  UserLoginResponseEntity({@required this.token});

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(token: json["token"]);

  Map<String, dynamic> toJson() => {"token": this.token};
}

// 获取信息返回
class UserInfoEntity {
  UserInfoEntity({this.username, this.roles, this.token});

  String username;
  List<String> roles;
  String token;

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => UserInfoEntity(
      username: json["username"],
      roles: List<String>.from(json["roles"].map((x) => x)),
      token: json["token"]);

  Map<String, dynamic> toJson() => {
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "username": username,
        "token": token
      };
}

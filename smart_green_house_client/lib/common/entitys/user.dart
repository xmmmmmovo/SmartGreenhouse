import 'package:flutter/foundation.dart';

// 登录请求
class UserLoginRequestEntity {
  String name;
  String password;

  UserLoginRequestEntity({
    @required this.name,
    @required this.password,
  });

  factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginRequestEntity(
        name: json["name"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
      };
}

class UserRegisterRequestEntity {
  String name;
  String password;

  UserRegisterRequestEntity({
    @required this.password,
    @required this.name,
  });

  factory UserRegisterRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserRegisterRequestEntity(
        password: json["password"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "name": name,
      };
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

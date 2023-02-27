// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class UserModel {
  UserModel({
    required this.username,
    required this.password,
    required this.isAdmin,
    this.userimage,
    this.userBio,
  });

  String username;
  String password;
  bool isAdmin;
  String? userimage;
  String? userBio;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json["username"],
        password: json["password"],
        isAdmin: json["isAdmin"],
        userimage: json["userimage"],
        userBio: json["userBio"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "isAdmin": isAdmin,
        "userimage": userimage,
        "userBio": userBio,
      };
}

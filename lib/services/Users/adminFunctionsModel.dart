// To parse this JSON data, do
//
//     final adminFunctionalityModel = adminFunctionalityModelFromJson(jsonString);

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class AdminFunctionalityModel {
  AdminFunctionalityModel({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  String title;
  IconData icon;
  VoidCallback onTap;

  factory AdminFunctionalityModel.fromRawJson(String str) =>
      AdminFunctionalityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdminFunctionalityModel.fromJson(Map<String, dynamic> json) =>
      AdminFunctionalityModel(
        title: json["title"],
        icon: json["icon"],
        onTap: json["onTap"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "onTap": onTap,
      };
}

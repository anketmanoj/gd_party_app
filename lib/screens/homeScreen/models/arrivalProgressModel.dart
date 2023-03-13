// To parse this JSON data, do
//
//     final arrivalProgressModel = arrivalProgressModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class ArrivalProgressModel {
  ArrivalProgressModel({
    required this.completed,
    required this.docId,
    required this.index,
    this.first,
    required this.imageUrl,
    required this.message,
    this.next,
    this.timestamp,
    required this.title,
  });

  bool completed;
  int index;
  String docId;
  bool? first;
  String imageUrl;
  String message;
  bool? next;
  Timestamp? timestamp;
  String title;

  factory ArrivalProgressModel.fromRawJson(String str) =>
      ArrivalProgressModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArrivalProgressModel.fromJson(Map<String, dynamic> json) =>
      ArrivalProgressModel(
        completed: json["completed"],
        index: json["index"],
        docId: json["docId"],
        first: json["first"],
        imageUrl: json["imageUrl"],
        message: json["message"],
        next: json["next"],
        timestamp: json["timestamp"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "index": index,
        "docId": docId,
        "first": first,
        "imageUrl": imageUrl,
        "message": message,
        "next": next,
        "timestamp": timestamp,
        "title": title,
      };
}

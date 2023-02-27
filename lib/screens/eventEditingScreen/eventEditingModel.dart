import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final Timestamp from;
  final Timestamp to;
  final Color backgroundColor;
  final bool isAllDay;
  final double locationLat;
  final double locationLng;
  final String placeDetail;
  final String imgUrl;

  Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay = false,
    required this.locationLat,
    required this.locationLng,
    required this.placeDetail,
    required this.imgUrl,
  });

  // convert Color to hex code
  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8)}';
  }

  // Get fromJson
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      from: json['from'],
      to: json['to'],
      backgroundColor: Color(json['backgroundColor']).withOpacity(1),
      isAllDay: json['isAllDay'],
      locationLat: json['locationLat'],
      locationLng: json['locationLng'],
      placeDetail: json['placeDetail'],
      imgUrl: json['imgUrl'],
    );
  }

  // get toJson
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'from': from,
      'to': to,
      'backgroundColor': backgroundColor.value,
      'isAllDay': isAllDay,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'placeDetail': placeDetail,
      'imgUrl': imgUrl,
    };
  }
}

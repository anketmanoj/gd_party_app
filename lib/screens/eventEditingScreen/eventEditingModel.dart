import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;
  final double locationLat;
  final double locationLng;
  final String placeDetail;

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
  });
}

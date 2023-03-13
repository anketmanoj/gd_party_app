import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Emergercy contacts statless class
class EmergencyContact {
  final String title;
  final String description;
  final String number;
  final IconData icon;
  EmergencyContact(
      {required this.icon,
      required this.title,
      required this.description,
      required this.number});
}

class ProfileController extends GetxController {
  void launchCaller({required String number}) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Error", "Could not place call");
      throw 'Could not launch $url';
    }
  }
}

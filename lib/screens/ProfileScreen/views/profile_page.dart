import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/ProfileScreen/controllers/profileController.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  static const String routeName = "/profile-page";
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Profile",
        ),
      ),
    );
  }
}

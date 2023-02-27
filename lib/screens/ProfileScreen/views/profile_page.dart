import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/ProfileScreen/controllers/profileController.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  static const String routeName = "/profile-page";
  ProfilePage({Key? key}) : super(key: key);
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // logout button
        child: ElevatedButton(
          onPressed: () => userController.logout(),
          child: Text("Logout"),
        ),
      ),
    );
  }
}

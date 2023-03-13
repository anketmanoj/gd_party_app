import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/ProfileScreen/profileController.dart';
import 'package:gd_party_app/screens/ProfileScreen/profilePageWidgets.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends GetView {
  static const String routeName = "/profile-page";
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(ProfileController());

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          profileImage(context: context),
          userNameAndBio(),
          emergencyTile(),
          adminFunctionality(),
        ],
      ),
    ));
  }
}

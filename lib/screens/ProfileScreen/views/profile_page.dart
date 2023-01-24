import 'package:flutter/material.dart';
import 'package:gd_party_app/navigation/custom_bottom_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = "/profile-page";
  const ProfilePage({super.key});

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

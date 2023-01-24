import 'package:flutter/material.dart';
import 'package:gd_party_app/navigation/custom_bottom_navigation_bar.dart';

class LocationPage extends StatelessWidget {
  static const String routeName = "/location-page";
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Location",
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gd_party_app/navigation/custom_bottom_navigation_bar.dart';
import 'package:gd_party_app/screens/locationScreen/controllers/locationController.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {
  static const String routeName = "/location-page";
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: locationController.initGooglePosition,
                onMapCreated: locationController.onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                trafficEnabled: true,
                markers: locationController.markers.values.toSet(),
                onTap: (argument) {
                  log("arguments == $argument");
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

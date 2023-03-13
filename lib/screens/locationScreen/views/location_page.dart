import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gd_party_app/navigation/custom_bottom_navigation_bar.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/locationScreen/controllers/locationController.dart';
import 'package:gd_party_app/screens/locationScreen/models/location_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class LocationPage extends StatelessWidget {
  static const String routeName = "/location-page";
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: locationController.initGooglePosition,
                onMapCreated: locationController.onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: locationController.markers.values.toSet(),
                onTap: (argument) {
                  log("arguments == $argument");
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: GetBuilder<EventEditingController>(builder: (eec) {
                return Container(
                  height: 25.h,
                  width: 100.w,
                  child: CarouselSlider(
                    carouselController: CarouselController(),
                    options: CarouselOptions(
                      initialPage: 0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) async {
                        locationController.setEventLocationPosition(
                            lat: eec.events[index].locationLat,
                            lng: eec.events[index].locationLng);
                      },
                      disableCenter: true,
                    ),
                    items: eec.events.map((i) {
                      return Stack(
                        children: [
                          Container(
                            width: 100.w,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(i.imgUrl),
                                  fit: BoxFit.cover),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 5,
                            right: 5,
                            child: Container(
                              height: 10.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: ListTile(
                                title: Text(i.title),
                                subtitle: Text(i.description),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
            )
          ],
        ),
      );
    });
  }
}

import 'dart:developer';

import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingModel.dart';
import 'package:gd_party_app/screens/locationScreen/controllers/locationController.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    if (tabIndex == 3) {
      final UserController userController = Get.put(UserController());
      userController.loadAdminFunctionalityList();
    }
    if (tabIndex == 2) {
      final LocationController locationController =
          Get.put(LocationController());

      final EventEditingController eventEditingController =
          Get.put(EventEditingController());

      log(eventEditingController.events.length.toString());

      for (Event event in eventEditingController.events) {
        if (locationController.checkIfMarkerExists(event) == false) {
          log("lat: ${event.locationLat} | lng : ${event.locationLng}");
          locationController.add(
              latitude: event.locationLat,
              longitude: event.locationLng,
              title: event.title,
              description: event.description);
        } else {
          log("EVENT EXISTS ${event.locationLat} | ${event.locationLng} :::: ${event.title}");
        }
      }
    }

    update();
  }
}

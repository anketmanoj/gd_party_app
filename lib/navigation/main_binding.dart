import 'package:gd_party_app/navigation/mainController.dart';
import 'package:gd_party_app/screens/ProfileScreen/controllers/profileController.dart';
import 'package:gd_party_app/screens/ScheduleScreen/controllers/scheduleController.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/homeScreen/controllers/homeController.dart';
import 'package:gd_party_app/screens/locationScreen/controllers/locationController.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<EventEditingController>(() => EventEditingController());
    Get.lazyPut<UserController>(() => UserController());
  }
}

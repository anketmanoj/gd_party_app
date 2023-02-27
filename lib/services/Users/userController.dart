import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gd_party_app/navigation/mainPage.dart';
import 'package:gd_party_app/screens/loginScreen/loginScreenView.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:gd_party_app/services/shared_preference_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel(
    username: '',
    password: '',
    isAdmin: false,
  ).obs;

  RxString username = ''.obs;
  RxString password = ''.obs;

  // getter
  UserModel get userModel => _userModel.value;

  // init
  @override
  void onInit() {
    super.onInit();
    // load userModel from sharedPreferences
    log("UserController onInit() called");
    SharedPreferencesHelper.initSharedPrefs();
    if (SharedPreferencesHelper.getBool("isLoggedIn") == true) {
      _userModel.value = UserModel(
        username: SharedPreferencesHelper.getString("username"),
        password: SharedPreferencesHelper.getString("password"),
        isAdmin: SharedPreferencesHelper.getBool("isAdmin"),
      );

      // Add timer for 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Get.toNamed(MainPage.routeName);
      });

      // Get.offNamed(MainPage.routeName);
    }
  }

  void setUserModel(UserModel userModel) {
    _userModel.value = userModel;
    update();
  }

  // logout user
  void logout() {
    SharedPreferencesHelper.setBool("isLoggedIn", false);
    Get.offNamed(LoginScreen.routeName);
  }

  // Log user in
  Future<void> loginUser(String username, String password) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(username)
        .get();

    SharedPreferencesHelper.initSharedPrefs();

    if (userDoc.exists) {
      UserModel userModel =
          UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      if (userModel.password == password) {
        setUserModel(userModel);
        // Save user data to shared preferences

        SharedPreferencesHelper.setString("username", userModel.username);
        SharedPreferencesHelper.setString("password", userModel.password);
        SharedPreferencesHelper.setBool("isAdmin", userModel.isAdmin);
        SharedPreferencesHelper.setBool("isLoggedIn", true);
        Get.offNamed(MainPage.routeName);
      } else {
        SharedPreferencesHelper.setBool("isLoggedIn", false);
        Get.snackbar("Error", "Wrong password");
      }
    } else {
      SharedPreferencesHelper.setBool("isLoggedIn", false);
      Get.snackbar("Error", "User does not exist");
    }
  }
}

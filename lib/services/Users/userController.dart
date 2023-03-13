import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_party_app/navigation/mainPage.dart';
import 'package:gd_party_app/screens/UsersDetails/usersDetailPage.dart';
import 'package:gd_party_app/screens/loginScreen/loginScreenView.dart';
import 'package:gd_party_app/services/Users/adminFunctionsModel.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:gd_party_app/services/fcm_notification_service.dart';
import 'package:gd_party_app/services/shared_preference_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  final Rx<UserModel> _userModel = UserModel(
    username: '',
    password: '',
    isAdmin: false,
  ).obs;
  final RxList<UserModel> _userList = <UserModel>[].obs;
  final RxList<AdminFunctionalityModel> _adminFunctionsList =
      <AdminFunctionalityModel>[].obs;

  RxString username = ''.obs;
  RxString password = ''.obs;

  // getter
  UserModel get userModel => _userModel.value;
  List<UserModel> get userList => _userList;
  List<AdminFunctionalityModel> get adminFunctionsList => _adminFunctionsList;

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
      Future.delayed(Duration(seconds: 2), () async {
        await loadUserDeviceToken();
        Get.toNamed(MainPage.routeName);
      });

      // Get.offNamed(MainPage.routeName);
    }
  }

  void loadAdminFunctionalityList() {
    _adminFunctionsList.value = [
      AdminFunctionalityModel(
        title: "Users Details",
        icon: Icons.people,
        onTap: () {
          log("User List pressed");
          Get.toNamed(UsersDetailsPage.routeName);
        },
      ),
      AdminFunctionalityModel(
        title: "Add Event",
        icon: Icons.event,
        onTap: () {
          log("Add Event pressed");
        },
      ),
      AdminFunctionalityModel(
        title: "Send Notification",
        icon: Icons.notifications,
        onTap: () {
          log("Send Notification pressed");
        },
      ),
    ];
  }

  Future<void> updateUserPassword(
      {required UserModel selectedUser, required String newPassword}) async {
    log("updateUserPassword() called");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(selectedUser.username)
        .update({
      'password': newPassword,
    });
    update();
  }

  Future<void> updateUserArrivalDate(
      {required UserModel selectedUser, required Timestamp newDate}) async {
    log("updateUserArrivalDate() called");
    // log timestamp
    log("newDate: ${newDate.toDate()}");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(selectedUser.username)
        .update({
      'arrivalDate': newDate,
    });
    update();
  }

  Future<void> updateUserIsAdmin(
      {required UserModel selectedUser, required bool newIsAdmin}) async {
    log("updateUserIsAdmin() called");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(selectedUser.username)
        .update({
      'isAdmin': newIsAdmin,
    });
    update();
  }

  Future<void> adminSendNotificationToUser(
      {required String title,
      required String body,
      required UserModel adminSelectedUser}) async {
    log("adminSelectedUser: ${adminSelectedUser.userDeviceToken}");
    await _fcmNotificationService.sendNotificationToUser(
        to: adminSelectedUser.userDeviceToken!, //To change once set up
        title: title,
        body: body);

    update();
  }

  Future<void> getAllUsersFromDb() async {
    log("getAllUsersFromDb() called");
    loadAdminFunctionalityList();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    _userList.value = querySnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    log("_userList.length: ${_userList.length}");
    update();
  }

  Future<void> loadUserDeviceToken() async {
    log("loadUserDeviceToken() called");

    if (Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]);
    }

    _fcm.getAPNSToken().then((value) => print("APN Token === $value"));

    String? token = await _fcm.getToken();
    assert(token != null);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(_userModel.value.username)
        .update({
      'userDeviceToken': token,
    });
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

  Future<void> createUser(
      {required String username, required String password}) async {
    log("createUser() called");
    await FirebaseFirestore.instance.collection("users").doc(username).set({
      'username': username,
      'password': password,
      'isAdmin': false,
      'arrivalDate': Timestamp.fromDate(DateTime(2023, 4, 1)),
      'userDeviceToken': "",
    });
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
        await loadUserDeviceToken();
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

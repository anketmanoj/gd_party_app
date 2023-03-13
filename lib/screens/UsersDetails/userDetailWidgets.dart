import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/UsersDetails/editUserPage.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void onMoreOptionsClicked({required UserModel userModel}) {
  log('More options clicked');

  Get.bottomSheet(
    Container(
      width: 100.w,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              log('Edit Profile clicked');
              Get.back();
              Get.toNamed(
                EditUserPage.routeName,
                arguments: userModel,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Send Notification'),
            onTap: () {
              log('Send Notification clicked');
            },
          ),
        ],
      ),
    ),
  );
}

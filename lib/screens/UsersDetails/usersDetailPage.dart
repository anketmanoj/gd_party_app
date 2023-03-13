import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/ProfileScreen/profilePageWidgets.dart';
import 'package:gd_party_app/screens/UsersDetails/userDetailWidgets.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';

class UsersDetailsPage extends StatelessWidget {
  static const String routeName = "/users-details-page";
  const UsersDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Scaffold(
        appBar: AppBar(
            title: Text("Users Details Page"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            )),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: userController.userList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title:
                    Text(userController.userList[index].username.capitalize!),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(userController.userModel.userimage ??
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => onMoreOptionsClicked(
                      userModel: userController.userList[index]),
                  icon: Icon(Icons.more_vert),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/screens/ProfileScreen/profileController.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:gd_party_app/widgets/task_column.dart';
import 'package:get/get.dart';

Widget profileImage({required BuildContext context}) {
  return GetBuilder<UserController>(builder: (userController) {
    return Stack(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(userController.userModel.userimage ??
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    // TODO: Add image picker
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 5,
          child: InkWell(
            onTap: () {
              Get.find<UserController>().logout();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  });
}

// Icon button to logout user
final logoutButton = IconButton(
  icon: Icon(Icons.logout),
  onPressed: () {
    Get.find<UserController>().logout();
  },
);

Widget userNameAndBio() {
  return GetBuilder<UserController>(
    builder: (userController) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              userController.userModel.username.capitalize!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}

List<EmergencyContact> emergencyContacts = [
  EmergencyContact(
    icon: Icons.security,
    title: "Police",
    number: "0335038484",
    description: "Police Consultation in English",
  ),
  EmergencyContact(
    icon: Icons.local_hospital,
    title: "Ambulance",
    number: "119",
    description: "For Hospital Emergency",
  ),
  EmergencyContact(
    icon: Icons.people,
    title: "GD Team",
    number: "09091354209",
    description: "Call the team for any assistance",
  ),
];

Widget emergencyTile() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      children: [
        InkWell(
          onTap: () {
            Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: emergencyContactsList(),
              ),
            );
          },
          child: TaskColumn(
            icon: Icons.local_phone,
            iconBackgroundColor: LightColors.kBlue,
            title: 'Emergency Contacts',
            subtitle: 'Police | Ambulance | GD Team',
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            //  ! Todo: Submit users allergies and medical conditions
          },
          child: TaskColumn(
            icon: Icons.local_hospital,
            iconBackgroundColor: LightColors.kRed,
            title: 'Allergies and Medical Conditions',
            subtitle: 'Please tell us about your dietary restrictions',
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            //  ! Todo: Submit users allergies and medical conditions
          },
          child: TaskColumn(
            icon: Icons.emergency,
            iconBackgroundColor: LightColors.kGreen,
            title: 'Emergency Contact',
            subtitle: 'Emergency Contact Details',
          ),
        ),
      ],
    ),
  );
}

Widget adminFunctionality() {
  return GetBuilder<UserController>(builder: (userController) {
    return Visibility(
      visible: userController.userModel.isAdmin ?? false,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: userController.adminFunctionsList[index].onTap,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            userController.adminFunctionsList[index].icon,
                            size: 90,
                          ),
                        ),
                        Text(userController.adminFunctionsList[index].title),
                      ],
                    ),
                  ),
                );
              },
              itemCount: userController.adminFunctionsList.length,
            ),
          ],
        ),
      ),
    );
  });
}

// ListViewBuilder widget to show users events
Widget emergencyContactsList() {
  return GetBuilder<ProfileController>(builder: (profileController) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: emergencyContacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(emergencyContacts[index].title),
          subtitle: Text(emergencyContacts[index].description),
          trailing: Icon(emergencyContacts[index].icon),
          onTap: () {
            profileController.launchCaller(
                number: emergencyContacts[index].number);
          },
          // onTap: profileController.emergencyContacts[index].onTap,
        );
      },
    );
  });
}

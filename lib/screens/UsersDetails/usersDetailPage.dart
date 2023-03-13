import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/ProfileScreen/profilePageWidgets.dart';
import 'package:gd_party_app/screens/UsersDetails/userDetailWidgets.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:gd_party_app/services/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UsersDetailsPage extends StatelessWidget {
  static const String routeName = "/users-details-page";
  UsersDetailsPage({Key? key}) : super(key: key);

  ValueNotifier<TextEditingController> _dateController =
      ValueNotifier(TextEditingController());
  ValueNotifier<TextEditingController> _timeController =
      ValueNotifier(TextEditingController());

  ValueNotifier<DateTime> selectedDate =
      ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<TimeOfDay> selectedTime =
      ValueNotifier<TimeOfDay>(TimeOfDay.now());

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      selectedDate.value = picked;
      _dateController.value.text = DateFormat.yMd().format(selectedDate.value);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
      _timeController.value.text =
          "${selectedTime.value.hour}:${selectedTime.value.minute}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final TextEditingController _usernameController =
                TextEditingController();
            final TextEditingController _passwordController =
                TextEditingController();

            final _formKey = GlobalKey<FormState>();
            Get.bottomSheet(
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Create New User"),
                      SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        lines: 1,
                        controller: _usernameController,
                        labelText: "Username",
                        onSubmit: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Username cannot be empty";
                          }
                          return null;
                        },
                      ),
                      CustomFormField(
                        lines: 1,
                        controller: _passwordController,
                        labelText: "Password",
                        onSubmit: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SubmitButton(function: () async {
                        if (_formKey.currentState!.validate()) {
                          await userController.createUser(
                              username: _usernameController.text,
                              password: _passwordController.text);
                          Get.back();
                          // Get success dialog
                          Get.defaultDialog(
                            title: "Success",
                            middleText: "User Created Successfully",
                            textConfirm: "Ok",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              Get.back();
                            },
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            );
          },
          child: Icon(Icons.add),
        ),
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  UserModel userModel = UserModel.fromJson(
                      snapshot.data!.docs[index].data()
                          as Map<String, dynamic>);

                  log("user device token: ${userModel.userDeviceToken}");
                  return ListTile(
                    title: Text(userModel.username.capitalize!),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(userModel.userimage ??
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () =>
                          onMoreOptionsClicked(userModel: userModel),
                      icon: Icon(Icons.more_vert),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
}

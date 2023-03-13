import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class EditUserPage extends StatelessWidget {
  static const String routeName = "/edit-user-page";

  EditUserPage({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User Page"),
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(userModel.userimage ??
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Username"),
                subtitle: Text(userModel.username),
              ),
              ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text("Password"),
                subtitle: Text(userModel.password),
                trailing: IconButton(
                  onPressed: () {
                    TextEditingController _passwordController =
                        TextEditingController();
                    final _formKey = GlobalKey<FormState>();
                    Get.defaultDialog(
                      title: "Edit Password",
                      barrierDismissible: false,
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            // if space is present
                            if (value.contains(" ")) {
                              return "Password cannot contain space";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Enter new password",
                          ),
                        ),
                      ),
                      textConfirm: "Confirm",
                      textCancel: "Cancel",
                      onConfirm: () async {
                        if (_formKey.currentState!.validate()) {
                          userModel.password = _passwordController.text;
                          log("Confirm clicked");
                          await userController.updateUserPassword(
                              selectedUser: userModel,
                              newPassword: _passwordController.text);

                          Get.back();
                        }
                      },
                      onCancel: () {
                        log("Cancel clicked");
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Arrival Date"),
                subtitle: Text(userModel.arrivalDate == null
                    ? "Not Set"
                    : DateFormat("dd/MM/yyyy | hh:mm a")
                        .format(userModel.arrivalDate!.toDate())),
                leading: Icon(Icons.airplanemode_on),
                trailing: IconButton(
                  onPressed: () async {
                    await _selectDate(context)
                        .then((value) => _selectTime(context));

                    log("selectedtime == ${selectedTime.toString()} | selectedDate = ${selectedDate.toString()}");

                    Get.defaultDialog(
                      title: "Arrival DateTime",
                      barrierDismissible: false,
                      content: Text(
                          "${DateFormat.yMd().format(selectedDate.value)} ${selectedTime.value.hour}:${selectedTime.value.minute}"),
                      textConfirm: "Confirm",
                      textCancel: "Cancel",
                      onConfirm: () async {
                        final Timestamp timeToPost = Timestamp.fromDate(
                            DateTime(
                                selectedDate.value.year,
                                selectedDate.value.month,
                                selectedDate.value.day,
                                selectedTime.value.hour,
                                selectedTime.value.minute));
                        userModel.arrivalDate = timeToPost;
                        await userController.updateUserArrivalDate(
                            selectedUser: userModel,
                            newDate: userModel.arrivalDate!);
                        Get.back();
                      },
                      onCancel: () {
                        log("Cancel clicked");
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Is Admin"),
                subtitle: Text(userModel.isAdmin.toString().capitalize!),
                leading: Icon(Icons.admin_panel_settings),
                trailing: Switch(
                    value: userModel.isAdmin,
                    onChanged: (value) async {
                      log("value = $value");
                      userModel.isAdmin = value;
                      await userController.updateUserIsAdmin(
                          selectedUser: userModel,
                          newIsAdmin: userModel.isAdmin);
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

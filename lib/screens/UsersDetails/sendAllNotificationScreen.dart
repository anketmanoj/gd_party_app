import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:gd_party_app/services/utils.dart';
import 'package:get/get.dart';

class SendAllUsersNotification extends StatelessWidget {
  static const String routeName = "/send-all-users-notification-page";
  SendAllUsersNotification({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> absorbing = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send User Notification Page"),
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomFormField(
                  lines: 1,
                  controller: _titleController,
                  labelText: "Title",
                  onSubmit: (val) {},
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Title cannot be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  lines: 6,
                  controller: _bodyController,
                  labelText: "Body",
                  onSubmit: (val) {},
                  validator: (val) {
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedBuilder(
                    animation: Listenable.merge([absorbing]),
                    builder: (context, _) {
                      return AbsorbPointer(
                        absorbing: absorbing.value,
                        child: SubmitButton(
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              absorbing.value = true;
                              log("sending now!");
                              //  Get loading dialog
                              Get.dialog(
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              //  Send notification
                              await userController.sendNotificationToAllUsers(
                                title: _titleController.text,
                                body: _bodyController.text,
                              );

                              Get.back();

                              absorbing.value = false;
                            }
                          },
                          text: "Send Notification",
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

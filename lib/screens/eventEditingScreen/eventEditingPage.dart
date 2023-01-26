import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/eventEditingScreen/evenWidgets.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingModel.dart';
import 'package:get/get.dart';

class EventEditingPage extends GetView<EventEditingController> {
  static const String routeName = "/event-editing-page";
  EventEditingPage({Key? key}) : super(key: key);

  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Add"),
        actions: [
          IconButton(
            onPressed: () => eventEditingController.saveForm(),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: eventEditingController.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BuildTitle(),
                SizedBox(
                  height: 10,
                ),
                BuildDateTimePickers(),
                SizedBox(
                  height: 10,
                ),
                BuildEventDescription(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

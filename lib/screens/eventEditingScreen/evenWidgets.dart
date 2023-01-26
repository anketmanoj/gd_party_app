import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/services/utils.dart';
import 'package:get/get.dart';

class BuildTitle extends StatelessWidget {
  BuildTitle({
    Key? key,
  }) : super(key: key);

  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 22),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Add Title",
      ),
      onFieldSubmitted: (_) {},
      controller: eventEditingController.titleController,
      validator: (title) =>
          title != null && title.isEmpty ? "Title cannot be empty" : null,
    );
  }
}

class BuildEventDescription extends StatelessWidget {
  BuildEventDescription({Key? key}) : super(key: key);

  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      minLines: 9,
      maxLines: 9,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Add Description",
      ),
      onFieldSubmitted: (_) {},
      controller: eventEditingController.descriptionController,
    );
  }
}

class BuildDateTimePickers extends StatelessWidget {
  BuildDateTimePickers({Key? key}) : super(key: key);
  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() => buildHeader(
        header: "FROM",
        child: Obx(() {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: buildDropDownField(
                  text: Utils.toDate(eventEditingController.fromDate.value),
                  onClicked: () => eventEditingController.pickFromDateTime(
                      pickDate: true, fromOrTo: "FROM"),
                ),
              ),
              Expanded(
                child: buildDropDownField(
                  text: Utils.toTime(eventEditingController.fromDate.value),
                  onClicked: () => eventEditingController.pickFromDateTime(
                      pickDate: false, fromOrTo: "FROM"),
                ),
              ),
            ],
          );
        }),
      );

  Widget buildTo() => buildHeader(
        header: "TO",
        child: Obx(() {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: buildDropDownField(
                  text: Utils.toDate(eventEditingController.toDate.value),
                  onClicked: () => eventEditingController.pickToDateTime(
                      pickDate: true, fromOrTo: "TO"),
                ),
              ),
              Expanded(
                child: buildDropDownField(
                  text: Utils.toTime(eventEditingController.toDate.value),
                  onClicked: () => eventEditingController.pickToDateTime(
                      pickDate: false, fromOrTo: "TO"),
                ),
              ),
            ],
          );
        }),
      );

  Widget buildDropDownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );
}

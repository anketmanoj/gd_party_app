import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingModel.dart';
import 'package:get/get.dart';

class EventEditingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().add(const Duration(hours: 2)).obs;
  RxList<Event> _events = <Event>[].obs;
  RxList<Event> get events => _events;

  Rx<DateTime> _selectedDate = DateTime.now().obs;
  Rx<DateTime> get selectedDate => _selectedDate;

  List<Event> get eventsOfSelectedDate => _events;

  void setSelectedDate(DateTime date) {
    _selectedDate.value = date;
    update();
  }

  void addEvent(Event event) {
    _events.add(event);
    update();

    log(_events.length.toString());
  }

  Future saveForm() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      Event event = Event(
        title: titleController.text,
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text,
        from: fromDate.value,
        to: toDate.value,
      );

      titleController.clear();
      descriptionController.clear();
      fromDate.value = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2)).obs;

      addEvent(event);
      Get.back();
    }
  }

  Future<DateTime?> pickDateTime(Rx<DateTime> initDate,
      {required bool pickDate,
      DateTime? firstDate,
      required String fromOrTo}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: Get.context!,
        initialDate: initDate.value,
        firstDate: firstDate ?? DateTime(2023, 1),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;

      final time =
          Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute);

      date.add(time);

      return date;
    } else {
      final timeOfDay = await showTimePicker(
          context: Get.context!, initialTime: TimeOfDay.now());

      if (timeOfDay == null) return null;

      if (fromOrTo == "FROM") {
        final date = DateTime(
            fromDate.value.year, fromDate.value.month, fromDate.value.day);
        final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

        return date.add(time);
      } else {
        final date =
            DateTime(toDate.value.year, toDate.value.month, toDate.value.day);
        final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

        return date.add(time);
      }
    }
  }

  void pickFromDateTime(
      {required bool pickDate, required String fromOrTo}) async {
    final date =
        await pickDateTime(fromDate, pickDate: pickDate, fromOrTo: fromOrTo);

    if (date == null) return null;

    fromDate.value = date;
    update();

    if (date.isAfter(toDate.value)) {
      toDate.value = fromDate.value;
      update();
    }
  }

  void pickToDateTime(
      {required bool pickDate, required String fromOrTo}) async {
    final date = await pickDateTime(fromDate,
        pickDate: pickDate,
        fromOrTo: fromOrTo,
        firstDate: pickDate ? fromDate.value : null);

    if (date == null) return null;

    toDate.value = date;
    update();

    if (date.isBefore(fromDate.value)) {
      fromDate.value = toDate.value;
      update();
    }
  }
}

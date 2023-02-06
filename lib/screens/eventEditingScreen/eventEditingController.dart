import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:gd_party_app/constants/apiKeys.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingModel.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmf;
import 'package:http/http.dart' as http;

class EventEditingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().add(const Duration(hours: 2)).obs;
  RxList<Event> _events = <Event>[].obs;
  RxList<Event> get events => _events;
  Rx<LatLng>? _latLng;
  Rx<LatLng>? get latLng => _latLng;
  gmf.CameraPosition? _initCameraPosition;
  gmf.CameraPosition? get initCameraPosition => _initCameraPosition;
  bool _latLngSet = false;
  bool get latLngSet => _latLngSet;
  String _setFullAddress = "";
  String get setFullAddress => _setFullAddress;
  String url = "";

  final Rx<Completer<gmf.GoogleMapController>> mapsController =
      Completer<gmf.GoogleMapController>().obs;

  void onMapCreated(gmf.GoogleMapController controller) async {
    mapsController.value.complete(controller);

    update();
  }

  void resetLatLng() {
    _latLngSet = false;
    update();
  }

  void getLatLngOfPlace({required LatLng latLngRecieved}) {
    _latLngSet = true;
    _latLng = latLngRecieved.obs;
    log("${_latLng!.value.lat} , ${_latLng!.value.lng}");

    _initCameraPosition = gmf.CameraPosition(
      zoom: 17,
      target: gmf.LatLng(_latLng!.value.lat, _latLng!.value.lng),
    );
    update();
  }

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

  Future<void> fetchPhoto({required String placeId}) async {
    final place_id = placeId;

    final placeRes = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$place_id&key=$kGoogleApiKey'));

    final Map<String, dynamic> placeData = jsonDecode(placeRes.body);

    final List photos = placeData['result']["photos"];

    for (var photo in photos) {
      final photo_reference = photo['photo_reference'];
      final url =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photo_reference&key=$kGoogleApiKey";
      this.url = url;
      log("URL ===== ${this.url}");
      update();
    }
  }

  Future saveForm() async {
    final isValid = formKey.currentState!.validate();

    if (isValid && _latLng != null) {
      Event event = Event(
        imgUrl: url,
        placeDetail: _setFullAddress,
        locationLat: _latLng!.value.lat,
        locationLng: _latLng!.value.lng,
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
    } else {
      Get.snackbar("Incomplete Form",
          "Please make sure you've added a title, description and the map location");
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

  final Rx<TextEditingController> appBarSearchController =
      TextEditingController().obs;
  final String _result = "Search";
  String get result => _result;
  RxList<AutocompletePrediction> _predictions = <AutocompletePrediction>[].obs;

  RxList<AutocompletePrediction> get getPredictions => _predictions;

  final places = FlutterGooglePlacesSdk(kGoogleApiKey);

  void searchPlace() async {
    log(appBarSearchController.string);
    final predictions = await places
        .findAutocompletePredictions(appBarSearchController.value.text);

    log('Result List: ${predictions.predictions[0].fullText}');

    _predictions.value = predictions.predictions;
    update();
  }

  void onTapPlace({required AutocompletePrediction selectedPrediction}) async {
    FetchPlaceResponse response = await places
        .fetchPlace(selectedPrediction.placeId, fields: [PlaceField.Location]);
    _setFullAddress = selectedPrediction.fullText;
    log("ADDRESS == ${_setFullAddress}");
    update();

    await fetchPhoto(placeId: selectedPrediction.placeId);

    getLatLngOfPlace(latLngRecieved: response.place!.latLng!);

    log(response.toString());
  }
}

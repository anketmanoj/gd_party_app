import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingModel.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  final Rx<Completer<GoogleMapController>> mapsController =
      Completer<GoogleMapController>().obs;

  static const LatLng center = LatLng(-33.86711, 151.1947171);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;
  LatLng? markerPosition;
  late MarkerId? _selectedId = MarkerId("test");
  MarkerId? get getSelectedId => _selectedId;

  final CameraPosition _initGooglePosition = CameraPosition(
    target: LatLng(35.588718277489804, 139.47903286742255),
    zoom: 15,
  );

  bool checkIfMarkerExists(Event event) {
    if (markers
        .containsKey("marker_id_${event.locationLat}${event.locationLng}")) {
      return true;
    } else {
      return false;
    }
  }

  CameraPosition get initGooglePosition => _initGooglePosition;

  void onMapCreated(GoogleMapController controller) {
    mapsController.value.complete(controller);
    _selectedId = selectedMarker;
    update();
  }

  void onMarkerTapped(MarkerId markerId) {
    final Marker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      final MarkerId? previousMarkerId = selectedMarker;
      if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
        final Marker resetOld = markers[previousMarkerId]!
            .copyWith(iconParam: BitmapDescriptor.defaultMarker);
        markers[previousMarkerId] = resetOld;
      }
      selectedMarker = markerId;
      final Marker newMarker = tappedMarker.copyWith(
        iconParam: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      );
      markers[markerId] = newMarker;

      markerPosition = null;
      update();
    }
  }

  Future<void> onMarkerDrag(MarkerId markerId, LatLng newPosition) async {
    markerPosition = newPosition;
    update();
  }

  Future<void> onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      markerPosition = null;
      update();
      Get.dialog(SimpleDialog(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 66),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Old position: ${tappedMarker.position}'),
                Text('New position: $newPosition'),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: Get.back,
                        child: Text("Okay"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ));
    }
  }

  void getMarkersFromEvents() {}

  void add(
      {required double latitude,
      required double longitude,
      String? title,
      String? description}) {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$latitude$longitude';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latitude,
        longitude,
      ),
      infoWindow: InfoWindow(
        title: title ?? markerIdVal,
        snippet: description ?? '*',
      ),
      onTap: () => onMarkerTapped(markerId),
      onDragEnd: (LatLng position) => onMarkerDragEnd(markerId, position),
      onDrag: (LatLng position) => onMarkerDrag(markerId, position),
    );

    markers[markerId] = marker;
    dev.log("marker added | total == ${markers.length}");
    update();
  }

  void remove(MarkerId markerId) {
    if (markers.containsKey(markerId)) {
      markers.remove(markerId);
      update();
    }
  }

  void changePosition(MarkerId markerId) {
    final Marker marker = markers[markerId]!;
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    markers[markerId] = marker.copyWith(
      positionParam: LatLng(
        center.latitude + offset.dy,
        center.longitude + offset.dx,
      ),
    );

    update();
  }

  void changeAnchor(MarkerId markerId) {
    final Marker marker = markers[markerId]!;
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    markers[markerId] = marker.copyWith(
      anchorParam: newAnchor,
    );
    update();
  }
}

import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/apiKeys.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/services/utils.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sizer/sizer.dart';

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

class SearchPlace extends StatelessWidget {
  SearchPlace({Key? key}) : super(key: key);
  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            eventEditingController.searchPlace();
          },
          child: Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 5.h,
              color: Colors.red,
              child: Text("Search"),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchAppBarWidget extends StatelessWidget {
  final EventEditingController eventEditingController =
      Get.put(EventEditingController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: TextField(
        controller: eventEditingController.appBarSearchController.value,
        decoration: InputDecoration(
          hintText: "Search for a place",
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: eventEditingController.searchPlace,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class SearchResultsList extends StatelessWidget {
  SearchResultsList({Key? key}) : super(key: key);

  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              eventEditingController.onTapPlace(
                  selectedPrediction:
                      eventEditingController.getPredictions[index]);
            },
            title:
                Text(eventEditingController.getPredictions[index].primaryText),
            subtitle: Text(
                eventEditingController.getPredictions[index].secondaryText),
          );
        },
        itemCount: eventEditingController.getPredictions.length,
        shrinkWrap: true,
      );
    });
  }
}

class LocationSelected extends StatelessWidget {
  const LocationSelected({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventEditingController>(builder: (eec) {
      return Visibility(
        replacement: Container(
          height: 20.h,
          width: 100.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.red),
          child: eec.initCameraPosition != null
              ? Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: eec.initCameraPosition!,
                        onMapCreated: eec.onMapCreated,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        trafficEnabled: true,
                        markers: {
                          Marker(
                            markerId: MarkerId("initMarker"),
                            position: LatLng(
                              eec.latLng!.value.lat,
                              eec.latLng!.value.lng,
                            ),
                          ),
                        },
                        onTap: (argument) {},
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: InkWell(
                        onTap: eec.resetLatLng,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(),
        ),
        visible: eec.latLngSet == false,
        child: Column(
          children: [
            SearchAppBarWidget(),
            SearchResultsList(),
          ],
        ),
      );
    });
  }
}

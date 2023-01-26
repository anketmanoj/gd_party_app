import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/screens/ScheduleScreen/views/calenderWidget.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingPage.dart';
import 'package:gd_party_app/services/mock_data.dart';
import 'package:gd_party_app/widgets/calendar_dates.dart';
import 'package:gd_party_app/widgets/task_container.dart';
import 'package:get/get.dart';

class SchedulePage extends StatelessWidget {
  static const String routeName = "/schedule-page";
  SchedulePage({Key? key}) : super(key: key);
  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style:
            TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  final EventEditingController eventEditingController =
      Get.put(EventEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => EventEditingPage()),
        child: Icon(Icons.add),
      ),
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Today',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Exciting Day ahead, Anket',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Expanded(child: CalenderWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

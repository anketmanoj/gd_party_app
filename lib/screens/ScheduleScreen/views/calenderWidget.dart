import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/screens/ScheduleScreen/models/eventDataSource.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/tasksScreen/tasksWidget.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderWidget extends StatelessWidget {
  CalenderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventEditingController>(builder: (events) {
      return SfCalendar(
        view: CalendarView.month,
        initialSelectedDate: DateTime.now(),
        dataSource: EventDataSource(events.events),
        onLongPress: (details) {
          events.setSelectedDate(details.date!);
          Get.bottomSheet(
            Container(
              height: 60.h,
              width: 100.w,
              color: LightColors.kLightYellow,
              child: TasksWidget(),
            ),
          );
        },
      );
    });
  }
}

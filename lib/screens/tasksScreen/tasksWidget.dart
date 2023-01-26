import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/ScheduleScreen/models/eventDataSource.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingModel.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends StatelessWidget {
  TasksWidget({Key? key}) : super(key: key);
  final EventEditingController eventController =
      Get.put(EventEditingController());
  @override
  Widget build(BuildContext context) {
    final selectedEvents = eventController.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text("No events found!"),
      );
    }
    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(eventController.events),
      initialDisplayDate: eventController.selectedDate.value,
      appointmentBuilder: buildAppointmentBuilder,
      onTap: (details) {
        final Event event = details.appointments!.first;
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.all(10),
            height: 30.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${event.title}"),
                Text(
                  "Description: ${event.description}",
                  maxLines: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAppointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final Event event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          event.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

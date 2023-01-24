import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/navigation/custom_bottom_navigation_bar.dart';
import 'package:gd_party_app/widgets/active_project_card.dart';
import 'package:gd_party_app/widgets/task_column.dart';
import 'package:gd_party_app/widgets/top_container.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home-page";
  const HomePage({Key? key}) : super(key: key);
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: Column(
        children: <Widget>[
          TopContainer(
            height: 18.h,
            width: width,
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 5.0,
                        animation: true,
                        percent: 0.75,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: LightColors.kRed,
                        backgroundColor: LightColors.kDarkYellow,
                        center: CircleAvatar(
                          backgroundColor: LightColors.kBlue,
                          radius: 25.0,
                          child: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Anket Waswani',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: LightColors.kDarkBlue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              'App Developer',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black45,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            subheading('Schedule Overview'),
                            GestureDetector(
                              onTap: () {},
                              child: calendarIcon(),
                            ),
                          ],
                        ),
                        TaskColumn(
                          icon: Icons.blur_circular,
                          iconBackgroundColor: LightColors.kDarkYellow,
                          title: 'In Progress',
                          subtitle: 'None',
                        ),
                        SizedBox(height: 15.0),
                        TaskColumn(
                          icon: Icons.alarm,
                          iconBackgroundColor: LightColors.kRed,
                          title: 'Upcoming',
                          subtitle: 'Departure',
                        ),
                        SizedBox(height: 15.0),
                        TaskColumn(
                          icon: Icons.check_circle_outline,
                          iconBackgroundColor: LightColors.kBlue,
                          title: 'Emergency Contact',
                          subtitle: 'Police | Ambulance',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subheading('Translation Shortcut'),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 25.h,
                                decoration: BoxDecoration(
                                  color: kFifthColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "English",
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.change_circle_outlined),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("Japanese"),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subheading('Currency Converter'),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kFifthColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "USD",
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.change_circle_outlined),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("YEN"),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

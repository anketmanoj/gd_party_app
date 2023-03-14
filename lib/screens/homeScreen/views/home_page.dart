import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/navigation/custom_bottom_navigation_bar.dart';
import 'package:gd_party_app/screens/ProfileScreen/profilePageWidgets.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingController.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page_widgets.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:gd_party_app/widgets/active_project_card.dart';
import 'package:gd_party_app/widgets/task_column.dart';
import 'package:gd_party_app/widgets/top_container.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home-page";
  HomePage({Key? key}) : super(key: key);
  UserController userController = Get.put(UserController());
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
                          backgroundColor: LightColors.kLavender,
                          radius: 25.0,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(userController
                                        .userModel.userimage ??
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userController.userModel.username.capitalize!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Visibility(
                            visible: userController.userModel.userBio != null,
                            child: Text(
                              userController.userModel.userBio ?? "",
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
                  GetBuilder<EventEditingController>(
                      builder: (eventController) {
                    return Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
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
                          eventController.currentEvent != null
                              ? Column(
                                  children: [
                                    TaskColumn(
                                      icon: Icons.blur_circular,
                                      iconBackgroundColor:
                                          LightColors.kDarkYellow,
                                      title: "In Progress",
                                      subtitle:
                                          eventController.currentEvent!.title,
                                    ),
                                    SizedBox(height: 15.0),
                                  ],
                                )
                              : SizedBox(),
                          eventController.nextEvent != null
                              ? Column(
                                  children: [
                                    TaskColumn(
                                      icon: Icons.alarm,
                                      iconBackgroundColor: LightColors.kRed,
                                      title: 'Upcoming',
                                      subtitle:
                                          eventController.nextEvent!.title,
                                    ),
                                    SizedBox(height: 15.0),
                                  ],
                                )
                              : SizedBox(),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: emergencyContactsList(),
                                ),
                              );
                            },
                            child: TaskColumn(
                              icon: Icons.check_circle_outline,
                              iconBackgroundColor: LightColors.kBlue,
                              title: 'Emergency Contact',
                              subtitle: 'Police | Ambulance',
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subheading('Arrival Progress'),
                        TimelineDelivery(),
                      ],
                    ),
                  ),
                  // Container(
                  //   color: Colors.transparent,
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       subheading('Translation Shortcut'),
                  //       SizedBox(height: 5.0),
                  //       Row(
                  //         children: <Widget>[
                  //           Expanded(
                  //             child: Container(
                  //               height: 25.h,
                  //               decoration: BoxDecoration(
                  //                 color: kFifthColor,
                  //                 borderRadius: BorderRadius.circular(20),
                  //               ),
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Expanded(
                  //                         flex: 1,
                  //                         child: Container(
                  //                           alignment: Alignment.center,
                  //                           child: Text(
                  //                             "English",
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       IconButton(
                  //                         onPressed: () {},
                  //                         icon: Icon(
                  //                             Icons.change_circle_outlined),
                  //                       ),
                  //                       Expanded(
                  //                         flex: 1,
                  //                         child: Container(
                  //                           child: Text("Japanese"),
                  //                           alignment: Alignment.center,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   color: Colors.transparent,
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       subheading('Currency Converter'),
                  //       SizedBox(height: 5.0),
                  //       Row(
                  //         children: <Widget>[
                  //           Expanded(
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 color: kFifthColor,
                  //                 borderRadius: BorderRadius.circular(20),
                  //               ),
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Expanded(
                  //                         flex: 1,
                  //                         child: Container(
                  //                           alignment: Alignment.center,
                  //                           child: Text(
                  //                             "USD",
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       IconButton(
                  //                         onPressed: () {},
                  //                         icon: Icon(
                  //                             Icons.change_circle_outlined),
                  //                       ),
                  //                       Expanded(
                  //                         flex: 1,
                  //                         child: Container(
                  //                           child: Text("YEN"),
                  //                           alignment: Alignment.center,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

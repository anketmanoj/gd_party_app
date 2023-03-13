import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/screens/homeScreen/models/arrivalProgressModel.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineDelivery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(Get.find<UserController>().userModel.username)
            .collection("arrivalProgress")
            .orderBy("index", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              ArrivalProgressModel arrivalProgressModel =
                  ArrivalProgressModel.fromJson(snapshot.data!.docs[index]
                      .data() as Map<String, dynamic>);
              return InkWell(
                onTap: () async {
                  switch (arrivalProgressModel.index) {
                    case 0:
                      log("Departure Airport");
                      if (arrivalProgressModel.index == 0 &&
                          arrivalProgressModel.completed == false) {
                        progressUpdate(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(Get.find<UserController>()
                                    .userModel
                                    .username)
                                .collection("arrivalProgress")
                                .doc("departureAirport")
                                .update({
                              "completed": true,
                              "timestamp": Timestamp.now(),
                            });

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(Get.find<UserController>()
                                    .userModel
                                    .username)
                                .collection("arrivalProgress")
                                .doc("landedInJapan")
                                .update({
                              "next": true,
                            });

                            Get.back();
                          },
                          title: "Departure Airport",
                          message: "I have arrived at the departure airport",
                        );
                      } else {
                        errorProgress(
                          message: "Already arrived at Depature Airport",
                        );
                      }

                      break;
                    case 1:
                      log("Landed In Japan");
                      if (arrivalProgressModel.next == true) {
                        if (arrivalProgressModel.completed == false) {
                          progressUpdate(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("landedInJapan")
                                  .update({
                                "completed": true,
                                "timestamp": Timestamp.now(),
                              });

                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("throughImmigration")
                                  .update({
                                "next": true,
                              });

                              Get.back();
                            },
                            title: "Arrival Airport",
                            message: "I have landed in Japan",
                          );
                        } else {
                          errorProgress(
                            message: "Already updated: Landed in Japan",
                          );
                        }
                      } else {
                        errorProgress(
                            message: "Please arrive at Depature Airport first");
                      }
                      break;
                    case 2:
                      log("Through Immigration");
                      if (arrivalProgressModel.next == true) {
                        if (arrivalProgressModel.completed == false) {
                          progressUpdate(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("throughImmigration")
                                  .update({
                                "completed": true,
                                "timestamp": Timestamp.now(),
                              });

                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("baggageClaim")
                                  .update({
                                "next": true,
                              });
                              Get.back();
                            },
                            title: "Immigration Check",
                            message: "Completed Immigration Check",
                          );
                        } else {
                          errorProgress(
                            message: "Already updated: Immigration Check",
                          );
                        }
                      } else {
                        errorProgress(message: "Please land in Japan first");
                      }
                      break;
                    case 3:
                      log("Baggage Claim");
                      if (arrivalProgressModel.next == true) {
                        if (arrivalProgressModel.completed == false) {
                          progressUpdate(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("baggageClaim")
                                  .update({
                                "completed": true,
                                "timestamp": Timestamp.now(),
                              });

                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("waitingForPickup")
                                  .update({
                                "next": true,
                              });
                              Get.back();
                            },
                            title: "Baggage Claimed",
                            message: "You've collected your baggage",
                          );
                        } else {
                          errorProgress(
                            message: "Already updated: Baggage Claimed",
                          );
                        }
                      } else {
                        errorProgress(
                            message: "Please pass trhough immigration first");
                      }
                      break;
                    case 4:
                      log("Waiting for Pick up");
                      if (arrivalProgressModel.next == true) {
                        if (arrivalProgressModel.completed == false) {
                          progressUpdate(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(Get.find<UserController>()
                                      .userModel
                                      .username)
                                  .collection("arrivalProgress")
                                  .doc("waitingForPickup")
                                  .update({
                                "completed": true,
                                "timestamp": Timestamp.now(),
                              });

                              Get.back();
                            },
                            title: "Waiting for Pick up",
                            message:
                                "Im at the airport exit waiting for pick up",
                          );
                        } else {
                          errorProgress(
                            message: "Already updated: Waiting for pickup",
                          );
                        }
                      } else {
                        errorProgress(message: "Please collect baggage first");
                      }
                      break;
                    default:
                      log("Default");
                  }
                },
                child: TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: arrivalProgressModel.index == 0 ? true : false,
                  isLast: arrivalProgressModel.index ==
                          snapshot.data!.docs.length - 1
                      ? true
                      : false,
                  indicatorStyle: arrivalProgressModel.completed == true
                      ? CompletedProgressItem()
                      : arrivalProgressModel.next == true
                          ? PendingProgressItem()
                          : YetToStartProgressItem(),
                  endChild: RightChild(
                    imageUrl: arrivalProgressModel.imageUrl,
                    title: arrivalProgressModel.title,
                    message: arrivalProgressModel.message,
                  ),
                  beforeLineStyle: const LineStyle(
                    color: LightColors.yetToStartProgress,
                  ),
                  afterLineStyle: const LineStyle(
                    color: LightColors.yetToStartProgress,
                  ),
                ),
              );
            },
            // children: <Widget>[
            //   TimelineTile(
            //     alignment: TimelineAlign.manual,
            //     lineXY: 0.1,
            //     isFirst: true,
            //     indicatorStyle: CompletedProgressItem(),
            //     endChild: const RightChild(
            //       imageUrl:
            //           'https://static.thenounproject.com/png/340428-200.png',
            //       title: 'Arrived At Departure airport',
            //       message: 'Im ready to go to Japan!',
            //     ),
            //     beforeLineStyle: const LineStyle(
            //       color: LightColors.currentProgress,
            //     ),
            //     afterLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //   ),
            //   TimelineTile(
            //     alignment: TimelineAlign.manual,
            //     lineXY: 0.1,
            //     indicatorStyle: YetToStartProgressItem(),
            //     endChild: const RightChild(
            //       disabled: true,
            //       imageUrl:
            //           'https://static.thenounproject.com/png/410143-200.png',
            //       title: 'Landed in Japan',
            //       message: 'Ive landed and entered the airport!',
            //     ),
            //     beforeLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //     afterLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //   ),
            //   TimelineTile(
            //     alignment: TimelineAlign.manual,
            //     lineXY: 0.1,
            //     indicatorStyle: YetToStartProgressItem(),
            //     endChild: const RightChild(
            //       disabled: true,
            //       imageUrl: 'https://static.thenounproject.com/png/31-200.png',
            //       title: 'Through Immigration',
            //       message: 'Ive completed Immigration',
            //     ),
            //     beforeLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //     afterLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //   ),
            //   TimelineTile(
            //     alignment: TimelineAlign.manual,
            //     lineXY: 0.1,
            //     indicatorStyle: YetToStartProgressItem(),
            //     endChild: const RightChild(
            //       disabled: true,
            //       imageUrl:
            //           'https://static.thenounproject.com/png/569938-200.png',
            //       title: 'Baggage Claim',
            //       message: 'Im collecting my bags now!',
            //     ),
            //     beforeLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //     afterLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //   ),
            //   TimelineTile(
            //     alignment: TimelineAlign.manual,
            //     lineXY: 0.1,
            //     isLast: true,
            //     indicatorStyle: YetToStartProgressItem(),
            //     endChild: RightChild(
            //       disabled: true,
            //       imageUrl:
            //           'https://amsholland.com/wp-content/uploads/2020/04/airport-pickup-icon-amsholland.fw_.png',
            //       title: 'Waiting in Lobby',
            //       message: 'Im waiting at the airport arrival lobby',
            //     ),
            //     beforeLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //     afterLineStyle: const LineStyle(
            //       color: LightColors.yetToStartProgress,
            //     ),
            //   ),
            // ],
          );
        });
  }

  Future<dynamic> errorProgress({required String message}) {
    return Get.dialog(
      AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  Future<dynamic> progressUpdate(
      {required String title,
      required String message,
      required VoidCallback onPressed}) {
    return Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  IndicatorStyle YetToStartProgressItem() {
    return const IndicatorStyle(
      width: 20,
      color: Color(0xFFDADADA),
      padding: EdgeInsets.all(6),
    );
  }

  IndicatorStyle PendingProgressItem() {
    return const IndicatorStyle(
      width: 20,
      color: LightColors.currentProgress,
      padding: EdgeInsets.all(6),
    );
  }

  IndicatorStyle CompletedProgressItem() {
    return IndicatorStyle(
      width: 20,
      color: Color(0xFF27AA69),
      padding: EdgeInsets.all(6),
    );
  }
}

class RightChild extends StatelessWidget {
  const RightChild({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.message,
    this.disabled = false,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.network(imageUrl, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title,
                    softWrap: true,
                    style: TextStyle(
                      color: disabled
                          ? const Color(0xFFBABABA)
                          : const Color(0xFF636564),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 6),
                Text(
                  message,
                  softWrap: true,
                  style: TextStyle(
                    color: disabled
                        ? const Color(0xFFD5D5D5)
                        : const Color(0xFF636564),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

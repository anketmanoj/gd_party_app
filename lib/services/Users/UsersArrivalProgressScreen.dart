import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/homeScreen/models/arrivalProgressModel.dart';
import 'package:gd_party_app/services/Users/userModel.dart';
import 'package:get/get.dart';

class UsersArrivalProgressScreen extends StatelessWidget {
  static const String routeName = "/users-arrival-progress-screen";
  const UsersArrivalProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users Arrival Progress Screen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("users").get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                UserModel userModel = UserModel.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);

                log("user device token: ${userModel.userDeviceToken}");
                return ListTile(
                  title: Text(userModel.username.capitalize!),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(userModel.userimage ??
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  trailing: FittedBox(
                    fit: BoxFit.contain,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(userModel.username)
                          .collection("arrivalProgress")
                          .orderBy("index", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        var lastProgress = snapshot.data!.docs
                            .lastWhere((element) => element['next'] == true);

                        ArrivalProgressModel arrivalProgressModel =
                            ArrivalProgressModel.fromJson(
                                lastProgress.data() as Map<String, dynamic>);

                        return Text(arrivalProgressModel.title);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

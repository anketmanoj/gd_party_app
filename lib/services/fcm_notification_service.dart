import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

class FCMNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _endpoint = "https://fcm.googleapis.com/fcm/send";
  final String _contentType = "application/json";
  final String _authorization =
      "Bearer AAAAolRoEew:APA91bEEZm-n7UWjfDKbZp6CgcgE2ri7C-Cu-c1jahTN3KSqcgrBAZtfneacA524OBjGepot2bSId6V7WUHsxwINX9RTvyMgGrFqXAO0E3HO4GLOuQlOuHFUzigzi6EIlx4wFeau9_FA";
  Future<http.Response?> sendNotificationToUser({
    required String to,
    required String title,
    required String body,
    String? click_action_url,
  }) async {
    try {
      final dynamic data = json.encode({
        'to': to,
        'priority': 'high',
        "click_action": click_action_url,
        'notification': click_action_url != null
            ? {"title": title, "body": body, "click_action": click_action_url}
            : {'title': title, 'body': body},
        'content_available': true,
      });

      http.Response response =
          await http.post(Uri.parse(_endpoint), body: data, headers: {
        'Content-Type': _contentType,
        'Authorization': _authorization,
      });

      return response;
    } catch (e) {
      print("ERROR FCM ==== ${e.toString()}");
    }
  }
}

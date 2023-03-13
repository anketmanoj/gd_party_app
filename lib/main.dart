import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/navigation/mainPAge.dart';
import 'package:gd_party_app/navigation/main_binding.dart';
import 'package:gd_party_app/router.dart';
import 'package:gd_party_app/screens/UsersDetails/editUserPage.dart';
import 'package:gd_party_app/screens/UsersDetails/sendUserNotificationScreen.dart';
import 'package:gd_party_app/screens/UsersDetails/usersDetailPage.dart';
import 'package:gd_party_app/screens/loginScreen/loginScreenView.dart';
import 'package:gd_party_app/services/shared_preference_service.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page.dart';
import 'package:gd_party_app/screens/onboardingScreen/views/onboarding_page.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesHelper.initSharedPrefs();
  await FirebaseMessaging.instance.requestPermission();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    importance: Importance.max,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    log('onMessageOpenedApp notification: ${message.notification}');
    log('onMessageOpenedApp data: ${message.data}');

    // if (message.data['videoId'] != null) {
    //   log("Go To!");
    //   Get.to(FCMNotificationNavigator(
    //     videoId: message.data['videoId'],
    //   ));
    // }

    ///Todo(param): yet undetermined
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool onboardingFinished =
        SharedPreferencesHelper.getBool("onboardFinished");
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'GD Party',
        onGenerateRoute: (settings) => onGenerateRoute(settings),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
          accentColor: kSecondaryColor,
          primaryColor: kTertiaryColor,
          fontFamily: "Poppins",
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
        ),
        initialRoute: onboardingFinished
            ? LoginScreen.routeName
            : OnboardingPage.routeName,
        getPages: [
          GetPage(
            name: MainPage.routeName,
            page: () => MainPage(),
            binding: MainBinding(),
          ),
          GetPage(
            name: OnboardingPage.routeName,
            page: () => OnboardingPage(),
          ),
          GetPage(
            name: LoginScreen.routeName,
            page: () => LoginScreen(),
          ),
          GetPage(
            name: UsersDetailsPage.routeName,
            page: () => UsersDetailsPage(),
          ),
          GetPage(
            name: EditUserPage.routeName,
            page: () => EditUserPage(
              userModel: Get.arguments,
            ),
          ),
          GetPage(
            name: SendUserNotification.routeName,
            page: () => SendUserNotification(
              userModel: Get.arguments,
            ),
          ),
        ],
      );
    });
  }
}

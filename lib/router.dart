import 'package:flutter/material.dart';
import 'package:gd_party_app/navigation/mainPAge.dart';
import 'package:gd_party_app/screens/ProfileScreen/profile_page.dart';
import 'package:gd_party_app/screens/UsersDetails/editUserPage.dart';
import 'package:gd_party_app/screens/UsersDetails/sendUserNotificationScreen.dart';
import 'package:gd_party_app/screens/UsersDetails/usersDetailPage.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingPage.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page.dart';
import 'package:gd_party_app/screens/locationScreen/views/location_page.dart';
import 'package:gd_party_app/screens/loginScreen/loginScreenView.dart';
import 'package:gd_party_app/screens/onboardingScreen/views/onboarding_page.dart';
import 'package:gd_party_app/screens/ScheduleScreen/views/schedule_page.dart';
import 'package:gd_party_app/screens/TranslationScreen/views/translation_page.dart';
import 'package:gd_party_app/services/Users/userModel.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case EventEditingPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => EventEditingPage(),
      );
    case EditUserPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => EditUserPage(
          userModel: routeSettings.arguments as UserModel,
        ),
      );
    case SendUserNotification.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SendUserNotification(
          userModel: routeSettings.arguments as UserModel,
        ),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomePage(),
      );
    case UsersDetailsPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UsersDetailsPage(),
      );
    case MainPage.routeName:
      return MaterialPageRoute(
        // settings: routeSettings,
        builder: (_) => MainPage(),
      );
    case OnboardingPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OnboardingPage(),
      );
    case ProfilePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProfilePage(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case LocationPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LocationPage(),
      );
    case SchedulePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SchedulePage(),
      );
    case TranslationPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => TranslationPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text("Error 404: Page does not exist"),
          ),
        ),
      );
  }
}

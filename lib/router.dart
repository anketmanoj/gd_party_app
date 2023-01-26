import 'package:flutter/material.dart';
import 'package:gd_party_app/navigation/mainPAge.dart';
import 'package:gd_party_app/screens/eventEditingScreen/eventEditingPage.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page.dart';
import 'package:gd_party_app/screens/locationScreen/views/location_page.dart';
import 'package:gd_party_app/screens/onboardingScreen/views/onboarding_page.dart';
import 'package:gd_party_app/screens/ProfileScreen/views/profile_page.dart';
import 'package:gd_party_app/screens/ScheduleScreen/views/schedule_page.dart';
import 'package:gd_party_app/screens/TranslationScreen/views/translation_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case EventEditingPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => EventEditingPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomePage(),
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

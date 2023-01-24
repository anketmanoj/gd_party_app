import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/onboardingScreen/models/onboarding_model.dart';
import 'package:gd_party_app/services/shared_preference_service.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page.dart';

import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  final pageController = PageController();
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;

  goToMainScreenPage() {
    SharedPreferencesHelper.initSharedPrefs();
    SharedPreferencesHelper.setBool("onboardFinished", true);
    Get.offNamed(HomePage.routeName);
  }

  skipToLast() {
    pageController.animateToPage(onboardingPages.length - 1,
        duration: 300.milliseconds, curve: Curves.ease);
  }

  nextPage() {
    if (!isLastPage) {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    } else {
      goToMainScreenPage();
    }
  }

  List<OnboardingModel> onboardingPages = [
    OnboardingModel(
        imageUrl: "assets/onboardingIcons/translate.json",
        title: "In-app Translation",
        description:
            "You'll be able to translate text and speech in real time"),
    OnboardingModel(
        imageUrl: "assets/onboardingIcons/schedule.json",
        title: "Event Schedule",
        description: "Track your activities for the days ahead of your trip"),
    OnboardingModel(
        imageUrl: "assets/onboardingIcons/map.json",
        title: "Map Location",
        description:
            "Being in a new country can be daunting, allow us to make sure you're okay by sharing your live location with us"),
    OnboardingModel(
        imageUrl: "assets/onboardingIcons/arrival.json",
        title: "Arrival Progress Tracker",
        description:
            "Share your airport progress with us so we can accomadate a smoother process to pick you up from the airport"),
  ];
}

import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/navigation/mainPAge.dart';
import 'package:gd_party_app/router.dart';
import 'package:gd_party_app/services/shared_preference_service.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page.dart';
import 'package:gd_party_app/screens/onboardingScreen/views/onboarding_page.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.initSharedPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        initialRoute:
            onboardingFinished ? MainPage.routeName : OnboardingPage.routeName,
      );
    });
  }
}

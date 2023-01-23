import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/services/shared_preference_service.dart';
import 'package:gd_party_app/views/onboarding_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  SharedPreferencesHelper.initSharedPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'GD Party',
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
        home: OnboardingPage(),
      );
    });
  }
}

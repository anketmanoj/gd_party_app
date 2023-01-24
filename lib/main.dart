import 'package:flutter/material.dart';
import 'package:gd_party_app/constants/colors.dart';
import 'package:gd_party_app/navigation/mainPAge.dart';
import 'package:gd_party_app/navigation/main_binding.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool onboardingFinished = false;
    // SharedPreferencesHelper.getBool("onboardFinished");
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
        initialRoute: OnboardingPage.routeName,
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
        ],
      );
    });
  }
}

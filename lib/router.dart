import 'package:flutter/material.dart';
import 'package:gd_party_app/views/home_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomePage(),
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

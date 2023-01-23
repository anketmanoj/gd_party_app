import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home-page";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Home",
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gd_party_app/screens/onboardingScreen/controllers/onboarding_controller.dart';
import 'package:gd_party_app/screens/homeScreen/views/home_page.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OnboardingPage extends StatelessWidget {
  static const String routeName = "/onboarding-page";
  OnboardingPage({super.key});
  final _controller = OnboardingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller.pageController,
              onPageChanged: _controller.selectedPageIndex,
              itemCount: _controller.onboardingPages.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.h,
                      child: Lottie.asset(
                        _controller.onboardingPages[index].imageUrl,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      _controller.onboardingPages[index].title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _controller.onboardingPages[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                children: List.generate(
                  _controller.onboardingPages.length,
                  (index) => Obx(() {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _controller.selectedPageIndex == index
                            ? Theme.of(context).primaryColorLight
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                elevation: 0,
                onPressed: _controller.nextPage,
                child: Obx(() {
                  return Text(_controller.isLastPage ? "Done" : "Next");
                }),
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomePage.routeName);
                },
                child: Text(
                  "Skip",
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

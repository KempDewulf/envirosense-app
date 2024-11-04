import 'package:envirosense/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Convenience",
      body: "Control your home device using a single app from anywhere in the world",
      image: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset('assets/images/convenience.png', height: 350),
      ),
      decoration: const PageDecoration(
        pageColor: AppColors.whiteColor,
        bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.accentColor),
      ),
    ),
    PageViewModel(
      title: "Automate",
      body:
          "Switch through different scenes and quick actions for fast management of your home",
      image: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset('assets/images/automate.png', height: 350),
      ),
      decoration: const PageDecoration(
        pageColor: AppColors.whiteColor,
        bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.accentColor),
      ),
    ),
    PageViewModel(
      title: "Stay Informed",
      body: "Instant notifications about any activity or alerts",
      image: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset('assets/images/stay_informed.png', height: 350),
      ),
      decoration: const PageDecoration(
        pageColor: AppColors.whiteColor,
        bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.accentColor),
      ),
    ),
  ];

  OnboardingScreen({super.key});

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.bold)),
      next:
          const Text('Next', style: TextStyle(color: AppColors.secondaryColor, fontWeight: FontWeight.bold)),
      done: const Text("Let's start",
          style: TextStyle(color: AppColors.secondaryColor, fontWeight: FontWeight.bold)),
      dotsDecorator: DotsDecorator(
        size: const Size(20.0, 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        activeSize: const Size(30.0, 4.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        activeColor: AppColors.secondaryColor,
        color: AppColors.accentColor,
      ),
    );
  }
}

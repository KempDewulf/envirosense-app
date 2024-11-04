import 'package:envirosense/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Convenience",
      body:
          "Control your home device using a single app from anywhere in the world",
      image: Center(
        child: Image.asset('assets/images/convenience.png', height: 175),
      ),
      decoration: const PageDecoration(
        pageColor: AppColors.whiteColor,
      ),
    ),
    PageViewModel(
      title: "Automate",
      body:
          "Switch through different scenes and quick actions for fast management of your home",
      image: Center(
        child: Image.asset('assets/images/automate.png', height: 175),
      ),
      decoration: const PageDecoration(
        pageColor: AppColors.whiteColor,
      ),
    ),
    PageViewModel(
      title: "Stay Informed",
      body: "Instant notifications about any activity or alerts",
      image: Center(
        child: Image.asset('assets/images/stay_informed.png', height: 175),
      ),
      decoration: const PageDecoration(
        pageColor: AppColors.whiteColor,
      ),
    ),
  ];

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
      skip: const Text('Skip', style: TextStyle(color: AppColors.accentColor)),
      next:
          const Text('Next', style: TextStyle(color: AppColors.secondaryColor)),
      done:
          const Text("Done", style: TextStyle(color: AppColors.secondaryColor)),
      dotsDecorator: const DotsDecorator(
        activeColor: AppColors.secondaryColor,
        color: AppColors.accentColor,
      ),
    );
  }
}

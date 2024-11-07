// lib/views/onboarding_screen.dart
import 'package:envirosense/colors/colors.dart';
import 'package:envirosense/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Common PageDecoration
  final PageDecoration _pageDecoration = const PageDecoration(
    pageColor: AppColors.whiteColor,
    bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.accentColor),
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor,
    ),
    imagePadding: EdgeInsets.only(top: 50),
    titlePadding: EdgeInsets.only(top: 100, bottom: 15),
    bodyPadding: EdgeInsets.symmetric(horizontal: 40),
    contentMargin: EdgeInsets.all(0),
  );

  // Reusable method to create PageViewModel
  PageViewModel _buildPageModel({
    required String title,
    required String body,
    required String imagePath,
  }) {
    return PageViewModel(
      title: title,
      body: body,
      image: Image.asset(
        imagePath,
        height: 350,
        fit: BoxFit.contain,
      ),
      decoration: _pageDecoration,
    );
  }

  // List of onboarding pages data
  List<PageViewModel> get _pages => [
        _buildPageModel(
          title: "Convenience",
          body:
              "Control your home device using a single app from anywhere in the world",
          imagePath: 'assets/images/convenience.png',
        ),
        _buildPageModel(
          title: "Automate",
          body:
              "Switch through different scenes and quick actions for fast management of your home",
          imagePath: 'assets/images/automate.png',
        ),
        _buildPageModel(
          title: "Stay Informed",
          body: "Instant notifications about any activity or alerts",
          imagePath: 'assets/images/stay_informed.png',
        ),
      ];

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _pages,
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(
          color: AppColors.accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      next: const Text(
        'Next',
        style: TextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      done: const Text(
        "Let's start",
        style: TextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(20.0, 4.0),
        activeSize: const Size(30.0, 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        activeColor: AppColors.secondaryColor,
        color: AppColors.accentColor,
        spacing: const EdgeInsets.symmetric(horizontal: 4.0),
      ),
    );
  }
}

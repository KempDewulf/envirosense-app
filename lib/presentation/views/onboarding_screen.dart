// lib/views/onboarding_screen.dart
import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
  List<PageViewModel> _buildPages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      _buildPageModel(
        title: l10n.onboardingConvenienceTitle,
        body: l10n.onboardingConvenienceDesc,
        imagePath: 'assets/images/convenience.png',
      ),
      _buildPageModel(
        title: l10n.onboardingAutomateTitle,
        body: l10n.onboardingAutomateDesc,
        imagePath: 'assets/images/automate.png',
      ),
      _buildPageModel(
        title: l10n.onboardingInformedTitle,
        body: l10n.onboardingInformedDesc,
        imagePath: 'assets/images/stay_informed.png',
      ),
    ];
  }

  void _onIntroEnd(context) async {
    final dbService = DatabaseService();
    await dbService.setSetting('isFirstTime', false);
    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IntroductionScreen(
      pages: _buildPages(context),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Text(
        l10n.skip,
        style: TextStyle(
          color: AppColors.accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      next: Text(
        l10n.next,
        style: TextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      done: Text(
        l10n.letsStart,
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

import 'package:envirosense/colors/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const FlutterLogo(
                size: 100.0,
              ),
              const SizedBox(height: 40.0),
              // Username field
              const TextField(
                style: TextStyle(color: AppColors.whiteColor),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: AppColors.accentColor),
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
                  floatingLabelStyle: TextStyle(color: AppColors.secondaryColor),
                ),
              ),
              const SizedBox(height: 10.0),
              // Password field
              const TextField(
                style: TextStyle(color: AppColors.whiteColor),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AppColors.accentColor),
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
                  floatingLabelStyle: TextStyle(color: AppColors.secondaryColor),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10.0),
              // Forgot password text
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Forgot your password? ',
                      style: TextStyle(color: AppColors.whiteColor),
                      children: [
                        TextSpan(
                          text: 'Click here',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // First button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Handle enter your house
                  },
                  child: const Text('Enter your house'),
                ),
              ),
              const SizedBox(height: 10.0),
              // Second button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteColor,
                    foregroundColor: AppColors.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Handle new resident
                  },
                  child: const Text('New resident'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

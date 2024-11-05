import 'package:envirosense/colors/colors.dart';
import 'package:envirosense/widgets/CustomButton.dart';
import 'package:envirosense/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
              // Custom Image
              Image.asset(
                'assets/your_image.png', // Replace with your image path
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(height: 40.0),
              // Username field
              const CustomTextField(
                labelText: 'Username',
              ),
              const SizedBox(height: 10.0),
              // Password field
              CustomTextField(
                labelText: 'Password',
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
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
              CustomButton(
                text: 'Enter your house',
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.whiteColor,
                onPressed: () {
                  // Handle enter your house
                },
              ),
              const SizedBox(height: 10.0),
              // Second button
              CustomButton(
                text: 'New resident',
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                onPressed: () {
                  // Handle new resident
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

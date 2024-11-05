import 'package:envirosense/colors/colors.dart';
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  floatingLabelStyle: TextStyle(color: AppColors.secondaryColor),
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
                ),
              ),
              const SizedBox(height: 10.0),
              // Password field
              TextField(
                style: const TextStyle(color: AppColors.whiteColor),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppColors.accentColor),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  floatingLabelStyle: const TextStyle(color: AppColors.secondaryColor),
                  border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscureText,
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
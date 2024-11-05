import 'package:envirosense/colors/colors.dart';
import 'package:envirosense/widgets/CustomButton.dart';
import 'package:envirosense/widgets/CustomTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Handle successful registration
    } on FirebaseAuthException catch (e) {
      // Handle registration error
      print(e.message);
    }
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
                'assets/logos/envirosense_logo.png', // Replace with your image path
                width: 200.0,
                height: 200.0,
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
                onPressed: _signIn,
              ),
              const SizedBox(height: 10.0),
              // Second button
              CustomButton(
                text: 'New resident',
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

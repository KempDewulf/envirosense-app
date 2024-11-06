import 'package:envirosense/colors/colors.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:envirosense/views/home_screen.dart';
import 'package:envirosense/widgets/CustomButton.dart';
import 'package:envirosense/widgets/CustomTextFormField.dart';
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
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Trigger a rebuild to clear the error state when the user starts typing
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _authService.signIn(
          _emailController.text,
          _passwordController.text,
        );
        // Navigate to home page on successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message ?? 'An error occurred during sign-in.');
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _authService.register(
          _emailController.text,
          _passwordController.text,
        );
        // Navigate to home page on successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message ?? 'An error occurred during registration.');
      }
    }
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                // Email field
                CustomTextFormField(
                  labelText: 'Email',
                  controller: _emailController,
                  validator: _validateEmail,
                  focusNode: _emailFocusNode,
                ),
                const SizedBox(height: 10.0),
                // Password field
                CustomTextFormField(
                  labelText: 'Password',
                  controller: _passwordController,
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  validator: _validatePassword,
                  focusNode: _passwordFocusNode,
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
                // Sign In button
                CustomButton(
                  text: 'Enter your house',
                  backgroundColor: AppColors.secondaryColor,
                  textColor: AppColors.whiteColor,
                  onPressed: _signIn,
                ),
                const SizedBox(height: 10.0),
                // Register button
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
      ),
    );
  }
}

import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/core/custom_button.dart';
import 'package:envirosense/presentation/widgets/core/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:envirosense/services/validation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscureText = true;
  bool _formSubmitted = false;

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

  Future<void> _signIn() async {
    setState(() {
      _formSubmitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _authService.signIn(
          _emailController.text,
          _passwordController.text,
        );

        final user = userCredential.user;

        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          if (!mounted) return;

          Navigator.pushReplacementNamed(context, '/emailVerification',
              arguments: {
                'email': _emailController.text.trim(),
              });
          return;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
          'loginTimestamp',
          DateTime.now().toUtc().millisecondsSinceEpoch,
        );

        if (!mounted) return;

        // Navigate to home page on successful sign-in
        Navigator.pushReplacementNamed(context, '/main');
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        _showErrorDialog(e.message ?? 'An error occurred during sign-in.');
      } catch (e) {
        if (!mounted) return;
        _showErrorDialog('An unexpected error occurred.');
      }
    }
  }

  Future<void> _register() async {
    setState(() {
      _formSubmitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _authService.register(
          _emailController.text,
          _passwordController.text,
        );

        await userCredential.user?.sendEmailVerification();

        if (!mounted) return;

        // Navigate to home page on successful registration
        Navigator.pushReplacementNamed(context, '/emailVerification',
            arguments: {
              'email': _emailController.text.trim(),
            });
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        _showErrorDialog(e.message ?? 'An error occurred during registration.');
      }
    }
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.secondaryColor),
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
            autovalidateMode: _formSubmitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
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
                  labelColor: AppColors.whiteColor,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: ValidationService.validateEmail,
                  focusNode: _emailFocusNode,
                  borderColor: AppColors.secondaryColor,
                  focusColor: AppColors.secondaryColor,
                ),
                const SizedBox(height: 14.0),
                // Password field
                CustomTextFormField(
                  labelText: 'Password',
                  labelColor: AppColors.whiteColor,
                  borderColor: AppColors.secondaryColor,
                  focusColor: AppColors.secondaryColor,
                  controller: _passwordController,
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  validator: ValidationService.validatePassword,
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

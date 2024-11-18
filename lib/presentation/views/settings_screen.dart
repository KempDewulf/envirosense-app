// In settings_screen.dart or the relevant file

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    // Clear the login timestamp
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loginTimestamp');

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _signOut(context),
        child: const Text('Sign Out'),
      ),
    );
  }
}

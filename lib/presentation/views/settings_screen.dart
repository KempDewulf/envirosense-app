import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear the login timestamp
    await prefs.remove('loginTimestamp');

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();
    navigator.pushReplacementNamed('/login');
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

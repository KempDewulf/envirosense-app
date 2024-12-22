import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    final dbService = DatabaseService();

    // Clear the login timestamp
    await dbService.setSetting('loginTimestamp', null);

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

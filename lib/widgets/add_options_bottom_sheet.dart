import 'package:flutter/material.dart';
import '../../../colors/colors.dart';

class AddOptionsBottomSheet extends StatelessWidget {
  const AddOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Add New',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 8),
            // Separator Line
            Divider(
              color: AppColors.accentColor,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            // Options
            ListTile(
              leading: Icon(
                Icons.meeting_room,
                color: AppColors.secondaryColor,
                size: 32,
              ),
              title: const Text(
                'Add New Room',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.whiteColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/addRoom');
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.devices,
                color: AppColors.secondaryColor,
                size: 32,
              ),
              title: const Text(
                'Add New Device',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.whiteColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/addDevice');
              },
            ),
          ],
        ),
      ),
    );
  }
}
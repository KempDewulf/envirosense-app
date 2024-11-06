// room_card.dart

import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              room['icon'],
              color: AppColors.secondaryColor,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              room['name'],
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'x${room['devices']} device${room['devices'] > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// room_card.dart

import 'package:envirosense/domain/entities/room.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({
    super.key,
    required this.room,
  });

  IconData getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'bedroom':
        return Icons.bed;
      case 'tv room':
        return Icons.tv;
      case 'bathroom':
        return Icons.bathtub;
      case 'cafetaria':
        return Icons.local_cafe;
      case 'classroom':
        return Icons.class_;
      case 'garage':
        return Icons.garage;
      case 'kid room':
        return Icons.child_care;
      case 'office':
        return Icons.business;
      case 'toiletroom':
        return Icons.wc;
      default:
        return Icons.help_outline;
    }
  }

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
              getIconData(room.roomType.icon),
              color: AppColors.secondaryColor,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${room.devices?.length ?? 0} device${(room.devices?.length ?? 0) > 1 ? 's' : ''}',
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

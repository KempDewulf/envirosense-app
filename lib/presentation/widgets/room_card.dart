// room_card.dart

import 'package:envirosense/core/helpers/icon_helper.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/roomOverview',
            arguments: {
              'roomName': room.name,
              'roomId': room.id,
            },
          );
        },
        child: Card(
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
        ));
  }
}

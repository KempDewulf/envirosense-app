import 'package:envirosense/core/helpers/icon_helper.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onChanged;

  const RoomCard({
    super.key,
    required this.room,
    required this.onChanged,
  });

  String _getDeviceText(BuildContext context, int count) {
    final l10n = AppLocalizations.of(context)!;
    return '$count ${count == 1 ? l10n.device.toLowerCase() : l10n.devices.toLowerCase()}';
  }

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
          ).then((value) {
            if (value == true) {
              onChanged?.call();
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  getIconData(room.roomType.icon),
                  color: AppColors.secondaryColor,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  room.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getDeviceText(context, room.devices?.length ?? 0),
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

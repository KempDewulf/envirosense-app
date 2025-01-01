import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

class RoomActionsTab extends StatelessWidget {
  final Function() onRenameRoom;
  final Function() onRemoveRoom;

  const RoomActionsTab({
    super.key,
    required this.onRenameRoom,
    required this.onRemoveRoom,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildActionButton(
                icon: Icons.edit,
                label: 'Rename Room',
                onPressed: onRenameRoom,
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Room',
                onPressed: onRemoveRoom,
                color: AppColors.redColor,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isDestructive = false,
    bool isWarning = false,
    bool isNeutral = false,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isDestructive
            ? AppColors.redColor.withOpacity(0.4)
            : isWarning
                ? AppColors.secondaryColor.withOpacity(0.4)
                : isNeutral
                    ? AppColors.accentColor.withOpacity(0.4)
                    : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? AppColors.redColor
                        : isWarning
                            ? AppColors.secondaryColor
                            : AppColors.blackColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDestructive
                      ? AppColors.redColor
                      : isWarning
                          ? AppColors.secondaryColor
                          : AppColors.blackColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

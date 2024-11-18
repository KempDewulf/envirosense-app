import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AddOptionsBottomSheet extends StatelessWidget {
  const AddOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.35,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with padding
            const Padding(
              padding: EdgeInsets.only(top: 28.0, bottom: 16.0, left: 32),
              child: Text(
                'Add new',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            // Divider without padding
            const Divider(
              color: AppColors.lightGrayColor,
              thickness: 1,
              height: 1,
            ),
            // Options
            Expanded(
              child: Column(
                children: [
                  // First Option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/addRoom');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.meeting_room,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Add New Room',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider with padding
                  const Divider(
                    color: AppColors.lightGrayColor,
                    thickness: 1,
                    indent: 32.0,
                    endIndent: 32.0,
                    height: 1,
                  ),
                  // Second Option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/addDevice');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.lightGrayColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.devices,
                              color: AppColors.accentColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Add New Device',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

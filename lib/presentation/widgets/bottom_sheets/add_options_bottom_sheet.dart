import 'dart:math';

import 'package:envirosense/core/enums/add_option_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/constants/colors.dart';

class AddOptionsBottomSheet extends StatelessWidget {
  final AddOptionType? preferredOption;
  final VoidCallback? onItemAdded;

  const AddOptionsBottomSheet({
    super.key,
    this.preferredOption,
    this.onItemAdded,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    List<_AddOption> options = [
      _AddOption(
        title: l10n.addRoom,
        icon: Icons.meeting_room,
        backgroundColor: preferredOption == AddOptionType.room ? AppColors.secondaryColor : AppColors.lightGrayColor,
        onTapRoute: '/addRoom',
        textColor: preferredOption == AddOptionType.room ? AppColors.secondaryColor : AppColors.accentColor,
        iconColor: preferredOption == AddOptionType.room ? AppColors.whiteColor : AppColors.accentColor,
        type: AddOptionType.room,
      ),
      _AddOption(
        title: l10n.addDevice,
        icon: Icons.devices,
        backgroundColor: preferredOption == AddOptionType.device ? AppColors.secondaryColor : AppColors.lightGrayColor,
        onTapRoute: '/addDevice',
        textColor: preferredOption == AddOptionType.device ? AppColors.secondaryColor : AppColors.accentColor,
        iconColor: preferredOption == AddOptionType.device ? AppColors.whiteColor : AppColors.accentColor,
        type: AddOptionType.device,
      ),
    ];

    if (preferredOption != null) {
      options.sort((a, b) {
        if (a.type == preferredOption && b.type != preferredOption) {
          return -1;
        } else if (a.type != preferredOption && b.type == preferredOption) {
          return 1;
        }
        return 0;
      });
    }

    return FractionallySizedBox(
      heightFactor: 0.35,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with padding
            Padding(
              padding: EdgeInsets.only(top: 28.0, bottom: 16.0, left: 32),
              child: Text(
                l10n.addNew,
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
                children: List.generate(options.length, (index) {
                  final option = options[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, option.onTapRoute).then((value) => {
                            if (value == true) {onItemAdded?.call()}
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: option.backgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  option.icon,
                                  color: option.iconColor,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: option.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Add Divider only if it's not the last option
                      if (index != options.length - 1)
                        const Divider(
                          color: AppColors.lightGrayColor,
                          thickness: 1,
                          indent: 32.0,
                          endIndent: 32.0,
                          height: 1,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddOption {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final String onTapRoute;
  final Color textColor;
  final Color iconColor;
  final AddOptionType type;

  _AddOption({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.onTapRoute,
    required this.textColor,
    required this.iconColor,
    required this.type,
  });
}

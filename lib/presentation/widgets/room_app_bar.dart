import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class RoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String roomName;
  final TabController tabController;
  final List<Tab> tabs;
  final VoidCallback onBackPressed;

  const RoomAppBar({
    super.key,
    required this.roomName,
    required this.tabController,
    required this.tabs,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left_rounded),
        iconSize: 35,
        onPressed: onBackPressed,
      ),
      title: Text(
        roomName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
      ),
      bottom: TabBar(
        controller: tabController,
        tabs: tabs,
        labelColor: AppColors.secondaryColor,
        indicatorColor: AppColors.secondaryColor,
        unselectedLabelColor: AppColors.whiteColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}

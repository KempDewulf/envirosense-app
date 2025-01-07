import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabController? tabController;
  final List<Tab>? tabs;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.tabController,
    this.tabs,
    this.onBackPressed,
  }) : assert((tabController == null && tabs == null) || (tabController != null && tabs != null),
            'Both tabController and tabs must be either provided or null');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left_rounded),
        iconSize: 35,
        onPressed: onBackPressed!,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
      ),
      bottom: TabBar(
        controller: tabController,
        tabs: tabs!,
        labelColor: AppColors.secondaryColor,
        indicatorColor: AppColors.secondaryColor,
        unselectedLabelColor: AppColors.whiteColor,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + ((tabController != null && tabs != null) ? 48 : 0));
}

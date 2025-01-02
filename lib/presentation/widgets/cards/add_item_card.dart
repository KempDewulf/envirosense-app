import 'package:flutter/material.dart';

class AddItemCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const AddItemCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: iconColor,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                ),
              ),
            ],
          )),
    );
  }
}

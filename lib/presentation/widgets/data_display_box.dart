import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

class DataDisplayBox extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>>
      data; // Updated type to include status

  const DataDisplayBox({
    super.key,
    required this.title,
    required this.data,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return AppColors.greenColor;
      case 'bad':
        return AppColors.redColor;
      case 'medium':
        return AppColors.secondaryColor;
      default:
        return AppColors.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...data.entries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  entry.value['value'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: AppColors.accentColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(entry.value['status']),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

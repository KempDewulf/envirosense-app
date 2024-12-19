import 'package:flutter/material.dart';

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

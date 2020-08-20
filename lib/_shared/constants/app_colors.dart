import 'package:flutter/material.dart';

class AppColors {
  static final Color defaultColor = _getColorFromHex(AppColors._defaultColor);

  static final String _defaultColor = "008cbf";

  static Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}

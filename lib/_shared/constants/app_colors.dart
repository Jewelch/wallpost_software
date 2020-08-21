import 'package:flutter/material.dart';

class AppColors {
  static final Color defaultColor = _getColorFromHex(AppColors._defaultColor);
  static final Color white = _getColorFromHex(AppColors._whiteColor);
  static final Color buttonColor = _getColorFromHex(AppColors._buttonColor);
  static final Color labelColor = _getColorFromHex(AppColors._labelColor);
  static final Color blackColor = _getColorFromHex(AppColors._blackColor);
  static final Color greyColor = _getColorFromHex(AppColors._greyColor);
  static final Color placeholderColor = _getColorFromHex(AppColors._placeholderColor);


  static final String _defaultColor = "AF1922";
  static final String _whiteColor = "FFFFFF";
  static final String _buttonColor = "fbc273";
  static final String _labelColor = "777777";
  static final String _blackColor = "222222";
  static final String _placeholderColor = "AAAAAA";
  static final String _greyColor = "EBEBEB";

  static Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}

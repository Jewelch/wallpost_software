import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TextStyles {
  static get screenTitleTextStyle => TextStyle(
        fontSize: 18,
        color: AppColors.defaultColorDark,
        fontWeight: FontWeight.bold,
      );

  static get largeTitleTextStyleBold => TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  static get titleTextStyle => TextStyle(
        fontSize: 16,
        color: Colors.black,
      );

  static get subTitleTextStyle => TextStyle(
        fontSize: 14,
        color: Colors.black,
      );

  static get labelTextStyle => TextStyle(
        fontSize: 12,
        color: Colors.grey,
      );
}

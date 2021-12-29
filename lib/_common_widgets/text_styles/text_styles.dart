import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TextStyles {
  static get titleTextStyle => TextStyle(
        fontSize: 16,
        color: Colors.black,
      );

  static get largeTitleTextStyle => TextStyle(
        fontSize: 18,
        color: Colors.black,
      );

  static get subTitleTextStyle => TextStyle(
        fontSize: 14,
        color: AppColors.getColorFromHex('#777777'),
      );

  static get labelTextStyle => TextStyle(
        fontSize: 12,
        color: AppColors.getColorFromHex('#777777'),
      );

  static get failureMessageTextStyle => TextStyle(
        fontSize: 16,
        color: AppColors.getColorFromHex('#777777'),
      );
}

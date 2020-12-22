import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TextStyles {
  static get screenTitleTextStyle => TextStyle(
        fontSize: 16,
        color: Colors.black,
      );

  static get titleTextStyle => TextStyle(
        fontSize: 18,
        color: Colors.black,
      );

  static get listButtonTextStyle => TextStyle(
        fontSize: 18,
        color: Colors.black,
      );

  static get failureMessageTextStyle => TextStyle(
        fontSize: 16,
        color: AppColors.labelColor,
      );

  static get subTitleTextStyle => TextStyle(
        fontSize: 14,
        color: AppColors.getColorFromHex('#9aa6b2'),
      );

  static get buttonTextStyle => TextStyle(
        fontSize: 16,
        color: Colors.white,
      );
}

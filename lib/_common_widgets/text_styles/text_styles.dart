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

  static get headerCardLargeTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.defaultColorDarkContrastColor,
      fontSize: 28.0,
      overflow: TextOverflow.ellipsis);

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

  static get thickTextStyle => TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}

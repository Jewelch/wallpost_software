import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TextStyles {
  static get screenTitleTextStyle => TextStyle(
        fontSize: 18,
        color: AppColors.defaultColorDark,
        fontWeight: FontWeight.bold,
      );

  static get extraLargeTitleTextStyleBold => TextStyle(
        fontSize: 22,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.bold,
      );

  static get largeTitleTextStyleBold => TextStyle(
    fontSize: 17,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.bold,
      );

  static get titleTextStyle => TextStyle(
    fontSize: 16,
        color: AppColors.textColorBlack,
      );

  static get titleTextStyleBold => TextStyle(
    fontSize: 16,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.w600,
      );

  static get subTitleTextStyle => TextStyle(
    fontSize: 14,
        color: AppColors.textColorBlack,
      );

  static get subTitleTextStyleBold => TextStyle(
        fontSize: 14,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.w600,
      );

  static get labelTextStyle => TextStyle(
        fontSize: 12,
        color: AppColors.textColorGray,
      );

  static get smallLabelTextStyle => TextStyle(
        fontSize: 11,
        color: AppColors.textColorGray,
      );

  static get labelTextStyleBold => TextStyle(
        fontSize: 12,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.w600,
      );

  //MARK: Header card text styles

  static get headerCardHeadingTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 24.0,
      );

  static get headerCardSubHeadingTextStyle => TextStyle(
    fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 17.0,
      );

  static get headerCardMainValueTextStyle => TextStyle(
    fontWeight: FontWeight.w700,
        color: AppColors.textColorBlack,
        fontSize: 24.0,
        overflow: TextOverflow.ellipsis,
      );

  static get headerCardMainLabelTextStyle => TextStyle(
        fontSize: 16,
        color: AppColors.defaultColorDarkContrastColor,
        fontWeight: FontWeight.w600,
      );

  static get headerCardSubValueTextStyle => TextStyle(
    fontWeight: FontWeight.w700,
        color: AppColors.textColorBlack,
        fontSize: 16.0,
        overflow: TextOverflow.ellipsis,
      );

  static get headerCardSubLabelTextStyle => TextStyle(
        fontWeight: FontWeight.w300,
        color: AppColors.defaultColorDarkContrastColor,
        fontSize: 11.0,
      );

  static get headerCardMoneyLabelTextStyle => TextStyle(
    fontWeight: FontWeight.w300,
    color: AppColors.defaultColorDarkContrastColor,
    fontSize: 18.0,
  );

  static get headerCardHeadingTextStyleWithGreenColor => TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.green,
    fontSize: 24.0,
  );
}

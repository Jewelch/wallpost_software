import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';

class TextStyles {
  static String _defaultFont = 'SF-Pro-Display';

  static get screenTitleTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 18,
        color: AppColors.defaultColorDark,
        fontWeight: FontWeight.bold,
      );

  static get extraLargeTitleTextStyleBold => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 22,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.bold,
      );

  static get largeTitleTextStyleBold => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 17,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.bold,
      );

  static get largeTitleTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 17,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.normal,
      );

  static get titleTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 15,
        color: AppColors.textColorBlack,
      );

  static get titleTextStyleBold => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 15,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.w600,
      );

  static get subTitleTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontSize: 14,
        color: AppColors.textColorBlack,
      );

  static get subTitleTextStyleBold => TextStyle(
    fontFamily: _defaultFont,
        fontSize: 14,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.w600,
      );

  static get labelTextStyle => TextStyle(
    fontFamily: _defaultFont,
        fontSize: 12,
        color: AppColors.textColorGray,
      );

  static get smallLabelTextStyle => TextStyle(
    fontFamily: _defaultFont,
        fontSize: 11,
        color: AppColors.textColorGray,
      );

  static get labelTextStyleBold => TextStyle(
    fontFamily: _defaultFont,
        fontSize: 12,
        color: AppColors.textColorBlack,
        fontWeight: FontWeight.w600,
      );

  //MARK: Header card text styles

  static get headerCardNumberTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 28.0,
      );

  static get headerCardHeadingTextStyle => TextStyle(
    fontFamily: _defaultFont,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 24.0,
      );

  static get headerCardSubHeadingTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 17.0,
      );

  static get headerCardMainValueTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontWeight: FontWeight.w800,
        color: AppColors.textColorBlack,
        fontSize: 28.0,
        overflow: TextOverflow.ellipsis,
      );

  static get headerCardMainLabelTextStyle => TextStyle(
    fontFamily: _defaultFont,
        fontSize: 16,
        color: AppColors.defaultColorDarkContrastColor,
        fontWeight: FontWeight.w600,
      );

  static get headerCardSubValueTextStyle => TextStyle(
        fontFamily: _defaultFont,
        fontWeight: FontWeight.w800,
        color: AppColors.textColorBlack,
        fontSize: 20.0,
        overflow: TextOverflow.ellipsis,
      );

  static get headerCardSubLabelTextStyle => TextStyle(
    fontFamily: _defaultFont,
        fontWeight: FontWeight.w400,
        color: AppColors.defaultColorDarkContrastColor,
        fontSize: 11.0,
      );

  static get headerCardMoneyLabelTextStyle => TextStyle(
    fontFamily: _defaultFont,
        fontWeight: FontWeight.w300,
        color: AppColors.screenBackgroundColor.withOpacity(.6),
        fontSize: 17.0,
      );
}

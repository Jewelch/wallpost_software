import 'package:flutter/material.dart';

class AppColors {
  static const Color defaultColor = Color.fromRGBO(0, 150, 227, 1.0);
  static const Color defaultColorWithTransparency =
      Color.fromRGBO(0, 150, 227, 0.6);
  static const Color defaultColorDark = Color.fromRGBO(0, 60, 129, 1.0);
  static const Color defaultColorDarkContrastColor =
      Color.fromRGBO(135, 169, 199, 1.0);

  //MARK: Text colors
  static const Color textColorBlack = Color.fromRGBO(39, 39, 39, 1.0);
  static const Color textColorGray = Color.fromRGBO(160, 160, 160, 1.0);

  //MARK: Button colors
  static const Color disabledButtonColor = Color.fromRGBO(210, 210, 210, 1.0);

  //MARK: Screen colors
  static const Color screenBackgroundColor = Colors.white;

  //MARK: Module colors
  static const Color myPortalColor = Color.fromRGBO(191, 10, 10, 1.0);

  //MARK: Text field colors
  static const Color textFieldBackgroundColor =
      Color.fromRGBO(237, 237, 237, 1.0);
  static const Color textFieldBorderColor = Color.fromRGBO(220, 220, 220, 0);
  static const Color textFieldFocusedBorderColor = AppColors.defaultColor;

  //MARK: Outcome colors
  static const Color green = Color.fromRGBO(51, 190, 114, 1.0);
  static final Color yellow = Color.fromRGBO(248, 166, 50, 1.0);
  static const Color red = Color.fromRGBO(243, 45, 44, 1.0);
  static const Color greenOnDarkDefaultColorBg =
      Color.fromRGBO(74, 240, 145, 1.0);
  static const Color redOnDarkDefaultColorBg =
      Color.fromRGBO(250, 104, 100, 1.0);

  //MARK: Shimmer colors
  static const Color shimmerColor = Color.fromRGBO(240, 240, 240, 1.0);

  //MARK: List item colors
  static const Color listItemBorderColor = Color.fromRGBO(237, 237, 237, 1.0);

  //MARK: Filter colors
  static const Color filtersBackgroundColor =
      Color.fromRGBO(223, 240, 247, 1.0);
  static const Color tabDatePickerColor = Color.fromARGB(255, 245, 245, 245);

  //MARK: Banner colors
  static const Color bannerBackgroundColor = Color.fromRGBO(248, 162, 40, 1.0);
}

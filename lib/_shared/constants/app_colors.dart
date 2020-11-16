import 'package:flutter/material.dart';

class AppColors {
  static final Color defaultColor = _getColorFromHex(AppColors._defaultColor);
  static final Color defaultColorDark =
      _getColorFromHex(AppColors._defaultColorDark);
  static final Color badgeColor = _getColorFromHex(AppColors._badgeColor);
  static final Color white = _getColorFromHex(AppColors._whiteColor);
  static final Color buttonColor = _getColorFromHex(AppColors._buttonColor);
  static final Color labelColor = _getColorFromHex(AppColors._labelColor);
  static final Color blackColor = _getColorFromHex(AppColors._blackColor);
  static final Color greyColor = _getColorFromHex(AppColors._greyColor);
  static final Color placeholderColor =
      _getColorFromHex(AppColors._placeholderColor);
  static final Color loginBackgroundGradiantColorOne =
      _getColorFromHex(AppColors._loginBackgroundGradiantColorOne);
  static final Color loginBackgroundGradiantColorTwo =
      _getColorFromHex(AppColors._loginBackgroundGradiantColorTwo);
  static final Color loginForgetPaasswordTextColor =
      _getColorFromHex(AppColors._loginForgetPaasswordTextColor);

  static final Color chartLineColor =
      _getColorFromHex(AppColors._chartLineColor);
  static final Color chartAxisTextColor =
      _getColorFromHex(AppColors._chartAxisTextColor);
  static final Color chartHorizontalLineColor =
      _getColorFromHex(AppColors._chartHorizontalLineColor);

  static final Color ForgetPaasswordSuccessButtonColor =
      _getColorFromHex(AppColors._lightGreenColor);
  static final Color ForgetPaasswordSuccessLabelColor =
      _getColorFromHex(AppColors._darkGreyColor);

  static final Color groupDashboardSearchViewColor =
      _getColorFromHex(AppColors._mediumGreyColor);

  static final Color filtersTextGreyColor =
      _getColorFromHex(AppColors._filtersGreyColor);

  static final Color filtersBackgroundGreyColor =
      _getColorFromHex(AppColors._filtersBackgroundGreyColor);

  static final Color attendanceLabelColor =
      _getColorFromHex(AppColors._darkGreyColor);
  static final Color attendanceLocationTextColor =
      _getColorFromHex(AppColors._defaultColor);

  static final Color logoutRedColor =
      _getColorFromHex(AppColors._logoutRedColor);
  static final Color statusRedColor =
      _getColorFromHex(AppColors._statusRedColor);

  static final Color goodPerformanceColor = _getColorFromHex('#2bba68');
  static final Color averagePerformanceColor = _getColorFromHex('#f0ad4e');
  static final Color badPerformanceColor = _getColorFromHex('#db544e');

  static final String _defaultColor = "#008cbf";
  static final String _defaultColorDark = "#0376a0";
  static final String _badgeColor = "#db544e";
  static final String _whiteColor = "FFFFFF";
  static final String _buttonColor = "3590de";
  static final String _labelColor = "777777";
  static final String _blackColor = "222222";
  static final String _placeholderColor = "AAAAAA";
  static final String _greyColor = "EBEBEB";
  static final String _mediumGreyColor = "#dedede";
  static final String _filtersGreyColor = "#9aa6b2";
  static final String _filtersBackgroundGreyColor = "#eeeeee";

  static final String _darkGreyColor = "#a3a3a3";

  static final String _lightGreenColor = "#2bba68";
  static final String _loginBackgroundGradiantColorOne = "4bafe1";
  static final String _loginBackgroundGradiantColorTwo = "2771ba";
  static final String _loginForgetPaasswordTextColor = '4bafe1';
  static final String _logoutRedColor = '#db544e';
  static final String _statusRedColor = '#ff5c57';

  static final String _chartLineColor = '#5dd2a9';
  static final String _chartAxisTextColor = '#75729e';
  static final String _chartHorizontalLineColor = '#f0f0f0';

  static Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}

import 'package:flutter/material.dart';

class AppColors {
  static const Color screenBackgroundColor = Colors.white;

  static const Color darkBlue = Color.fromRGBO(0, 60, 129, 1.0);
  static const Color blue = Color.fromRGBO(0, 105, 178, 1.0);
  static const Color lightBlue = Color.fromRGBO(0, 150, 227, 1.0);

  static final Color defaultColor = getColorFromHex('#008cbf');
  static final Color defaultColorDark = getColorFromHex('#0376a0');
  static final Color badgeColor = getColorFromHex('#db544e');

  //Chip Background colors

  static final Color backGroundColor = getColorFromHex('#DFF0F7');

  //Button colors
  static final Color actionButtonColor = defaultColor;
  static final Color criticalButtonColor = getColorFromHex('#db544e');
  static final Color darkGreyIconColor = Color.fromRGBO(100, 100, 100, 1.0);

  //Text colors
  static final Color labelColor = getColorFromHex('#777777');
  static final Color placeholderColor = getColorFromHex('#AAAAAA');
  static final Color greyColor = getColorFromHex('#DCDCDC');
  static final Color lightGreyColor = getColorFromHex('#EDEDED');
  static final Color lightBlueColor = getColorFromHex('#C3E4ED');

  //Chart colors
  static final Color chartLineColor = getColorFromHex('#5dd2a9');
  static final Color chartGridLineColor = getColorFromHex('#f0f0f0');

  //Success and failure colors
  static const Color successColor = Color.fromRGBO(43, 186, 104, 1.0);
  static const Color failureColor = Color.fromRGBO(212, 28, 28, 1.0);

  //Contrast background color for views like search bar, chips, etc
  static final Color primaryContrastColor = Color.fromRGBO(240, 240, 240, 1.0);

  //Performance colors
  static final Color goodPerformanceColor = getColorFromHex('#2bba68');
  static final Color averagePerformanceColor = getColorFromHex('#f0ad4e');
  static final Color badPerformanceColor = getColorFromHex('#db544e');

  //Leave status colors
  static final Color pendingApprovalColor = getColorFromHex('#f0ad4e');
  static final Color approvedColor = getColorFromHex('#2bba68');
  static final Color rejectedColor = getColorFromHex('#db544e');
  static final Color cancelledColor = getColorFromHex('#db544e');

  //Attendance status colors
  static final Color presentColor = Color.fromRGBO(43, 186, 104, 1.0);
  static final Color absentColor = getColorFromHex('#FF0000');
  static final Color lateColor = getColorFromHex('#ffa500');

  //Dashboard colors
  static final Color bottomSheetColor = getColorFromHex('#F8A228');

  //MARK: Util function to convert hex string to color
  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}

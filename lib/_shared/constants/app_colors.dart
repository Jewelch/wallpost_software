import 'package:flutter/material.dart';

class AppColors {
  static const Color defaultColor = Color.fromRGBO(24, 152, 224, 1.0);
  static const Color defaultColorWithTransparency = Color.fromRGBO(24, 152, 224, 0.6);
  static const Color defaultColorDark = Color.fromRGBO(6, 62, 127, 1.0);
  static const Color defaultColorDarkContrastColor = Color.fromRGBO(119, 155, 189, 1.0);

  static const Color screenBackgroundColor = Colors.white;
  static const Color textFieldBackgroundColor = Color.fromRGBO(237, 237, 237, 1.0);
  static const Color textFieldBorderColor = Color.fromRGBO(220, 220, 220, 0);
  static const Color textFieldFocusedBorderColor = AppColors.defaultColor;
  static const Color textFieldErrorBorderColor = Color.fromRGBO(212, 28, 28, 1.0);

  static const Color successColor = Color.fromRGBO(43, 186, 104, 1.0);
  static const Color failureColor = Color.fromRGBO(212, 28, 28, 1.0);
  static const Color headerCardSuccessColor = Color.fromRGBO(83, 238, 148, 1.0);
  static const Color headerCardFailureColor = Color.fromRGBO(250, 104, 100, 1.0);

  static const Color shimmerColor = Color.fromRGBO(240, 240, 240, 1.0);

  static const Color bannerBackgroundColor = Color.fromRGBO(248, 162, 40, 1.0);

  static const Color cautionColor = Color.fromRGBO(212, 28, 28, 1.0);

  static const Color filtersBackgroundColour = Color.fromRGBO(223, 240, 247, 1.0);

  //MARK: Attendance colors
  //TODO Attendance: Remove duplicates
  static final Color punchInButtonColor = Color.fromRGBO(43, 186, 104, 1.0);
  static final Color punchInMoreButtonColor = Color.fromRGBO(0, 152, 66, 1.0);
  static final Color punchOutButtonColor = Color.fromRGBO(246, 42, 32, 1.0);
  static final Color punchOutMoreButtonColor = Color.fromRGBO(226, 32, 23, 1.0);
  static final Color breakButtonColor = Color.fromRGBO(223, 240, 247, 1.0);
  static final Color resumeButtonColor = Color.fromRGBO(37, 208, 110, 1.0);
  static final Color attendanceButtonSubTextColor = Color.fromRGBO(217, 217, 217, 1.0);
  static final Color locationAddressTextColor = Color.fromRGBO(217, 217, 217, 1.0);


  static final Color attendanceReportLatePunchInDayTextColor = Color.fromRGBO(255, 248, 166, 0.20);
  static final Color attendanceReportAbsenceDayTextColor = Color.fromRGBO(255, 248, 82, 0.29);

  //expense requests colors
  static final Color darkGrey = Color.fromRGBO(100, 100, 100, 1.0);
}

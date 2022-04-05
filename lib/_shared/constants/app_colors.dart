import 'package:flutter/material.dart';

class AppColors {
  static const Color defaultColor = Color.fromRGBO(24, 152, 224, 1.0);
  static const Color defaultColorWithTransparency = Color.fromRGBO(24, 152, 224, 0.6);
  static final Color defaultColorDark = Color.fromRGBO(6, 62, 127, 1.0);

  static const Color screenBackgroundColor = Colors.white;
  static const Color textFieldBackgroundColor = Color.fromRGBO(237, 237, 237, 1.0);
  static const Color textFieldBorderColor = Color.fromRGBO(220, 220, 220, 0);
  static const Color textFieldFocusedBorderColor = AppColors.defaultColor;
  static const Color textFieldErrorBorderColor = Color.fromRGBO(212, 28, 28, 1.0);

  static const Color successColor = Color.fromRGBO(43, 186, 104, 1.0);
  static const Color failureColor = Color.fromRGBO(212, 28, 28, 1.0);

  static final Color shimmerColor = Color.fromRGBO(240, 240, 240, 1.0);

  static final Color bannerBackgroundColor = Color.fromRGBO(248, 162, 40, 1.0);

  static const Color cautionColor = Color.fromRGBO(212, 28, 28, 1.0);
}

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';

class StatusBarColorSetter {
  static void setColorBasedOnLoginStatus() {
    try {
      var user = CurrentUserProvider().getCurrentUser();
      var isLoggedIn = user != null;
      if (isLoggedIn) {
        setColorToWhite();
      } else {
        setColorToAppColor();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void setColorToAppColor() {
    try {
      var statusBarColor = AppColors.defaultColor;
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor, animate: false);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void setColorToWhite() {
    try {
      var statusBarColor = Colors.white;
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor, animate: false);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';

class StatusBarColorSetter {
  static void setColorBasedOnLoginStatus() async {
    try {
      var user = await CurrentUserProvider().getCurrentUser();
      var isLoggedIn = user != null;
      var statusBarColor = isLoggedIn ? Colors.white : AppColors.defaultColor;
      var shoutSetTextColorToWhite = isLoggedIn ? false : true;
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor, animate: false);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(shoutSetTextColorToWhite);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void setColorToAppColor() async {
    try {
      var statusBarColor = AppColors.defaultColor;
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor, animate: false);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class StatusBarColorSetter {
  // static void setColorBasedOnLoginStatus(bool isLoggedIn) {
  //   if (isLoggedIn) {
  //     setColorToWhite();
  //   } else {
  //     setColorToAppColor();
  //   }
  // }

  // static void setColorToAppColor() {
  //   try {
  //     var statusBarColor = AppColors.defaultColor;
  //     FlutterStatusbarcolor.setStatusBarColor(statusBarColor, animate: false);
  //     FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

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

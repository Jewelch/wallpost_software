import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class StatusBarColorSetter {
  void setColorToWhite() {
    try {
      var statusBarColor = Colors.white;
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor, animate: false);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setNavigationBarColor(statusBarColor);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    } catch (e) {
      //do nothing
    }
  }
}

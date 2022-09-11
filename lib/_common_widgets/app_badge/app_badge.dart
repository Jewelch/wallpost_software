import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class AppBadge {
  void updateAppBadge(int count) {
    try {
      if (count == 0)
        FlutterAppBadger.removeBadge();
      else
        FlutterAppBadger.updateBadgeCount(count);
    } on PlatformException {
      //do nothing
    }
  }
}

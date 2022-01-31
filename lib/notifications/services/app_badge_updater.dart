import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';

class AppBadgeUpdater {
  final UnreadNotificationsCountProvider _notificationsCountProvider;
  final CurrentUserProvider _currentUserProvider;

  AppBadgeUpdater()
      : _notificationsCountProvider = UnreadNotificationsCountProvider(),
        _currentUserProvider = CurrentUserProvider();

  updateBadgeCount() {
    _checkIfBadgeIsSupported();
  }

  _checkIfBadgeIsSupported() async {
    try {
      bool isAppBadgeSupported = await FlutterAppBadger.isAppBadgeSupported();
      if (isAppBadgeSupported) {
        var isLoggedIn = _currentUserProvider.isLoggedIn();
        if (isLoggedIn) {
          _getUnreadNotificationsCount();
        } else {
          _removeBadge();
        }
      }
    } on PlatformException {}
  }

  void _getUnreadNotificationsCount() async {
    try {
      var unreadNotificationsCount = await _notificationsCountProvider.getCount();
      num _selectedCompanyUnreadNotificationsCount = unreadNotificationsCount.totalUnreadNotifications;
      if (_selectedCompanyUnreadNotificationsCount > 0) {
        _addBadge(_selectedCompanyUnreadNotificationsCount.toInt());
      } else {
        _removeBadge();
      }
    } on WPException catch (_) {}
  }

  void _addBadge(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }
}

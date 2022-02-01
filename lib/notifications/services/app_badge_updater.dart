import 'package:wallpost/_common_widgets/app_badge/app_badge.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';

class AppBadgeUpdater {
  final AppBadge _appBadge;
  final UnreadNotificationsCountProvider _notificationsCountProvider;
  final CurrentUserProvider _currentUserProvider;

  AppBadgeUpdater()
      : _appBadge = AppBadge(),
        _notificationsCountProvider = UnreadNotificationsCountProvider(),
        _currentUserProvider = CurrentUserProvider();

  updateBadgeCount() async {
    if (!_currentUserProvider.isLoggedIn()) {
      _appBadge.updateAppBadge(0);
      return;
    }

    try {
      var unreadNotificationsCount = await _notificationsCountProvider.getCount();
      num count = unreadNotificationsCount.totalUnreadNotifications;
      _appBadge.updateAppBadge(count.toInt());
    } on WPException catch (_) {
      //think about this, ignore or set to 0
      _appBadge.updateAppBadge(0);
    }
  }
}

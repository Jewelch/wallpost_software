import 'package:wallpost/_common_widgets/app_badge/app_badge.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';

class AppBadgeUpdater {
  final CurrentUserProvider _currentUserProvider;
  final UnreadNotificationsCountProvider _notificationsCountProvider;
  final AppBadge _appBadge;
  num count = 0;

  AppBadgeUpdater()
      : _currentUserProvider = CurrentUserProvider(),
        _notificationsCountProvider = UnreadNotificationsCountProvider(),
        _appBadge = AppBadge();

  AppBadgeUpdater.initWith(
    this._currentUserProvider,
    this._notificationsCountProvider,
    this._appBadge,
  );

  updateBadgeCount() async {
    if (!_currentUserProvider.isLoggedIn()) {
      _appBadge.updateAppBadge(0);
      return;
    }

    try {
      var unreadNotificationsCount = await _notificationsCountProvider.getCount();
      count = unreadNotificationsCount.totalUnreadNotifications;
      _appBadge.updateAppBadge(count.toInt());
    } on WPException catch (_) {}
  }

}

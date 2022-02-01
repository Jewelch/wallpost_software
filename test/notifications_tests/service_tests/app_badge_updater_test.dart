import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_common_widgets/app_badge/app_badge.dart';
import 'package:wallpost/notifications/services/app_badge_updater.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

class MockAppBadge extends Mock implements AppBadge {}

class MockUnreadNotificationsCountProvider extends Mock implements UnreadNotificationsCountProvider {}

void main() {
  var currentUserProvider = MockCurrentUserProvider();
  var unreadNotificationsCountProvider = MockUnreadNotificationsCountProvider();
  var appBadge = MockAppBadge();
  var appBadgeUpdater = AppBadgeUpdater.initWith(
    currentUserProvider,
    unreadNotificationsCountProvider,
    appBadge,
  );

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(unreadNotificationsCountProvider);
    verifyNoMoreInteractions(appBadge);
  }

  test('app count badge is not updated when user is not logged in', () {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
      () => currentUserProvider.isLoggedIn(),
      () => appBadge.updateAppBadge(0),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to get updated badge count is ignored', () {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
    when(() => unreadNotificationsCountProvider.getCount()).thenAnswer((_) => Future.error(InvalidResponseException()));

    appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
      () => currentUserProvider.isLoggedIn(),
      () => unreadNotificationsCountProvider.getCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('app count badge is updated when user is logged in', () {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);

    appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
      () => appBadgeUpdater.updateBadgeCount(),
      () => appBadge.updateAppBadge(0),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_common_widgets/app_badge/app_badge.dart';
import 'package:wallpost/notification_center/constants/notification_urls.dart';
import 'package:wallpost/notification_center/services/notification_count_updater.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockAppBadge extends Mock implements AppBadge {}

void main() {
  var successfulResponse = Mocks.notificationCountResponse;
  var currentUserProvider = MockCurrentUserProvider();
  var networkAdapter = MockNetworkAdapter();
  var appBadge = MockAppBadge();
  var notificationCountUpdater = NotificationCountUpdater.initWith(
    currentUserProvider,
    networkAdapter,
    appBadge,
  );

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(appBadge);
  }

  setUp(() {
    clearInteractions(currentUserProvider);
    clearInteractions(appBadge);
    networkAdapter.reset();
  });

  test('app count badge is not updated when user is not logged in', () async {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    await notificationCountUpdater.updateCount();

    verifyInOrder([
      () => currentUserProvider.isLoggedIn(),
      () => appBadge.updateAppBadge(0),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  group("tests for when user is logged in", () {
    test('api request is built correctly', () async {
      when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
      Map<String, dynamic> requestParams = {};
      networkAdapter.succeed(successfulResponse);

      var _ = await notificationCountUpdater.updateCount();

      expect(networkAdapter.apiRequest.url, NotificationUrls.notificationCountUrl());
      expect(networkAdapter.apiRequest.parameters, requestParams);
    });

    test('does nothing when network adapter fails', () async {
      when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
      networkAdapter.fail(NetworkFailureException());

      await notificationCountUpdater.updateCount();

      verifyInOrder([
        () => currentUserProvider.isLoggedIn(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('does nothing when response is null', () async {
      when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
      networkAdapter.succeed(null);

      await notificationCountUpdater.updateCount();

      verifyInOrder([
        () => currentUserProvider.isLoggedIn(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('does nothing when response is of the wrong format', () async {
      when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
      networkAdapter.succeed('wrong response format');

      await notificationCountUpdater.updateCount();

      verifyInOrder([
        () => currentUserProvider.isLoggedIn(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('does nothing when entity mapping fails', () async {
      when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
      networkAdapter.succeed(<String, dynamic>{});

      await notificationCountUpdater.updateCount();

      verifyInOrder([
        () => currentUserProvider.isLoggedIn(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('success', () async {
      networkAdapter.succeed(successfulResponse);

      await notificationCountUpdater.updateCount();

      verifyInOrder([
        () => currentUserProvider.isLoggedIn(),
        () => appBadge.updateAppBadge(22),
      ]);

      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('test loading flag is set to true when the service is executed', () async {
      networkAdapter.succeed(successfulResponse);

      notificationCountUpdater.updateCount();

      expect(notificationCountUpdater.isLoading, true);
    });

    test('test loading flag is reset after success', () async {
      networkAdapter.succeed(successfulResponse);

      var _ = await notificationCountUpdater.updateCount();

      expect(notificationCountUpdater.isLoading, false);
    });

    test('test loading flag is reset after failure', () async {
      networkAdapter.fail(NetworkFailureException());

      try {
        var _ = await notificationCountUpdater.updateCount();
        fail('failed to throw exception');
      } catch (_) {
        expect(notificationCountUpdater.isLoading, false);
      }
    });
  });
}

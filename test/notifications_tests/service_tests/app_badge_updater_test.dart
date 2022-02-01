import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_common_widgets/app_badge/app_badge.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../main_tests/presenter_tests/main_presenter_test.dart';
import '../mocks.dart';

class MockUnreadNotificationsCountProvider extends Mock
    implements UnreadNotificationsCountProvider {}

class MockAppBadge extends Mock implements AppBadge {}

void main() {
  var mockCompany = MockCompany();
  var currentUserProvider = MockCurrentUserProvider();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var unreadNotificationsCountProvider = UnreadNotificationsCountProvider.initWith(mockNetworkAdapter);
  var appBadgeUpdater = MockAppBadgeUpdater();
  var appBadge = MockAppBadge();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(appBadgeUpdater);
    verifyNoMoreInteractions(unreadNotificationsCountProvider);
    verifyNoMoreInteractions(appBadge);
  }

  setUp(() {
    when(() => mockCompany.id).thenReturn('selectedCompanyId');
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser())
        .thenReturn(mockCompany);
  });

  test('app count badge is not updated when user is logged out', () {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
      () => appBadgeUpdater.updateBadgeCount(),
      () => appBadge.updateAppBadge(any()),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('app count badge is updated when user is logged in', ()  {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);

     appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
      () => appBadgeUpdater.updateBadgeCount(),
      () => appBadge.updateAppBadge(0),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('app count badge is not updated on exception', ()  {
    mockNetworkAdapter.fail(NetworkFailureException());
     appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
      () => appBadgeUpdater.updateBadgeCount(),
      () => appBadge.updateAppBadge(0),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

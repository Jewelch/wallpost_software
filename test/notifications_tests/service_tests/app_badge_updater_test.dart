import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../_mocks/mock_unread_notification_count_provider.dart';
import '../../main_tests/presenter_tests/main_presenter_test.dart';
import '../mocks.dart';

void main() {
  List<Map<String, dynamic>> successfulResponse =
      Mocks.notificationsListResponse;
  var mockCompany = MockCompany();
  var currentUserProvider = MockCurrentUserProvider();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var unreadNotificationsCountProvider = MockUnreadNotificationsCountProvider();
  var appBadgeUpdater = MockAppBadgeUpdater();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(appBadgeUpdater);
    verifyNoMoreInteractions(unreadNotificationsCountProvider);
  }

  setUp(() {
    when(() => mockCompany.id).thenReturn('selectedCompanyId');
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser())
        .thenReturn(mockCompany);
  });

  test('app count badge is not updated when user is logged out', () async {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    await appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
          () => appBadgeUpdater.updateBadgeCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('app count badge is updated when user is logged in', () async {
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);

    await appBadgeUpdater.updateBadgeCount();

    verifyInOrder([
          () => appBadgeUpdater.updateBadgeCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

}

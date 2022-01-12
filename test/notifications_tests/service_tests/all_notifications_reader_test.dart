import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';
import 'package:wallpost/notifications/services/all_notifications_reader.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../_mocks/mock_user.dart';

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  var mockUserProvider = MockCurrentUserProvider();
  var mockCompanyProvider = MockCompanyProvider();
  Map<String, dynamic> successfulResponse = {};
  var mockNetworkAdapter = MockNetworkAdapter();
  var allNotificationsReader = AllNotificationsReader.initWith(
    mockUserProvider,
    mockCompanyProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    when(() => mockUser.id).thenReturn('someUserId');
    when(() => mockCompany.id).thenReturn('someCompanyId');
    when(() => mockUserProvider.getCurrentUser()).thenReturn(mockUser);
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {'user_id': 'someUserId'};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await allNotificationsReader.markAllAsRead();

    expect(mockNetworkAdapter.apiRequest.url, NotificationUrls.markAllNotificationsAsReadUrl('someCompanyId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPostWithNonce, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await allNotificationsReader.markAllAsRead();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await allNotificationsReader.markAllAsRead();
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    allNotificationsReader.markAllAsRead();

    expect(allNotificationsReader.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await allNotificationsReader.markAllAsRead();

    expect(allNotificationsReader.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await allNotificationsReader.markAllAsRead();
      fail('failed to throw exception');
    } catch (_) {
      expect(allNotificationsReader.isLoading, false);
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  List<Map<String, dynamic>> successfulResponse = Mocks.notificationsListResponse;
  var mockCompany = MockCompany();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var notificationListProvider = NotificationsListProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUp(() {
    when(mockCompany.id).thenReturn('selectedCompanyId');
    when(mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await notificationListProvider.getNext();

    expect(mockNetworkAdapter.apiRequest.url,
        NotificationUrls.notificationsListUrl('REMOVE MODULE ID FROM URL', 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await notificationListProvider.getNext();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    notificationListProvider.getNext().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    notificationListProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    notificationListProvider.getNext().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await notificationListProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await notificationListProvider.getNext();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await notificationListProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var notificationsList = await notificationListProvider.getNext();
      expect(notificationsList, isNotEmpty);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    notificationListProvider.reset();
    try {
      expect(notificationListProvider.getCurrentPageNumber(), 1);
      await notificationListProvider.getNext();
      expect(notificationListProvider.getCurrentPageNumber(), 2);
      await notificationListProvider.getNext();
      expect(notificationListProvider.getCurrentPageNumber(), 3);
      await notificationListProvider.getNext();
      expect(notificationListProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    notificationListProvider.getNext();

    expect(notificationListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await notificationListProvider.getNext();

    expect(notificationListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await notificationListProvider.getNext();
      fail('failed to throw exception');
    } catch (_) {
      expect(notificationListProvider.isLoading, false);
    }
  });
}

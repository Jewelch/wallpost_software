import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';
import 'package:wallpost/notifications/entities/notification.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockNotification extends Mock implements Notification {}

void main() {
  var mockNotification = MockNotification();
  Map<String, dynamic> successfulResponse = {};
  var mockNetworkAdapter = MockNetworkAdapter();
  var singleNotificationReader = SingleNotificationReader.initWith(mockNetworkAdapter);

  setUpAll(() {
    when(mockNotification.notificationId).thenReturn('someNotificationId');
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await singleNotificationReader.markAsRead(mockNotification);

    expect(mockNetworkAdapter.apiRequest.url, NotificationUrls.markSingleNotificationsAsReadUrl('someNotificationId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await singleNotificationReader.markAsRead(mockNotification);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await singleNotificationReader.markAsRead(mockNotification);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    singleNotificationReader.markAsRead(mockNotification);

    expect(singleNotificationReader.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await singleNotificationReader.markAsRead(mockNotification);

    expect(singleNotificationReader.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await singleNotificationReader.markAsRead(mockNotification);
      fail('failed to throw exception');
    } catch (_) {
      expect(singleNotificationReader.isLoading, false);
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/notification_center/constants/notification_urls.dart';
import 'package:wallpost/notification_center/services/notification_token_synchronizer.dart';

import '../../_mocks/mock_network_adapter.dart';

main() {
  late MockNetworkAdapter mockNetworkAdapter;
  var successfulResponse = {'user_id': 12};
  late NotificationTokenSynchronizer tokenSynchronizer;

  setUp(() {
    mockNetworkAdapter = MockNetworkAdapter();
    tokenSynchronizer = NotificationTokenSynchronizer.initWith(mockNetworkAdapter);
  });

  test("api request is built correctly", () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await tokenSynchronizer.syncToken("someNotificationToken");

    expect(mockNetworkAdapter.apiRequest.url, NotificationUrls.syncTokenUrl());
    expect(mockNetworkAdapter.apiRequest.parameters, {'devicetoken': 'someNotificationToken'});
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await tokenSynchronizer.syncToken("someNotificationToken");
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    tokenSynchronizer.syncToken("someNotificationToken").then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    tokenSynchronizer.syncToken("someNotificationToken").then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await tokenSynchronizer.syncToken("someNotificationToken");
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await tokenSynchronizer.syncToken("someNotificationToken");
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when response does not container the required data', () async {
    mockNetworkAdapter.succeed(Map<String, dynamic>());

    try {
      var _ = await tokenSynchronizer.syncToken("someNotificationToken");
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      tokenSynchronizer.syncToken("someNotificationToken");
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    tokenSynchronizer.syncToken("someNotificationToken");

    expect(tokenSynchronizer.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await tokenSynchronizer.syncToken("someNotificationToken");

    expect(tokenSynchronizer.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await tokenSynchronizer.syncToken("someNotificationToken");
      fail('failed to throw exception');
    } catch (_) {
      expect(tokenSynchronizer.isLoading, false);
    }
  });
}

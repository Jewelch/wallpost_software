import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/firebase_fcm/constants/firebase_urls.dart';
import 'package:wallpost/firebase_fcm/services/firebase_token_updater.dart';
import 'package:wallpost/firebase_fcm/utils/firebase_device_token_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

class MockDeviceTokenProvider extends Mock implements FireBaseDeviceTokenProvider {}

main() {
  // mocks
  var mockDeviceTokenProvider = MockDeviceTokenProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var successfulResponse = {'user_id': 12};
  var firebaseTokenUpdater =
      FireBaseTokenUpdater.initWith(mockNetworkAdapter, mockDeviceTokenProvider);

  setUpAll(() {
    when(mockDeviceTokenProvider.getDeviceToken)
        .thenAnswer((invocation) => Future.value("device_token"));
  });

  test("api request is built correctly", () async {
    Map<String, dynamic> requestParams = {'devicetoken': 'device_token'};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await firebaseTokenUpdater.updateToken();

    expect(mockNetworkAdapter.apiRequest.url, FirebaseUrls.updateTokenUrl());
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());
    try {
      var _ = await firebaseTokenUpdater.updateToken();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when network adapter response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await firebaseTokenUpdater.updateToken();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when network adapter response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await firebaseTokenUpdater.updateToken();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test(
      'throws WrongResponseFormatException when network adapter response is not the right response shape',
      () async {
    mockNetworkAdapter.succeed({'wrong_key': false});

    try {
      var _ = await firebaseTokenUpdater.updateToken();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('executing flag is set to true when the service is executed', () {
    mockNetworkAdapter.succeed(successfulResponse);

    firebaseTokenUpdater.updateToken();

    expect(firebaseTokenUpdater.isExecuting, true);
  });

  test('executing flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await firebaseTokenUpdater.updateToken();

    expect(firebaseTokenUpdater.isExecuting, false);
  });

  test('executing flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await firebaseTokenUpdater.updateToken();
    } catch (e) {
      expect(firebaseTokenUpdater.isExecuting, false);
    }
  });

  test('calling update while still executing the first call do nothing', () async {
    clearInteractions(mockDeviceTokenProvider);
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = firebaseTokenUpdater.updateToken();
    _ = firebaseTokenUpdater.updateToken();
    _ = firebaseTokenUpdater.updateToken();

    var verifyResult = verify(() => mockDeviceTokenProvider.getDeviceToken());

    expect(verifyResult.callCount, 1);
  });

  test("success", () async {});
}

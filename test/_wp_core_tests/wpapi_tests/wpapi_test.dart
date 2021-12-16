// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_wp_core/user_management/services/access_token_provider.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/malformed_response_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_adapter.dart';
import 'package:wallpost/_wp_core/wpapi/services/nonce_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockDeviceInfo extends Mock implements DeviceInfoProvider {}

class MockAccessTokenProvider extends Mock implements AccessTokenProvider {}

class MockNonce extends Mock implements Nonce {}

class MockNonceProvider extends Mock implements NonceProvider {}

void main() {
  var simpleWpResponse = {
    "status": "success",
    "data": {"some": "data"}
  };
  var apiRequest = APIRequest('www.url.com');
  var mockDeviceInfo = MockDeviceInfo();
  var mockAccessTokenProvider = MockAccessTokenProvider();
  var mockNonce = MockNonce();
  var mockNonceProvider = MockNonceProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var wpApi = WPAPI.initWith(
    mockDeviceInfo,
    mockAccessTokenProvider,
    mockNonceProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    when(mockDeviceInfo.getDeviceId()).thenAnswer((_) => Future.value('someDeviceId'));
    when(mockNonce.value).thenReturn('randomNonce');
    when(mockNonceProvider.getNonce(any)).thenAnswer((_) => Future.value(mockNonce));
  });

  setUp(() {
    reset(mockAccessTokenProvider);
    mockNetworkAdapter.reset();
  });

  group('test if the right network executor functions are called', () {
    test('get', () async {
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.get(apiRequest);

      expect(mockNetworkAdapter.didCallGet, true);
    });

    test('put', () async {
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.put(apiRequest);

      expect(mockNetworkAdapter.didCallPut, true);
    });

    test('post', () async {
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.post(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
    });

    test('delete', () async {
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.delete(apiRequest);

      expect(mockNetworkAdapter.didCallDelete, true);
    });
  });

  group('test adding wp headers', () {
    test('auth token is not added when it is not available locally', () async {
      when(mockAccessTokenProvider.getToken()).thenAnswer((_) => Future.value(null));
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.post(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.headers['Content-Type'], 'application/json');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-Device-ID'], 'someDeviceId');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-App-ID'], AppId.appId);
      expect(mockNetworkAdapter.apiRequest.headers.containsKey('Authorization'), false);
    });

    test('auth token is added when it is available locally', () async {
      when(mockAccessTokenProvider.getToken()).thenAnswer((_) => Future.value('someAuthToken'));
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.post(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.headers['Content-Type'], 'application/json');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-Device-ID'], 'someDeviceId');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-App-ID'], AppId.appId);
      expect(mockNetworkAdapter.apiRequest.headers['Authorization'], isNotNull);
    });

    test('nonce is added when nonce functions are called', () async {
      when(mockAccessTokenProvider.getToken()).thenAnswer((_) => Future.value('someAuthToken'));
      mockNetworkAdapter.succeed(simpleWpResponse);

      var _ = await wpApi.postWithNonce(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.headers['X-Wp-Nonce'], 'randomNonce');
    });
  });

  group('test error processing', () {
    test('force refreshes token and reattempts API call in case of HTTP 401 exception with token expired code',
        () async {
      mockNetworkAdapter.fail(HTTPException(401, '{"code": 1022}'));
      mockNetworkAdapter.onComplete = () {
        mockNetworkAdapter.succeed(simpleWpResponse);
      };

      var _ = await wpApi.post(apiRequest);

      verify(mockAccessTokenProvider.getToken(forceRefresh: false)).called(1);
      verify(mockAccessTokenProvider.getToken(forceRefresh: true)).called(1);
      expect(mockNetworkAdapter.noOfTimesPostIsCalled, 2);
    });

    test('throws UnexpectedResponseFormatException when json decoding fails', () async {
      mockNetworkAdapter.succeed('non-json string');

      try {
        var _ = await wpApi.post(apiRequest);
        fail('expected to throw error, but did not');
      } catch (error) {
        expect(error is UnexpectedResponseFormatException, true);
      }
    });

    test('throws UnexpectedResponseFormatException when response data is not a map', () async {
      mockNetworkAdapter.succeed('not a map');

      try {
        var _ = await wpApi.post(apiRequest);
        fail('expected to throw error, but did not');
      } catch (error) {
        expect(error is UnexpectedResponseFormatException, true);
      }
    });

    test('throws MalformedResponseException when the status key is missing', () async {
      mockNetworkAdapter.succeed({"missing": "statusKey"});

      try {
        var _ = await wpApi.post(apiRequest);
        fail('expected to throw error, but did not');
      } catch (error) {
        expect(error is MalformedResponseException, true);
      }
    });

    test('throws MalformedResponseException when the data key is missing when status == success', () async {
      mockNetworkAdapter.succeed({"status": "success", "missing": "dataKey"});

      try {
        var _ = await wpApi.post(apiRequest);
        fail('expected to throw error, but did not');
      } catch (error) {
        expect(error is MalformedResponseException, true);
      }
    });

    test('throws ServerSentException when server sends a custom error', () async {
      mockNetworkAdapter.succeed({"status": "failure", "message": "task failed", "errorCode": 1004});

      try {
        var _ = await wpApi.post(apiRequest);
        fail('expected to throw error, but did not');
      } catch (error) {
        expect(error is ServerSentException, true);
        expect((error as ServerSentException).userReadableMessage, 'task failed');
        expect((error as ServerSentException).errorCode, 1004);
      }
    });

    test('converting empty response data list to List<Map<String, dynamic>>', () async {
      mockNetworkAdapter.succeed({"status": "success", "data": []});

      var response = await wpApi.post(apiRequest);

      expect(response.data is List<Map<String, dynamic>>, true);
      expect(response.data, []);
    });

    test('converting response data list with items of wrong format returns empty list', () async {
      mockNetworkAdapter.succeed({
        "status": "success",
        "data": [1, 2, 3]
      });

      var response = await wpApi.post(apiRequest);

      expect(response.data is List<Map<String, dynamic>>, true);
      expect(response.data, []);
    });

    test('converting response data list with items of correct format', () async {
      mockNetworkAdapter.succeed({
        "status": "success",
        "data": [
          {"userId": 1},
          {"userId": 2}
        ]
      });

      var response = await wpApi.post(apiRequest);

      expect(response.data is List<Map<String, dynamic>>, true);
      expect(response.data, [
        {'userId': 1},
        {'userId': 2}
      ]);
    });
  });
}

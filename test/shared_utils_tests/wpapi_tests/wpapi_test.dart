import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/network_adapter/network_adapter.dart';
import 'package:wallpost/_shared/user_management/services/access_token_provider.dart';
import 'package:wallpost/_shared/wpapi/wp_api.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockDeviceInfo extends Mock implements DeviceInfoProvider {}

class MockAccessTokenProvider extends Mock implements AccessTokenProvider {}

void main() {
  var apiRequest = APIRequest('www.url.com');
  var mockDeviceInfo = MockDeviceInfo();
  var mockAccessTokenProvider = MockAccessTokenProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var wpApi = WPAPI.initWith(mockDeviceInfo, mockAccessTokenProvider, mockNetworkAdapter);

  setUpAll(() {
    when(mockDeviceInfo.getDeviceId()).thenAnswer((_) => Future.value('someDeviceId'));
  });

  setUp(() {
    reset(mockAccessTokenProvider);
  });

  group('test if the right network executor functions are called', () {
    test('get', () async {
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var _ = await wpApi.get(apiRequest);

      expect(mockNetworkAdapter.didCallGet, true);
    });

    test('put', () async {
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var _ = await wpApi.put(apiRequest);

      expect(mockNetworkAdapter.didCallPut, true);
    });

    test('post', () async {
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var _ = await wpApi.post(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
    });
  });

  group('test adding wp headers', () {
    test('wp headers without authorization token', () async {
      when(mockAccessTokenProvider.getToken()).thenAnswer((_) => Future.value(null));
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var _ = await wpApi.post(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.headers['Content-Type'], 'application/json');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-Device-ID'], 'someDeviceId');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-App-ID'], AppId.appId);
      expect(mockNetworkAdapter.apiRequest.headers.containsKey('Authorization'), false);
    });

    test('wp headers with authorization token', () async {
      when(mockAccessTokenProvider.getToken()).thenAnswer((_) => Future.value('someAuthToken'));
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var _ = await wpApi.post(apiRequest);

      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.headers['Content-Type'], 'application/json');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-Device-ID'], 'someDeviceId');
      expect(mockNetworkAdapter.apiRequest.headers['X-WallPost-App-ID'], AppId.appId);
      expect(mockNetworkAdapter.apiRequest.headers['Authorization'], isNotNull);
    });
  });
}

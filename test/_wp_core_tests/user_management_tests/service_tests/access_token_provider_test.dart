import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/access_token_provider.dart';

import '../../../_mocks/mock_network_adapter.dart';
import '../../../_mocks/mock_user.dart';
import '../mocks.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockDeviceInfoProvider extends Mock implements DeviceInfoProvider {}

void main() {
  var mockUserRepository = MockUserRepository();
  var mockDeviceInfoProvider = MockDeviceInfoProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var accessTokenProvider = AccessTokenProvider.initWith(
    mockUserRepository,
    mockDeviceInfoProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    registerFallbackValue(MockUser());
    when(() => mockDeviceInfoProvider.getDeviceId()).thenAnswer((_) => Future.value('someDeviceId'));
  });

  setUp(() {
    reset(mockUserRepository);
  });

  test('null is returned when user is not found locally', () async {
    when(() => mockUserRepository.getCurrentUser()).thenReturn(null);

    var accessToken = await accessTokenProvider.getToken();

    verify(() => mockUserRepository.getCurrentUser()).called(1);
    expect(accessToken, null);
  });

  test('local user session is active', () async {
    var user = User.fromJson(Mocks.loginResponse);
    when(() => mockUserRepository.getCurrentUser()).thenReturn(user);

    var accessToken = await accessTokenProvider.getToken();

    verify(() => mockUserRepository.getCurrentUser()).called(1);
    expect(accessToken, 'accessToken');
  });

  group('refresh session', () {
    test('request is built correctly', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.fail(HTTPException(400, 'error response data'));

      var accessToken = await accessTokenProvider.getToken();

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      expect(mockNetworkAdapter.apiRequest.parameters['username'], 'someUserName');
      expect(mockNetworkAdapter.apiRequest.parameters['refresh_token'], 'refToken');
      expect(mockNetworkAdapter.apiRequest.parameters['deviceuid'], 'someDeviceId');
      expect(accessToken, null);
    });

    test('returns null if refresh token API fails', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.fail(HTTPException(400, 'error response data'));

      var accessToken = await accessTokenProvider.getToken();

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('returns null if refresh token API data is null', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.succeed(null);

      var accessToken = await accessTokenProvider.getToken();

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('returns null if refresh token API data is of the wrong format', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.succeed('wrong format');

      var accessToken = await accessTokenProvider.getToken();

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('returns null if authToken mapping fails', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var accessToken = await accessTokenProvider.getToken();

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('successfully getting a new auth token from the API', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.succeed({'status': 'success', 'data': Mocks.refreshSessionResponse});

      var accessToken = await accessTokenProvider.getToken();

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      verify(() => mockUserRepository.updateUser(any())).called(1);
      expect(accessToken, 'refreshedToken');
    });

    test('force refresh even if the local token has not expired', () async {
      var user = User.fromJson(Mocks.loginResponse);
      when(() => mockUserRepository.getCurrentUser()).thenReturn(user);
      mockNetworkAdapter.succeed({'status': 'success', 'data': Mocks.refreshSessionResponse});

      var accessToken = await accessTokenProvider.getToken(forceRefresh: true);

      verify(() => mockUserRepository.getCurrentUser()).called(1);
      verify(() => mockUserRepository.updateUser(any())).called(1);
      expect(accessToken, 'refreshedToken');
    });
  });
}

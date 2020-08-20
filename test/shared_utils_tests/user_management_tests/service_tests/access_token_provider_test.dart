import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';
import 'package:wallpost/_shared/user_management/services/access_token_provider.dart';

import '../../../_mocks/mock_network_adapter.dart';
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
    when(mockDeviceInfoProvider.getDeviceId()).thenAnswer((_) => Future.value('someDeviceId'));
  });

  setUp(() {
    reset(mockUserRepository);
  });

  test('null is returned when user is not found locally', () async {
    when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(null));

    var accessToken = await accessTokenProvider.getToken();

    verify(mockUserRepository.getCurrentUser()).called(1);
    expect(accessToken, null);
  });

  test('local user session is active', () async {
    var user = User.fromJson(Mocks.loginResponse);
    when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));

    var accessToken = await accessTokenProvider.getToken();

    verify(mockUserRepository.getCurrentUser()).called(1);
    expect(accessToken, 'active_token');
  });

  group('refresh session', () {
    test('request is built correctly', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
      mockNetworkAdapter.fail(HTTPException(400));

      var accessToken = await accessTokenProvider.getToken();

      verify(mockUserRepository.getCurrentUser()).called(1);
      expect(mockNetworkAdapter.apiRequest.parameters['username'], 'someUserName@test.com');
      expect(mockNetworkAdapter.apiRequest.parameters['refresh_token'], 'ref_token');
      expect(mockNetworkAdapter.apiRequest.parameters['deviceuid'], 'someDeviceId');
      expect(accessToken, null);
    });

    test('returns null if refresh token API fails', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
      mockNetworkAdapter.fail(HTTPException(400));

      var accessToken = await accessTokenProvider.getToken();

      verify(mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('returns null if refresh token API data is null', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
      mockNetworkAdapter.succeed(null);

      var accessToken = await accessTokenProvider.getToken();

      verify(mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('returns null if refresh token API data is of the wrong format', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
      mockNetworkAdapter.succeed('wrong format');

      var accessToken = await accessTokenProvider.getToken();

      verify(mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('returns null if authToken mapping fails', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
      mockNetworkAdapter.succeed(<String, dynamic>{});

      var accessToken = await accessTokenProvider.getToken();

      verify(mockUserRepository.getCurrentUser()).called(1);
      expect(accessToken, null);
    });

    test('successfully getting a new auth token from the API', () async {
      var user = User.fromJson(Mocks.userMapWithInactiveSession);
      when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
      mockNetworkAdapter.succeed(Mocks.refreshSessionResponse);

      var accessToken = await accessTokenProvider.getToken();

      verify(mockUserRepository.getCurrentUser()).called(1);
      verify(mockUserRepository.updateUser(any)).called(1);
      expect(accessToken, 'activeToken');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/user_management/constants/login_urls.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';
import 'package:wallpost/_wp_core/user_management/services/new_user_adder.dart';

import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockDeviceInfo extends Mock implements DeviceInfoProvider {}

class MockNewUserAdder extends Mock implements NewUserAdder {}

void main() {
  var credentials = Mocks.credentials;
  Map<String, dynamic> successfulResponse = Mocks.loginResponse;
  var mockDeviceInfo = MockDeviceInfo();
  var mockNewUserAdder = MockNewUserAdder();
  var mockNetworkAdapter = MockNetworkAdapter();
  var authenticator = Authenticator.initWith(mockDeviceInfo, mockNewUserAdder, mockNetworkAdapter);

  setUpAll(() {
    when(mockDeviceInfo.getDeviceId()).thenAnswer((_) => Future.value('someDeviceId'));
  });

  setUp(() {
    reset(mockNewUserAdder);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(credentials.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await authenticator.login(credentials);

    expect(mockNetworkAdapter.apiRequest.url, LoginUrls.authUrl());
    expect(mockNetworkAdapter.apiRequest.parameters['accountno'], credentials.accountNumber);
    expect(mockNetworkAdapter.apiRequest.parameters['username'], credentials.username);
    expect(mockNetworkAdapter.apiRequest.parameters['password'], credentials.password);
    expect(mockNetworkAdapter.apiRequest.parameters.containsKey('apptype'), true);
    expect(mockNetworkAdapter.apiRequest.parameters.containsKey('deviceuid'), true);
    expect(mockNetworkAdapter.apiRequest.parameters.containsKey('environment'), true);
    expect(mockNetworkAdapter.apiRequest.parameters.containsKey('deviceos'), true);
    expect(mockNetworkAdapter.apiRequest.parameters.containsKey('devicemodel'), true);
    expect(mockNetworkAdapter.apiRequest.parameters.containsKey('appversion'), true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await authenticator.login(credentials);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('convert 401 HTTP exception to a server sent exception', () async {
    mockNetworkAdapter.fail(HTTPException(401, 'error response data'));

    try {
      var _ = await authenticator.login(credentials);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is ServerSentException, true);
      expect((e as ServerSentException).userReadableMessage, 'Invalid username or password');
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await authenticator.login(credentials);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await authenticator.login(credentials);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await authenticator.login(credentials);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('successful login', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var user = await authenticator.login(credentials);
    expect(user, isNotNull);

    var userRepoVerificationResult = verify(mockNewUserAdder.addUser(captureAny));
    expect(userRepoVerificationResult.callCount, 1);
    expect(userRepoVerificationResult.captured.single, isNotNull);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';
import 'package:wallpost/password_management/services/password_changer.dart';

import '../../_mocks/mock_network_adapter.dart';

void main() {
  var changePasswordForm = ChangePasswordForm(
    oldPassword: randomString(10),
    newPassword: randomString(10),
  );
  Map<String, dynamic> successfulResponse = {};
  var mockNetworkAdapter = MockNetworkAdapter();
  var passwordChanger = PasswordChanger.initWith(mockNetworkAdapter);

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(changePasswordForm.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await passwordChanger.changePassword(changePasswordForm);

    expect(mockNetworkAdapter.apiRequest.url, PasswordManagementUrls.changePasswordUrl());
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPostWithNonce, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await passwordChanger.changePassword(changePasswordForm);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await passwordChanger.changePassword(changePasswordForm);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    passwordChanger.changePassword(changePasswordForm);

    expect(passwordChanger.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await passwordChanger.changePassword(changePasswordForm);

    expect(passwordChanger.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await passwordChanger.changePassword(changePasswordForm);
      fail('failed to throw exception');
    } catch (_) {
      expect(passwordChanger.isLoading, false);
    }
  });
}

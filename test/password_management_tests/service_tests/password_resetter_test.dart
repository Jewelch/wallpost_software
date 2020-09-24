import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';
import 'package:wallpost/password_management/services/password_resetter.dart';

import '../../_mocks/mock_network_adapter.dart';

void main() {
  var resetPasswordForm = ResetPasswordForm(
    randomString(10),
    randomString(10),
  );
  Map<String, dynamic> successfulResponse = {};
  var mockNetworkAdapter = MockNetworkAdapter();
  var passwordResetter = PasswordResetter.initWith(mockNetworkAdapter);

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(resetPasswordForm.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await passwordResetter.resetPassword(resetPasswordForm);

    expect(mockNetworkAdapter.apiRequest.url, PasswordManagementUrls.resetPasswordUrl());
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await passwordResetter.resetPassword(resetPasswordForm);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await passwordResetter.resetPassword(resetPasswordForm);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    passwordResetter.resetPassword(resetPasswordForm);

    expect(passwordResetter.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await passwordResetter.resetPassword(resetPasswordForm);

    expect(passwordResetter.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await passwordResetter.resetPassword(resetPasswordForm);
      fail('failed to throw exception');
    } catch (_) {
      expect(passwordResetter.isLoading, false);
    }
  });
}

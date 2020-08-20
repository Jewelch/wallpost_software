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

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(resetPasswordForm.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await passwordResetter.resetPassword(resetPasswordForm);

    expect(mockNetworkAdapter.apiRequest.url, PasswordManagementUrls.passwordResetterUrl());
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
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
}

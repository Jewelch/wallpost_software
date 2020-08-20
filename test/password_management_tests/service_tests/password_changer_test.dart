import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_string/random_string.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';
import 'package:wallpost/password_management/services/password_changer.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../_mocks/mock_user.dart';

void main() {
  var changePasswordForm = ChangePasswordForm(
    randomString(10),
    randomString(10),
    randomString(10),
  );
  Map<String, dynamic> successfulResponse = {};
  var mockUser = MockUser();
  var mockUserProvider = MockCurrentUserProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var passwordChanger = PasswordChanger.initWith(mockUserProvider, mockNetworkAdapter);

  setUp(() {
    when(mockUser.companyId).thenReturn('someCompanyId');
    when(mockUserProvider.getCurrentUser()).thenAnswer((_) => Future.value(mockUser));
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(changePasswordForm.toJson());
    mockNetworkAdapter.succeed({});

    var _ = await passwordChanger.update(changePasswordForm);

    expect(mockNetworkAdapter.apiRequest.url, PasswordManagementUrls.changePasswordUrl('someCompanyId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await passwordChanger.update(changePasswordForm);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await passwordChanger.update(changePasswordForm);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}

import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/password_management_urls.dart';
import '../entities/change_password_form.dart';

class PasswordChanger {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PasswordChanger() : _networkAdapter = WPAPI();

  PasswordChanger.initWith(this._networkAdapter);

  Future<void> changePassword(ChangePasswordForm changePasswordForm) async {
    var url = PasswordManagementUrls.changePasswordUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(changePasswordForm.toJson());
    isLoading = true;

    try {
      var _ = await _networkAdapter.postWithNonce(apiRequest);
      isLoading = false;
      return null;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}

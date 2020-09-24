import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';

class PasswordResetter {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  PasswordResetter() : _networkAdapter = WPAPI();

  PasswordResetter.initWith(this._networkAdapter);

  Future<void> resetPassword(ResetPasswordForm resetPasswordForm) async {
    var url = PasswordManagementUrls.resetPasswordUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(resetPasswordForm.toJson());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<void> _processResponse(APIResponse apiResponse) async {
    return null;
  }
}

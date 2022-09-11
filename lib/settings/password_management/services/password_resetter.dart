import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/settings/password_management/constants/password_management_urls.dart';
import 'package:wallpost/settings/password_management/entities/reset_password_form.dart';

class PasswordResetter {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PasswordResetter() : _networkAdapter = WPAPI();

  PasswordResetter.initWith(this._networkAdapter);

  Future<void> resetPassword(ResetPasswordForm resetPasswordForm) async {
    var url = PasswordManagementUrls.resetPasswordUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(resetPasswordForm.toJson());
    isLoading = true;

    try {
      var _ = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return null;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}

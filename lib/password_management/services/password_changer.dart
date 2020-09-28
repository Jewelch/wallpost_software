import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';

class PasswordChanger {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  PasswordChanger() : _networkAdapter = WPAPI();

  PasswordChanger.initWith(this._networkAdapter);

  Future<void> changePassword(ChangePasswordForm changePasswordForm) async {
    var url = PasswordManagementUrls.changePasswordUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(changePasswordForm.toJson());
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

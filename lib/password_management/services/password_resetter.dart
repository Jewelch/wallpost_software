import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';

class PasswordResetter {
  NetworkAdapter _networkAdapter;
  bool isLoading = false;

  PasswordResetter() {
    _networkAdapter = WPAPI();
  }

  PasswordResetter.initWith(this._networkAdapter);

  Future<void> resetPassword(ResetPasswordForm resetPasswordForm) async {
    var url = PasswordManagementUrls.passwordResetterUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(resetPasswordForm.toJson());
    isLoading = true;

    var apiResponse = await _networkAdapter.post(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  void _processResponse(APIResponse apiResponse) {
    return null;
  }
}

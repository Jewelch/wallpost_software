import 'package:wallpost/_shared/network_adapter/network_adapter.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/password_management/constants/password_management_urls.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';

class PasswordChanger {
  CurrentUserProvider _currentUserProvider;
  NetworkAdapter _networkAdapter;
  bool isLoading = false;

  PasswordChanger() {
    _currentUserProvider = CurrentUserProvider();
    _networkAdapter = WPAPI();
  }

  PasswordChanger.initWith(this._currentUserProvider, this._networkAdapter);

  Future<void> update(ChangePasswordForm changePasswordForm) async {
    var user = await _currentUserProvider.getCurrentUser();
    var url = PasswordManagementUrls.changePasswordUrl(user.companyId);
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(changePasswordForm.toJson());
    isLoading = true;

    var apiResponse = await _networkAdapter.post(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  void _processResponse(APIResponse apiResponse) {
    return null;
  }
}

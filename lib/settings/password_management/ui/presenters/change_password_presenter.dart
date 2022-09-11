import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/settings/password_management/entities/change_password_form.dart';
import 'package:wallpost/settings/password_management/services/password_changer.dart';
import 'package:wallpost/settings/password_management/ui/contracts/change_password_view.dart';

class ChangePasswordPresenter {
  final ChangePasswordView _view;
  final CurrentUserProvider _userProvider;
  final PasswordChanger _passwordChanger;

  ChangePasswordPresenter(this._view)
      : _userProvider = CurrentUserProvider(),
        _passwordChanger = PasswordChanger();

  ChangePasswordPresenter.initWith(
    this._view,
    this._userProvider,
    this._passwordChanger,
  );

  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    if (_passwordChanger.isLoading) return;

    _view.clearErrors();
    if (!_isInputValid(oldPassword, newPassword, confirmPassword)) return;

    _view.disableFormInput();
    _view.showLoader();
    try {
      var changePasswordForm = ChangePasswordForm(oldPassword: oldPassword, newPassword: newPassword);
      var _ = await _passwordChanger.changePassword(changePasswordForm);
      _view.hideLoader();
      _view.goToSuccessScreen();
    } on WPException catch (e) {
      _view.enableFormInput();
      _view.hideLoader();
      _view.onChangePasswordFailed("Failed to change password", e.userReadableMessage);
    }
  }

  bool _isInputValid(String oldPassword, String newPassword, String confirmPassword) {
    var isValid = true;

    if (oldPassword.isEmpty) {
      isValid = false;
      _view.notifyInvalidCurrentPassword("Please enter current password");
    }

    if (newPassword.isEmpty) {
      isValid = false;
      _view.notifyInvalidNewPassword("Please enter new password");
    }

    if (confirmPassword.isEmpty) {
      isValid = false;
      _view.notifyInvalidConfirmPassword("Please re-enter new password");
    }

    if (newPassword != confirmPassword) {
      isValid = false;
      _view.notifyInvalidConfirmPassword("The passwords do not match");
    }

    return isValid;
  }

  String getUserName() {
    return _userProvider.getCurrentUser().fullName;
  }

  String getProfileImage() {
    return _userProvider.getCurrentUser().profileImageUrl;
  }
}

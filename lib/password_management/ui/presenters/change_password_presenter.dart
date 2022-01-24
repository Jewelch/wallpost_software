import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';
import 'package:wallpost/password_management/services/password_changer.dart';
import 'package:wallpost/password_management/ui/contracts/change_password_view.dart';

class ChangePasswordPresenter {
  final ChangePasswordView _view;
  final PasswordChanger _passwordChanger;

  ChangePasswordPresenter(this._view) : _passwordChanger = PasswordChanger();

  ChangePasswordPresenter.initWith(this._view, this._passwordChanger);

  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    _view.clearErrors();
    if (!_isInputValid(oldPassword, newPassword, confirmPassword)) return;
    if (_passwordChanger.isLoading) return;
    _view.showLoader();
    try {
      var changePasswordForm = ChangePasswordForm(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      var _ = await _passwordChanger.changePassword(changePasswordForm);
      _view.hideLoader();
      _view.goToSuccessScreen();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onChangePasswordFailed(
          "Failed to change Password", e.userReadableMessage);
    }
  }

  bool _isInputValid(
      String oldPassword, String newPassword, String confirmPassword) {
    var isValid = true;

    if (oldPassword.isEmpty) {
      isValid = false;
      _view.notifyInvalidCurrentPassword("Please Enter Current Password");
    }

    if (newPassword.isEmpty) {
      isValid = false;
      _view.notifyInvalidNewPassword("Please Enter New Password");
    }

    if (confirmPassword.isEmpty) {
      isValid = false;
      _view.notifyInvalidConfirmPassword("Please Re-Enter New Password");
    }

    if (newPassword != confirmPassword) {
      isValid = false;
      _view.notifyInvalidConfirmPassword("The Passwords Do Not Match");
    }

    return isValid;
  }

  String getUserName() {
    return CurrentUserProvider().getCurrentUser().fullName;
  }

  String getProfileImage() {
    return CurrentUserProvider().getCurrentUser().profileImageUrl;
  }
}

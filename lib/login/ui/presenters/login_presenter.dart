// @dart=2.9

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/entities/credentials.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';

class LoginPresenter {
  final LoginView _view;
  final Authenticator _authenticator;

  LoginPresenter(this._view) : _authenticator = Authenticator();

  LoginPresenter.initWith(this._view, this._authenticator);

  Future<void> login(String accountNumber, String username, String password) async {
    if (!_isInputValid(accountNumber, username, password)) return;
    if (_authenticator.isLoading) return;

    try {
      _view.showLoader();
      await _authenticator.login(Credentials(accountNumber, username, password));
      _view.hideLoader();
      _view.goToCompanyListScreen();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onLoginFailed("Login Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String accountNumber, String username, String password) {
    var isValid = true;

    if (accountNumber.isEmpty) {
      isValid = false;
      _view.notifyInvalidAccountNumber("Invalid account number");
    }

    if (username.isEmpty) {
      isValid = false;
      _view.notifyInvalidUsername("Invalid username");
    }

    if (password.isEmpty) {
      isValid = false;
      _view.notifyInvalidPassword("Invalid password");
    }

    return isValid;
  }

  void onKeyboardVisibilityChange({bool visibility}) {
    visibility ? _view.hideLogoIcon() : _view.showLogoIcon();
  }
}

import 'dart:core';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';
import 'package:wallpost/password_management/services/password_resetter.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';

class ForgotPasswordPresenter {
  final ForgotPasswordView _view;
  final PasswordResetter _passwordResetter;

  ForgotPasswordPresenter(this._view) : _passwordResetter = PasswordResetter();

  ForgotPasswordPresenter.initWith(this._view, this._passwordResetter);

  Future<void> resetPassword(String _accountNumber, String _email) async {
    _view.clearErrors();
    if (!_isInputValid(_accountNumber, _email)) return;
    if (_passwordResetter.isLoading) return;

    try {
      _view.showLoader();
      var resetPasswordForm = ResetPasswordForm(_accountNumber, _email);
      await _passwordResetter.resetPassword(resetPasswordForm);
      _view.hideLoader();
      _view.goToSuccessScreen();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onResetPasswordFailed("Reset password failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String accountNumber, String email) {
    var isValid = true;

    if (accountNumber.isEmpty) {
      isValid = false;
      _view.notifyInvalidAccountNumber("Invalid account number");
    }

    if (!_isEmailValid(email)) {
      isValid = false;
      _view.notifyInvalidEmailFormat("Invalid email format");
    }

    return isValid;
  }

  bool _isEmailValid(String email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(email)) {
      return false;
    }
    return true;
  }
}

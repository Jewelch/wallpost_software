// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';
import 'package:wallpost/login/ui/presenters/login_presenter.dart';
import 'package:wallpost/password_management/services/password_resetter.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/forgot_password_presenter.dart';

import '../_mocks/mock_network_adapter.dart';

class MockForgotPasswordView extends Mock implements ForgotPasswordView {}

class MockPasswordResetter extends Mock implements PasswordResetter {}

void main() {
  var view = MockForgotPasswordView();
  var passwordResetter = MockPasswordResetter();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(passwordResetter);
  }

  test('reset password is successful', () async {
    //given
    when(passwordResetter.isLoading).thenReturn(false);
    ForgotPasswordPresenter presenter =
        ForgotPasswordPresenter.initWith(view, passwordResetter);

    //when
    await presenter.resetPassword("account number", "email@email.com");

    //then
    verifyInOrder([
      view.clearErrors(),
      passwordResetter.isLoading,
      view.showLoader(),
      passwordResetter.resetPassword(any),
      view.hideLoader(),
      view.goToSuccessScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('email format is faulty', () async {
    //given
    when(passwordResetter.isLoading).thenReturn(false);
    ForgotPasswordPresenter presenter =
        ForgotPasswordPresenter.initWith(view, passwordResetter);

    //when
    await presenter.resetPassword("account number", "email");

    //then
    verifyInOrder([
      view.clearErrors(),
      view.notifyInvalidEmailFormat("Invalid email format")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submit invalid credentials notifies the view', () async {
    //given
    when(passwordResetter.isLoading).thenReturn(false);
    ForgotPasswordPresenter presenter =
        ForgotPasswordPresenter.initWith(view, passwordResetter);

    //when
    await presenter.resetPassword("", "");

    //then
    verifyInOrder([
      view.clearErrors(),
      view.notifyInvalidAccountNumber("Invalid account number"),
      view.notifyInvalidEmailFormat("Invalid email format"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submit valid credentials clears the errors', () async {
    //given
    when(passwordResetter.isLoading).thenReturn(false);
    ForgotPasswordPresenter presenter =
        ForgotPasswordPresenter.initWith(view, passwordResetter);
    await presenter.resetPassword("", "");

    //when
    await presenter.resetPassword("someAccountNumber", "email@email.com");

    //then
    verifyInOrder([
      view.clearErrors(),
      view.notifyInvalidAccountNumber("Invalid account number"),
      view.notifyInvalidEmailFormat("Invalid email format"),
      view.clearErrors(),
      passwordResetter.isLoading,
      view.showLoader(),
      passwordResetter.resetPassword(any),
      view.hideLoader(),
      view.goToSuccessScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('passwordResetter loading does nothing', () async {
    //given
    when(passwordResetter.isLoading).thenReturn(true);
    ForgotPasswordPresenter presenter =
    ForgotPasswordPresenter.initWith(view, passwordResetter);

    //when
    await presenter.resetPassword("someAccountNumber", "email@email.com");


    //then
    verifyInOrder([
      view.clearErrors(),
      passwordResetter.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });


  test('failure to reset password ', () async {
    //given
    when(passwordResetter.isLoading).thenReturn(false);
    when(passwordResetter.resetPassword(any)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    ForgotPasswordPresenter presenter = ForgotPasswordPresenter.initWith(view, passwordResetter);

    //when
    await presenter.resetPassword("account number", "email@email.com");


    //then
    verifyInOrder([
      view.clearErrors(),
      passwordResetter.isLoading,
      view.showLoader(),
      passwordResetter.resetPassword(any),
      view.hideLoader(),
      view.onFailed("Reset password Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';
import 'package:wallpost/login/ui/presenters/login_presenter.dart';

import '../_mocks/mock_network_adapter.dart';

class MockLoginView extends Mock implements LoginView {}

class MockAuthenticator extends Mock implements Authenticator {}

void main() {
  var view = MockLoginView();
  var authenticator = MockAuthenticator();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(authenticator);
  }

  test('logging in successfully', () async {
    //given
    when(authenticator.isLoading).thenReturn(false);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    //then
    verifyInOrder([
      authenticator.isLoading,
      view.showLoader(),
      authenticator.login(any),
      view.hideLoader(),
      view.goToCompanyListScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      'logging in with invalid credentials notifies the view | verify the order',
      () async {
    when(authenticator.isLoading).thenReturn(false);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("", "", "");

    verifyInOrder([
      view.notifyInvalidAccountNumber(any),
      view.notifyInvalidUsername(any),
      view.notifyInvalidPassword(any),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      'logging in with invalid credentials notifies the view | verify the messages',
      () async {
    when(authenticator.isLoading).thenReturn(false);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("", "", "");

    expect(verify(view.notifyInvalidAccountNumber(captureAny)).captured.single,
        "Invalid account number");
    expect(verify(view.notifyInvalidUsername(captureAny)).captured.single,
        "Invalid username");
    expect(verify(view.notifyInvalidPassword(captureAny)).captured.single,
        "Invalid password");
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in when the authenticator is loading does nothing', () async {
    when(authenticator.isLoading).thenReturn(true);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    verifyInOrder([
      authenticator.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to login successfully | verify the order', () async {
    when(authenticator.isLoading).thenReturn(false);
    when(authenticator.login(any)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    verifyInOrder([
      authenticator.isLoading,
      view.showLoader(),
      authenticator.login(any),
      view.hideLoader(),
      view.onLoginFailed(
          "Login Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to login successfully | verify the title and the message',
      () async {
    when(authenticator.isLoading).thenReturn(false);
    when(authenticator.login(any)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    expect(verify(view.onLoginFailed(captureAny, captureAny)).captured,
        ["Login Failed", InvalidResponseException().userReadableMessage]);
    reset(view);
    reset(authenticator);
  });

  test("test showing the logo icon when hiding the keyboard", () {
    when(authenticator.isLoading).thenReturn(false);
    when(authenticator.login(any)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    presenter.onKeyboardVisibilityChange(visibility: false);
    verify(view.showLogoIcon());
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("test hiding the logo icon when showing the keyboard", () {
    when(authenticator.isLoading).thenReturn(false);
    when(authenticator.login(any)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    presenter.onKeyboardVisibilityChange(visibility: true);
    verify(view.hideLogoIcon());
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

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
    LoginPresenter presenter = LoginPresenter(view, authenticator);

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

  test('logging in with invalid credentials notifies the view', () async {
    when(authenticator.isLoading).thenReturn(false);
    LoginPresenter presenter = LoginPresenter(view, authenticator);

    //when
    await presenter.login("", "", "");

    verifyInOrder([
      view.notifyInvalidAccountNumber(),
      view.notifyInvalidUsername(),
      view.notifyInvalidPassword(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in when the authenticator is loading does nothing', () async {
    when(authenticator.isLoading).thenReturn(true);
    LoginPresenter presenter = LoginPresenter(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    verifyInOrder([
      authenticator.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to login successfully', () async {
    when(authenticator.isLoading).thenReturn(false);
    when(authenticator.login(any)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    LoginPresenter presenter = LoginPresenter(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    verifyInOrder([
      authenticator.isLoading,
      view.showLoader(),
      authenticator.login(any),
      view.hideLoader(),
      view.onLoginFailed("Login Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

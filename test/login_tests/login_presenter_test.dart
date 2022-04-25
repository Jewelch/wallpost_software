import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/user_management/entities/credentials.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';
import 'package:wallpost/login/ui/presenters/login_presenter.dart';

import '../_mocks/mock_network_adapter.dart';
import '../_mocks/mock_user.dart';

class MockLoginView extends Mock implements LoginView {}

class MockAuthenticator extends Mock implements Authenticator {}

class MockCredentials extends Mock implements Credentials {}

void main() {
  var view = MockLoginView();
  var authenticator = MockAuthenticator();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(authenticator);
  }

  setUpAll(() {
    registerFallbackValue(MockCredentials());
  });

  test('logging in successfully', () async {
    //given
    when(() => authenticator.isLoading).thenReturn(false);
    when(() => authenticator.login(any())).thenAnswer((_) => Future.value(MockUser()));
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => authenticator.isLoading,
      () => view.disableFormInput(),
      () => view.showLoader(),
      () => authenticator.login(any()),
      () => view.hideLoader(),
      () => view.goToCompanyListScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in with invalid credentials notifies the view', () async {
    //given
    when(() => authenticator.isLoading).thenReturn(false);
    // when(() => authenticator.login(any)).thenReturn(false);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("", "", "");

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => view.notifyInvalidAccountNumber("Invalid account number"),
      () => view.notifyInvalidUsername("Invalid username"),
      () => view.notifyInvalidPassword("Invalid password"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in with valid credentials clears the errors', () async {
    //given
    when(() => authenticator.isLoading).thenReturn(false);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);
    await presenter.login("", "", "");

    //when
    await presenter.login("someAccountNumber", "someUsername", "");

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => view.notifyInvalidAccountNumber("Invalid account number"),
      () => view.notifyInvalidUsername("Invalid username"),
      () => view.notifyInvalidPassword("Invalid password"),
      () => view.clearLoginErrors(),
      () => view.notifyInvalidPassword("Invalid password"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('logging in when the authenticator is loading does nothing', () async {
    //given
    when(() => authenticator.isLoading).thenReturn(true);
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => authenticator.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to login successfully', () async {
    //given
    when(() => authenticator.isLoading).thenReturn(false);
    when(() => authenticator.login(any())).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    LoginPresenter presenter = LoginPresenter.initWith(view, authenticator);

    //when
    await presenter.login("account number", "username", "password");

    //then
    verifyInOrder([
      () => view.clearLoginErrors(),
      () => authenticator.isLoading,
      () => view.disableFormInput(),
      () => view.showLoader(),
      () => authenticator.login(any()),
      () => view.enableFormInput(),
      () => view.hideLoader(),
      () => view.onLoginFailed("Login Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

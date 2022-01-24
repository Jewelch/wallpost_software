import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';
import 'package:wallpost/password_management/services/password_changer.dart';
import 'package:wallpost/password_management/ui/contracts/change_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/change_password_presenter.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockChangePasswordView extends Mock implements ChangePasswordView {}

class MockPasswordChanger extends Mock implements PasswordChanger {}

class MockChangePasswordForm extends Mock implements ChangePasswordForm {}

void main() {
  var view = MockChangePasswordView();
  var passwordChanger = MockPasswordChanger();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(passwordChanger);
  }

  setUpAll(() {
    registerFallbackValue(MockChangePasswordForm());
  });

  test('change password successful', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    when(() => passwordChanger.changePassword(any()))
        .thenAnswer((_) => Future.value(null));
    ChangePasswordPresenter presenter =
        ChangePasswordPresenter.initWith(view, passwordChanger);

    //when
    await presenter.changePassword("oldPassword", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => view.clearErrors(),
      () => passwordChanger.isLoading,
      () => view.showLoader(),
      () => passwordChanger.changePassword(any()),
      () => view.hideLoader(),
      () => view.goToSuccessScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submit invalid credentials notifies the view ', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    ChangePasswordPresenter presenter =
        ChangePasswordPresenter.initWith(view, passwordChanger);

    //when
    await presenter.changePassword("", "", "");

    //then
    verifyInOrder([
      () => view.clearErrors(),
      () => view.notifyInvalidCurrentPassword("Please Enter Current Password"),
      () => view.notifyInvalidNewPassword("Please Enter New Password"),
      () => view.notifyInvalidConfirmPassword("Please Re-Enter New Password"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submit valid credentials clears the errors ', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    ChangePasswordPresenter presenter =
        ChangePasswordPresenter.initWith(view, passwordChanger);
    when(() => passwordChanger.changePassword(any()))
        .thenAnswer((_) => Future.value(null));
    await presenter.changePassword("", "", "");

    //when
    await presenter.changePassword("password", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => view.clearErrors(),
      () => view.notifyInvalidCurrentPassword("Please Enter Current Password"),
      () => view.notifyInvalidNewPassword("Please Enter New Password"),
      () => view.notifyInvalidConfirmPassword("Please Re-Enter New Password"),
      () => view.clearErrors(),
      () => passwordChanger.isLoading,
      () => view.showLoader(),
      () => passwordChanger.changePassword(any()),
      () => view.hideLoader(),
      () => view.goToSuccessScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('notifies view if new password and confirm password does not match ',
      () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    ChangePasswordPresenter presenter =
        ChangePasswordPresenter.initWith(view, passwordChanger);

    //when
    await presenter.changePassword("password", "new", "confirm");

    //then
    verifyInOrder([
      () => view.clearErrors(),
      () => view.notifyInvalidConfirmPassword("The Passwords Do Not Match"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('resetting when the password changer is loading does nothing ',
      () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(true);
    ChangePasswordPresenter presenter =
        ChangePasswordPresenter.initWith(view, passwordChanger);

    //when
    await presenter.changePassword("oldPassword", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => view.clearErrors(),
      () => passwordChanger.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('change password failed', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    when(() => passwordChanger.changePassword(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    ChangePasswordPresenter presenter =
        ChangePasswordPresenter.initWith(view, passwordChanger);

    //when
    await presenter.changePassword("oldPassword", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => view.clearErrors(),
      () => passwordChanger.isLoading,
      () => view.showLoader(),
      () => passwordChanger.changePassword(any()),
      () => view.hideLoader(),
      () => view.onChangePasswordFailed("Failed to change Password",
          InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('get name and profile image of user successfully', () {
    ChangePasswordPresenter presenter =
    ChangePasswordPresenter.initWith(view, passwordChanger);

    verifyInOrder([
      () => presenter.getProfileImage(),
      () => presenter.getUserName(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

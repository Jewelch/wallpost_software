import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';
import 'package:wallpost/password_management/services/password_changer.dart';
import 'package:wallpost/password_management/ui/contracts/change_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/change_password_presenter.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../_mocks/mock_user.dart';

class MockChangePasswordView extends Mock implements ChangePasswordView {}

class MockPasswordChanger extends Mock implements PasswordChanger {}

class MockChangePasswordForm extends Mock implements ChangePasswordForm {}

void main() {
  var view = MockChangePasswordView();
  var userProvider = MockCurrentUserProvider();
  var passwordChanger = MockPasswordChanger();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(passwordChanger);
  }

  setUpAll(() {
    registerFallbackValue(MockChangePasswordForm());
  });

  setUp(() {
    clearInteractions(view);
    clearInteractions(passwordChanger);
  });

  test('resetting when the password changer is loading does nothing ', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(true);
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);

    //when
    await presenter.changePassword("oldPassword", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => passwordChanger.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submit invalid credentials notifies the view ', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);

    //when
    await presenter.changePassword("", "", "");

    //then
    verifyInOrder([
      () => passwordChanger.isLoading,
      () => view.clearErrors(),
      () => view.notifyInvalidCurrentPassword("Please enter current password"),
      () => view.notifyInvalidNewPassword("Please enter new password"),
      () => view.notifyInvalidConfirmPassword("Please re-enter new password"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('notifies view if new password and confirm password does not match ', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);

    //when
    await presenter.changePassword("password", "new", "confirm");

    //then
    verifyInOrder([
      () => passwordChanger.isLoading,
      () => view.clearErrors(),
      () => view.notifyInvalidConfirmPassword("The passwords do not match"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submit valid credentials clears the errors ', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);
    when(() => passwordChanger.changePassword(any())).thenAnswer((_) => Future.value(null));
    await presenter.changePassword("", "", "");

    //when
    await presenter.changePassword("password", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => passwordChanger.isLoading,
      () => view.clearErrors(),
      () => view.notifyInvalidCurrentPassword("Please enter current password"),
      () => view.notifyInvalidNewPassword("Please enter new password"),
      () => view.notifyInvalidConfirmPassword("Please re-enter new password"),
      () => passwordChanger.isLoading,
      () => view.clearErrors(),
      () => view.disableFormInput(),
      () => view.showLoader(),
      () => passwordChanger.changePassword(any()),
      () => view.hideLoader(),
      () => view.goToSuccessScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('change password successful', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    when(() => passwordChanger.changePassword(any())).thenAnswer((_) => Future.value(null));
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);

    //when
    await presenter.changePassword("oldPassword", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => passwordChanger.isLoading,
      () => view.clearErrors(),
      () => view.disableFormInput(),
      () => view.showLoader(),
      () => passwordChanger.changePassword(any()),
      () => view.hideLoader(),
      () => view.goToSuccessScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('change password failed', () async {
    //given
    when(() => passwordChanger.isLoading).thenReturn(false);
    when(() => passwordChanger.changePassword(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);

    //when
    await presenter.changePassword("oldPassword", "newPassword", "newPassword");

    //then
    verifyInOrder([
      () => passwordChanger.isLoading,
      () => view.clearErrors(),
      () => view.disableFormInput(),
      () => view.showLoader(),
      () => passwordChanger.changePassword(any()),
      () => view.enableFormInput(),
      () => view.hideLoader(),
      () => view.onChangePasswordFailed("Failed to change password", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('get name and profile image of user successfully', () {
    var mockUser = MockUser();
    when(() => mockUser.fullName).thenReturn("some name");
    when(() => mockUser.profileImageUrl).thenReturn("www.someImageUrl.com");
    when(() => userProvider.getCurrentUser()).thenReturn(mockUser);
    ChangePasswordPresenter presenter = ChangePasswordPresenter.initWith(view, userProvider, passwordChanger);

    expect(presenter.getUserName(), "some name");
    expect(presenter.getProfileImage(), "www.someImageUrl.com");
    verifyInOrder([
      () => userProvider.getCurrentUser(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

class MockMainView extends Mock implements MainView {}

class MockCurrentUserProvider extends Mock implements CurrentUserProvider {}

class MockSelectedCompanyProvider extends Mock implements SelectedCompanyProvider {}

void main() {
  var view = MockMainView();
  var currentUserProvider = MockCurrentUserProvider();
  var selectedCompanyProvider = MockSelectedCompanyProvider();
  var presenter = MainPresenter.initWith(view, currentUserProvider, selectedCompanyProvider);

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(selectedCompanyProvider);
  }

  test('navigates to login screen if a user is not logged in', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    //when
    await presenter.showLandingScreen();

    //then
    verifyInOrder([
      () => currentUserProvider.isLoggedIn(),
      () => view.goToLoginScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('navigates to the company list screen when a user is logged in and no company is selected', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
    when(() => selectedCompanyProvider.isCompanySelected()).thenReturn(false);

    //when
    await presenter.showLandingScreen();

    //then
    verifyInOrder([
      () => currentUserProvider.isLoggedIn(),
      () => selectedCompanyProvider.isCompanySelected(),
      () => view.goToCompaniesListScreen()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('navigates to the dashboard screen when a user is logged in and a company is selected', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
    when(() => selectedCompanyProvider.isCompanySelected()).thenReturn(true);

    //when
    await presenter.showLandingScreen();

    //then
    verifyInOrder([
      () => currentUserProvider.isLoggedIn(),
      () => selectedCompanyProvider.isCompanySelected(),
      () => view.goToDashboardScreen()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

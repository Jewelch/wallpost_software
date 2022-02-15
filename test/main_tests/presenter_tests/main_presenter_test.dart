import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/services/repository_initializer.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/notifications/services/app_badge_updater.dart';

import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_current_user_provider.dart';

class MockMainView extends Mock implements MainView {}

class MockRepositoryInitializer extends Mock implements RepositoryInitializer {}

class MockAppBadgeUpdater extends Mock implements AppBadgeUpdater {}

void main() {
  var view = MockMainView();
  var repositoryInitializer = MockRepositoryInitializer();
  var currentUserProvider = MockCurrentUserProvider();
  var selectedCompanyProvider = MockCompanyProvider();
  var appBadgeUpdater = MockAppBadgeUpdater();
  var presenter = MainPresenter.initWith(
    view,
    repositoryInitializer,
    currentUserProvider,
    selectedCompanyProvider,
    appBadgeUpdater,
  );

  setUpAll(() {
    when(() => repositoryInitializer.initializeRepos()).thenAnswer((invocation) => Future.value(null));
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(repositoryInitializer);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(selectedCompanyProvider);
    verifyNoMoreInteractions(appBadgeUpdater);
  }

  test('navigates to login screen if a user is not logged in', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    //when
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repositoryInitializer.initializeRepos(),
      () => appBadgeUpdater.updateBadgeCount(),
      () => currentUserProvider.isLoggedIn(),
      () => view.setStatusBarColor(false),
      () => view.goToLoginScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('navigates to the company list screen when a user is logged in and no company is selected', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
    when(() => selectedCompanyProvider.isCompanySelected()).thenReturn(false);

    //when
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repositoryInitializer.initializeRepos(),
      () => appBadgeUpdater.updateBadgeCount(),
      () => currentUserProvider.isLoggedIn(),
      () => view.setStatusBarColor(true),
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
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repositoryInitializer.initializeRepos(),
      () => appBadgeUpdater.updateBadgeCount(),
      () => currentUserProvider.isLoggedIn(),
      () => view.setStatusBarColor(true),
      () => selectedCompanyProvider.isCompanySelected(),
      () => view.goToDashboardScreen()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

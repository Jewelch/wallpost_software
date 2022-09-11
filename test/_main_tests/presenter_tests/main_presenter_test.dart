import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/services/repository_initializer.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/_main/ui/view_contracts/main_view.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_notification_center.dart';

class MockMainView extends Mock implements MainView {}

class MockRepositoryInitializer extends Mock implements RepositoryInitializer {}

void main() {
  late MockMainView view;
  late MockCurrentUserProvider currentUserProvider;
  late MockRepositoryInitializer repoInitializer;
  late MockNotificationCenter notificationCenter;
  late MainPresenter presenter;

  setUp(() {
    view = MockMainView();
    currentUserProvider = MockCurrentUserProvider();
    repoInitializer = MockRepositoryInitializer();
    notificationCenter = MockNotificationCenter();
    presenter = MainPresenter.initWith(view, currentUserProvider, repoInitializer, notificationCenter);

    when(() => repoInitializer.initializeRepos()).thenAnswer((invocation) => Future.value(null));
    when(() => notificationCenter.setupAndHandlePushNotifications()).thenAnswer((_) => Future.value(null));
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(repoInitializer);
    verifyNoMoreInteractions(notificationCenter);
  }

  test('processes launch tasks and navigates to login screen if a user is not logged in', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);
    when(() => notificationCenter.setupAndHandlePushNotifications()).thenAnswer((_) => Future.value(null));
    when(() => notificationCenter.updateCount()).thenAnswer((_) => Future.value(null));

    //when
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repoInitializer.initializeRepos(),
      () => currentUserProvider.isLoggedIn(),
      () => view.goToLoginScreen(),
      () => notificationCenter.setupAndHandlePushNotifications(),
      () => notificationCenter.updateCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('processes launch tasks and navigates to the company list screen when a user is logged in', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);
    when(() => notificationCenter.setupAndHandlePushNotifications()).thenAnswer((_) => Future.value(null));
    when(() => notificationCenter.updateCount()).thenAnswer((_) => Future.value(null));

    //when
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repoInitializer.initializeRepos(),
      () => currentUserProvider.isLoggedIn(),
      () => view.goToCompanyListScreen(),
      () => notificationCenter.setupAndHandlePushNotifications(),
      () => notificationCenter.updateCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('updating badge count', () async {
    //when
    when(() => notificationCenter.updateCount()).thenAnswer((_) => Future.value(null));
    presenter.updateBadgeCount();

    //then
    verifyInOrder([
      () => notificationCenter.updateCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

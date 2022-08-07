import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/services/repository_initializer.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/notifications/services/app_badge_updater.dart';
import 'package:wallpost/notifications_core/services/notification_center.dart';

import '../../_mocks/mock_current_user_provider.dart';

class MockMainView extends Mock implements MainView {}

class MockRepositoryInitializer extends Mock implements RepositoryInitializer {}

class MockNotificationCenter extends Mock implements NotificationCenter {}

class MockAppBadgeUpdater extends Mock implements AppBadgeUpdater {}

void main() {
  late MockMainView view;
  late MockCurrentUserProvider currentUserProvider;
  late MockRepositoryInitializer repoInitializer;
  late MockNotificationCenter notificationCenter;
  late MockAppBadgeUpdater badgeUpdater;
  late MainPresenter presenter;

  setUp(() {
    view = MockMainView();
    currentUserProvider = MockCurrentUserProvider();
    repoInitializer = MockRepositoryInitializer();
    notificationCenter = MockNotificationCenter();
    badgeUpdater = MockAppBadgeUpdater();
    presenter = MainPresenter.initWith(view, currentUserProvider, repoInitializer, notificationCenter, badgeUpdater);

    when(() => repoInitializer.initializeRepos()).thenAnswer((invocation) => Future.value(null));
    when(() => notificationCenter.setupAndHandlePushNotifications()).thenAnswer((_) => Future.value(null));
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(repoInitializer);
    verifyNoMoreInteractions(notificationCenter);
    verifyNoMoreInteractions(badgeUpdater);
  }

  test('processes launch tasks and navigates to login screen if a user is not logged in', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(false);

    //when
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repoInitializer.initializeRepos(),
      () => notificationCenter.setupAndHandlePushNotifications(),
      () => badgeUpdater.updateBadgeCount(),
      () => currentUserProvider.isLoggedIn(),
      () => view.setStatusBarColor(false),
      () => view.goToLoginScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('processes launch tasks and navigates to the company list screen when a user is logged in', () async {
    //given
    when(() => currentUserProvider.isLoggedIn()).thenReturn(true);

    //when
    await presenter.processLaunchTasksAndShowLandingScreen();

    //then
    verifyInOrder([
      () => repoInitializer.initializeRepos(),
      () => notificationCenter.setupAndHandlePushNotifications(),
      () => badgeUpdater.updateBadgeCount(),
      () => currentUserProvider.isLoggedIn(),
      () => view.setStatusBarColor(true),
      () => view.goToCompanyListScreen(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('updating badge count', () async {
    //when
    presenter.updateBadgeCount();

    //then
    verifyInOrder([
      () => badgeUpdater.updateBadgeCount(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

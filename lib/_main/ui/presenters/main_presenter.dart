import 'dart:core';

import 'package:wallpost/_main/services/repository_initializer.dart';
import 'package:wallpost/_main/ui/view_contracts/main_view.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/services/app_badge_updater.dart';
import 'package:wallpost/notifications_core/services/notification_center.dart';

class MainPresenter {
  final MainView _view;
  final CurrentUserProvider _currentUserProvider;
  final RepositoryInitializer _repositoryInitializer;
  final AppBadgeUpdater _appBadgeUpdater;
  final NotificationCenter _notificationCenter;

  MainPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _repositoryInitializer = RepositoryInitializer(),
        _notificationCenter = NotificationCenter.getInstance(),
        _appBadgeUpdater = AppBadgeUpdater();

  MainPresenter.initWith(
    this._view,
    this._currentUserProvider,
    this._repositoryInitializer,
    this._notificationCenter,
    this._appBadgeUpdater,
  );

  Future<void> processLaunchTasksAndShowLandingScreen({int delayBeforeSettingUpNotificationsAndAppBadge = 5}) async {
    //initializing repos
    await _repositoryInitializer.initializeRepos();

    //navigating based on login status
    var isLoggedIn = _currentUserProvider.isLoggedIn();
    isLoggedIn ? _view.goToCompanyListScreen() : _view.goToLoginScreen();

    //setup push notifications and update badge count
    await Future.delayed(Duration(seconds: delayBeforeSettingUpNotificationsAndAppBadge)).then((value) {
      _notificationCenter.setupAndHandlePushNotifications();
      updateBadgeCount();
    });
  }

  void updateBadgeCount() {
    _appBadgeUpdater.updateBadgeCount();
  }
}

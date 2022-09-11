import 'dart:core';

import 'package:wallpost/_main/services/repository_initializer.dart';
import 'package:wallpost/_main/ui/view_contracts/main_view.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

import '../../../notification_center/notification_center.dart';

class MainPresenter {
  final MainView _view;
  final CurrentUserProvider _currentUserProvider;
  final RepositoryInitializer _repositoryInitializer;
  final NotificationCenter _notificationCenter;

  MainPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _repositoryInitializer = RepositoryInitializer(),
        _notificationCenter = NotificationCenter.getInstance();

  MainPresenter.initWith(
    this._view,
    this._currentUserProvider,
    this._repositoryInitializer,
    this._notificationCenter,
  );

  Future<void> processLaunchTasksAndShowLandingScreen() async {
    //initializing repos
    await _repositoryInitializer.initializeRepos();

    //navigating based on login status
    var isLoggedIn = _currentUserProvider.isLoggedIn();
    isLoggedIn ? _view.goToCompanyListScreen() : _view.goToLoginScreen();

    //notifications setup
    _notificationCenter.setupAndHandlePushNotifications();
    updateBadgeCount();
  }

  Future<void> updateBadgeCount() async {
    await _notificationCenter.updateCount();
  }
}

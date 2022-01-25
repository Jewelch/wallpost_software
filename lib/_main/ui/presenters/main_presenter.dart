import 'dart:core';

import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/start_up/repository_initializer.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/services/selected_company_unread_notifications_count_provider.dart';

class MainPresenter {
  final MainView _view;
  final RepositoryInitializer _repositoryInitializer;
  final CurrentUserProvider _currentUserProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  SelectedCompanyUnreadNotificationsCountProvider _selectedCompanyUnreadNotificationsCountProvider = SelectedCompanyUnreadNotificationsCountProvider();

  MainPresenter(this._view)
      : _repositoryInitializer = RepositoryInitializer(),
        _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  MainPresenter.initWith(this._view,
      this._repositoryInitializer,
      this._currentUserProvider,
      this._selectedCompanyProvider,);

  Future<void> initializeReposAndShowLandingScreen() async {
    await _repositoryInitializer.initializeRepos();
    var isLoggedIn = _currentUserProvider.isLoggedIn();

    _view.setStatusBarColor(isLoggedIn);
    if (isLoggedIn == false) {
      _view.goToLoginScreen();
    } else {
      _showLandingScreenForLoggedInUser();
    }
  }

  void _showLandingScreenForLoggedInUser() {
    if ((_selectedCompanyProvider.isCompanySelected() == true)) {
      initAppCountBadgeState();
    } else {
      _view.goToCompaniesListScreen();
    }
  }

  initAppCountBadgeState() async {
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        _getSelectedCompanyUnreadNotificationsCount();
      } else {
        _view.goToDashboardScreen();
      }
    } on PlatformException {
      _view.goToDashboardScreen();
    }
  }

  void _getSelectedCompanyUnreadNotificationsCount() async {
    try {
      var unreadNotificationsCount = await _selectedCompanyUnreadNotificationsCountProvider
          .getCount();
      num _selectedCompanyUnreadNotificationsCount = unreadNotificationsCount
          .totalUnreadNotifications;
      if (_selectedCompanyUnreadNotificationsCount > 0) {
        _addBadge(_selectedCompanyUnreadNotificationsCount.toInt());
      }
      else {
        _removeBadge();
      }
      _view.goToDashboardScreen();
    } on WPException catch (_) {
      _view.goToDashboardScreen();
    }
  }



  void _addBadge(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }

}
/*
  //   TODO: when app opens
//    1. reload companies
//    cases
//        a. nothing has changed, do nothing - can be found comparing old list with new
//
//        else
//        b. companies added or removed or replaced -
//            i. store the new data
//            ii. check if the currently selected company has been removed - if yes- launch company selection screen and show alert
//                'Looks like you do not have access to this company any more. Please select another company from the list.'
 */

import 'dart:core';

import 'package:wallpost/_main/services/repository_initializer.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_list/services/selected_company_provider.dart';
import 'package:wallpost/notifications/services/app_badge_updater.dart';

class MainPresenter {
  final MainView _view;
  final RepositoryInitializer _repositoryInitializer;
  final CurrentUserProvider _currentUserProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final AppBadgeUpdater _appBadgeUpdater;

  MainPresenter(this._view)
      : _repositoryInitializer = RepositoryInitializer(),
        _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
  _appBadgeUpdater = AppBadgeUpdater();

  MainPresenter.initWith(
    this._view,
    this._repositoryInitializer,
    this._currentUserProvider,
    this._selectedCompanyProvider,
    this._appBadgeUpdater,
  );

  Future<void> initializeReposAndShowLandingScreen() async {
    await _repositoryInitializer.initializeRepos();
    _appBadgeUpdater.updateBadgeCount();
    var isLoggedIn = _currentUserProvider.isLoggedIn();
    _view.setStatusBarColor(isLoggedIn);
    if (isLoggedIn == false) {
      _view.goToLoginScreen();
    } else {
      _showLandingScreenForLoggedInUser();
    }
  }

  void _showLandingScreenForLoggedInUser() {
    if (_selectedCompanyProvider.isCompanySelected()) {
      _view.goToDashboardScreen();
    } else {
      _view.goToCompaniesListScreen();
    }
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

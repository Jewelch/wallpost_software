import 'dart:core';

import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

class MainPresenter {
  final MainView _view;
  final CurrentUserProvider _currentUserProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  MainPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  MainPresenter.initWith(this._view, this._currentUserProvider, this._selectedCompanyProvider);

  Future<void> showLandingScreen() async {
    if (isLoggedIn() == false) {
      _view.goToLoginScreen();
    } else {
      _showLandingScreenForLoggedInUser();
    }
  }

  void _showLandingScreenForLoggedInUser() {
    if (_selectedCompanyProvider.isCompanySelected() == false) {
      _view.goToCompaniesListScreen();
    } else {
      _view.goToDashboardScreen();
    }
  }

  bool isLoggedIn() {
    return _currentUserProvider.isLoggedIn();
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

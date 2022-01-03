import 'dart:core';

import 'package:wallpost/_main/contracts/main_view.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';
import 'package:wallpost/password_management/services/password_resetter.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';

class MainPresenter {
  final MainView _view;
  final CurrentUserProvider _currentUserProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  MainPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  MainPresenter.initWith(
      this._view, this._currentUserProvider, this._selectedCompanyProvider);

  Future<void> showLandingScreen() async {
    var _ = await Future.delayed(Duration(milliseconds: 1000));

    if (isLoggedIn() == false) {
      _view.showLoginScreen();
    } else {
      _showLandingScreenForLoggedInUser();
    }
  }

  void _showLandingScreenForLoggedInUser() {
    var selectedCompany =
        _selectedCompanyProvider.getSelectedCompanyForCurrentUser();

    if (selectedCompany == null) {
      _view.goToCompaniesListScreen();
    } else {
      _view.goToDashboardScreen();
    }

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
  }

  bool isLoggedIn() {
    return _currentUserProvider.isLoggedIn();
  }
}

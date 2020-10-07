import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    StatusBarColorSetter.setColorToAppColor();
    _showLandingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.defaultColor,
      ),
    );
  }

  _showLandingScreen() async {
    var _ = await Future.delayed(Duration(milliseconds: 1000));

    StatusBarColorSetter.setColorBasedOnLoginStatus();
    if (_isLoggedIn() == false) {
      _showLoginScreen();
    } else {
      _showLandingScreenForLoggedInUser();
    }
  }

  bool _isLoggedIn() {
    return CurrentUserProvider().getCurrentUser() != null;
  }

  void _showLoginScreen() async {
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (_) => false);
  }

  void _showLandingScreenForLoggedInUser() {
    var selectedCompany = SelectedCompanyProvider().getSelectedCompanyForCurrentUser();

    if (selectedCompany == null) {
      _showScreenAndClearStack(RouteNames.companiesList);
    } else {
      _showScreenAndClearStack(RouteNames.dashboard);
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

  void _showScreenAndClearStack(String route, {Object arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false, arguments: arguments);
  }
}

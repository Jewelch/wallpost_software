import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_main/contracts/main_view.dart';
import 'package:wallpost/_main/presenters/main_presenter.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/login/ui/views/login_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements MainView {
  late MainPresenter presenter;

  @override
  void initState() {
    presenter = MainPresenter(this);
    StatusBarColorSetter.setColorToAppColor();
    presenter.showLandingScreen();
    StatusBarColorSetter.setColorBasedOnLoginStatus(presenter.isLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.defaultColor,
      ),
    );
  }

  @override
  void showLoginScreen() {
    ScreenPresenter.present(LoginScreen(), context);
  }

  @override
  void goToCompaniesListScreen() {
    // navigate  to companiesList
    log("navigated to companieslist");

  }

  @override
  void goToDashboardScreen() {
    // navigate to dashboard
    log("navigated to dahsboard");
  }




}

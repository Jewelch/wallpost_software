import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_list/ui/companies_list_screen.dart';
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
    StatusBarColorSetter.setColorBasedOnLoginStatus(presenter.isLoggedIn());
    presenter.showLandingScreen();
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

  //MARK: View functions

  @override
  void goToLoginScreen() {
    //waiting for build to complete
    Future.microtask(() {
      ScreenPresenter.present(LoginScreen(), context);
    });
  }

  @override
  void goToCompaniesListScreen() {
    //waiting for build to complete
    Future.microtask(() {
      ScreenPresenter.present(CompanyListScreen(), context);
    });
  }

  @override
  void goToDashboardScreen() {
    //waiting for build to complete
    Future.microtask(() {
      log("navigated to dashboard");
    });
  }
}

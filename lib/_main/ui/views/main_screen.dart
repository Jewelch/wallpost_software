import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_main/ui/contracts/main_view.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_list/views/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';
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
    presenter.processLaunchTasksAndShowLandingScreen();
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
  void setStatusBarColor(bool isLoggedIn) {
    StatusBarColorSetter.setColorBasedOnLoginStatus(isLoggedIn);
  }

  @override
  void goToLoginScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(LoginScreen(), context);
  }

  @override
  void goToCompaniesListScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(CompanyListScreen(), context);
  }

  @override
  void goToDashboardScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(DashboardScreen(), context);
  }
}

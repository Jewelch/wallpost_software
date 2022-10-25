import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_main/ui/presenters/main_presenter.dart';
import 'package:wallpost/_main/ui/view_contracts/main_view.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/login/ui/views/login_screen.dart';

import '../../../restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver implements MainView {
  late MainPresenter presenter;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        presenter.updateBadgeCount();
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    presenter = MainPresenter(this);
    presenter.processLaunchTasksAndShowLandingScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: AppColors.screenBackgroundColor),
    );
  }

  //MARK: View functions

  @override
  void goToLoginScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(LoginScreen(), context);
  }

  @override
  void goToCompanyListScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(RestaurantDashboardScreen(), context);
  }
}

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';

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
    var _ = await Future.delayed(Duration(milliseconds: 2000));

    StatusBarColorSetter.setColorBasedOnLoginStatus();
    if (await _isLoggedIn() == false) {
      _showLoginScreen();
    } else {
      var currentUser = await CurrentUserProvider().getCurrentUser();
      _showLandingScreenForUser(currentUser);
    }
  }

  Future<bool> _isLoggedIn() async {
    return await CurrentUserProvider().getCurrentUser() != null;
  }

  void _showLoginScreen() async {
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (_) => false);
  }

  void _showLandingScreenForUser(User user) {
    //TODO: Show landing screens
  }

  void _showScreenAndClearStack(String route, {Object arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false, arguments: arguments);
  }
}

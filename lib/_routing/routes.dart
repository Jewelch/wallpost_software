import 'package:flutter/material.dart';
import 'package:wallpost/_main/main_screen.dart';
import 'package:wallpost/_main/splash_screen.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/authentication/ui/login_screen.dart';
import 'package:wallpost/password_management/ui/change_password_screen.dart';
import 'package:wallpost/password_management/ui/forgot_password_screen.dart';

class Routes {
  Map<String, WidgetBuilder> buildRoutes(BuildContext context) {
    return <String, WidgetBuilder>{
      //Main
      RouteNames.main: (context) => MainScreen(),

      //Splash
      RouteNames.splash: (context) => SplashScreen(),

      //Authentication
      RouteNames.login: (BuildContext context) => LoginScreen(),

      //Password management
      RouteNames.forgotPassword: (BuildContext context) =>
          ForgotPasswordScreen(),
      RouteNames.changePassword: (BuildContext context) =>
          ChangePasswordScreen(),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:wallpost/_main/main_screen.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/authentication/ui/login_screen.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';
import 'package:wallpost/company_management/ui/companies_list_screen.dart';
import 'package:wallpost/password_management/ui/forgot_password_screen.dart';

class Routes {
  Map<String, WidgetBuilder> buildRoutes(BuildContext context) {
    return <String, WidgetBuilder>{
      //Main
      RouteNames.main: (context) => MainScreen(),

      //Authentication
      RouteNames.login: (BuildContext context) => LoginScreen(),

      //Password management
      RouteNames.forgotPassword: (BuildContext context) => ForgotPasswordScreen(),

      //Companies list
      RouteNames.companiesList: (BuildContext context) => CompaniesListScreen(),

      //Companies list
      RouteNames.dashboard: (BuildContext context) => DashboardScreen(),
    };
  }
}

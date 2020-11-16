import 'package:flutter/material.dart';
import 'package:wallpost/_main/main_screen.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/authentication/ui/login_screen.dart';
import 'package:wallpost/company_management/ui/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';
import 'package:wallpost/password_management/ui/change_password_screen.dart';
import 'package:wallpost/password_management/ui/forgot_password_screen.dart';
import 'package:wallpost/password_management/ui/forgot_password_success_screen.dart';
import 'package:wallpost/requests/ui/task_details_screen.dart';
import 'package:wallpost/requests/ui/task_filter_screen.dart';
import 'package:wallpost/requests/ui/task_screen.dart';
import 'package:wallpost/settings/ui/settings_screen.dart';

class Routes {
  Map<String, WidgetBuilder> buildRoutes(BuildContext context) {
    return <String, WidgetBuilder>{
      //Main
      RouteNames.main: (context) => MainScreen(),

      //Authentication
      RouteNames.login: (BuildContext context) => LoginScreen(),

      //Companies list
      RouteNames.companiesList: (BuildContext context) => CompaniesListScreen(),

      //Dashboard
      RouteNames.dashboard: (BuildContext context) => DashboardScreen(),

      //Settings
      RouteNames.settings: (BuildContext context) => SettingsScreen(),

      //task
      RouteNames.task: (BuildContext context) => TaskScreen(),

      //task filter
      RouteNames.taskFilter: (BuildContext context) => TaskFilterScreen(),

      //task Details
      RouteNames.taskDetails: (BuildContext context) => TaskDetailsScreen(),

      //Password management
      RouteNames.forgotPassword: (BuildContext context) =>
          ForgotPasswordScreen(),

      RouteNames.changePassword: (BuildContext context) =>
          ChangePasswordScreen(),

      RouteNames.forgotPasswordSuccess: (BuildContext context) =>
          ForgotPasswordSuccessScreen(),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:wallpost/_main/main_screen.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/company_list//ui/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';
import 'package:wallpost/leave/ui/views/create_leave/create_leave_screen.dart';
import 'package:wallpost/leave/ui/views/leave_list_details/leave_list_deatils_screen.dart';
import 'package:wallpost/leave/ui/views/leave_list/leave_list_screen.dart';
import 'package:wallpost/login/ui/login_screen.dart';
import 'package:wallpost/password_management/ui/change_password_screen.dart';
import 'package:wallpost/password_management/ui/forgot_password_screen.dart';
import 'package:wallpost/password_management/ui/forgot_password_success_screen.dart';
import 'package:wallpost/settings/ui/settings_screen.dart';
import 'package:wallpost/task/ui/views/new_task/new_task_screen.dart';
import 'package:wallpost/task/ui/views/task_details/task_details_screen.dart';
import 'package:wallpost/task/ui/views/task_list/list/task_list_screen.dart';

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
      RouteNames.task: (BuildContext context) => TaskListScreen(),

      //task Details
      RouteNames.taskDetails: (BuildContext context) => TaskDetailsScreen(),

      //Password management
      RouteNames.forgotPassword: (BuildContext context) =>
          ForgotPasswordScreen(),

      RouteNames.changePassword: (BuildContext context) =>
          ChangePasswordScreen(),

      RouteNames.forgotPasswordSuccess: (BuildContext context) =>
          ForgotPasswordSuccessScreen(),

      //leave
      RouteNames.leaveList: (BuildContext context) => LeaveListScreen(),

      //leave list details
      RouteNames.leaveListdetails: (BuildContext context) =>
          LeaveListDetailsScreen(),

      //Create Leave
      RouteNames.createLeaveScreen: (BuildContext context) =>
          CreateLeaveScreen(),

      //create Task Screen
      RouteNames.createTaskScreen: (BuildContext context) => CreateTaskScreen()
    };
  }
}

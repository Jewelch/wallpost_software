import 'package:flutter/material.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';
import 'package:wallpost/company_list/services/user_companies_remover.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';

class LogoutHandler {
  final CurrentUserProvider _currentUserProvider;
  final UserRemover _userRemover;
  final UserCompaniesRemover _userCompaniesRemover;

  LogoutHandler()
      : this._currentUserProvider = CurrentUserProvider(),
        this._userRemover = UserRemover(),
        this._userCompaniesRemover = UserCompaniesRemover();

  LogoutHandler.initWith(this._currentUserProvider, this._userRemover, this._userCompaniesRemover);

  void logout(BuildContext? context) async {
    var user = _currentUserProvider.getCurrentUser();
    _userRemover.removeUser(user);
    _userCompaniesRemover.removeCompaniesForUser(user);
    _goToMainScreenAndClearStack(context);
  }

  void _goToMainScreenAndClearStack(BuildContext? context) {
    if (context != null)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false,
      );
  }
}

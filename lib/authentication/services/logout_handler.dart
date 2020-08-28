import 'package:flutter/material.dart';
import 'package:wallpost/_main/main_screen.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/_shared/user_management/services/user_remover.dart';
import 'package:wallpost/company_management/services/company_remover.dart';

class LogoutHandler {
  final CurrentUserProvider _currentUserProvider;
  final UserRemover _userRemover;
  final CompanyRemover _companyRemover;

  LogoutHandler()
      : this._currentUserProvider = CurrentUserProvider(),
        this._userRemover = UserRemover(),
        this._companyRemover = CompanyRemover();

  LogoutHandler.initWith(this._currentUserProvider, this._userRemover, this._companyRemover);

  void logout(BuildContext context) async {
    var user = _currentUserProvider.getCurrentUser();
    _userRemover.removeUser(user);
    _companyRemover.removeCompaniesForUser(user);

    if (context != null) Navigator.of(context).push(_createMainScreenRoute());
  }

  Route _createMainScreenRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
      settings: RouteSettings(name: RouteNames.main),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

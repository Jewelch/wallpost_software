import 'package:flutter/cupertino.dart';
import 'package:wallpost/_main/main_screen.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/_shared/user_management/services/user_remover.dart';

class LogoutHandler {
  static void logout(BuildContext context) async {
    var user = await CurrentUserProvider().getCurrentUser();
    var userRemover = UserRemover();
    userRemover.removeUser(user);

    Navigator.of(context).push(_createRoute());
  }

  static Route _createRoute() {
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

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';
import 'package:wallpost/_wp_core/start_up/repository_initializer.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

void main() => runApp(WallPostApp());

class WallPostApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  _WallPostAppState createState() => _WallPostAppState();
}

class _WallPostAppState extends State<WallPostApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    RepositoryInitializer.initializeRepos();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(fontFamily: 'PTSans'),
    );
  }

  @override
  initState() {
    //waiting for build to complete
    Future.microtask(() {
      setStatusBarColor();
    });
    super.initState();
  }

  void setStatusBarColor() {
    var isLoggedIn = CurrentUserProvider().isLoggedIn();
    StatusBarColorSetter.setColorBasedOnLoginStatus(isLoggedIn);
  }
}

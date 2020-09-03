import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_routing/routes.dart';
import 'package:wallpost/_shared/start_up/repository_initializer.dart';

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
      initialRoute: RouteNames.login,
      routes: Routes().buildRoutes(context),
      theme: ThemeData(fontFamily: 'PTSans'),
    );
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    StatusBarColorSetter.setColorBasedOnLoginStatus();
    super.didChangeAppLifecycleState(state);
  }
}

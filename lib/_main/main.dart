import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_routing/routes.dart';
import 'package:wallpost/_shared/constants/string_constants.dart';

void main() => runApp(WallPostApp());

class WallPostApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  _WallPostAppState createState() => _WallPostAppState();
}

class _WallPostAppState extends State<WallPostApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConstants.shovestClub,
      initialRoute: RouteNames.main,
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

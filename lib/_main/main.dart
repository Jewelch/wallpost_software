import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';

import '../_common_widgets/status_bar_color/status_bar_color_setter.dart';

//this navigator key is used for routing when context is not available
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  //initialize firebase
  await Firebase.initializeApp();

  //run the app
  runApp(WallPostApp());
}

class WallPostApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  _WallPostAppState createState() => _WallPostAppState();
}

class _WallPostAppState extends State<WallPostApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),
    );
  }

  @override
  initState() {
    //waiting for build to complete
    Future.microtask(() => setStatusBarColor());
    super.initState();
  }

  void setStatusBarColor() {
    StatusBarColorSetter().setColorToWhite();
  }
}

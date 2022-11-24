import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';

import 'notification_center/notification_center.dart';
import 'notification_router/notification_screen_router.dart';

//this navigator key is used for routing when context is not available
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//this key is used for showing snack bar when scaffold is not available
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  //setting this to false to avoid automatic ui adjustments for
  //status bar and bottom nav bar
  binding.renderView.automaticSystemUiAdjustment = false;

  DartPluginRegistrant.ensureInitialized();

  //initialize firebase
  await NotificationCenter.initialize(NotificationScreenRouter());

  //run the app
  runApp(WallPostApp());
}

class WallPostApp extends StatefulWidget {
  @override
  _WallPostAppState createState() => _WallPostAppState();
}

class _WallPostAppState extends State<WallPostApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: snackbarKey,
      home: MainScreen(),
      theme: ThemeData(fontFamily: 'SF-Pro-Display'),
      themeMode: ThemeMode.light,
    );
  }

  @override
  initState() {
    //waiting for build to complete
    Future.microtask(() {
      _setStatusAndSystemNavigationBarColor();
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _setStatusAndSystemNavigationBarColor();
  }

  void _setStatusAndSystemNavigationBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

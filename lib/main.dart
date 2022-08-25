import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';

import '_common_widgets/status_bar_color/status_bar_color_setter.dart';

//this navigator key is used for routing when context is not available
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;

  DartPluginRegistrant.ensureInitialized();

  //initialize firebase
  await Firebase.initializeApp();

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
      home: MainScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),
    );
  }

  @override
  initState() {
    //waiting for build to complete
    Future.microtask(() {
      setStatusBarColor();
      setSystemNavigationBarColor();
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void setStatusBarColor() {
    StatusBarColorSetter().setColorToWhite();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) StatusBarColorSetter().setColorToWhite();
  }

  void setSystemNavigationBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';
import 'package:wallpost/notifications/services/app_badge_updater.dart';

void main() => runApp(WallPostApp());

class WallPostApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  _WallPostAppState createState() => _WallPostAppState();
}

class _WallPostAppState extends State<WallPostApp> with WidgetsBindingObserver {
  final AppBadgeUpdater _appBadgeUpdater;

  _WallPostAppState() : this._appBadgeUpdater = AppBadgeUpdater();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _appBadgeUpdater.updateBadgeCount();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(fontFamily: 'PTSans'),
    );
  }
}

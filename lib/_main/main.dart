import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
// import 'package:wallpost/notifications/services/selected_company_unread_notifications_count_provider.dart';

void main() => runApp(WallPostApp());

class WallPostApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  _WallPostAppState createState() => _WallPostAppState();
}

class _WallPostAppState extends State<WallPostApp> with WidgetsBindingObserver {

  @override
  initState() {
    super.initState();
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

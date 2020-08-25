import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(RouteNames.login);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/logo.png',
            width: 180.0,
            height: 180.0,
          ),
        ),
      ),
    );
  }
}

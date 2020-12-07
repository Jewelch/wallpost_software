import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Requests Screen'),
              FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () {
                  LogoutHandler().logout(context);
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text('Go To Tasks'),
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.task);
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text('Go To Leave'),
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.leave);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

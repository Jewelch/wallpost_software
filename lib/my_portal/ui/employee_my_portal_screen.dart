import 'package:flutter/material.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';

class EmployeeMyPortalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Employee Dashboard With Personal Performance and Attendance'),
              FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () {
                  LogoutHandler().logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

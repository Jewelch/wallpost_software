import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/attendance_adjustment/ui/views/attendance_list_screen.dart';
import 'package:wallpost/password_management/ui/views/change_password_screen.dart';

class MyPortalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('My Portal Screen'),
              FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () {
                  LogoutHandler().logout(context);
                },
              ),
              FlatButton(
                color: Colors.blueAccent,
                child: Text('Change password'),
                onPressed: () {
                  ScreenPresenter.present(ChangePasswordScreen(), context);
                },
              ),
              FlatButton(
                color: Colors.greenAccent,
                child: Text('Adjust Attendance'),
                onPressed: () {
                  ScreenPresenter.present(AttendanceListScreen(), context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

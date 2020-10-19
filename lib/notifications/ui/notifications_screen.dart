import 'package:flutter/material.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Notifications Screen'),
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


//1. unread notification count api for total and module wise notification count
//    2. module wise notification list api
//3. mark all notifications as read API

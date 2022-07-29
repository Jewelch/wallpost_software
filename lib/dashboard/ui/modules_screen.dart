import 'package:flutter/material.dart';
import 'package:wallpost/_main/services/logout_handler.dart';

class ModulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Modules Screen'),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
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

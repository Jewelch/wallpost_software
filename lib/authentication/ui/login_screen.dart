import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Login Screen'),
              FlatButton(
                color: Colors.red,
                child: Text('Reset Password'),
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.forgotPassword);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

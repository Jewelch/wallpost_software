import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: "Account Number"
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Username"
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Password"
            ),
          ),
        ],
      ),
    );
  }
}

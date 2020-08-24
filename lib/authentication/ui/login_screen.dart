import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';

class LoginScreen extends StatelessWidget {
   final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c9fd5),
      body: SingleChildScrollView(
          child: Form(
      //  key: _formKey,
        child: formUI(),
      )),
    );
  }

Widget formUI() {
}
  int doSomething() {
    var a = 123;
    var b = 123;
    var c = 123;
    var d = 123;
    var e = 123;

    var f = a + b + c + d + e;

    return f;
  }
}



import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/authentication/ui/textformfield.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c9fd5),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            logoIcon(),
            formUI(),
          ],
        )),
      ),
    );
  }

  Widget logoIcon() {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 70, 0, 50),
        child: Image.asset('assets/images/logo.png'),
        width: 120.0,
        height: 120.0,
      ),
    );
  }

  Widget formUI() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
          child: Column(
            key: _formKey,
        children: <Widget>[
          accountTextFormField(),
          SizedBox(
            height: 40,
          ),
          usernameTextFormField(),
          SizedBox(height: 40,),
          passwordTextFormField()
          ],
      )),
    );
  }

  Widget accountTextFormField() {
    return CustomTextField(
      hint: 'Account Number',
    );
  }
}

Widget usernameTextFormField(){
  return CustomTextField(
    hint: 'User Name',
  );
}

Widget passwordTextFormField(){
  return CustomTextField(
    hint: 'Password',
  );
}

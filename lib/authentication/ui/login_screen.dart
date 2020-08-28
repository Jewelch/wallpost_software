import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  double _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                AppColors.loginBackgroundGradiantColorOne,
                AppColors.loginBackgroundGradiantColorTwo
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            loginIcon(),
            formUI(),
            loginButton(),
            forgetPassword()
          ],
        )),
      ),
    );
  }

  Widget loginIcon() {
    return Center(
      child: Container(
        child: Image.asset('assets/images/logo.png'),
        width: 120.0,
        height: _height * 0.5,
      ),
    );
  }

  Widget formUI() {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              accountTextFormField(),
              SizedBox(
                height: _height * 0.03,
              ),
              usernameTextFormField(),
              SizedBox(
                height: _height * 0.03,
              ),
              passwordTextFormField(),
            ],
          )),
    );
  }

  Widget accountTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      textAlign: TextAlign.center,
      cursorColor: AppColors.defaultColor,
      decoration: InputDecoration(
        hintText: 'Account Number',
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none),
      ),
      validator: validateAccount,
    );
  }

  Widget usernameTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      textAlign: TextAlign.center,
      cursorColor: AppColors.defaultColor,
      decoration: InputDecoration(
        hintText: 'User Name',
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none),
      ),
      validator: validateUserName,
    );
  }

  Widget passwordTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      textAlign: TextAlign.center,
      cursorColor: AppColors.defaultColor,
      decoration: InputDecoration(
        hintText: 'Password',
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none),
      ),
      validator: validatePassword,
    );
  }

  String validateAccount(value) {
    if (value.isEmpty) {
      return 'Please enter valied Account number';
    } else {
      return null;
    }
  }

  String validateUserName(value) {
    if (value.isEmpty) {
      return 'Please enter valied UserName';
    } else {
      return null;
    }
  }

  String validatePassword(value) {
    if (value.isEmpty) {
      return 'Please enter your Password';
    } else {
      return null;
    }
  }

  Widget loginButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(2.0, 20.0, 2.0, 20.0),
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          child: Text(
            'Log In',
            style: TextStyle(color: AppColors.white),
          ),
          padding: EdgeInsets.all(15.0),
          color: AppColors.buttonColor,
          onPressed: gotoHome,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  void gotoHome() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {}
  }

  Widget forgetPassword() {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushReplacementNamed(RouteNames.forgotPassword);
      },
      child: Container(
        child: Text(
          'Forgot your Password?',
          style: TextStyle(
              color: AppColors.loginForgetPaasswordTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wallpost/authentication/ui/textformfield.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  
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
                AppColors.loginGradiantFirstColor,
                AppColors.loginGradiantSecoundColor
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),

        //  margin: EdgeInsets.all(10.0),
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
    return CustomTextField(
      hint: 'Account Number',
      inputType: TextInputType.number,
    );
  }

  Widget usernameTextFormField() {
    return CustomTextField(
      hint: 'User Name',
      inputType: TextInputType.text,
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      hint: 'Password',
      inputType: TextInputType.visiblePassword,
    );
  }

  Widget loginButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(2.0, 20.0, 2.0, 20.0),
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white),
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
  
  void gotoHome(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
    }else{

    }
  }
  Widget forgetPassword() {
    return Container(
      child: Text(
        'Forgot your Password?',
        style: TextStyle(
            color: Color(0xFF4bafe1),
            fontSize: 16.0,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}

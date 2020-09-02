import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar_with_back_button.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';
import 'package:wallpost/password_management/services/password_resetter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _accountNumber;
  String _email;
  Loader _loader;

  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBarWithBackButton(
          title: 'Forget Password',
          onBackButtonPress: null,
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin:
                  EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Account Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                        BorderSide(color: AppColors.defaultColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                        BorderSide(color: AppColors.defaultColor, width: 2),
                      ),
                    ),
                    validator: (value) =>
                    value.length < 1 ? 'Please enter account number' : null,
                    onSaved: (value) => _accountNumber = value,
                  ),
                ),
                Container(
                  margin:
                  EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                        BorderSide(color: AppColors.defaultColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                        BorderSide(color: AppColors.defaultColor, width: 2),
                      ),
                    ),
                    validator: (value) =>
                    !value.contains('@')
                        ? 'Please enter valid email'
                        : null,
                    onSaved: (value) => _email = value,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin:
                  EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: AppColors.defaultColor)),
                      color: AppColors.defaultColor,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      onPressed: _submit,
                      child: Text('Continue')),
                ),
              ],
            ),
          ),
        ));
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loader.show('Submitting..');
      var _passwordResetter = PasswordResetter();
      var resetPasswordForm = ResetPasswordForm(_accountNumber, _email);
      print(_accountNumber);
      try {
        var _ = await _passwordResetter.resetPassword(resetPasswordForm);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.forgotPasswordSuccess,
              (_) => false,
        );
      } on APIException catch (error) {
        _loader.hide();
        Alert.showSimpleAlert(
          context,
          title: 'Reset passwrod Failed',
          message: error.userReadableMessage,
          buttonTitle: 'Okay',
        );
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
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
    StatusBarColorSetter.setColorToWhite();
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Password Recovery',
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 60),
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white,
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginTextField(
                hint: 'Account Number',
                keyboardType: TextInputType.number,
                validator: (value) => value.length < 1 ? 'Please enter an account number' : null,
                onSaved: (value) => _accountNumber = value,
              ),
              SizedBox(height: 20),
              LoginTextField(
                hint: 'Email',
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value.length < 1 ? 'Please enter your email address' : null,
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: AppColors.defaultColor,
                  textColor: Colors.white,
                  onPressed: _submit,
                  child: Text('Continue'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColors.defaultColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loader.show('Resetting your password...');
      var _passwordResetter = PasswordResetter();
      var resetPasswordForm = ResetPasswordForm(_accountNumber, _email);
      try {
        var _ = await _passwordResetter.resetPassword(resetPasswordForm);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.forgotPasswordSuccess,
          (_) => false,
        );
      } on WPException catch (error) {
        _loader.hide();
        Alert.showSimpleAlert(
          context,
          title: 'Reset Password Failed',
          message: error.userReadableMessage,
          buttonTitle: 'Okay',
        );
      }
    }
  }
}

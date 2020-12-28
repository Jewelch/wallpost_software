import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_routing/route_names.dart';
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
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    StatusBarColorSetter.setColorToWhite();
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Password Recovery',
        leading: CircularBackButton(onPressed: () => Navigator.pop(context)),
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
              RoundedRectangleActionButton(
                title: 'Reset Password',
                borderColor: Colors.grey.withOpacity(0.3),
                onPressed: () {
                  setState(() {
                    _submit();
                  });
                },
                showLoader: _isLoading,
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
      setState(() => _isLoading = true);

      var resetPasswordForm = ResetPasswordForm(_accountNumber, _email);
      try {
        var _ = await PasswordResetter().resetPassword(resetPasswordForm);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.forgotPasswordSuccess,
          (_) => false,
        );
      } on WPException catch (error) {
        setState(() => _isLoading = false);
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

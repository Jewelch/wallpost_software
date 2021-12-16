import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/entities/credentials.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _showLogo = true;
  var _accountNumberTextController = TextEditingController();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _isLoading = false;
  StreamSubscription<bool> _keyboardSubscription;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() => _showLogo = visible ? false : true);
    });
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    AppColors.getColorFromHex('#4bafe1'),
                    AppColors.getColorFromHex('#2771ba'),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                loginIcon(),
                Expanded(child: formUI()),
              ],
            ),
          ),
        ),
      ),
    );
  }

//TODO: Fix this- Obaid
  Widget loginIcon() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: double.infinity,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: _showLogo ? 40 : 0),
          height: _showLogo ? 120 : 0,
          width: 120,
          child: Image.asset('assets/logo/logo.png'),
        ),
      ),
    );
  }

  Widget formUI() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
//      padding: EdgeInsets.only(top: _showLogo ? 0 : 40),
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoginTextField(
                hint: 'Account Number',
                controller: _accountNumberTextController,
                validator: validateAccount,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 16),
              LoginTextField(
                hint: 'Username',
                controller: _usernameTextController,
                validator: validateUserName,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 16),
              LoginTextField(
                hint: 'Password',
                obscureText: true,
                controller: _passwordTextController,
                validator: validatePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _performLogin(),
              ),
              SizedBox(height: 16),
              loginButton(),
              SizedBox(height: 16),
              forgetPassword(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String validateAccount(value) {
    if (value.isEmpty) {
      return 'Please enter a valid account number';
    } else {
      return null;
    }
  }

  String validateUserName(value) {
    if (value.isEmpty) {
      return 'Please enter a valid username';
    } else {
      return null;
    }
  }

  String validatePassword(value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else {
      return null;
    }
  }

  Widget loginButton() {
    return RoundedRectangleActionButton(
      title: 'Login',
      borderColor: Colors.grey.withOpacity(0.3),
      onPressed: () {
        setState(() {
          _performLogin();
        });
      },
      showLoader: _isLoading,
    );
  }

  void _performLogin() async {
    if (_formKey.currentState.validate() == false) return;

    FocusScope.of(context).unfocus();

    var accountNumber = _accountNumberTextController.text;
    var username = _usernameTextController.text;
    var password = _passwordTextController.text;
    var credentials = Credentials(accountNumber, username, password);

    try {
      setState(() => _isLoading = true);
      var _ = await Authenticator().login(credentials);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.main,
        (_) => false,
        arguments: _passwordTextController.text,
      );
    } on WPException catch (error) {
      setState(() => _isLoading = false);
      Alert.showSimpleAlert(
        context,
        title: 'Login Failed',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
    }
  }

  Widget forgetPassword() {
    return RoundedRectangleActionButton(
      title: 'Forgot your password?',
      color: Colors.transparent,
      onPressed: () {
        setState(() {
          Navigator.of(context).pushNamed(RouteNames.forgotPassword);
        });
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/authentication/entities/credentials.dart';
import 'package:wallpost/authentication/services/authenticator.dart';

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
  Loader _loader;

  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          if (visible) {
            _showLogo = false;
          } else {
            _showLogo = true;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    AppColors.loginBackgroundGradiantColorOne,
                    AppColors.loginBackgroundGradiantColorTwo,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Flexible(child: loginIcon()),
                formUI(),
                loginButton(),
                forgetPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginIcon() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: _showLogo ? 300 : 0,
      child: Center(
        child: SizedBox(
          height: _showLogo ? 120 : 0,
          width: 120,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }

  Widget formUI() {
    return Container(
      padding: EdgeInsets.only(top: _showLogo ? 0 : 40),
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTextFormField(
                hint: 'Account Number',
                controller: _accountNumberTextController,
                validator: validateAccount,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 16),
              buildTextFormField(
                hint: 'Username',
                controller: _usernameTextController,
                validator: validateUserName,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 16),
              buildTextFormField(
                hint: 'Password',
                obscureText: true,
                controller: _passwordTextController,
                validator: validatePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _performLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField({
    String hint,
    bool obscureText = false,
    TextEditingController controller,
    FormFieldValidator validator,
    TextInputAction textInputAction,
    ValueChanged<String> onFieldSubmitted,
  }) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      textAlign: TextAlign.center,
      cursorColor: AppColors.defaultColor,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide.none),
      ),
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
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
          onPressed: _performLogin,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  void _performLogin() async {
    if (_formKey.currentState.validate() == false) return;

    FocusScope.of(context).unfocus();
    _loader.show('Logging In...');
    var authenticator = Authenticator();
    var accountNumber = _accountNumberTextController.text;
    var username = _usernameTextController.text;
    var password = _passwordTextController.text;
    var credentials = Credentials(accountNumber, username, password);

    try {
      _loader.hide();
      var _ = await authenticator.login(credentials);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.main,
        (_) => false,
        arguments: _passwordTextController.text,
      );
    } on APIException catch (error) {
      _loader.hide();
      Alert.showSimpleAlert(
        context,
        title: 'Login Failed',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
    }
  }

  Widget forgetPassword() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteNames.forgotPassword);
      },
      child: Container(
        child: Text(
          'Forgot your Password?',
          style: TextStyle(
            color: AppColors.loginForgetPaasswordTextColor,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

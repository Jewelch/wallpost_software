import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';
import 'package:wallpost/login/ui/presenters/login_presenter.dart';

class LoginScreen extends StatelessWidget implements LoginView {
  late LoginPresenter presenter;

  var _accountNumberErrorNotifier = ItemNotifier<String>();
  var _usernameErrorNotifier = ItemNotifier<String>();
  var _passwordErrorNotifier = ItemNotifier<String>();
  var _showLogoNotifier = ItemNotifier<bool>();
  var _showLoaderNotifier = ItemNotifier<bool>();

  TextEditingController _accountNumberTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  LoginScreen() {
    presenter = LoginPresenter(this);
    KeyboardVisibilityController().onChange.listen((visibility) =>
        presenter.onKeyboardVisibilityChange(visibility: visibility));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget loginIcon() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: double.infinity,
      child: Center(
        child: ItemNotifiable<bool>(
          notifier: _showLogoNotifier,
          builder: (context, value) => Container(
            margin: EdgeInsets.symmetric(vertical: (value ?? true) ? 40 : 0),
            height: (value ?? true) ? 120 : 0,
            width: 120,
            child: Image.asset('assets/logo/logo.png'),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return ItemNotifiable<bool>(
      notifier: _showLogoNotifier,
      builder: (context, value) => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: (value ?? true) ? 0 : 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ItemNotifiable<String>(
                notifier: _accountNumberErrorNotifier,
                builder: (context, value) => TextField(
                  controller: _accountNumberTextController,
                  decoration: InputDecoration(
                      hintText: "Account Number", errorText: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 16),
              ItemNotifiable<String>(
                notifier: _usernameErrorNotifier,
                builder: (context, value) => TextField(
                  controller: _usernameTextController,
                  decoration:
                      InputDecoration(hintText: "Username", errorText: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 16),
              ItemNotifiable<String>(
                notifier: _passwordErrorNotifier,
                builder: (context, value) => TextField(
                  controller: _passwordTextController,
                  decoration:
                      InputDecoration(hintText: "Password", errorText: value),
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                ),
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

  Widget loginButton() {
    return ItemNotifiable<bool>(
      notifier: _showLoaderNotifier,
      builder:(context,value)=> RoundedRectangleActionButton(
        title: 'Login',
        borderColor: Colors.grey.withOpacity(0.3),
        onPressed: () {
          presenter.login(_accountNumberTextController.text,
              _usernameTextController.text, _passwordTextController.text);
        },
        showLoader: value ?? false,
      ),
    );
  }

  Widget forgetPassword() {
    return RoundedRectangleActionButton(
      title: 'Forgot your password?',
      color: Colors.transparent,
      onPressed: () {
        // ScreenPresenter.present(, context)
      },
    );
  }

  //MARK: View functions

  @override
  void showLogoIcon() {
    _showLogoNotifier.notify(true);
  }

  @override
  void hideLogoIcon() {
    _showLogoNotifier.notify(false);
  }

  @override
  void showLoader() {
    _accountNumberErrorNotifier.notify(null);
    _usernameErrorNotifier.notify(null);
    _passwordErrorNotifier.notify(null);
    _showLoaderNotifier.notify(true);
  }

  @override
  void hideLoader() {
    _showLoaderNotifier.notify(false);
  }

  @override
  void notifyInvalidAccountNumber(String message) {
    _accountNumberErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidUsername(String message) {
    _usernameErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidPassword(String message) {
    _passwordErrorNotifier.notify(message);
  }

  @override
  void onLoginFailed(String title, String message) {
    Alert.showSimpleAlert(title: title,message: message);
  }

  @override
  void goToCompanyListScreen() {}
}

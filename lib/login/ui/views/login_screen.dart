import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/form_widgets/password_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_main/ui/views/main_screen.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';
import 'package:wallpost/login/ui/presenters/login_presenter.dart';
import 'package:wallpost/settings/password_management/ui/views/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginView {
  late LoginPresenter presenter;
  var _accountNumberErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _usernameErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _passwordErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _showLogoNotifier = ItemNotifier<bool>(defaultValue: true);
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);
  var _formInputInteractionNotifier = ItemNotifier<bool>(defaultValue: true);
  var _accountNumberTextController = TextEditingController();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  @override
  void initState() {
    presenter = LoginPresenter(this);
    KeyboardVisibilityController().onChange.listen((visibility) => _showLogoNotifier.notify(!visibility));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.screenBackgroundColor,
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                _logo(),
                SizedBox(height: 4),
                CurveBottomToTop(),
                Container(
                  margin: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      formUI(),
                      SizedBox(height: 16),
                      _loginButton(),
                      SizedBox(height: 4),
                      _forgotPasswordButton(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return ItemNotifiable<bool>(
      notifier: _showLogoNotifier,
      builder: (context, showLogo) => AnimatedContainer(
        duration: Duration(milliseconds: 100),
        margin: EdgeInsets.symmetric(vertical: showLogo ? 80 : 0),
        curve: Curves.easeInOut,
        width: double.infinity,
        child: Center(
          child: Container(
            height: showLogo ? 152 : 0,
            width: 152,
            child: Image.asset('assets/logo/wallpost_logo.png'),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return ItemNotifiable<bool>(
      notifier: _formInputInteractionNotifier,
      builder: (context, enableFormInput) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ItemNotifiable<String?>(
            notifier: _accountNumberErrorNotifier,
            builder: (context, value) => FormTextField(
              controller: _accountNumberTextController,
              hint: "Account Number",
              errorText: value,
              textInputAction: TextInputAction.next,
              isEnabled: enableFormInput,
            ),
          ),
          SizedBox(height: 16),
          ItemNotifiable<String?>(
            notifier: _usernameErrorNotifier,
            builder: (context, value) => FormTextField(
              controller: _usernameTextController,
              hint: "Username",
              errorText: value,
              textInputAction: TextInputAction.next,
              isEnabled: enableFormInput,
            ),
          ),
          SizedBox(height: 16),
          ItemNotifiable<String?>(
            notifier: _passwordErrorNotifier,
            builder: (context, value) => PasswordTextField(
              controller: _passwordTextController,
              hint: "Password",
              errorText: value,
              textInputAction: TextInputAction.done,
              obscureText: true,
              isEnabled: enableFormInput,
              onFieldSubmitted: (_) => _performLogin(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return ItemNotifiable<bool>(
      notifier: _showLoaderNotifier,
      builder: (context, showLoader) => RoundedRectangleActionButton(
        title: 'Login',
        borderColor: AppColors.defaultColor,
        onPressed: () => _performLogin(),
        showLoader: showLoader,
      ),
    );
  }

  void _performLogin() {
    presenter.login(
      _accountNumberTextController.text,
      _usernameTextController.text,
      _passwordTextController.text,
    );
  }

  Widget _forgotPasswordButton() {
    return ItemNotifiable<bool>(
      notifier: _formInputInteractionNotifier,
      builder: (context, enableInteraction) => RoundedRectangleActionButton(
        title: 'Forgot password?',
        textColor: Colors.black,
        disabledTextColor: Colors.black54,
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        disabled: !enableInteraction,
        alignment: MainAxisAlignment.end,
        onPressed: () {
          ScreenPresenter.present(ForgotPasswordScreen(), context);
        },
      ),
    );
  }

  @override
  void showLoader() {
    _showLoaderNotifier.notify(true);
  }

  @override
  void hideLoader() {
    _showLoaderNotifier.notify(false);
  }

  @override
  void enableFormInput() {
    _formInputInteractionNotifier.notify(true);
  }

  @override
  void disableFormInput() {
    _formInputInteractionNotifier.notify(false);
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
  void clearLoginErrors() {
    _accountNumberErrorNotifier.notify(null);
    _usernameErrorNotifier.notify(null);
    _passwordErrorNotifier.notify(null);
  }

  @override
  void onLoginFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void goToCompanyListScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(MainScreen(), context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/forgot_password_presenter.dart';
import 'package:wallpost/password_management/ui/views/forgot_password_success_screen.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> implements ForgotPasswordView {
  late ForgotPasswordPresenter presenter;
  var _showLogoNotifier = ItemNotifier<bool>(defaultValue: true);
  var _accountNumberErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _emailErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);
  var _formInputInteractionNotifier = ItemNotifier<bool>(defaultValue: true);
  var _accountNumberTextController = TextEditingController();
  var _emailTextController = TextEditingController();

  @override
  void initState() {
    presenter = ForgotPasswordPresenter(this);
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
                      _resetPasswordButton(),
                      SizedBox(height: 4),
                      _cancelButton(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Password Recovery', style: TextStyles.screenTitleTextStyle),
          SizedBox(height: 16),
          ItemNotifiable<String?>(
            notifier: _accountNumberErrorNotifier,
            builder: (context, value) => LoginTextField(
              controller: _accountNumberTextController,
              hint: "Account Number",
              errorText: value,
              textInputAction: TextInputAction.next,
              isEnabled: enableFormInput,
            ),
          ),
          SizedBox(height: 16),
          ItemNotifiable<String?>(
            notifier: _emailErrorNotifier,
            builder: (context, value) => LoginTextField(
              controller: _emailTextController,
              hint: "Email",
              errorText: value,
              textInputAction: TextInputAction.next,
              isEnabled: enableFormInput,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resetPasswordButton() {
    return ItemNotifiable<bool>(
      notifier: _showLoaderNotifier,
      builder: (context, showLoader) => RoundedRectangleActionButton(
        title: 'Reset Password',
        onPressed: () => _resetPassword(),
        showLoader: showLoader,
      ),
    );
  }

  void _resetPassword() {
    presenter.resetPassword(_accountNumberTextController.text, _emailTextController.text);
  }

  Widget _cancelButton() {
    return ItemNotifiable<bool>(
      notifier: _formInputInteractionNotifier,
      builder: (context, enableInteraction) => RoundedRectangleActionButton(
        title: 'Cancel',
        textColor: Colors.black,
        disabledTextColor: Colors.black54,
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        disabled: !enableInteraction,
        alignment: MainAxisAlignment.end,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _accountNumberErrorNotifier.notify(null);
    _emailErrorNotifier.notify(null);
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
  void clearErrors() {
    _accountNumberErrorNotifier.notify(null);
    _emailErrorNotifier.notify(null);
  }

  @override
  void notifyInvalidAccountNumber(String message) {
    _accountNumberErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidEmailFormat(String message) {
    _emailErrorNotifier.notify(message);
  }

  @override
  void goToSuccessScreen() {
    ScreenPresenter.present(ForgotPasswordSuccessScreen(), context);
  }

  @override
  void onResetPasswordFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }
}

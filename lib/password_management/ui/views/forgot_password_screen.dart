import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/forgot_password_presenter.dart';
import 'package:wallpost/password_management/ui/views/forgot_password_success_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> implements ForgotPasswordView {
  late ForgotPasswordPresenter presenter;
  var _showLogoNotifier = ItemNotifier<bool>();
  var _accountNumberErrorNotifier = ItemNotifier<String>();
  var _emailErrorNotifier = ItemNotifier<String>();
  var _showLoaderNotifier = ItemNotifier<bool>();
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
    StatusBarColorSetter.setColorToWhite();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 60),
          padding: EdgeInsets.symmetric(horizontal: 12),
          color: Colors.white,
          width: double.infinity,
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              ItemNotifiable<bool>(
                notifier: _showLogoNotifier,
                builder: (context, showLogo) => AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  margin: EdgeInsets.symmetric(vertical: (showLogo ?? true) ? 60 : 0),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      height: (showLogo ?? true) ? 140 : 0,
                      width: 140,
                      child: Image.asset('assets/logo/wallpost_logo.png'),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Password Recovery',
                          style: TextStyle(color: AppColors.defaultColorDark,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),)),
                    ItemNotifiable<String>(
                      notifier: _accountNumberErrorNotifier,
                      builder: (context, value) => LoginTextField(
                        controller: _accountNumberTextController,
                        hint: "Account Number",
                        errorText: value,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 16),
                    ItemNotifiable<String>(
                      notifier: _emailErrorNotifier,
                      builder: (context, value) => LoginTextField(
                        controller: _emailTextController,
                        hint: "Email",
                        errorText: value,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20),
                    ItemNotifiable<bool>(
                      notifier: _showLoaderNotifier,
                      builder: (context, value) => RoundedRectangleActionButton(
                        title: 'Continue',
                        borderColor: Colors.grey.withOpacity(0.3),
                        onPressed: () => _submit(),
                        showLoader: value ?? false,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    presenter.resetPassword(_accountNumberTextController.text, _emailTextController.text);
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

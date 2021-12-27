import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/status_bar_color/status_bar_color_setter.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/forgot_password_presenter.dart';
import 'package:wallpost/password_management/ui/views/forgot_password_success_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen>
    implements ForgotPasswordView {
  late ForgotPasswordPresenter presenter;
  var _accountNumberErrorNotifier = ItemNotifier<String>();
  var _emailErrorNotifier = ItemNotifier<String>();
  var _showLoaderNotifier = ItemNotifier<bool>();
  var _accountNumberTextController = TextEditingController();
  var _emailTextController = TextEditingController();

  @override
  void initState() {
    presenter = ForgotPasswordPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StatusBarColorSetter.setColorToWhite();
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Password Recovery',
        leadingButtons: [
          CircularBackButton(onPressed: () => Navigator.pop(context))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 60),
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                title: 'Reset Password',
                borderColor: Colors.grey.withOpacity(0.3),
                onPressed: () => _submit(),
                showLoader: value ?? false,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submit() {
    presenter.resetPassword(
        _accountNumberTextController.text, _emailTextController.text);
  }

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
  void onFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

}

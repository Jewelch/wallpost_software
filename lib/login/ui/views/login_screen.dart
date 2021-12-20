import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';
import 'package:wallpost/login/ui/presenters/login_presenter.dart';

class LoginScreen extends StatelessWidget implements LoginView {
  late LoginPresenter presenter;

  var accountNumberErrorNotifier = ItemNotifier<String>();
  var usernameErrorNotifier = ItemNotifier<String>();
  var passwordErrorNotifier = ItemNotifier<String>();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginScreen() {
    presenter = LoginPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ItemNotifiable<String>(
            notifier: accountNumberErrorNotifier,
            builder: (context, errorMessage) => TextField(
              controller: accountNumberController,
              decoration: InputDecoration(
                hintText: "Account Number",
                errorText: errorMessage,
              ),
            ),
          ),
          ItemNotifiable<String>(
            notifier: usernameErrorNotifier,
            builder: (context, errorMessage) => TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                errorText: errorMessage,
              ),
            ),
          ),
          ItemNotifiable<String>(
            notifier: passwordErrorNotifier,
            builder: (context, errorMessage) => TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                errorText: errorMessage,
              ),
            ),
          ),
          TextButton(
              child: Text("LOGIN"),
              onPressed: () {
                presenter.login(
                  accountNumberController.text,
                  usernameController.text,
                  passwordController.text,
                );
              }),
        ],
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {}

  @override
  void hideLoader() {}

  @override
  void notifyInvalidAccountNumber(String message) {
    accountNumberErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidUsername(String message) {
    usernameErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidPassword(String message) {
    passwordErrorNotifier.notify(message);
  }

  @override
  void onLoginFailed(String title, String message) {}

  @override
  void goToCompanyListScreen() {}
}

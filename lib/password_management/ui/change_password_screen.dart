import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/password_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _showLogo = true;
  var _currentPasswordTextController = TextEditingController();
  var _newPasswordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  Loader _loader;

  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) => setState(() => _showLogo = visible ? false : true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: SimpleAppBar(
          title: 'Change Password',
          leading: RoundedIconButton(
            iconName: 'assets/icons/back.svg',
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            RoundedIconButton(
              iconName: 'assets/icons/check.svg',
              onPressed: _performChangePassword,
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                profileImageandName(),
                descriptionText(),
                formUI(),
                forgetPasswordText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImageandName() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      height: _showLogo ? 180 : 0,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    CurrentUserProvider().getCurrentUser().profileImageUrl),
              ),
              Text(
                CurrentUserProvider().getCurrentUser().fullName,
                style: TextStyle(fontSize: 16),
              ),
            ]),
      ),
    );
  }

  Widget descriptionText() {
    return Container(
      child: Text(
          'You need to type in your current password to make sure its not someone else trying to access your data',
          style: TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }

  Widget formUI() {
    return Container(
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: <Widget>[
              PasswordTextField(
                label: "Current Password",
                placeholder: "munavir@123456",
                controller: _currentPasswordTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Current Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              PasswordTextField(
                label: "New Password",
                placeholder: "munavir@123",
                controller: _newPasswordTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter New Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              PasswordTextField(
                label: "Confirm New Password",
                placeholder: "munavir@123",
                controller: _confirmPasswordTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter New Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget forgetPasswordText() {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        child: Text(
          'Forgot Password?',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(RouteNames.forgotPassword);
      },
    );
  }

  void _performChangePassword() async {
    if (_formKey.currentState.validate() == false) return;
  }
}

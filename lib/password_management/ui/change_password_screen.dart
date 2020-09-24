import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/password_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/password_management/entities/change_password_form.dart';
import 'package:wallpost/password_management/services/password_changer.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _showLogo = true;
  Loader _loader;
  var _currentPasswordTextController = TextEditingController();
  var _newPasswordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();

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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: SimpleAppBar(
          title: 'Change Password',
          leading: RoundedIconButton(
            iconName: 'assets/icons/back.svg',
            onPressed: () => Navigator.pop(context),
          ),
          trailing: RoundedIconButton(
            iconName: 'assets/icons/check.svg',
            onPressed: _changePassword,
          ),
          showDivider: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                profileImageAndNameWidget(),
                descriptionText(),
                formUI(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImageAndNameWidget() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      height: _showLogo ? 180 : 0,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.defaultColor, width: 1),
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: NetworkImage(CurrentUserProvider().getCurrentUser().profileImageUrl), fit: BoxFit.fill),
            ),
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
                controller: _confirmPasswordTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Re-Enter New Password';
                  } else if (value != _newPasswordTextController.text) {
                    return 'The Passwords Do Not Match';
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

  void _changePassword() async {
    if (_formKey.currentState.validate() == false) return;

    _loader.show('Changing your password...');
    try {
      var changePasswordForm = ChangePasswordForm(_currentPasswordTextController.text, _newPasswordTextController.text);
      var _ = await PasswordChanger().changePassword(changePasswordForm);
      await _loader.hide();
      Alert.showSimpleAlert(
        context,
        title: 'Password Changed',
        message: 'Your password has been changed successfully',
        buttonTitle: 'Okay',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } on APIException catch (e) {
      await _loader.hide();
      Alert.showSimpleAlert(
        context,
        title: 'Failed to Change Password',
        message: e.userReadableMessage,
        buttonTitle: 'Okay',
        onPressed: () {},
      );
    }
  }
}

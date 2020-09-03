import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/password_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_routing/route_names.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

/*
1. Move content up with keyboard
2. Remove unused variables/attributes/widgets
3. Check and see if the app bar action button width change for Android
 */
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
        appBar: SimpleAppBar(
          title: 'Change Password',
          leading: RoundedIconButton(
            iconName: 'assets/icons/back.svg',
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            RoundedIconButton(
              iconName: 'assets/icons/check.svg',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: <Widget>[profilePicandName(), description(), formUI(), forgetPassword()],
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicandName() {
    return Container(
      height: 180,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/person.jpg'),
          ),
          Text(
            'John Peter',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    );
  }

  Widget description() {
    return Container(
      child: Text(
          'You need to type in your current password to make sure its not someone else trying to access your data'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget forgetPassword() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteNames.forgotPassword);
      },
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
    );
  }

  void _performChangePassword() async {
    if (_formKey.currentState.validate() == false) return;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import 'package:wallpost/_common_widgets/form_widgets/password_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/settings/password_management/ui/contracts/change_password_view.dart';
import 'package:wallpost/settings/password_management/ui/presenters/change_password_presenter.dart';
import 'package:wallpost/settings/password_management/ui/views/change_password_success_screen.dart';

import '../../../../_common_widgets/buttons/rounded_back_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> implements ChangePasswordView {
  late ChangePasswordPresenter presenter;
  var _showProfileImageNotifier = ItemNotifier<bool>(defaultValue: true);
  var _currentPasswordErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _newPasswordErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _confirmPasswordErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);
  var _formInputInteractionNotifier = ItemNotifier<bool>(defaultValue: true);
  var _currentPasswordTextController = TextEditingController();
  var _newPasswordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();

  @override
  void initState() {
    presenter = ChangePasswordPresenter(this);
    KeyboardVisibilityController().onChange.listen((visibility) => _showProfileImageNotifier.notify(!visibility));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: SimpleAppBar(
          title: 'Change Password',
          leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                _profileImageAndNameWidget(),
                SizedBox(height: 12),
                CurveBottomToTop(),
                formUI(),
                _changePasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImageAndNameWidget() {
    return ItemNotifiable<bool>(
      notifier: _showProfileImageNotifier,
      builder: (context, showProfileImage) => AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        child: Center(
          child: Container(
            height: showProfileImage ? 220 : 0,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.defaultColor, width: 1),
                        borderRadius: BorderRadius.circular(60)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              placeholder: "assets/icons/user_image_placeholder.png",
                              image: presenter.getProfileImage()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    presenter.getUserName(),
                    style: TextStyles.titleTextStyle,
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'You need to type in your current password to make sure its not someone else trying to access your data.',
                      style: TextStyles.subTitleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return ItemNotifiable<bool>(
      notifier: _formInputInteractionNotifier,
      builder: (context, enableInput) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                ItemNotifiable<String?>(
                  notifier: _currentPasswordErrorNotifier,
                  builder: (context, value) => PasswordTextField(
                    hint: "Current Password",
                    controller: _currentPasswordTextController,
                    textInputAction: TextInputAction.next,
                    errorText: value,
                    isEnabled: enableInput,
                  ),
                ),
                SizedBox(height: 16),
                ItemNotifiable<String?>(
                  notifier: _newPasswordErrorNotifier,
                  builder: (context, value) => PasswordTextField(
                    hint: "New Password",
                    controller: _newPasswordTextController,
                    textInputAction: TextInputAction.next,
                    errorText: value,
                    isEnabled: enableInput,
                  ),
                ),
                SizedBox(height: 16),
                ItemNotifiable<String?>(
                  notifier: _confirmPasswordErrorNotifier,
                  builder: (context, value) => PasswordTextField(
                    hint: "Confirm New Password",
                    controller: _confirmPasswordTextController,
                    textInputAction: TextInputAction.done,
                    errorText: value,
                    isEnabled: enableInput,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _changePasswordButton() {
    return ItemNotifiable<bool>(
      notifier: _showLoaderNotifier,
      builder: (context, showLoader) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: RoundedRectangleActionButton(
          title: 'Change Password',
          borderColor: AppColors.defaultColor,
          onPressed: () => _changePassword(),
          showLoader: showLoader,
        ),
      ),
    );
  }

  void _changePassword() {
    presenter.changePassword(
      _currentPasswordTextController.text,
      _newPasswordTextController.text,
      _confirmPasswordTextController.text,
    );
  }

  //MARK : View functions

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
  void notifyInvalidCurrentPassword(String message) {
    _currentPasswordErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidNewPassword(String message) {
    _newPasswordErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidConfirmPassword(String message) {
    _confirmPasswordErrorNotifier.notify(message);
  }

  @override
  void clearErrors() {
    _currentPasswordErrorNotifier.notify(null);
    _newPasswordErrorNotifier.notify(null);
    _confirmPasswordErrorNotifier.notify(null);
  }

  @override
  void goToSuccessScreen() {
    ScreenPresenter.present(ChangePasswordSuccessScreen(), context);
  }

  @override
  void onChangePasswordFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }
}

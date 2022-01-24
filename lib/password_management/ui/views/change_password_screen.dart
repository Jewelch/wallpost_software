import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/password_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/password_management/ui/contracts/change_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/change_password_presenter.dart';
import 'package:wallpost/password_management/ui/views/change_password_success_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    implements ChangePasswordView {
  var _showLogo = true;
  late Loader _loader;
  late ChangePasswordPresenter presenter;
  var _currentPasswordErrorNotifier = ItemNotifier<String>();
  var _newPasswordErrorNotifier = ItemNotifier<String>();
  var _confirmPasswordErrorNotifier = ItemNotifier<String>();
  var _currentPasswordTextController = TextEditingController();
  var _newPasswordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();

  @override
  void initState() {
    _loader = Loader(context);
    presenter = ChangePasswordPresenter(this);
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
          leadingButtons: [
            CircularBackButton(onPressed: () => Navigator.pop(context))
          ],
          trailingButtons: [
            CircularIconButton(
              iconName: 'assets/icons/check_mark_icon.svg',
              onPressed: _changePassword,
            )
          ],
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
                SizedBox(height: 12),
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.defaultColor, width: 1),
                    borderRadius: BorderRadius.circular(50)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder:
                              "assets/icons/user_image_placeholder.png",
                          image: presenter.getProfileImage()),
                    ),
                  ),
                ),
              ),
              Text(
                presenter.getUserName(),
                style: TextStyles.titleTextStyle,
              ),
            ]),
      ),
    );
  }

  Widget descriptionText() {
    return Container(
      child: Text(
          'You need to type in your current password to make sure its not someone else trying to access your data',
          style: TextStyles.subTitleTextStyle),
    );
  }

  Widget formUI() {
    return Container(
      child: Form(
        child: Center(
          child: Column(
            children: <Widget>[
              ItemNotifiable<String>(
                notifier: _currentPasswordErrorNotifier,
                builder: (context, value) => PasswordTextField(
                  label: "Current Password",
                  controller: _currentPasswordTextController,
                  textInputAction: TextInputAction.next,
                  errorText: value,
                  // errorText: value,
                ),
              ),
              SizedBox(height: 10),
              ItemNotifiable<String>(
                notifier: _newPasswordErrorNotifier,
                builder: (context, value) => PasswordTextField(
                  label: "New Password",
                  controller: _newPasswordTextController,
                  textInputAction: TextInputAction.next,
                  errorText: value,
                ),
              ),
              SizedBox(height: 10),
              ItemNotifiable<String>(
                notifier: _confirmPasswordErrorNotifier,
                builder: (context, value) => PasswordTextField(
                  label: "Confirm New Password",
                  controller: _confirmPasswordTextController,
                  textInputAction: TextInputAction.done,
                  errorText: value,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    presenter.changePassword(_currentPasswordTextController.text,
        _newPasswordTextController.text, _confirmPasswordTextController.text);
  }

  //MARK : VIEW FUNCTIONS
  @override
  void showLoader() {
    _loader.showLoadingIndicator("Changing your password...");
  }

  @override
  void hideLoader() {
    _loader.hideOpenDialog();
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

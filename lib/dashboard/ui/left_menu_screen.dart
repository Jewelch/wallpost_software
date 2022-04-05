import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/ui/views/notifications_screen.dart';
import 'package:wallpost/password_management/ui/views/change_password_screen.dart';

import '../../_common_widgets/custom_shapes/header_card.dart';

class LeftMenuScreen extends StatefulWidget {
  const LeftMenuScreen({Key? key}) : super(key: key);

  @override
  _LeftMenuScreenState createState() => _LeftMenuScreenState();
}

class _LeftMenuScreenState extends State<LeftMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        leadingButtons: [CircularBackButton(onPressed: () => Navigator.pop(context))],
        showDivider: false,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              _headerCard(),
              _changePassword(),
              Divider(),
              _notifications(),
              Divider(),
              _logout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return HeaderCard(
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 56.0, bottom: 8.0),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                imageUrl: CurrentUserProvider().getCurrentUser().profileImageUrl,
                placeholder: (context, url) => Image.asset(
                  'assets/icons/user_image_placeholder.png',
                  width: 48,
                  height: 48,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Text(
            CurrentUserProvider().getCurrentUser().fullName,
            style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _changePassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: InkWell(
        onTap: goToChangePasswordScreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/settings_icon.svg',
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  'Change Password',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _notifications() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: InkWell(
        onTap: goToNotificationsScreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/notification_icon.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  'Notifications',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _logout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: InkWell(
        onTap: logout,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/icons/logout_box_arrow_icon.svg',
              color: Colors.red,
              width: 20,
              height: 20,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text('Logout',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  goToChangePasswordScreen() {
    ScreenPresenter.present(ChangePasswordScreen(), context);
  }

  goToNotificationsScreen() {
    ScreenPresenter.present(NotificationsScreen(), context);
  }

  logout() {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: "Logout",
      message: "Are you sure you want to log out?",
      buttonOneTitle: "Yes",
      buttonTwoTitle: "Cancel",
      buttonOneOnPressed: () {
        LogoutHandler().logout(context);
      },
    );
  }
}

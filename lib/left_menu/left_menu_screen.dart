import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notifications/ui/views/notifications_screen.dart';
import 'package:wallpost/password_management/ui/views/change_password_screen.dart';

import '../_common_widgets/buttons/rounded_back_button.dart';
import '../_common_widgets/custom_shapes/header_card.dart';
import '../_shared/constants/app_colors.dart';

class LeftMenuScreen extends StatefulWidget {
  const LeftMenuScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    ScreenPresenter.present(
      LeftMenuScreen(),
      context,
      slideDirection: SlideDirection.fromLeft,
    );
  }

  @override
  _LeftMenuScreenState createState() => _LeftMenuScreenState();
}

class _LeftMenuScreenState extends State<LeftMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Menu',
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _userImageAndName(),
            _listItem(
              title: 'Change Password',
              iconName: 'assets/icons/settings_icon.svg',
              showArrow: true,
              onTap: goToChangePasswordScreen,
            ),
            Divider(),
            _listItem(
              title: 'Notifications',
              iconName: 'assets/icons/notification_icon.svg',
              showArrow: true,
              onTap: goToNotificationsScreen,
            ),
            Divider(),
            _listItem(
              title: 'Logout',
              iconName: 'assets/icons/logout_box_arrow_icon.svg',
              showArrow: false,
              onTap: logout,
              color: AppColors.cautionColor,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _userImageAndName() {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
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
          SizedBox(height: 16),
          Text(
            CurrentUserProvider().getCurrentUser().fullName,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headerCardSubHeadingTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _listItem({
    required String title,
    required String iconName,
    required bool showArrow,
    Color color = Colors.black,
    required VoidCallback onTap,
  }) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                iconName,
                width: 20,
                height: 20,
                color: color,
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: color),
              ),
              Expanded(child: SizedBox()),
              if (showArrow) Icon(Icons.arrow_forward_ios),
            ],
          ),
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

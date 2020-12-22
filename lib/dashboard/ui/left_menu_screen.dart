import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/logout_handler.dart';

//TODO: Add loader when profile picture loads or add a placeholder image
class LeftMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: _getTitle(),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/close_menu_icon.svg',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.defaultColor, width: 1),
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
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                CurrentUserProvider().getCurrentUser().fullName,
                style: TextStyles.titleTextStyle,
              ),
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLeftMenuButton(
                  title: 'Settings',
                  imageName: 'assets/icons/settings_icon.svg',
                  borderColor: AppColors.defaultColor,
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.settings),
                ),
                SizedBox(width: 40),
                _buildLeftMenuButton(
                  title: 'Logout',
                  imageName: 'assets/icons/logout_icon.svg',
                  imageSize: 22,
                  borderColor: AppColors.criticalButtonColor,
                  onPressed: () => LogoutHandler().logout(context),
                ),
                SizedBox(height: 40),
              ],
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    if (SelectedCompanyProvider().getSelectedCompanyForCurrentUser() == null)
      return '';
    else
      return SelectedCompanyProvider().getSelectedCompanyForCurrentUser().shortName;
  }

  Widget _buildLeftMenuButton({
    String title,
    String imageName,
    double imageSize = 24,
    Color borderColor,
    VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageName,
                width: imageSize,
                height: imageSize,
              ),
              SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 10)),
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

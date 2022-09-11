import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/settings/left_menu/left_menu_screen.dart';

import '../company_dashboard_my_portal/ui/views/my_portal_dasboard_base_screen.dart';
import 'company_dashboard_app_bar.dart';

class CompanyDashboardScreen extends StatelessWidget {
  final String companyId;
  final String companyName;

  CompanyDashboardScreen(this.companyId, this.companyName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          CompanyDashboardAppBar(
            companyName: companyName,
            profileImageUrl: CurrentUserProvider().getCurrentUser().profileImageUrl,
            onLeftMenuButtonPress: () => LeftMenuScreen.show(context),
            onAddButtonPress: () {},
            onTitlePress: () => Navigator.pop(context),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Text(
              "My Portal",
              style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: AppColors.myPortalColor),
            ),
          ),
          SizedBox(height: 8),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  Widget _content() {
    return MyPortalDashboardBaseScreen(companyId);
  }
}

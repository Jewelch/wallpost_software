import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/views/manager_my_portal_dashboard_screen.dart';
import 'package:wallpost/settings/left_menu/left_menu_screen.dart';

import '../../../company_dashboard_employee_my_portal/ui/views/employee_my_portal_dashboard_screen.dart';
import '../../../company_dashboard_owner_my_portal/ui/views/owner_my_portal_dashboard_screen.dart';
import '../presenters/company_dashboard_presenter.dart';
import 'company_dashboard_app_bar.dart';

class CompanyDashboardScreen extends StatelessWidget {
  final String companyId;
  final String companyName;
  final _presenter = CompanyDashboardPresenter();

  CompanyDashboardScreen(this.companyId, this.companyName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyDashboardAppBar(
            companyName: companyName,
            profileImageUrl: _presenter.getProfileImageUrl(),
            onLeftMenuButtonPress: () => LeftMenuScreen.show(context),
            onAddButtonPress: () {},
            onTitlePress: () => Navigator.pop(context),
          ),
          SizedBox(height: 16),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  Widget _content() {
    if (_presenter.shouldShowOwnerDashboard()) {
      return OwnerMyPortalDashboardScreen();
    } else if (_presenter.shouldShowManagerDashboard()) {
      return ManagerMyPortalDashboardScreen();
    } else if (_presenter.shouldShowEmployeeDashboard()) {
      return EmployeeMyPortalDashboardScreen();
    } else {
      return Container();
    }
  }
}

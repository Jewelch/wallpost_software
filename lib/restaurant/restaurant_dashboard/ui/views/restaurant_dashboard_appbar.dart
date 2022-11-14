import 'package:flutter/material.dart';

import '../../../../dashboard/company_dashboard/ui/views/company_dashboard_app_bar.dart';
import '../../../../settings/left_menu/left_menu_screen.dart';
import '../presenters/restaurant_dashboard_presenter.dart';

class RestaurantDashboardAppBar extends StatelessWidget {
  const RestaurantDashboardAppBar({Key? key, required this.salesPresenter}) : super(key: key);

  final RestaurantDashboardPresenter salesPresenter;

  @override
  Widget build(BuildContext context) {
    return CompanyDashboardAppBar(
      companyName: salesPresenter.getSelectedCompanyName(),
      profileImageUrl: salesPresenter.getProfileImageUrl(),
      onLeftMenuButtonPress: () => LeftMenuScreen.show(context),
      onAddButtonPress: () {},
      onTitlePress: () => Navigator.pop(context),
    );
  }
}

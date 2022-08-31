import 'package:flutter/material.dart';

import '../presenters/my_portal_dashboard_presenter.dart';
import 'employee_my_portal_dashboard_screen.dart';
import 'owner_my_portal_dashboard_screen.dart';

class MyPortalDashboardBaseScreen extends StatefulWidget {
  final String companyId;

  const MyPortalDashboardBaseScreen(this.companyId);

  @override
  _MyPortalDashboardBaseScreenState createState() => _MyPortalDashboardBaseScreenState();
}

class _MyPortalDashboardBaseScreenState extends State<MyPortalDashboardBaseScreen> {
  late MyPortalDashboardPresenter _presenter;

  @override
  void initState() {
    _presenter = MyPortalDashboardPresenter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_presenter.shouldShowOwnerDashboard()) {
      return OwnerMyPortalDashboardScreen();
    } else if (_presenter.shouldShowEmployeeDashboard()) {
      return EmployeeMyPortalDashboardScreen();
    } else {
      return Container();
    }
  }
}

import 'package:wallpost/permissions/permissions_provider.dart';

import '../../../../_wp_core/user_management/services/current_user_provider.dart';

class CompanyDashboardPresenter {
  final CurrentUserProvider _currentUserProvider;
  PermissionsProvider _permissionsProvider;

  CompanyDashboardPresenter()
      : _currentUserProvider = CurrentUserProvider(),
        _permissionsProvider = PermissionsProvider();

  CompanyDashboardPresenter.initWith(this._currentUserProvider, this._permissionsProvider);

  String getProfileImageUrl() {
    return _currentUserProvider.getCurrentUser().profileImageUrl;
  }

  bool shouldShowOwnerDashboard() {
    return _permissionsProvider.shouldShowOwnerDashboard();
  }

  bool shouldShowManagerDashboard() {
    return _permissionsProvider.shouldShowManagerDashboard();
  }

  bool shouldShowEmployeeDashboard() {
    return _permissionsProvider.shouldShowEmployeeDashboard();
  }
}

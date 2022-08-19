import 'package:wallpost/company_core/services/selected_company_provider.dart';

import '../../../../_wp_core/user_management/services/current_user_provider.dart';

class MyPortalDashboardPresenter {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final CurrentUserProvider _currentUserProvider;

  MyPortalDashboardPresenter()
      : _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  MyPortalDashboardPresenter.initWith(this._selectedCompanyProvider, this._currentUserProvider);

  String getProfileImageUrl() {
    return _currentUserProvider.getCurrentUser().profileImageUrl;
  }

  bool shouldShowOwnerDashboard() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    return company.employee.isOwner() || company.employee.isGM();
  }

  bool shouldShowEmployeeDashboard() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    return !(company.employee.isOwner() || company.employee.isGM());
  }
}

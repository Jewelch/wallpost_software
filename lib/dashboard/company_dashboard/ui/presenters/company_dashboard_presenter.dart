import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/user_management/services/current_user_provider.dart';

class CompanyDashboardPresenter {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final CurrentUserProvider _currentUserProvider;

  CompanyDashboardPresenter()
      : _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  CompanyDashboardPresenter.initWith(this._selectedCompanyProvider, this._currentUserProvider);

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

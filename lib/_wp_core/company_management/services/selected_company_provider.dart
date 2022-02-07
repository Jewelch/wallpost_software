import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/dashboard_management/entities/Dashboard.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

class SelectedCompanyProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  SelectedCompanyProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository();

  SelectedCompanyProvider.initWith(this._currentUserProvider, this._companyRepository);

  bool isCompanySelected() {
    var currentUser = _currentUserProvider.getCurrentUser();
    return _companyRepository.getSelectedCompanyForUser(currentUser) != null;
  }

  bool isSingleCompany() {
    var currentUser = _currentUserProvider.getCurrentUser();
    var singleCompany = _companyRepository.getCompaniesForUser(currentUser).length == 1;
    return singleCompany;
  }

  Company? getSelectedCompanyForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();
    return _companyRepository.getSelectedCompanyForUser(currentUser);
  }
}

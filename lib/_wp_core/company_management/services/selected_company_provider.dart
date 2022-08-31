import 'package:wallpost/_wp_core/company_management/entities/company.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

class SelectedCompanyProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  SelectedCompanyProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository.getInstance();

  SelectedCompanyProvider.initWith(this._currentUserProvider, this._companyRepository);

  bool isCompanySelected() {
    var currentUser = _currentUserProvider.getCurrentUser();
    return _companyRepository.getSelectedCompanyForUser(currentUser) != null;
  }

  //NOTE: Should only call this function once a company
  //has already be selected. We do not return null when
  //no company is selected because returning null from
  // this function will mean using the force unwrap
  // operator (!) throughout the app
  Company getSelectedCompanyForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();
    return _companyRepository.getSelectedCompanyForUser(currentUser)!;
  }
}

import 'package:wallpost/company_list/entities/company.dart';
import 'package:wallpost/company_list/repositories/company_repository.dart';
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

  //NOTE: Should only call this function once a company
  //has already be selected. Returning null from this function
  //will mean using the force unwrap operator (!) througout
  //the app
  Company getSelectedCompanyForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();
    return _companyRepository.getSelectedCompanyForUser(currentUser)!;
  }
}

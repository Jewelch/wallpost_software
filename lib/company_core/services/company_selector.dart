import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

class CompanySelector {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  CompanySelector.initWith(this._currentUserProvider, this._companyRepository);

  CompanySelector()
      : this._currentUserProvider = CurrentUserProvider(),
        this._companyRepository = CompanyRepository.getInstance();

  void selectCompanyForCurrentUser(Company company) {
    var user = _currentUserProvider.getCurrentUser();
    _companyRepository.selectCompanyForUser(company, user);
  }
}

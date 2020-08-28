import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class CompanySelector {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  CompanySelector()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository();

  CompanySelector.initWith(this._currentUserProvider, this._companyRepository);

  void selectCompanyForCurrentUser(Company company) {
    var currentUser = _currentUserProvider.getCurrentUser();

    if (currentUser == null) return;

    _companyRepository.selectCompanyForUser(company, currentUser);
  }
}

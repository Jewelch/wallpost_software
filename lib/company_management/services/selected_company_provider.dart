import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class SelectedCompanyProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  SelectedCompanyProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository();

  SelectedCompanyProvider.initWith(this._currentUserProvider, this._companyRepository);

  Company getSelectCompanyForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();

    if (currentUser == null) return null;

    return _companyRepository.getSelectedCompanyForUser(currentUser);
  }
}

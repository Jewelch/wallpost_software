// @dart=2.9

import 'package:wallpost/_wp_core/company_management/entities/company.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

class SelectedCompanyProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  SelectedCompanyProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository();

  SelectedCompanyProvider.initWith(this._currentUserProvider, this._companyRepository);

  Company getSelectedCompanyForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();

    if (currentUser == null) return null;

    return _companyRepository.getSelectedCompanyForUser(currentUser);
  }
}

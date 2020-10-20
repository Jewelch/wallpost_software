import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_management/entities/employee.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class SelectedEmployeeProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  SelectedEmployeeProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository();

  SelectedEmployeeProvider.initWith(this._currentUserProvider, this._companyRepository);

  Employee getSelectedEmployeeForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();

    if (currentUser == null) return null;

    return _companyRepository.getSelectedEmployeeForUser(currentUser);
  }
}

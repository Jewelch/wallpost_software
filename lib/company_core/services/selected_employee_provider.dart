import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

class SelectedEmployeeProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;

  SelectedEmployeeProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository.getInstance();

  SelectedEmployeeProvider.initWith(this._currentUserProvider, this._companyRepository);

  Employee getSelectedEmployeeForCurrentUser() {
    var currentUser = _currentUserProvider.getCurrentUser();
    return _companyRepository.getSelectedEmployeeForUser(currentUser)!;
  }
}

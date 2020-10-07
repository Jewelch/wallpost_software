import 'package:wallpost/company_management/entities/employee.dart';
import 'package:wallpost/company_management/repositories/employee_repository.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';

class SelectedEmployeeProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final EmployeeRepository _employeeRepository;

  SelectedEmployeeProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _employeeRepository = EmployeeRepository();

  SelectedEmployeeProvider.initWith(this._selectedCompanyProvider, this._employeeRepository);

  Employee getEmployeeForSelectedCompany() {
    var selectedCompany = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();

    if (selectedCompany == null) return null;

    return _employeeRepository.getEmployeeForCompany(selectedCompany);
  }
}

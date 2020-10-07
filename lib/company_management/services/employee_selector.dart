import 'package:wallpost/company_management/entities/employee.dart';
import 'package:wallpost/company_management/repositories/employee_repository.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';

class EmployeeSelector {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final EmployeeRepository _employeeRepository;

  EmployeeSelector()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _employeeRepository = EmployeeRepository();

  EmployeeSelector.initWith(this._selectedCompanyProvider, this._employeeRepository);

  void selectEmployeeForSelectedCompany(Employee employee) {
    var selectedCompany = _selectedCompanyProvider.getSelectCompanyForCurrentUser();

    if (selectedCompany == null) return;

    _employeeRepository.saveEmployeeForCompany(employee, selectedCompany);
  }
}

import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/entities/employee.dart';

class EmployeeRepository {
  static EmployeeRepository _singleton;
  Employee _employee;
  String _companyId;

  factory EmployeeRepository() {
    if (_singleton == null) {
      _singleton = EmployeeRepository._();
    }
    return _singleton;
  }

  EmployeeRepository._();

  void saveEmployeeForCompany(Employee employee, Company company) {
    _employee = employee;
    _companyId = company.companyId;
  }

  Employee getEmployeeForCompany(Company company) {
    if (_companyId != company.companyId) return null;

    return _employee;
  }
}

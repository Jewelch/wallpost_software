import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/employee_repository.dart';

import '../../_mocks/mock_employee.dart';

class MockCompany extends Mock implements Company {}

void main() {
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();
  EmployeeRepository employeeRepository;

  setUpAll(() {
    when(mockCompany.companyId).thenReturn('someCompanyId');
  });

  setUp(() {
    employeeRepository = EmployeeRepository();
  });

  test('returns null if no employee is stored', () async {
    expect(employeeRepository.getEmployeeForCompany(mockCompany), null);
  });

  test('storing employee for a company id', () async {
    employeeRepository.saveEmployeeForCompany(mockEmployee, mockCompany);

    expect(employeeRepository.getEmployeeForCompany(mockCompany), mockEmployee);
  });

  test('returns null if employee is not found for a company', () async {
    employeeRepository.saveEmployeeForCompany(mockEmployee, mockCompany);

    var someOtherCompany = MockCompany();
    expect(employeeRepository.getEmployeeForCompany(someOtherCompany), null);
  });
}

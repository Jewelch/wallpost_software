import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/repositories/employee_repository.dart';
import 'package:wallpost/company_management/services/employee_selector.dart';

import '../../_mocks/MockCompany.dart';
import '../../_mocks/MockCompanyProvider.dart';
import '../../_mocks/mock_employee.dart';

class MockEmployeeRepository extends Mock implements EmployeeRepository {}

void main() {
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();
  var mockCompanyProvider = MockCompanyProvider();
  var mockEmployeeRepository = MockEmployeeRepository();
  var employeeSelector = EmployeeSelector.initWith(mockCompanyProvider, mockEmployeeRepository);

  setUpAll(() {});

  test('selecting an employee does nothing when selected company is not available', () async {
    when(mockCompanyProvider.getSelectCompanyForCurrentUser()).thenReturn(null);

    employeeSelector.selectEmployeeForSelectedCompany(mockEmployee);

    verify(mockCompanyProvider.getSelectCompanyForCurrentUser()).called(1);
    verifyNever(mockEmployeeRepository.saveEmployeeForCompany(any, any)).called(0);
  });

  test('selecting an employee when the selected company is available is available', () async {
    when(mockCompanyProvider.getSelectCompanyForCurrentUser()).thenReturn(mockCompany);

    employeeSelector.selectEmployeeForSelectedCompany(mockEmployee);

    verify(mockCompanyProvider.getSelectCompanyForCurrentUser()).called(1);
    var verificationResult = verify(mockEmployeeRepository.saveEmployeeForCompany(captureAny, captureAny));
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockEmployee);
    expect(verificationResult.captured[1], mockCompany);
  });
}

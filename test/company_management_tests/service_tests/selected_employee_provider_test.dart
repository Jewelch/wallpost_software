import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/repositories/employee_repository.dart';
import 'package:wallpost/company_management/services/selected_employee_provider.dart';

import '../../_mocks/MockCompany.dart';
import '../../_mocks/MockCompanyProvider.dart';
import '../../_mocks/mock_employee.dart';

class MockEmployeeRepository extends Mock implements EmployeeRepository {}

void main() {
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();
  var mockCompanyProvider = MockCompanyProvider();
  var mockEmployeeRepository = MockEmployeeRepository();
  var selectedEmployeeProvider = SelectedEmployeeProvider.initWith(mockCompanyProvider, mockEmployeeRepository);

  setUpAll(() {});

  test('returns null if there is no selected company', () async {
    when(mockCompanyProvider.getSelectCompanyForCurrentUser()).thenReturn(null);

    var employee = selectedEmployeeProvider.getEmployeeForSelectedCompany();

    expect(employee, null);
    verify(mockCompanyProvider.getSelectCompanyForCurrentUser()).called(1);
    verifyNever(mockEmployeeRepository.getEmployeeForCompany(any)).called(0);
  });

  test('getting the employee for the selected company', () async {
    when(mockCompanyProvider.getSelectCompanyForCurrentUser()).thenReturn(mockCompany);
    when(mockEmployeeRepository.getEmployeeForCompany(any)).thenReturn(mockEmployee);

    var employee = selectedEmployeeProvider.getEmployeeForSelectedCompany();

    expect(employee, mockEmployee);
    verify(mockCompanyProvider.getSelectCompanyForCurrentUser()).called(1);
    var verificationResult = verify(mockEmployeeRepository.getEmployeeForCompany(captureAny));
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockCompany);
  });
}

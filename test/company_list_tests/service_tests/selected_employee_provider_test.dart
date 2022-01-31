import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_user.dart';
import 'companies_list_provider_test.dart';

void main() {
  var mockUser = MockUser();
  var mockCurrentUserProvider = MockCurrentUserProvider();
  var mockEmployee = MockEmployee();
  var mockCompanyRepository = MockCompanyRepository();
  var selectedEmployeeProvider = SelectedEmployeeProvider.initWith(mockCurrentUserProvider, mockCompanyRepository);

  setUpAll(() {
    registerFallbackValue(MockUser());
    registerFallbackValue(MockCompany());
  });

  test('getting selected employee for current user', () async {
    when(() => mockCurrentUserProvider.getCurrentUser()).thenReturn(mockUser);
    when(() => mockCompanyRepository.getSelectedEmployeeForUser(any())).thenReturn(mockEmployee);

    var selectedEmployee = selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();

    expect(selectedEmployee, mockEmployee);
    verify(() => mockCurrentUserProvider.getCurrentUser()).called(1);
    var verificationResult = verify(() => mockCompanyRepository.getSelectedEmployeeForUser(captureAny()));
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockUser);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';

import '../../_mocks/mock_user.dart';

class MockCompany extends Mock implements Company {}

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  var mockCompanyRepository = MockCompanyRepository();
  var selectedCompanyProvider = SelectedCompanyProvider.initWith(mockCompanyRepository);

  test('getting selected company for a user', () async {
    when(mockCompanyRepository.getSelectedCompanyForUser(any)).thenReturn(mockCompany);

    var selectedCompany = selectedCompanyProvider.getSelectedCompanyForUser(mockUser);
    var verificationResult = verify(mockCompanyRepository.getSelectedCompanyForUser(captureAny));

    expect(selectedCompany, mockCompany);
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockUser);
  });
}

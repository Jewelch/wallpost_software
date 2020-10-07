import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';
import 'package:wallpost/company_management/services/companies_list_remover.dart';

import '../../_mocks/mock_user.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompanyRepository = MockCompanyRepository();
  var companyRemover = CompaniesListRemover.initWith(mockCompanyRepository);

  test('removing companies for a user', () async {
    companyRemover.removeCompaniesForUser(mockUser);

    var verificationResult = verify(mockCompanyRepository.removeCompaniesForUser(captureAny));

    verificationResult.called(1);
    expect(verificationResult.captured.single, mockUser);
  });
}

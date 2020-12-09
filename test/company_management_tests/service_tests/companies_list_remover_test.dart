import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/company_management/services/user_companies_remover.dart';

import '../../_mocks/mock_user.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompanyRepository = MockCompanyRepository();
  var companiesRemover = UserCompaniesRemover.initWith(mockCompanyRepository);

  test('removing companies for a user', () async {
    companiesRemover.removeCompaniesForUser(mockUser);

    var verificationResult = verify(mockCompanyRepository.removeCompaniesForUser(captureAny));

    verificationResult.called(1);
    expect(verificationResult.captured.single, mockUser);
  });
}

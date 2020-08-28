import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';
import 'package:wallpost/company_management/services/company_selector.dart';

import '../../_mocks/mock_user.dart';

class MockCompany extends Mock implements Company {}

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  var mockCompanyRepository = MockCompanyRepository();
  var companySelector = CompanySelector.initWith(mockCompanyRepository);

  test('selecting company for a user', () async {
    companySelector.selectCompanyForUser(mockCompany, mockUser);

    var verificationResult = verify(mockCompanyRepository.selectCompanyForUser(captureAny, captureAny));

    verificationResult.called(1);
    expect(verificationResult.captured[0], mockCompany);
    expect(verificationResult.captured[1], mockUser);
  });
}

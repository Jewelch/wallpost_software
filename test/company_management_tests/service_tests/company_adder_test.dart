import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';
import 'package:wallpost/company_management/services/company_adder.dart';

import '../../_mocks/mock_user.dart';

class MockCompany extends Mock implements Company {}

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompany1 = MockCompany();
  var mockCompany2 = MockCompany();
  var mockCompanyRepository = MockCompanyRepository();
  var companyAdder = CompanyAdder.initWith(mockCompanyRepository);

  test('adding companies for a user', () async {
    companyAdder.addCompaniesForUser([mockCompany1, mockCompany2], mockUser);

    var verificationResult = verify(mockCompanyRepository.saveCompaniesForUser(captureAny, captureAny));

    verificationResult.called(1);
    expect(verificationResult.captured[0], [mockCompany1, mockCompany2]);
    expect(verificationResult.captured[1], mockUser);
  });
}

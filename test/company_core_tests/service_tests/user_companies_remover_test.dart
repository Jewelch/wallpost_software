import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';
import 'package:wallpost/company_core/services/user_companies_remover.dart';

import '../../_mocks/mock_user.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}


//TODO:: Obaid fix with Aymen
void main() {
  // var mockUser = MockUser();
  // var mockCompanyRepository = MockCompanyRepository();
  // var companiesRemover = UserCompaniesRemover.initWith(mockCompanyRepository);
  //
  // setUpAll(() {
  //   registerFallbackValue(MockUser());
  // });
  //
  // test('removing companies for a user', () async {
  //   companiesRemover.removeCompaniesForUser(mockUser);
  //
  //   var verificationResult = verify(() => mockCompanyRepository.removeCompaniesForUser(captureAny()));
  //
  //   verificationResult.called(1);
  //   expect(verificationResult.captured.single, mockUser);
  // });
}

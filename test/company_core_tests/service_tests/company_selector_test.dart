import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';
import 'package:wallpost/company_core/services/company_selector.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_user.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var userProvider = MockCurrentUserProvider();
  var companyRepository = MockCompanyRepository();
  late CompanySelector companySelector;

  setUp(() {
    companySelector = CompanySelector.initWith(userProvider, companyRepository);
  });

  test("selecting a company for a user", () {
    //given
    var user = MockUser();
    when(() => userProvider.getCurrentUser()).thenReturn(user);
    var company = MockCompany();

    //when
    companySelector.selectCompanyForCurrentUser(company);

    //then
    verifyInOrder([() => userProvider.getCurrentUser(), () => companyRepository.selectCompanyForUser(company, user)]);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_user.dart';

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  late CompanyRepository companyRepository;

  setUp(() {
    companyRepository = CompanyRepository.initWith();
  });

  test('selecting a company', () async {
    companyRepository.selectCompanyForUser(mockCompany, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany);
  });

  test('removing selected company', () async {
    companyRepository.selectCompanyForUser(mockCompany, mockUser);
    companyRepository.removeSelectedCompanyForUser(mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });
}

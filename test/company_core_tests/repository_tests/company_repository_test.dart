import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/entities/company_group.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_user.dart';

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockCompaniesGroup extends Mock implements CompanyGroup {}

void main() {
  var mockUser = MockUser();
  var mockFinancialSummary = MockFinancialSummary();
  var mockCompaniesGroup1 = MockCompaniesGroup();
  var mockCompaniesGroup2 = MockCompaniesGroup();
  var mockCompany1 = MockCompany();
  var mockCompany2 = MockCompany();
  var companyList = CompanyList(
    mockFinancialSummary,
    [mockCompaniesGroup1, mockCompaniesGroup2],
    [mockCompany1, mockCompany2],
  );
  late CompanyRepository companyRepository;

  setUpAll(() {
    when(() => mockUser.username).thenReturn('someUserName');
    when(() => mockCompany1.id).thenReturn('1');
    when(() => mockCompany2.id).thenReturn('2');
  });

  setUp(() {
    companyRepository = CompanyRepository.initWith();
  });

  test('saving companies for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), isNotNull);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });

  test('saving group dashboard for a user that already exists, replaces the group dashboard for that user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    var groupDashboard2 = CompanyList(null, [mockCompaniesGroup1], [mockCompany1]);
    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser)!.financialSummary, null);
    expect(companyRepository.getCompanyListForUser(mockUser)!.groups.length, 1);
    expect(companyRepository.getCompanyListForUser(mockUser)!.companies.length, 1);
  });

  test('selecting a company and employee for a user that does not exist does nothing', () async {
    companyRepository.selectCompanyForUser(mockCompany1, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), null);
  });

  test('selecting a company for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    companyRepository.selectCompanyForUser(mockCompany1, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany1);
  });

  test('selecting a company that does not exist does nothing', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    var someOtherCompany = MockCompany();
    when(() => someOtherCompany.id).thenReturn('someOtherCompanyId');

    companyRepository.selectCompanyForUser(someOtherCompany, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });

  test(
      'saving companies for an existing user, auto selects previously selected'
      ' company and employee if it exists in the new list', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    companyRepository.selectCompanyForUser(mockCompany1, mockUser);

    var groupDashboard2 = CompanyList(
      mockFinancialSummary,
      [mockCompaniesGroup1, mockCompaniesGroup2],
      [mockCompany1, mockCompany2],
    );
    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany1);
  });

  test(
      'saving companies for a user that already exists, removes previously selected '
      'company and employee if it does not exist in the new list', () async {
    var groupDashboard1 = CompanyList(null, [mockCompaniesGroup1], [mockCompany1]);
    var groupDashboard2 = CompanyList(null, [mockCompaniesGroup2], [mockCompany2]);

    companyRepository.saveCompanyListForUser(groupDashboard1, mockUser);
    companyRepository.selectCompanyForUser(mockCompany1, mockUser);

    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });

  test('removing group dashboard for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    companyRepository.selectCompanyForUser(mockCompany1, mockUser);

    companyRepository.removeCompaniesForUser(mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), null);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });
}

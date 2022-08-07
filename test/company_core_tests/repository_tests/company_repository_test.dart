import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/entities/company_group.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_user.dart';

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockCompaniesGroup extends Mock implements CompanyGroup {}

class MockCompanyListItem extends Mock implements CompanyListItem {}

void main() {
  var mockUser = MockUser();
  var mockFinancialSummary = MockFinancialSummary();
  var mockCompaniesGroup1 = MockCompaniesGroup();
  var mockCompaniesGroup2 = MockCompaniesGroup();
  var mockCompanyListItem1 = MockCompanyListItem();
  var mockCompanyListItem2 = MockCompanyListItem();
  var companyList = CompanyList(
    mockFinancialSummary,
    [mockCompaniesGroup1, mockCompaniesGroup2],
    [mockCompanyListItem1, mockCompanyListItem2],
  );
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();
  late CompanyRepository companyRepository;

  setUpAll(() {
    when(() => mockUser.username).thenReturn('someUserName');
    when(() => mockCompanyListItem1.id).thenReturn('1');
    when(() => mockCompanyListItem2.id).thenReturn('2');
    when(() => mockCompany.id).thenReturn('1');
    when(() => mockEmployee.companyId).thenReturn('1');
  });

  setUp(() {
    companyRepository = CompanyRepository.initWith();
  });

  test('saving companies for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), isNotNull);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('saving group dashboard for a user that already exists, replaces the group dashboard for that user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    var groupDashboard2 = CompanyList(null, [mockCompaniesGroup1], [mockCompanyListItem1]);
    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser)!.financialSummary, null);
    expect(companyRepository.getCompanyListForUser(mockUser)!.groups.length, 1);
    expect(companyRepository.getCompanyListForUser(mockUser)!.companies.length, 1);
  });

  test('selecting a company and employee for a user that does not exist does nothing', () async {
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), null);
  });

  test('selecting a company for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), mockEmployee);
  });

  test('selecting a company that does not exist does nothing', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    var someOtherCompany = MockCompany();
    when(() => someOtherCompany.id).thenReturn('someOtherCompanyId');

    companyRepository.selectCompanyAndEmployeeForUser(someOtherCompany, mockEmployee, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('selecting an employee with a company id that does not exist does nothing', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    var employeeFromAnotherCompany = MockEmployee();
    when(() => employeeFromAnotherCompany.companyId).thenReturn('someOtherCompanyId');

    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, employeeFromAnotherCompany, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test(
      'saving companies for an existing user, auto selects previously selected'
      ' company and employee if it exists in the new list', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    var groupDashboard2 = CompanyList(
      mockFinancialSummary,
      [mockCompaniesGroup1, mockCompaniesGroup2],
      [mockCompanyListItem1, mockCompanyListItem2],
    );
    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), mockEmployee);
  });

  test(
      'saving companies for a user that already exists, removes previously selected '
      'company and employee if it does not exist in the new list', () async {
    var groupDashboard1 = CompanyList(null, [mockCompaniesGroup1], [mockCompanyListItem1]);
    var groupDashboard2 = CompanyList(null, [mockCompaniesGroup2], [mockCompanyListItem2]);

    companyRepository.saveCompanyListForUser(groupDashboard1, mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('removing group dashboard for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    companyRepository.removeCompaniesForUser(mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), null);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/company_core/entities/company_group.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_user.dart';
import '../mocks.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

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
  var mockSharedPrefs = MockSharedPrefs();
  late CompanyRepository companyRepository;

  setUpAll(() {
    when(() => mockUser.username).thenReturn('someUserName');

    when(() => mockFinancialSummary.toJson()).thenReturn({'financial': 'data'});
    when(() => mockCompaniesGroup1.toJson()).thenReturn({'companiesGroup1': 'json'});
    when(() => mockCompaniesGroup2.toJson()).thenReturn({'companiesGroup2': 'json'});
    when(() => mockCompanyListItem1.toJson()).thenReturn({'companyListItemOne': 'json'});
    when(() => mockCompanyListItem2.toJson()).thenReturn({'companyListItemTwo': 'json'});
    when(() => mockCompany.toJson()).thenReturn({'company': 'json'});
    when(() => mockEmployee.toJson()).thenReturn({'employee': 'json'});

    when(() => mockCompanyListItem1.id).thenReturn('1');
    when(() => mockCompanyListItem2.id).thenReturn('2');
    when(() => mockCompany.id).thenReturn('1');
    when(() => mockEmployee.companyId).thenReturn('1');
  });

  setUp(() {
    reset(mockSharedPrefs);
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value());
    companyRepository = CompanyRepository.withSharedPrefs(mockSharedPrefs);
    reset(mockSharedPrefs);
  });

  test('saving group dashboard for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), isNotNull);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
    verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny())).called(1);
  });

  test('saving group dashboard for a user that already exists, replaces the group dashboard for that user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    reset(mockSharedPrefs);
    var groupDashboard2 = CompanyList(null, [mockCompaniesGroup1], [mockCompanyListItem1]);
    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser)!.financialSummary, null);
    expect(companyRepository.getCompanyListForUser(mockUser)!.groups.length, 1);
    expect(companyRepository.getCompanyListForUser(mockUser)!.companies.length, 1);
    verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny())).called(1);
  });

  test('selecting a company and employee for a user that does not exist does nothing', () async {
    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    verifyNever(() => mockSharedPrefs.saveMap(any(), any()));
    expect(companyRepository.getCompanyListForUser(mockUser), null);
  });

  test('selecting a company for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);

    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), mockEmployee);
    verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny())).called(1);
  });

  test('selecting a company that does not exist does nothing', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    var someOtherCompany = MockCompany();
    when(() => someOtherCompany.id).thenReturn('someOtherCompanyId');

    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(someOtherCompany, mockEmployee, mockUser);

    verifyNever(() => mockSharedPrefs.saveMap(any(), any()));
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('selecting an employee with a company id that does not exist does nothing', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    var employeeFromAnotherCompany = MockEmployee();
    when(() => employeeFromAnotherCompany.companyId).thenReturn('someOtherCompanyId');

    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, employeeFromAnotherCompany, mockUser);

    verifyNever(() => mockSharedPrefs.saveMap(any(), any()));
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test(
      'saving companies for an existing user, auto selects previously selected'
      ' company and employee if it exists in the new list', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);
    reset(mockSharedPrefs);

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
    reset(mockSharedPrefs);

    companyRepository.saveCompanyListForUser(groupDashboard2, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('removing group dashboard for a user', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    reset(mockSharedPrefs);
    companyRepository.removeCompaniesForUser(mockUser);

    expect(companyRepository.getCompanyListForUser(mockUser), null);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('data is mapped correctly when storing', () async {
    companyRepository.saveCompanyListForUser(companyList, mockUser);
    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    expect(verificationResult.captured[0], 'allUsersCompanies');
    expect(verificationResult.captured[1], {
      'someUserName': {
        'companyList': {
          'financial_summary': {'financial': 'data'},
          'groups': [
            {'companiesGroup1': 'json'},
            {'companiesGroup2': 'json'}
          ],
          'companies': [
            {'companyListItemOne': 'json'},
            {'companyListItemTwo': 'json'}
          ]
        },
        'selectedCompany': {'company': 'json'},
        'selectedEmployee': {'employee': 'json'},
      },
    });
  });

  test('data is mapped correctly when reading from the storage', () async {
    var user1 = MockUser();
    var user2 = MockUser();
    var userWhoseCompaniesAreNotStored = MockUser();
    when(() => user1.username).thenReturn('username1');
    when(() => user2.username).thenReturn('username2');
    when(() => userWhoseCompaniesAreNotStored.username).thenReturn('username3');
    when(() => mockSharedPrefs.getMap('allUsersCompanies')).thenAnswer(
      (_) => Future.value({
        'username1': {
          'companyList': Mocks.companiesListResponse,
          'selectedCompany': null,
          'selectedEmployee': null,
        },
        'username2': {
          'companyList': Mocks.companiesListResponse,
          'selectedCompany': Mocks.companyDetailsResponse,
          'selectedEmployee': Mocks.companyDetailsResponse,
        },
      }),
    );

    companyRepository = CompanyRepository.withSharedPrefs(mockSharedPrefs);
    //awaiting because the shared prefs get method is async and takes a few ms to load
    //This will not be an issue in the actual app because the companyRepository is initialized when the
    //app starts and there is time before it is actually used.
    await Future.delayed(Duration(milliseconds: 450));

    expect(companyRepository.getCompanyListForUser(userWhoseCompaniesAreNotStored), null);
    expect(companyRepository.getSelectedCompanyForUser(userWhoseCompaniesAreNotStored), null);
    expect(companyRepository.getSelectedEmployeeForUser(userWhoseCompaniesAreNotStored), null);

    expect(companyRepository.getCompanyListForUser(user1)?.companies.length, 7);
    expect(companyRepository.getSelectedCompanyForUser(user1), null);
    expect(companyRepository.getSelectedEmployeeForUser(user1), null);

    expect(companyRepository.getCompanyListForUser(user2)?.companies.length, 7);
    var selectedCompanyId = '${Mocks.companyDetailsResponse['company_id']}';
    var selectedEmployeeId = '${Mocks.companyDetailsResponse['employee']['employment_id_v1']}';
    expect(companyRepository.getSelectedCompanyForUser(user2)!.id, selectedCompanyId);
    expect(companyRepository.getSelectedEmployeeForUser(user2)!.v1Id, selectedEmployeeId);
  });
}

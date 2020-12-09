import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_employee.dart';
import '../../../_mocks/mock_user.dart';
import '../mocks.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

class MockCompanyListItem extends Mock implements CompanyListItem {}

void main() {
  var mockUser = MockUser();
  var mockCompanyListItem1 = MockCompanyListItem();
  var mockCompanyListItem2 = MockCompanyListItem();
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();
  var mockSharedPrefs = MockSharedPrefs();
  CompanyRepository companyRepository;

  setUpAll(() {
    when(mockUser.username).thenReturn('someUserName');
    when(mockCompanyListItem1.toJson()).thenReturn({'companyListItemOne': 'json'});
    when(mockCompanyListItem2.toJson()).thenReturn({'companyListItemTwo': 'json'});
    when(mockCompany.toJson()).thenReturn({'company': 'json'});
    when(mockEmployee.toJson()).thenReturn({'employee': 'json'});

    when(mockCompanyListItem1.id).thenReturn('1');
    when(mockCompanyListItem2.id).thenReturn('2');
    when(mockCompany.id).thenReturn('1');
    when(mockEmployee.companyId).thenReturn('1');
  });

  setUp(() {
    reset(mockSharedPrefs);
    companyRepository = CompanyRepository.withSharedPrefs(mockSharedPrefs);
  });

  test('saving companies for a user', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1, mockCompanyListItem2], mockUser);

    expect(companyRepository.getCompaniesForUser(mockUser).length, 2);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
    verify(mockSharedPrefs.saveMap(captureAny, captureAny)).called(1);
  });

  test('saving companies for a user that already exists, replaces the companies for that user', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1], mockUser);

    reset(mockSharedPrefs);
    companyRepository.saveCompaniesForUser([mockCompanyListItem2], mockUser);

    expect(companyRepository.getCompaniesForUser(mockUser)[0], mockCompanyListItem2);
    verify(mockSharedPrefs.saveMap(captureAny, captureAny)).called(1);
  });

  test('selecting a company and employee for a user that does not exist does nothing', () async {
    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    verifyNever(mockSharedPrefs.saveMap(any, any));
    expect(companyRepository.getCompaniesForUser(mockUser), []);
  });

  test('selecting a company for a user', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1, mockCompanyListItem2], mockUser);

    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), mockEmployee);
    verify(mockSharedPrefs.saveMap(captureAny, captureAny)).called(1);
  });

  test('selecting a company that does not exist does nothing', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1], mockUser);
    var someOtherCompany = MockCompany();
    when(someOtherCompany.id).thenReturn('someOtherCompanyId');

    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(someOtherCompany, mockEmployee, mockUser);

    verifyNever(mockSharedPrefs.saveMap(any, any));
    expect(companyRepository.getCompaniesForUser(mockUser), [mockCompanyListItem1]);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('selecting an employee with a company id that does not exist does nothing', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1], mockUser);
    var employeeFromAnotherCompany = MockEmployee();
    when(employeeFromAnotherCompany.companyId).thenReturn('someOtherCompanyId');

    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, employeeFromAnotherCompany, mockUser);

    verifyNever(mockSharedPrefs.saveMap(any, any));
    expect(companyRepository.getCompaniesForUser(mockUser), [mockCompanyListItem1]);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test(
      'saving companies for an existing user, auto selects previously selected'
      ' company and employee if it exists in the new list', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1, mockCompanyListItem2], mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);
    reset(mockSharedPrefs);

    companyRepository.saveCompaniesForUser([mockCompanyListItem1, mockCompanyListItem2], mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), mockEmployee);
  });

  test(
      'saving companies for a user that already exists, removes previously selected '
      'company and employee if it does not exist in the new list', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1], mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);
    reset(mockSharedPrefs);

    companyRepository.saveCompaniesForUser([mockCompanyListItem2], mockUser);

    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('removing companies for a user', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1, mockCompanyListItem2], mockUser);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);

    reset(mockSharedPrefs);
    companyRepository.removeCompaniesForUser(mockUser);

    expect(companyRepository.getCompaniesForUser(mockUser), []);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
    expect(companyRepository.getSelectedEmployeeForUser(mockUser), null);
  });

  test('data is mapped correctly when storing', () async {
    companyRepository.saveCompaniesForUser([mockCompanyListItem1, mockCompanyListItem2], mockUser);
    reset(mockSharedPrefs);
    companyRepository.selectCompanyAndEmployeeForUser(mockCompany, mockEmployee, mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

    expect(verificationResult.captured[0], 'allUsersCompanies');
    expect(verificationResult.captured[1], {
      'someUserName': {
        'companies': [
          {'companyListItemOne': 'json'},
          {'companyListItemTwo': 'json'}
        ],
        'selectedCompany': {'company': 'json'},
        'selectedEmployee': {'employee': 'json'},
      },
    });
  });

  test('data is mapped correctly while reading from the storage', () async {
    var user1 = MockUser();
    var user2 = MockUser();
    var userWhoseCompaniesAreNotStored = MockUser();
    when(user1.username).thenReturn('username1');
    when(user2.username).thenReturn('username2');
    when(mockSharedPrefs.getMap('allUsersCompanies')).thenAnswer(
      (_) => Future.value({
        'username1': {
          'companies': Mocks.companiesListResponse,
          'selectedCompany': null,
          'selectedEmployee': null,
        },
        'username2': {
          'companies': Mocks.companiesListResponse,
          'selectedCompany': Mocks.companyDetailsResponse,
          'selectedEmployee': Mocks.companyDetailsResponse,
        },
      }),
    );

    companyRepository = CompanyRepository.withSharedPrefs(mockSharedPrefs);
    //awaiting because the shared prefs get method is async and takes a few ms to load
    //This will not be an issue in the actual app because the repo is initialized when the
    //app starts and there is time before it is actually used.
    await Future.delayed(Duration(milliseconds: 50));

    expect(companyRepository.getCompaniesForUser(userWhoseCompaniesAreNotStored).length, 0);
    expect(companyRepository.getSelectedCompanyForUser(userWhoseCompaniesAreNotStored), null);
    expect(companyRepository.getSelectedEmployeeForUser(userWhoseCompaniesAreNotStored), null);

    expect(companyRepository.getCompaniesForUser(user1).length, 2);
    expect(companyRepository.getSelectedCompanyForUser(user1), null);
    expect(companyRepository.getSelectedEmployeeForUser(user1), null);

    expect(companyRepository.getCompaniesForUser(user2).length, 2);
    var selectedCompanyId = '${Mocks.companyDetailsResponse['company_id']}';
    var selectedEmployeeId = '${Mocks.companyDetailsResponse['employee']['employment_id_v1']}';
    expect(companyRepository.getSelectedCompanyForUser(user2).id, selectedCompanyId);
    expect(companyRepository.getSelectedEmployeeForUser(user2).v1Id, selectedEmployeeId);
  });
}

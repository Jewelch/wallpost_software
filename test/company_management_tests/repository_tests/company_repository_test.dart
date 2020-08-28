import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

import '../../_mocks/mock_user.dart';
import '../../shared_utils_tests/user_management_tests/repository_tests/user_repository_test.dart';
import '../mocks.dart';

class MockCompany extends Mock implements Company {}

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  var mockSharedPrefs = MockSharedPrefs();
  CompanyRepository companyRepository;

  setUp(() {
    reset(mockUser);
    reset(mockSharedPrefs);
    companyRepository = CompanyRepository.withSharedPrefs(mockSharedPrefs);
  });

  test('reading companies data on initialization when no data is available', () async {
    var verificationResult = verify(mockSharedPrefs.getMap(captureAny));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'allUsersCompanies');
  });

  test('reading companies data on initialization when data is available', () async {
    var selectedCompanyId = '${Mocks.companiesListResponse[0]['companyId']}';
    var user1 = MockUser();
    var user2 = MockUser();
    var userWhoseCompaniesAreNotStored = MockUser();
    when(user1.username).thenReturn('username1');
    when(user2.username).thenReturn('username2');
    when(mockSharedPrefs.getMap('allUsersCompanies')).thenAnswer(
      (_) => Future.value({
        'username1': {'companies': Mocks.companiesListResponse, 'selectedCompanyId': null},
        'username2': {'companies': Mocks.companiesListResponse, 'selectedCompanyId': selectedCompanyId},
      }),
    );

    companyRepository = CompanyRepository.withSharedPrefs(mockSharedPrefs);
    //awaiting because the shared prefs get method is async and takes a few ms to load
    //This will not be an issue in the actual app because the repo is initialized when the
    //app starts and there is time before it is actually used.
    await Future.delayed(Duration(milliseconds: 200));

    expect(companyRepository.getCompaniesForUser(user1).length, 2);
    expect(companyRepository.getSelectedCompanyForUser(user1), null);
    expect(companyRepository.getCompaniesForUser(user2).length, 2);
    expect(companyRepository.getSelectedCompanyForUser(user2).companyId, selectedCompanyId);
    expect(companyRepository.getCompaniesForUser(userWhoseCompaniesAreNotStored).length, 0);
    expect(companyRepository.getSelectedCompanyForUser(userWhoseCompaniesAreNotStored), null);
  });

  test('saving companies for a user, saves the companies in memory as well as locally', () async {
    when(mockUser.username).thenReturn('someUserName');
    when(mockCompany.toJson()).thenReturn({'company': 'json'});

    companyRepository.saveCompaniesForUser([mockCompany], mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'allUsersCompanies');
    expect(verificationResult.captured[1], {
      'someUserName': {
        'companies': [
          {'company': 'json'}
        ],
        'selectedCompanyId': null,
      },
    });
    expect(companyRepository.getCompaniesForUser(mockUser).length, 1);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });

  test('saving companies for a user that already exists, replaces the companies for that user', () async {
    when(mockUser.username).thenReturn('someUserName');
    when(mockCompany.toJson()).thenReturn({'company': 'json'});
    companyRepository.saveCompaniesForUser([mockCompany], mockUser);

    reset(mockSharedPrefs);
    var anotherCompany = MockCompany();
    when(anotherCompany.toJson()).thenReturn({'different': 'company'});
    companyRepository.saveCompaniesForUser([anotherCompany], mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

    expect(verificationResult.captured[1], {
      'someUserName': {
        'companies': [
          {'different': 'company'}
        ],
        'selectedCompanyId': null,
      },
    });
    expect(companyRepository.getCompaniesForUser(mockUser)[0], anotherCompany);
  });

  test('selecting a company, saves the data in memory as well as locally', () async {
    var mockCompany1 = MockCompany();
    var mockCompany2 = MockCompany();
    when(mockUser.username).thenReturn('someUserName');
    when(mockCompany1.companyId).thenReturn('1');
    when(mockCompany2.companyId).thenReturn('2');
    when(mockCompany1.toJson()).thenReturn({'company': '1'});
    when(mockCompany2.toJson()).thenReturn({'company': '2'});
    companyRepository.saveCompaniesForUser([mockCompany1, mockCompany2], mockUser);

    reset(mockSharedPrefs);
    companyRepository.selectCompanyForUser(mockCompany2, mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

    expect(verificationResult.captured[1], {
      'someUserName': {
        'companies': [
          {'company': '1'},
          {'company': '2'}
        ],
        'selectedCompanyId': '2',
      },
    });
    expect(companyRepository.getSelectedCompanyForUser(mockUser), mockCompany2);
  });

  test('selecting a company for a user that does not exist does nothing', () async {
    var someOtherUser = MockUser();
    var mockCompany1 = MockCompany();
    var mockCompany2 = MockCompany();
    when(mockUser.username).thenReturn('someUserName');
    when(someOtherUser.username).thenReturn('nonExistentUser');
    when(mockCompany1.companyId).thenReturn('1');
    when(mockCompany2.companyId).thenReturn('2');
    when(mockCompany1.toJson()).thenReturn({'company': '1'});
    when(mockCompany2.toJson()).thenReturn({'company': '2'});
    companyRepository.saveCompaniesForUser([mockCompany1, mockCompany2], mockUser);

    reset(mockSharedPrefs);
    companyRepository.selectCompanyForUser(mockCompany2, someOtherUser);

    verifyNever(mockSharedPrefs.saveMap(any, any));
    expect(companyRepository.getCompaniesForUser(someOtherUser), []);
  });

  test('selecting a company that does not exist does nothing', () async {
    var mockCompany1 = MockCompany();
    var mockCompany2 = MockCompany();
    var someOtherCompany = MockCompany();
    when(mockUser.username).thenReturn('someUserName');
    when(mockCompany1.companyId).thenReturn('1');
    when(mockCompany2.companyId).thenReturn('2');
    when(someOtherCompany.companyId).thenReturn('nonExistentCompany');
    when(mockCompany1.toJson()).thenReturn({'company': '1'});
    when(mockCompany2.toJson()).thenReturn({'company': '2'});
    companyRepository.saveCompaniesForUser([mockCompany1, mockCompany2], mockUser);

    reset(mockSharedPrefs);
    companyRepository.selectCompanyForUser(someOtherCompany, mockUser);

    verifyNever(mockSharedPrefs.saveMap(any, any));
    expect(companyRepository.getCompaniesForUser(mockUser), [mockCompany1, mockCompany2]);
    expect(companyRepository.getSelectedCompanyForUser(mockUser), null);
  });

  test('removing companies for a user', () async {
    var mockUser2 = MockUser();
    var mockCompany1 = MockCompany();
    var mockCompany2 = MockCompany();
    when(mockUser.username).thenReturn('user1');
    when(mockUser2.username).thenReturn('user2');
    when(mockCompany1.toJson()).thenReturn({'company': '1'});
    when(mockCompany2.toJson()).thenReturn({'company': '2'});
    companyRepository.saveCompaniesForUser([mockCompany1], mockUser);
    companyRepository.saveCompaniesForUser([mockCompany2], mockUser2);

    reset(mockSharedPrefs);
    companyRepository.removeCompaniesForUser(mockUser2);

    expect(companyRepository.getCompaniesForUser(mockUser), [mockCompany1]);
    expect(companyRepository.getCompaniesForUser(mockUser2), []);
  });
}

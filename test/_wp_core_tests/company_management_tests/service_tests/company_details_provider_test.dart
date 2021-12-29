// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/constants/company_management_urls.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/company_management/services/company_details_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_current_user_provider.dart';
import '../../../_mocks/mock_employee.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../../../_mocks/mock_user.dart';
import '../mocks.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  Map<String, dynamic> successfulResponse = Mocks.companyDetailsResponse;
  var mockUser = MockUser();
  var mockUserProvider = MockCurrentUserProvider();
  var mockCompanyRepository = MockCompanyRepository();
  var mockNetworkAdapter = MockNetworkAdapter();
  var companyDetailsProvider = CompanyDetailsProvider.initWith(
    mockUserProvider,
    mockCompanyRepository,
    mockNetworkAdapter,
  );

  setUpAll(() {
    registerFallbackValue(MockUser());
    registerFallbackValue(MockCompany());
    registerFallbackValue(MockEmployee());
    when(() => mockUserProvider.getCurrentUser()).thenReturn(mockUser);
  });

  setUp(() {
    reset(mockCompanyRepository);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');

    expect(mockNetworkAdapter.apiRequest.url, CompanyManagementUrls.getCompanyDetailsUrl('someCompanyId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    companyDetailsProvider.getCompanyDetails('someCompanyId').then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    companyDetailsProvider.getCompanyDetails('someCompanyId').then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');
      verify(() => mockCompanyRepository.selectCompanyAndEmployeeForUser(any(), any(), any())).called(1);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    companyDetailsProvider.getCompanyDetails('someCompanyId');

    expect(companyDetailsProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');

    expect(companyDetailsProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await companyDetailsProvider.getCompanyDetails('someCompanyId');
      fail('failed to throw exception');
    } catch (_) {
      expect(companyDetailsProvider.isLoading, false);
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_my_portal/constants/my_portal_dashboard_urls.dart';
import 'package:wallpost/dashboard/company_dashboard_my_portal/services/owner_my_portal_data_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.ownerMyPortalDataResponse;
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var myPortalDataProvider = OwnerMyPortalDataProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => company.currency).thenReturn("USD");
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await myPortalDataProvider.get(month: 1, year: 2022);

    expect(mockNetworkAdapter.apiRequest.url, MyPortalDashboardUrls.ownerMyPortalDataUrl('someCompanyId', 1, 2022));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await myPortalDataProvider.get(month: 1, year: 2022);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    myPortalDataProvider.get(month: 1, year: 2022).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    myPortalDataProvider.get(month: 1, year: 2022).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await myPortalDataProvider.get(month: 1, year: 2022);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await myPortalDataProvider.get(month: 1, year: 2022);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when response mapping fails', () async {
    mockNetworkAdapter.succeed(Map<String, dynamic>());

    try {
      var _ = await myPortalDataProvider.get(month: 1, year: 2022);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var attendanceDetails = await myPortalDataProvider.get(month: 1, year: 2022);
      expect(attendanceDetails, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    myPortalDataProvider.get(month: 1, year: 2022);

    expect(myPortalDataProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await myPortalDataProvider.get(month: 1, year: 2022);

    expect(myPortalDataProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await myPortalDataProvider.get(month: 1, year: 2022);
      fail('failed to throw exception');
    } catch (_) {
      expect(myPortalDataProvider.isLoading, false);
    }
  });
}

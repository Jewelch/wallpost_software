import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/crm/dashboard/constants/crm_dashboard_urls.dart';
import 'package:wallpost/crm/dashboard/services/crm_dashboard_data_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.crmDashboardResponse;
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var dataProvider = CrmDashboardDataProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await dataProvider.get(month: 1, year: 2022);

    expect(mockNetworkAdapter.apiRequest.url, CrmDashboardUrls.getDashboardDataUrl('someCompanyId', 1, 2022));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await dataProvider.get(month: 1, year: 2022);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    dataProvider.get(month: 1, year: 2022).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    dataProvider.get(month: 1, year: 2022).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await dataProvider.get(month: 1, year: 2022);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await dataProvider.get(month: 1, year: 2022);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when response mapping fails', () async {
    Map<String, dynamic> response = {"some": "data"};
    mockNetworkAdapter.succeed(response);

    try {
      var _ = await dataProvider.get(month: 1, year: 2022);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      print(e);
      expect(e is InvalidResponseException, true);
    }
  });

  test('returns empty data if the response is a list', () async {
    List<Map<String, dynamic>> response = [];
    mockNetworkAdapter.succeed(response);

    try {
      var crmData = await dataProvider.get(month: 1, year: 2022);
      expect(crmData, isNotNull);
      expect(crmData.salesThisYear, "0");
      expect(crmData.targetAchievedPercentage, "0");
      expect(crmData.inPipeline, "0");
      expect(crmData.leadConversionPercentage, "0");
      expect(crmData.salesGrowthPercentage, "0");
      expect(crmData.staffPerformances.isEmpty, true);
      expect(crmData.servicePerformances.isEmpty, true);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var crmData = await dataProvider.get(month: 1, year: 2022);
      expect(crmData, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    dataProvider.get(month: 1, year: 2022);

    expect(dataProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await dataProvider.get(month: 1, year: 2022);

    expect(dataProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await dataProvider.get(month: 1, year: 2022);
      fail('failed to throw exception');
    } catch (_) {
      expect(dataProvider.isLoading, false);
    }
  });
}

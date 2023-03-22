import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/hourly_sales/constants/hourly_sales_urls.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/hourly_sales/entities/hourly_sales_report_filters.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/hourly_sales/services/hourly_sales_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

main() {
  final successfulResponse = hourlySalesReportSuccessfulResponse;

  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var hourlySalesFilter = HourlySalesReportFilters();
  var hourlySalesReportProvider = HourlySalesProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('hourlySalesReportProvider API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);
    expect(mockNetworkAdapter.apiRequest.url, HourlySalesUrls.getHourSalesUrl('someCompanyId', hourlySalesFilter));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('hourlySalesReportProvider API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('hourlySalesReportProvider API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('hourlySalesReportProvider API throws <WrongResponseFormatException> when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('hourlySalesReportProvider API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    hourlySalesReportProvider.getHourlySales(hourlySalesFilter).then((_) {
      fail('Received the response for thefirst request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    hourlySalesReportProvider.getHourlySales(hourlySalesFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('hourlySalesReportProvider API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    hourlySalesReportProvider.getHourlySales(hourlySalesFilter);

    expect(hourlySalesReportProvider.isLoading, true);
  });

  test('loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);

    expect(hourlySalesReportProvider.isLoading, false);
  });

  test('loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await hourlySalesReportProvider.getHourlySales(hourlySalesFilter);
      fail('failed to throw exception');
    } catch (_) {
      expect(hourlySalesReportProvider.isLoading, false);
    }
  });
}

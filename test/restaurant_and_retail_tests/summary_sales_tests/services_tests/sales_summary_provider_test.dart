import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/sales_summary/constants/sales_summary_urls.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/sales_summary/services/sales_summary_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../_mocks.dart';

main() {
  final successfulResponse = successfulSalesSummaryResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var dateFilter = DateRangeFilters();
  var salesSummaryReportProvider = SalesSummaryProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('SalesSummaryReportProvider API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await salesSummaryReportProvider.getSummarySales(dateFilter);

    expect(mockNetworkAdapter.apiRequest.url, SummarySalesUrls.getSummarySalesUrl('someCompanyId', dateFilter));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('SalesSummaryReportProvider API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesSummaryReportProvider.getSummarySales(dateFilter);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('SalesSummaryReportProvider API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await salesSummaryReportProvider.getSummarySales(dateFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesSummaryReportProvider API throws <WrongResponseFormatException> when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await salesSummaryReportProvider.getSummarySales(dateFilter);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('SalesSummaryReportProvider API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    salesSummaryReportProvider.getSummarySales(dateFilter).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    salesSummaryReportProvider.getSummarySales(dateFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('SalesSummaryReportProvider API throws <InvalidResponseException> when item mapping fails', () async {
    mockNetworkAdapter.succeed({"summary": {}});

    try {
      await salesSummaryReportProvider.getSummarySales(dateFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesSummaryReportProvider API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await salesSummaryReportProvider.getSummarySales(dateFilter);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    salesSummaryReportProvider.getSummarySales(dateFilter);

    expect(salesSummaryReportProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await salesSummaryReportProvider.getSummarySales(dateFilter);

    expect(salesSummaryReportProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesSummaryReportProvider.getSummarySales(dateFilter);
      fail('failed to throw exception');
    } catch (_) {
      expect(salesSummaryReportProvider.isLoading, false);
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/constants/orders_summary_urls.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/services/orders_summary_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../_mocks.dart';

main() {
  final successfulResponse = successfulOrdersSummaryResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var dateFilter = DateRange();
  var ordersSummaryReportProvider = OrdersSummaryProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('OrdersSummaryReportProvider API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await ordersSummaryReportProvider.getNext(dateFilter);

    expect(mockNetworkAdapter.apiRequest.url, OrdersSummaryUrls.ordersSummaryList('someCompanyId', dateFilter, 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('OrdersSummaryReportProvider API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await ordersSummaryReportProvider.getNext(dateFilter);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('OrdersSummaryReportProvider API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await ordersSummaryReportProvider.getNext(dateFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('OrdersSummaryReportProvider API throws <WrongResponseFormatException> when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await ordersSummaryReportProvider.getNext(dateFilter);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('OrdersSummaryReportProvider API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    ordersSummaryReportProvider.getNext(dateFilter).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    ordersSummaryReportProvider.getNext(dateFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('OrdersSummaryReportProvider API throws <InvalidResponseException> when item mapping fails', () async {
    mockNetworkAdapter.succeed({"summary": {}});

    try {
      await ordersSummaryReportProvider.getNext(dateFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('OrdersSummaryReportProvider API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await ordersSummaryReportProvider.getNext(dateFilter);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    ordersSummaryReportProvider.getNext(dateFilter);

    expect(ordersSummaryReportProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await ordersSummaryReportProvider.getNext(dateFilter);

    expect(ordersSummaryReportProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await ordersSummaryReportProvider.getNext(dateFilter);
      fail('failed to throw exception');
    } catch (_) {
      expect(ordersSummaryReportProvider.isLoading, false);
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    ordersSummaryReportProvider.reset();
    try {
      expect(ordersSummaryReportProvider.getCurrentPageNumber(), 1);
      await ordersSummaryReportProvider.getNext(DateRange());
      expect(ordersSummaryReportProvider.getCurrentPageNumber(), 2);
      await ordersSummaryReportProvider.getNext(DateRange());
      expect(ordersSummaryReportProvider.getCurrentPageNumber(), 3);
      await ordersSummaryReportProvider.getNext(DateRange());
      expect(ordersSummaryReportProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}

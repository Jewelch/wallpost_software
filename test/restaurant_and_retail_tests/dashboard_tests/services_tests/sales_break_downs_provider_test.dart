import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/constants/dashboard_urls.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/services/sales_breakdowns_provider.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/ui/views/screens/dashboard_screen.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../../mocks.dart';

void main() {
  List<Map<String, dynamic>> successfulResponse = Mocks.salesBreakDownsData;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var salesBreakDownsProvider = SalesBreakDownsProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);
  var dateFilter = DateRangeFilters();
  var salesBreakDownWiseOption = SalesBreakDownWiseOptions.basedOnMenu;

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('SalesBreakDown Provider request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);

    expect(
        mockNetworkAdapter.apiRequest.url,
        DashboardUrls.getSalesBreakDownsUrl(
          'someCompanyId',
          salesBreakDownWiseOption,
          dateFilter,
          DashboardContext.restaurant,
        ));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('SalesBreakDown Provider throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('SalesBreakDown Provider throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesBreakDown Provider throws <WrongResponseFormatException> when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('SalesBreakDown Provider throws <InvalidResponseException> when entity mapping fails', () async {
    mockNetworkAdapter.succeed(List<Map<String, dynamic>>.from([
      <String, dynamic>{"miss_data": "anyWrongData"}
    ]));

    try {
      await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesBreakDown Provider response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('SalesBreakDown Provider succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);

    expect(salesBreakDownsProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);

    expect(salesBreakDownsProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesBreakDownsProvider.getSalesBreakDowns(salesBreakDownWiseOption, dateFilter);
      fail('failed to throw exception');
    } catch (_) {
      expect(salesBreakDownsProvider.isLoading, false);
    }
  });
}

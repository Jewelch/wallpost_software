import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/constants/restaurant_dashboard_urls.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/aggregated_sales_data_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_company_repository.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.salesDataRandomResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockCompanyRepository = MockCompanyRepository();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var dateFilter = DateRangeFilters();
  var salesDataProvider = AggregatedSalesDataProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  setUp(() {
    reset(mockCompanyRepository);
  });

  test('SalesAmounts API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await salesDataProvider.getSalesAmounts(dateFilter, storeId: 'someStoreId');

    expect(mockNetworkAdapter.apiRequest.url,
        RestaurantDashboardUrls.getSalesAmountsUrl('someCompanyId', 'someStoreId', dateFilter));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('SalesAmounts API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesDataProvider.getSalesAmounts(dateFilter, storeId: 'someStoreId');
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('SalesAmounts API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await salesDataProvider.getSalesAmounts(dateFilter, storeId: 'someStoreId');
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesAmounts API throws <WrongResponseFormatException> when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await salesDataProvider.getSalesAmounts(dateFilter, storeId: 'someStoreId');
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('SalesAmounts API throws <InvalidResponseException> when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{"miss_data": "anyWrongData"});

    try {
      await salesDataProvider.getSalesAmounts(dateFilter, storeId: 'someStoreId');
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesAmounts API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    salesDataProvider.getSalesAmounts(dateFilter).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    salesDataProvider.getSalesAmounts(dateFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('SalesAmounts API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await salesDataProvider.getSalesAmounts(dateFilter, storeId: "someStoreId");
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    salesDataProvider.getSalesAmounts(dateFilter, storeId: "someStoreId");

    expect(salesDataProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await salesDataProvider.getSalesAmounts(dateFilter, storeId: "someStoreId");

    expect(salesDataProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesDataProvider.getSalesAmounts(dateFilter, storeId: "someStoreId");
      fail('failed to throw exception');
    } catch (_) {
      expect(salesDataProvider.isLoading, false);
    }
  });
}

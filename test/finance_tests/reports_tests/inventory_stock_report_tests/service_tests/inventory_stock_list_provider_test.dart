import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_report_filter.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/services/inventory_stock_report_provider.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockWarehouse extends Mock implements InventoryStockWarehouse {}

void main() {
  Map<String, dynamic> successfulResponse = Mocks.inventoryStockReportResponse;
  late InventoryStockReportFilter filters;
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  late InventoryStockReportProvider reportProvider;

  setUp(() {
    reset(mockCompanyProvider);
    var company = MockCompany();
    when(() => company.id).thenReturn('someCompanyId');
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    mockNetworkAdapter.reset();
    filters = InventoryStockReportFilter();
    reportProvider = InventoryStockReportProvider.initWith(mockCompanyProvider, mockNetworkAdapter);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);
    var warehouse = MockWarehouse();
    when(() => warehouse.id).thenReturn("someWarehouseId");
    filters.date = DateTime(2022, 12, 1);
    filters.warehouse = warehouse;
    filters.searchText = "someText";

    var _ = await reportProvider.getNext(filters);

    expect(
        mockNetworkAdapter.apiRequest.url,
        "https://hr.api.wallpostsoftware.com/api/v3/companies/someCompanyId/finance/inventory/stock_report?"
        "date=2022-12-01&"
        "search=someText&"
        "warehouse=someWarehouseId&"
        "page=1&perPage=15&consumedByMobile=true");
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('url when there is no search text and warehouse', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    filters.date = DateTime(2022, 12, 1);
    var _ = await reportProvider.getNext(filters);

    expect(
        mockNetworkAdapter.apiRequest.url,
        "https://hr.api.wallpostsoftware.com/api/v3/companies/someCompanyId/finance/inventory/stock_report?"
        "date=2022-12-01&"
        "page=1&perPage=15&consumedByMobile=true");
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await reportProvider.getNext(filters);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    reportProvider.getNext(filters).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    reportProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    reportProvider.getNext(filters).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await reportProvider.getNext(filters);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await reportProvider.getNext(filters);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await reportProvider.getNext(filters);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    var report = await reportProvider.getNext(filters);
    expect(report.total, "200");
    expect(report.items.length, 2);

    mockNetworkAdapter.succeed(Mocks.inventoryStockReportResponsePage2);
    report = await reportProvider.getNext(filters);
    expect(report.total, "300");
    expect(report.items.length, 3);
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    reportProvider.reset();
    try {
      expect(reportProvider.getCurrentPageNumber(), 1);
      await reportProvider.getNext(filters);
      expect(reportProvider.getCurrentPageNumber(), 2);
      await reportProvider.getNext(filters);
      expect(reportProvider.getCurrentPageNumber(), 3);
      await reportProvider.getNext(filters);
      expect(reportProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    reportProvider.getNext(filters);

    expect(reportProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await reportProvider.getNext(filters);

    expect(reportProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await reportProvider.getNext(filters);
      fail('failed to throw exception');
    } catch (_) {
      expect(reportProvider.isLoading, false);
    }
  });
}

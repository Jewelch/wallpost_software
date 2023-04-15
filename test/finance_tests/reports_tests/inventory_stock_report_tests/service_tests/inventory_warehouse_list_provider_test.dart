import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/services/inventory_warehouse_list_provider.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  var successfulResponse = Mocks.warehouseListResponse;
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var warehouseListProvider = InventoryWarehouseListProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await warehouseListProvider.getAll();

    expect(
      mockNetworkAdapter.apiRequest.url,
      "https://misc.api.wallpostsoftware.com/api/v2/crm/companies/someCompanyId/warehouses",
    );
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await warehouseListProvider.getAll();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    warehouseListProvider.getAll().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    warehouseListProvider.getAll().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await warehouseListProvider.getAll();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await warehouseListProvider.getAll();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when response mapping fails', () async {
    mockNetworkAdapter.succeed([Map<String, dynamic>()]);

    try {
      var _ = await warehouseListProvider.getAll();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var warehouses = await warehouseListProvider.getAll();

    expect(warehouses.length, 4);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await warehouseListProvider.getAll();

    expect(warehouseListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await warehouseListProvider.getAll();
      fail('failed to throw exception');
    } catch (_) {
      expect(warehouseListProvider.isLoading, false);
    }
  });
}

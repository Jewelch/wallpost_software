import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/expense_requests/constants/requests_urls.dart';
import 'package:wallpost/expense_requests/services/expense_categories_provider.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../_mocks/expense_categories_mock.dart';

void main() {
  var successfulResponse = expenseCategoriesListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var expenseCategoriesProvider = ExpenseCategoriesProvider.initWith(mockNetworkAdapter);
  var companyId = "13";

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await expenseCategoriesProvider.get(companyId);

    expect(mockNetworkAdapter.apiRequest.url,
        RequestsUrls.getExpenseRequestUrl(companyId));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await expenseCategoriesProvider.get(companyId);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await expenseCategoriesProvider.get(companyId);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test(
      'throws WrongResponseFormatException when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await expenseCategoriesProvider.get(companyId);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{
      "miss_data":"anyWrongData"
    }]);

    try {
      var _ = await expenseCategoriesProvider.get(companyId);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      print(e.runtimeType);
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var requestItems = await expenseCategoriesProvider.get(companyId);
      expect(requestItems, isNotEmpty);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}

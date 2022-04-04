import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_requests/constants/expense_requests_urls.dart';
import 'package:wallpost/expense_requests/services/expense_categories_provider.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../_mocks/expense_categories_mock.dart';

class MockSelectedCompanyProvider extends Mock implements SelectedCompanyProvider {}

class MockCompany extends Mock implements Company {}

void main() {
  var successfulResponse = expenseCategoriesListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockSelectedCompanyProvider();
  var expenseCategoriesProvider =
      ExpenseCategoriesProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);
  var companyId = "13";
  var mockCompany = MockCompany();

  setUpAll(() {
    when(() => mockCompany.id).thenReturn(companyId);
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser())
        .thenReturn(mockCompany);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await expenseCategoriesProvider.get();

    expect(
        mockNetworkAdapter.apiRequest.url, ExpenseRequestsUrls.getExpenseCategoriesUrl(companyId));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await expenseCategoriesProvider.get();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    expenseCategoriesProvider.get();

    expect(expenseCategoriesProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await expenseCategoriesProvider.get();

    expect(expenseCategoriesProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await expenseCategoriesProvider.get();
      fail('failed to throw exception');
    } catch (_) {
      expect(expenseCategoriesProvider.isLoading, false);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    expenseCategoriesProvider.get().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    expenseCategoriesProvider.get().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await expenseCategoriesProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await expenseCategoriesProvider.get();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([
      <String, dynamic>{"miss_data": "anyWrongData"}
    ]);

    try {
      var _ = await expenseCategoriesProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      print(e.runtimeType);
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var requestItems = await expenseCategoriesProvider.get();
      expect(requestItems, isNotEmpty);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}

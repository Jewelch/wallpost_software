import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/reports/stock_expiration/constants/stock_expiration_urls.dart';
import 'package:wallpost/finance/reports/stock_expiration/services/stock_expiration_provider.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  var successfulResponse = Mocks.stockExpirationListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var stocksExpirationProvider = StocksExpirationProvider.initWith(
    mockNetworkAdapter,
    mockSelectedCompanyProvider,
  );

  void resetProvider() {
    stocksExpirationProvider = StocksExpirationProvider.initWith(
      mockNetworkAdapter,
      mockSelectedCompanyProvider,
    );
  }

  setUpAll(() {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('api request is built correctly when isExpired = true', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await stocksExpirationProvider.getNext(true,0);

    expect(mockNetworkAdapter.apiRequest.url, StocksExpirationUrls.getExpiredUrl("someCompanyId", 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('api request is built correctly when isExpired = false', () async {
    resetProvider();
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await stocksExpirationProvider.getNext(false, 30);

    expect(mockNetworkAdapter.apiRequest.url, StocksExpirationUrls.getExpiredInDaysUrl("someCompanyId", 30, 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await stocksExpirationProvider.getNext(true,0);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    stocksExpirationProvider.getNext(true,0).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    stocksExpirationProvider.getNext(true,0).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await stocksExpirationProvider.getNext(true,0);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await stocksExpirationProvider.getNext(true,0);
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
      var _ = await stocksExpirationProvider.getNext(true,0);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var requestItems = await stocksExpirationProvider.getNext(true,0);
      expect(requestItems, isNotEmpty);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    stocksExpirationProvider.reset();
    try {
      expect(stocksExpirationProvider.getCurrentPageNumber(), 1);
      await stocksExpirationProvider.getNext(true,0);
      expect(stocksExpirationProvider.getCurrentPageNumber(), 2);
      await stocksExpirationProvider.getNext(true,0);
      expect(stocksExpirationProvider.getCurrentPageNumber(), 3);
      await stocksExpirationProvider.getNext(true,0);
      expect(stocksExpirationProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true while the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    stocksExpirationProvider.getNext(true,0);

    expect(stocksExpirationProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await stocksExpirationProvider.getNext(true,0);

    expect(stocksExpirationProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await stocksExpirationProvider.getNext(true,0);
      fail('failed to throw exception');
    } catch (_) {
      expect(stocksExpirationProvider.isLoading, false);
    }
  });
}

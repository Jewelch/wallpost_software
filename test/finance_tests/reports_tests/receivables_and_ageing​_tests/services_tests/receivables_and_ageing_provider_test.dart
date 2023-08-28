import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/constants/receivables_and_ageing%E2%80%8B_urls.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/services/receivables_and_ageing_provider.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

main() {
  final successfulResponse = Mocks.receivablesResponse;

  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var receivablesProvider = ReceivablesProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('receivablesProvider API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await receivablesProvider.getReceivables();

    expect(mockNetworkAdapter.apiRequest.url, ReceivablesUrls.getUrl('someCompanyId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('receivablesProvider API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await receivablesProvider.getReceivables();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('receivablesProvider API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await receivablesProvider.getReceivables();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('receivablesProvider API throws <WrongResponseFormatException> when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await receivablesProvider.getReceivables();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('receivablesProvider API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    receivablesProvider.getReceivables().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    receivablesProvider.getReceivables().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('receivablesProvider API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await receivablesProvider.getReceivables();
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    receivablesProvider.getReceivables();

    expect(receivablesProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await receivablesProvider.getReceivables();

    expect(receivablesProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await receivablesProvider.getReceivables();
      fail('failed to throw exception');
    } catch (_) {
      expect(receivablesProvider.isLoading, false);
    }
  });
}

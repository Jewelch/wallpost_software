import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/reports/balance_sheet/constants/balance_sheet_urls.dart';
import 'package:wallpost/finance/reports/balance_sheet/services/balance_sheet_provider.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

main() {
  final successfulResponse = Mocks.balanceSheetReportResponse;

  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var dateFilter = DateRange();
  var balanceSheetReportProvider = BalanceSheetProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('BalanceSheetReportProvider API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await balanceSheetReportProvider.getBalance(dateFilter);

    expect(mockNetworkAdapter.apiRequest.url, BalanceSheetUrls.getBalanceSheetUrl('someCompanyId', dateFilter));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('BalanceSheetReportProvider API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await balanceSheetReportProvider.getBalance(
        dateFilter,
      );
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('BalanceSheetReportProvider API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await balanceSheetReportProvider.getBalance(
        dateFilter,
      );
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('BalanceSheetReportProvider API throws <WrongResponseFormatException> when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await balanceSheetReportProvider.getBalance(
        dateFilter,
      );
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('BalanceSheetReportProvider API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    balanceSheetReportProvider.getBalance(dateFilter).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    balanceSheetReportProvider.getBalance(dateFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('BalanceSheetReportProvider API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await balanceSheetReportProvider.getBalance(
        dateFilter,
      );
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    balanceSheetReportProvider.getBalance(
      dateFilter,
    );

    expect(balanceSheetReportProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await balanceSheetReportProvider.getBalance(
      dateFilter,
    );

    expect(balanceSheetReportProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await balanceSheetReportProvider.getBalance(
        dateFilter,
      );
      fail('failed to throw exception');
    } catch (_) {
      expect(balanceSheetReportProvider.isLoading, false);
    }
  });
}

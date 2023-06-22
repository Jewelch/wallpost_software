import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/reports/profit_loss/constants/profit_loss_urls.dart';
import 'package:wallpost/finance/reports/profit_loss/services/profit_loss_provider.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

main() {
  final successfulResponse = Mocks.profitLossReportResponse;

  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompanyProvider = MockCompanyProvider();
  var dateFilter = DateRange();
  var profitLossReportProvider = ProfitsLossesProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('ProfitLossReportProvider API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await profitLossReportProvider.getProfitsLosses(dateFilter);

    expect(mockNetworkAdapter.apiRequest.url, ProfitsLossesUrls.getProfitsLossesUrl('someCompanyId', dateFilter));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('ProfitLossReportProvider API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await profitLossReportProvider.getProfitsLosses(
        dateFilter,
      );
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('ProfitLossReportProvider API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await profitLossReportProvider.getProfitsLosses(
        dateFilter,
      );
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('ProfitLossReportProvider API throws <WrongResponseFormatException> when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await profitLossReportProvider.getProfitsLosses(
        dateFilter,
      );
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('ProfitLossReportProvider API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    profitLossReportProvider.getProfitsLosses(dateFilter).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    profitLossReportProvider.getProfitsLosses(dateFilter).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('ProfitLossReportProvider API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await profitLossReportProvider.getProfitsLosses(
        dateFilter,
      );
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    profitLossReportProvider.getProfitsLosses(
      dateFilter,
    );

    expect(profitLossReportProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await profitLossReportProvider.getProfitsLosses(
      dateFilter,
    );

    expect(profitLossReportProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await profitLossReportProvider.getProfitsLosses(
        dateFilter,
      );
      fail('failed to throw exception');
    } catch (_) {
      expect(profitLossReportProvider.isLoading, false);
    }
  });
}

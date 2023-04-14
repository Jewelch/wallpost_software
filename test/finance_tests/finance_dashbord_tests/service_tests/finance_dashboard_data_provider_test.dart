import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/finance/dashboard/constants/finance_dashboard_urls.dart';
import 'package:wallpost/finance/dashboard/services/finance_dashboard_provider.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  var successfulResponse = Mocks.financialDashboardResponse;
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var financialDashBoardProvider = FinanceDashBoardProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => company.currency).thenReturn("USD");
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await financialDashBoardProvider.get(year: 2022, month: 1);

    expect(
        mockNetworkAdapter.apiRequest.url, FinanceDashBoardUrls.getFinanceInnerPageDetails("someCompanyId", 2022, 1));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await financialDashBoardProvider.get();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await financialDashBoardProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await financialDashBoardProvider.get();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when response mapping fails', () async {
    mockNetworkAdapter.succeed(Map<String, dynamic>());

    try {
      var _ = await financialDashBoardProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var financialDashboard = await financialDashBoardProvider.get();
    expect(financialDashboard.profitAndLoss, isNotNull);
    expect(financialDashboard.income, isNotNull);
    expect(financialDashboard.expenses, isNotNull);
    expect(financialDashboard.bankAndCash, isNotNull);
    expect(financialDashboard.cashIn, isNotNull);
    expect(financialDashboard.cashOut, isNotNull);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await financialDashBoardProvider.get();

    expect(financialDashBoardProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await financialDashBoardProvider.get();
      fail('failed to throw exception');
    } catch (_) {
      expect(financialDashBoardProvider.isLoading, false);
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/services/finance_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/models/manager_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/presenters/finance_performance_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';

class MockModulePerformanceView extends Mock implements ModulePerformanceView {}

class MockFinanceDataProvider extends Mock implements FinanceDashboardDataProvider {}

class MockFinancialSummary extends Mock implements FinancialSummary {}

void main() {
  var filters = ManagerDashboardFilters();
  var view = MockModulePerformanceView();
  var dataProvider = MockFinanceDataProvider();
  var companyProvider = MockCompanyProvider();
  late FinancePerformancePresenter presenter;

  setUp(() {
    var company = MockCompany();
    when(() => company.currency).thenReturn("USD");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    presenter = FinancePerformancePresenter.initWith(view, filters, dataProvider, companyProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
  }

  test('loading data when service is loading does nothing', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinancialSummary()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('error message is reset before getting the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    presenter.loadData();

    expect(presenter.errorMessage, "");
  });

  test("get profit and loss", () async {
    var data = MockFinancialSummary();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //negative
    when(() => data.profitLoss).thenReturn("-12000");
    when(() => data.isInProfit()).thenReturn(false);
    expect(presenter.getProfitLoss().label, "Profile & Loss (USD)");
    expect(presenter.getProfitLoss().value, "-12000");
    expect(presenter.getProfitLoss().textColor, AppColors.redOnDarkDefaultColorBg);

    //positive
    when(() => data.profitLoss).thenReturn("7000");
    when(() => data.isInProfit()).thenReturn(true);
    expect(presenter.getProfitLoss().label, "Profile & Loss (USD)");
    expect(presenter.getProfitLoss().value, "7000");
    expect(presenter.getProfitLoss().textColor, AppColors.greenOnDarkDefaultColorBg);
  });

  test("get available funds", () async {
    var data = MockFinancialSummary();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //negative
    when(() => data.availableFunds).thenReturn("-12000");
    when(() => data.areFundsAvailable()).thenReturn(false);
    expect(presenter.getAvailableFunds().label, "Available\nFunds");
    expect(presenter.getAvailableFunds().value, "-12000");
    expect(presenter.getAvailableFunds().textColor, AppColors.redOnDarkDefaultColorBg);

    //positive
    when(() => data.availableFunds).thenReturn("7000");
    when(() => data.areFundsAvailable()).thenReturn(true);
    expect(presenter.getAvailableFunds().label, "Available\nFunds");
    expect(presenter.getAvailableFunds().value, "7000");
    expect(presenter.getAvailableFunds().textColor, AppColors.greenOnDarkDefaultColorBg);
  });

  test("get receivables overdue", () async {
    var data = MockFinancialSummary();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //overdue
    when(() => data.receivableOverdue).thenReturn("10000");
    when(() => data.areReceivablesOverdue()).thenReturn(true);
    expect(presenter.getOverdueReceivables().label, "Receivables\nOverdue");
    expect(presenter.getOverdueReceivables().value, "10000");
    expect(presenter.getOverdueReceivables().textColor, AppColors.redOnDarkDefaultColorBg);

    //no overdue
    when(() => data.receivableOverdue).thenReturn("0");
    when(() => data.areReceivablesOverdue()).thenReturn(false);
    expect(presenter.getOverdueReceivables().label, "Receivables\nOverdue");
    expect(presenter.getOverdueReceivables().value, "0");
    expect(presenter.getOverdueReceivables().textColor, AppColors.greenOnDarkDefaultColorBg);
  });

  test("get payables overdue", () async {
    var data = MockFinancialSummary();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //overdue
    when(() => data.payableOverdue).thenReturn("10000");
    when(() => data.arePayablesOverdue()).thenReturn(true);
    expect(presenter.getOverduePayables().label, "Payables\nOverdue");
    expect(presenter.getOverduePayables().value, "10000");
    expect(presenter.getOverduePayables().textColor, AppColors.redOnDarkDefaultColorBg);

    //no overdue
    when(() => data.payableOverdue).thenReturn("0");
    when(() => data.arePayablesOverdue()).thenReturn(false);
    expect(presenter.getOverduePayables().label, "Payables\nOverdue");
    expect(presenter.getOverduePayables().value, "0");
    expect(presenter.getOverduePayables().textColor, AppColors.greenOnDarkDefaultColorBg);
  });
}

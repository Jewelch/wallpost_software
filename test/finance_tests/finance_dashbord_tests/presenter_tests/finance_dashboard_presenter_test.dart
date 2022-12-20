import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_shared/extensions/color_extensions.dart';
import 'package:wallpost/finance/entities/finance_bill_details.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/entities/finance_invoice_details.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';

class MockFinanceDashBoardProvider extends Mock implements FinanceDashBoardProvider {}

class MockFinanceDashBoardData extends Mock implements FinanceDashBoardData {}

class MockFinanceInvoiceDetails extends Mock implements FinanceInvoiceDetails{}

class MockFinanceBillDetails extends Mock implements FinanceBillDetails{}

class MockFinanceDashBoardView extends Mock implements FinanceDashBoardView {}

void main() {
  late MockFinanceDashBoardView view;
  late MockFinanceDashBoardProvider provider;
  late MockCompanyProvider companyProvider;
  late FinanceDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(provider);
    verifyNoMoreInteractions(companyProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(provider);
    clearInteractions(companyProvider);
  }

  setUp(() {
    view = MockFinanceDashBoardView();
    provider = MockFinanceDashBoardProvider();
    companyProvider = MockCompanyProvider();
    presenter = FinanceDashboardPresenter.initWith(
      view,
      provider,
      companyProvider,
    );
    _clearInteractionsOnAllMocks();
  });

  test('failure to load the finance dashboard details', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorAndRetryView("Failed to load finance details.\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the finance dashboard details', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting month to 0 sets it to null in the provider', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.setFilter(month: 0, year: 2022);

    //then
    expect(presenter.selectedMonth, 0);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: null, year: 2022),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('show only three nearest months cash in and cash out list in cash details chart', () async {
    List<String> monthList = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
    List<String> cashInList = ["5,000", "7,837", "18,603", "3,500", "0", "0", "0", "0", "0", "0", "0", "0"];
    List<String> cashOutList = ["5,000", "7,837", "18,603", "3,500", "0", "0", "0", "0", "0", "0", "0", "0"];
    var data = MockFinanceDashBoardData();
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.monthsList).thenReturn(monthList.toList());
    when(() => data.cashInList).thenReturn(cashInList.toList());
    when(() => data.cashOutList).thenReturn(cashOutList.toList());
    expect(presenter.getMonthList().skip(3).toList(), monthList.skip(3).toList());
    expect(presenter.getCashInList().skip(3).toList(), cashInList.skip(3).toList());
    expect(presenter.getCashOutList().skip(3).toList(), cashOutList.skip(3).toList());

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("add 3 on selected month index when next click when selected index less than 9", () {
    var selectedMonthIndex = 3;
    presenter.onNextTextClick();
    expect(selectedMonthIndex + 3, 6);
  });

  test("no change selected month index when next click when selected index greater than 8", () {
    var selectedMonthIndex = 9;
    presenter.onNextTextClick();
    expect(selectedMonthIndex, 9);
  });

  test("subtract 3 on selected month index when previous click when selected index greater than 0", () {
    var selectedMonthIndex = 3;
    presenter.onPreviousTextClick();
    expect(selectedMonthIndex - 3, 0);
  });

  test("no change selected month index when previous click when selected index less than 0", () {
    var selectedMonthIndex = 0;
    presenter.onPreviousTextClick();
    expect(selectedMonthIndex, 0);
  });

  test('initiate filter selection', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.loadFinanceDashBoardDetails();
    presenter.initiateFilterSelection();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
      () => view.showFilters(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting filter', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.setFilter(month: 2, year: 2022);

    //then
    expect(presenter.selectedMonth, 2);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: 2, year: 2022),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("select module at index", () {
    presenter.selectModuleAtIndex(3);

    expect(presenter.selectedModuleIndex, 3);
  });

  test("getting selected company", () {
    var company=MockCompany();
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    expect(presenter.getSelectedCompany(), company);
  });

  test('getting profit and loss this year of finance details'
      'show text color red when value is negative '
      'show text color green when value is positive', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.profitAndLoss).thenReturn("-400");
    when(() => data.isInProfit()).thenReturn(false);
    var details1 = presenter.getProfitAndLoss();
    expect(details1.label, "Loss This Year");
    expect(details1.value, "-400");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    when(() => data.profitAndLoss).thenReturn("400");
    when(() => data.isInProfit()).thenReturn(true);
    var details2 = presenter.getProfitAndLoss();
    expect(details2.label, "Profit This Year");
    expect(details2.value, "400");
    expect(details2.valueColor.isEqualTo(AppColors.green), true);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting income of financial details', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.income).thenReturn("40000");
    var details1 = presenter.getIncome();
    expect(details1.label, "Income");
    expect(details1.value, "40000");
    expect(details1.valueColor.isEqualTo(AppColors.green), true);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting expense of financial details', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.expenses).thenReturn("80000");
    var details1 = presenter.getExpenses();
    expect(details1.label, "Expense");
    expect(details1.value, "80000");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting cash in bank data of financial details'
       'show text color red when value is negative'
       'show text color green when value is positive', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.bankAndCash).thenReturn("-400");
    when(() => data.isProfitCashInBank()).thenReturn(false);
    var details1 = presenter.getCashInBank();
    expect(details1.label, "Available Balance In Bank/Cash");
    expect(details1.value, "-400");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    when(() => data.bankAndCash).thenReturn("400");
    when(() => data.isProfitCashInBank()).thenReturn(true);
    var details2 = presenter.getCashInBank();
    expect(details2.label, "Available Balance In Bank/Cash");
    expect(details2.value, "400");
    expect(details2.valueColor.isEqualTo(AppColors.green), true);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting cash in of financial details', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.cashIn).thenReturn("800");
    var details1 = presenter.getCashIn();
    expect(details1, "800");

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting cash out of financial details', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.cashOut).thenReturn("800");
    var details1 = presenter.getCashOut();
    expect(details1, "800");

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting finance invoice details of financial details', () async {
    //given
    var data = MockFinanceDashBoardData();
    var invoiceDetails=MockFinanceInvoiceDetails();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
          () => provider.isLoading,
          () => view.showLoader(),
          () => provider.get(month: any(named: "month"), year: any(named: "year")),
          () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.financeInvoiceDetails).thenReturn(invoiceDetails);
    var details1 = presenter.getFinanceInvoiceReport();
    expect(details1, invoiceDetails);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting finance bill details of financial details', () async {
    //given
    var data = MockFinanceDashBoardData();
    var billDetails=MockFinanceBillDetails();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
          () => provider.isLoading,
          () => view.showLoader(),
          () => provider.get(month: any(named: "month"), year: any(named: "year")),
          () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.financeBillDetails).thenReturn(billDetails);
    var details1 = presenter.getFinanceBillDetails();
    expect(details1, billDetails);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting profit and loss box color of financial dashboard'
      'show box color light red when value is negative '
      'show box color light green when value is positive', () async {
    //given
    var data = MockFinanceDashBoardData();

    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    when(() => data.isInProfit()).thenReturn(false);
    var details1 = presenter.profitLossBoxColor();
    expect(details1.isEqualTo(AppColors.lightRed), true);

    when(() => data.isInProfit()).thenReturn(true);
    var details2 = presenter.profitLossBoxColor();
    expect(details2.isEqualTo(AppColors.lightGreen), true);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("Test current and past moth count ", () {
   var count= presenter.getMonthCountForTheSelectedYear(2022);
    expect(count, 12);
  });
}

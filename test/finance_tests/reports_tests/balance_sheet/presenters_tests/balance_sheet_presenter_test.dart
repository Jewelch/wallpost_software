import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/reports/balance_sheet/entities/balance_sheet_data.dart';
import 'package:wallpost/finance/reports/balance_sheet/entities/profit_loss_report_filters.dart';
import 'package:wallpost/finance/reports/balance_sheet/services/balance_sheet_provider.dart';
import 'package:wallpost/finance/reports/balance_sheet/ui/presenters/balance_sheet_presenter.dart';
import 'package:wallpost/finance/reports/balance_sheet/ui/view_contracts/balance_sheet_view.dart';

import '../../../../_mocks/mock_company_provider.dart';
import '../mocks.dart';
import 'helpers.dart';

class MockBalanceSheetReportProvider extends Mock implements BalanceSheetProvider {}

class MockBalanceSheetReport extends Mock implements BalanceSheetData {}

class MockBalanceSheetView extends Mock implements BalanceSheetView {}

void main() {
  var mockBalanceSheetReportProvider = MockBalanceSheetReportProvider();
  var view = MockBalanceSheetView();
  var dateFilter = DateRange();
  late BalanceSheetPresenter presenter;

  void _initializePresenter() {
    presenter = BalanceSheetPresenter.initWith(
      view,
      mockBalanceSheetReportProvider,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockBalanceSheetReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(mockBalanceSheetReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockBalanceSheetReport());
    registerFallbackValue(dateFilter);
  });

  test('loading balance Sheet report when the provider is loading does nothing', () async {
    //given
    when(() => mockBalanceSheetReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.getBalance();

    //then
    verify(() => mockBalanceSheetReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load balance Sheet report', () async {
    //given
    when(() => mockBalanceSheetReportProvider.isLoading).thenReturn(false);
    when(() => mockBalanceSheetReportProvider.getBalance(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getBalance();

    verifyInOrder([
      () => mockBalanceSheetReportProvider.isLoading,
      () => view.showLoader(),
      () => mockBalanceSheetReportProvider.getBalance(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('successfully loading the balance Sheet report', () async {
    //given
    var report = MockBalanceSheetReport();
    when(() => mockBalanceSheetReportProvider.isLoading).thenReturn(false);
    when(() => mockBalanceSheetReportProvider.getBalance(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.getBalance();

    verifyInOrder([
      () => mockBalanceSheetReportProvider.isLoading,
      () => view.showLoader(),
      () => mockBalanceSheetReportProvider.getBalance(any()),
      () => view.onDidLoadBalanceSheet(),
    ]);
    _clearInteractionsOnAllMocks();
  });

  test('on filter got clicked notify ui to show filters', () {
    //when
    presenter.onFiltersGotClicked();

    //then
    verify(view.showFilter);
  });

  test("apply Filter do nothing when new applied filters is null", () async {
    //given
    var newFilters;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter do nothing when there is no different between the current filters and the new one", () async {
    //given
    var newFilters = BalanceSheetReportFilters();
    newFilters.dateFilters = presenter.filters.dateFilters;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter when only the change happened to the date filters call the api to load the balance Sheet from api",
      () async {
    //given
    var profitLossData = BalanceSheetData.fromJson(Mocks.balanceSheetReportResponse);
    when(() => mockBalanceSheetReportProvider.isLoading).thenReturn(false);
    when(() => mockBalanceSheetReportProvider.getBalance(any())).thenAnswer((_) => Future.value(profitLossData));
    var newFilters = BalanceSheetReportFilters();
    newFilters.dateFilters = getDifferentDateRangeOption(presenter.filters.dateFilters);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => mockBalanceSheetReportProvider.isLoading,
      () => view.showLoader(),
      () => mockBalanceSheetReportProvider.getBalance(any()),
      () => view.onDidLoadBalanceSheet(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("reset filter return the filters to the default state and call the api", () async {
    // given
    var report = MockBalanceSheetReport();
    when(() => mockBalanceSheetReportProvider.isLoading).thenReturn(false);
    when(() => mockBalanceSheetReportProvider.getBalance(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.resetFilters();

    //then
    verifyInOrder([
      () => mockBalanceSheetReportProvider.isLoading,
      () => view.showLoader(),
      () => mockBalanceSheetReportProvider.getBalance(any()),
      () => view.onDidLoadBalanceSheet(),
    ]);
    expect(presenter.filters.dateFilters.selectedRangeOption, SelectableDateRangeOptions.thisYear);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

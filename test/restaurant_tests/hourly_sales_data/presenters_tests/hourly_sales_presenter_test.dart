import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant/sales_reports/hourly_sales/entities/hourly_sales_report.dart';
import 'package:wallpost/restaurant/sales_reports/hourly_sales/entities/hourly_sales_report_filters.dart';
import 'package:wallpost/restaurant/sales_reports/hourly_sales/services/hourly_sales_provider.dart';
import 'package:wallpost/restaurant/sales_reports/hourly_sales/ui/presenter/hourly_sales_presenter.dart';
import 'package:wallpost/restaurant/sales_reports/hourly_sales/ui/view_contracts/hourly_sales_view.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../mocks.dart' as mocks;
import 'helpers.dart';

class MockHourlySalesReportProvider extends Mock implements HourlySalesProvider {}

class MockHourlySalesReport extends Mock implements HourlySalesReport {}

class MockHourlySalesView extends Mock implements HourlySalesView {}

void main() {
  var hourlySalesReportProvider = MockHourlySalesReportProvider();
  var view = MockHourlySalesView();
  var filters = HourlySalesReportFilters();
  late HourlySalesPresenter presenter;

  void _initializePresenter() {
    presenter = HourlySalesPresenter.initWith(
      view,
      hourlySalesReportProvider,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(hourlySalesReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(hourlySalesReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockHourlySalesReport());
    registerFallbackValue(filters);
  });

  // MARK: test loading data from api

  test('loading hourly sales report when the api is loading does nothing', () async {
    //given
    when(() => hourlySalesReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadHourlySalesData();

    //then
    verify(() => hourlySalesReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load hourly sales report notify ui to show error message', () async {
    //given
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadHourlySalesData();

    verifyInOrder([
      () => hourlySalesReportProvider.isLoading,
      () => view.showLoader(),
      () => hourlySalesReportProvider.getHourlySales(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows message when hourly sales report is empty', () async {
    //given
    var report = MockHourlySalesReport();
    when(() => report.hourlySales).thenReturn([]);
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadHourlySalesData();

    //then
    verifyInOrder([
      () => hourlySalesReportProvider.isLoading,
      () => view.showLoader(),
      () => hourlySalesReportProvider.getHourlySales(any()),
      () => view.onDidLoadReport(),
      () => view.showNoHourlySalesMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading hourly sales report', () async {
    //given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadHourlySalesData();

    verifyInOrder([
      () => hourlySalesReportProvider.isLoading,
      () => view.showLoader(),
      () => hourlySalesReportProvider.getHourlySales(any()),
      () => view.onDidLoadReport(),
    ]);
    _clearInteractionsOnAllMocks();
  });

  // MARK: test applying filters

  test('on filter got clicked notify ui to show filters', () {
    //when
    presenter.onFiltersGotClicked();

    //then
    verify(view.showSalesReportFilter);
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
    var newFilters = HourlySalesReportFilters();
    newFilters.selectedDate = presenter.filters.selectedDate;
    newFilters.sortOption = presenter.filters.sortOption;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter with different date call the api to fetch data with the new filters", () async {
    //given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));
    var newFilters = HourlySalesReportFilters();
    newFilters.selectedDate = getDifferentDate(presenter.filters.selectedDate);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => hourlySalesReportProvider.isLoading,
      () => view.showLoader(),
      () => hourlySalesReportProvider.getHourlySales(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter with different date change the filter instance in the memory", () async {
    //given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));
    var newFilters = HourlySalesReportFilters();
    newFilters.selectedDate = getDifferentDate(presenter.filters.selectedDate);

    //when
    await presenter.applyFilters(newFilters);

    //then
    expect(presenter.filters.selectedDate, newFilters.selectedDate);
    _clearInteractionsOnAllMocks();
  });

  test("apply Filter with different sort call the api to fetch data with the new filters", () async {
    //given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));
    var newFilters = HourlySalesReportFilters();
    newFilters.sortOption = getDifferentHourlySaleSortFilter(presenter.filters.sortOption);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => hourlySalesReportProvider.isLoading,
      () => view.showLoader(),
      () => hourlySalesReportProvider.getHourlySales(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter with different sort change the filter instance in the memory", () async {
    //given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));
    var newFilters = HourlySalesReportFilters();
    newFilters.sortOption = getDifferentHourlySaleSortFilter(presenter.filters.sortOption);

    //when
    await presenter.applyFilters(newFilters);

    //then
    expect(presenter.filters.sortOption, newFilters.sortOption);
    _clearInteractionsOnAllMocks();
  });

  test("reset filter return the filters to the default state and call the api", () async {
    // given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    var defaultFilters = HourlySalesReportFilters();
    presenter.filters.sortOption = getDifferentHourlySaleSortFilter(defaultFilters.sortOption);
    presenter.filters.selectedDate = getDifferentDate(defaultFilters.selectedDate);

    //when
    await presenter.resetFilters();

    //then
    verifyInOrder([
      () => hourlySalesReportProvider.isLoading,
      () => view.showLoader(),
      () => hourlySalesReportProvider.getHourlySales(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
    expect(presenter.filters.selectedDate, defaultFilters.selectedDate);
    expect(presenter.filters.sortOption, defaultFilters.sortOption);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // MARK: test getters

  test("data getters", () async {
    //given
    var report = mocks.getHourlySalesReport();
    when(() => hourlySalesReportProvider.isLoading).thenReturn(false);
    when(() => hourlySalesReportProvider.getHourlySales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadHourlySalesData();

    //then
    expect(presenter.getHourAtIndex(0), "9 to 10 AM");
    expect(presenter.getTicketsNumberAtIndex(0), 'Tickets(8)');
    expect(presenter.getTotalRevenueAtIndex(0), "2,550");
    expect(presenter.getDataListLength(), 4);
  });
}

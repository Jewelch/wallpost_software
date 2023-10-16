import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/entities/orders_summary.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/services/orders_summary_provider.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/ui/presenter/orders_summary_presenter.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/ui/view_contracts/orders_summary_view.dart';

import '../../../_mocks/mock_company_provider.dart';

class MockOrdersSummaryReportProvider extends Mock implements OrdersSummaryProvider {}

class MockSummaryOrdersReport extends Mock implements OrdersSummary {}

class MockOrders extends Mock implements List<Order> {}

class MockOrdersSummaryView extends Mock implements OrdersSummaryView {}

void main() {
  var ordersSummaryReportProvider = MockOrdersSummaryReportProvider();
  var view = MockOrdersSummaryView();
  var dateFilter = DateRange();
  late OrdersSummaryPresenter presenter;

  void _initializePresenter() {
    presenter = OrdersSummaryPresenter.initWith(
      view,
      ordersSummaryReportProvider,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(ordersSummaryReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(ordersSummaryReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockSummaryOrdersReport());
    registerFallbackValue(dateFilter);
  });

  // MARK: test load summary orders functions

  test('loading orders summary report when the report provider is loading does nothing', () async {
    //given
    when(() => ordersSummaryReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadNextOrdersSummary();

    //then
    verify(() => ordersSummaryReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load orders summary report notify ui error has been occurred', () async {
    //given
    when(() => ordersSummaryReportProvider.isLoading).thenReturn(false);
    when(() => ordersSummaryReportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadNextOrdersSummary();

    verifyInOrder([
      () => ordersSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => ordersSummaryReportProvider.getNext(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the orders summary report first time but with empty list show no summary message', () async {
    //given
    var report = MockSummaryOrdersReport();
    var mockOrdersList = MockOrders();
    when(() => mockOrdersList.isEmpty).thenReturn(true);
    when(() => report.orders).thenReturn(mockOrdersList);
    when(() => ordersSummaryReportProvider.isLoading).thenReturn(false);
    when(() => ordersSummaryReportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadNextOrdersSummary();

    verifyInOrder([
      () => ordersSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => ordersSummaryReportProvider.getNext(any()),
      () => view.onDidLoadReport(),
      () => view.showNoSummaryMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('successfully loading the orders summary report first time (no pagination yet)', () async {
    //given
    var report = MockSummaryOrdersReport();
    var mockOrdersList = MockOrders();
    when(() => mockOrdersList.isEmpty).thenReturn(false);
    when(() => report.orders).thenReturn(mockOrdersList);
    when(() => ordersSummaryReportProvider.isLoading).thenReturn(false);
    when(() => ordersSummaryReportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadNextOrdersSummary();

    verifyInOrder([
      () => ordersSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => ordersSummaryReportProvider.getNext(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the orders summary report with pagination', () async {
    //given
    var report = MockSummaryOrdersReport();
    var mockOrdersList = MockOrders();
    when(() => mockOrdersList.isEmpty).thenReturn(false);
    when(() => report.orders).thenReturn(mockOrdersList);
    when(() => ordersSummaryReportProvider.isLoading).thenReturn(false);
    when(() => ordersSummaryReportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    var previousReport = MockSummaryOrdersReport();
    var previousList = MockOrders();
    when(() => previousReport.orders).thenReturn(previousList);
    when(() => previousList.isEmpty).thenReturn(false);
    presenter.ordersSummary = previousReport;
    await presenter.loadNextOrdersSummary();

    verifyInOrder([
      () => ordersSummaryReportProvider.isLoading,
      () => view.showPaginationLoader(),
      () => ordersSummaryReportProvider.getNext(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // MARK: test applying summary orders filters functions

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

  test("apply Filter update the presenter filter object with the same instance in the memory", () async {
    //given
    var newFilters = DateRange();
    newFilters.startDate = presenter.filters.startDate.add(Duration(days: 1));

    //when
    await presenter.applyFilters(newFilters);

    //then
    expect(presenter.filters, newFilters);
    _clearInteractionsOnAllMocks();
  });

  test("reset filter return the filters to the default state and call the api", () async {
    // given
    var report = MockSummaryOrdersReport();
    var mockOrdersList = MockOrders();
    when(() => mockOrdersList.isEmpty).thenReturn(false);
    when(() => report.orders).thenReturn(mockOrdersList);
    when(() => ordersSummaryReportProvider.isLoading).thenReturn(false);
    when(() => ordersSummaryReportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.resetFilters();

    //then
    expect(presenter.filters.selectedRangeOption, SelectableDateRangeOptions.today);

    verifyInOrder([
      () => ordersSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => ordersSummaryReportProvider.getNext(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

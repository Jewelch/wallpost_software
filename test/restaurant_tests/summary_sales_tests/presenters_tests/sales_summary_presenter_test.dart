import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant/sales_reports/sales_summary/entities/sales_summary.dart';
import 'package:wallpost/restaurant/sales_reports/sales_summary/entities/sales_summary_details.dart';
import 'package:wallpost/restaurant/sales_reports/sales_summary/services/sales_summary_provider.dart';
import 'package:wallpost/restaurant/sales_reports/sales_summary/ui/presenter/sales_summary_presenter.dart';
import 'package:wallpost/restaurant/sales_reports/sales_summary/ui/view_contracts/sales_summary_view.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../_mocks.dart';

class MockSalesSummaryReportProvider extends Mock implements SalesSummaryProvider {}

class MockSummarySalesReport extends Mock implements SalesSummary {}

class MockSalesSummaryDetails extends Mock implements SalesSummaryDetails {}

class MockSalesSummaryItem extends Mock implements SalesSummaryItem {}

class MockSalesSummaryOrderType extends Mock implements SaleSummaryOrderType {}

class MockSalesSummaryView extends Mock implements SalesSummaryView {}

void main() {
  var salesSummaryReportProvider = MockSalesSummaryReportProvider();
  var view = MockSalesSummaryView();
  var dateFilter = DateRange();
  late SalesSummaryPresenter presenter;

  void _initializePresenter() {
    presenter = SalesSummaryPresenter.initWith(
      view,
      salesSummaryReportProvider,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(salesSummaryReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(salesSummaryReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockSummarySalesReport());
    registerFallbackValue(dateFilter);
  });

  // MARK: test load summary sales functions

  test('loading sales summary report when the report provider is loading does nothing', () async {
    //given
    when(() => salesSummaryReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadSalesSummaryData();

    //then
    verify(() => salesSummaryReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load sales summary report notify ui error has been occurred', () async {
    //given
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadSalesSummaryData();

    verifyInOrder([
      () => salesSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => salesSummaryReportProvider.getSummarySales(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the sales summary report', () async {
    //given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadSalesSummaryData();

    verifyInOrder([
      () => salesSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => salesSummaryReportProvider.getSummarySales(any()),
      () => view.onDidLoadReport(),
    ]);
    _clearInteractionsOnAllMocks();
  });

  // MARK: test applying summary sales filters functions

  test('on filter got clicked notify ui to show filters', () {
    //when
    presenter.onFiltersGotClicked();

    //then
    verify(view.showSalesSummaryFilter);
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
    var newFilters = DateRange();
    newFilters.startDate = presenter.dateFilters.startDate;
    newFilters.endDate = presenter.dateFilters.endDate;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter with different filter update the presenter filter object with the same instance in the memory",
      () async {
    //given
    var newFilters = DateRange();
    newFilters.startDate = presenter.dateFilters.startDate.add(Duration(days: 1));

    //when
    await presenter.applyFilters(newFilters);

    //then
    expect(presenter.dateFilters, newFilters);
    _clearInteractionsOnAllMocks();
  });

  test("apply Filter with different filter call the api to load the sales summary", () async {
    //given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));
    var newFilters = DateRange();
    newFilters.startDate = presenter.dateFilters.startDate.add(Duration(days: 2));

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => salesSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => salesSummaryReportProvider.getSummarySales(newFilters),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // MARK: test toggling sales summary ui

  test("toggling with index 0 change the toggle collection state to opposite of the passed state", () async {
    //given
    int indexToToggle = 0;

    //when true case
    presenter.toggleExpansion(indexToToggle, true);

    //then true case
    expect(presenter.isCollectionsExpanded, false);

    //when false case
    presenter.toggleExpansion(indexToToggle, false);

    //then false case
    expect(presenter.isCollectionsExpanded, true);
  });

  test("toggling with index 1 change the toggle order type state to opposite of the passed state", () async {
    //given
    int indexToToggle = 1;

    //when true case
    presenter.toggleExpansion(indexToToggle, true);

    //then true case
    expect(presenter.isOrderTypesExpanded, false);

    //when false case
    presenter.toggleExpansion(indexToToggle, false);

    //then false case
    expect(presenter.isOrderTypesExpanded, true);
  });

  test("toggling with index 2 change the toggle categories state to opposite of the passed state", () async {
    //given
    int indexToToggle = 2;

    //when true case
    presenter.toggleExpansion(indexToToggle, true);

    //then true case
    expect(presenter.isCategoriesExpanded, false);

    //when false case
    presenter.toggleExpansion(indexToToggle, false);

    //then false case
    expect(presenter.isCategoriesExpanded, true);
  });

  test("toggling with index 3 change the toggle summary state to opposite of the passed state", () async {
    //given
    int indexToToggle = 3;

    //when true case
    presenter.toggleExpansion(indexToToggle, true);

    //then true case
    expect(presenter.isSummaryExpanded, false);

    //when false case
    presenter.toggleExpansion(indexToToggle, false);

    //then false case
    expect(presenter.isSummaryExpanded, true);
  });

  test("toggling with index out of the range 0 to 3 do nothing", () async {
    //given
    int indexToToggle = 4;
    var isSummaryExpandedBefore = presenter.isSummaryExpanded;
    var isCategoriesExpandedBefore = presenter.isCategoriesExpanded;
    var isOrderTypesExpandedBefore = presenter.isOrderTypesExpanded;
    var isCollectionsExpandedBefore = presenter.isCollectionsExpanded;

    //when
    presenter.toggleExpansion(indexToToggle, true);

    // then
    expect(presenter.isSummaryExpanded, isSummaryExpandedBefore);
    expect(presenter.isCategoriesExpanded, isCategoriesExpandedBefore);
    expect(presenter.isOrderTypesExpanded, isOrderTypesExpandedBefore);
    expect(presenter.isCollectionsExpanded, isCollectionsExpandedBefore);
  });

  // MARK: test getters

  test(
      'isSalesSummaryHasDetails return false when sales summary has no categories neither collections neither order types data',
      () async {
    //given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));
    var details = MockSalesSummaryDetails();
    when(() => details.categories).thenReturn([]);
    when(() => details.collections).thenReturn([]);
    when(() => details.orderTypes).thenReturn([]);
    when(() => report.details).thenReturn(details);

    //when
    await presenter.loadSalesSummaryData();
    var isSummaryHasDetails = presenter.isSalesSummaryHasDetails;

    //then
    expect(isSummaryHasDetails, false);
    _clearInteractionsOnAllMocks();
  });

  test('isSalesSummaryHasDetails return true if only sales summary categories has data', () async {
    //given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));
    var details = MockSalesSummaryDetails();
    var salesSummaryItem = MockSalesSummaryItem();
    when(() => details.categories).thenReturn([salesSummaryItem]);
    when(() => details.collections).thenReturn([]);
    when(() => details.orderTypes).thenReturn([]);
    when(() => report.details).thenReturn(details);

    //when
    await presenter.loadSalesSummaryData();
    var isSummaryHasDetails = presenter.isSalesSummaryHasDetails;

    //then
    expect(isSummaryHasDetails, true);
    _clearInteractionsOnAllMocks();
  });

  test('isSalesSummaryHasDetails return true if only sales summary collections has data', () async {
    //given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));
    var details = MockSalesSummaryDetails();
    var salesSummaryItem = MockSalesSummaryItem();
    when(() => details.collections).thenReturn([salesSummaryItem]);
    when(() => details.categories).thenReturn([]);
    when(() => details.orderTypes).thenReturn([]);
    when(() => report.details).thenReturn(details);

    //when
    await presenter.loadSalesSummaryData();
    var isSummaryHasDetails = presenter.isSalesSummaryHasDetails;

    //then
    expect(isSummaryHasDetails, true);
    _clearInteractionsOnAllMocks();
  });

  test('isSalesSummaryHasDetails return true if only sales summary orderTypes has data', () async {
    //given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));
    var details = MockSalesSummaryDetails();
    var salesSummaryOrderType = MockSalesSummaryOrderType();
    when(() => details.collections).thenReturn([]);
    when(() => details.categories).thenReturn([]);
    when(() => details.orderTypes).thenReturn([salesSummaryOrderType]);
    when(() => report.details).thenReturn(details);

    //when
    await presenter.loadSalesSummaryData();
    var isSummaryHasDetails = presenter.isSalesSummaryHasDetails;

    //then
    expect(isSummaryHasDetails, true);
    _clearInteractionsOnAllMocks();
  });

  test("data getters", () async {
    //given
    var report = SalesSummary.fromJson(successfulSalesSummaryResponse);
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadSalesSummaryData();

    //then
    expect(presenter.isSalesSummaryCollectionsHasData, true);
    expect(presenter.isSalesSummaryOrderTypeHasData, true);
    expect(presenter.isSalesSummaryCategoriesHasData, true);

    expect(presenter.getSalesSummaryCollections, report.details.collections);
    expect(presenter.getSalesSummaryOrderTypes, report.details.orderTypes);
    expect(presenter.getSalesSummaryCategories, report.details.categories);

    expect(presenter.getSalesSummaryItemNameAt(0, report.details.categories), "Burger");
    expect(presenter.getSalesSummaryItemNameAt(0, report.details.collections), "CASH");
    expect(presenter.getSalesSummaryItemRevenueAt(0, report.details.categories), "3,118");
    expect(presenter.getSalesSummaryItemRevenueAt(0, report.details.collections), "459,124");
    expect(presenter.getSalesSummaryItemQuantityAt(0, report.details.categories), "1,600");
    expect(presenter.getSalesSummaryItemQuantityAt(0, report.details.collections), "6");

    expect(presenter.getOrderTypeNameAt(0), "DineIn");
    expect(presenter.orderTypePercentageAt(0), "60");
    expect(presenter.orderTypeRevenueAt(0), "1,456");

    expect(presenter.getSalesSummaryGross, "1,574,454");
    expect(presenter.getSalesSummaryDiscounts, "0");
    expect(presenter.getSalesSummaryRefunds, "0");
    expect(presenter.getSalesSummaryTax, "0");
    expect(presenter.getSalesSummaryNet, "1,274,454");
  });

  test("reset filter return the filters to the default state and call the api", () async {
    // given
    var report = MockSummarySalesReport();
    when(() => salesSummaryReportProvider.isLoading).thenReturn(false);
    when(() => salesSummaryReportProvider.getSummarySales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.resetFilters();

    //then
    expect(presenter.dateFilters.selectedRangeOption,SelectableDateRangeOptions.today);

    verifyInOrder([
      () => salesSummaryReportProvider.isLoading,
      () => view.showLoader(),
      () => salesSummaryReportProvider.getSummarySales(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/item_sales_model.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/item_sales_report_filters.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/sales_item_view_options.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/services/item_sales_provider.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/ui/presenter/item_sales_presenter.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/ui/view_contracts/item_sales_view.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/utils/item_sales_sorter.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../mocks.dart';
import 'helpers.dart';

class MockItemSalesReportProvider extends Mock implements ItemSalesProvider {}

class MockItemSalesReport extends Mock implements ItemSalesReport {}

class MockItemSalesBreakdown extends Mock implements CategoriesSales {}

class MockItemSalesView extends Mock implements ItemSalesView {}

class MockItemSalesSorter extends Mock implements ItemSalesSorter {}

void main() {
  var itemSalesReportProvider = MockItemSalesReportProvider();
  var view = MockItemSalesView();
  var dateFilter = DateRangeFilters();
  var itemSalesSorter = MockItemSalesSorter();
  late ItemSalesPresenter presenter;

  void _initializePresenter() {
    presenter = ItemSalesPresenter.initWith(
      view,
      itemSalesReportProvider,
      itemSalesSorter,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(itemSalesReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(itemSalesReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockItemSalesReport());
    registerFallbackValue(MockItemSalesBreakdown());
    registerFallbackValue(dateFilter);
    registerFallbackValue(SalesItemWiseOptions.CategoriesAndItems);
    registerFallbackValue(ItemSalesReportSortOptions.byNameZToA);
  });

  test('loading item sales report when the report provider is loading does nothing', () async {
    //given
    when(() => itemSalesReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadItemSalesData();

    //then
    verify(() => itemSalesReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load item sales report', () async {
    //given
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadItemSalesData();

    verifyInOrder([
      () => itemSalesReportProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesReportProvider.getItemSales(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows message when item sales data break down is empty', () async {
    //given
    var report = MockItemSalesReport();
    when(() => report.categoriesSales).thenReturn([]);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadItemSalesData();

    //then
    verifyInOrder([
      () => itemSalesReportProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesReportProvider.getItemSales(any()),
      () => view.onDidLoadReport(),
      () => view.showNoItemSalesBreakdownMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the item sales report', () async {
    //given
    var report = MockItemSalesReport();
    var breakdown1 = MockItemSalesBreakdown();
    when(() => breakdown1.items).thenReturn([]);
    when(() => report.categoriesSales).thenReturn([breakdown1]);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadItemSalesData();

    verifyInOrder([
      () => itemSalesReportProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesReportProvider.getItemSales(any()),
      () => view.onDidLoadReport(),
    ]);
    _clearInteractionsOnAllMocks();
  });

  test("data getters", () async {
    //given
    var report = ItemSalesReport.fromJson(Mocks.itemSalesReportResponse);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadItemSalesData();

    //then
    expect(presenter.getTotalRevenue(), "175");
    expect(presenter.getTotalOfAllItemsQuantity(), "22");

    expect(presenter.getTotalCategories(), "2");
    expect(presenter.getCategoryCardHeader(), "Categories(2)");
    expect(presenter.getItemsListLength(), 16);
    expect(presenter.getItemCardHeader(), "Items(16)");

    //category 1
    expect(presenter.getCategoryNameAtIndex(0), "Soda");
    expect(presenter.getCategoryTotalToDisplayRevenueAtIndex(0), "61");
    expect(presenter.getCategoryTotalQtyAtIndex(0), "13");

    //category 3
    expect(presenter.getCategoryNameAtIndex(2), "Aalads");
    expect(presenter.getCategoryTotalToDisplayRevenueAtIndex(2), "114");
    expect(presenter.getCategoryTotalQtyAtIndex(2), "9");

    //item 3
    expect(presenter.getItemNameAtIndex(2), "Fanta");
    expect(presenter.getItemQtyAtIndex(2), "2");
    expect(presenter.getItemRevenueToDisplayAtIndex(2), "10");

    //item 8
    expect(presenter.getItemNameAtIndex(7), "Creamy Vegan Pasta Salad");
    expect(presenter.getItemQtyAtIndex(7), "2");
    expect(presenter.getItemRevenueToDisplayAtIndex(7), "56");

    //item 12
    expect(presenter.getItemNameAtIndex(11), "Pasta Salad");
    expect(presenter.getItemQtyAtIndex(11), "3");
    expect(presenter.getItemRevenueToDisplayAtIndex(11), "54");
  });

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
    var newFilters = ItemSalesReportFilters();
    newFilters.dateRangeFilters = presenter.filters.dateRangeFilters;
    newFilters.sortOption = presenter.filters.sortOption;
    newFilters.salesItemWiseOptions = presenter.filters.salesItemWiseOptions;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter update the presenter filter object with the same instance in the memory", () async {
    //given
    var newFilters = ItemSalesReportFilters();
    newFilters.dateRangeFilters = presenter.filters.dateRangeFilters;
    newFilters.sortOption = presenter.filters.sortOption;
    newFilters.salesItemWiseOptions = presenter.filters.salesItemWiseOptions;

    //when
    await presenter.applyFilters(newFilters);

    //then
    expect(presenter.filters, newFilters);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter when only the change happened to the date filters call the api to load the item sales from api",
      () async {
    //given
    var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesReportResponse);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
    var newFilters = ItemSalesReportFilters();
    newFilters.dateRangeFilters = getDifferentDateRangeOption(presenter.filters.dateRangeFilters);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => itemSalesReportProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesReportProvider.getItemSales(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter when only the change happened to the sort filters calls itemSalesSorter to sort the breakdowns",
      () async {
    // Feed the presenter
    var report = MockItemSalesReport();
    var breakdown1 = MockItemSalesBreakdown();
    when(() => breakdown1.items).thenReturn([]);
    when(() => report.categoriesSales).thenReturn([breakdown1]);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadItemSalesData();
    _clearInteractionsOnAllMocks();

    // given
    var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesReportResponse);
    var allItems = <ItemSales>[];
    itemSalesData.categoriesSales.forEach((element) => element.items.forEach((item) => allItems.add(item)));
    when(() => itemSalesSorter.sortBreakDowns(any(), any())).thenReturn(itemSalesData);
    when(() => itemSalesSorter.sortAllBreakDownItems(any(), any())).thenReturn(allItems);
    var newFilters = ItemSalesReportFilters();
    newFilters.sortOption = getDifferentItemSaleSortFilter(presenter.filters.sortOption);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => itemSalesSorter.sortBreakDowns(any(), newFilters.sortOption),
      () => itemSalesSorter.sortAllBreakDownItems(any(), newFilters.sortOption),
      () => view.onDidChangeFilters()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
    expect(presenter.itemSalesReport, itemSalesData);
    expect(presenter.getItemsListLength(), allItems.length);
  });

  test("apply Filter when only the change happened to the views filters notify ui that filter had changed", () async {
    // given
    var newFilters = ItemSalesReportFilters();
    newFilters.salesItemWiseOptions = getDifferentItemSaleViewFilter(presenter.filters.salesItemWiseOptions);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verify(() => view.onDidChangeFilters());
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("reset filter return the filters to the default state and call the api", () async {
    // given
    var report = MockItemSalesReport();
    var breakdown1 = MockItemSalesBreakdown();
    when(() => breakdown1.items).thenReturn([]);
    when(() => report.categoriesSales).thenReturn([breakdown1]);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.resetFilters();

    //then
    verifyInOrder([
      () => itemSalesReportProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesReportProvider.getItemSales(any()),
      () => view.onDidLoadReport(),
    ]);
    expect(presenter.filters.dateRangeFilters.selectedRangeOption, SelectableDateRangeOptions.today);
    expect(presenter.filters.salesItemWiseOptions, SalesItemWiseOptions.CategoriesAndItems);
    expect(presenter.filters.sortOption, ItemSalesReportSortOptions.byRevenueLowToHigh);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

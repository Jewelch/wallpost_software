import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_report_filters.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/services/item_sales_provider.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/presenter/item_sales_presenter.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/view_contracts/item_sales_view.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/utils/item_sales_sorter.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../mocks.dart';
import 'helpers.dart';

class MockItemSalesReportProvider extends Mock implements ItemSalesProvider {}

class MockItemSalesReport extends Mock implements ItemSalesReport {}

class MockItemSalesBreakdown extends Mock implements ItemSalesBreakdown {}

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

  // void _verifyInOrderAndShowData() {
  //   verifyInOrder([
  //     () => itemSalesReportProvider.isLoading,
  //     () => view.showLoader(),
  //     () => itemSalesReportProvider.getItemSales(any()),
  //     () => view.updateItemSalesData(),
  //     () => view.showItemSalesBreakDowns(),
  //   ]);
  // }
  //
  // void _verifyInOrderAndShowNoDataMessage() {
  //   verifyInOrder([
  //     () => itemSalesReportProvider.isLoading,
  //     () => view.showLoader(),
  //     () => itemSalesReportProvider.getItemSales(any()),
  //     () => view.updateItemSalesData(),
  //     () => view.showNoItemSalesBreakdownMessage(),
  //   ]);
  // }

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
    when(() => report.breakdown).thenReturn([]);
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
    when(() => report.breakdown).thenReturn([breakdown1]);
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
    newFilters.sortOptions = presenter.filters.sortOptions;
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
    newFilters.sortOptions = presenter.filters.sortOptions;
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
    when(() => report.breakdown).thenReturn([breakdown1]);
    when(() => itemSalesReportProvider.isLoading).thenReturn(false);
    when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadItemSalesData();
    _clearInteractionsOnAllMocks();

    // given
    var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesReportResponse);
    var allItems = <ItemSales>[];
    itemSalesData.breakdown.forEach((element) => element.items.forEach((item) => allItems.add(item)));
    when(() => itemSalesSorter.sortBreakDowns(any(), any())).thenReturn(itemSalesData);
    when(() => itemSalesSorter.sortAllBreakDownItems(any(), any())).thenReturn(allItems);
    var newFilters = ItemSalesReportFilters();
    newFilters.sortOptions = getDifferentItemSaleSortFilter(presenter.filters.sortOptions);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => itemSalesSorter.sortBreakDowns(any(), newFilters.sortOptions),
      () => itemSalesSorter.sortAllBreakDownItems(any(), newFilters.sortOptions),
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
    when(() => report.breakdown).thenReturn([breakdown1]);
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
    expect(presenter.filters.sortOptions, ItemSalesReportSortOptions.byRevenueLowToHigh);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  /*


TODO: Test the following getters

  // Item and Category wise

  String getNameOfSpecificItem(ItemSales item) => item.itemName;

  String getQtyOfSpecificItem(ItemSales item) => item.qty.toString();

  String getRevenueToDisplayOfSpecificItem(ItemSales item) => item.revenueToDisplay.toString();

  String getCategoryNameCardHeader(ItemSalesBreakdown breakDown) => breakDown.categoryName;

  String getBreakDownRevenueForCategory(ItemSalesBreakdown breakDown) => breakDown.totalRevenueToDisplay;

  void toggleCategoryExpansionStatusAtIndex(int index) =>
      itemSalesReport.breakdown[index].isExpanded = !(itemSalesReport.breakdown[index].isExpanded);

  List<ItemSalesBreakdown> getItemSalesBreakDownList() => itemSalesReport.breakdown;

  int getDataListLength() => itemSalesReport.breakdown.length;

   */

  /*
  expect(presenter.getTotalCategories(), itemSalesData.totalCategories.toString());
    expect(presenter.getTotalOfAllItemsQuantity(), itemSalesData.totalOfAllItemsQuantities.toString());
   */
  //
  // test("presenter returns 0.0 or empty string for item sales data when item sales data is uninitialized yet", () {
  //   _initializePresenter();
  //
  //   // Top card
  //   expect(presenter.getTotalOfAllItemsQuantity(), "0");
  //   expect(presenter.getTotalRevenue(), "0.00");
  //
  //   // Category wise
  //   expect(presenter.getCategoryNameAtIndex(0), "");
  //   expect(presenter.getCategoryTotalToDisplayRevenueAtIndex(0), "0");
  //   expect(presenter.getCategoryTotalQtyAtIndex(0), "0");
  //   expect(presenter.getTotalCategories(), "0");
  //   expect(presenter.getCategoryCardHeader(), "Categories(0)");
  //
  //   // Item wise
  //   expect(presenter.getItemNameAtIndex(0), "");
  //   expect(presenter.getItemQtyAtIndex(0), "0");
  //   expect(presenter.getItemsListLength(), 0);
  //   expect(presenter.getItemCardHeader(), "Items(0)");
  //
  //   _clearInteractionsOnAllMocks();
  // });

  //
  // test('getTotalRevenue() returns the item sales total revenue', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   // //then
  //   _verifyInOrderAndShowData();
  //
  //   expect(presenter.getTotalRevenue(), itemSalesData.totalRevenue.toString());
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getTotalOfAllItemsQuantity() returns the item sales total of all items quantity', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   ///then
  //   _verifyInOrderAndShowData();
  //
  //   expect(presenter.getTotalOfAllItemsQuantity(), itemSalesData.totalOfAllItemsQuantities.toString());
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getTotalOfAllItemsQuantity() returns 0 when the total of all items quantity is null', () async {
  //   var itemSalesData = MockItemSalesData();
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowNoDataMessage();
  //
  //   expect(presenter.getTotalOfAllItemsQuantity(), "0");
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getTotalCategories() returns the item sales total categories', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   expect(presenter.getTotalCategories(), itemSalesData.totalCategories.toString());
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getCategoryCardHeader() returns the categories card header', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   expect(presenter.getCategoryCardHeader(), "Categories(${itemSalesData.totalCategories.toString()})");
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getItemCardHeader() returns the item card header', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   expect(presenter.getItemCardHeader(), "Items(${presenter.getItemsListLength().toString()})");
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getDataListLength() returns the length of the breakdown list', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   expect(presenter.getDataListLength(), itemSalesData.breakdown?.length);
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getTotalRevenue() returns "0.00" if revenue is null', () async {
  //   var itemSalesData = MockItemSalesData();
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowNoDataMessage();
  //
  //   expect(presenter.getTotalRevenue(), "0.00");
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getCategoryNameAtIndex() returns category name at index', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   for (var i = 0; i < itemSalesData.breakdown!.length; i++) {
  //     final currentItem = itemSalesData.breakdown?[i];
  //
  //     expect(presenter.getCategoryNameAtIndex(i), currentItem?.categoryName);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getCategoryTotalToDisplayRevenueAtIndex() returns category total to display revenue at index', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   for (var i = 0; i < itemSalesData.breakdown!.length; i++) {
  //     final currentItem = itemSalesData.breakdown?[i];
  //
  //     expect(presenter.getCategoryTotalToDisplayRevenueAtIndex(i), currentItem?.totalRevenueToDisplay);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getCategoryQtyAtIndex() returns category total quantity at index', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   for (var i = 0; i < itemSalesData.breakdown!.length; i++) {
  //     final currentItem = itemSalesData.breakdown?[i];
  //
  //     expect(presenter.getCategoryTotalQtyAtIndex(i), currentItem?.totalQuantity.toString());
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getItemNameAtIndex() returns item name at index', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //   for (var i = 0; i < itemsList!.length; i++) {
  //     final currentItem = itemsList[i];
  //
  //     expect(presenter.getItemNameAtIndex(i), currentItem.itemName);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getItemQtyAtIndex() returns item quantity at index', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //   for (var i = 0; i < itemsList!.length; i++) {
  //     final currentItem = itemsList[i];
  //
  //     expect(presenter.getItemQtyAtIndex(i), currentItem.qty.toString());
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getItemRevenueToDisplayAtIndex() returns item revenue to display at index', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //   for (var i = 0; i < itemsList!.length; i++) {
  //     final currentItem = itemsList[i];
  //
  //     expect(presenter.getItemRevenueToDisplayAtIndex(i), currentItem.revenueToDisplay);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getItemsListLength() returns items list length', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //
  //   expect(presenter.getItemsListLength(), itemsList?.length);
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getItemNameOfSpecificItem() returns name of specific item', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //   for (var i = 0; i < itemsList!.length; i++) {
  //     final currentItem = itemsList[i];
  //
  //     expect(presenter.getNameOfSpecificItem(currentItem), currentItem.itemName);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getQtyOfSpecificItem() returns quantity of specific item', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //   for (var i = 0; i < itemsList!.length; i++) {
  //     final currentItem = itemsList[i];
  //
  //     expect(presenter.getQtyOfSpecificItem(currentItem), currentItem.qty.toString());
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  // test('getRevenueToDisplayOfSpecificItem() returns revenue to display of specific item', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   presenter.getItemsList();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemsList = presenter.itemslist;
  //   for (var i = 0; i < itemsList!.length; i++) {
  //     final currentItem = itemsList[i];
  //
  //     expect(presenter.getRevenueToDisplayOfSpecificItem(currentItem), currentItem.revenueToDisplay);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getCategoryNameHeaderCard() returns category name card header', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemSalesBreakDown = presenter.itemSalesData?.breakdown;
  //   for (var i = 0; i < itemSalesBreakDown!.length; i++) {
  //     final currentItem = itemSalesBreakDown[i];
  //
  //     expect(presenter.getCategoryNameCardHeader(currentItem), currentItem.categoryName);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test('getBreakDownRevenueForCategory() returns break down revenue for category to display', () async {
  //   var itemSalesData = ItemSalesReport.fromJson(Mocks.itemSalesRandomResponse);
  //
  //   //given
  //   when(() => itemSalesReportProvider.isLoading).thenReturn(false);
  //   when(() => itemSalesReportProvider.getItemSales(any())).thenAnswer((_) => Future.value(itemSalesData));
  //
  //   //when
  //   await presenter.loadItemSalesData();
  //
  //   //then
  //   _verifyInOrderAndShowData();
  //
  //   var itemSalesBreakDown = presenter.itemSalesData?.breakdown;
  //   for (var i = 0; i < itemSalesBreakDown!.length; i++) {
  //     final currentItem = itemSalesBreakDown[i];
  //
  //     expect(presenter.getBreakDownRevenueForCategory(currentItem), currentItem.totalRevenueToDisplay);
  //   }
  //
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
}

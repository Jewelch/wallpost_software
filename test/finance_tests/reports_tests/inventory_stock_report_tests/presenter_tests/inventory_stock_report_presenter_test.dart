import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_item.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_report.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_report_filter.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/services/inventory_stock_report_provider.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/models/stock_list_item_view_type.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/presenters/inventory_stock_report_presenter.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/view_contracts/inventory_stock_report_view.dart';

import '../../../../_mocks/mock_company.dart';
import '../../../../_mocks/mock_company_provider.dart';
import '../../../../_mocks/mock_network_adapter.dart';

class MockInventoryStockReportView extends Mock implements InventoryStockReportView {}

class MockInventoryStockReportProvider extends Mock implements InventoryStockReportProvider {}

class MockInventoryStockReport extends Mock implements InventoryStockReport {}

class MockInventoryStockItem extends Mock implements InventoryStockItem {}

class MockInventoryStockWarehouse extends Mock implements InventoryStockWarehouse {}

void main() {
  late InventoryStockReport report;
  late InventoryStockReportView view;
  late InventoryStockReportProvider reportProvider;
  late MockCompanyProvider companyProvider;
  late InventoryStockReportPresenter presenter;

  void verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(reportProvider);
  }

  void clearAllInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(reportProvider);
  }

  setUp(() {
    registerFallbackValue(InventoryStockReportFilter());

    report = MockInventoryStockReport();
    view = MockInventoryStockReportView();
    reportProvider = MockInventoryStockReportProvider();
    companyProvider = MockCompanyProvider();
    var company = MockCompany();
    when(() => company.name).thenReturn("Some company name");
    when(() => company.currency).thenReturn("USD");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    presenter = InventoryStockReportPresenter.initWith(view, reportProvider, companyProvider);
  });

  //MARK: Tests for loading data for the first time

  test("loading data for the first time does nothing when the provider is loading", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => reportProvider.isLoading,
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("failure to load data for the first time", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => reportProvider.isLoading,
      () => view.showLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidFailToLoadAnyData(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully loading the data the first time", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => reportProvider.isLoading,
      () => view.showLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidLoadData(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("error is reset when loading the data after a failure", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadData();
    clearAllInteractionsOnAllMocks();

    //when
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();

    //then
    expect(presenter.errorMessage, "");
  });

  //MARK: Tests for loading data more data

  test("loading more data does nothing when the provider is loading", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(true);

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => reportProvider.isLoading,
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("failure to load more data", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => reportProvider.isLoading,
      () => view.showGetNextDataLoader(),
      () => reportProvider.getNext(any()),
      () => view.onDidFailToGetNextData(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully loading more data", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => reportProvider.isLoading,
      () => view.showGetNextDataLoader(),
      () => reportProvider.getNext(any()),
      () => view.onDidLoadNextData(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("error is reset when getting more data after a failure", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadData();
    clearAllInteractionsOnAllMocks();

    //when
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "");
  });

  //MARK: Tests for loading after filter selection

  test("calls the provider again even if it is loading", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(true);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    presenter.refreshWithUpdatedFilters();
    presenter.refreshWithUpdatedFilters();
    presenter.refreshWithUpdatedFilters();

    //then
    verify(() => reportProvider.getNext(any())).called(3);
  });

  test("failure to load data after filter selection", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.refreshWithUpdatedFilters();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidFailToApplyFilters(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully loading data after filter selection", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.refreshWithUpdatedFilters();

    //then
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("error is reset when getting more data after a failure", () async {
    //given
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadData();
    clearAllInteractionsOnAllMocks();

    //when
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.refreshWithUpdatedFilters();

    //then
    expect(presenter.errorMessage, "");
  });

  //MARK: Tests for applying filters

  test("successfully setting date and warehouse filter", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    var date = DateTime(2022, 01, 30);
    var warehouse = MockInventoryStockWarehouse();
    await presenter.setFilterBarFilters(date: date, warehouse: warehouse);

    //then
    expect(presenter.copyOfCurrentFilters.date, date);
    expect(presenter.copyOfCurrentFilters.warehouse, warehouse);
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully setting search filter", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.setSearchText("some search text");

    //then
    expect(presenter.copyOfCurrentFilters.searchText, "some search text");
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("updating filters", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    var newFilters = InventoryStockReportFilter();
    newFilters.date = DateTime(2000, 12, 20);
    newFilters.warehouse = MockInventoryStockWarehouse();
    newFilters.searchText = "new search text";

    //when
    await presenter.updateFilters(newFilters);

    //then
    expect(presenter.copyOfCurrentFilters.date, newFilters.date);
    expect(presenter.copyOfCurrentFilters.warehouse, newFilters.warehouse);
    expect(presenter.copyOfCurrentFilters.searchText, "new search text");
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for clearing filters

  test("show clear filter icon", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));

    //do not show clear button when date is today, no warehouse is selected
    presenter.setFilterBarFilters(date: DateTime.now(), warehouse: null);
    expect(presenter.showClearDateFilterIcon(), false);
    expect(presenter.showClearWarehouseFilterIcon(), false);

    presenter.setFilterBarFilters(date: DateTime(2022, 12, 30), warehouse: MockInventoryStockWarehouse());
    expect(presenter.showClearDateFilterIcon(), true);
    expect(presenter.showClearWarehouseFilterIcon(), true);
  });

  test("clearing date filter", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.setFilterBarFilters(date: DateTime(2022, 12, 30), warehouse: null);
    clearAllInteractionsOnAllMocks();

    //when
    await presenter.clearDateFilter();

    //then
    expect(presenter.copyOfCurrentFilters.date.isToday(), true);
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("clearing warehouse filter", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.setFilterBarFilters(date: DateTime(2022, 12, 30), warehouse: MockInventoryStockWarehouse());
    clearAllInteractionsOnAllMocks();

    //when
    await presenter.clearWarehouseFilter();

    //then
    expect(presenter.copyOfCurrentFilters.warehouse, null);
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("clearing all filter bar filters", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.setFilterBarFilters(date: DateTime(2022, 12, 30), warehouse: MockInventoryStockWarehouse());
    clearAllInteractionsOnAllMocks();

    //when
    await presenter.clearAllFilterBarFilters();

    //then
    expect(presenter.copyOfCurrentFilters.date.isToday(), true);
    expect(presenter.copyOfCurrentFilters.warehouse, null);
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("clearing all filter bar filters", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.setFilterBarFilters(date: DateTime(2022, 12, 30), warehouse: MockInventoryStockWarehouse());
    clearAllInteractionsOnAllMocks();

    //when
    await presenter.clearAllFilterBarFilters();

    //then
    expect(presenter.copyOfCurrentFilters.date.isToday(), true);
    expect(presenter.copyOfCurrentFilters.warehouse, null);
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("clearing search filter", () async {
    //given
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.setSearchText("some search text");
    clearAllInteractionsOnAllMocks();

    //when
    await presenter.clearSearchFilter();

    //then
    expect(presenter.copyOfCurrentFilters.searchText, "");
    verifyInOrder([
      () => view.showFilteringInProgressLoader(),
      () => reportProvider.reset(),
      () => reportProvider.getNext(any()),
      () => view.onDidApplyFiltersSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for getting list details

  test('get number of leave list items when there are no items', () async {
    //when
    when(() => report.items).thenReturn([]);
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();

    //then
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of list items when there are some items and the provider is loading', () async {
    //when
    when(() => report.items).thenReturn([
      MockInventoryStockItem(),
      MockInventoryStockItem(),
      MockInventoryStockItem(),
    ]);
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();
    when(() => reportProvider.didReachListEnd).thenReturn(false);
    when(() => reportProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 5);
    expect(presenter.getItemTypeAtIndex(0), StockListItemViewType.Header);
    expect(presenter.getItemTypeAtIndex(1), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(4), StockListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => report.items).thenReturn([
      MockInventoryStockItem(),
      MockInventoryStockItem(),
      MockInventoryStockItem(),
    ]);
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 5);
    expect(presenter.getItemTypeAtIndex(0), StockListItemViewType.Header);
    expect(presenter.getItemTypeAtIndex(1), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(4), StockListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => report.items).thenReturn([
      MockInventoryStockItem(),
      MockInventoryStockItem(),
      MockInventoryStockItem(),
    ]);
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.didReachListEnd).thenReturn(false);

    //when
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 5);
    expect(presenter.getItemTypeAtIndex(0), StockListItemViewType.Header);
    expect(presenter.getItemTypeAtIndex(1), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(4), StockListItemViewType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => report.items).thenReturn([
      MockInventoryStockItem(),
      MockInventoryStockItem(),
      MockInventoryStockItem(),
    ]);
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();
    when(() => reportProvider.didReachListEnd).thenReturn(true);
    when(() => reportProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 5);
    expect(presenter.getItemTypeAtIndex(0), StockListItemViewType.Header);
    expect(presenter.getItemTypeAtIndex(1), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), StockListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(4), StockListItemViewType.EmptySpace);
  });

  test('getting list item at index', () async {
    //when
    var item1 = MockInventoryStockItem();
    var item2 = MockInventoryStockItem();
    var item3 = MockInventoryStockItem();
    when(() => report.items).thenReturn([item1, item2, item3]);
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.getNext();
    when(() => reportProvider.didReachListEnd).thenReturn(false);
    when(() => reportProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getItemAtIndex(1), item1);
    expect(presenter.getItemAtIndex(2), item2);
    expect(presenter.getItemAtIndex(3), item3);
  });

  //MARK: Tests for header card and stock item getters

  test("header card getters", () async {
    //given
    when(() => report.total).thenReturn("12,300");
    when(() => reportProvider.isLoading).thenReturn(false);
    when(() => reportProvider.getNext(any())).thenAnswer((_) => Future.value(report));
    await presenter.loadData();

    //when
    var stockValue = presenter.getTotalStockValue();

    //then
    expect(stockValue.label, "Stock Value (USD)");
    expect(stockValue.value, "12,300");
    expect(stockValue.textColor, AppColors.brightGreen);
    expect(stockValue.backgroundColor, AppColors.lightGreen);
  });

  test("stock item getters", () async {
    var item = MockInventoryStockItem();

    when(() => item.name).thenReturn("some name");
    expect(presenter.getTitle(item), "some name");

    //quantity
    when(() => item.isStockZero()).thenReturn(true);
    when(() => item.totalQuantity).thenReturn("0");
    var zeroQuantity = presenter.getTotalQuantity(item);
    expect(zeroQuantity.label, "");
    expect(zeroQuantity.value, "0");
    expect(zeroQuantity.textColor, AppColors.yellow);
    expect(zeroQuantity.backgroundColor, Colors.white);

    when(() => item.isStockZero()).thenReturn(false);
    when(() => item.isStockNegative()).thenReturn(true);
    when(() => item.totalQuantity).thenReturn("-10");
    var negativeQuantity = presenter.getTotalQuantity(item);
    expect(negativeQuantity.label, "");
    expect(negativeQuantity.value, "-10");
    expect(negativeQuantity.textColor, AppColors.red);
    expect(negativeQuantity.backgroundColor, Colors.white);

    when(() => item.isStockZero()).thenReturn(false);
    when(() => item.isStockNegative()).thenReturn(false);
    when(() => item.totalQuantity).thenReturn("20");
    var positiveQuantity = presenter.getTotalQuantity(item);
    expect(positiveQuantity.label, "");
    expect(positiveQuantity.value, "20");
    expect(positiveQuantity.textColor, AppColors.green);
    expect(positiveQuantity.backgroundColor, Colors.white);

    //value
    when(() => item.isStockZero()).thenReturn(true);
    when(() => item.totalValue).thenReturn("0");
    var zeroQuantityTotalValue = presenter.getTotalValue(item);
    expect(zeroQuantityTotalValue.label, "");
    expect(zeroQuantityTotalValue.value, "0");
    expect(zeroQuantityTotalValue.textColor, AppColors.yellow);
    expect(zeroQuantityTotalValue.backgroundColor, Colors.white);

    when(() => item.isStockZero()).thenReturn(false);
    when(() => item.isStockNegative()).thenReturn(true);
    when(() => item.totalValue).thenReturn("-111");
    var negativeQuantityTotalValue = presenter.getTotalValue(item);
    expect(negativeQuantityTotalValue.label, "");
    expect(negativeQuantityTotalValue.value, "-111");
    expect(negativeQuantityTotalValue.textColor, AppColors.red);
    expect(negativeQuantityTotalValue.backgroundColor, Colors.white);

    when(() => item.isStockZero()).thenReturn(false);
    when(() => item.isStockNegative()).thenReturn(false);
    when(() => item.totalValue).thenReturn("222");
    var positiveQuantityTotalValue = presenter.getTotalValue(item);
    expect(positiveQuantityTotalValue.label, "");
    expect(positiveQuantityTotalValue.value, "222");
    expect(positiveQuantityTotalValue.textColor, AppColors.green);
    expect(positiveQuantityTotalValue.backgroundColor, Colors.white);
  });

  //MARK: Tests for getters

  test("get company name", () {
    expect(presenter.getCompanyName(), "Some company name");
  });

  test("no items message", () {
    expect(
        presenter.noItemsMessage,
        "There are no inventory stock items to show.\n\n"
        "Try changing the filters or tap here to reload.");
  });

  test("get copy of filters", () {
    var filtersCopy1 = presenter.copyOfCurrentFilters;
    var filtersCopy2 = presenter.copyOfCurrentFilters;

    expect(filtersCopy1 == filtersCopy2, false);
  });
}

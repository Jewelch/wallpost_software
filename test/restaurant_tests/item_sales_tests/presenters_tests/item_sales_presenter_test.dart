import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/services/item_sales_provider.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/presenter/item_sales_presenter.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/view_contracts/item_sales_view.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../../mocks.dart';

class MockItemSalesDataProvider extends Mock implements ItemSalesProvider {}

class MockItemSalesView extends Mock implements ItemSalesView {}

void main() {
  var itemSalesDataProvider = MockItemSalesDataProvider();
  var view = MockItemSalesView();
  late ItemSalesPresenter presenter;
  var dateFilter = DateRangeFilters();

  void _initializePresenter() {
    presenter = ItemSalesPresenter.initWith(
      view,
      MockCompanyProvider(),
      itemSalesDataProvider,
    );
  }

  _initializePresenter();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(itemSalesDataProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(itemSalesDataProvider);
  }

  void _verifyInOrderAndShowData() {
    verifyInOrder([
      () => itemSalesDataProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesDataProvider.getItemSales(),
      () => view.updateItemSalesData(),
      () => view.showItemSalesBreakDowns(),
    ]);
  }

  void _verifyInOrderAndShowNoDataMessage() {
    verifyInOrder([
      () => itemSalesDataProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesDataProvider.getItemSales(),
      () => view.updateItemSalesData(),
      () => view.showNoItemSalesBreakdownMessage(),
    ]);
  }

  setUpAll(() {
    registerFallbackValue(SalesItemWiseOptions.CategoriesAndItems);
  });

  test('presenter returns Item Sales Data when item sales data is initialized', () async {
    //given
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    expect(presenter.getTotalCategories(), itemSalesData.totalCategories.toString());
    expect(
        presenter.getTotalOfAllItemsQuantity(), itemSalesData.totalOfAllItemsQuantities.toString());
    _clearInteractionsOnAllMocks();
  });

  test(
      "presenter returns 0.0 or empty string for item sales data when item sales data is uninitialized yet",
      () {
    _initializePresenter();

    // Top card
    expect(presenter.getTotalOfAllItemsQuantity(), "0");
    expect(presenter.getTotalRevenue(), "0.00");

    // Category wise
    expect(presenter.getCategoryNameAtIndex(0), "");
    expect(presenter.getCategoryTotalToDisplayRevenueAtIndex(0), "0");
    expect(presenter.getCategoryTotalQtyAtIndex(0), "0");
    expect(presenter.getTotalCategories(), "0");
    expect(presenter.getCategoryCardHeader(), "Categories(0)");

    // Item wise
    expect(presenter.getItemNameAtIndex(0), "");
    expect(presenter.getItemQtyAtIndex(0), "0");
    expect(presenter.getItemsListLength(), 0);
    expect(presenter.getItemCardHeader(), "Items(0)");

    _clearInteractionsOnAllMocks();
  });
  test('loading item sales data when sales data provider is loading does nothing', () async {
    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadItemSalesData();

    //then
    verify(() => itemSalesDataProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load item sales data', () async {
    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales())
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadItemSalesData();

    verifyInOrder([
      () => itemSalesDataProvider.isLoading,
      () => view.showLoader(),
      () => itemSalesDataProvider.getItemSales(),
      () => view.showErrorMessage(
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('showing message item sales data break down is empty', () async {
    //given
    var itemSalesData = MockItemSalesData();
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowNoDataMessage();

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getTotalRevenue() returns the item sales total revenue', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    // //then
    _verifyInOrderAndShowData();

    expect(presenter.getTotalRevenue(), itemSalesData.totalRevenue.toString());

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getTotalOfAllItemsQuantity() returns the item sales total of all items quantity', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    ///then
    _verifyInOrderAndShowData();

    expect(
        presenter.getTotalOfAllItemsQuantity(), itemSalesData.totalOfAllItemsQuantities.toString());

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getTotalOfAllItemsQuantity() returns 0 when the total of all items quantity is null',
      () async {
    var itemSalesData = MockItemSalesData();

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowNoDataMessage();

    expect(presenter.getTotalOfAllItemsQuantity(), "0");

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getTotalCategories() returns the item sales total categories', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    expect(presenter.getTotalCategories(), itemSalesData.totalCategories.toString());

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getCategoryCardHeader() returns the categories card header', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    expect(presenter.getCategoryCardHeader(),
        "Categories(${itemSalesData.totalCategories.toString()})");

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getItemCardHeader() returns the item card header', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    expect(presenter.getItemCardHeader(), "Items(${presenter.getItemsListLength().toString()})");

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getDataListLength() returns the length of the breakdown list', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    expect(presenter.getDataListLength(), itemSalesData.breakdown?.length);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getTotalRevenue() returns "0.00" if revenue is null', () async {
    var itemSalesData = MockItemSalesData();
    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowNoDataMessage();

    expect(presenter.getTotalRevenue(), "0.00");

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getCategoryNameAtIndex() returns category name at index', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    for (var i = 0; i < itemSalesData.breakdown!.length; i++) {
      final currentItem = itemSalesData.breakdown?[i];

      expect(presenter.getCategoryNameAtIndex(i), currentItem?.categoryName);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test(
      'getCategoryTotalToDisplayRevenueAtIndex() returns category total to display revenue at index',
      () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    for (var i = 0; i < itemSalesData.breakdown!.length; i++) {
      final currentItem = itemSalesData.breakdown?[i];

      expect(
          presenter.getCategoryTotalToDisplayRevenueAtIndex(i), currentItem?.totalRevenueToDisplay);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getCategoryQtyAtIndex() returns category total quantity at index', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    for (var i = 0; i < itemSalesData.breakdown!.length; i++) {
      final currentItem = itemSalesData.breakdown?[i];

      expect(presenter.getCategoryTotalQtyAtIndex(i), currentItem?.totalQuantity.toString());
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getItemNameAtIndex() returns item name at index', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;
    for (var i = 0; i < itemsList!.length; i++) {
      final currentItem = itemsList[i];

      expect(presenter.getItemNameAtIndex(i), currentItem.itemName);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getItemQtyAtIndex() returns item quantity at index', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;
    for (var i = 0; i < itemsList!.length; i++) {
      final currentItem = itemsList[i];

      expect(presenter.getItemQtyAtIndex(i), currentItem.qty.toString());
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getItemRevenueToDisplayAtIndex() returns item revenue to display at index', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;
    for (var i = 0; i < itemsList!.length; i++) {
      final currentItem = itemsList[i];

      expect(presenter.getItemRevenueToDisplayAtIndex(i), currentItem.revenueToDisplay);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getItemsListLength() returns items list length', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;

    expect(presenter.getItemsListLength(), itemsList?.length);

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getItemNameOfSpecificItem() returns name of specific item', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;
    for (var i = 0; i < itemsList!.length; i++) {
      final currentItem = itemsList[i];

      expect(presenter.getNameOfSpecificItem(currentItem), currentItem.itemName);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getQtyOfSpecificItem() returns quantity of specific item', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;
    for (var i = 0; i < itemsList!.length; i++) {
      final currentItem = itemsList[i];

      expect(presenter.getQtyOfSpecificItem(currentItem), currentItem.qty.toString());
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('getRevenueToDisplayOfSpecificItem() returns revenue to display of specific item', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    presenter.getItemsList();

    //then
    _verifyInOrderAndShowData();

    var itemsList = presenter.itemslist;
    for (var i = 0; i < itemsList!.length; i++) {
      final currentItem = itemsList[i];

      expect(
          presenter.getRevenueToDisplayOfSpecificItem(currentItem), currentItem.revenueToDisplay);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getCategoryNameHeaderCard() returns category name card header', () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    var itemSalesBreakDown = presenter.itemSalesData?.breakdown;
    for (var i = 0; i < itemSalesBreakDown!.length; i++) {
      final currentItem = itemSalesBreakDown[i];

      expect(presenter.getCategoryNameCardHeader(currentItem), currentItem.categoryName);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getBreakDownRevenueForCategory() returns break down revenue for category to display',
      () async {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    //given
    when(() => itemSalesDataProvider.isLoading).thenReturn(false);
    when(() => itemSalesDataProvider.getItemSales()).thenAnswer((_) => Future.value(itemSalesData));

    //when
    await presenter.loadItemSalesData();

    //then
    _verifyInOrderAndShowData();

    var itemSalesBreakDown = presenter.itemSalesData?.breakdown;
    for (var i = 0; i < itemSalesBreakDown!.length; i++) {
      final currentItem = itemSalesBreakDown[i];

      expect(
          presenter.getBreakDownRevenueForCategory(currentItem), currentItem.totalRevenueToDisplay);
    }

    _verifyNoMoreInteractionsOnAllMocks();
  });
}

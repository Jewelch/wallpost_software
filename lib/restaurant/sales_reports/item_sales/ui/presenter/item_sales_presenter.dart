import 'package:flutter/foundation.dart';

import '../../../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/item_sales_model.dart';
import '../../entities/sales_item_view_options.dart';
import '../../services/item_sales_provider.dart';
import '../view_contracts/item_sales_view.dart';

class ItemSalesPresenter {
  ItemSalesView _view;
  SelectedCompanyProvider _selectedCompanyProvider;
  ItemSalesProvider _itemSalesDataProvider;
  ItemSalesDataModel? itemSalesData;

  ItemSalesPresenter(this._view)
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _itemSalesDataProvider = ItemSalesProvider();

  SalesItemWiseOptions salesItemWiseOption = SalesItemWiseOptions.CategoriesAndItems;
  final DateRangeFilters _dateRangeFilters = DateRangeFilters();

  ItemSalesPresenter.initWith(
    this._view,
    this._selectedCompanyProvider,
    this._itemSalesDataProvider,
  );

  final List<String> filterTypeList = [
    "Sort by: Descend",
    "Date: 2022-12-31",
    "View: Category & Items",
  ];

  var index = 0;
  void nextWise() {
    index = index == 2 ? 0 : index += 1;
    debugPrint(index.toString());
    salesItemWiseOption = SalesItemWiseOptions.values[index];
    _view.onDidChangeSalesItemWise();
  }

  loadItemSalesData() async {
    // _dateRangeFilters = '2022-8-1';
    //_salesItemWiseOption = SalesItemWiseOptions.viewAsCategory;

    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      itemSalesData = await _itemSalesDataProvider.getItemSales(); // _dateRangeFilters

      _view.updateItemSalesData();
      itemSalesData?.breakdown != null
          ? _view.showItemSalesBreakDowns()
          : _view.showNoItemSalesBreakdownMessage();
      getItemsList();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}" + "\n\nTap here to reload.");
    }
  }

  //MARK: Function to initiate filter selection

  void onFiltersGotClicked() {
    _view.showSalesReportFilter();
  }

  //MARK: Functions to apply sales breakdown type filter

  void selectItemSalesBreakDownWiseAtIndex(int index) {
    salesItemWiseOption = SalesItemWiseOptions.values[index];
    getItemsList();
    _view.onDidChangeSalesItemWise();
  }

  //MARK: Functions retruns the list of items sales
  List<ItemSales>? itemslist;
  void getItemsList() {
    itemslist = [];
    itemSalesData?.breakdown
        ?.forEach((element) => element.items?.forEach((item) => itemslist?.add(item)));
  }

  // Getters

  String getSelectedCompanyName() =>
      _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;
  String getFilterType(int index) => filterTypeList[index];

  //? Top card getters
  String getTotalRevenue() => itemSalesData?.totalRevenue?.toString() ?? "0.00";
  String getTotalOfAllItemsQuantity() =>
      itemSalesData?.totalOfAllItemsQuantities?.toString() ?? "0";

  // Category wise
  String getCategoryNameAtIndex(int index) => itemSalesData?.breakdown?[index].categoryName ?? "";
  String getCategoryTotalToDisplayRevenueAtIndex(int index) =>
      itemSalesData?.breakdown?[index].totalRevenueToDisplay.toString() ?? "0";
  String getCategoryTotalQtyAtIndex(int index) =>
      itemSalesData?.breakdown?[index].totalQuantity.toString() ?? "0";
  String getTotalCategories() => itemSalesData?.totalCategories.toString() ?? "0";
  String getCategoryCardHeader() =>
      "Categories(${itemSalesData?.totalCategories.toString() ?? "0"})";

  // Item wise
  String getItemNameAtIndex(int index) => itemslist?[index].itemName ?? "";
  String getItemQtyAtIndex(int index) => itemslist?[index].qty?.toString() ?? "0";
  String getItemRevenueToDisplayAtIndex(int index) =>
      itemslist?[index].revenueToDisplay?.toString() ?? "0";
  int getItemsListLength() => itemslist?.length ?? 0;
  String getItemCardHeader() => "Items(${getItemsListLength().toString()})";

// Item and Category wise
  String getNameOfSpecificItem(ItemSales? item) => item?.itemName ?? "";
  String getQtyOfSpecificItem(ItemSales? item) => item?.qty?.toString() ?? "";
  String getRevenueToDisplayOfSpecificItem(ItemSales? item) =>
      item?.revenueToDisplay?.toString() ?? "";
  String getCategoryNameCardHeader(ItemSalesBreakdown breakDown) => breakDown.categoryName ?? "";
  String getBreakDownRevenueForCategory(ItemSalesBreakdown breakDown) =>
      breakDown.totalRevenueToDisplay ?? "0";

  void toggleCategoryExpansionStatusAtIndex(int index) =>
      itemSalesData?.breakdown?[index].isExpanded =
          !(itemSalesData?.breakdown?[index].isExpanded ?? false);
  List<ItemSalesBreakdown> getItemSalesBreakDownList() => itemSalesData?.breakdown ?? [];

  int getDataListLength() => itemSalesData?.breakdown?.length ?? 0;
}

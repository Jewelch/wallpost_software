import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/item_sales_model.dart';
import '../../entities/item_sales_report_filters.dart';
import '../../services/item_sales_provider.dart';
import '../../utils/item_sales_sorter.dart';
import '../view_contracts/item_sales_view.dart';

class ItemSalesPresenter {
  ItemSalesView _view;
  ItemSalesProvider _itemSalesDataProvider;
  ItemSalesDataModel? itemSalesData;
  ItemSalesSorter _itemSalesSorter;
  SelectedCompanyProvider _selectedCompanyProvider;

  ItemSalesPresenter(this._view)
      : _itemSalesDataProvider = ItemSalesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        _itemSalesSorter = ItemSalesSorter();

  ItemSalesReportFilters filters = ItemSalesReportFilters();

  ItemSalesPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._itemSalesSorter,
    this._selectedCompanyProvider,
  );

  var index = 0;

  loadItemSalesData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      var dateFilters = filters.dateRangeFilters;
      itemSalesData = await _itemSalesDataProvider.getItemSales(dateFilters); // _dateRangeFilters

      _view.updateItemSalesData();
      itemSalesData?.breakdown != null ? _view.showItemSalesBreakDowns() : _view.showNoItemSalesBreakdownMessage();
      getItemsList();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}" + "\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters

  Future applyFilters(ItemSalesReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    if (newFilters.dateRangeFilters != oldFilter.dateRangeFilters) {
      await loadItemSalesData();
    }
    if (newFilters.sortOptions != oldFilter.sortOptions) {
      itemSalesData = _itemSalesSorter.sortBreakDowns(itemSalesData!, filters.sortOptions);
      itemslist = _itemSalesSorter.sortAllBreakDownItems(itemSalesData!, filters.sortOptions);
      _view.onDidChangeFilters();
    }
    if (newFilters.salesItemWiseOptions != oldFilter.salesItemWiseOptions) {
      _view.onDidChangeFilters();
    }
  }

  void onFiltersGotClicked() {
    _view.showSalesReportFilter();
  }

  //MARK: Functions retruns the list of items sales
  List<ItemSales>? itemslist;

  void getItemsList() {
    itemslist = [];
    itemSalesData?.breakdown?.forEach((element) => element.items?.forEach((item) => itemslist?.add(item)));
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  //? Top card getters
  String getTotalRevenue() => itemSalesData?.totalRevenue?.toString() ?? "0.00";

  String getTotalOfAllItemsQuantity() => itemSalesData?.totalOfAllItemsQuantities?.toString() ?? "0";

  // Category wise
  String getCategoryNameAtIndex(int index) => itemSalesData?.breakdown?[index].categoryName ?? "";

  String getCategoryTotalToDisplayRevenueAtIndex(int index) =>
      itemSalesData?.breakdown?[index].totalRevenueToDisplay.toString() ?? "0";

  String getCategoryTotalQtyAtIndex(int index) => itemSalesData?.breakdown?[index].totalQuantity.toString() ?? "0";

  String getTotalCategories() => itemSalesData?.totalCategories.toString() ?? "0";

  String getCategoryCardHeader() => "Categories(${itemSalesData?.totalCategories.toString() ?? "0"})";

  // Item wise
  String getItemNameAtIndex(int index) => itemslist?[index].itemName ?? "";

  String getItemQtyAtIndex(int index) => itemslist?[index].qty?.toString() ?? "0";

  String getItemRevenueToDisplayAtIndex(int index) => itemslist?[index].revenueToDisplay?.toString() ?? "0";

  int getItemsListLength() => itemslist?.length ?? 0;

  String getItemCardHeader() => "Items(${getItemsListLength().toString()})";

// Item and Category wise
  String getNameOfSpecificItem(ItemSales? item) => item?.itemName ?? "";

  String getQtyOfSpecificItem(ItemSales? item) => item?.qty?.toString() ?? "";

  String getRevenueToDisplayOfSpecificItem(ItemSales? item) => item?.revenueToDisplay?.toString() ?? "";

  String getCategoryNameCardHeader(ItemSalesBreakdown breakDown) => breakDown.categoryName ?? "";

  String getBreakDownRevenueForCategory(ItemSalesBreakdown breakDown) => breakDown.totalRevenueToDisplay ?? "0";

  void toggleCategoryExpansionStatusAtIndex(int index) =>
      itemSalesData?.breakdown?[index].isExpanded = !(itemSalesData?.breakdown?[index].isExpanded ?? false);

  List<ItemSalesBreakdown> getItemSalesBreakDownList() => itemSalesData?.breakdown ?? []; // ١

  int getDataListLength() => itemSalesData?.breakdown?.length ?? 0;
}

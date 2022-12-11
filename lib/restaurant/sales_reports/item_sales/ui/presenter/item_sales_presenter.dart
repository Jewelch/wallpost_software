import '../../../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/sales_item_view_options.dart';
import '../../services/item_sales_provider.dart';
import '../view_contracts/item_sales_view.dart';

class ItemSalesPresenter {
  ItemSalesView _view;
  SelectedCompanyProvider _selectedCompanyProvider;
  ItemSalesProvider _itemSalesDataProvider;
  ItemSalesPresenter(this._view)
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _itemSalesDataProvider = ItemSalesProvider();

  dynamic itemSalesData;

  SalesItemWiseOptions _salesItemWiseOption = SalesItemWiseOptions.viewAsCategory;
  DateRangeFilters _dateRangeFilters = DateRangeFilters();

  ItemSalesPresenter.initWith(
    this._view,
    this._selectedCompanyProvider,
    this._itemSalesDataProvider,
  );

  List<String> filterTypeList = [
    "Sort by:",
    "Date:",
    "View:",
  ];

  loadItemSalesData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      itemSalesData =
          await _itemSalesDataProvider.getItemSales(_dateRangeFilters, _salesItemWiseOption);

      _view.updateSalesItemData();
      itemSalesData.isNotEmpty ? _view.showSalesBreakDowns() : _view.showNoSalesBreakdownMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}" + "\n\nTap here to reload.");
    }
  }

  //MARK: Function to initiate filter selection

  void onFiltersGotClicked() {
    _view.showSalesReportFilter();
  }

  //MARK: Functions to apply sales breakdown type filter

  void selectSalesBreakDownWiseAtIndex(int index) {
    _salesItemWiseOption = SalesItemWiseOptions.values[index];
    _view.onDidChangeSalesItemWise();
  }

  // Getters

  String getSelectedCompanyName() =>
      _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;
  String getFilterType(int index) => filterTypeList[index];
  String getCategoryNameAtIndex(int index) => itemSalesData?[index].categoryName ?? "0.00";
  num getCategoryRevenueAtIndex(int index) => itemSalesData?[index].totalRevenue ?? 0;
  num getCategoryQtyAtIndex(int index) => itemSalesData?[index].totalQuantity ?? 0;
  String getTotalRevenue(int index) => itemSalesData?[index].totalRevenue.toString() ?? "0.00";
  String getTotalQuantity() => '0';
  String getQty(int index) => "0";
  String getRevenue(int index) => "0";
  String getSumRevenue() => '0';
  // int getCategoryWiseListLength() => _salesData?.categories?.length ?? 0;
  // String getCategoryName(int index) => _salesData?.categories?[index].categoryName ?? '';
}
